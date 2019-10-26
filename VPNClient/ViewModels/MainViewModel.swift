//
//  MainViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//

import Foundation
import TunnelKit
import CoreData
import NetworkExtension
import Alamofire

protocol MainView: class {
    var username: String? { get set }
    var password: String? { get set }
    func statusUpdated(newStatus status: NEVPNStatus)
    func serverListUpdated()
    func showError(description: String)
    func serversLoadingIndicator(show: Bool)
}

class MainViewModel: NSObject {
    weak var view: MainView?
    private(set) var selectedServer: ServerEntity?
    var serversType: ServerType = .shared {
        didSet {
            selectedServer = nil
            fetchServers()
        }
    }
    
    var serverIP: String? {
        return vpnService.currentProtocolConfiguration?.serverAddress
    }
    
    private func getPortAndProtocol(from providerConfiguration: [String : Any]?) -> (port: UInt16, protocol: SocketType)? {
        if let tuple = (providerConfiguration?["EndpointProtocols"] as? [String])?.first {
            let arr = String(describing: tuple).split(separator: ":")
            guard let p = arr.last, let port = UInt16(p), let type = arr.first else {
                return nil
            }
            return (port: port, protocol: type == "TCP" ? .tcp : .udp)
        }
       return nil
    }
    
    var socketType: SocketType? {
        let proto = getPortAndProtocol(from: vpnService.currentProtocolConfiguration?.providerConfiguration)?.protocol
        return proto ?? vpnService.configuration?.socketType
    }
    
    var port: UInt16? {
        let port = getPortAndProtocol(from: vpnService.currentProtocolConfiguration?.providerConfiguration)?.port
        return port ?? vpnService.configuration?.port
    }
    
    private var savedCredentialsInKeychain: (username: String, password: String)? {
        get {
            let keychain = Keychain(group: OpenVPNConstants.appGroup)
            let passwordKey = OpenVPNConstants.keychainPasswordKey
            let usernameKey = OpenVPNConstants.keychainUsernameKey
            
            guard let passwordReference = try? keychain.passwordReference(for: passwordKey) else {
                print("Couldn't get password reference")
                return nil
            }
            guard let fetchedPassword = try? Keychain.password(for: passwordKey, reference: passwordReference) else {
                print("Couldn't fetch password")
                return nil
            }
            
            guard let usernameReference = try? keychain.passwordReference(for: usernameKey) else {
                print("Couldn't get username reference")
                return nil
            }
            guard let fetchedUsername = try? Keychain.password(for: usernameKey, reference: usernameReference) else {
                print("Couldn't fetch username")
                return nil
            }
            return (username: fetchedUsername, password: fetchedPassword)
        }
        set {
            let keychain = Keychain(group: OpenVPNConstants.appGroup)
            let passwordKey = OpenVPNConstants.keychainPasswordKey
            let usernameKey = OpenVPNConstants.keychainUsernameKey
            
            if let creds = newValue {
                guard let _ = try? keychain.set(password: creds.username, for: usernameKey) else {
                    print("Couldn't set username")
                    return
                }
                guard let _ = try? keychain.set(password: creds.password, for: passwordKey) else {
                    print("Couldn't set password")
                    return
                }
            } else {
                keychain.removePassword(for: usernameKey)
                keychain.removePassword(for: passwordKey)
            }
        }
    }
    
    var storeCredentials: Bool {
        get {
            return savedCredentialsInKeychain != nil
        }
        set {
            let pass = newValue ? view?.password : nil
            let username = newValue ? view?.username : nil
            if let username = username, let password = pass {
                savedCredentialsInKeychain = (username: username, password: password)
            } else {
                savedCredentialsInKeychain = nil
            }
        }
    }
    
    private var vpnService: VPNService
    private let api: RestAPI
    private let coreDataStack: CoreDataStack
    private(set) lazy var serverListController: NSFetchedResultsController<ServerEntity> = {
        let request = NSFetchRequest<ServerEntity>(entityName: "ServerEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "type", ascending: false), NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = getFetchServersPredicate()
        let controller = NSFetchedResultsController<ServerEntity>(fetchRequest: request, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    init(vpnService: VPNService = OpenVPNService.shared, coreDataStack: CoreDataStack = CoreDataStack.shared, api: RestAPI = RestAPI.shared) {
        self.vpnService = vpnService
        self.coreDataStack = coreDataStack
        self.api = api
        super.init()
        self.vpnService.delegate = self
        tryToRestoreLastSelectedServer()
    }
    
    private func getFetchServersPredicate() -> NSPredicate {
        return NSPredicate(format: "type == %@", serversType.rawValue)
    }
    
    func isConnected(toServer server: ServerEntity) -> Bool {
        return vpnService.currentProtocolConfiguration?.serverAddress == server.address && (vpnService.status != .disconnected && vpnService.status != .invalid)
    }
    
    func viewDidLoad() {
        fetchServers()
        updateServersIfNeeded()
        view?.username = savedCredentialsInKeychain?.username
        view?.password = savedCredentialsInKeychain?.password
        setupSettingsObservers()
    }
    
    func updateServersIfNeeded(forceReload: Bool = false) {
        let localServersCount = serverListController.fetchedObjects?.count ?? 0
        view?.serversLoadingIndicator(show: true)
        api.getServersVersion { [weak self] (result) in
            guard let `self` = self else { return }
            let sVersion = result.value?.servers
            if let lastServersVersion = UserDefaults.lastServersVersion, let sVersion = sVersion, let currentServerVersion = Int(sVersion), let currentClientVersion = Int(lastServersVersion), currentClientVersion == currentServerVersion, localServersCount > 0, !forceReload {
                print("Servers are actual")
                self.view?.serversLoadingIndicator(show: false)
            } else {
                print("Servers are not actual, updating...")
                self.api.getServerList { (result) in
                    switch result {
                    case .success(let servers):
                        ServerEntity.update(withDtos: servers, in: self.coreDataStack.context) {
                            self.coreDataStack.saveContext()
                            self.fetchServers()
                            UserDefaults.lastServersVersion = sVersion
                        }
                    case .failure(let error):
                        self.view?.showError(description: "Error occurred during update")
                    }
                    self.view?.serversLoadingIndicator(show: false)
                }
            }
        }
    }
    
    private func setupSettingsObservers() {
         NotificationCenter.default.addObserver(self, selector: #selector(settingsUpdated), name: VPNSettings.settingsChangedNotification, object: nil)
    }
    
    @objc func settingsUpdated() {
        vpnService.disconnect()
    }
    
    func fetchServers() {
        serverListController.fetchRequest.predicate = getFetchServersPredicate()
        try? serverListController.performFetch()
        view?.serverListUpdated()
    }
    
    private func tryToRestoreLastSelectedServer() {
        if let ip = UserDefaults.selectedServerIP, let server = ServerEntity.find(byIP: ip, in: coreDataStack.context) {
            selectedServer = server
        } else {
            print("server not restored")
        }
    }
    
    func select(server: ServerEntity) {
        selectedServer = server
    }
    
    func connectTouched() {
        switch vpnService.status {
        case .invalid, .disconnected:
            let port = Int(UserDefaults.portSetting ?? String(VPNSettings.defaultSettings.port)) ?? VPNSettings.defaultSettings.port
            let type = UserDefaults.socketTypeSetting ?? VPNSettings.defaultSettings.socketType
            guard let server = selectedServer else {
                view?.showError(description: "Please select server from the list")
                print("please select server from list")
                return;
            }
            
            if let username = view?.username, let password = view?.password {
                if username == "" {
                    view?.showError(description: "Please input username")
                    return
                }
                if password == "" {
                    view?.showError(description: "Please input password")
                    return
                }
                let credentials = OpenVPN.Credentials(username, password)
                let onDemandRuleConnect = UserDefaults.reconnectOnNetworkChangeSetting
                let dnsServers = server.dns == nil ? nil : [server.dns!]
                vpnService.configure(settings: (hostname: server.address!, port: UInt16(port), dnsServers: dnsServers, socketType: type, credentials: credentials, onDemandRuleConnect: onDemandRuleConnect))
                vpnService.connectionClicked()
            }
        case .connected, .connecting:
            vpnService.connectionClicked()
        default:
            break
        }
        
    }
    
    private func save(credentials: OpenVPN.Credentials?) {
        
    }
    
}

extension MainViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        view?.serverListUpdated()
    }
}

extension MainViewModel: VPNServiceDelegate {
    func raised(error: VPNError) {
        switch error {
        case .error(let desc):
            DispatchQueue.main.async {
                self.view?.showError(description: desc)
            }
        }
        
    }
    
    func statusUpdated(newStatus status: NEVPNStatus) {
        view?.statusUpdated(newStatus: status)
    }
}

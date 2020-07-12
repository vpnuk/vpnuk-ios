//
//  CustomConnectionDataViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import TunnelKit

protocol CustomConnectViewModelProtocol: VPNCredentialsProvider {
    var credentialsIsStoring: Bool { get }
    func storeCredentials(_ store: Bool)
}

class CustomConnectViewModel {
    weak var view: CustomConnectViewProtocol? {
        didSet {
            viewLoaded()
        }
    }
    
    private var connectedServerData: ConnectionData? {
        if connectorDelegate?.connectionStatus == .connected {
            return connectorDelegate?.connectedServerData
        } else {
            return nil
        }
    }
    
    private let router: MainScreenRouterProtocol
    
    private let credentialsStorage: CredentialsStorage
    private var connectionStateStorage: CustomConnectionStateStorage
    var credentialsChangedListener: ((UsernamePasswordCredentials) -> ())?
    private let serversRepository: ServersRepository
    private weak var connectorDelegate: VPNConnectorDelegate?
    
    
    init(
        router: MainScreenRouterProtocol,
        customCredentialsStorage: CredentialsStorage,
        connectionStateStorage: CustomConnectionStateStorage,
        serversRepository: ServersRepository,
        connectorDelegate: VPNConnectorDelegate
    ) {
        self.credentialsStorage = customCredentialsStorage
        self.router = router
        self.connectionStateStorage = connectionStateStorage
        self.serversRepository = serversRepository
        self.connectorDelegate = connectorDelegate
    }
    
    private func viewLoaded() {
        updateServerPicker()
        connectorDelegate?.connectPressedAction = { [weak self] in
            self?.connectTouched()
        }
        connectorDelegate?.connectionStatusUpdatedAction = { [weak self] _ in
            self?.updateServerPicker()
        }
    }
    
    private func updateServerPicker() {
        let state: ServerPickerView.State = selectedServer.map { server in
            let isConnectedToSelected = connectedServerData?.serverIP == server.address
            return .picked(server: server, isConnected: isConnectedToSelected)
        } ?? .notPicked
        
        view?.updateServerPicker(
            state: state,
            action: { [weak self] in
                guard let self = self else { return }
                let viewModel = self.buildServerPickerViewModel()
                self.router.presentServersPicker(viewModel: viewModel)
            }
        )
    }
}

// MARK: - Connecting to server

extension CustomConnectViewModel {
    
    private var selectedServer: ServerEntity? {
        if let ip = connectionStateStorage.customConnectionState?.selectedServerIp {
            return serversRepository.getServer(byIp: ip)
        }
        return nil
    }
    
    func connectTouched() {
        let port = Int(UserDefaults.portSetting ?? String(VPNSettings.defaultSettings.port)) ?? VPNSettings.defaultSettings.port
        let type = UserDefaults.socketTypeSetting ?? VPNSettings.defaultSettings.socketType
        guard let server = selectedServer else {
            router.presentAlert(message: "Please select server from the list")
            return
        }
        
        if let username = view?.username, let password = view?.password {
            if username == "" {
                router.presentAlert(message: "Please input username")
                return
            }
            if password == "" {
                router.presentAlert(message: "Please input password")
                return
            }
            let credentials = OpenVPN.Credentials(username, password)
            let onDemandRuleConnect = UserDefaults.reconnectOnNetworkChangeSetting
            let dnsServers = server.dns == nil ? nil : [server.dns!]
            
            let connectionSettings = ConnectionSettings(
                hostname: server.address!,
                port: UInt16(port),
                dnsServers: dnsServers,
                socketType: type,
                credentials: credentials,
                onDemandRuleConnect: onDemandRuleConnect
            )
            connectorDelegate?.connect(withSettings: connectionSettings)
            
        }
    }
}

// MARK: - Build data for server picker

extension CustomConnectViewModel {
    
    private func buildServerPickerViewModel() -> ServerPickerListViewModelProtocol {
//        let connectionState = connectionStateStorage.customConnectionState
        let allServers = getAllServers()
        var connectedServerPosition: ServerTablePosition? = nil
        if let connectedIp = connectedServerData?.serverIP {
            connectedServerPosition = getServerPosition(forServerIp: connectedIp, inServers: allServers)
        }
        
        var selectedServerPosition: ServerTablePosition? = nil
        if let selectedIp = connectionStateStorage.customConnectionState?.selectedServerIp {
            selectedServerPosition = getServerPosition(forServerIp: selectedIp, inServers: allServers)
        }
        
        let viewModel = ServerPickerListViewModel(
            initiallySelectedPosition: selectedServerPosition ?? ServerTablePosition(type: .shared, index: 0),
            servers: getAllServers(),
            connectedServerPosition: connectedServerPosition,
            selectServerAtAction: { [weak self] position in
                let server = allServers[position.type]?[position.index]
                self?.connectionStateStorage.customConnectionState = .init(selectedServerIp: server?.address)
                self?.updateServerPicker()
            }
        )
        
        return viewModel
    }
    
    private func getServerPosition(
        forServerIp ip: String,
        inServers servers: [ServerType : [ServerEntity]]
    ) -> ServerTablePosition? {
        for type in servers.keys {
            let indexOfLastServer = servers[type]?
                .enumerated()
                .first(where: { index, server in server.address == ip })
                .map { $0.offset }
            
            if let indexOfLastServer = indexOfLastServer {
                return ServerTablePosition(type: type, index: indexOfLastServer)
            }
        }
        return nil
    }
    
    private func getAllServers() -> [ServerType : [ServerEntity]] {
        var result = [ServerType : [ServerEntity]]()
        for type in ServerType.allCases {
            let servers = serversRepository.getServers(forTypes: [type])
            if !servers.isEmpty {
                result[type] = servers
            }
        }
        return result
    }
    
}

extension CustomConnectViewModel: CustomConnectViewModelProtocol {
    var credentialsIsStoring: Bool {
        return (try? credentialsStorage.getCredentials()) != nil
    }
    
    func storeCredentials(_ store: Bool) {
        let credentials: UsernamePasswordCredentials?
        if store, let password = view?.password, let username = view?.username {
            credentials = UsernamePasswordCredentials(username: username, password: password)
        } else {
            credentials = nil
        }
        do {
            try credentialsStorage.setCredentials(credentials)
        } catch {
            //TODO: print cannot save
        }
        view?.updateCredentials()
    }
    
    func getCredentials() throws -> UsernamePasswordCredentials? {
        return try credentialsStorage.getCredentials()
    }
}

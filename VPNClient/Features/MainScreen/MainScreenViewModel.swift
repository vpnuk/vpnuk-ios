//
//  MainScreenViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 09.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension

protocol VPNConnectorDelegate: AnyObject {
    typealias ConnectionStatusUpdatedAction = (_ newStatus: NEVPNStatus) -> ()
    var connectPressedAction: Action? { get set }
    var connectionStatusUpdatedAction: ConnectionStatusUpdatedAction? { get set }
    var connectedServerData: ConnectionData? { get }
    func connect(withSettings settings: UserVPNConnectionSettings)
    var connectionStatus: NEVPNStatus { get }

}

enum ConnectScreenType: Int {
    case account = 0
    case custom = 1
}

protocol MainScreenViewModelProtocol {
    func viewLoaded()
    func openSettingsTouched()
    func openSupportTouched()
    func connectTypeChanged(type: ConnectScreenType)
}

class MainScreenViewModel: MainScreenViewModelProtocol {
    private let router: MainScreenRouterProtocol
    weak var view: MainScreenViewProtocol?
    private var vpnService: VPNServiceProtocol
    private let serversRepository: ServersRepository
    private let openVPNConfigurationRepository: OpenVPNConfigurationRepositoryProtocol
    private let serverUpdatesChecker: ServerUpdatesCheckerProtocol
    
    var connectPressedAction: Action?
    var connectionStatusUpdatedAction: ConnectionStatusUpdatedAction?
    
    private var lastConnectScreenType: ConnectScreenType? {
        get {
            let val = UserDefaults.standard.integer(forKey: "lastConnectScreenType")
            return ConnectScreenType(rawValue: val)
        }
        set {
            UserDefaults.standard.set(newValue?.rawValue, forKey: "lastConnectScreenType")
        }
    }
    
    init(
        router: MainScreenRouterProtocol,
        vpnService: VPNServiceProtocol,
        serversRepository: ServersRepository,
        openVPNConfigurationRepository: OpenVPNConfigurationRepositoryProtocol,
        serverUpdatesChecker: ServerUpdatesCheckerProtocol
    ) {
        self.router = router
        self.vpnService = vpnService
        self.serversRepository = serversRepository
        self.openVPNConfigurationRepository = openVPNConfigurationRepository
        self.serverUpdatesChecker = serverUpdatesChecker
    }
    
    func viewLoaded() {
        let lastConnectType = lastConnectScreenType ?? .custom
        connectTypeChanged(type: lastConnectType)
        vpnService.delegate = self
        view?.connectionStatusView.connectButtonAction = { [weak self] in
            self?.connectButtonTouched()
        }
        
        checkVersionsAndUpdateDataIfNeeded()
    }
    
    private func checkVersionsAndUpdateDataIfNeeded() {
        view?.setLoading(true)
        serverUpdatesChecker.checkVersions { [weak self] result in
            self?.view?.setLoading(false)
            
            switch result {
            case .success(let updates):
                if updates.shouldUpdateServerlist {
                    self?.reloadServers { result in
                        switch result {
                        case .success:
                            self?.serverUpdatesChecker.setLastServersVersion(Int(updates.versionsOnServer.servers ?? "") ?? 0)
                        case .failure:
                            self?.view?.presentAlert(message: NSLocalizedString("Servers update error.", comment: ""))
                        }
                    }
                }
                
                if updates.shouldUpdateOVPNFile {
                    self?.reloadOVPNConfiguration { result in
                        switch result {
                        case .success:
                            self?.serverUpdatesChecker.setLastOVPNVersion(Int(updates.versionsOnServer.ovpn ?? "") ?? 0)
                        case .failure:
                            self?.view?.presentAlert(message: NSLocalizedString(".ovpn file update error.", comment: ""))
                        }
                    }
                }
            case .failure:
                self?.view?.presentAlert(message: NSLocalizedString("Server connection error.", comment: ""))
            }
        }
    }
    
    private func reloadOVPNConfiguration(completion: @escaping (Result<Void, Error>) -> Void) {
        view?.setLoading(true)
        openVPNConfigurationRepository.downloadOVPNConfigurationFile { [weak self] result in
            guard let self = self else { return }
            self.view?.setLoading(false)
            switch result {
            case .success(let url):
                self.vpnService.updateWithNewOVPNConfigurationFile(fileURL: url, completion: completion)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func reloadServers(completion: @escaping (Result<Void, Error>) -> Void) {
        view?.setLoading(true)
        serversRepository.updateServers { [weak self] result in
            guard let self = self else { return }
            self.view?.setLoading(false)
            
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func connectTypeChanged(type: ConnectScreenType) {
        switch type {
        case .account:
            router.switchToAccountConnectView(connectorDelegate: self)
        case .custom:
            router.switchToCustomConnectView(connectorDelegate: self)
        }
        lastConnectScreenType = type
        view?.setConnectScreenType(type)
    }
    
    func openSettingsTouched() {
        router.presentSettings()
    }
    
    func openSupportTouched() {
        if let link = URL(string: Constants.supportUrl) {
            UIApplication.shared.open(link)
        }
    }
}

extension MainScreenViewModel: VPNConnectorDelegate {
    var connectionStatus: NEVPNStatus {
        vpnService.status
    }
    
    private func connectButtonTouched() {
        switch vpnService.status {
        case .invalid, .disconnected:
            connectPressedAction?()
        case .connected, .connecting:
            vpnService.toggleConnection()
        default:
            break
        }
    }
    
    var connectedServerData: ConnectionData? {
        return vpnService.currentProtocolConfiguration?.connectionData
    }
    
    func connect(withSettings settings: UserVPNConnectionSettings) {
        switch vpnService.status {
        case .invalid, .disconnected:
            vpnService.configure(settings: settings)
            vpnService.toggleConnection()
        case .connected, .connecting:
            vpnService.toggleConnection()
        default:
            break
        }
    }
}

extension ConnectionStatusView.ConnectionDetails {
    init(connectionData: ConnectionData?) {
        guard let connectionData = connectionData else {
            ip = nil
            port = nil
            socketType = nil
            return
        }
        ip = connectionData.serverIP
        port = connectionData.port
        socketType = connectionData.socketType.rawValue
    }
}

extension MainScreenViewModel: VPNServiceDelegate {
    func raised(error: VPNError) {
        switch error {
        case .error(let desc):
            DispatchQueue.main.async {
                self.view?.presentAlert(message: desc)
            }
        }
    }
    
    func statusUpdated(newStatus status: NEVPNStatus) {
        let connectionData = vpnService.currentProtocolConfiguration?.connectionData
        switch status {
        case .connecting:
            view?.connectionStatusView.update(
                with: .init(
                    status: .connecting(details: .init(connectionData: connectionData))
                )
            )
        case .connected:
            view?.connectionStatusView.update(with: .init(status: .connected(details: .init(connectionData: connectionData))))
        case .disconnected:
            view?.connectionStatusView.update(with: .init(status: .disconnected))
        case .disconnecting:
            view?.connectionStatusView.update(with: .init(status: .disconnecting))
        default:
            break
        }
        connectionStatusUpdatedAction?(status)
    }
}

extension MainScreenViewModel {
    enum Constants {
        static let supportUrl: String = SubscriptionConstants.liveHelpUrl
    }
}

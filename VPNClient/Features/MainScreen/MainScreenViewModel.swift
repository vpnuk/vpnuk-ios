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

enum ConnectScreenType: String {
    case account = "account_type"
    case custom = "custom_type"
}

protocol MainScreenViewModelProtocol {
    func viewLoaded()
    func openSettingsTouched()
    func openSupportTouched()
}

class MainScreenViewModel: MainScreenViewModelProtocol {
    private let router: MainScreenRouterProtocol
    weak var view: MainScreenViewProtocol?
    private var vpnService: VPNServiceProtocol
    private let serversRepository: ServersRepository
    private let openVPNConfigurationProvider: OpenVPNConfigurationProviderProtocol
    private let serverUpdatesChecker: ServerUpdatesCheckerProtocol
    
    var connectPressedAction: Action?
    var connectionStatusUpdatedAction: ConnectionStatusUpdatedAction?
    
    private var lastConnectScreenType: ConnectScreenType? {
        get {
            guard let val = UserDefaults.standard.string(forKey: "lastConnectScreenType") else {
                return nil
            }
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
        openVPNConfigurationProvider: OpenVPNConfigurationProviderProtocol,
        serverUpdatesChecker: ServerUpdatesCheckerProtocol
    ) {
        self.router = router
        self.vpnService = vpnService
        self.serversRepository = serversRepository
        self.openVPNConfigurationProvider = openVPNConfigurationProvider
        self.serverUpdatesChecker = serverUpdatesChecker
    }
    
    func viewLoaded() {
        let lastConnectType = lastConnectScreenType ?? .custom
        connectTypeChanged(type: lastConnectType)
        vpnService.delegate = self
        view?.connectionStatusView.connectButtonAction = { [weak self] in
            self?.connectButtonTouched()
        }
        
        loadData(forceReload: false)
    }
    
    func openSettingsTouched() {
        router.presentSettings()
    }
    
    func openSupportTouched() {
        if let link = URL(string: Constants.supportUrl) {
            UIApplication.shared.open(link)
        }
    }
    
    private func loadData(forceReload: Bool) {
        view?.setLoading(true)
        checkVersionsAndUpdateDataIfNeeded(
            forceUpdate: forceReload
        ) { [weak self] result in
            self?.view?.setLoading(false)
            
            switch result {
            case .success:
                // Updated
                break
            case .failure(let error):
                switch error {
                case .error(let text):
                    self?.view?.presentAlert(message: text)
                }
            }
        }
    }
    
    private func checkVersionsAndUpdateDataIfNeeded(forceUpdate: Bool, completion: @escaping (Result<Void, MainScreenError>) -> Void) {
        serverUpdatesChecker.checkVersions { [weak self] result in
            switch result {
            case .success(let updates):
                
                let shouldReloadServers = updates.isServerlistVersionOutdated
                || forceUpdate
                let shouldReloadOvpnConfigurations = updates.isOVPNFileVersionOutdated
                || self?.openVPNConfigurationProvider.isConfigurationsLoaded == false
                || forceUpdate
                
                let group = DispatchGroup()
                var updateErrors: [MainScreenError] = []
                
                if shouldReloadServers {
                    group.enter()
                    self?.reloadServers { result in
                        switch result {
                        case .success:
                            self?.serverUpdatesChecker.setLastServersVersion(Int(updates.versionsOnServer.servers ?? "") ?? 0)
                        case .failure:
                            updateErrors.append(.error(description: NSLocalizedString("Servers update error.", comment: "")))
                        }
                        group.leave()
                    }
                }
                
                if shouldReloadOvpnConfigurations {
                    group.enter()
                    self?.reloadOVPNConfiguration(forceRedownload: updates.isOVPNFileVersionOutdated || forceUpdate) { result in
                        switch result {
                        case .success:
                            self?.serverUpdatesChecker.setLastOVPNVersion(Int(updates.versionsOnServer.ovpn ?? "") ?? 0)
                        case .failure:
                            updateErrors.append(.error(description: NSLocalizedString(".ovpn file update error.", comment: "")))
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: DispatchQueue.main) {
                    if let error = updateErrors.first {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure:
                completion(.failure(.error(description: NSLocalizedString("Server connection error.", comment: ""))))
            }
        }
    }
    
    private func reloadOVPNConfiguration(forceRedownload: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        openVPNConfigurationProvider.reloadConfigurations(forceRedownload: forceRedownload, completion: completion)
    }
    
    private func reloadServers(completion: @escaping (Result<Void, Error>) -> Void) {
        serversRepository.updateServers(completion: completion)
    }
    
    private func connectTypeChanged(type: ConnectScreenType) {
        switch type {
        case .account:
            router.switchToAccountConnectView(connectorDelegate: self)
        case .custom:
            router.switchToCustomConnectView(connectorDelegate: self)
        }
        lastConnectScreenType = type
        view?.updateConnectScreenSwitcher(
            model: buildModelForSwitcher(connectScreenType: type)
        )
    }
    
    private func buildModelForSwitcher(
        connectScreenType: ConnectScreenType
    ) -> MainScreenViewController.ConnectScreenSwitcherModel {
        let items: [String] = [
            NSLocalizedString("VPN Account", comment: ""),
            NSLocalizedString("User Account", comment: "")
        ]
        
        let selectedIndex: Int
        switch connectScreenType {
        case .custom:
            selectedIndex = 0
        case .account:
            selectedIndex = 1
        }
        
        return .init(
            items: items,
            selectedIndex: selectedIndex,
            itemSelectedAction: { [weak self] selectedIndex in
                guard let self = self else { return }
                switch selectedIndex {
                case 0:
                    self.connectTypeChanged(type: .custom)
                case 1:
                    self.connectTypeChanged(type: .account)
                default:
                    break
                }
            }
        )
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
        guard let configuration = openVPNConfigurationProvider.getOpenVPNConfiguration(with: settings) else {
            view?.presentAlert(message: NSLocalizedString("OpenVPN configuration not loaded", comment: ""))
            return
        }
        switch vpnService.status {
        case .invalid, .disconnected:
            vpnService.configure(settings: .init(userSettings: settings, configuration: configuration))
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

private extension MainScreenViewModel {
    enum MainScreenError: Error {
        case error(description: String)
    }
}

private extension MainScreenViewModel {
    enum Constants {
        static let supportUrl: String = SubscriptionConstants.liveHelpUrl
    }
}

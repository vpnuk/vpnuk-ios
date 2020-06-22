//
//  MainScreenViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 09.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import NetworkExtension

enum ConnectScreenType: Int {
    case account = 0
    case custom = 1
}

protocol MainScreenViewModelProtocol {
    func viewLoaded()
    func connectTypeChanged(type: ConnectScreenType)
}

class MainScreenViewModel: MainScreenViewModelProtocol {
    private let router: MainScreenRouterProtocol
    weak var view: MainScreenViewProtocol?
    private var vpnService: VPNService
    
    private var lastConnectScreenType: ConnectScreenType? {
        get {
            let val = UserDefaults.standard.integer(forKey: "lastConnectScreenType")
            return ConnectScreenType(rawValue: val)
        }
        set {
            UserDefaults.standard.set(newValue?.rawValue, forKey: "lastConnectScreenType")
        }
    }
    
    init(router: MainScreenRouterProtocol, vpnService: VPNService) {
        self.router = router
        self.vpnService = vpnService
    }
    
    func viewLoaded() {
        let lastConnectType = lastConnectScreenType ?? .custom
        connectTypeChanged(type: lastConnectType)
        vpnService.delegate = self
    }
    
    func connectTypeChanged(type: ConnectScreenType) {
        guard let connectionStatusView = view?.connectionStatusView else {
            return
        }
        switch type {
        case .account:
            router.switchToAccountConnectView(connectionStatusView: connectionStatusView)
        case .custom:
            router.switchToCustomConnectView(connectionStatusView: connectionStatusView)
        }
        lastConnectScreenType = type
        view?.setConnectScreenType(type)
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
            view?.connectionStatusView.update(with: .connecting(details: .init(connectionData: connectionData)))
        case .connected:
            view?.connectionStatusView.update(with: .connected(details: .init(connectionData: connectionData)))
        case .disconnected:
            view?.connectionStatusView.update(with: .disconnected)
        case .disconnecting:
            view?.connectionStatusView.update(with: .disconnecting)
        default:
            break
        }
    }
}

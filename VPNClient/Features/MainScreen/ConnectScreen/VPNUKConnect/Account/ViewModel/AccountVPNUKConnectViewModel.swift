//
//  VPNUKAccountConnectionDataViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import TunnelKit

protocol AccountVPNUKConnectViewModelProtocol {
    func viewDidLoad()
    func signOut()
}

struct SubscriptionVPNAccount: Codable {
    let subscription: SubscriptionDTO
    let vpnAccount: VPNAccountDTO?
}

class AccountVPNUKConnectViewModel  {
    private var deps: Dependencies
    
    weak var view: AccountVPNUKConnectViewProtocol? {
        didSet {
            viewDidLoad()
        }
    }
    private var selectedSubscriptionAndAccount: SubscriptionVPNAccount? {
        didSet {
            updateSubscriptionPickerView()
        }
    }
    
    private var connectedServerData: ConnectionData? {
        if deps.connectorDelegate?.connectionStatus == .connected {
            return deps.connectorDelegate?.connectedServerData
        } else {
            return nil
        }
    }
    
    private var userSubscriptions: [SubscriptionDTO] = []
    
    init(dependencies: Dependencies) {
        self.deps = dependencies
    }
    
}

// MARK: - AccountVPNUKConnectViewModelProtocol

extension AccountVPNUKConnectViewModel: AccountVPNUKConnectViewModelProtocol {

    func viewDidLoad() {
        //        deps.subscripionsAPI.createSubscription(
        //        subscriptionRequest: .init(productId: "6622", productIdSource: .vpnuk)) { (result) in
        //            switch result {
        //            case .success(let t):
        //                print(t)
        //            case .failure(let error):
        //                print(error)
        //            }
        //        }
        reloadSubscriptions()
        updateServerPicker()
        deps.connectorDelegate?.connectPressedAction = { [weak self] in
            self?.connectTouched()
        }
        deps.connectorDelegate?.connectionStatusUpdatedAction = { [weak self] _ in
            self?.updateServerPicker()
        }
    }
    
    func signOut() {
        try? deps.authService.signOut()
        deps.connectionStateStorage.vpnukConnectionSelectedServerState = nil
        deps.connectionStateStorage.vpnukConnectionSelectedSubscriptionState = nil
        deps.router.switchToAuthorizationScreen()
    }
    
}

// MARK: - Connecting to server

extension AccountVPNUKConnectViewModel {
    
    private var selectedServer: ServerEntity? {
        if let ip = deps.connectionStateStorage.vpnukConnectionSelectedServerState?.selectedServerIp {
            return deps.serversRepository.getServer(byIp: ip)
        }
        return nil
    }
    
    private func connectTouched() {
        guard
            let selectedSubscriptionAndAccount = selectedSubscriptionAndAccount,
            let account = selectedSubscriptionAndAccount.vpnAccount
        else {
            deps.router.presentAlert(message: "Please select subscription and vpn account from the list")
            return
        }
        
        guard let server = selectedServer, let ip = server.address else {
            deps.router.presentAlert(message: "Please select server from the list")
            return
        }
        
        let port = Int(UserDefaults.portSetting ?? String(VPNSettings.defaultSettings.port)) ?? VPNSettings.defaultSettings.port
        let type = UserDefaults.socketTypeSetting ?? VPNSettings.defaultSettings.socketType
        let serverDns: String? = server.dns
        let serverIp: String = ip
        
        
        let credentials = OpenVPN.Credentials(account.username, account.password)
        let onDemandRuleConnect = UserDefaults.reconnectOnNetworkChangeSetting
        let dnsServers = serverDns == nil ? nil : [serverDns!]
        
        let connectionSettings = ConnectionSettings(
            hostname: serverIp,
            port: UInt16(port),
            dnsServers: dnsServers,
            socketType: type,
            credentials: credentials,
            onDemandRuleConnect: onDemandRuleConnect
        )
        deps.connectorDelegate?.connect(withSettings: connectionSettings)
    }
    
}

// MARK: - Build data for server picker

extension AccountVPNUKConnectViewModel {
    
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
                self.deps.router.presentServersPicker(viewModel: viewModel)
            }
        )
    }
    
    private func buildServerPickerViewModel() -> ServerPickerListViewModelProtocol {
        let allServers = getAllServers()
        var connectedServerPosition: ServerTablePosition? = nil
        if let connectedIp = connectedServerData?.serverIP {
            connectedServerPosition = getServerPosition(forServerIp: connectedIp, inServers: allServers)
        }
        
        var selectedServerPosition: ServerTablePosition? = nil
        if let selectedIp = deps.connectionStateStorage.vpnukConnectionSelectedServerState?.selectedServerIp {
            selectedServerPosition = getServerPosition(forServerIp: selectedIp, inServers: allServers)
        }
        
        let viewModel = ServerPickerListViewModel(
            initiallySelectedPosition: selectedServerPosition ?? ServerTablePosition(type: .shared, index: 0),
            servers: getAllServers(),
            connectedServerPosition: connectedServerPosition,
            selectServerAtAction: { [weak self] position in
                guard let self = self else { return }
                let server = allServers[position.type]?[position.index]
                let state = VPNUKConnectionSelectedServerState(
                    selectedServerIp: server?.address
                )
                self.deps.connectionStateStorage.vpnukConnectionSelectedServerState = state
                self.updateServerPicker()
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
            let servers = deps.serversRepository.getServers(forTypes: [type])
            if !servers.isEmpty {
                result[type] = servers
            }
        }
        return result
    }
    
}

// MARK: - Subscriptions

private extension AccountVPNUKConnectViewModel {
    private func updateSubscriptionPickerView() {
        if let subscriptionAndAccount = selectedSubscriptionAndAccount {
            let subscription = subscriptionAndAccount.subscription
            
            let dedicatedServerModel: PickedSubscriptionDedicatedServerView.Model?
            if let server = subscriptionAndAccount.vpnAccount?.server {
                dedicatedServerModel = .init(
                    title: server.description,
                    ip: server.ip,
                    location: server.location
                )
            } else {
                dedicatedServerModel = nil
            }
            
            let vpnAccountModel: PickedSubscriptionVPNAccountView.Model?
            if let vpn = subscriptionAndAccount.vpnAccount {
                vpnAccountModel = .init(
                    username: vpn.username,
                    password: vpn.password,
                    info: NSLocalizedString("With this account you can connect to all shared servers.", comment: "")
                )
            } else {
                vpnAccountModel = nil
            }
            
            let state: SubscriptionPickerView.State = .picked(
                subscriptionModel: .init(
                    subscriptionModel: .init(
                        title: subscription.productName,
                        vpnAccountsQuantity: subscription.quantity,
                        maxSessions: subscription.sessions,
                        subscriptionStatus: subscription.status,
                        periodMonths: subscription.period,
                        trialEnd: subscription.trialEndDate
                    ),
                    dedicatedServerModel: dedicatedServerModel,
                    pickedVPNAccountModel: vpnAccountModel,
                    tapAction: { [weak self] in
                        self?.openSubscriptionPicker()
                    }
                )
            )
            
            view?.updateSubscriptionPicker(withState: state)
        } else {
            let state: SubscriptionPickerView.State = .notPicked(
                notPickedModel: .init(
                    title: NSLocalizedString("Pick a VPN account to connect...", comment: ""),
                    tapAction: { [weak self] in
                        self?.openSubscriptionPicker()
                    }
                )
            )
            
            view?.updateSubscriptionPicker(withState: state)
        }
    }
    
    private func openSubscriptionPicker() {
        deps.router.openSubscriptionAndVPNAccountPicker(
            subscriptions: self.userSubscriptions,
            subscriptionPickedAction: { [weak self] data in
                guard let self = self else { return }
                self.selectedSubscriptionAndAccount = data
                if let data = data {
                    self.deps.connectionStateStorage.vpnukConnectionSelectedSubscriptionState = .init(
                        subscriptionId: data.subscription.id,
                        subscriptionName: data.subscription.productName,
                        vpnAccountUsername: data.vpnAccount?.username
                    )
                } else {
                    self.deps.connectionStateStorage.vpnukConnectionSelectedSubscriptionState = nil
                }
            },
            initiallySelectedSubscription: selectedSubscriptionAndAccount
        )
    }
    
    private func reloadSubscriptions(completion: Action? = nil) {
        view?.setLoading(true)
        deps.subscripionsAPI.getSubscriptions { [weak self] result in
            guard let self = self else { return }
            self.view?.setLoading(false)
            
            switch result {
            case .success(let subscriptions):
                self.userSubscriptions = subscriptions
            case .failure(let error):
                self.deps.router.presentAlert(message: error.localizedDescription)
            }
            self.updateSubscriptionPickerView()
            self.restoreLastSelectedSubscription()
            completion?()
        }
    }
    
    private func restoreLastSelectedSubscription() {
        let allUserSubscriptions = userSubscriptions
        if let selectedSubscriptionState = deps.connectionStateStorage.vpnukConnectionSelectedSubscriptionState {
            let foundSubscription = allUserSubscriptions.first(where: {
                $0.id == selectedSubscriptionState.subscriptionId
                    && $0.productName == selectedSubscriptionState.subscriptionName
            })
            if let foundSubscription = foundSubscription {
                let foundVpnAccount = foundSubscription.vpnAccounts.first(where: { $0.username == selectedSubscriptionState.vpnAccountUsername })
                self.selectedSubscriptionAndAccount = .init(subscription: foundSubscription, vpnAccount: foundVpnAccount)
            } else {
                self.selectedSubscriptionAndAccount = nil
            }
        } else {
            self.selectedSubscriptionAndAccount = nil
        }
    }
}

// MARK: - Dependencies

extension AccountVPNUKConnectViewModel {
    struct Dependencies {
        let router: AccountVPNUKConnectRouterProtocol
        weak var connectorDelegate: VPNConnectorDelegate?
        let subscripionsAPI: SubscripionsAPI
        var connectionStateStorage: VPNUKConnectionStateStorage
        let serversRepository: ServersRepository
        let authService: AuthService
    }
}

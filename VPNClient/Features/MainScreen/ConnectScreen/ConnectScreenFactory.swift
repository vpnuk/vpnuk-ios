//
//  ConnectScreenFactory.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 07.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class ConnectScreenFactory {

    func createCustomConnectModule(
        withRouter router: MainScreenRouterProtocol,
        connectorDelegate: VPNConnectorDelegate
    ) -> UIView {
        let storage = KeychainCredentialsStorage(
            usernameKey: KeychainKeys.VPN.usernameKey,
            passwordKey: KeychainKeys.VPN.passwordKey
        )
        
        let viewModel = CustomConnectViewModel(
            router: router,
            customCredentialsStorage: storage,
            connectionStateStorage: ConnectionStateStorageImpl.shared,
            serversRepository: ServersRepositoryImpl(
                coreDataStack: CoreDataStack.shared,
                serversRestAPI: RestAPI.shared
            ),
            connectorDelegate: connectorDelegate
        )
        let view = CustomConnectView(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func createAccountConnectModule(withRouter router: MainScreenRouterProtocol, connectorDelegate: VPNConnectorDelegate) -> UIView {
        let storage = KeychainCredentialsStorage(
            usernameKey: KeychainKeys.VPNUKAccount.usernameKey,
            passwordKey: KeychainKeys.VPNUKAccount.passwordKey
        )
        let factory = VPNUKConnectFactory(accountCredentialsStorage: storage, connectorDelegate: connectorDelegate)
        let view = factory.createAccountConnectContainerModule(withRouter: router)
        
        return view
    }
}

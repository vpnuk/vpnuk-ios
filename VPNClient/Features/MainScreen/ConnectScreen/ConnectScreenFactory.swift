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

    func createCustomConnectModule() -> UIView {
        let storage = KeychainCredentialsStorage(
            usernameKey: KeychainKeys.VPN.usernameKey,
            passwordKey: KeychainKeys.VPN.passwordKey
        )
        let viewModel = CustomConnectViewModel(customCredentialsStorage: storage)
        let view = CustomConnectView(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func createAccountConnectModule(withRouter router: MainScreenRouterProtocol) -> UIView {
        let storage = KeychainCredentialsStorage(
            usernameKey: KeychainKeys.VPNUKAccount.usernameKey,
            passwordKey: KeychainKeys.VPNUKAccount.passwordKey
        )
        let factory = VPNUKConnectFactory(accountCredentialsStorage: storage)
        let view = factory.createAccountConnectContainerModule(withRouter: router)
        
        return view
    }
    
    
    
    
}

//
//  VPNUKConnectFactory.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 07.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class VPNUKConnectFactory {
    private let authService: AuthService
    private weak var connectorDelegate: VPNConnectorDelegate?
    
    init(accountCredentialsStorage: CredentialsStorage, connectorDelegate: VPNConnectorDelegate) {
        authService = VPNUKAuthService(userCredentialsStorage: accountCredentialsStorage)
        self.connectorDelegate = connectorDelegate
    }
    
    func createAccountVPNUKConnectModule(withRouter router: AccountVPNUKConnectRouterProtocol) -> UIView {
        let viewModel = AccountVPNUKConnectViewModel(router: router, connectorDelegate: connectorDelegate)
        let view = AccountVPNUKConnectView(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    
    func createAuthVPNUKConnectModule(withRouter router: AuthVPNUKConnectRouterProtocol) -> UIView {
        let viewModel = AuthVPNUKConnectViewModel(
            deps: .init(
                router: router,
                authApi: RestAPI.shared,
                authService: authService
            )
        )
        let view = AuthVPNUKConnectView(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func createRegistrationVPNUKConnectModule(withRouter router: AuthVPNUKConnectRouterProtocol) -> UIView {
        let viewModel = RegistrationVPNUKConnectViewModel(
            deps: .init(
                router: router,
                authApi: RestAPI.shared,
                authService: authService
            )
        )
        let view = RegistrationVPNUKConnectView(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func createAccountConnectContainerModule(withRouter router: MainScreenRouterProtocol) -> UIView {
        let vpnukRouter = VPNUKConnectRouter(parentRouter: router, vpnukFactory: self)
        
        let containerView = createAccountContainerView()
        vpnukRouter.containerView = containerView
        
        if authService.isSignedIn {
            vpnukRouter.switchToAccountScreen()
        } else {
            vpnukRouter.switchToAuthorizationScreen()
        }
        
        return containerView
    }
    
    private func createAccountContainerView() -> UIView {
        let view = UIView()
        
        return view
    }
}

//
//  VPNUKConnectRouter.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 07.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

protocol AccountVPNUKConnectRouterProtocol: AlertPresentable {
    func switchToAuthorizationScreen()
}

protocol AuthVPNUKConnectRouterProtocol: AlertPresentable {
    func switchToAccountScreen()
    func switchToAuthorizationScreen()
    func switchToRegistrationScreen()
}

class VPNUKConnectRouter: AuthVPNUKConnectRouterProtocol, AccountVPNUKConnectRouterProtocol {
    
    weak var containerView: UIView?
    private let parentRouter: MainScreenRouterProtocol
    private let vpnukFactory: VPNUKConnectFactory
    
    init(parentRouter: MainScreenRouterProtocol, vpnukFactory: VPNUKConnectFactory) {
        self.vpnukFactory = vpnukFactory
        self.parentRouter = parentRouter
    }
    
    func switchToAccountScreen() {
        containerView?.removeSubviews()
        let view = vpnukFactory.createAccountVPNUKConnectModule(withRouter: self)
        containerView?.addSubview(view)
        view.makeEdgesEqualToSuperview()
    }
    
    func switchToAuthorizationScreen() {
        containerView?.removeSubviews()
        let view = vpnukFactory.createAuthVPNUKConnectModule(withRouter: self)
        containerView?.addSubview(view)
        view.makeEdgesEqualToSuperview()
    }
    
    func switchToRegistrationScreen() {
        containerView?.removeSubviews()
        let view = vpnukFactory.createRegistrationVPNUKConnectModule(withRouter: self)
        containerView?.addSubview(view)
        view.makeEdgesEqualToSuperview()
    }
    
    func presentAlert(message: String) {
        parentRouter.presentAlert(message: message)
    }
    
    func presentAlert(message: String, completion: @escaping () -> ()) {
        parentRouter.presentAlert(message: message, completion: completion)
    }
}

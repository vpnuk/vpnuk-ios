//
//  VPNUKConnectRouter.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 07.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

protocol AccountVPNUKConnectRouterProtocol {
    func switchToAuthorizationScreen()
}

protocol AuthVPNUKConnectRouterProtocol {
    func switchToAccountScreen()
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
        containerView?.subviews.forEach { $0.removeFromSuperview() }
        let view = vpnukFactory.createAccountVPNUKConnectModule(withRouter: self)
        containerView?.addSubview(view)
        view.makeEdgesEqualToSuperview()
    }
    
    func switchToAuthorizationScreen() {
        containerView?.subviews.forEach { $0.removeFromSuperview() }
        let view = vpnukFactory.createAuthVPNUKConnectModule(withRouter: self)
        containerView?.addSubview(view)
        view.makeEdgesEqualToSuperview()
    }
    
}

//
//  AuthVPNUKConnectViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol AuthVPNUKConnectViewModelProtocol {
    
}

class AuthVPNUKConnectViewModel: AuthVPNUKConnectViewModelProtocol {
    private let router: AuthVPNUKConnectRouterProtocol
    
    weak var view: AuthVPNUKConnectViewProtocol?
    
    init(router: AuthVPNUKConnectRouterProtocol) {
        self.router = router
    }
}

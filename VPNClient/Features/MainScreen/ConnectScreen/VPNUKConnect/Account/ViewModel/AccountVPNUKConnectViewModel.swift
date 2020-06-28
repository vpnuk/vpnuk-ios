//
//  VPNUKAccountConnectionDataViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol AccountVPNUKConnectViewModelProtocol {
    
}

class AccountVPNUKConnectViewModel: AccountVPNUKConnectViewModelProtocol  {
    private let router: AccountVPNUKConnectRouterProtocol
    
    weak var view: AccountVPNUKConnectViewProtocol?
    
    init(router: AccountVPNUKConnectRouterProtocol) {
        self.router = router
    }
}

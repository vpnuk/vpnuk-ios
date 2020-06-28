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
    private weak var connectorDelegate: VPNConnectorDelegate?
    
    weak var view: AccountVPNUKConnectViewProtocol?
    
    init(router: AccountVPNUKConnectRouterProtocol, connectorDelegate: VPNConnectorDelegate?) {
        self.router = router
        self.connectorDelegate = connectorDelegate
    }
}

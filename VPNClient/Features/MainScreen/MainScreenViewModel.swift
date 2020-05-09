//
//  MainScreenViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 09.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

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
    
    init(router: MainScreenRouterProtocol) {
        self.router = router
    }
    
    func viewLoaded() {
        router.switchToCustomConnectView()
    }
    
    func connectTypeChanged(type: ConnectScreenType) {
        switch type {
        case .account:
            router.switchToAccountConnectView()
        case .custom:
            router.switchToCustomConnectView()
        }
    }
    
}

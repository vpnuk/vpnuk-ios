//
//  MainScreenFactory.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 09.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class MainScreenFactory {
    func create() -> UIViewController {
        let router = MainScreenRouter()
        let repository = ServersRepositoryImpl(
            coreDataStack: CoreDataStack.shared,
            serversRestAPI: RestAPI.shared
        )
        let viewModel = MainScreenViewModel(
            router: router,
            vpnService: OpenVPNService.shared,
            serversRepository: repository
        )
        let view = MainScreenViewController(viewModel: viewModel)
        viewModel.view = view
        router.viewController = view
        
        return view
    }
}

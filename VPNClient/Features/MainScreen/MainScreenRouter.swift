//
//  MainScreenRouter.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

protocol MainScreenRouterProtocol {
    func presentSettings()
    func presentServersPicker(delegate: ServerPickerListViewModelProtocol)
    
    func switchToCustomConnectView()
    func switchToAccountConnectView()
    
}

class MainScreenRouter: MainScreenRouterProtocol {
    weak var viewController: (UIViewController & MainScreenViewProtocol)?
    
    func switchToCustomConnectView() {
        let factory = ConnectScreenFactory()
        let view = factory.createCustomConnectModule(withRouter: self)
        viewController?.replaceConnectView(with: view)
    }
    
    func switchToAccountConnectView() {
        let factory = ConnectScreenFactory()
        let view = factory.createAccountConnectModule(withRouter: self)
        viewController?.replaceConnectView(with: view)
    }
    
    func presentSettings() {
        
    }
    
    func presentServersPicker(delegate: ServerPickerListViewModelProtocol) {
        let view = ServerPickerListViewController(viewModel: delegate)
        view.modalPresentationStyle = .fullScreen
        viewController?.present(view, animated: true, completion: nil)
    }
}

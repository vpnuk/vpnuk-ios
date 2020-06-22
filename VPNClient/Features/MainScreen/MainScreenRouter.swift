//
//  MainScreenRouter.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

protocol MainScreenRouterProtocol: AlertPresentable {
    func presentSettings()
    func presentServersPicker(viewModel: ServerPickerListViewModelProtocol)
    
    func switchToCustomConnectView(connectionStatusView: ConnectionStatusViewProtocol)
    func switchToAccountConnectView(connectionStatusView: ConnectionStatusViewProtocol)
    
}


class MainScreenRouter: MainScreenRouterProtocol {
    weak var viewController: (UIViewController & MainScreenViewProtocol)?
    
    func switchToCustomConnectView(connectionStatusView: ConnectionStatusViewProtocol) {
        let factory = ConnectScreenFactory()
        let view = factory.createCustomConnectModule(
            withRouter: self,
            connectionStatusView: connectionStatusView
        )
        viewController?.replaceConnectView(with: view)
    }
    
    func switchToAccountConnectView(connectionStatusView: ConnectionStatusViewProtocol) {
        let factory = ConnectScreenFactory()
        let view = factory.createAccountConnectModule(
            withRouter: self,
            connectionStatusView: connectionStatusView
        )
        viewController?.replaceConnectView(with: view)
    }
    
    func presentSettings() {
        
    }
    
    func presentAlert(message: String) {
        viewController?.presentAlert(message: message)
    }
    
    func presentServersPicker(viewModel: ServerPickerListViewModelProtocol) {
        let view = ServerPickerListViewController(viewModel: viewModel)
        viewModel.view = view
        view.modalPresentationStyle = .fullScreen
        viewController?.present(view, animated: true, completion: nil)
    }
}

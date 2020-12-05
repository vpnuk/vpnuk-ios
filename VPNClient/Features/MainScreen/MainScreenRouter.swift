//
//  MainScreenRouter.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

protocol MainScreenRouterProtocol: AlertPresentable, LoaderPresentable {
    func presentSettings()
    func presentServersPicker(viewModel: ServerPickerListViewModelProtocol)
    func present(controller: UIViewController, animated: Bool)
    
    func switchToCustomConnectView(connectorDelegate: VPNConnectorDelegate)
    func switchToAccountConnectView(connectorDelegate: VPNConnectorDelegate)
    
}

class MainScreenRouter: MainScreenRouterProtocol {
    weak var viewController: (UIViewController & MainScreenViewProtocol)?
    
    func switchToCustomConnectView(connectorDelegate: VPNConnectorDelegate) {
        let factory = ConnectScreenFactory()
        let view = factory.createCustomConnectModule(
            withRouter: self,
            connectorDelegate: connectorDelegate
        )
        viewController?.replaceConnectView(with: view)
    }
    
    func switchToAccountConnectView(connectorDelegate: VPNConnectorDelegate) {
        let factory = ConnectScreenFactory()
        let view = factory.createAccountConnectModule(
            withRouter: self,
            connectorDelegate: connectorDelegate
        )
        viewController?.replaceConnectView(with: view)
    }
    
    func presentSettings() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func presentAlert(message: String) {
        viewController?.presentAlert(message: message)
    }
    
    func presentAlert(message: String, completion: @escaping () -> ()) {
        viewController?.presentAlert(message: message, completion: completion)
    }
    
    func presentServersPicker(viewModel: ServerPickerListViewModelProtocol) {
        let view = ServerPickerListViewController(viewModel: viewModel)
        viewModel.view = view
        viewController?.present(view, animated: true, completion: nil)
    }
    
    func present(controller: UIViewController, animated: Bool) {
        viewController?.present(controller, animated: animated, completion: nil)
    }
    
    func setLoading(_ present: Bool) {
        viewController?.setLoading(present)
    }
}

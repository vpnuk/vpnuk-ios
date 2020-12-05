//
//  PurchaseSubscriptionOfferRouter.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 02.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit


struct Country {
    let title: String
    let descr: String
    let image: UIImage
    /// name for country api field
    let name: String
}

protocol PurchaseSubscriptionOfferRouterProtocol: AlertPresentable {
    func presentChooseCountryScreen(
        countries: [Country],
        initialSelectedCountryIndex: Int?,
        selectCountryAtIndexAction: @escaping (_ index: Int) -> Void
    )
    
    func close(completion: (() -> Void)?)
}

class PurchaseSubscriptionOfferRouter: PurchaseSubscriptionOfferRouterProtocol {
    weak var viewController: UIViewController?
    
    func presentChooseCountryScreen(
        countries: [Country],
        initialSelectedCountryIndex: Int?,
        selectCountryAtIndexAction: @escaping (_ index: Int) -> Void
    ) {
        let factory = PurchaseSubscriptionChooseCountryFactory()
        let controller = factory.create(
            availableCountries: countries,
            initialSelectedCountryIndex: initialSelectedCountryIndex,
            selectCountryAtIndexAction: selectCountryAtIndexAction
        )
        controller.modalPresentationStyle = .fullScreen
        viewController?.present(controller, animated: true)
    }
    
    func presentAlert(message: String) {
        viewController?.presentAlert(message: message)
    }
    func presentAlert(message: String, completion: @escaping () -> ()) {
        viewController?.presentAlert(message: message, completion: completion)
    }
    
    func close(completion: (() -> Void)?) {
        viewController?.dismiss(animated: true, completion: completion)
    }
}


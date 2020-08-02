//
//  PurchaseSubscriptionOfferRouter.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 02.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

protocol PurchaseSubscriptionOfferRouterProtocol {
    func presentAlert(message: String)
    func presentChooseCountryScreen(
        countries: [Country],
        initialSelectedCountryIndex: Int?,
        selectCountryAtIndexAction: @escaping (_ index: Int) -> Void
    )
    
    func close(completion: (() -> Void)?)
}

struct Country {
    let title: String
    let descr: String
    let image: UIImage
}

class PurchaseSubscriptionOfferRouter: PurchaseSubscriptionOfferRouterProtocol {
    weak var viewController: UIViewController?
    
    func presentChooseCountryScreen(
        countries: [Country],
        initialSelectedCountryIndex: Int?,
        selectCountryAtIndexAction: @escaping (_ index: Int) -> Void
    ) {
        
    }
    
    func presentAlert(message: String) {
        viewController?.presentAlert(message: message)
    }
    
    func close(completion: (() -> Void)?) {
        viewController?.dismiss(animated: true, completion: completion)
    }
}


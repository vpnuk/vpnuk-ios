//
//  PurchaseSubscriptionChooseCountryRouter.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 16.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

protocol PurchaseSubscriptionChooseCountryRouterProtocol {
    func close(completion: (() -> Void)?)
}

class PurchaseSubscriptionChooseCountryRouter: PurchaseSubscriptionChooseCountryRouterProtocol {
    weak var viewController: UIViewController?
    
    func close(completion: (() -> Void)?) {
        viewController?.dismiss(animated: true, completion: completion)
    }
}

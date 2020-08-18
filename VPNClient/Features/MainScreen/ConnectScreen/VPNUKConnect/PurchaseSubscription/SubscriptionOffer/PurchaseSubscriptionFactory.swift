//
//  PurchaseSubscriptionFactory.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 02.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class PurchaseSubscriptionFactory {
    func create(reloadSubscriptionsAction: @escaping Action) -> UIViewController {
        
        let router = PurchaseSubscriptionOfferRouter()
        let purchasesService: InAppPurchasesService = InAppPurchasesServiceImpl(
            availableProducts: PurchaseProduct.availableProducts,
            allProducts: PurchaseProduct.allCases,
            paymentQueue: SKPaymentQueue.default(),
            defaults: UserDefaults.standard,
            fileManager: FileManager.default
        )
        let viewModel = PurchaseSubscriptionOfferViewModel(
            reloadSubscriptionsAction: reloadSubscriptionsAction,
            deps: .init(
                router: router,
                purchasesService: purchasesService,
                subscripionsAPI: RestAPI.shared
            )
        )
        let viewController = PurchaseSubscriptionOfferViewController(viewModel: viewModel)
        viewModel.view = viewController
        router.viewController = viewController
        
        return viewController
    }
}


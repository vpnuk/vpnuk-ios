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
    func create(
        allPurchasableProducts: [PurchaseProduct],
        reloadSubscriptionsAction: @escaping Action
    ) -> UIViewController {
        
        let router = PurchaseSubscriptionOfferRouter()
        let purchasesService: InAppPurchasesService = InAppPurchasesServiceImpl(
            availableProducts: allPurchasableProducts,
            allProducts: PurchaseProduct.allCases,
            paymentQueue: SKPaymentQueue.default(),
            defaults: UserDefaults.standard,
            fileManager: FileManager.default
        )
        let viewModel = PurchaseSubscriptionOfferViewModel(
            allPurchasableProducts: allPurchasableProducts,
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
    
    func create(reloadSubscriptionsAction: @escaping Action) -> UIViewController {
        return create(
            allPurchasableProducts: PurchaseProduct.availableProducts,
            reloadSubscriptionsAction: reloadSubscriptionsAction
        )
    }
}


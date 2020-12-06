//
//  RenewPendingSubscriptionFactory.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.12.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class RenewPendingSubscriptionFactory {
    func create(
        allPurchasableProducts: [PurchaseProduct],
        subscriptionToRenew: SubscriptionDTO,
        reloadSubscriptionsAction: @escaping Action
    ) -> UIViewController {
        
        let router = PurchaseSubscriptionOfferRouter()
        let purchasesService: InAppPurchasesService = InAppPurchasesServiceImpl(
            availableProducts: allPurchasableProducts,
            allProducts: allPurchasableProducts,
            paymentQueue: SKPaymentQueue.default(),
            defaults: UserDefaults.standard,
            fileManager: FileManager.default
        )
        let viewModel = RenewPendingSubscriptionViewModel(
            allPurchasableProducts: allPurchasableProducts,
            subscriptionToRenew: subscriptionToRenew,
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
    
    func create(
        subscriptionToRenew: SubscriptionDTO,
        reloadSubscriptionsAction: @escaping Action
    ) -> UIViewController {
        return create(
            allPurchasableProducts: PurchaseProduct.availableProducts,
            subscriptionToRenew: subscriptionToRenew,
            reloadSubscriptionsAction: reloadSubscriptionsAction
        )
    }
}


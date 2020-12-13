//
//  RenewSubscriptionButtonModelBuilder.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.12.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

protocol RenewSubscriptionButtonRouterProtocol: AnyObject {
    func openRenewSubscriptionScreen(for subscription: SubscriptionDTO, reloadSubscriptionsAction: @escaping Action)
    func presentOkCancelAlert(withText text: String, okAction: @escaping Action)
}

class RenewSubscriptionButtonModelBuilder {
    func build(
        for subscription: SubscriptionDTO,
        router: RenewSubscriptionButtonRouterProtocol,
        reloadSubscriptionsAction: @escaping Action
    ) -> PickedSubscriptionInfoView.RenewSubscriptionModel? {
        guard let productId = subscription.productId else {
            return nil
        }
        let userCanRenewSubscription = subscription.status == .onHold
        
        if userCanRenewSubscription {
            let availableProducts = PurchaseProduct.availableProducts
            let userCanRenewSubscriptionFromApp = availableProducts.contains(where: { $0.productId == String(productId) })
            
            let renewAction: Action
            if userCanRenewSubscriptionFromApp {
                renewAction = { [weak router] in
                    router?.openRenewSubscriptionScreen(
                        for: subscription,
                        reloadSubscriptionsAction: reloadSubscriptionsAction
                    )
                }
            } else {
                let purchaseOnWebsiteText = NSLocalizedString(
                    "It is not possible to renew this subscription in app, we can forward you to your account page on the VPNUK website?",
                    comment: ""
                )
                renewAction = { [weak router] in
                    router?.presentOkCancelAlert(withText: purchaseOnWebsiteText, okAction: {
                        if let link = URL(string: Constants.accountUrlString) {
                            UIApplication.shared.open(link)
                        }
                    })
                }
            }
            let renewModel = PickedSubscriptionInfoView.RenewSubscriptionModel(
                title: NSLocalizedString("Renew subscription", comment: ""),
                action: renewAction
            )
            return renewModel
        } else {
            return nil
        }
    }
}

private extension RenewSubscriptionButtonModelBuilder {
    enum Constants {
        static let accountUrlString = "https://www.vpnuk.net/my-account/"
    }
}



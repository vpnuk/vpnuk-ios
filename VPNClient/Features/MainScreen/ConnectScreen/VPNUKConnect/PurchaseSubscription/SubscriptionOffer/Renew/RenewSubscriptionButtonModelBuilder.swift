//
//  RenewSubscriptionButtonModelBuilder.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.12.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class RenewSubscriptionButtonModelBuilder {
    func build(
        for subscription: SubscriptionDTO,
        openRenewSubscriptionScreenAction: @escaping (SubscriptionDTO) -> Void
    ) -> PickedSubscriptionInfoView.RenewSubscriptionModel? {
        let userCanRenewSubscription = subscription.status == .onHold
        if userCanRenewSubscription {
            let renewModel = PickedSubscriptionInfoView.RenewSubscriptionModel(
                title: NSLocalizedString("Renew subscription", comment: ""),
                action: { openRenewSubscriptionScreenAction(subscription) }
            )
            return renewModel
        } else {
            return nil
        }
    }
}

//
//  SubscriptionsListPickerFactory.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 08.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class SubscriptionsListPickerFactory {
    func create(
        withSubscriptionsToPick subscriptions: [SubscriptionDTO],
        subscriptionPickedAction: @escaping SubscriptionPickedAction,
        initiallySelectedSubscription: SubscriptionVPNAccount? = nil
    ) -> UIViewController {
        let controller = SubscriptionsListViewController(
            subscriptions: subscriptions,
            subscriptionPickedAction: subscriptionPickedAction,
            initiallySelectedSubscription: initiallySelectedSubscription
        )
        
        return controller
    }
}

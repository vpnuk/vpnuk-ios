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
        reloadSubscriptionsAction: @escaping Action,
        initiallySelectedSubscription: SubscriptionVPNAccount? = nil
    ) -> UIViewController {
        let controller = SubscriptionsListViewController(
            subscriptions: subscriptions,
            subscriptionPickedAction: subscriptionPickedAction,
            reloadSubscriptionsAction: reloadSubscriptionsAction,
            initiallySelectedSubscription: initiallySelectedSubscription
        )
        
        return controller
    }
}

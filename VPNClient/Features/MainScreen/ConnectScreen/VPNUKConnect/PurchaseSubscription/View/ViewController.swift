//
//  ViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    override func loadView() {
        let purchaseView = PurchaseSubscriptionOfferView()
        let planView = PurchaseSubscriptionChoosePlanView()
        var isSelected: Bool = false

        
        purchaseView.update(model: .init(
            logo: #imageLiteral(resourceName: "logo"),
            
            plansModel: .init(
                title: "Choose a Plan",
                plans: [.init(title: "Shared IP", subtitle: "Many servers"),
                        .init(title: "Dedicated IP", subtitle: "Your personal server"),
                        .init(title: "1:1 Dedicated IP", subtitle: "Your personal 1:1 server")],
                selectedPlanIndex: nil,
                planSelectedAction: { (index) in
                    viewSelected()
            }),
            
            periodModel: .init(
                title: "Choose Period",
                options: [.init(title: "12 Months"),
                          .init(title: "6 Months"),
                          .init(title: "3 Months"),
                          .init(title: "1 Month")],
                selectedOptionIndex: nil,
                optionSelectedAction: { (index) in
                    
                    viewSelected()
            }),
            
            maxUsersModel: .init(
                title: "Max Users",
                options: [.init(title: "6 users")],
                selectedOptionIndex: nil,
                optionSelectedAction: { (index) in
                    viewSelected()
            }),
            
            priceModel: .init(title: "Total price:",
                              moneySum: "10$"),
            
            advantagesModel: .init(
                title: "Why subscribe?",
                reasons: [.init(title: "Apps for every device"),
                          .init(title: "160 locations worldwide"),
                          .init(title: "24/7 customer support"),
                          .init(title: "Unlimited bandwidth")]),
            
            termsDetailsModel: .init(
                title: "Subscription details:",
                termsDetails: """
                Your Apple ID account will be charged on the last
                day of your free trial.

                Your subscription will automatically renew at the
                end of each billing period unless it is canceled at
                least 24 hours before the expiry date.

                You can manage and cancel your subscriptions
                by going to your App Store account settings after
                purchase.

                Any unused portion of a free trial period, if
                offered, will be forfeited when you purchase a
                subscription.

                By subscribing, you agree to the Terms of
                Service and Privacy Policy.


                """),
            
            purchaseButtonTitle: "Start your 7-day free trial"))
        
        func viewSelected() {
            isSelected = !isSelected
            switch isSelected {
            case true:
                planView.updateSelect(model: .init(planMark: #imageLiteral(resourceName: "checked")))
            case false:
                planView.updateSelect(model: .init(planMark: #imageLiteral(resourceName: "unchecked")))
            }
        }
        view = purchaseView
    }
}


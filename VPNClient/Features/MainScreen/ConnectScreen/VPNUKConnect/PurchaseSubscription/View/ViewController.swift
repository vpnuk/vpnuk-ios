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

        purchaseView.update(model: .init(
            logo: #imageLiteral(resourceName: "logo"),
            plansModel: .init(
                title: NSLocalizedString("Choose a Plan", comment: ""),
                plans: [.init(title: NSLocalizedString("Shared IP", comment: ""),
                              subtitle: NSLocalizedString("Many servers", comment: "")),
                        
                        .init(title: NSLocalizedString("Dedicated IP", comment: ""),
                              subtitle: NSLocalizedString("Your personal server", comment: "")),
                        
                        .init(title: NSLocalizedString("1:1 Dedicated IP", comment: ""),
                              subtitle: NSLocalizedString("Your personal 1:1 server", comment: ""))],
                selectedPlanIndex: nil,
                planSelectedAction: { (index) in
                    viewSelected()
            },
                infoTapAction: {infoButtonTapped()}),
            
            periodModel: .init(
                title: NSLocalizedString("Choose period", comment: ""),
                options: [.init(title: NSLocalizedString("12 Months", comment: "")),
                          .init(title: NSLocalizedString("6 Months", comment: "")),
                          .init(title: NSLocalizedString("3 Months", comment: "")),
                          .init(title: NSLocalizedString("1 Months", comment: ""))],
                selectedOptionIndex: nil,
                optionSelectedAction: { (index) in
                    viewSelected()
            },
                infoTapAction: {infoButtonTapped()}),
            
            maxUsersModel: .init(
                title: NSLocalizedString("Max users", comment: ""),
                options: [.init(title: NSLocalizedString("6 users", comment: ""))],
                selectedOptionIndex: nil,
                optionSelectedAction: { (index) in
                    viewSelected()
            },
                infoTapAction: {infoButtonTapped()}),
            
            priceModel: .init(title: NSLocalizedString("Total Price:", comment: ""),
                              moneySum: NSLocalizedString("10$", comment: "")),
            
            advantagesModel: .init(
                title: NSLocalizedString("Why Subscribe?", comment: ""),
                reasons: [.init(title: NSLocalizedString("Apps for every device", comment: "")),
                          .init(title: NSLocalizedString("160 locations worldwide", comment: "")),
                          .init(title: NSLocalizedString("24/7 customer support", comment: "")),
                          .init(title: NSLocalizedString("Unlimited bandwidth", comment: ""))]),
            
            termsDetailsModel: .init(
                title: NSLocalizedString("Subscribtion details:", comment: ""),
                termsDetails: NSMutableAttributedString(string:"-Your Apple ID account will be charged on the last day of your free trial. \n \n-Your subscription will automatically renew at the end of each billing period unless it is canceled at least 24 hours before the expiry date. \n \n-You can manage and cancel your subscriptions by going to your App Store account settings after purchase. \n \n-Any unused portion of a free trial period, if offered, will be forfeited when you purchase a subscription. \n \n-By subscribing, you agree to the Terms of Service and Privacy Policy."),
                
                termsDetailsURL: "https://www.vpnuk.net/terms/"),
            
            purchaseButtonTitle: NSLocalizedString("Start your 7-day free trial", comment: "")))
        
        func viewSelected() {}
        
        func infoButtonTapped() {}
        
        view = purchaseView
    }
}


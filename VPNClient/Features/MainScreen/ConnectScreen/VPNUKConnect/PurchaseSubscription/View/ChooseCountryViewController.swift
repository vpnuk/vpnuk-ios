//
//  ChooseCountryViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit
class ChooseCountryViewController: UIViewController {
    let countryView = PurchaseSubscriptionChooseCountryView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        countryView.update(model: .init(
            title: NSLocalizedString("Choose country of your dedicated server", comment: ""),
            countries: [.init(title: "Australia", imageFlag: #imageLiteral(resourceName: "au1")),
                        .init(title: "England", imageFlag: #imageLiteral(resourceName: "uk1")),
                        .init(title: "Japan", imageFlag: #imageLiteral(resourceName: "jp1"))],
            selectedCountryIndex: nil,
            countrySelectedAction: { (index) in
                viewSelected()
        },
            chooseButtonTitle: NSLocalizedString("Choose", comment: "")))
        view = countryView
        
        func viewSelected() {}
    }
}


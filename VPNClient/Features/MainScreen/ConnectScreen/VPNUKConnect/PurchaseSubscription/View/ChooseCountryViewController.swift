//
//  ChooseCountryViewController.swift
//  Purchase
//
//  Created by Александр Умаров on 24.07.2020.
//  Copyright © 2020 Александр Умаров. All rights reserved.
//

import UIKit

class ChooseCountryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

    }
    override func loadView() {
        self.view = PurchaseSubscriptionChooseCountryView()
    }
}

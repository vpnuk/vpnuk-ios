//
//  ViewController.swift
//  PurchaseScreen
//
//  Created by Александр Умаров on 22.07.2020.
//  Copyright © 2020 Александр Умаров. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    override func loadView() {
        view = PurchaseSubscriptionOfferView()
        
    }

   
}

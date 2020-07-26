//
//  ViewController.swift
//  PurchaseScreen
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
        view = PurchaseSubscriptionOfferView()
        
    }
    
    
}

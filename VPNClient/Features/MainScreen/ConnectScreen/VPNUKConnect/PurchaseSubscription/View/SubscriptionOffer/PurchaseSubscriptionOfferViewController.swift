//
//  PurchaseSubscriptionViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 02.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol PurchaseSubscriptionOfferViewProtocol: AnyObject {
    func update(model: PurchaseSubscriptionOfferView.Model)
}

class PurchaseSubscriptionOfferViewController: UIViewController {
    private lazy var customView = PurchaseSubscriptionOfferView()
    private let viewModel: PurchaseSubscriptionOfferViewModelProtocol
    
    init(viewModel: PurchaseSubscriptionOfferViewModelProtocol) {
         self.viewModel = viewModel
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        viewModel.viewLoaded()
    }
    
    private func commonInit() {
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    private func setupConstraints() {
        customView.makeEdgesEqualToSuperview()
    }
    
    private func setupSubviews() {
        view.addSubview(customView)
    }
}

extension PurchaseSubscriptionOfferViewController: PurchaseSubscriptionOfferViewProtocol {
    func update(model: PurchaseSubscriptionOfferView.Model) {
        customView.update(model: model)
    }
}

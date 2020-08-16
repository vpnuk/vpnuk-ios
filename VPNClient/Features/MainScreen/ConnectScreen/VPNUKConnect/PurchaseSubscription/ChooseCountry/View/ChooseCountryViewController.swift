//
//  ChooseCountryViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit

protocol ChooseCountryViewProtocol: AnyObject {
    func update(model: PurchaseSubscriptionChooseCountryView.Model)
}

class ChooseCountryViewController: UIViewController {
    private lazy var countryView = PurchaseSubscriptionChooseCountryView()
    private let viewModel: PurchaseSubscriptionChooseCountryViewModelProtocol
    
    init(viewModel: PurchaseSubscriptionChooseCountryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        viewModel.viewLoaded()
    }
    
    private func setupSubviews() {
        view.addSubview(countryView)
        countryView.makeEdgesEqualToSuperview()
    }
}

extension ChooseCountryViewController: ChooseCountryViewProtocol {
    func update(model: PurchaseSubscriptionChooseCountryView.Model) {
        countryView.update(model: model)
    }
}


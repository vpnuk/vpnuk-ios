//
//  PurchaseSubscriptionOfferView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionOfferView: UIView {
    
    // MARK: Header
    
    private lazy var headerLogoImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    // MARK: Plans
    
    private lazy var choosePlanView = PurchaseSubscriptionChoosePlanView()
    
    // MARK: Periods
    
     private lazy var periodsView = PurchaseSubscriptionOptionsView()
    
    // MARK: Max users
    
    private lazy var maxUsersView = PurchaseSubscriptionOptionsView()
    
    // MARK: Price
    
    private lazy var priceView = PurchaseSubscriptionPriceView()
    
    // MARK: Purchase
    
    private lazy var purchaseButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    // MARK: Advantages
    
    private lazy var advantagesView = PurchaseSubscriptionAdvantagesView()
    
    // MARK: Subscription details
    
    private lazy var termsAndDetailsView = PurchaseSubscriptionTermsAndDetailsView()
    
    // MARK: Content
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLogoImageView,
            choosePlanView,
            periodsView,
            maxUsersView,
            priceView,
            purchaseButton,
            advantagesView,
            termsAndDetailsView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return scroll
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {

    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    private func setupConstraints() {
        scrollView.makeEdgesEqualToSuperview()
        contentStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionOfferView {
    struct Model {
        let title: String
    }
}

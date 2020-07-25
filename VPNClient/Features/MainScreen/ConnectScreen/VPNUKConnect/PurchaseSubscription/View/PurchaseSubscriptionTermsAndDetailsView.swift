//
//  PurchaseSubscriptionTermsAndDetailsView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionTermsAndDetailsView: UIView {
    
    // MARK: - Header
    private lazy var headerLabel : UILabel = {
           let label = UILabel()
           label.text = "Subscription details:"
           label.textColor = .gray
           label.font = UIFont.boldSystemFont(ofSize: 14.0)
           return label
       }()

    
    // MARK: - Content
    
    private lazy var termsDetailsLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = """
        Your Apple ID account will be charged on the last
        day of your free trial.

        Your subscription will automatically renew at the
        end of each billing period unless it is canceled at
        east 24 hours before the expiry date.

        You can manage and cancel your subscriptions
        by going to your App Store account settings after
        purchase.

        Any unused portion of a free trial period, if
        offered, will be forfeited when you purchase a
        subscription.

        By subscribing, you agree to the Terms of
        Service and Privacy Policy.
        
        
        """
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel,
            termsDetailsLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
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
        addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionTermsAndDetailsView {
    struct Model {
        let title: String
    }
}

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
    private lazy var appearance = Appearance()
    // MARK: - Header
    private lazy var headerLabel : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Subscription details:", comment: "")
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        return label
    }()
    
    
    // MARK: - Content
    
    private lazy var termsDetailsLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        stackView.spacing = appearance.bigSpacing
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
        headerLabel.text = model.title
        termsDetailsLabel.text = model.termsDetails
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
        let termsDetails: String
    }
}

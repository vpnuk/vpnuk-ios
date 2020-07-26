//
//  PurchaseSubscriptionAdvantagesView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionAdvantagesView: UIView {
    private lazy var appearance = Appearance()
    // MARK: - Header
    private lazy var whySubscribeLabel : UILabel = {
        let label = UILabel()
        label.text = "Why subscribe?"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    // MARK: - Content
    
    private lazy var reasonLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
    
    private lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkmark"))
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(23)
        }
        return imageView
    }()
    
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            whySubscribeLabel,
            reasonsStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.standartSpacing
        return stackView
    }()
    private lazy var reasonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            checkMarkImageView,
            reasonLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = appearance.standartSpacing
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
        for text in model.reasons {
            reasonLabel.text = text.title
        }
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionAdvantagesView {
    struct Model {
        let title: String
        let reasons: [Reason]
    }
    struct Reason {
        let title: String
    }
}

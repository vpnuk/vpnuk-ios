//
//  PurchaseSubscriptionPriceView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionPriceView: UIView {
    private lazy var appearance = Appearance()
    // MARK: - Content
    
    private lazy var totalPriceLabel : UILabel = {
        let label = UILabel()
        label.textColor = appearance.totalPriceLabelTextColor
        label.font = appearance.totalPriceLabelFont
        
        return label
    }()
    
    private lazy var moneySumLabel : UILabel = {
        let label = UILabel()
        label.font = appearance.moneySumLabelFont
        
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            totalPriceLabel,
            moneySumLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = appearance.contentStackViewSpacing
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
        totalPriceLabel.text = NSLocalizedString("\(model.title)", comment: "")
        moneySumLabel.text = NSLocalizedString("\(model.moneySum)", comment: "")
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

extension PurchaseSubscriptionPriceView {
    struct Model {
        let title: String
        let moneySum: String
    }
    struct Appearance {
        let totalPriceLabelFont = Style.Fonts.bigBoldFont
        let totalPriceLabelTextColor = Style.Color.darkGrayColor
        let moneySumLabelFont = Style.Fonts.bigBoldFont
        let contentStackViewSpacing = Style.Spacing.bigSpacing
    }
}

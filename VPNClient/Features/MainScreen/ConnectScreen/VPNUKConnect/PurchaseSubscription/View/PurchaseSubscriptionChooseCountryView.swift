//
//  ChooseCountryView.swift
//  VPNClient
//
//  Created by Александр Умаров on 24.07.2020.
//  Copyright © 2020 Александр Умаров. All rights reserved.
//

import UIKit
class PurchaseSubscriptionChooseCountryView: UIView {
    private lazy var appearance = Appearance()
    private lazy var countryView = PurchaseSubscriptionChoosePlanView()
    
    // MARK: - Header
    private lazy var headerLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = appearance.headerLabelNumberOfLines
        label.textColor = .darkGray
        label.font = appearance.headerLabelFont
        
        return label
    }()
    // MARK: - Content
    private lazy var chooseButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = appearance.chooseButtonTitleFont
        button.layer.backgroundColor = appearance.chooseButtonColor
        button.layer.cornerRadius = appearance.chooseButtonCornerRadius
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            countryView
        ])
        stackView.axis = .vertical
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
        headerLabel.text = model.title
        chooseButton.setTitle(NSLocalizedString("\(model.buttonTitle)", comment: ""), for: .normal)
    }
    
    private func setupSubviews() {
        addSubview(headerLabel)
        addSubview(contentStackView)
        addSubview(chooseButton)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.left.equalTo(appearance.contentStackViewLeftConstraint)
            make.top.equalTo(headerLabel.snp.bottom).offset(appearance.contentStackViewTopOffsetConstraint)
        }
        headerLabel.snp.makeConstraints{ make in
            make.left.equalTo(appearance.headerLabelLeftConstraint)
            make.top.equalTo(appearance.headerLabelTopConstraint)
        }
        chooseButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(appearance.chooseButtonLeftRightInsetConstraint)
            make.bottom.equalTo(appearance.chooseButtonBottomConstraint)
            make.height.equalTo(appearance.chooseButtonHeightConstraint)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionChooseCountryView {
    struct Model {
        let title: String
        let buttonTitle: String
    }
    struct Appearance {
        // MARK: - Header Appearance
        let headerLabelNumberOfLines = 0
        let headerLabelFont = Style.Fonts.bigBoldFont
        let headerLabelLeftConstraint = Style.Constraint.bigConstreint
        let headerLabelTopConstraint = 40
        
        // MARK: - ChooseButton Appearance
        let chooseButtonTitleFont = Style.Fonts.bigBoldFont
        let chooseButtonColor = Style.Color.blueColor
        let chooseButtonCornerRadius = Style.CornerRadius.standartCornerRadius
        let chooseButtonLeftRightInsetConstraint = Style.Constraint.standartConstreint
        let chooseButtonBottomConstraint = -11
        let chooseButtonHeightConstraint = 54
        
        // MARK: - ContentStackView Appearance
        let contentStackViewSpacing = Style.Spacing.noSpacing
        let contentStackViewLeftConstraint = Style.Constraint.bigConstreint
        let contentStackViewTopOffsetConstraint = 77
    }
}

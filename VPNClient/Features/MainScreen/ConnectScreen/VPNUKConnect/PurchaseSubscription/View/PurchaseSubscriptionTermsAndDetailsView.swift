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
        label.textColor = appearance.labelTextColor
        label.font = appearance.headerLabelFont
        return label
    }()
    // MARK: - Content
    
    private lazy var termsDetailsLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = appearance.termsDetailsLabelNumberOfLines
        label.textColor = appearance.labelTextColor
        label.font = appearance.termsDetailsLabelFont
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel,
            termsDetailsLabel
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
        headerLabel.text = NSLocalizedString("\(model.title)", comment: "")
        let termsText = NSMutableAttributedString(string: model.termsDetails)
        termsText.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 397, length: 13))
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
    struct Appearance {
        let headerLabelFont = Style.Fonts.smallBoldFont
        let labelTextColor = Style.Color.grayTextColor
        let termsDetailsLabelNumberOfLines = 0
        let termsDetailsLabelFont = Style.Fonts.minFont
        let contentStackViewSpacing = Style.Spacing.bigSpacing
    }
}

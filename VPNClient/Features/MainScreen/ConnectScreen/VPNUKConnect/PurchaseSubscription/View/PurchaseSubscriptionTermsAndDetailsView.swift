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
        label.textColor = appearance.textColor
        label.font = appearance.headerLabelFont
        return label
    }()
    // MARK: - Content
    private lazy var termsDetailsTextView: UITextView = {
        let textView = UITextView()
        textView.font = appearance.termsDetailsLabelFont
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.linkTextAttributes = [.foregroundColor: appearance.textViewLinkColor]
        return textView
    }()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel,
            termsDetailsTextView
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
        let attributedString = NSMutableAttributedString(string: "\(model.termsDetails)")
        let url = URL(string: "https://www.vpnuk.net/terms/")!
        attributedString.addAttribute(.foregroundColor,
                                      value: appearance.textColor,
                                      range: appearance.attributedMainTextRange)
        attributedString.setAttributes([.link: url], range: appearance.attributedLinkTextRange)
        headerLabel.text = model.title
        termsDetailsTextView.attributedText = attributedString
    }
    private func setupSubviews() {
        addSubview(contentStackView)
    }
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalToSuperview()
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
        let textColor = Style.Color.grayTextColor
        let termsDetailsLabelNumberOfLines = 0
        let termsDetailsLabelFont = Style.Fonts.minFont
        let contentStackViewSpacing = Style.Spacing.bigSpacing
        let textViewLinkColor = UIColor(red: 0.18, green: 0.439, blue: 0.627, alpha: 1)
        let attributedLinkTextRange = NSMakeRange(479, 35)
        let attributedMainTextRange = NSMakeRange(0, 478)
    }
}

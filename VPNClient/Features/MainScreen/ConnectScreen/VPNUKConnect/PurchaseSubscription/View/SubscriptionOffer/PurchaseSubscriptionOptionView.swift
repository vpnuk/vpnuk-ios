//
//  PurchaseSubscriptionOptionView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit

class PurchaseSubscriptionOptionView: UIView {
    private lazy var appearance = Appearance()
    private var tappedAction: (() -> Void)?
    // MARK: - Content
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            optionImageView,
            optionLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = appearance.contentStackViewSpacing
        return stackView
    }()
    
    private lazy var optionImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "unchecked.pdf"))
        return imageView
    }()
    
    private lazy var optionLabel : UILabel = {
        let label = UILabel()
        label.font = appearance.optionLabelFont
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        optionLabel.text = model.title
        tappedAction = model.tappedAction
        if model.isSelected {
            optionImageView.image = UIImage(named: "checked.pdf")
            layer.borderColor = Style.Color.blueColor
        } else {
            optionImageView.image = UIImage(named: "unchecked.pdf")
            layer.borderColor = Style.Color.grayColor
        }
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
        layer.cornerRadius = appearance.selfViewCornerRadius
        layer.borderWidth = appearance.selfViewBorderWidth
        layer.borderColor = appearance.selfViewBorderColor
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(appearance.contentStackViewEdgesInsetSize)
        }
        optionImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(appearance.optionImageViewSize)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapped))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func didTapped(_ gesture: UIGestureRecognizer){
        tappedAction?()
    }
}

extension PurchaseSubscriptionOptionView {
    struct Model {
        let title: String
        let tappedAction: () -> Void
        let isSelected: Bool
    }
    
    struct Appearance {
        let contentStackViewSpacing = Style.Spacing.standartSpacing
        let optionLabelFont = Style.Fonts.minBoldFont
        let optionImageViewSize = 23
        let selfViewCornerRadius = Style.CornerRadius.standartCornerRadius
        let selfViewBorderColor = Style.Color.grayColor
        let selfViewBorderWidth: CGFloat = 2
        let contentStackViewEdgesInsetSize = Style.Constraint.smallConstreint
    }
}

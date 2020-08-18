//
//  PurchaseSubscriptionBannerView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 02.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionBannerView: UIView {
    private lazy var appearance = Appearance()
    private var tapAction: Action?
    
    // MARK: - Content
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
    
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.titleLabelFont
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            titleLabel
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
        imageView.image = model.image
        titleLabel.text = model.title
        tapAction = model.tapAction
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
        layer.borderWidth = appearance.borderWidth
        layer.borderColor = appearance.borderColor
        layer.cornerRadius = appearance.cornerRadius
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(appearance.contentInsets)
        }
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(recognizer)
    }
    
    @objc
    private func viewTapped() {
        tapAction?()
    }
}

extension PurchaseSubscriptionBannerView {
    struct Model {
        let image: UIImage?
        let title: String
        let tapAction: Action
    }
    
    struct Appearance {
        let titleLabelFont = Style.Fonts.bigBoldFont
        let titleLabelTextColor = Style.Color.darkGrayColor
        let contentStackViewSpacing = Style.Spacing.bigSpacing
        let borderWidth: CGFloat = 2
        let cornerRadius: CGFloat = 5
        let borderColor: CGColor = Style.Color.grayColor.cgColor
        let contentInsets: UIEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
    }
}

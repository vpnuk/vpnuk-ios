//
//  PurchaseSubscriptionTooltipView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 13.12.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionTooltipView: UIView {
    private lazy var appearance = Appearance()
    
    // MARK: - Content
    
    private lazy var infoLabel: UITextView = {
        let label = UITextView()
        label.font = appearance.tooltipFont
        label.isEditable = false
        label.isScrollEnabled = false
        label.isPagingEnabled = false
        label.linkTextAttributes = appearance.attributedTextLinkColor
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let imageView = UIImageView(image: appearance.image)
        imageView.contentMode = .center
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            infoLabel
        ])
        imageView.snp.makeConstraints { make in
            make.width.equalTo(appearance.imageWidth)
        }
        
        stackView.axis = .horizontal
        stackView.spacing = appearance.imageSpacing
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
        infoLabel.attributedText = model.tooltip
    }
    
    private func setupSubviews() {
        addSubview(infoStackView)
    }
    
    private func setupConstraints() {
        infoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionTooltipView {
    struct Model {
        let tooltip: NSAttributedString
    }
    
    struct Appearance {
        let tooltipFont: UIFont = .systemFont(ofSize: 12, weight: .light)
        let image: UIImage? = UIImage(named: "ic_info")
        let imageWidth: CGFloat = 15
        let imageSpacing: CGFloat = 10
        let attributedTextLinkColor = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.18, green: 0.439, blue: 0.627, alpha: 1)
        ]
    }
}

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
        label.font = appearance.whySubscribeLabelFont
        return label
    }()
    
    // MARK: - Content
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            whySubscribeLabel,
            reasonsStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.contentStackViewSpacing
        return stackView
    }()
    
    private lazy var reasonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = appearance.reasonsStackViewSpacing
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildReasonsView(_ reasons:[Reason]) -> [UIStackView] {
        var reasonsStackViews: [UIStackView] = []
        for reason in reasons {
            let reasonLabel : UILabel = {
                let label = UILabel()
                label.font = appearance.reasonLabelFont
                return label
            }()
            
            let checkMarkImageView: UIImageView = {
                let imageView = UIImageView(image: UIImage(named: "checkmark"))
                imageView.snp.makeConstraints { (make) in
                    make.size.equalTo(appearance.checkMarkImageViewSize)
                }
                return imageView
            }()
            
            let reasonStackView: UIStackView = {
                let stackView = UIStackView(arrangedSubviews: [
                    checkMarkImageView,
                    reasonLabel
                ])
                stackView.axis = .horizontal
                stackView.spacing = appearance.reasonsStackViewSpacing
                return stackView
            }()
            
            reasonLabel.text = reason.title
            reasonsStackViews.append(reasonStackView)
        }
        return reasonsStackViews
    }
    
    func update(model: Model) {
        whySubscribeLabel.text = model.title
        let allReasons = buildReasonsView(model.reasons)
        reasonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for reason in allReasons {
            reasonsStackView.addArrangedSubview(reason)
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
    
    struct Appearance {
        let whySubscribeLabelFont = Style.Fonts.bigBoldFont
        let reasonLabelFont = Style.Fonts.standartBoldFont
        let checkMarkImageViewSize = CGSize(width: 23, height: 23)
        let contentStackViewSpacing = Style.Spacing.standartSpacing
        let reasonsStackViewSpacing = Style.Spacing.standartSpacing
    }
}

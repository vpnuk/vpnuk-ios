//
//  PurchaseSubscriptionOfferView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PurchaseSubscriptionOfferView: UIView {
    private lazy var appearance = Appearance()
    private var closeScreenAction: Action?
    // MARK: - Header
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLogoImageView,
            UIView(),
            closeButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = appearance.headerStackViewSpacing
        return stackView
    }()
    
    private lazy var headerLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "greyCross"), for: .normal)
        button.imageView?.contentMode = .center
        button.addTarget(self, action: #selector(closeTouched), for: .touchUpInside)
        return button
    }()
    // MARK: - Plans
    private lazy var choosePlansView = PurchaseSubscriptionChoosePlansView()
    
    // MARK: - Periods
    private lazy var periodsView = PurchaseSubscriptionPeriodView()
    
    // MARK: - Max users
    private lazy var maxUsersView = PurchaseSubscriptionMaxUsersView()
    
    // MARK: - Price
    private lazy var priceView = PurchaseSubscriptionPriceView()
    
    // MARK: - Advantages
    private lazy var advantagesView = PurchaseSubscriptionAdvantagesView()
    
    // MARK: - Subscription details
    private lazy var termsAndDetailsView = PurchaseSubscriptionTermsAndDetailsView()
    
    // MARK: - Content
    private lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = appearance.purchaseButtonTitleLabelFont
        button.layer.backgroundColor = appearance.purchaseButtonColor
        button.layer.cornerRadius = appearance.purchaseButtonCornerRadius
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerStackView,
            choosePlansView,
            periodsView,
            maxUsersView,
            priceView,
            purchaseButton,
            advantagesView,
            termsAndDetailsView
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.contentStackViewSpacing
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.edges.equalTo(appearance.scrollViewEdgesSize)
        }
        return scroll
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        closeScreenAction = model.closeScreenAction
        if let plansModel = model.plansModel {
            choosePlansView.isHidden = false
            choosePlansView.update(model: plansModel)
        } else {
            choosePlansView.isHidden = true
        }
        
        if let periodsModel = model.periodModel {
            periodsView.isHidden = false
            periodsView.update(model: periodsModel)
        } else {
            periodsView.isHidden = true
        }
        
        if let maxUsersModel = model.maxUsersModel {
            maxUsersView.isHidden = false
            maxUsersView.update(model: maxUsersModel)
        } else {
            maxUsersView.isHidden = true
        }
        
        if let pricesView = model.priceModel {
            priceView.isHidden = false
            priceView.update(model: pricesView)
        } else {
            priceView.isHidden = true
        }
        
        if let advantageView = model.advantagesModel {
            advantagesView.isHidden = false
            advantagesView.update(model: advantageView)
        } else {
            advantagesView.isHidden = true
        }
        
        if let termsView = model.termsDetailsModel {
            termsAndDetailsView.isHidden = false
            termsAndDetailsView.update(model: termsView)
        } else {
            termsAndDetailsView.isHidden = true
        }
        headerLogoImageView.image = model.logo
        purchaseButton.setTitle(model.purchaseButtonTitle, for: .normal)
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.contentInset = appearance.scrollViewContentInsets
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        purchaseButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(appearance.purchaseButtonHeightSize)
        }
        headerLogoImageView.snp.makeConstraints { (make) in
            make.size.equalTo(appearance.headeLogoSize)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    @objc
    private func closeTouched() {
        closeScreenAction?()
    }
}

extension PurchaseSubscriptionOfferView {
    struct Model {
        let logo: UIImage
        let closeScreenAction: Action
        let plansModel: PurchaseSubscriptionChoosePlansView.Model?
        let periodModel: PurchaseSubscriptionPeriodView.Model?
        let maxUsersModel: PurchaseSubscriptionMaxUsersView.Model?
        let priceModel: PurchaseSubscriptionPriceView.Model?
        let advantagesModel: PurchaseSubscriptionAdvantagesView.Model?
        let termsDetailsModel: PurchaseSubscriptionTermsAndDetailsView.Model?
        let purchaseButtonTitle: String
    }
    
    struct Appearance {
        // MARK: - PurchaseButton Appearance
        let purchaseButtonTitleLabelFont = Style.Fonts.bigBoldFont
        let purchaseButtonColor = Style.Color.blueColor
        let purchaseButtonCornerRadius = Style.CornerRadius.standartCornerRadius
        let purchaseButtonHeightSize = 54
        
        // MARK: - ContentStackView Appearance
        let contentStackViewSpacing: CGFloat = 16
        let contentStackViewEdgesSize = Style.Constraint.bigConstraint
        
        // MARK: - ScrollView Appearance
        let scrollViewEdgesSize = Style.Constraint.bigConstraint
        let scrollViewContentInsets = UIEdgeInsets(top: -16, left: 0, bottom: 64, right: 0)
        
        let headerStackViewSpacing = Style.Spacing.noSpacing
        let headeLogoSize = CGSize(width: 202, height: 50)
    }
}


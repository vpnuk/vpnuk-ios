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
    // MARK: - Header
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLogoImageView,
            closeButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 141
        stackView.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            //            make.width.equalTo(202)
        }
        return stackView
    }()
    private lazy var headerLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        return imageView
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "greyCross"), for: .normal)
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
        button.setTitle(NSLocalizedString("Start your 7-day free trial", comment: ""), for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = appearance.bigBoldFont
        button.layer.backgroundColor = appearance.blueColor
        button.layer.cornerRadius = appearance.standartCornerRadius
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
        stackView.spacing = appearance.bigSpacing
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(appearance.bigConstreint)
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
        headerLogoImageView.image = model.logo
        purchaseButton.titleLabel?.text = model.buttonTitle
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.contentInset = .init(top: 0, left: 0, bottom: appearance.standartConstreint, right: 0)
    }
    // MARK: - Setup Constraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(appearance.bigConstreint)
        }
        headerStackView.snp.makeConstraints { (make) in
            make.height.equalTo(headerLogoImageView.snp.height)
        }
        purchaseButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(54)
        }
        
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
        let tap = UIGestureRecognizer(target: self, action: #selector(didTapped))
        choosePlansView.addGestureRecognizer(tap)
    }
    @objc private func didTapped(){
        print("view tapped")
    }
}

extension PurchaseSubscriptionOfferView {
    struct Model {
        let logo: UIImage
        let plansModel: PurchaseSubscriptionChoosePlansView.Model?
        let periodModel: PurchaseSubscriptionPeriodView.Model?
        let maxUsersModel: PurchaseSubscriptionMaxUsersView.Model?
        let priceModel: PurchaseSubscriptionPriceView.Model?
        let advantagesModel: PurchaseSubscriptionAdvantagesView.Model?
        let termsDetailsModel: PurchaseSubscriptionTermsAndDetailsView.Model?
        let buttonTitle: String
    }
    
}


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
    
    // MARK: - Header
  private lazy var headerLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        return imageView
    }()
    private lazy var headerLogoView: UIView = {
       let view = UIView()
        addSubview(headerLogoImageView)
        headerLogoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(202)
            make.height.equalTo(50)
            make.left.equalTo(16)
            make.top.equalTo(32)
        }
        addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
              make.top.equalTo(50)
              make.left.equalTo(329)
              make.width.height.equalTo(15)
          }
         return view
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "greyCross"), for: .normal)
        //        button.addTarget(self, action: #selector(), for: .touchUpInside)
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
    
    // MARK: - Purchase
    
    private lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start your 7-day free trial", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        button.layer.backgroundColor = UIColor(red: 0.18, green: 0.439, blue: 0.627, alpha: 1).cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    // MARK: - Advantages
    
    private lazy var advantagesView = PurchaseSubscriptionAdvantagesView()
    
    // MARK: - Subscription details
    
    private lazy var termsAndDetailsView = PurchaseSubscriptionTermsAndDetailsView()
    
    // MARK: - Content
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLogoView,
            choosePlansView,
            periodsView,
            maxUsersView,
            priceView,
            purchaseButton,
            advantagesView,
            termsAndDetailsView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        addSubview(purchaseButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
  
        headerLogoView.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.top.equalTo(27)
            make.height.equalTo(headerLogoImageView.snp.height)
            
        }
        choosePlansView.snp.makeConstraints { (make) in
            make.top.equalTo(headerLogoView.snp.bottom).offset(22)
            make.left.equalToSuperview()
            make.height.equalTo(234)
        }
        periodsView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(choosePlansView.snp.bottom).offset(16)
            make.height.equalTo(80)
        }
        maxUsersView.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.top.equalTo(periodsView.snp.bottom).offset(16)
            make.height.equalTo(80)
        }
        priceView.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.top.equalTo(maxUsersView.snp.bottom).offset(16)
        }
        
        purchaseButton.snp.makeConstraints { (make) in
            make.width.equalTo(315)
            make.height.equalTo(54)
            make.bottom.equalTo(-11)
            make.left.equalTo(29)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionOfferView {
    struct Model {
        let logo: UIImage
        let plansModel: PurchaseSubscriptionChoosePlansView.Model
        
    }
    
}


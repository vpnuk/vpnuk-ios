//
//  ChooseCountryView.swift
//  Purchase
//
//  Created by Александр Умаров on 24.07.2020.
//  Copyright © 2020 Александр Умаров. All rights reserved.
//

import UIKit
class PurchaseSubscriptionChooseCountryView: UIView {
    private lazy var appearance = Appearance()
    private lazy var countryView = PurchaseSubscriptionChoosePlanView()
    // MARK: - Header
    var headerLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        return label
    }()
    // MARK: - Content
    private lazy var chooseButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Choose", comment: ""), for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = appearance.bigBoldFont
        button.layer.backgroundColor = appearance.blueColor
        button.layer.cornerRadius = appearance.standartCornerRadius
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            countryView
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.noSpacing
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
        chooseButton.titleLabel?.text = model.buttonTitle
    }
    
    private func setupSubviews() {
        addSubview(headerLabel)
        addSubview(contentStackView)
        addSubview(chooseButton)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.left.equalTo(appearance.bigConstreint)
            make.top.equalTo(headerLabel.snp.bottom).offset(77)
        }
        headerLabel.snp.makeConstraints{ make in
            make.left.equalTo(appearance.bigConstreint)
            make.top.equalTo(40)
        }
        chooseButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(appearance.standartConstreint)
            make.bottom.equalTo(-11)
            make.height.equalTo(54)
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
}

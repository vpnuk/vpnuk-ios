//
//  ChooseCountryView.swift
//  Purchase
//
//  Created by Александр Умаров on 24.07.2020.
//  Copyright © 2020 Александр Умаров. All rights reserved.
//

import UIKit
class PurchaseSubscriptionChooseCountryView: UIView {
    
    let countryView = PurchaseSubscriptionChoosePlanView()
    // MARK: - Header
  var headerLabel : UILabel = {
      let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .darkGray
      label.text = """
    Choose country of your
    dedicated server
    """
      label.font = UIFont.boldSystemFont(ofSize: 20.0)
      
      return label
  }()
    // MARK: - Content
    private lazy var chooseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Choose", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        button.layer.backgroundColor = UIColor(red: 0.18, green: 0.439, blue: 0.627, alpha: 1).cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            countryView
        ])
        stackView.axis = .vertical
        stackView.spacing = 0
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

    }
    
    private func setupSubviews() {
        addSubview(headerLabel)
        addSubview(contentStackView)
        addSubview(chooseButton)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.top.equalTo(headerLabel.snp.bottom).offset(77)
        }
        headerLabel.snp.makeConstraints{ make in
            make.left.equalTo(32)
            make.top.equalTo(40)
        }
        chooseButton.snp.makeConstraints { (make) in
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

extension PurchaseSubscriptionChooseCountryView {
    struct Model {
        let title: String
    }
}

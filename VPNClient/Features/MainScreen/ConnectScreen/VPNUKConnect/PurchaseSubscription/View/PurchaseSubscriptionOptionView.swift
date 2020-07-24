//
//  PurchaseSubscriptionOptionView.swift
//  Purchase
//
//  Created by Александр Умаров on 24.07.2020.
//  Copyright © 2020 Александр Умаров. All rights reserved.
//

import UIKit

class PurchaseSubscriptionOptionView: UIView {
  
    // MARK: - Content
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
           optionImageView,
           optionLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    var optionImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "unchecked.pdf"))
        return imageView
    }()

    var optionLabel : UILabel = {
        let label = UILabel()
        label.text = "text"
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        return label
    }()
    
    private lazy var optionView: UIView = {
        let view = UIView()
        
        // MARK: - OptionView setup
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.569, green: 0.569, blue: 0.569, alpha: 1).cgColor
        return view
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
        addSubview(contentStackView)
        addSubview(optionView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(8)
        }
        optionView.snp.makeConstraints { (make) in
            make.width.equalTo(contentStackView.snp.width).offset(16)
            make.height.equalTo(contentStackView.snp.height).offset(16)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionOptionView {
    struct Model {
        let title: String
    }
}

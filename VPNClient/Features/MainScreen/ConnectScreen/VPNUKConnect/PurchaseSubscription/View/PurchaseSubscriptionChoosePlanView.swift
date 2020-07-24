//
//  PurchaseSubscriptionChoosePlanView.swift
//  Purchase
//
//  Created by Александр Умаров on 23.07.2020.
//  Copyright © 2020 Александр Умаров. All rights reserved.
//

import UIKit
class PurchaseSubscriptionChoosePlanView: UIView {
    // MARK: - Content
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            planLabel,
            detailLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
  
    var planMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "unchecked.pdf"))
        
        return imageView
    }()
    var planLabel : UILabel = {
        let label = UILabel()
        label.text = "Text"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        return label
    }()
    
    var detailLabel : UILabel = {
        let label = UILabel()
        label.text = "Text"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    
    // MARK: - Model View
    private lazy var planView: UIView = {
        let view = UIView()
        
        // MARK: - PlanView setup
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
        addSubview(planView)
        addSubview(planMarkImageView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(planMarkImageView.snp.right).offset(16)
        }
        planView.snp.makeConstraints { (make) in
            make.width.equalTo(311)
            make.height.equalTo(75)
        }
        planMarkImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(23)
            make.top.equalTo(26)
                make.left.equalTo(16)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionChoosePlanView {
    struct Model {
        let title: String
        let subTitle: String
        let image: UIImage
    }
}

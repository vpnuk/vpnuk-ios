//
//  PurchaseSubscriptionChoosePlanView.swift
//  Purchase
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit
class PurchaseSubscriptionChoosePlanView: UIView {
    private lazy var appearance = Appearance()
    // MARK: - Content
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            planLabel,
            detailLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.smallSpacing
        return stackView
    }()
    
    var planMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "unchecked.pdf"))
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(23)}
        
        return imageView
    }()
    
    var flagImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "au1"))
        
        return imageView
    }()
    var planLabel : UILabel = {
        let label = UILabel()
        label.text = "text"
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
        view.layer.cornerRadius = appearance.standartCornerRadius
        view.layer.borderWidth = 2
        view.layer.borderColor = appearance.grayColor
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
        planLabel.text = model.title
        detailLabel.text = model.subTitle
        flagImageView.image = model.imageFlag
        planMarkImageView.image = model.isSelected
            ? UIImage(named: "checked.pdf")
            : UIImage(named: "unchecked.pdf")
        
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
        addSubview(planView)
        addSubview(planMarkImageView)
        addSubview(flagImageView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { (make) in
            make.top.equalTo(appearance.standartConstreint)
            make.left.equalTo(planMarkImageView.snp.right).offset(appearance.standartConstreint)
            make.height.equalToSuperview().inset(13)
        }
        planView.snp.makeConstraints { (make) in
            make.width.equalTo(311)
            make.height.equalTo(75)
        }
        
        planMarkImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(appearance.standartConstreint)
        }
        flagImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(255)
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
        let imageFlag: UIImage
        var isSelected: Bool
        
    }
}

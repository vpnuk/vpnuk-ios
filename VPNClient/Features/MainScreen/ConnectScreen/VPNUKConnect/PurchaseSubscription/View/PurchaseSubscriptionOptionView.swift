//
//  PurchaseSubscriptionOptionView.swift
//  Purchase
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit

class PurchaseSubscriptionOptionView: UIView {
    private lazy var appearance = Appearance()
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
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        for option in model.options {
            optionLabel.text = option.title
        }
        
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
        self.layer.cornerRadius = appearance.standartCornerRadius
        self.layer.borderWidth = 2
        self.layer.borderColor = appearance.grayColor
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(appearance.standartSpacing)
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
        let options: [Option]
    }
    
    struct Option {
        let title: String
    }
}

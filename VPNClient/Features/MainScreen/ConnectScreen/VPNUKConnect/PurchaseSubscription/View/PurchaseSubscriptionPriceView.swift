//
//  PurchaseSubscriptionPriceView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionPriceView: UIView {
    
    
    // MARK: - Content
    
    var totalPriceLabel : UILabel = {
        let label = UILabel()
        label.text = "Total Price:"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        return label
    }()
    
    var moneySumLabel : UILabel = {
        let label = UILabel()
        label.text = "10$"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            totalPriceLabel,
            moneySumLabel
        ])
        stackView.axis = .horizontal
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
        addSubview(contentStackView)
        addSubview(moneySumLabel)
        addSubview(totalPriceLabel)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }
        totalPriceLabel.snp.makeConstraints { (make) in
            make.width.equalTo(119)
            make.height.equalTo(28)
        }
        moneySumLabel.snp.makeConstraints { (make) in
            make.width.equalTo(41)
            make.height.equalTo(28)
            make.left.equalTo(totalPriceLabel.snp.right).offset(-14)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionPriceView {
    struct Model {
        let title: String
    }
}

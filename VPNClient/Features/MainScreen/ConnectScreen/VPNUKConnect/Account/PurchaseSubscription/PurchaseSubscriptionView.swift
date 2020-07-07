//
//  PurchaseSubscriptionView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionView: UIView {
    
    private lazy var connectButton: UIButton =  {
        let button = UIButton()
        button.layer.cornerRadius = 25
        
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = .init(width: 0, height: 2)
        button.layer.shadowRadius = 2
        
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        button.addTarget(self, action: #selector(purchaseTouched), for: .touchUpInside)
        button.setTitle(NSLocalizedString("Purchase subscription", comment: ""), for: .normal)
        button.backgroundColor = .systemGreen
        return button
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
        addSubview(connectButton)
    }
    
    private func setupConstraints() {
        connectButton.makeEdgesEqualToSuperview()
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    @objc
    private func purchaseTouched() {
        
    }
}

extension PurchaseSubscriptionView {
    struct Model {
        let title: String
    }
}

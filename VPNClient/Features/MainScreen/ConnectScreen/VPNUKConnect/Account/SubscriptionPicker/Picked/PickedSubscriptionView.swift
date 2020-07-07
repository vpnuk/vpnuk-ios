//
//  PickedSubscriptionView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PickedSubscriptionView: UIView {
    
    private lazy var pickedSubscriptionInfoView = PickedSubscriptionInfoView()
    private lazy var pickedSubscriptionDedicatedServerView = PickedSubscriptionDedicatedServerView()
    private lazy var pickedSubscriptionVPNAccountView = PickedSubscriptionVPNAccountView()
    
    private lazy var contentView: UIView = {
         let stackView = UIStackView(arrangedSubviews: [
             pickedSubscriptionInfoView,
             pickedSubscriptionDedicatedServerView,
             pickedSubscriptionVPNAccountView
         ])
         stackView.axis = .vertical
         stackView.spacing = 0
         return stackView.contained(with: .zero)
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
        addSubview(contentView)
        contentView.makeDefaultShadowAndCorners()
    }
    
    private func setupConstraints() {
        contentView.makeEdgesEqualToSuperview()
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}


extension PickedSubscriptionView {
    struct Model {
        let subscriptionModel: PickedSubscriptionInfoView.Model
        let dedicatedServerModel: PickedSubscriptionDedicatedServerView.Model?
        let pickedVPNAccountModel: PickedSubscriptionVPNAccountView.Model?
    }
}

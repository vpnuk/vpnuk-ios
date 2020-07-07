//
//  PickedSubscriptionInfoView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PickedSubscriptionInfoView: UIView {
    
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
        
    }
    
    private func setupConstraints() {
        
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}


extension PickedSubscriptionInfoView {
    struct Model {
        let title: String
        let vpnAccountsQuantity: Int?
        let maxSessions: Int?
        let subscriptionStatus: SubscriptionStatus
        let periodMonths: Int?
        let trialEnd: Date?
    }
}

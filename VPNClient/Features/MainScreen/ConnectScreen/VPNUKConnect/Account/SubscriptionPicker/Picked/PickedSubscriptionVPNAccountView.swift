//
//  PickedSubscriptionVPNAccountView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PickedSubscriptionVPNAccountView: UIView {
    
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


extension PickedSubscriptionVPNAccountView {
    struct Model {
        let username: String
        let password: String
        let info: String?
    }
}

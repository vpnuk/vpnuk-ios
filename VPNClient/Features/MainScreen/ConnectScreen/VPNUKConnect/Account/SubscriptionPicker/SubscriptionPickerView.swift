//
//  SubscriptionPickerView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class SubscriptionPickerView: UIView {
    private lazy var pickedView = PickedSubscriptionView()
    private lazy var notPickedView = NotPickedSubscriptionView()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(withState state: State) {
        switch state {
        case .picked(let model):
            notPickedView.removeFromSuperview()
            addSubview(pickedView)
            pickedView.makeEdgesEqualToSuperview()
            
            pickedView.update(model: model)
        case .notPicked(let model):
            pickedView.removeFromSuperview()
            addSubview(notPickedView)
            notPickedView.makeEdgesEqualToSuperview()
            
            notPickedView.update(model: model)
        }
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


extension SubscriptionPickerView {
    enum State {
        case picked(subscriptionModel: PickedSubscriptionView.Model)
        case notPicked(notPickedModel: NotPickedSubscriptionView.Model)
    }
}

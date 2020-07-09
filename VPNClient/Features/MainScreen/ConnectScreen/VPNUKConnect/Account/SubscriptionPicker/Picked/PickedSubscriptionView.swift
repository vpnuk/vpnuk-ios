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
    private var tapAction: Action?
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = NSLocalizedString("Selected subscription:", comment: "")
        return label
    }()
       
    private lazy var pickedSubscriptionInfoView = PickedSubscriptionInfoView()
    private lazy var pickedSubscriptionDedicatedServerView = PickedSubscriptionDedicatedServerView()
    private lazy var pickedSubscriptionVPNAccountView = PickedSubscriptionVPNAccountView()
    
    private lazy var contentView: UIView = {
        
        let innerStackView = UIStackView(arrangedSubviews: [
            pickedSubscriptionInfoView,
            pickedSubscriptionDedicatedServerView,
            pickedSubscriptionVPNAccountView
        ])
        innerStackView.axis = .vertical
        innerStackView.spacing = 0
        
        let innerView = innerStackView.contained(with: .zero)
        innerView.backgroundColor = .white
        innerView.makeDefaultShadowAndCorners()
        
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel,
            innerView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 5
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
        tapAction = model.tapAction
        pickedSubscriptionInfoView.update(model: model.subscriptionModel)
        
        if let dedicatedServerModel = model.dedicatedServerModel {
            pickedSubscriptionDedicatedServerView.update(model: dedicatedServerModel)
            pickedSubscriptionDedicatedServerView.isHidden = false
        } else {
            pickedSubscriptionDedicatedServerView.isHidden = true
        }
        
        if let pickedVPNAccountModel = model.pickedVPNAccountModel {
            pickedSubscriptionVPNAccountView.update(model: pickedVPNAccountModel)
            pickedSubscriptionVPNAccountView.isHidden = false
        } else {
            pickedSubscriptionVPNAccountView.isHidden = true
        }
        
        
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        addSubview(contentView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        contentView.addGestureRecognizer(tap)
    }
    
    @objc
    private func viewTapped() {
        tapAction?()
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
        let tapAction: Action
    }
}

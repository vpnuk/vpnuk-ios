//
//  SubscriptionTableViewCell.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 08.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SubscriptionTableViewCell: UITableViewCell {
    private lazy var pickedSubscriptionInfoView = PickedSubscriptionInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    
    private func setupSubviews() {
        contentView.addSubview(pickedSubscriptionInfoView)
    }
    
    private func setupConstraints() {
        pickedSubscriptionInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func update(model: Model) {
        pickedSubscriptionInfoView.update(model: model.subscriptionModel)
    }
    
}

extension SubscriptionTableViewCell {
    struct Model {
        let subscriptionModel: PickedSubscriptionInfoView.Model
    }
}

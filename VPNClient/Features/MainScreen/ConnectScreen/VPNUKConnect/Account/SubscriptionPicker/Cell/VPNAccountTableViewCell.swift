//
//  VPNAccountTableViewCell.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 08.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class VPNAccountTableViewCell: UITableViewCell {
    private lazy var pickedSubscriptionDedicatedServerView = PickedSubscriptionDedicatedServerView()
    private lazy var pickedSubscriptionVPNAccountView = PickedSubscriptionVPNAccountView(appearance: .init(shouldShowBg: false))
    
    // MARK: Content
    
    private lazy var contentStackView: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: ""))
        imageView.contentMode = .center
        
        let stackView = UIStackView(arrangedSubviews: [
            pickedSubscriptionVPNAccountView,
            pickedSubscriptionDedicatedServerView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
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
        contentView.addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
    func update(model: Model) {
        pickedSubscriptionVPNAccountView.update(model: model.vpnAccountModel)
        if let serverModel = model.dedicatedServerModel {
            pickedSubscriptionDedicatedServerView.update(model: serverModel)
        }
        pickedSubscriptionDedicatedServerView.isHidden = model.dedicatedServerModel == nil
    }
    
}

extension VPNAccountTableViewCell {
    struct Model {
        let vpnAccountModel: PickedSubscriptionVPNAccountView.Model
        let dedicatedServerModel: PickedSubscriptionDedicatedServerView.Model?
    }
}

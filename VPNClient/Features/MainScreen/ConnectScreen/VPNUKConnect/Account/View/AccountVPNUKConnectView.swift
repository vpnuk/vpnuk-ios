//
//  AccountVPNUKConnectView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol AccountVPNUKConnectViewProtocol: class {
    func updateSubscriptionPicker(withState state: SubscriptionPickerView.State)
}

class AccountVPNUKConnectView: UIView {
    private let viewModel: AccountVPNUKConnectViewModelProtocol
    
    private lazy var purchaseSubscriptionView = PurchaseSubscriptionView()
    private lazy var subscriptionPickerView = SubscriptionPickerView()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                subscriptionPickerView,
                purchaseSubscriptionView
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    init(viewModel: AccountVPNUKConnectViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension AccountVPNUKConnectView: AccountVPNUKConnectViewProtocol {
    func updateSubscriptionPicker(withState state: SubscriptionPickerView.State) {
        subscriptionPickerView.update(withState: state)
    }
}

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

protocol AccountVPNUKConnectViewProtocol: AnyObject, LoaderPresentable {
    func updateSubscriptionPicker(withState state: SubscriptionPickerView.State)
    func updateServerPicker(state: ServerPickerView.State, action: @escaping Action)
}

class AccountVPNUKConnectView: UIView {
    private let viewModel: AccountVPNUKConnectViewModelProtocol
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemRed, for: .normal)
        button.setTitle(NSLocalizedString("Sign Out", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    private lazy var purchaseSubscriptionView = PurchaseSubscriptionView()
    private lazy var subscriptionPickerView = SubscriptionPickerView()
    // server picker
    private lazy var serverPickerView: ServerPickerView = {
        let view = ServerPickerView()
        return view
    }()
   
    private lazy var subscriptionAndServerPickerStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                subscriptionPickerView,
                serverPickerView
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                subscriptionAndServerPickerStackView,
                purchaseSubscriptionView,
                signOutButton
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 16
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
    
    @objc
    private func signOut() {
        viewModel.signOut()
    }
}

extension AccountVPNUKConnectView: AccountVPNUKConnectViewProtocol {
    func updateSubscriptionPicker(withState state: SubscriptionPickerView.State) {
        subscriptionPickerView.update(withState: state)
    }
    
    func updateServerPicker(state: ServerPickerView.State, action: @escaping Action) {
        serverPickerView.state = state
        serverPickerView.viewTappedAction = action
    }
    
}

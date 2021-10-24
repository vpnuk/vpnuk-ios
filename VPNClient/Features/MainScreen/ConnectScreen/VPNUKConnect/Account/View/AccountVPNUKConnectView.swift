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

protocol AccountVPNUKConnectViewProtocol: LoaderPresentable {
    func updateSubscriptionPicker(withState state: SubscriptionPickerView.State)
    func updateServerPicker(state: ServerPickerView.State, action: @escaping Action)
    func updatePurchaseSubscriptionBanner(model: PurchaseSubscriptionBannerView.Model?)
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
    
    
    private lazy var purchaseSubscriptionContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        view.addSubview(purchaseSubscriptionView)
        purchaseSubscriptionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        return view
    }()
    
    private lazy var purchaseSubscriptionView: PurchaseSubscriptionBannerView = {
        let view = PurchaseSubscriptionBannerView()
        return view
    }()
    
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
                purchaseSubscriptionContainer,
                subscriptionAndServerPickerStackView,
                signOutButton
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return scroll
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
        addSubview(scrollView)
        scrollView.contentInset = .init(top: 6, left: 0, bottom: 16, right: 0)
    }
    
    private func setupConstraints() {
        scrollView.makeEdgesEqualToSuperview()
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalTo(self)
            make.width.equalTo(self).inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
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
    
    func updatePurchaseSubscriptionBanner(model: PurchaseSubscriptionBannerView.Model?) {
        if let model = model {
            purchaseSubscriptionView.update(model: model)
            purchaseSubscriptionContainer.isHidden = false
        } else {
            purchaseSubscriptionContainer.isHidden = true
        }
    }
    
}

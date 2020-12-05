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
    
    private let appearance = Appearance()
    
    private var renewSubscriptionAction: Action?
    
    // MARK: Title and type
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var titleTypeStackView: UIStackView = {
        let typeContainer = typeLabel.contained(with: .init(top: 5, left: 5, bottom: 5, right: 5))
        typeContainer.backgroundColor = .init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)
        typeContainer.layer.cornerRadius = 15
        
        let typeStackView = UIStackView(arrangedSubviews: [
            typeContainer,
            UIView() // spacer
        ])
        typeStackView.axis = .vertical
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            typeStackView
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Vpn accounts quantity
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("VPN accounts count:", comment: "")
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var quantityValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var quantityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            quantityLabel,
            quantityValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Vpn max sessions
    
    private lazy var maxSessionsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = NSLocalizedString("Max concurrent sessions:", comment: "")
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var maxSessionsValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var maxSessionsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            maxSessionsLabel,
            maxSessionsValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Subscription status
    
    private lazy var subscriptionStatusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = NSLocalizedString("Subscription status:", comment: "")
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var subscriptionStatusValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var subscriptionStatusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            subscriptionStatusLabel,
            subscriptionStatusValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Subscription period
    
    private lazy var subscriptionPeriodLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = NSLocalizedString("Subscription period (months):", comment: "")
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var subscriptionPeriodValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var subscriptionPeriodStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            subscriptionPeriodLabel,
            subscriptionPeriodValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Trial end
    
    private lazy var trialEndLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = NSLocalizedString("Trial end:", comment: "")
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var trialEndValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var trialEndTimeLeftLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private lazy var trialEndStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            trialEndLabel,
            trialEndValueLabel,
            trialEndTimeLeftLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Renew subscription
    
    private lazy var renewSubscriptionButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = appearance.chooseButtonTitleFont
        button.layer.backgroundColor = appearance.chooseButtonColor.cgColor
        button.layer.cornerRadius = appearance.chooseButtonCornerRadius
        button.addTarget(self, action: #selector(renewSubscriptionTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var renewSubscriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            renewSubscriptionButton
        ])
        stackView.axis = .vertical
        stackView.isHidden = true
        return stackView
    }()
    
    
    // MARK: Content view
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleTypeStackView,
            quantityStackView,
            maxSessionsStackView,
            subscriptionStatusStackView,
            subscriptionPeriodStackView,
            trialEndStackView,
            renewSubscriptionStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 0
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
        titleLabel.text = model.title
        typeLabel.text = model.subscriptionType.localizedValue
        
        if let quantity = model.vpnAccountsQuantity {
            quantityValueLabel.text = "\(quantity)"
        }
        quantityStackView.isHidden = model.vpnAccountsQuantity == nil
        
        if let maxSessions = model.maxSessions {
            maxSessionsValueLabel.text = "\(maxSessions)"
        }
        maxSessionsStackView.isHidden = model.maxSessions == nil
        
        subscriptionStatusValueLabel.text = model.subscriptionStatus.localizedValue
        subscriptionStatusValueLabel.textColor = model.subscriptionStatus.color
        
        if let subscriptionPeriod = model.periodMonths {
            subscriptionPeriodValueLabel.text = "\(subscriptionPeriod)"
        }
        subscriptionPeriodStackView.isHidden = model.periodMonths == nil
        
        if let trialEnd = model.trialEnd {
            trialEndValueLabel.text = "\(trialEnd)"
        }
        trialEndStackView.isHidden = model.trialEnd == nil
        
        if let renewSubscriptionModel = model.renewSubscriptionModel {
            renewSubscriptionButton.setTitle(renewSubscriptionModel.title, for: .normal)
            renewSubscriptionAction = renewSubscriptionModel.action
            renewSubscriptionStackView.isHidden = false
        } else {
            renewSubscriptionStackView.isHidden = true
        }
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    @objc
    private func renewSubscriptionTouched() {
        renewSubscriptionAction?()
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
        let subscriptionType: SubscriptionType
        let renewSubscriptionModel: RenewSubscriptionModel?
    }
    
    struct RenewSubscriptionModel {
        let title: String
        let action: Action
    }
    
    struct Appearance {
        // MARK: - ChooseButton Appearance
        let chooseButtonTitleFont = Style.Fonts.bigBoldFont
        let chooseButtonColor = Style.Color.blueColor
        let chooseButtonDisabledColor = Style.Color.grayColor
        let chooseButtonCornerRadius = Style.CornerRadius.standartCornerRadius
        let chooseButtonLeftRightInsetSize = Style.Constraint.standartConstreint
        let chooseButtonBottomSize = -11
        let chooseButtonHeightSize = 54
    }
}

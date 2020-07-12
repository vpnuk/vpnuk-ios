//
//  PickedSubscriptionDedicatedServerView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PickedSubscriptionDedicatedServerView: UIView {
    
    // MARK: Title
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Your dedicated server info:", comment: "")
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 1
        return label
    }()
    
    
    // MARK: Address
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Address:", comment: "")
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var addressValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            addressLabel,
            addressValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Location
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Location:", comment: "")
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var locationValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            locationLabel,
            locationValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    
    // MARK: Content
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            addressStackView,
            locationStackView
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
        addressValueLabel.text = model.ip
        locationValueLabel.text = model.location
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
}


extension PickedSubscriptionDedicatedServerView {
    struct Model {
        let title: String?
        let ip: String
        let location: String?
    }
}

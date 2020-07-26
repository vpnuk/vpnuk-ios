//
//  PurchaseSubscriptionOptionsView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionMaxUsersView: UIView {
    private lazy var appearance = Appearance()
    let optionView = PurchaseSubscriptionOptionView()
    // MARK: - Content
    
    private lazy var maxUsersQuastionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "questionMark.pdf"), for: .normal)
        return button
    }()
    
    var maxUsersLabel : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            maxUsersLabel,
            maxUsersQuastionButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = appearance.standartSpacing
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            labelStackView,
            optionView
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.standartSpacing
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
        maxUsersLabel.text = model.title
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
        
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.height.equalToSuperview().inset(appearance.standartConstreint)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionMaxUsersView {
    struct Model {
        let title: String
        let options: [Option]
        let selectedOptionIndex: Int?
        let optionSelectedAction: (_ index: Int) -> Void
    }
    
    struct Option {
        let title: String
    }
}

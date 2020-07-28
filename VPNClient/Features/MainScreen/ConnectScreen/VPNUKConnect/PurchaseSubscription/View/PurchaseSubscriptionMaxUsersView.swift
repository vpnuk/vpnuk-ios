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
    private var optionSelectedAction: ((_ index: Int) -> Void)?
    // MARK: - Content
    
    private lazy var maxUsersQuastionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "questionMark.pdf"), for: .normal)
        return button
    }()
    
    private lazy var maxUsersLabel : UILabel = {
        let label = UILabel()
        label.textColor = appearance.maxUsersLabelTextLabelColor
        label.font = appearance.maxUsersLabelFont
        
        return label
    }()
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            maxUsersLabel,
            maxUsersQuastionButton,
        ])
        stackView.axis = .horizontal
        stackView.spacing = appearance.labelStackViewSpacing
        return stackView
    }()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            labelStackView,
            optionsStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.contentStackViewSpacing
        return stackView
    }()
    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            
        ])
        stackView.axis = .horizontal
        stackView.spacing = appearance.contentStackViewSpacing
        return stackView
    }()
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildOptionViews(fromOption options: [Option], selectedIndex: Int?) -> [PurchaseSubscriptionOptionView] {
        let optionsViews = options.enumerated().map { index,option -> PurchaseSubscriptionOptionView in
            let optionView = PurchaseSubscriptionOptionView()
            optionView.update(model: .init(title: option.title, tappedAction: { [weak self] in
                self?.optionSelectedAction?(index)
                }, isSelected: selectedIndex == index))
            return optionView
        }
        return optionsViews
    }
    
    func update(model: Model) {
        optionSelectedAction = model.optionSelectedAction
        maxUsersLabel.text = NSLocalizedString("\(model.title)", comment: "")
        let newOptionsView = buildOptionViews(fromOption: model.options, selectedIndex: model.selectedOptionIndex)
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for optionView in newOptionsView {
            optionsStackView.addArrangedSubview(optionView)
        }
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
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
    struct Appearance {
        //MARK: - MaxUsers Appearance
        let maxUsersLabelFont = Style.Fonts.standartBoldFont
        let maxUsersLabelTextLabelColor = Style.Color.darkGrayColor
        
        //MARK: - StackViews Appearance
        let labelStackViewSpacing = Style.Spacing.standartSpacing
        let contentStackViewSpacing = Style.Spacing.smallSpacing
        let contentStackViewHieghtInsetConstraint = Style.Constraint.standartConstreint
    }
}

//
//  ChooseCountryView.swift
//  VPNClient
//
//  Created by Александр Умаров on 24.07.2020.
//  Copyright © 2020 Александр Умаров. All rights reserved.
//

import UIKit
class PurchaseSubscriptionChooseCountryView: UIView {
    private lazy var appearance = Appearance()
    private var countrySelectedAction: ((_ index: Int) -> Void)?
    private lazy var countryView = PurchaseSubscriptionChoosePlanView()
    
    // MARK: - Header
    private lazy var headerLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = appearance.headerLabelNumberOfLines
        label.textColor = .darkGray
        label.font = appearance.headerLabelFont
        
        return label
    }()
    // MARK: - Content
    private lazy var chooseButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = appearance.chooseButtonTitleFont
        button.layer.backgroundColor = appearance.chooseButtonColor
        button.layer.cornerRadius = appearance.chooseButtonCornerRadius
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        ])
        stackView.axis = .vertical
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
    func buildCountyViews(fromCountries countries: [Country], selectedIndex: Int?) -> [PurchaseSubscriptionChoosePlanView] {
           let countriesViews = countries.enumerated().map { index,country -> PurchaseSubscriptionChoosePlanView in
               let countyView = PurchaseSubscriptionChoosePlanView()
               let appearance = PurchaseSubscriptionChoosePlanView.Appearance()
               let isFirstCounty = index == 0
               let isLastCounty = index == countries.count - 1
               let haveOnlyOneCounty = countries.count == 1
               if haveOnlyOneCounty {
                   countyView.layer.cornerRadius = appearance.selfViewCornerRadius
                   countyView.layer.borderWidth = appearance.selfViewBorderWidth
                   countyView.layer.borderColor = appearance.selfViewBorderColor
               } else { if isFirstCounty {
                   countyView.layer.cornerRadius = appearance.selfViewCornerRadius
                   countyView.layer.maskedCorners = appearance.isFirst
                   countyView.layer.borderWidth = appearance.selfViewBorderWidth
                   countyView.layer.borderColor = appearance.selfViewBorderColor
               } else if isLastCounty {
                   countyView.layer.cornerRadius = appearance.selfViewCornerRadius
                   countyView.layer.maskedCorners = appearance.isLast
                   countyView.layer.borderWidth = appearance.selfViewBorderWidth
                   countyView.layer.borderColor = appearance.selfViewBorderColor
               } else { countyView.showBorderViews(value: false) }
               }
            countyView.update(model: .init(title: country.title, subTitle: nil, imageFlag: country.imageFlag, isSelected: selectedIndex == index, tappedAction: { [weak self] in
                   self?.countrySelectedAction?(index)
               }))
               return countyView
           }
           return countriesViews
       }
    
    func update(model: Model) {
        let newCountriesView = buildCountyViews(fromCountries: model.countries, selectedIndex: model.selectedCountryIndex)
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for countyView in newCountriesView {
            contentStackView.addArrangedSubview(countyView)
        }
        headerLabel.text = model.title
        chooseButton.setTitle("\(model.chooseButtonTitle)", for: .normal)
    }
    
    private func setupSubviews() {
        addSubview(headerLabel)
        addSubview(contentStackView)
        addSubview(chooseButton)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.left.equalTo(appearance.contentStackViewLeftConstraint)
            make.top.equalTo(headerLabel.snp.bottom).offset(appearance.contentStackViewTopOffsetConstraint)
            make.right.equalTo(-appearance.contentStackViewLeftConstraint)
        }
        headerLabel.snp.makeConstraints{ make in
            make.left.equalTo(appearance.headerLabelLeftConstraint)
            make.right.equalTo(-appearance.headerLabelLeftConstraint)
            make.top.equalTo(appearance.headerLabelTopConstraint)
            
            
        }
        chooseButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(appearance.chooseButtonLeftRightInsetConstraint)
            make.bottom.equalTo(appearance.chooseButtonBottomConstraint)
            make.height.equalTo(appearance.chooseButtonHeightConstraint)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionChooseCountryView {
    struct Model {
          let title: String
          let countries: [Country]
          let selectedCountryIndex: Int?
          let countrySelectedAction: (_ index: Int) -> Void
          let chooseButtonTitle: String
      }
      struct Country {
          let title: String
          let imageFlag: UIImage
      }
    struct Appearance {
        // MARK: - Header Appearance
        let headerLabelNumberOfLines = 0
        let headerLabelFont = Style.Fonts.bigBoldFont
        let headerLabelLeftConstraint = Style.Constraint.bigConstraint
        let headerLabelTopConstraint = Style.Constraint.bigConstraint
        
        // MARK: - ChooseButton Appearance
        let chooseButtonTitleFont = Style.Fonts.bigBoldFont
        let chooseButtonColor = Style.Color.blueColor
        let chooseButtonCornerRadius = Style.CornerRadius.standartCornerRadius
        let chooseButtonLeftRightInsetConstraint = Style.Constraint.standartConstreint
        let chooseButtonBottomConstraint = -11
        let chooseButtonHeightConstraint = 54
        
        // MARK: - ContentStackView Appearance
        let contentStackViewSpacing = Style.Spacing.noSpacing
        let contentStackViewLeftConstraint = Style.Constraint.bigConstraint
        let contentStackViewTopOffsetConstraint = 77
    }
}

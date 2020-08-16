//
//  ChooseCountryView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//
import UIKit
class PurchaseSubscriptionChooseCountryView: UIView {
    private lazy var appearance = Appearance()
    private var countrySelectedAction: ((_ index: Int) -> Void)?
    private var chooseAction: Action?
    private var closeAction: Action?
    
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
        button.layer.backgroundColor = appearance.chooseButtonColor.cgColor
        button.layer.cornerRadius = appearance.chooseButtonCornerRadius
        button.addTarget(self, action: #selector(chooseTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "greyCross"), for: .normal)
        button.imageView?.contentMode = .center
        button.addTarget(self, action: #selector(closeTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
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
    
    func buildCountryViews(fromCountries countries: [Country], selectedIndex: Int?) -> [PurchaseSubscriptionChoosePlanView] {
        let countriesViews = countries.enumerated().map { index,country ->
            PurchaseSubscriptionChoosePlanView in
            var countryAppearance: PurchaseSubscriptionChoosePlanView.Appearance
            let isFirstCountry = index == 0
            let isLastCountry = index == countries.count - 1
            let haveOnlyOneCountry = countries.count == 1
            if haveOnlyOneCountry {
                countryAppearance = PurchaseSubscriptionChoosePlanView.Appearance.oneItemAppearance
            } else { if isFirstCountry {
                countryAppearance = PurchaseSubscriptionChoosePlanView.Appearance.firstItemAppearance
            } else if isLastCountry {
                countryAppearance = PurchaseSubscriptionChoosePlanView.Appearance.lastItemAppearance
            } else {
                countryAppearance = PurchaseSubscriptionChoosePlanView.Appearance.middleItemAppearance
                }
            }
            let countryView = PurchaseSubscriptionChoosePlanView(appearance: countryAppearance)
            
            countryView.update(
                model: .init(
                    title: country.title,
                    subTitle: nil,
                    imageFlag: country.imageFlag,
                    isSelected: selectedIndex == index,
                    tappedAction: { [weak self] in self?.countrySelectedAction?(index) }
                )
            )
            return countryView
        }
        return countriesViews
    }
    
    func update(model: Model) {
        let newCountriesView = buildCountryViews(
            fromCountries: model.countries,
            selectedIndex: model.selectedCountryIndex
        )
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for countyView in newCountriesView {
            contentStackView.addArrangedSubview(countyView)
        }
        headerLabel.text = model.title
        
        closeAction = model.closeAction
        countrySelectedAction = model.countrySelectedAction
        chooseAction = model.chooseButtonModel?.action
        if let chooseButtonModel = model.chooseButtonModel {
            chooseButton.isHidden = false
            chooseButton.setTitle(chooseButtonModel.title, for: .normal)
            chooseButton.isEnabled = chooseButtonModel.isEnabled
            chooseButton.backgroundColor = chooseButtonModel.isEnabled ? appearance.chooseButtonColor : appearance.chooseButtonDisabledColor
        } else {
            chooseButton.isHidden = true
        }
    }
    
    private func setupSubviews() {
        addSubview(closeButton)
        addSubview(headerLabel)
        addSubview(contentStackView)
        addSubview(chooseButton)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.left.equalTo(appearance.contentStackViewLeftSize)
            make.top.equalTo(headerLabel.snp.bottom).offset(appearance.contentStackViewTopOffsetSize)
            make.right.equalTo(-appearance.contentStackViewLeftSize)
        }
        headerLabel.snp.makeConstraints{ make in
            make.left.equalTo(appearance.headerLabelLeftSize)
            make.right.equalTo(-appearance.headerLabelLeftSize)
            make.top.equalTo(appearance.headerLabelTopSize)
        }
        chooseButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(appearance.chooseButtonLeftRightInsetSize)
            make.bottom.equalTo(appearance.chooseButtonBottomSize)
            make.height.equalTo(appearance.chooseButtonHeightSize)
        }
        closeButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(appearance.closeButtonOffset)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    @objc
    private func chooseTouched() {
        chooseAction?()
    }
    
    @objc
    private func closeTouched() {
        closeAction?()
    }
}

extension PurchaseSubscriptionChooseCountryView {
    struct Model {
        let title: String
        let countries: [Country]
        let selectedCountryIndex: Int?
        let countrySelectedAction: (_ index: Int) -> Void
        let chooseButtonModel: ChooseButtonModel?
        let closeAction: Action?
    }
    
    struct ChooseButtonModel {
        let title: String
        let isEnabled: Bool
        let action: Action
    }
    
    struct Country {
        let title: String
        let imageFlag: UIImage
    }
    
    struct Appearance {
        // MARK: - Header Appearance
        let headerLabelNumberOfLines = 0
        let headerLabelFont = Style.Fonts.bigBoldFont
        let headerLabelLeftSize = Style.Constraint.bigConstraint
        let headerLabelTopSize = Style.Constraint.bigConstraint
        
        // MARK: - ChooseButton Appearance
        let chooseButtonTitleFont = Style.Fonts.bigBoldFont
        let chooseButtonColor = Style.Color.blueColor
        let chooseButtonDisabledColor = Style.Color.grayColor
        let chooseButtonCornerRadius = Style.CornerRadius.standartCornerRadius
        let chooseButtonLeftRightInsetSize = Style.Constraint.standartConstreint
        let chooseButtonBottomSize = -11
        let chooseButtonHeightSize = 54
        
        // MARK: - ContentStackView Appearance
        let contentStackViewSpacing = Style.Spacing.noSpacing
        let contentStackViewLeftSize = Style.Constraint.bigConstraint
        let contentStackViewTopOffsetSize = 77
        
        // MARK: - Close button
        let closeButtonOffset = 32
    }
}

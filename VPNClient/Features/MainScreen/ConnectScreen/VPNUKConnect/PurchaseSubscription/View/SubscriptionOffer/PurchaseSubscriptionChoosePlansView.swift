//
//  PurchaseSubscriptionChoosePlanView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionChoosePlansView: UIView {
    private lazy var appearance = Appearance()
    private var planSelectedAction: ((_ index: Int) -> Void)?
    private var infoTapAction: (() -> Void)?
    // MARK: - Content
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            horizontalContentStackView,
            plansStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.contentStackViewSpacing
        return stackView
    }()
    
    private lazy var plansStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = appearance.plansStackViewSpacing
        return stackView
    }()
    
    private lazy var horizontalContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            choosePlanLabel,
            choosePlanQuastionButton,
            UIView()
        ])
        stackView.axis = .horizontal
        stackView.spacing = appearance.horizontalContentStackViewSpacing
        return stackView
    }()
    
    private lazy var choosePlanLabel : UILabel = {
        let label = UILabel()
        label.textColor = appearance.choosePlanLabelTextColor
        label.font = appearance.choosePlanLabelFont
        return label
    }()
    
    private lazy var choosePlanQuastionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "questionMark.pdf"), for: .normal)
        button.addTarget(self, action: #selector(quastionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildPlanViews(fromPlans plans: [Plan], selectedIndex: Int?) -> [PurchaseSubscriptionChoosePlanView] {
        let plansViews = plans.enumerated().map { index,plan -> PurchaseSubscriptionChoosePlanView in
            var planAppearance: PurchaseSubscriptionChoosePlanView.Appearance
            let isFirstPlan = index == 0
            let isLastPlan = index == plans.count - 1
            let haveOnlyOnePlan = plans.count == 1
            if haveOnlyOnePlan {
                planAppearance = PurchaseSubscriptionChoosePlanView.Appearance.oneItemAppearance
            } else { if isFirstPlan {
                planAppearance = PurchaseSubscriptionChoosePlanView.Appearance.firstItemAppearance
            } else if isLastPlan {
                planAppearance = PurchaseSubscriptionChoosePlanView.Appearance.lastItemAppearance
            } else  {
                planAppearance = PurchaseSubscriptionChoosePlanView.Appearance.middleItemAppearance
                }
            }
            let planView = PurchaseSubscriptionChoosePlanView(appearance: planAppearance)
            
            planView.update(model: .init(
                title: plan.title,
                subTitle: plan.subtitle,
                imageFlag: nil,
                isSelected: selectedIndex == index,
                tappedAction: { [weak self] in self?.planSelectedAction?(index) }
                ))
            return planView
        }
        return plansViews
    }
    
    func update(model: Model) {
        planSelectedAction = model.planSelectedAction
        choosePlanLabel.text = model.title
        let newPlansView = buildPlanViews(
            fromPlans: model.plans,
            selectedIndex: model.selectedPlanIndex
        )
        plansStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for planView in newPlansView {
            plansStackView.addArrangedSubview(planView)
        }
        choosePlanQuastionButton.isHidden = model.infoTapAction == nil
        infoTapAction = model.infoTapAction
    }
    
    @objc private func quastionButtonTapped(){
        infoTapAction?()
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionChoosePlansView {
    struct Model {
        let title: String
        let plans: [Plan]
        let selectedPlanIndex: Int?
        let planSelectedAction: (_ index: Int) -> Void
        let infoTapAction: (() -> Void)?
    }
    
    struct Plan {
        let title: String
        let subtitle: String
    }
    
    struct Appearance {
        let contentStackViewSpacing = Style.Spacing.bigSpacing
        let plansStackViewSpacing = Style.Spacing.noSpacing
        let horizontalContentStackViewSpacing = Style.Spacing.standartSpacing
        let choosePlanLabelFont = Style.Fonts.bigBoldFont
        let choosePlanLabelTextColor = Style.Color.darkGrayColor
    }
}

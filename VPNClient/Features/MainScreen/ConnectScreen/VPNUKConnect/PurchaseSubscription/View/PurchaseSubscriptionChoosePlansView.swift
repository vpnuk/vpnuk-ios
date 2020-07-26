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
    private lazy var planView = PurchaseSubscriptionChoosePlanView()
    private lazy var planView2 = PurchaseSubscriptionChoosePlanView()
    private lazy var plansView: [Plan] = []
    
    // MARK: - Content
    
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            horizontalContentStackView,
            plansStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.bigSpacing
        return stackView
    }()
    
    private lazy var plansStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            planView,
            planView2
        ])
        stackView.axis = .vertical
        stackView.spacing = appearance.noSpacing
        return stackView
    }()
    private lazy var horizontalContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            choosePlanLabel,
            choosePlanQuastionButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = appearance.standartSpacing
        return stackView
    }()
    
    private lazy var choosePlanLabel : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Choose a Plan", comment: "")
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    private lazy var choosePlanQuastionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "questionMark.pdf"), for: .normal)
        return button
    }()
    
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        choosePlanLabel.text = model.title
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
    func buildPlanViews(fromPlans plans: [Plan]) -> [PurchaseSubscriptionChoosePlanView] {
        for plan in plans {
            let planView = PurchaseSubscriptionChoosePlanView()
            
        }
        var plansView:[PurchaseSubscriptionChoosePlanView] = []
        plansView.append(planView)
        
        return plansView
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
        let choosePlanViewModel: PurchaseSubscriptionChoosePlanView.Model
    }
    
    struct Plan {
        let title: String
        let subtitle: String
    }
}

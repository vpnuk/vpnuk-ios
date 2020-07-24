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
    
    
    // MARK: - Content
    
    private lazy var planView = PurchaseSubscriptionChoosePlanView()
    private lazy var plan2View = PurchaseSubscriptionChoosePlanView()
    private lazy var plan3View = PurchaseSubscriptionChoosePlanView()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            horizontalContentStackView,
            plansStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var plansStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            planView,
            plan2View,
            plan3View
            
        ])
        stackView.axis = .vertical
        stackView.spacing = 75
        return stackView
    }()
    private lazy var horizontalContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            choosePlanLabel,
            choosePlanQuastionButton
            
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var choosePlanLabel : UILabel = {
        let label = UILabel()
        label.text = "Choose a Plan"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    private lazy var choosePlanQuastionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "questionMark.pdf"), for: .normal)
        //        button.addTarget(self, action: #selector(), for: .touchUpInside)
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
        
    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
     
        
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalContentStackView.snp.bottom).offset(16)
            make.left.equalTo(32)
        }
        horizontalContentStackView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        
        choosePlanLabel.snp.makeConstraints { (make) in
            make.width.equalTo(155)
            make.height.equalTo(28)
        }
        choosePlanQuastionButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.left.equalTo(choosePlanLabel.snp.right).offset(-8)
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
    }
    
    struct Plan {
        let title: String
        let subtitle: String
        
    }
}

//
//  PurchaseSubscriptionChoosePlanView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionChoosePlanView: UIView {
    
    
    // MARK: - Content
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            planView,
           
        ])
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()
    // MARK: - Model View
    private lazy var planView: UIView = {
        let view = UIView()
        // MARK: - Plan ImageView setup
        
        var planMarkImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "unchecked.pdf"))
            return imageView
        }()
        addSubview(planMarkImageView)
        planMarkImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(23)
            make.left.equalTo(16)
            make.top.equalTo(26)
        }
        // MARK: - PlanView setup
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.569, green: 0.569, blue: 0.569, alpha: 1).cgColor


       
        // MARK: - Model Labels
        var planLabel : UILabel = {
            let label = UILabel()
            label.text = "Text"
            label.font = UIFont.boldSystemFont(ofSize: 20.0)
            
            return label
        }()
        addSubview(planLabel)
        planLabel.snp.makeConstraints { (make) in
            make.width.equalTo(147)
            make.height.equalTo(23)
            make.top.equalTo(16)
            make.left.equalTo(55)
        }
        var detailLabel : UILabel = {
            let label = UILabel()
            label.text = "Text"
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 16.0)
            return label
        }()
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
                   make.width.equalTo(151)
                   make.height.equalTo(16)
            make.top.equalTo(planLabel.snp.bottom).offset(4)
            make.left.equalTo(55)
        }
        return view
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
        addSubview(planView)
        
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }
        planView.snp.makeConstraints { (make) in
            make.width.equalTo(311)
            make.height.equalTo(75)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}


extension PurchaseSubscriptionChoosePlanView {
    struct Model {
        let title: String
        let plans: [Plan]
        let selectedPlanIndex: Int?
        let planSelectedAction: (_ index: Int) -> Void
    }
    
    struct Plan {
        let title: String
        let subtitle: String
        
        enum titles: Int {
            case sharedIP
            case dedicatedIP
            case oneOneIP
            
            var description: Plan {
                switch self {
                    
                case .sharedIP:
                    return Plan.init(title: "Shared IP", subtitle: "Many servers")
                case .dedicatedIP:
                    return Plan.init(title: "Dedicated IP", subtitle: "Your personal server")
                case .oneOneIP:
                    return Plan.init(title: "1:1 Dedicated IP", subtitle: "Your personal 1:1 server")
                }
            }
        }
    }
}

//
//  PurchaseSubscriptionPeriodView.swift
//  Purchase
//
//  Created by Александр Умаров on 23.07.2020.
//  Copyright © 2020 Александр Умаров. All rights reserved.
//

import Foundation
import UIKit

class PurchaseSubscriptionPeriodView: UIView {
    
    
    // MARK: - Content
    
    private lazy var periodQuastionButton: UIButton = {
                  let button = UIButton()
                  button.setImage(UIImage(named: "questionMark.pdf"), for: .normal)
      //        button.addTarget(self, action: #selector(), for: .touchUpInside)
                  
                  return button
              }()
    
    var choosePeriodLabel : UILabel = {
        let label = UILabel()
        label.text = "Choose a period"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        return label
    }()
    
    private lazy var firstPeriodView: UIView = {
     let view = UIView()
        
     // MARK: - First Period ImageView setup
     
     var periodMarkImageView: UIImageView = {
         let imageView = UIImageView(image: UIImage(named: "unchecked.pdf"))
         return imageView
     }()
     addSubview(periodMarkImageView)
     periodMarkImageView.snp.makeConstraints { (make) in
         make.width.height.equalTo(23)
         make.left.equalTo(9)
         make.top.equalTo(8)
     }
        
     // MARK: - OptionView setup
        
     view.layer.cornerRadius = 10
     view.layer.borderWidth = 2
     view.layer.borderColor = UIColor(red: 0.569, green: 0.569, blue: 0.569, alpha: 1).cgColor

     // MARK: - Model Labels
     var periodLabel : UILabel = {
         let label = UILabel()
         label.text = "12 mounth"
         label.font = UIFont.boldSystemFont(ofSize: 12.0)
         
         return label
     }()
        
     addSubview(periodLabel)
        
     periodLabel.snp.makeConstraints { (make) in
         make.width.equalTo(68)
         make.height.equalTo(16)
        make.left.equalTo(periodMarkImageView.snp.right).offset(8)
         make.top.equalTo(11)
        }
        return view
           }()
    
    private lazy var secondPeriodView: UIView = {
        let view = UIView()
           
        // MARK: - Second Period ImageView setup
        
        var periodMarkImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "unchecked.pdf"))
            return imageView
        }()
        addSubview(periodMarkImageView)
        periodMarkImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(23)
            make.left.equalTo(139)
            make.top.equalTo(8)
        }
           
        // MARK: - OptionView setup
           
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.569, green: 0.569, blue: 0.569, alpha: 1).cgColor

        // MARK: - Model Labels
        var periodLabel : UILabel = {
            let label = UILabel()
            label.text = "6 mounth"
            label.font = UIFont.boldSystemFont(ofSize: 12.0)
            
            return label
        }()
           
        addSubview(periodLabel)
           
        periodLabel.snp.makeConstraints { (make) in
            make.width.equalTo(68)
            make.height.equalTo(16)
           make.left.equalTo(periodMarkImageView.snp.right).offset(8)
            make.top.equalTo(11)
           }
           return view
              }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstPeriodView,
            choosePeriodLabel,
            periodQuastionButton,
            secondPeriodView
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

    }
    
    private func setupSubviews() {
        addSubview(contentStackView)
        addSubview(firstPeriodView)
        addSubview(choosePeriodLabel)
        addSubview(periodQuastionButton)
        addSubview(secondPeriodView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }
        firstPeriodView.snp.makeConstraints { (make) in
                   make.width.equalTo(116)
                   make.height.equalTo(39)
               }
        choosePeriodLabel.snp.makeConstraints { (make) in
            make.width.equalTo(146)
            make.height.equalTo(23)
            make.bottom.equalTo(firstPeriodView.snp.top).offset(-8)
        }
        periodQuastionButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.left.equalTo(choosePeriodLabel.snp.right).offset(-16)
            make.bottom.equalTo(-44)
            
        }
        secondPeriodView.snp.makeConstraints { (make) in
            make.width.equalTo(116)
            make.height.equalTo(39)
            make.left.equalTo(firstPeriodView.snp.right).offset(14)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension PurchaseSubscriptionPeriodView {
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


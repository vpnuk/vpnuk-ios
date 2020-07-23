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
    
    
    // MARK: - Content
    
    private lazy var maxUsersQuastionButton: UIButton = {
                  let button = UIButton()
                  button.setImage(UIImage(named: "questionMark.pdf"), for: .normal)
      //        button.addTarget(self, action: #selector(), for: .touchUpInside)
                  
                  return button
              }()
    
    var maxUsersLabel : UILabel = {
        let label = UILabel()
        label.text = "Max users"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        return label
    }()
    
    private lazy var maxUsersView: UIView = {
     let view = UIView()
        
     // MARK: - Max Users ImageView setup
     
     var maxUsersMarkImageView: UIImageView = {
         let imageView = UIImageView(image: UIImage(named: "unchecked.pdf"))
         return imageView
     }()
     addSubview(maxUsersMarkImageView)
     maxUsersMarkImageView.snp.makeConstraints { (make) in
         make.width.height.equalTo(23)
         make.left.equalTo(9)
         make.top.equalTo(8)
     }
        
     // MARK: - OptionView setup
        
     view.layer.cornerRadius = 10
     view.layer.borderWidth = 2
     view.layer.borderColor = UIColor(red: 0.569, green: 0.569, blue: 0.569, alpha: 1).cgColor

     // MARK: - Model Labels
     var optionLabel : UILabel = {
         let label = UILabel()
         label.text = "6 users"
         label.font = UIFont.boldSystemFont(ofSize: 12.0)
         
         return label
     }()
        
     addSubview(optionLabel)
        
     optionLabel.snp.makeConstraints { (make) in
         make.width.equalTo(47)
         make.height.equalTo(16)
        make.left.equalTo(maxUsersMarkImageView.snp.right).offset(8)
         make.top.equalTo(11)
        }
        return view
           }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            maxUsersView,
            maxUsersLabel,
            maxUsersQuastionButton
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
        addSubview(maxUsersView)
        addSubview(maxUsersLabel)
        addSubview(maxUsersQuastionButton)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }
        maxUsersView.snp.makeConstraints { (make) in
                   make.width.equalTo(96)
                   make.height.equalTo(39)
               }
        maxUsersLabel.snp.makeConstraints { (make) in
            make.width.equalTo(93)
            make.height.equalTo(23)
            make.bottom.equalTo(maxUsersView.snp.top).offset(-8)
        }
        maxUsersQuastionButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.left.equalTo(maxUsersLabel.snp.right).offset(-8)
            make.bottom.equalTo(-44)
            
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

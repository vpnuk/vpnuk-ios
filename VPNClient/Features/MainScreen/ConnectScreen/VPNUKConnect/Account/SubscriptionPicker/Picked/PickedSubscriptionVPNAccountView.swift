//
//  PickedSubscriptionVPNAccountView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class PickedSubscriptionVPNAccountView: UIView {
    
    private let appearance: Appearance
    
    // MARK: Username
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Username:", comment: "")
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var usernameValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var usernameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            usernameLabel,
            usernameValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Password
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Password:", comment: "")
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var passwordValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var passwordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            passwordLabel,
            passwordValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Creds
    
    private lazy var credsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            usernameStackView,
            passwordStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        
        let imageView = UIImageView(image: UIImage(named: "ic_password"))
        imageView.contentMode = .center
        
        let stackViewImage = UIStackView(arrangedSubviews: [
            imageView,
            stackView,
        ])
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        
        stackViewImage.axis = .horizontal
        stackViewImage.spacing = 10
        
        return stackViewImage
    }()
    
    // MARK: Info
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: "ic_info"))
        imageView.contentMode = .center
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            infoLabel
        ])
        imageView.snp.makeConstraints { make in
            make.width.equalTo(15)
        }
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Content
    
    private lazy var contentStackView: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: ""))
        imageView.contentMode = .center
        
        let stackView = UIStackView(arrangedSubviews: [
            credsStackView,
            infoStackView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    
    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        usernameValueLabel.text = model.username
        passwordValueLabel.text = masked(password: model.password)
        infoLabel.text = model.info
        
        infoStackView.isHidden = model.info == nil
    }
    
    
    private func masked(password: String) -> String {
        return "******"
    }
    
    
    private func setupSubviews() {
        if appearance.shouldShowBg {
            backgroundColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
            makeDefaultShadowAndCorners()
        }
        
        addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}


extension PickedSubscriptionVPNAccountView {
    struct Model {
        let username: String
        let password: String
        let info: String?
    }
    
    struct Appearance {
        let shouldShowBg: Bool
        
        init(shouldShowBg: Bool = true) {
            self.shouldShowBg = shouldShowBg
        }
    }
}

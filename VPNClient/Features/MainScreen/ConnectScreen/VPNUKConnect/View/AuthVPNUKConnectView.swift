//
//  AuthVPNUKConnectView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol AuthVPNUKConnectViewProtocol: class {
    
}

class AuthVPNUKConnectView: UIView {
    private let viewModel: AuthVPNUKConnectViewModelProtocol
    private let contentView: UIView = SignInVPNUKConnectView()
    
    init(viewModel: AuthVPNUKConnectViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(contentView)
    }
    
    private func setupConstraints() {
        contentView.makeEdgesEqualToSuperview()
    }
}

extension AuthVPNUKConnectView: AuthVPNUKConnectViewProtocol {
    
}

class SignInVPNUKConnectView: UIView {
    private var signInAction: ((_ login: String, _ password: String) -> ())?
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Sign In with VPNUK Account", comment: "")
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var signInButton: UIButton = {
       let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    private lazy var switchToRegisterButton: UIButton = {
       let button = UIButton()
        button.setTitle("Don't have an account?", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = NSLocalizedString("Username:", comment: "Username:")
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("Username", comment: "Username")
        return textField
    }()
    
    private lazy var containerUsernameView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            usernameLabel,
            usernameTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var passwordLabel: UILabel = {
           let label = UILabel()
           label.font = .systemFont(ofSize: 17, weight: .semibold)
           label.text = NSLocalizedString("Password:", comment: "Username:")
           return label
       }()
       
       private lazy var passwordTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = NSLocalizedString("Password", comment: "Username")
           return textField
       }()
       
       private lazy var containerPasswordView: UIStackView = {
           let stackView = UIStackView(arrangedSubviews: [
               passwordLabel,
               passwordTextField
           ])
           stackView.axis = .vertical
           stackView.spacing = 8
           return stackView
       }()

    
    private lazy var containerCredentialsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            containerUsernameView,
            containerPasswordView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var contentView: UIView = {
        let stackView = UIStackView(arrangedSubviews: [
            signInLabel,
            containerCredentialsStackView,
            signInButton,
            switchToRegisterButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView.contained(with: .init(top: 0, left: 16, bottom: 0, right: 16))
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(contentView)
    }
    
    private func setupConstraints() {
        contentView.makeEdgesEqualToSuperview()
    }
    
    func update(model: Model) {
        self.signInAction = model.signInAction
    }
}

extension SignInVPNUKConnectView {
    struct Model {
        let signInAction: (_ login: String, _ password: String) -> ()
    }
}



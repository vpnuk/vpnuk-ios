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
    func update(model: AuthVPNUKConnectView.Model)
}

class AuthVPNUKConnectView: UIView {
    private let viewModel: AuthVPNUKConnectViewModelProtocol
    private var signInAction: ((_ data: AuthData) -> ())?
    private var switchToSignUpAction: Action?
    
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
        button.addTarget(self, action: #selector(signInTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var switchToRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Don't have an account?", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(switchToSignUpTouched), for: .touchUpInside)
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
        textField.autocapitalizationType = .none
        textField.textContentType = .username
        textField.delegate = self
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
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.delegate = self
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
            containerPasswordView,
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
        stackView.spacing = 8
        return stackView.contained(with: .init(top: 0, left: 16, bottom: 0, right: 16))
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return scroll
    }()
    
    init(viewModel: AuthVPNUKConnectViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func signInTouched() {
        signInAction?(
            .init(
                username: usernameTextField.text ?? "",
                password: passwordTextField.text ?? ""
            )
        )
    }
    
    @objc
    private func switchToSignUpTouched() {
        switchToSignUpAction?()
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
    }
    
    private func setupConstraints() {
        scrollView.makeEdgesEqualToSuperview()
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    func update(model: Model) {
        self.signInAction = model.signInAction
        self.switchToSignUpAction = model.switchToSignUpAction
    }
}

extension AuthVPNUKConnectView {
    struct Model {
        let signInAction: (_ data: AuthData) -> ()
        let switchToSignUpAction: Action
    }
    
    struct AuthData {
        let username: String
        let password: String
    }
}

extension AuthVPNUKConnectView: AuthVPNUKConnectViewProtocol {
    
}

extension AuthVPNUKConnectView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}

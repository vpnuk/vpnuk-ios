//
//  RegistrationVPNUKConnectView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 27.06.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

protocol RegistrationVPNUKConnectViewProtocol: class {
    func update(model: RegistrationVPNUKConnectView.Model)
}

class RegistrationVPNUKConnectView: UIView {
    private let viewModel: RegistrationVPNUKConnectViewModelProtocol
    private var signUpAction: ((_ data: RegistrationData) -> ())?
    private var switchToSignInAction: Action?
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Sign Up", comment: "")
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.addTarget(self, action: #selector(signUpTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var switchToSignInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Have an account? Sign In", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(switchToSignInTouched), for: .touchUpInside)
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
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = NSLocalizedString("Email:", comment: "")
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("Email", comment: "")
        textField.delegate = self
        return textField
    }()
    
    private lazy var emailContainerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailLabel,
            emailTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var firstNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = NSLocalizedString("First name:", comment: "")
        return label
    }()
    
    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("First name", comment: "")
        textField.delegate = self
        return textField
    }()
    
    private lazy var firstNameContainerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstNameLabel,
            firstNameTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = NSLocalizedString("Last name:", comment: "")
        return label
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("Last name", comment: "")
        textField.delegate = self
        return textField
    }()
    
    private lazy var lastNameContainerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            lastNameLabel,
            lastNameTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var firstLastNameContainerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstNameContainerView,
            lastNameContainerView,
        ])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var containerCredentialsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            containerUsernameView,
            containerPasswordView,
            emailContainerView,
            firstLastNameContainerView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var contentView: UIView = {
        let stackView = UIStackView(arrangedSubviews: [
            signUpLabel,
            containerCredentialsStackView,
            signUpButton,
            switchToSignInButton
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
    
    init(viewModel: RegistrationVPNUKConnectViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func signUpTouched() {
        signUpAction?(
            .init(
                username: usernameTextField.text ?? "",
                password: passwordTextField.text ?? "",
                firstName: firstNameTextField.text ?? "",
                lastName: lastNameTextField.text ?? "",
                email: emailTextField.text ?? ""
            )
        )
    }
    
    @objc
    private func switchToSignInTouched() {
        switchToSignInAction?()
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    private func setupConstraints() {
        scrollView.makeEdgesEqualToSuperview()
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    func update(model: Model) {
        self.signUpAction = model.signUpAction
        self.switchToSignInAction = model.switchToSignInAction
    }
}

extension RegistrationVPNUKConnectView {
    struct Model {
        let signUpAction: (_ data: RegistrationData) -> ()
        let switchToSignInAction: Action
    }
    
    struct RegistrationData {
        let username: String
        let password: String
        let firstName: String
        let lastName: String
        let email: String
    }
}

extension RegistrationVPNUKConnectView: RegistrationVPNUKConnectViewProtocol {
    
}

extension RegistrationVPNUKConnectView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}

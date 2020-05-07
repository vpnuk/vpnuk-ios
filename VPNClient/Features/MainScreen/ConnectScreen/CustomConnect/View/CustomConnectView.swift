//
//  CustomConnectView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol CustomConnectViewProtocol: class {
    var username: String? { get set }
    var password: String? { get set }
    
    func update()
}

class CustomConnectView: UIView {
    private var viewModel: CustomConnectViewModelProtocol
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username:"
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private lazy var containerUsernameView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var saveCredentialsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "blank-check-box"), for: .normal)
        button.setTitle("Save credentials", for: .normal)
        button.setImage(UIImage(named: "black-check-box-with-white-check"), for: .selected)
        button.setTitle("Save credentials", for: .selected)
        button.tintColor = .black
        button.contentEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        button.imageEdgeInsets = .init(top: 0, left: -10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(saveCredentialsTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerPasswordView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    init(viewModel: CustomConnectViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
        update()
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    @objc private func saveCredentialsTouched() {
        viewModel.storeCredentials = !viewModel.storeCredentials
    }
    
    private func setupSubviews() {
        containerUsernameView.addArrangedSubview(usernameLabel)
        containerUsernameView.addArrangedSubview(usernameTextField)
        
        let passwordDescriptionStackView = UIStackView()
        passwordDescriptionStackView.axis = .horizontal
        passwordDescriptionStackView.addArrangedSubview(passwordLabel)
        passwordDescriptionStackView.addArrangedSubview(UIView())
        passwordDescriptionStackView.addArrangedSubview(saveCredentialsButton)
        containerPasswordView.addArrangedSubview(passwordDescriptionStackView)
        containerPasswordView.addArrangedSubview(passwordTextField)
        
        containerStackView.addArrangedSubview(containerUsernameView)
        containerStackView.addArrangedSubview(containerPasswordView)
        
        addSubview(containerStackView)
    }
    
    private func setupConstraints() {
        containerStackView.makeEdgesEqualToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CustomConnectView: CustomConnectViewProtocol {
    var username: String? {
        get {
            return usernameTextField.text
        }
        set {
            usernameTextField.text = newValue
        }
    }
    
    var password: String? {
        get {
            return passwordTextField.text
        }
        set {
            passwordTextField.text = newValue
        }
    }
    
    func update() {
        saveCredentialsButton.isSelected = viewModel.storeCredentials
        let credentials = try? viewModel.getCredentials()
        username = credentials?.username
        password = credentials?.password
    }
    
}

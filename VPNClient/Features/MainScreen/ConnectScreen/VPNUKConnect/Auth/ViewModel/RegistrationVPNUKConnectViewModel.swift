//
//  RegistrationVPNUKConnectViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 27.06.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol RegistrationVPNUKConnectViewModelProtocol {
    func viewDidLoad()
}

class RegistrationVPNUKConnectViewModel: RegistrationVPNUKConnectViewModelProtocol {
    private let deps: Dependencies
    
    weak var view: RegistrationVPNUKConnectViewProtocol? {
        didSet {
            viewDidLoad()
        }
    }
    
    init(deps: Dependencies) {
        self.deps = deps
    }
    
    func viewDidLoad() {
        updateView()
    }
    
    private func updateView() {
        view?.update(model:
            .init(
                signUpAction: { [weak self] data in
                    self?.signUpTouched(withData: data)
                },
                switchToSignInAction: {  [weak self] in
                    self?.deps.router.switchToAuthorizationScreen()
                }
            )
        )
    }
    
    private func signUpTouched(withData data: RegistrationVPNUKConnectView.RegistrationData) {
        if !data.username.isEmpty
            && !data.password.isEmpty
            && !data.firstName.isEmpty
            && !data.lastName.isEmpty
            && !data.email.isEmpty
        {
            // all fiels were filled
            signUp(withData: data)
        } else {
            deps.router.presentAlert(
                message: NSLocalizedString("Please fill in all fields", comment: "Please fill in all fields")
            )
        }
    }
    
    private func signUp(withData data: RegistrationVPNUKConnectView.RegistrationData) {
        deps.router.setLoading(true)
        deps.authApi.signUp(
            withData: .init(
                username: data.username,
                password: data.password,
                firstName: data.firstName,
                lastName: data.lastName,
                email: data.email
            )
        )
        { [weak self] result in
            self?.deps.router.setLoading(false)
            
            switch result {
            case .success(_):
                self?.deps.router.presentAlert(message: NSLocalizedString("Successful. Please sign in", comment: ""), completion: {
                    self?.deps.router.switchToAuthorizationScreen()
                })
            case .failure(_):
                self?.deps.router.presentAlert(
                    message: NSLocalizedString("Registration failed. Please check all fields and try again.", comment: "Registration failed.")
                )
            }
        }
    }
}

extension RegistrationVPNUKConnectViewModel {
    struct Dependencies {
        let router: AuthVPNUKConnectRouterProtocol
        let authApi: AuthAPI
        let authService: AuthService
    }
}

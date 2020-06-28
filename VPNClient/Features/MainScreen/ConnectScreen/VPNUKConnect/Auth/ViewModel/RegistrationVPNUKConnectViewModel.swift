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
        // TODO: validate
        signUp(withData: data)
    }
    
    private func signUp(withData data: RegistrationVPNUKConnectView.RegistrationData) {
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
            switch result {
            case .success(_):
                self?.deps.router.presentAlert(message: NSLocalizedString("Successful. Please sign in", comment: ""), completion: {
                    self?.deps.router.switchToAuthorizationScreen()
                })
            case .failure(let error):
                self?.deps.router.presentAlert(message: error.localizedDescription)
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

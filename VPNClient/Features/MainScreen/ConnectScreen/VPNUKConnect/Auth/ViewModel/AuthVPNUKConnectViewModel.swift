//
//  AuthVPNUKConnectViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol AuthVPNUKConnectViewModelProtocol {
    func viewDidLoad()
}

class AuthVPNUKConnectViewModel: AuthVPNUKConnectViewModelProtocol {
    weak var view: AuthVPNUKConnectViewProtocol? {
        didSet {
            viewDidLoad()
        }
    }
    private let deps: Dependencies
     
     init(deps: Dependencies) {
         self.deps = deps
     }
     
    func viewDidLoad() {
        updateView()
    }
    
    private func updateView() {
        view?.update(
            model: .init(
                signInAction: { [weak self] data in
                    self?.signInTouched(withData: data)
                },
                switchToSignUpAction: { [weak self] in
                    self?.deps.router.switchToRegistrationScreen()
                }
            )
        )
    }
    
    private func signInTouched(withData data: AuthVPNUKConnectView.AuthData) {
        if !data.username.isEmpty
            && !data.password.isEmpty
        {
            // all fiels were filled
            signIn(withData: data)
        } else {
            deps.router.presentAlert(
                message: NSLocalizedString("Please fill in all fields", comment: "Please fill in all fields")
            )
        }
        
    }
    
    private func signIn(withData data: AuthVPNUKConnectView.AuthData) {
        deps.router.setLoading(true)
        deps.authApi.signIn(
            withCredentials: .init(grantType: .password, username: data.username, password: data.password)
            )
        { [weak self] result in
            self?.deps.router.setLoading(false)
            
            switch result {
            case .success(let authResponse):
                do {
                    try self?.deps.authService.setAuthToken(authResponse.accessToken)
                    self?.deps.router.switchToAccountScreen()
                } catch {
                    self?.deps.router.presentAlert(message: error.localizedDescription)
                }
            case .failure(_):
                self?.deps.router.presentAlert(
                    message: NSLocalizedString("Login failed. Please check all fields and try again.", comment: "Login failed")
                )
            }
        }
    }
}

extension AuthVPNUKConnectViewModel {
    struct Dependencies {
        let router: AuthVPNUKConnectRouterProtocol
        let authApi: AuthAPI
        let authService: AuthService
    }
}

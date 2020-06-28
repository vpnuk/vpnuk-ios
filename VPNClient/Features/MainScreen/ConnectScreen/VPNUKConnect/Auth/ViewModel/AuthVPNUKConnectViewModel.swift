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
        // TODO: validate
        signIn(withData: data)
    }
    
    private func signIn(withData data: AuthVPNUKConnectView.AuthData) {
        deps.authApi.signIn(
            withCredentials: .init(grantType: .password, username: data.username, password: data.password)
            )
        { [weak self] result in
            switch result {
            case .success(let authResponse):
                do {
                    try self?.deps.authService.setAuthToken(authResponse.accessToken)
                    self?.deps.router.switchToAccountScreen()
                } catch {
                    self?.deps.router.presentAlert(message: error.localizedDescription)
                }
            case .failure(let error):
                self?.deps.router.presentAlert(message: error.localizedDescription)
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

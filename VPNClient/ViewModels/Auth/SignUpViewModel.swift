//
//  SignUpViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 19.04.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

class SignUpViewModel {
    private let api: AuthAPI
    var view: SignUpView?
    private let userService: UserService
    
    init(api: AuthAPI = RestAPI.shared, userService: UserService = UserServiceImpl.shared) {
        self.api = api
        self.userService = userService
    }
    
    private func goToMainScreen() {
        view?.goToMainScreen()
    }
    
    
    private func showError(withText text: String) {
        view?.showError(withText: text)
    }
    
    private func showLoading() {
        view?.showLoading()
    }
    
    private func hideLoading() {
        view?.hideLoading()
    }
    
    private func validate(data: SignUpData) throws {
        // TODO: fix
    }
    
    
    
    
    func signUp(withData data: SignUpData, completion: @escaping (_ result: Result<Void, Error>)->()) {
        do {
            try validate(data: data)
        } catch {
            showError(withText: "Some fields are not valid")
            return
        }
        showLoading()
        let signupData = SignUpRequestDTO(withData: data)
        api.signUp(withData: signupData) { [weak self] result in
            self?.hideLoading()
            switch result {
            case .success(_):
                self?.api.signIn(withCredentials: .init(
                    grantType: .password,
                    username: signupData.username,
                    password: signupData.password
                )) { (result) in
                    switch result {
                    case .success(_):
                        self?.goToMainScreen()
                    case .failure(let error):
                        print(error)
                        self?.showError(withText: "Sign in error")
                    }
                }
            case .failure(let error):
                self?.showError(withText: "Response error")
            }
            completion(result)
        }
    }
}

fileprivate extension SignUpRequestDTO {
    init(withData data: SignUpViewModel.SignUpData) {
        username = data.username ?? ""
        password = data.password ?? ""
        firstName = data.password ?? ""
        lastName = data.lastName ?? ""
        email = data.email ?? ""
    }
}

extension SignUpViewModel {
    struct SignUpData {
        let username: String?
        let password: String?
        let firstName: String?
        let lastName: String?
        let email: String?
    }
}

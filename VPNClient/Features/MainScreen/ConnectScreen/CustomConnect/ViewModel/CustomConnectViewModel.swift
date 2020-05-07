//
//  CustomConnectionDataViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol CustomConnectViewModelProtocol: VPNCredentialsProvider {
    var storeCredentials: Bool { get set }
}

class CustomConnectViewModel: CustomConnectViewModelProtocol {
    weak var view: CustomConnectViewProtocol?
    
    private let credentialsStorage: CredentialsStorage
    
    var credentialsChangedListener: ((UsernamePasswordCredentials) -> ())?
    
    var storeCredentials: Bool {
        get {
            return (try? credentialsStorage.getCredentials()) != nil
        }
        set {
            let credentials: UsernamePasswordCredentials?
            if newValue, let password = view?.password, let username = view?.username {
                credentials = UsernamePasswordCredentials(username: username, password: password)
            } else {
                credentials = nil
            }
            do {
                try credentialsStorage.setCredentials(credentials)
            } catch {
                //TODO: print cannot save
            }
        }
    }
    
    init(customCredentialsStorage: CredentialsStorage) {
        self.credentialsStorage = customCredentialsStorage
    }
    
    func getCredentials() throws -> UsernamePasswordCredentials? {
        return try credentialsStorage.getCredentials()
    }
}

//
//  AuthService.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 07.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol AuthService {
    var isSignedIn: Bool { get }
    func setAuthToken(_ token: String) throws
    func getAuthToken() throws -> String?
}

class VPNUKAuthService {
    private let userCredentialsStorage: CredentialsStorage
    
    init(userCredentialsStorage: CredentialsStorage) {
        self.userCredentialsStorage = userCredentialsStorage
    }
}


extension VPNUKAuthService: AuthService {
    var isSignedIn: Bool {
        let credentials = try? userCredentialsStorage.getCredentials()
        return credentials != nil
    }
    
    func setAuthToken(_ token: String) throws {
        try userCredentialsStorage.setCredentials(.init(username: "token", password: token))
    }
    
    func getAuthToken() throws -> String? {
        return try userCredentialsStorage.getCredentials()?.password
    }
}

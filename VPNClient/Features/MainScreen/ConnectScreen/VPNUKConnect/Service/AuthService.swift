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
}

class VPNUKAuthService: AuthService {
    var isSignedIn: Bool {
        let credentials = try? userCredentialsStorage.getCredentials()
        return credentials != nil
    }
    
    private let userCredentialsStorage: CredentialsStorage
    
    init(userCredentialsStorage: CredentialsStorage) {
        self.userCredentialsStorage = userCredentialsStorage
    }
}

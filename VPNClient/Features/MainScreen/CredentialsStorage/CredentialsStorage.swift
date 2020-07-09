//
//  CredentialStorage.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import TunnelKit

struct UsernamePasswordCredentials {
    let username: String
    let password: String
}

protocol CredentialsStorage {
    func getCredentials() throws -> UsernamePasswordCredentials?
    func setCredentials(_ credentials: UsernamePasswordCredentials?) throws
}

enum KeychainCredentialsError: Error {
    case couldntGetPasswordReference
    case couldntFetchPassword
    case couldntGetUsernameReference
    case couldntFetchUsername
    case couldntSetPassword
    case couldntSetUsername
}

class KeychainCredentialsStorage: CredentialsStorage {
    private let usernameKey: String
    private let passwordKey: String
    private let appGroup: String
    
    init(usernameKey: String, passwordKey: String, appGroup: String = OpenVPNConstants.appGroup) {
        self.usernameKey = usernameKey
        self.passwordKey = passwordKey
        self.appGroup = appGroup
    }
    
    func getCredentials() throws -> UsernamePasswordCredentials? {
        let keychain = Keychain(group: appGroup)
        
        guard let passwordReference = try? keychain.passwordReference(for: passwordKey) else {
            throw KeychainCredentialsError.couldntGetPasswordReference
        }
        guard let fetchedPassword = try? Keychain.password(for: passwordKey, reference: passwordReference) else {
            throw KeychainCredentialsError.couldntFetchPassword
        }
        
        guard let usernameReference = try? keychain.passwordReference(for: usernameKey) else {
            throw KeychainCredentialsError.couldntGetUsernameReference
        }
        guard let fetchedUsername = try? Keychain.password(for: usernameKey, reference: usernameReference) else {
            throw KeychainCredentialsError.couldntFetchUsername
        }
        return UsernamePasswordCredentials(username: fetchedUsername, password: fetchedPassword)
    }
    
    func setCredentials(_ credentials: UsernamePasswordCredentials?) throws {
        let keychain = Keychain(group: appGroup)
        
        if let creds = credentials {
            guard let _ = try? keychain.set(password: creds.username, for: usernameKey) else {
                throw KeychainCredentialsError.couldntSetUsername
            }
            guard let _ = try? keychain.set(password: creds.password, for: passwordKey) else {
                throw KeychainCredentialsError.couldntSetPassword
            }
        } else {
            keychain.removePassword(for: usernameKey)
            keychain.removePassword(for: passwordKey)
        }
    }
    
}

extension KeychainCredentialsStorage {
    static func buildForVPNUKAccount() -> CredentialsStorage {
        let storage = KeychainCredentialsStorage(
            usernameKey: KeychainKeys.VPNUKAccount.usernameKey,
            passwordKey: KeychainKeys.VPNUKAccount.passwordKey
        )
        return storage
    }
    
    static func buildForCustomVPN() -> CredentialsStorage {
        let storage = KeychainCredentialsStorage(
            usernameKey: KeychainKeys.VPN.usernameKey,
            passwordKey: KeychainKeys.VPN.passwordKey
        )
        return storage
    }
}



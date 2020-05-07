//
//  KeychainKeys.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 07.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

enum KeychainKeys {
    enum VPNUKAccount {
        static let usernameKey = "keychainVPNUKAccountUsernameKey"
        static let passwordKey = "keychainVPNUKAccountPasswordKey"
    }
    
    enum VPN {
        static let usernameKey = "keychainVPNUsernameKey"
        static let passwordKey = "keychainVPNPasswordKey"
    }
}

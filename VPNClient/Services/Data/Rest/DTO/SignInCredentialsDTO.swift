//
//  SignInCredentialsDTO.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 19.04.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

enum SignInGrantType: String, Codable {
    case password
}
struct SignInCredentialsDTO: Codable {
    let grantType: SignInGrantType
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
        case grantType = "grant_type"
    }
}

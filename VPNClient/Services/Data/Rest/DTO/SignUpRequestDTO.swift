//
//  SignUpRequest.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 19.04.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
struct SignUpRequestDTO: Codable {
    let username: String
    let password: String
    let firstName: String
    let lastName: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case username = "user_name"
        case password = "password"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
    }
}


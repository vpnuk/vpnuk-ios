//
//  SignInResponseDTO.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 19.04.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

struct SignInResponseDTO: Codable {
    let accessToken: String?
    let tokenType: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

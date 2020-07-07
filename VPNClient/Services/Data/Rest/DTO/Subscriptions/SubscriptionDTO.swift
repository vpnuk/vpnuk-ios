//
//  SubscriptionDTO.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.06.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

enum SubscriptionType: String, Codable {
    case shared = "Shared"
    case dedicated = "Dedicated"
}

struct DedicatedServerDTO: Codable {
    let id: String
    let location: String
    let ip: String
    let description: String?
}

struct VPNAccountDTO: Codable {
    let username: String
    let password: String
    let server: DedicatedServerDTO?
}

struct SubscriptionDTO: Codable {
    let id: String
    let productName: String
    /// VPN accounts quantity
    let quantity: Int
    /// max sessions count
    let sessions: Int
    let period: Int
    let type: SubscriptionType
    let status: SubscriptionStatus
    let trialEnd: String?
    let vpnAccounts: [VPNAccountDTO]
}

extension SubscriptionDTO {
    var trialEndDate: Date? {
        return nil
    }
}

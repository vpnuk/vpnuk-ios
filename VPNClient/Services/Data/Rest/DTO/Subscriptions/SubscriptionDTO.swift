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
    case oneToOne = "One2One"
}

extension SubscriptionType: Comparable {
    static func < (lhs: SubscriptionType, rhs: SubscriptionType) -> Bool {
        switch (lhs, rhs) {
        case (.shared, .dedicated):
            return true
        case (.dedicated, .oneToOne):
            return true
        case (.oneToOne, _):
            return false
        case (.dedicated, .dedicated):
            return true
        case (.shared, .oneToOne):
            return true
        case (_, .shared):
            return false
        }
    }
}

extension SubscriptionType {
    var localizedValue: String {
        switch self {
        case .shared:
            return NSLocalizedString("Shared", comment: "")
        case .dedicated:
            return NSLocalizedString("Dedicated", comment: "")
        case .oneToOne:
            return NSLocalizedString("1:1", comment: "")
        }
    }
}

struct DedicatedServerDTO: Codable, Equatable {
    let id: String
    let location: String
    let ip: String
    let description: String?
}

struct VPNAccountDTO: Codable, Equatable {
    let username: String
    let password: String
    /// Unique user ip for dedicated server
    let uniqueUserIp: String
    let server: DedicatedServerDTO?
    
    enum CodingKeys: String, CodingKey {
         case username = "username"
         case password = "password"
         case uniqueUserIp = "ip"
         case server = "server"
     }
}

struct SubscriptionDTO: Codable, Equatable {
    let id: Int
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
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productName = "product_name"
        case sessions = "sessions"
        case quantity = "quantity"
        case period = "period"
        case type = "type"
        case status = "status"
        case trialEnd = "trial_end"
        case vpnAccounts = "vpnaccounts"
    }
}

extension SubscriptionDTO {
    var trialEndDate: Date? {
        guard let trialEnd = trialEnd else { return nil }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.date(from: trialEnd)
    }
}

//
//  PurchaseProduct.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 02.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

enum PurchaseProduct: String, CaseIterable {
    case oneToOneDedicatedIp1Month1User = "68152"
    case oneToOneDedicatedIp3Month1User = "68151"
    case oneToOneDedicatedIp6Month1User = "68150"
    case oneToOneDedicatedIp12Month1User = "68149"
    case dedicatedIp1Month2User = "6633"
    case dedicatedIp3Month2User = "6637"
    case dedicatedIp6Month2User = "6641"
    case dedicatedIp12Month2User = "6645"
    case sharedIp1Month1User = "59160"
    case sharedIp3Month1User = "59161"
    case sharedIp6Month1User = "59162"
    case sharedIp12Month1User = "59163"
}

extension PurchaseProduct {
    static var availableProducts: [PurchaseProduct] {
        return [
            .oneToOneDedicatedIp1Month1User,
            .oneToOneDedicatedIp3Month1User,
            .oneToOneDedicatedIp6Month1User,
            .oneToOneDedicatedIp12Month1User,
            .dedicatedIp1Month2User,
            .dedicatedIp3Month2User,
            .dedicatedIp6Month2User,
            .dedicatedIp12Month2User,
            .sharedIp1Month1User,
            .sharedIp3Month1User,
            .sharedIp6Month1User,
            .sharedIp12Month1User
        ]
    }
    
    var productId: String { rawValue }
    
    var localizedTitle: String {
        switch self {
        case .oneToOneDedicatedIp1Month1User:
            return NSLocalizedString("1:1 Dedicated IP. 1 Month. 1 User", comment: "")
        case .oneToOneDedicatedIp3Month1User:
            return NSLocalizedString("1:1 Dedicated IP. 3 Months. 1 User", comment: "")
        case .oneToOneDedicatedIp6Month1User:
            return NSLocalizedString("1:1 Dedicated IP. 6 Months. 1 User", comment: "")
        case .oneToOneDedicatedIp12Month1User:
            return NSLocalizedString("1:1 Dedicated IP. 12 Months. 1 User", comment: "")
        case .dedicatedIp1Month2User:
            return NSLocalizedString("Dedicated IP. 1 Month. 2 Users", comment: "")
        case .dedicatedIp3Month2User:
            return NSLocalizedString("Dedicated IP. 3 Months. 2 Users", comment: "")
        case .dedicatedIp6Month2User:
            return NSLocalizedString("Dedicated IP. 6 Months. 2 Users", comment: "")
        case .dedicatedIp12Month2User:
            return NSLocalizedString("Dedicated IP. 12 Months. 2 Users", comment: "")
        case .sharedIp1Month1User:
            return NSLocalizedString("Shared IP. 1 Month. 1 User", comment: "")
        case .sharedIp3Month1User:
            return NSLocalizedString("Shared IP. 3 Months. 1 User", comment: "")
        case .sharedIp6Month1User:
            return NSLocalizedString("Shared IP. 6 Months. 1 User", comment: "")
        case .sharedIp12Month1User:
            return NSLocalizedString("Shared IP. 12 Months. 1 User", comment: "")
        }
    }
    
    var localizeDescription: String {
        switch self {
        case .oneToOneDedicatedIp1Month1User, .oneToOneDedicatedIp3Month1User, .oneToOneDedicatedIp6Month1User, .oneToOneDedicatedIp12Month1User:
            return NSLocalizedString("Your own unique 1:1 IP (UK only)", comment: "")
        case .dedicatedIp1Month2User, .dedicatedIp3Month2User, .dedicatedIp6Month2User, .dedicatedIp12Month2User:
            return NSLocalizedString("Your own unique IP", comment: "")
        case .sharedIp1Month1User, .sharedIp3Month1User, .sharedIp6Month1User, .sharedIp12Month1User:
            return NSLocalizedString("Large choice of server. Dynamic IP", comment: "")
        }
    }
    
    var data: Data {
        switch self {
        case .oneToOneDedicatedIp1Month1User:
            return .init(periodMonths: 1, maxUsers: 1, type: .oneToOne)
        case .oneToOneDedicatedIp3Month1User:
            return .init(periodMonths: 3, maxUsers: 1, type: .oneToOne)
        case .oneToOneDedicatedIp6Month1User:
            return .init(periodMonths: 6, maxUsers: 1, type: .oneToOne)
        case .oneToOneDedicatedIp12Month1User:
            return .init(periodMonths: 12, maxUsers: 1, type: .oneToOne)
        case .dedicatedIp1Month2User:
            return .init(periodMonths: 1, maxUsers: 2, type: .dedicated)
        case .dedicatedIp3Month2User:
            return .init(periodMonths: 3, maxUsers: 2, type: .dedicated)
        case .dedicatedIp6Month2User:
            return .init(periodMonths: 6, maxUsers: 2, type: .dedicated)
        case .dedicatedIp12Month2User:
            return .init(periodMonths: 12, maxUsers: 2, type: .dedicated)
        case .sharedIp1Month1User:
            return .init(periodMonths: 1, maxUsers: 1, type: .shared)
        case .sharedIp3Month1User:
            return .init(periodMonths: 3, maxUsers: 1, type: .shared)
        case .sharedIp6Month1User:
            return .init(periodMonths: 6, maxUsers: 1, type: .shared)
        case .sharedIp12Month1User:
            return .init(periodMonths: 12, maxUsers: 1, type: .shared)
        }
    }
    
    struct Data {
        let periodMonths: Int
        let maxUsers: Int
        let type: SubscriptionType
    }
}

extension SubscriptionType {
    var localizedTitle: String {
          switch self {
          case .oneToOne:
              return NSLocalizedString("1:1 Dedicated IP", comment: "")
          case .dedicated:
              return NSLocalizedString("Dedicated IP", comment: "")
          case .shared:
              return NSLocalizedString("Shared IP", comment: "")
          }
      }
      
      var localizeDescription: String {
          switch self {
          case .oneToOne:
              return NSLocalizedString("Your unique 1:1 IP based in the UK", comment: "")
          case .dedicated:
              return NSLocalizedString("Your unique personal IP", comment: "")
          case .shared:
              return NSLocalizedString("Randomly assigned dynamic IP", comment: "")
          }
      }
}

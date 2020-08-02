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
    case dedicatedIp1Month2User = "6633"
    case sharedIp1Month1User = "59160"
}

extension PurchaseProduct {
    static var availableProducts: [PurchaseProduct] {
        return [
            .oneToOneDedicatedIp1Month1User,
            .dedicatedIp1Month2User,
            .sharedIp1Month1User
        ]
    }
    
    var localizedTitle: String {
        switch self {
        case .oneToOneDedicatedIp1Month1User:
            return NSLocalizedString("1:1 Dedicated IP", comment: "")
        case .dedicatedIp1Month2User:
            return NSLocalizedString("Dedicated IP", comment: "")
        case .sharedIp1Month1User:
            return NSLocalizedString("Shared IP", comment: "")
        }
    }
    
    var localizeDescription: String {
        switch self {
        case .oneToOneDedicatedIp1Month1User:
            return NSLocalizedString("Your own unique 1:1 IP (UK only)", comment: "")
        case .dedicatedIp1Month2User:
            return NSLocalizedString("Your own unique IP", comment: "")
        case .sharedIp1Month1User:
            return NSLocalizedString("Large choice of server. Dynamic IP", comment: "")
        }
    }
}

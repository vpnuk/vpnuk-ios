//
//  SubsriptionStatusDto.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

enum SubscriptionStatus: String, Codable {
    case cancelled = "cancelled"
    case active = "active"
    case onHold = "on-hold"
    case pending = "pending"
}

extension SubscriptionStatus {
    var localizedValue: String {
        switch self {
        case .cancelled:
            return NSLocalizedString("Cancelled", comment: "")
        case .active:
            return NSLocalizedString("Active", comment: "")
        case .onHold:
            return NSLocalizedString("On Hold", comment: "")
        case .pending:
            return NSLocalizedString("Pending", comment: "")
        }
    }
    
    var color: UIColor {
        switch self {
        case .cancelled:
            return .systemRed
        case .active:
            return .systemGreen
        case .onHold:
            return .systemGray
        case .pending:
            return .systemYellow
        }
    }
}



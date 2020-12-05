//
//  SKProduct+Price.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.12.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct {
    fileprivate static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }

    var localizedPrice: String {
        if self.price == 0.00 {
            return NSLocalizedString("Free", comment: "")
        } else {
            let formatter = SKProduct.formatter
            formatter.locale = self.priceLocale

            guard let formattedPrice = formatter.string(from: self.price) else {
                return NSLocalizedString("Unknown Price", comment: "")
            }

            return formattedPrice
        }
    }
}

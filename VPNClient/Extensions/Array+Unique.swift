//
//  Array+Unique.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.12.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}

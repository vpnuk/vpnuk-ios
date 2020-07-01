//
//  ServerDto.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//  Distributed under the GNU GPL v3 For full terms see the file LICENSE
//

import Foundation

class ParentServerDTO: Codable {
    var servers: [ServerDTO]?
}

enum ServerType: String, Codable, CaseIterable {
    case shared = "shared"
    case dedicated = "dedicated"
    case oneToOne = "dedicated11"
}

extension ServerType {
    var title: String {
        switch self {
        case .dedicated:
            return "Dedicated IP"
        case .shared:
            return "Shared IP"
        case .oneToOne:
            return "1:1 Dedicated IP"
        }
    }
    
    var shortTitle: String {
        switch self {
        case .dedicated:
            return "Dedicated"
        case .shared:
            return "Shared"
        case .oneToOne:
            return "1:1"
        }
    }
}

extension ServerType: Comparable {
    static func < (lhs: ServerType, rhs: ServerType) -> Bool {
        switch (lhs, rhs)
        {
        case    (.shared, .dedicated),
                (.shared, .oneToOne):
            return true
        case    (.dedicated, .oneToOne):
            return true
        default:
            return false
        }
    }
}

class ServerDTO: Codable {
    var location: ServerLocation?
    var type: ServerType?
    var address: String?
    var dns: String?
    var speed: String?
    
    init(location: ServerLocation?, type: ServerType?, address: String?, dns: String?, speed: String?) {
        self.location = location
        self.type = type
        self.address = address
        self.dns = dns
        self.speed = speed
    }
}

class ServerLocation: Codable {
    var name: String?
    var icon: String?
    var city: String?
    
    init(name: String?, icon: String?, city: String?) {
         self.name = name
         self.icon = icon
         self.city = city
     }
}

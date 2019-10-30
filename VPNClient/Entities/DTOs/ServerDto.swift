//
//  ServerDto.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//

import Foundation

class ParentServerDTO: Codable {
    var server: [ServerDTO]?
}

enum ServerType: String, Codable {
    case dedicated = "dedicated"
    case shared = "shared"
}


class ServerDTO: Codable {
    var location: ServerLocation?
    var type: ServerType?
    var address: String?
    var dns: String?
    var speed: String?
    
    internal init(location: ServerLocation?, type: ServerType?, address: String?, dns: String?, speed: String?) {
        self.location = location
        self.type = type
        self.address = address
        self.dns = dns
        self.speed = speed
    }
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case type
        case address
        case dns
        case speed

    }
}

class ServerLocation: Codable {
    internal init(name: String?, icon: String?, city: String?) {
        self.name = name
        self.icon = icon
        self.city = city
    }
    
    var name: String?
    var icon: String?
    var city: String?
    
    enum CodingKeys: String, CodingKey {
         case name = "CharToken"
         case icon
         case city
     }
}

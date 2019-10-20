//
//  ServerDto.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//

import Foundation

class ServersDTO: Codable {
    var servers: [ServerDTO]?
}

enum ServerType: String, Codable {
    case dedicated = "dedicated"
    case shared = "shared"
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
}

class ServerDTO: Codable {
    internal init(location: ServerLocation?, type: ServerType?, address: String?, dns: String?, speed: String?) {
        self.location = location
        self.type = type
        self.address = address
        self.dns = dns
        self.speed = speed
    }
    

    var location: ServerLocation?
    var type: ServerType?
    var address: String?
    var dns: String?
    var speed: String?
}

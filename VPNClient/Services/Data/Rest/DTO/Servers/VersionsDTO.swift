//
//  ServersVersionDTO.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 26.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//  Distributed under the GNU GPL v3 For full terms see the file LICENSE
//

import Foundation

class VersionsDTO: Codable {
    var servers: String?
    var ovpn: String?
    var win32Generic: String?
    
    init(servers: String? = nil, ovpn: String? = nil, win32Generic: String? = nil) {
        self.servers = servers
        self.ovpn = ovpn
        self.win32Generic = win32Generic
    }
    
    enum CodingKeys: String, CodingKey {
        case servers
        case win32Generic = "win32_generic"
        case ovpn
    }
}

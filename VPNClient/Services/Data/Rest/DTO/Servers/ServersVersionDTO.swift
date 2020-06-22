//
//  ServersVersionDTO.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 26.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//  Distributed under the GNU GPL v3 For full terms see the file LICENSE
//

import Foundation

class ServersVersionDTO: Codable {
    internal init(servers: String?, win32Generic: String?) {
        self.servers = servers
        self.win32Generic = win32Generic
    }
    
    var servers: String?
    var win32Generic: String?
    
    
    enum CodingKeys: String, CodingKey {
        case servers
        case win32Generic = "win32_generic"
    }
}

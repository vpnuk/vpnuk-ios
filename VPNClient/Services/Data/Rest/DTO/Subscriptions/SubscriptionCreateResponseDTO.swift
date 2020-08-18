//
//  SubscriptionCreateResponseDTO.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.06.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

struct SubscriptionCreateResponseDTO: Codable {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

//
//  PendingSubscriptionOrderDTO.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.12.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

struct PendingSubscriptionOrderDTO: Codable, Equatable {
    let orderId: Int
    let product: Product
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case product = "product"
    }
}

extension PendingSubscriptionOrderDTO {
    struct Product: Codable, Equatable {
        let productId: Int
        let quantity: Int
        
        enum CodingKeys: String, CodingKey {
            case productId = "product_id"
            case quantity = "quantity"
        }
    }
}

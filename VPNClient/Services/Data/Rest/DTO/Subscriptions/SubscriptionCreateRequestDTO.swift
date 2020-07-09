//
//  SubscriptionCreateRequestDTO.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 08.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

enum ProductIdSource: String, Codable {
    case vpnuk
    case apple
}

struct SubscriptionCreateRequestDTO: Codable {
    let productId: String
    let productIdSource: ProductIdSource
    let quantity: Int?
    let country: String?
    
    init(productId: String, productIdSource: ProductIdSource, quantity: Int? = nil, country: String? = nil) {
        self.productId = productId
        self.productIdSource = productIdSource
        self.quantity = quantity
        self.country = country
    }
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productIdSource = "product_id_source"
        case quantity = "quantity"
        case country = "country"
    }
}

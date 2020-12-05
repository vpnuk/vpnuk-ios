//
//  IAPReceiptDTO.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 13.10.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

struct IAPReceiptDTO: Codable {
    let receipt: String
    let country: String?
}


struct IAPReceiptWithoutCountryDTO: Codable {
    let receipt: String
}

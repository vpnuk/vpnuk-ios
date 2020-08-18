//
//  ReceiptResponseEntity.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 18.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

class ReceiptResponseEntity: Codable {
    var latest_receipt_info: [ReceiptInfoEntity]?
}

class ReceiptInfoEntity: Codable {
    var quantity: String?
    var purchase_date_ms: String?
    var expires_date: String?
    
    var expiresDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        guard let expiresDateStr = expires_date, let expirationDate = formatter.date(from: expiresDateStr) else {
            return nil
        }
        return expirationDate
    }
   
    
    var expires_date_pst: String?
    var is_in_intro_offer_period: String?
    var transaction_id: String?
    var purchase_date: String?
    var product_id: String?
    var product: PurchaseProduct? {
        if let id = product_id {
            return PurchaseProduct(rawValue: id)
        } else {
            return nil
        }
    }
    var original_purchase_date_pst: String?
    var original_purchase_date_ms: String?
    var web_order_line_item_id: String?
    var expires_date_ms: String?
    var purchase_date_pst: String?
    var original_purchase_date: String?
}

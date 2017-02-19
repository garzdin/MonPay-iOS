//
//  Account.swift
//  MonPay
//
//  Created by Teodor on 17/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import Foundation

fileprivate let dateFormat: String = "yyyy-MM-dd HH:mm:ss.S"

class Account: NSObject {
    var id: Int?
    var iban: String?
    var bic_swift: String?
    var currency: String?
    var country: String?
    var created_on: Date?
    var updated_on: Date?
    var version: Int?
    
    init(values: Dictionary<String, Any>) {
        super.init()
        if let id = values["id"] as? Int {
            self.id = id
        }
        if let iban = values["iban"] as? String {
            self.iban = iban
        }
        if let bic_swift = values["bic_swift"] as? String {
            self.bic_swift = bic_swift
        }
        if let currency = values["currency"] as? String {
            self.currency = currency
        }
        if let country = values["country"] as? String {
            self.country = country
        }
        if let created_on = values["created_on"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            self.created_on = formatter.date(from: created_on)
        }
        if let updated_on = values["updated_on"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            self.updated_on = formatter.date(from: updated_on)
        }
        if let version = values["version"] as? Int {
            self.version = version
        }
    }
}

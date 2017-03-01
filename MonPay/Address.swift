//
//  Address.swift
//  MonPay
//
//  Created by Teodor on 17/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import Foundation

fileprivate let dateTimeFormat: String = "yyyy-MM-dd HH:mm:ss.S"

class Address: NSObject {
    var id: Int?
    var address: String?
    var city: String?
    var state_or_province: String?
    var postal_code: Int?
    var country: String?
    var created_on: Date?
    var updated_on: Date?
    var version: Int?

    convenience init(values: Dictionary<String, Any>) {
        self.init()
        if let id = values["id"] as? Int {
            self.id = id
        }
        if let address = values["address"] as? String {
            self.address = address
        }
        if let city = values["city"] as? String {
            self.city = city
        }
        if let state_or_province = values["state_or_province"] as? String {
            self.state_or_province = state_or_province
        }
        if let postal_code = values["postal_code"] as? Int {
            self.postal_code = postal_code
        }
        if let country = values["country"] as? String {
            self.country = country
        }
        if let created_on = values["created_on"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = dateTimeFormat
            self.created_on = formatter.date(from: created_on)
        }
        if let updated_on = values["updated_on"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = dateTimeFormat
            self.updated_on = formatter.date(from: updated_on)
        }
        if let version = values["version"] as? Int {
            self.version = version
        }
    }
}

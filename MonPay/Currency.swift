//
//  Currency.swift
//  MonPay
//
//  Created by Teodor on 04/03/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import Foundation

fileprivate let dateTimeFormat: String = "yyyy-MM-dd HH:mm:ss.S"

class Currency: NSObject {
    var id: Int?
    var isoCode: String?
    var displayName: String?
    var created_on: Date?
    var updated_on: Date?
    var version: Int?
    
    convenience init(values: Dictionary<String, Any>) {
        self.init()
        if let id = values["id"] as? Int {
            self.id = id
        }
        if let isoCode = values["iso_code"] as? String {
            self.isoCode = isoCode
        }
        if let displayName = values["display_name"] as? String {
            self.displayName = displayName
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

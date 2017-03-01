//
//  Transaction.swift
//  MonPay
//
//  Created by Teodor on 17/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import Foundation

fileprivate let dateTimeFormat: String = "yyyy-MM-dd HH:mm:ss.S"

class Transaction: NSObject {
    var id: Int?
    var reference: String?
    var amount: Float?
    var currency: String?
    var reason: String?
    var completed: Bool?
    var user: User?
    var beneficiary: Beneficiary?
    var account: Account?
    var created_on: Date?
    var updated_on: Date?
    var version: Int?
    
    convenience init(values: Dictionary<String, Any>) {
        self.init()
        if let id = values["id"] as? Int {
            self.id = id
        }
        if let reference = values["reference"] as? String {
            self.reference = reference
        }
        if let amount = values["amount"] as? Float {
            self.amount = amount
        }
        if let currency = values["currency"] as? String {
            self.currency = currency
        }
        if let reason = values["reason"] as? String {
            self.reason = reason
        }
        if let completed = values["completed"] as? Bool {
            self.completed = completed
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

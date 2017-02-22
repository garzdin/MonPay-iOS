//
//  User.swift
//  MonPay
//
//  Created by Teodor on 17/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import Foundation

fileprivate let dateFormat: String = "yyyy-MM-dd"
fileprivate let dateTimeFormat: String = "yyyy-MM-dd HH:mm:ss.S"

class User: NSObject {
    var id: Int?
    var entity_type: Int?
    var first_name: String?
    var last_name: String?
    var date_of_birth: Date?
    var email: String?
    var password: String?
    var address: Address?
    var id_type: Int?
    var id_value: String?
    var is_admin: Bool?
    var accounts: [Account]?
    var created_on: Date?
    var updated_on: Date?
    var version: Int?
    
    init(values: Dictionary<String, Any>) {
        super.init()
        if let id = values["id"] as? Int {
            self.id = id
        }
        if let entity_type = values["entity_type"] as? Int {
            self.entity_type = entity_type
        }
        if let first_name = values["first_name"] as? String {
            self.first_name = first_name
        }
        if let last_name = values["last_name"] as? String {
            self.last_name = last_name
        }
        if let date_of_birth = values["date_of_birth"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            self.date_of_birth = formatter.date(from: date_of_birth)
        }
        if let email = values["email"] as? String {
            self.email = email
        }
        if let password = values["password"] as? String {
            self.password = password
        }
        if let address = values["address"] as? Dictionary<String, Any> {
            self.address = Address(values: address, entity: self)
        }
        if let id_type = values["id_type"] as? Int {
            self.id_type = id_type
        }
        if let id_value = values["id_value"] as? String {
            self.id_value = id_value
        }
        if let is_admin = values["is_admin"] as? Bool {
            self.is_admin = is_admin
        }
        if let accounts = values["accounts"] as? [Dictionary<String, Any>] {
            for account in accounts {
                self.accounts?.append(Account(values: account))
            }
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

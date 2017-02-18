//
//  Keychain.swift
//  MonPay
//
//  Created by Teodor on 18/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import Foundation
import KeychainSwift

class Keychain: NSObject {
    static let sharedInstance = KeychainSwift(keyPrefix: "mP_")
}

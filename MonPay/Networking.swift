//
//  Networking.swift
//  MonPay
//
//  Created by Teodor on 18/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import Foundation
import Alamofire

class Networking: NSObject {
    let endpoint: URLConvertible = "https://monpay.herokuapp.com/api/v1/"
    let version: Int = 1
    static let sharedInstance = Networking()
    
    func request(url: URLConvertible, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, completion: @escaping (_ response: [String: Any]?, _ error: [String: Any]?) -> Void) {
        Alamofire.request("\(endpoint)\(url)", method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let responseDict = response.result.value as? [String: Any] {
                if let status = responseDict["status"] as? Bool {
                    if status == true {
                        completion(responseDict, nil)
                    }
                } else {
                    completion(nil, responseDict)
                }
            }
        }
    }
}

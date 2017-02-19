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
    
    func request(url: URLConvertible, method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, headers: HTTPHeaders, completion: @escaping (_ response: [String: Any]?, _ error: [String: Any]?) -> Void) {
        Alamofire.request("\(endpoint)\(url)", method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
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
    
    func authenticatedRequest(url: URLConvertible, method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, headers: HTTPHeaders, completion: @escaping (_ response: [String: Any]?, _ error: [String: Any]?) -> Void) {
        var unifiedHeaders: Dictionary<String, String> = Dictionary()
        if let token = Keychain.sharedInstance.get("token") {
            unifiedHeaders["Authorization"] = token
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController")
            initialViewController.view.frame = CGRect(x: initialViewController.view.frame.origin.x, y: -(initialViewController.view.frame.size.width * 2), width: initialViewController.view.frame.size.width, height: initialViewController.view.frame.size.height)
            UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                UIApplication.shared.keyWindow?.rootViewController = initialViewController
                initialViewController.view.frame = CGRect(x: initialViewController.view.frame.origin.x, y: 0, width: initialViewController.view.frame.size.width, height: initialViewController.view.frame.size.height)
            }, completion: nil)
        }
        headers.forEach {
            unifiedHeaders.updateValue($1, forKey: $0)
        }
        Networking.sharedInstance.request(url: url, method: method, parameters: parameters, encoding: encoding, headers: unifiedHeaders) { (response) in
            if response.1 == nil {
                completion(response.0, response.1)
            } else {
                if let description = response.1?["description"] as? String {
                    if description.contains("expired") {
                        if let refresh_token = Keychain.sharedInstance.get("refresh_token") {
                            let params: HTTPHeaders = [
                                "refresh_token": refresh_token
                            ]
                            Networking.sharedInstance.request(url: "auth/refresh", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]) { (response) in
                                if response.1 == nil {
                                    if let token = response.0?["token"] as? String, let refresh_token = response.0?["refresh_token"] as? String {
                                        Keychain.sharedInstance.set(token, forKey: "token")
                                        Keychain.sharedInstance.set(refresh_token, forKey: "refresh_token")
                                    }
                                }
                            }
                            var unifiedHeaders: Dictionary<String, String> = [
                                "Authorization": Keychain.sharedInstance.get("token")!
                            ]
                            headers.forEach {
                                unifiedHeaders.updateValue($1, forKey: $0)
                            }
                            Networking.sharedInstance.request(url: url, method: method, parameters: parameters, encoding: encoding, headers: unifiedHeaders) { (response) in
                                if response.1 == nil {
                                    completion(response.0, response.1)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

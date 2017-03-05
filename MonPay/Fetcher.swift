//
//  Fetcher.swift
//  MonPay
//
//  Created by Teodor on 19/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import Foundation
import Alamofire

class Fetcher: NSObject {
    static var sharedInstance = Fetcher()
    let endpoint: URLConvertible = "https://monpay.herokuapp.com/api/v1/"
    
    // MARK: - Request setup
    
    func request(url: URLConvertible, method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, headers: HTTPHeaders, authRequired: Bool, completion: @escaping (_ response: [String: Any]?) -> ()) {
        var unifiedHeaders: Dictionary<String, String> = Dictionary()
        if authRequired == true {
            if let token = Keychain.sharedInstance.get("token") {
                unifiedHeaders["Authorization"] = token
            } else {
                self.redirectToLogin()
            }
        }
        headers.forEach {
            unifiedHeaders.updateValue($1, forKey: $0)
        }
        Alamofire.request("\(self.endpoint)\(url)", method: method, parameters: parameters, encoding: encoding, headers: authRequired ? unifiedHeaders : headers).responseJSON { (response: DataResponse<Any>) in
            if let json = response.result.value as? [String: Any] {
                if let description = json["description"] as? [String: Any] {
                    if let token = description["token"] as? String {
                        if token.contains("expired") {
                            if let refresh_token = Keychain.sharedInstance.get("refresh_token") {
                                let params: HTTPHeaders = [
                                    "refresh_token": refresh_token
                                ]
                                Alamofire.request("\(self.endpoint)auth/refresh", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON(completionHandler: { (response) in
                                    if let json = response.result.value as? [String: Any] {
                                        if let token = json["token"] as? String, let refresh_token = json["refresh_token"] as? String {
                                            Keychain.sharedInstance.set(token, forKey: "token")
                                            Keychain.sharedInstance.set(refresh_token, forKey: "refresh_token")
                                        } else {
                                            self.redirectToLogin()
                                        }
                                    }
                                })
                                unifiedHeaders["Authorization"] = Keychain.sharedInstance.get("token")
                                Alamofire.request("\(self.endpoint)\(url)", method: method, parameters: parameters, encoding: encoding, headers: unifiedHeaders).responseJSON(completionHandler: { (response) in
                                    if let json = response.result.value as? [String: Any] {
                                        completion(json)
                                    }
                                })
                            } else {
                                self.redirectToLogin()
                            }
                        } else {
                            completion(json)
                        }
                    } else {
                        completion(json)
                    }
                } else {
                    completion(json)
                }
            }
        }
    }
    
    // MARK: - Redirect to login screen
    
    func redirectToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController")
        initialViewController.view.frame = CGRect(x: initialViewController.view.frame.origin.x, y: -(initialViewController.view.frame.size.width * 2), width: initialViewController.view.frame.size.width, height: initialViewController.view.frame.size.height)
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            UIApplication.shared.keyWindow?.rootViewController = initialViewController
            initialViewController.view.frame = CGRect(x: initialViewController.view.frame.origin.x, y: 0, width: initialViewController.view.frame.size.width, height: initialViewController.view.frame.size.height)
        }, completion: nil)
    }
    
    // MARK: - Upload file
    
    func uploadFile(file: Data, completion: @escaping (_ progress: Progress?, _ response: DataResponse<Any>?) -> ()) {
        Alamofire.upload(file, to: "\(self.endpoint)upload/file")
            .uploadProgress { (progress: Progress) in
            completion(progress, nil)
        }
            .responseJSON { (response: DataResponse<Any>) in
                completion(nil, response)
        }
    }
    
    // MARK: - Auth endpoints
    
    func authCreate(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "auth/create", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: false) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func authLogin(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "auth/login", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: false) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func authReset(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "auth/reset", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: false) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
     // MARK: - User endpoints
    
    func userGet(completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "user", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func userUpdate(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "user/update", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func userAddressUpdate(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "user/address", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    // MARK: - Account endpoints
    
    func accountList(completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "account", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func accountGet(id: Int, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "account/\(id)", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func accountCreate(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "account/create", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func accountUpdate(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "account/update", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func accountActivate(id: Int, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "account/\(id)/activate", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func accountDelete(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "account/delete", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    // MARK: - Currency endpoints
    
    func currencyList(completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "currency", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func currencyGet(id: Int, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "currency/\(id)", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    // MARK: - Conversion endpoints
    func conversionCreate(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "convert", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    // MARK: - Beneficiary endpoints
    
    func beneficiaryList(completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "beneficiary", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func beneficiaryGet(id: Int, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "beneficiary/\(id)", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func beneficiaryCreate(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        var params = params
        if var account = params.removeValue(forKey: "account") as? [String: Any] {
            self.request(url: "beneficiary/create", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
                if let beneficiary = response?["beneficiary"] as? [String: Any] {
                    if let id = beneficiary["id"] as? Int {
                        account["beneficiary"] = id
                        self.request(url: "account/create", method: .post, parameters: account, encoding: JSONEncoding.default, headers: [:], authRequired: true, completion: { (accountResponse: [String : Any]?) in
                            if let singleAccount = accountResponse?["account"] as? [String: Any] {
                                if let accountBeneficiary = singleAccount["beneficiary"] as? Int {
                                    self.request(url: "beneficiary/\(accountBeneficiary)", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true, completion: { (beneficiaryResponse: [String : Any]?) in
                                        completion(beneficiaryResponse)
                                    })
                                }
                            } else {
                                completion(accountResponse)
                            }

                        })
                    }
                } else {
                    completion(response)
                }
            }
        }
    }
    
    func beneficiaryUpdate(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "beneficiary/update", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func beneficiaryDelete(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "beneficiary/delete", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    // MARK: - Transaction endpoints
    
    func transactionList(completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "transaction", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func transactionGet(id: Int, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "transaction/\(id)", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func transactionCreate(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "transaction/create", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
    
    func transactionDelete(params: Parameters, completion: @escaping (_ response: [String: Any]?) -> ()) {
        self.request(url: "transaction/delete", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:], authRequired: true) { (response: [String : Any]?) in
            completion(response)
        }
    }
}

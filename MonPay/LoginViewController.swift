//
//  LoginViewController.swift
//  MonPay
//
//  Created by Teodor on 26/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameFieldErrorLabel: UILabel!
    @IBOutlet var passwordFieldErrorLabel: UILabel!
    
    @IBOutlet var usernameField: UnderlinedTextField! {
        didSet {
            usernameField.delegate = self
        }
    }
    @IBOutlet var passwordField: UnderlinedTextField! {
        didSet {
            passwordField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        }
        return false
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.usernameFieldErrorLabel.text = ""
        self.passwordFieldErrorLabel.text = ""
        if(self.usernameField.text == "") {
            self.usernameFieldErrorLabel.text = "Username required"
            return
        }
        if(self.passwordField.text == "") {
            self.passwordFieldErrorLabel.text = "Password required"
            return
        }
        let params = [
            "email": usernameField.text,
            "password": passwordField.text
        ]
        Networking.sharedInstance.request(url: "auth/login", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]) { (response) in
            if response.1 == nil {
                if let token = response.0?["token"] as? String, let refresh_token = response.0?["refresh_token"] as? String {
                    Keychain.sharedInstance.set(token, forKey: "token")
                    Keychain.sharedInstance.set(refresh_token, forKey: "refresh_token")
                    self.performSegue(withIdentifier: "authenticated", sender: sender)
                }
            } else {
                if let errorDict = response.1 as [String: Any]? {
                    if let title = errorDict["title"] as? String, let description = errorDict["description"] as? String {
                        if title.contains("404") {
                            self.usernameFieldErrorLabel.text = description
                        } else {
                            self.passwordFieldErrorLabel.text = description
                        }
                    }
                }
                return
            }
        }
    }
}

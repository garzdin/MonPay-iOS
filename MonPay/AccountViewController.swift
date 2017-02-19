//
//  AccountViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

class AccountViewController: UIViewController {

    @IBOutlet var emailField: UnderlinedTextField!
    @IBOutlet var firstNameField: UnderlinedTextField!
    @IBOutlet var lastNameField: UnderlinedTextField!
    @IBOutlet var dateOfBirthField: UnderlinedTextField!
    @IBOutlet var postalCodeField: UnderlinedTextField!
    @IBOutlet var cityField: UnderlinedTextField!
    @IBOutlet var countryField: UnderlinedTextField!
    @IBOutlet var addressField: UnderlinedTextField!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAccountInfo()
        emailField.isEnabled = false
        firstNameField.isEnabled = false
        lastNameField.isEnabled = false
        dateOfBirthField.isEnabled = false
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let user = user {
            let params: [String : Any] = [
                "id": user.id,
                "update": [
                    "address": [
                        "postal_code": postalCodeField.text,
                        "city": cityField.text,
                        "country": countryField.text,
                        "address": addressField.text
                    ]
                ]
            ]
            Networking.sharedInstance.authenticatedRequest(url: "user/update/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]) { (response) in
                if response.1 == nil {
                    print(response.0)
                } else {
                    if let errorDict = response.1 as [String: Any]? {
                        print(errorDict)
                    }
                    return
                }
            }
        }
    }
    
    @IBAction func unwindToAccount(segue: UIStoryboardSegue) {}
    
    func getAccountInfo() {
        Networking.sharedInstance.authenticatedRequest(url: "user", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:]) { (response) in
            if response.1 == nil {
                if let user = response.0?["user"] as? [String: Any] {
                    self.user = User(values: user)
                    self.emailField.text = self.user?.email
                    self.firstNameField.text = self.user?.first_name
                    self.lastNameField.text = self.user?.last_name
                }
            } else {
                if let errorDict = response.1 as [String: Any]? {
                    print(errorDict)
                }
                return
            }
        }
    }

}

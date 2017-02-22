//
//  AccountViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

fileprivate let dateFormat: String = "yyyy-MM-dd"

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
        if let address = self.addressField.text,
            let city = self.cityField.text,
            let postalCode = self.postalCodeField.text,
            let country = self.countryField.text {
            let params: [String : Any] = [
                "address": address,
                "city": city,
                "postal_code": postalCode,
                "country": country
            ]
            Fetcher.sharedInstance.userAddressUpdate(params: params, completion: { (response: [String : Any]?) in
                // Update interface
                print(response)
            })
        }
    }
    
    @IBAction func unwindToAccount(segue: UIStoryboardSegue) {}
    
    func getAccountInfo() {
        Fetcher.sharedInstance.userGet { (response: [String : Any]?) in
            if let user = response?["user"] as? [String: Any] {
                self.user = User(values: user)
                self.emailField.text = self.user?.email
                self.firstNameField.text = self.user?.first_name
                self.lastNameField.text = self.user?.last_name
                if let date_of_birth = self.user?.date_of_birth {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = dateFormat
                    if let regionCode = Locale.current.regionCode {
                        dateFormatter.locale = Locale.init(identifier: regionCode)
                    }
                    self.dateOfBirthField.text = dateFormatter.string(from: date_of_birth)
                }
                if let address = self.user?.address {
                    if let postal_code = address.postal_code {
                        self.postalCodeField.text = "\(postal_code)"
                    }
                    self.cityField.text = address.city
                    self.countryField.text = address.country
                    self.addressField.text = address.address
                }
            }
        }
    }
}

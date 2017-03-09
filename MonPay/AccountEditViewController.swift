//
//  AccountEditViewController.swift
//  MonPay
//
//  Created by Teodor on 06/03/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

class AccountEditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var firstNameField: UnderlinedTextField! {
        didSet {
            firstNameField.delegate = self
        }
    }
    @IBOutlet var lastNameField: UnderlinedTextField! {
        didSet {
            lastNameField.delegate = self
        }
    }
    @IBOutlet var emailField: UnderlinedTextField! {
        didSet {
            emailField.delegate = self
        }
    }
    @IBOutlet var addressField: UnderlinedTextField! {
        didSet {
            addressField.delegate = self
        }
    }
    @IBOutlet var cityField: UnderlinedTextField! {
        didSet {
            cityField.delegate = self
        }
    }
    @IBOutlet var postalCodeField: UnderlinedTextField! {
        didSet {
            postalCodeField.delegate = self
        }
    }
    @IBOutlet var countryField: UnderlinedTextField! {
        didSet {
            countryField.delegate = self
        }
    }
    @IBOutlet var firstNameErrorLabel: UILabel!
    @IBOutlet var lastNameErrorLabel: UILabel!
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var addressErrorLabel: UILabel!
    @IBOutlet var cityErrorLabel: UILabel!
    @IBOutlet var postalCodeErrorLabel: UILabel!
    @IBOutlet var countryErrorLabel: UILabel!
    
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFields()
        self.alert = UIAlertController(title: "", message: "Your account has been updated", preferredStyle: .alert)
    }
    
    func setupFields() {
        if let user = DataStore.shared.user {
            if let firstName = user.first_name {
                self.firstNameField.text = firstName
            }
            if let lastName = user.last_name {
                self.lastNameField.text = lastName
            }
            if let email = user.email {
                self.emailField.text = email
            }
            if let address = user.address {
                if let addressLine = address.address {
                    self.addressField.text = addressLine
                }
                if let city = address.city {
                    self.cityField.text = city
                }
                if let postalCode = address.postal_code {
                    self.postalCodeField.text = "\(postalCode)"
                }
                if let country = address.country {
                    self.countryField.text = country
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case firstNameField:
            lastNameField.becomeFirstResponder()
            break
        case lastNameField:
            emailField.becomeFirstResponder()
            break
        case emailField:
            addressField.becomeFirstResponder()
            break
        case addressField:
            cityField.becomeFirstResponder()
            break
        case cityField:
            postalCodeField.becomeFirstResponder()
            break
        case postalCodeField:
            countryField.becomeFirstResponder()
            break
        default: break
        }
        return false
    }
    
    func checkFields() -> Bool {
        self.resetErrors()
        if self.firstNameField.text == "" {
            self.firstNameErrorLabel.text = "First name is required"
            self.firstNameField.becomeFirstResponder()
            return false
        }
        if self.lastNameField.text == "" {
            self.lastNameErrorLabel.text = "Last name is required"
            self.lastNameField.becomeFirstResponder()
            return false
        }
        if self.emailField.text == "" {
            self.emailErrorLabel.text = "Email is required"
            self.emailField.becomeFirstResponder()
            return false
        } else {
            if self.checkEmail(email: self.emailField.text!) == false {
                self.emailErrorLabel.text = "Email is invalid"
                self.emailField.becomeFirstResponder()
                return false
            }
        }
        if self.addressField.text == "" {
            self.addressErrorLabel.text = "Address is required"
            self.addressField.becomeFirstResponder()
            return false
        }
        if self.cityField.text == "" {
            self.cityErrorLabel.text = "City is required"
            self.cityField.becomeFirstResponder()
            return false
        }
        if self.postalCodeField.text == "" {
            self.postalCodeErrorLabel.text = "Postal code is required"
            self.postalCodeField.becomeFirstResponder()
            return false
        }
        if self.countryField.text == "" {
            self.countryErrorLabel.text = "Country is required"
            self.countryField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func checkEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    func resetErrors() {
        self.firstNameErrorLabel.text = ""
        self.lastNameErrorLabel.text = ""
        self.emailErrorLabel.text = ""
        self.addressErrorLabel.text = ""
        self.cityErrorLabel.text = ""
        self.postalCodeErrorLabel.text = ""
        self.countryErrorLabel.text = ""
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if self.checkFields() == true {
            self.view.endEditing(true)
            let params: Parameters = [
                "first_name": self.firstNameField.text!,
                "last_name": self.lastNameField.text!,
                "email": self.emailField.text!
            ]
            let addressParams: Parameters = [
                "address": self.addressField.text!,
                "city": self.cityField.text!,
                "postal_code": self.postalCodeField.text!,
                "country": self.countryField.text!
            ]
            Fetcher.sharedInstance.userUpdate(params: params, completion: { (response: [String : Any]?) in
                if let _ = response?["user"] as? [String: Any] {
                    Fetcher.sharedInstance.userAddressUpdate(params: addressParams, completion: { (addressResponse: [String : Any]?) in
                        if let _ = addressResponse?["address"] as? [String: Any] {
                            self.present(self.alert!, animated: true, completion: nil)
                            let when = DispatchTime.now() + 2
                            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                                self.alert?.dismiss(animated: true, completion: {
                                    self.dismiss(animated: true, completion: nil)
                                })
                            })
                        }
                    })
                }
            })
        }
    }
}

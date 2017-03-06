//
//  AccountEditViewController.swift
//  MonPay
//
//  Created by Teodor on 06/03/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFields()
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
    
    @IBAction func saveAction(_ sender: UIButton) {
        // SAVE
    }
}

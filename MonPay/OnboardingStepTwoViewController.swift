//
//  OnboardingStepTwoViewController.swift
//  MonPay
//
//  Created by Teodor on 23/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

fileprivate let dateFormat: String = "yyyy-MM-dd"

class OnboardingStepTwoViewController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet var dateOfBirthField: UnderlinedTextField! {
        didSet {
            dateOfBirthField.delegate = self
        }
    }
    @IBOutlet var postalCodeField: UnderlinedTextField! {
        didSet {
            postalCodeField.delegate = self
        }
    }
    @IBOutlet var cityField: UnderlinedTextField! {
        didSet {
            cityField.delegate = self
        }
    }
    @IBOutlet var countryField: UnderlinedTextField! {
        didSet {
            countryField.delegate = self
        }
    }
    @IBOutlet var addressField: UnderlinedTextField! {
        didSet {
            addressField.delegate = self
        }
    }
    
    var user: User?
    var address: Address?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.address = Address()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onboardingStepThree" {
            if let destination = segue.destination as? OnboardingStepThreeViewController {
                destination.user = self.user
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case self.firstNameField:
            self.user?.first_name = self.firstNameField.text
            self.lastNameField.becomeFirstResponder()
            break
        case self.lastNameField:
            self.user?.last_name = self.lastNameField.text
            self.dateOfBirthField.becomeFirstResponder()
            break
        case self.dateOfBirthField:
            if let dateOfBirth = self.dateOfBirthField.text {
                let formatter = DateFormatter()
                formatter.dateFormat = dateFormat
                self.user?.date_of_birth = formatter.date(from: dateOfBirth)
                self.postalCodeField.becomeFirstResponder()
            }
            break
        case self.postalCodeField:
            if let postalCode = self.postalCodeField.text {
                self.address?.postal_code = Int(postalCode)
                self.cityField.becomeFirstResponder()
            }
            break
        case self.cityField:
            self.address?.city = self.cityField.text
            self.countryField.becomeFirstResponder()
            break
        case self.countryField:
            self.address?.country = self.countryField.text
            self.addressField.becomeFirstResponder()
            break
        case self.addressField:
            self.address?.address = self.addressField.text
            self.user?.address = self.address
            self.performSegue(withIdentifier: "onboardingStepThree", sender: self)
            break
        default: break
        }
        return false
    }
    
    @IBAction func unwindToStepTwo(segue: UIStoryboardSegue) {}
}

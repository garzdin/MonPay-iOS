//
//  OnboardingStepTwoViewController.swift
//  MonPay
//
//  Created by Teodor on 23/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

fileprivate let dateFormat: String = "yyyy-MM-dd"
fileprivate let datePickerHeight: CGFloat = 120.0

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
    
    @IBOutlet var firstNameError: UILabel!
    @IBOutlet var lastNameError: UILabel!
    @IBOutlet var dateOfBirthError: UILabel!
    @IBOutlet var postalCodeError: UILabel!
    @IBOutlet var cityError: UILabel!
    @IBOutlet var countryError: UILabel!
    @IBOutlet var addressError: UILabel!
    
    
    var datePicker: UIDatePicker?
    
    var user: User?
    var address: Address?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.address = Address()
        self.setupDatePicker()
        self.dateOfBirthField.inputView = self.datePicker
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
            if validateFirstName() == true {
                self.user?.first_name = self.firstNameField.text
                self.firstNameError.text = ""
                self.lastNameField.becomeFirstResponder()
            }
            break
        case self.lastNameField:
            if validateLastName() == true {
                self.user?.last_name = self.lastNameField.text
                self.lastNameError.text = ""
                self.dateOfBirthField.becomeFirstResponder()
            }
            break
        case self.dateOfBirthField:
            if let dateOfBirth = self.dateOfBirthField.text {
                let formatter = DateFormatter()
                formatter.dateFormat = dateFormat
                self.user?.date_of_birth = formatter.date(from: dateOfBirth)
                self.dateOfBirthError.text = ""
                self.postalCodeField.becomeFirstResponder()
            }
            break
        case self.postalCodeField:
            if validatePostalCode() == true {
                if let postalCode = self.postalCodeField.text {
                    self.address?.postal_code = Int(postalCode)
                    self.postalCodeError.text = ""
                    self.cityField.becomeFirstResponder()
                }
            }
            break
        case self.cityField:
            if validateCity() == true {
                self.address?.city = self.cityField.text
                self.cityError.text = ""
                self.countryField.becomeFirstResponder()
            }
            break
        case self.countryField:
            if validateCountry() == true {
                self.address?.country = self.countryField.text
                self.countryError.text = ""
                self.addressField.becomeFirstResponder()
            }
            break
        case self.addressField:
            if validateFirstName() == true && validateLastName() == true && validateDateOfBirth() == true && validatePostalCode() == true && validateCity() == true && validateCountry() == true && validateAddress() == true {
                self.address?.address = self.addressField.text
                self.user?.address = self.address
                self.clearErrors()
                self.performSegue(withIdentifier: "onboardingStepThree", sender: self)
            }
            break
        default: break
        }
        return false
    }
    
    func setupDatePicker() {
        let frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height, width: self.view.frame.size.width, height: datePickerHeight)
        datePicker = UIDatePicker(frame: frame)
        datePicker?.backgroundColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0)
        datePicker?.setValue(UIColor.white, forKey: "textColor")
        datePicker?.timeZone = TimeZone.current
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(didChangeDate(sender:)), for: .valueChanged)
    }
    
    func didChangeDate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        self.dateOfBirthField.text = dateFormatter.string(from: sender.date)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.dateOfBirthField {
            UIView.animate(withDuration: 0.4) {
                self.datePicker?.frame.origin.y = (self.datePicker?.frame.origin.y)! - datePickerHeight
            }
        }
        return true
    }
    
    func validateFirstName() -> Bool {
        if self.firstNameField.text == "" {
            self.firstNameError.text = "First name required"
            self.firstNameField.becomeFirstResponder()
        } else {
            return true
        }
        return false
    }
    
    func validateLastName() -> Bool {
        if self.lastNameField.text == "" {
            self.lastNameError.text = "Last name required"
            self.lastNameField.becomeFirstResponder()
        } else {
            return true
        }
        return false
    }
    
    func validateDateOfBirth() -> Bool {
        if self.dateOfBirthField.text == "" {
            self.dateOfBirthError.text = "Date required"
            self.dateOfBirthField.becomeFirstResponder()
        } else {
            return true
        }
        return false
    }
    
    func validatePostalCode() -> Bool {
        if self.postalCodeField.text == "" {
            self.postalCodeError.text = "Postal code required"
            self.postalCodeField.becomeFirstResponder()
        } else {
            return true
        }
        return false
    }
    
    func validateCity() -> Bool {
        if self.cityField.text == "" {
            self.cityError.text = "City required"
            self.cityField.becomeFirstResponder()
        } else {
            return true
        }
        return false
    }
    
    func validateCountry() -> Bool {
        if self.countryField.text == "" {
            self.countryError.text = "Country required"
            self.countryField.becomeFirstResponder()
        } else {
            return true
        }
        return false
    }
    
    func validateAddress() -> Bool {
        if self.addressField.text == "" {
            self.addressError.text = "Address required"
            self.addressField.becomeFirstResponder()
        } else {
            return true
        }
        return false
    }
    
    func clearErrors() {
        self.firstNameError.text = ""
        self.lastNameError.text = ""
        self.dateOfBirthError.text = ""
        self.postalCodeError.text = ""
        self.cityError.text = ""
        self.countryError.text = ""
        self.addressError.text = ""
    }
    
    @IBAction func unwindToStepTwo(segue: UIStoryboardSegue) {}
}

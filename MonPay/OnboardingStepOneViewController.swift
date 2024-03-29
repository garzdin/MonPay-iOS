//
//  OnboardingStepOneViewController.swift
//  MonPay
//
//  Created by Teodor on 23/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class OnboardingStepOneViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: UnderlinedTextField! {
        didSet {
            emailField.delegate = self
        }
    }
    @IBOutlet var passwordField: UnderlinedTextField! {
        didSet {
            passwordField.delegate = self
        }
    }
    @IBOutlet var confirmPasswordField: UnderlinedTextField! {
        didSet {
            confirmPasswordField.delegate = self
        }
    }
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var passwordErrorLabel: UILabel!
    @IBOutlet var confirmErrorLabel: UILabel!
    
    var user: User?

    override func viewDidLoad() {
        self.user = User()
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onboardingStepTwo" {
            if let destination = segue.destination as? OnboardingStepTwoViewController {
                destination.user = self.user
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case self.emailField:
            self.passwordField.becomeFirstResponder()
            break
        case self.passwordField:
            self.confirmPasswordField.becomeFirstResponder()
            break
        case self.confirmPasswordField: break
        default: break
        }
        return false
    }
    
    func validateEmail() -> Bool {
        if self.emailField.text == "" {
            self.emailErrorLabel.text = "Email required"
            self.emailField.becomeFirstResponder()
        } else if validateEmail(enteredEmail: self.emailField.text!) == false {
            self.emailErrorLabel.text = "Email invalid"
            self.emailField.becomeFirstResponder()
        } else {
            self.emailErrorLabel.text = ""
            self.user?.email = self.emailField.text
            return true
        }
        return false
    }
    
    func validatePassword() -> Bool {
        if self.passwordField.text == "" {
            self.passwordErrorLabel.text = "Password required"
            self.passwordField.becomeFirstResponder()
        } else {
            self.passwordErrorLabel.text = ""
            self.user?.password = self.passwordField.text
            return true
        }
        return false
    }
    
    func validateConfirmPassword() -> Bool {
        if self.confirmPasswordField.text == "" {
            self.confirmErrorLabel.text = "Confirmation required"
            self.confirmPasswordField.becomeFirstResponder()
        } else if self.checkPassword() == false {
            self.confirmErrorLabel.text = "Passwords don't match"
            self.confirmPasswordField.becomeFirstResponder()
        } else {
            self.confirmErrorLabel.text = ""
            return true
        }
        return false
    }
    
    func clearErrors() {
        self.emailErrorLabel.text = ""
        self.passwordErrorLabel.text = ""
        self.confirmErrorLabel.text = ""
    }
    
    func checkPassword() -> Bool {
        if self.passwordField.text != self.confirmPasswordField.text {
            return false
        }
        return true
    }
    
    func validateEmail(enteredEmail: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    @IBAction func goToStepTwo(_ sender: UIButton) {
        if validateEmail() == true && validatePassword() == true && validateConfirmPassword() == true {
            self.clearErrors()
            self.performSegue(withIdentifier: "onboardingStepTwo", sender: self)
        }
    }
    
    @IBAction func unwindToStepOne(segue: UIStoryboardSegue) {}
}

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
            self.user?.email = self.emailField.text
            self.passwordField.becomeFirstResponder()
            break
        case self.passwordField:
            self.user?.password = self.passwordField.text
            self.confirmPasswordField.becomeFirstResponder()
            break
        case self.confirmPasswordField:
            if self.checkPassword() == true {
                self.performSegue(withIdentifier: "onboardingStepTwo", sender: self)
            } else {
                // Passwords do not match
            }
            break
        default: break
        }
        return false
    }
    
    func checkPassword() -> Bool {
        if self.passwordField.text != self.confirmPasswordField.text {
            return false
        }
        return true
    }
    
    @IBAction func unwindToStepOne(segue: UIStoryboardSegue) {}
}

//
//  ResetViewController.swift
//  MonPay
//
//  Created by Teodor on 10/03/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailField: UnderlinedTextField! {
        didSet {
            emailField.delegate = self
        }
    }
    @IBOutlet var emailErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func validateEmail(enteredEmail: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }

    @IBAction func resetAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.emailErrorLabel.text = ""
        if validateEmail(enteredEmail: self.emailField.text!) == true {
            // Send password reset email
        } else {
            self.emailErrorLabel.text = "Invalid email"
            self.emailField.becomeFirstResponder()
        }
    }
}

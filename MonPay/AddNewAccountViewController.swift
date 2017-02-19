//
//  AddNewAccountViewController.swift
//  MonPay
//
//  Created by Teodor on 25/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

class AddNewAccountViewController: UIViewController, UITextFieldDelegate, CurrencyPickerDelegate {

    @IBOutlet var ibanTextField: UnderlinedTextField!
    @IBOutlet var bicSwiftTextField: UnderlinedTextField!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var ibanErrorLabel: UILabel!
    @IBOutlet var bicSwiftErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapCurrencyLabel = UITapGestureRecognizer(target: self, action: #selector(didTapCurrencyLabel(sender:)))
        currencyLabel.isUserInteractionEnabled = true
        currencyLabel.addGestureRecognizer(tapCurrencyLabel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCurrencyForNewAccount" {
            if let destination = segue.destination as? CurrencyPickerViewController {
                destination.delegate = self
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == ibanTextField {
            bicSwiftTextField.becomeFirstResponder()
        }
        return false
    }
    
    func didTapCurrencyLabel(sender: UILabel) {
        performSegue(withIdentifier: "selectCurrencyForNewAccount", sender: sender)
    }
    
    func didSelectCurrency(index: Int, currency: String, sender: Any?) {
        currencyLabel.text = currency
    }
    
    @IBAction func addNewAccountAction(_ sender: UIButton) {
        self.ibanErrorLabel.text = ""
        self.bicSwiftErrorLabel.text = ""
        if(self.ibanTextField.text == "") {
            self.ibanErrorLabel.text = "IBAN required"
            return
        }
        if(self.bicSwiftTextField.text == "") {
            self.bicSwiftErrorLabel.text = "BIC/SWIFT required"
            return
        }
        let params = [
            "iban": ibanTextField.text,
            "bic_swift": bicSwiftTextField.text,
            "currency": currencyLabel.text,
            "country": Locale.current.regionCode
        ]
        Networking.sharedInstance.authenticatedRequest(url: "account/create", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]) { (response) in
            if response.1 == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                if let errorDict = response.1 as [String: Any]? {
                    print(errorDict)
                }
                return
            }
        }
    }
    
    @IBAction func unwindToAddNewAccount(segue: UIStoryboardSegue) {}
}

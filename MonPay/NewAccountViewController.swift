//
//  NewAccountViewController.swift
//  MonPay
//
//  Created by Teodor on 25/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

protocol NewAccountDelegate: class {
    func didAddNewAccount(account: Account)
}

class NewAccountViewController: UIViewController, UITextFieldDelegate, PickerDelegate {

    @IBOutlet var ibanTextField: UnderlinedTextField! {
        didSet {
            ibanTextField.delegate = self
        }
    }
    @IBOutlet var bicSwiftTextField: UnderlinedTextField! {
        didSet {
            bicSwiftTextField.delegate = self
        }
    }
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var ibanErrorLabel: UILabel!
    @IBOutlet var bicSwiftErrorLabel: UILabel!
    
    weak var delegate: NewAccountDelegate?
    
    var selectedCurrency: Currency?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapCurrencyLabel = UITapGestureRecognizer(target: self, action: #selector(didTapCurrencyLabel(sender:)))
        currencyLabel.isUserInteractionEnabled = true
        currencyLabel.addGestureRecognizer(tapCurrencyLabel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCurrencyForNewAccount" {
            if let destination = segue.destination as? PickerViewController {
                destination.delegate = self
                destination.data = DataStore.shared.currencies
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
    
    func didSelect(item: Any?, at: Int?, sender: Any?) {
        if let currency = item as? Currency {
            self.selectedCurrency = currency
            currencyLabel.text = currency.isoCode
        }
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
        if self.currencyLabel.text == "NONE" {
            self.ibanErrorLabel.text = "Please select a currency"
            return
        }
        if let selectedCurrency = self.selectedCurrency {
            let params: Parameters = [
                "iban": ibanTextField.text!,
                "bic_swift": bicSwiftTextField!.text!,
                "currency": selectedCurrency.id!,
                "country": Locale.current.regionCode!
            ]
            Fetcher.sharedInstance.accountCreate(params: params) { (response: [String : Any]?) in
                if let account = response?["account"] as? [String: Any] {
                    let newAccount = Account(values: account)
                    self.delegate?.didAddNewAccount(account: newAccount)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func unwindToAddNewAccount(segue: UIStoryboardSegue) {}
}

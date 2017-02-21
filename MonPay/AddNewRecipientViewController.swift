//
//  AddNewRecipientViewController.swift
//  MonPay
//
//  Created by Teodor on 01/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

protocol AddNewRecipientDelegate: class {
    func didAddNewRecipient(recipient: Beneficiary)
}

class AddNewRecipientViewController: UIViewController, CurrencyPickerDelegate {

    @IBOutlet var recipientName: UnderlinedTextField!
    @IBOutlet var recipientEmail: UnderlinedTextField!
    @IBOutlet var recipientIban: UnderlinedTextField!
    @IBOutlet var recipientBicSwift: UnderlinedTextField!
    @IBOutlet var recipientNameErrorLabel: UILabel!
    @IBOutlet var recipientEmailErrorLabel: UILabel!
    @IBOutlet var recipientIbanErrorLabel: UILabel!
    @IBOutlet var recipientBicSwiftErrorLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
    weak var delegate: AddNewRecipientDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backArrow = UIImage(named: "back")
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 20, width: 8, height: 16)
        backButton.addTarget(self, action: #selector(didPressBackButton(sender:)), for: .touchUpInside)
        backButton.setTitle("", for: .normal)
        backButton.setBackgroundImage(backArrow, for: .normal)
        backButton.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        let tapFromCurrencyLabel = UITapGestureRecognizer(target: self, action: #selector(didTapCurrencyLabel(sender:)))
        currencyLabel.isUserInteractionEnabled = true
        currencyLabel.addGestureRecognizer(tapFromCurrencyLabel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseCurrencyForNewRecipient" {
            if let destination = segue.destination as? CurrencyPickerViewController {
                destination.delegate = self
            }
        }
    }
    
    func didTapCurrencyLabel(sender: UILabel) {
        performSegue(withIdentifier: "chooseCurrencyForNewRecipient", sender: sender)
    }
    
    func didSelectCurrency(index: Int, currency: String, sender: Any?) {
        currencyLabel.text = currency
    }
    
    func didPressBackButton(sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addNewRecipientAction(_ sender: UIButton) {
        self.recipientNameErrorLabel.text = ""
        self.recipientEmailErrorLabel.text = ""
        self.recipientIbanErrorLabel.text = ""
        self.recipientBicSwiftErrorLabel.text = ""
        if(self.recipientName.text == "") {
            self.recipientNameErrorLabel.text = "Name required"
            return
        }
        if(self.recipientEmail.text == "") {
            self.recipientEmailErrorLabel.text = "Email required"
            return
        }
        if(self.recipientIban.text == "") {
            self.recipientIbanErrorLabel.text = "IBAN required"
            return
        }
        if(self.recipientBicSwift.text == "") {
            self.recipientBicSwiftErrorLabel.text = "BIC/SWIFT required"
            return
        }
        let full_name = self.recipientName.text!.components(separatedBy: " ")
        if(full_name.count < 2) {
            self.recipientNameErrorLabel.text = "Provide first and last name"
            return
        }
        let params: [String : Any] = [
            "email": self.recipientEmail.text!,
            "first_name": full_name[0],
            "last_name": full_name[1],
            "entity_type": 0,
            "date_of_birth": "1995-08-11",
            "account": [
                "iban": self.recipientIban.text,
                "bic_swift": self.recipientBicSwift.text,
                "currency": self.currencyLabel.text,
                "country": Locale.current.regionCode
            ]
        ]
        Fetcher.sharedInstance.beneficiaryCreate(params: params, completion: { (response: [String : Any]?) in
            if let beneficiary = response?["beneficiary"] as? [String: Any] {
                let newBeneficiary = Beneficiary(values: beneficiary)
                self.delegate?.didAddNewRecipient(recipient: newBeneficiary)
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                if let description = response?["description"] as? [String: Any] {
                    for error in description {
                        if let errors = error.value as? [String] {
                            switch error.key {
                            case "email":
                                self.recipientEmailErrorLabel.text = errors[0]
                                break
                            case "first_name":
                                self.recipientNameErrorLabel.text = errors[0]
                                break
                            case "last_name":
                                self.recipientNameErrorLabel.text = errors[0]
                                break
                            case "iban":
                                self.recipientIbanErrorLabel.text = errors[0]
                                break
                            default: break
                            }
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func unwindToNewRecipient(sender: UIStoryboardSegue) {}
}

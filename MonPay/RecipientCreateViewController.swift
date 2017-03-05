//
//  NewRecipientViewController.swift
//  MonPay
//
//  Created by Teodor on 01/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

protocol BeneficiaryCreateDelegate: class {
    func didAdd(beneficiary: Beneficiary)
}

class RecipientCreateViewController: UIViewController, UITextFieldDelegate, PickerDelegate {

    @IBOutlet var recipientName: UnderlinedTextField! {
        didSet {
            recipientName.delegate = self
        }
    }
    @IBOutlet var recipientEmail: UnderlinedTextField! {
        didSet {
            recipientEmail.delegate = self
        }
    }
    @IBOutlet var recipientIban: UnderlinedTextField! {
        didSet {
            recipientIban.delegate = self
        }
    }
    @IBOutlet var recipientBicSwift: UnderlinedTextField! {
        didSet {
            recipientBicSwift.delegate = self
        }
    }
    @IBOutlet var recipientNameErrorLabel: UILabel!
    @IBOutlet var recipientEmailErrorLabel: UILabel!
    @IBOutlet var recipientIbanErrorLabel: UILabel!
    @IBOutlet var recipientBicSwiftErrorLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
    weak var delegate: BeneficiaryCreateDelegate?
    
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
            if let destination = segue.destination as? PickerViewController {
                destination.delegate = self
                destination.data = DataStore.shared.currencies
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case recipientName:
            recipientEmail.becomeFirstResponder()
            break
        case recipientEmail:
            recipientIban.becomeFirstResponder()
            break
        case recipientIban:
            recipientBicSwift.becomeFirstResponder()
            break
        default: break
        }
        return false
    }
    
    func didTapCurrencyLabel(sender: UILabel) {
        performSegue(withIdentifier: "chooseCurrencyForNewRecipient", sender: sender)
    }
    
    func didSelect(item: Any?, at: Int?, sender: Any?) {
        if let currency = item as? Currency {
            currencyLabel.text = currency.isoCode
        }
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
        var currencyId: Int = 0
        for currency in DataStore.shared.currencies {
            if currency.isoCode == self.currencyLabel.text {
                currencyId = currency.id!
            }
        }
        let params: [String : Any] = [
            "email": self.recipientEmail.text!,
            "first_name": full_name[0],
            "last_name": full_name[1],
            "entity_type": 0,
            "account": [
                "iban": self.recipientIban.text!,
                "bic_swift": self.recipientBicSwift.text!,
                "currency": currencyId,
                "country": Locale.current.regionCode!
            ]
        ]
        Fetcher.sharedInstance.beneficiaryCreate(params: params, completion: { (response: [String : Any]?) in
            if let beneficiary = response?["beneficiary"] as? [String: Any] {
                let newBeneficiary = Beneficiary(values: beneficiary)
                self.delegate?.didAdd(beneficiary: newBeneficiary)
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

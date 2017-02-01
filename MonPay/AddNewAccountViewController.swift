//
//  AddNewAccountViewController.swift
//  MonPay
//
//  Created by Teodor on 25/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class AddNewAccountViewController: UIViewController, CurrencyPickerDelegate {

    @IBOutlet var currencyLabel: UILabel!
    
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
    
    func didTapCurrencyLabel(sender: UILabel) {
        performSegue(withIdentifier: "selectCurrencyForNewAccount", sender: sender)
    }
    
    func didSelectCurrency(index: Int, currency: String, sender: Any?) {
        currencyLabel.text = currency
    }
    
    @IBAction func unwindToAddNewAccount(segue: UIStoryboardSegue) {}
}

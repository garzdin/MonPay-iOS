//
//  AddNewRecipientViewController.swift
//  MonPay
//
//  Created by Teodor on 01/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class AddNewRecipientViewController: UIViewController, CurrencyPickerDelegate {

    @IBOutlet var currencyLabel: UILabel!
    
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToNewRecipient(sender: UIStoryboardSegue) {}
}

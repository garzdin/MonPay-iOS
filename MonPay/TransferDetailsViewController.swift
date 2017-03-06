//
//  TransferDetailsViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

protocol TransactionDeleteDelegate: class {
    func didDelete(transaction: Transaction)
}

fileprivate let dateTimeFormat: String = "yyyy-MM-dd HH:mm:ss.S"

class TransferDetailsViewController: UIViewController {

    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var ibanLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    var transaction: Transaction?
    
    weak var delegate: TransactionDeleteDelegate?
    
    let dateFormatter = DateFormatter()
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "delete"), style: .plain, target: self, action: #selector(didPressDelete(sender:)))
        self.dateFormatter.dateFormat = dateTimeFormat
        self.setupDetailsFor(transaction: self.transaction)
    }
    
    func setupDetailsFor(transaction: Transaction?) {
        if let transaction = self.transaction {
            if transaction.beneficiary != nil {
                for beneficiary in DataStore.shared.beneficiaries {
                    if beneficiary.id == transaction.beneficiary {
                        if let firstName = beneficiary.first_name, let lastName = beneficiary.last_name {
                            self.nameLabel.text = "\(firstName) \(lastName)"
                            if let firstNameInitial = firstName.characters.first, let lastNameInitial = lastName.characters.first {
                                self.initialsLabel.text = "\(firstNameInitial)\(lastNameInitial)"
                            }
                        }
                        if let email = beneficiary.email {
                            self.emailLabel.text = email
                        }
                        if let iban = beneficiary.account?.iban {
                            self.ibanLabel.text = iban
                        }
                    }
                }
            }
            if let amount = transaction.amount, let currencyId = transaction.currency {
                for currency in DataStore.shared.currencies {
                    if currency.id == currencyId {
                        if let isoCode = currency.isoCode {
                            self.amountLabel.text = "\(amount) \(isoCode)"
                        }
                    }
                }
            }
            if let updatedOn = transaction.updated_on {
                self.statusLabel.text = self.dateFormatter.string(from: updatedOn)
            } else {
                self.statusLabel.text = "Processing"
            }
        }
    }
    
    func didPressBackButton(sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func didPressDelete(sender: UIBarButtonItem) {
        if let transaction = self.transaction, let amount = transaction.amount, let currency = transaction.currency {
            let alert = UIAlertController(title: "Are you sure?", message: "Would you like to delete the transaction of \(amount) \(currency) from your transaction history?", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (action: UIAlertAction!) in
                self.confirmDelete(sender: alert)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func confirmDelete(sender: UIAlertController) {
        if let transaction = self.transaction {
            let params = [
                "id": transaction.id
            ]
            Fetcher.sharedInstance.transactionDelete(params: params, completion: { (response: [String : Any]?) in
                _ = self.navigationController?.popViewController(animated: true)
                self.delegate?.didDelete(transaction: transaction)
            })
        }
    }
}

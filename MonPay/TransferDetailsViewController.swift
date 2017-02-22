//
//  TransferDetailsViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

protocol TransferDeleteDelegate: class {
    func didDeleteTransfer(transfer: Transaction)
}

class TransferDetailsViewController: UIViewController {

    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var ibanLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    var transfer: Transaction?
    
    weak var delegate: TransferDeleteDelegate?
    
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
        if let transfer = self.transfer {
//            if let first_name = transfer.beneficiary.first_name, let last_name = transfer.beneficiary.last_name {
//                self.nameLabel.text = "\(first_name) \(last_name)"
//                if let firstNameInitial = first_name.characters.first, let lastNameInitial = last_name.characters.first {
//                    self.initialsLabel.text = "\(firstNameInitial)\(lastNameInitial)"
//                }
//            }
            if let amount = transfer.amount, let currency = transfer.currency {
                self.amountLabel.text = "\(amount) \(currency)"
            }
//            if let email = transfer.beneficiary.email {
//                self.emailLabel.text = email
//            }
//            if let iban = transfer.beneficiary.account?.iban {
//                self.ibanLabel.text = iban
//            }
            if let status = transfer.completed {
                self.statusLabel.text = status ? "Completed" : "Processing"
            }
        }
        
    }
    
    func didPressBackButton(sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func didPressDelete(sender: UIBarButtonItem) {
        if let transfer = self.transfer, let amount = transfer.amount, let currency = transfer.currency {
            let alert = UIAlertController(title: "Are you sure?", message: "Would you like to delete the transfer of \(amount) \(currency) from your transfer history?", preferredStyle: UIAlertControllerStyle.alert)
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
        if let transfer = self.transfer {
            let params = [
                "id": transfer.id
            ]
            Fetcher.sharedInstance.transactionDelete(params: params, completion: { (response: [String : Any]?) in
                _ = self.navigationController?.popViewController(animated: true)
                self.delegate?.didDeleteTransfer(transfer: transfer)
            })
        }
    }
}

//
//  RecipientDetailsViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

protocol RecipientDeleteDelegate: class {
    func didDeleteRecipient(recipient: Beneficiary)
}

class RecipientDetailsViewController: UIViewController {
    
    weak var delegate: RecipientDeleteDelegate?
    
    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var entityTypeLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var ibanLabel: UILabel!
    @IBOutlet var bicSwiftLabel: UILabel!
    
    var recipient: Beneficiary?

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
        self.setupDetailsFor(beneficiary: self.recipient)
    }
    
    func setupDetailsFor(beneficiary: Beneficiary?) {
        if let beneficiary = beneficiary {
            if let firstName = beneficiary.first_name, let lastName = beneficiary.last_name {
                self.nameLabel.text = "\(firstName) \(lastName)"
                if let firstNameInitial = firstName.characters.first, let lastNameInitial = lastName.characters.first {
                    self.initialsLabel.text = "\(firstNameInitial)\(lastNameInitial)"
                }
            }
            if let entityType = beneficiary.entity_type {
                switch entityType {
                case 0:
                    self.entityTypeLabel.text = "Private"
                    break
                case 1:
                    self.entityTypeLabel.text = "Company"
                    break
                default: break
                }
            }
            if let email = beneficiary.email {
                self.emailLabel.text = email
            }
            if let iban = beneficiary.account?.iban {
                self.ibanLabel.text = iban
            }
            if let bicSwift = beneficiary.account?.bic_swift {
                self.bicSwiftLabel.text = bicSwift
            }
        }
    }
    
    func didPressBackButton(sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func didPressDelete(sender: UIBarButtonItem) {
        if let recipient = self.recipient, let first_name = recipient.first_name, let last_name = recipient.last_name {
            let alert = UIAlertController(title: "Are you sure?", message: "Would you like to delete \(first_name) \(last_name) from your recipients?", preferredStyle: UIAlertControllerStyle.alert)
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
        if let recipient = self.recipient {
            let params = [
                "id": recipient.id
            ]
            Fetcher.shared.beneficiaryDelete(params: params, completion: { (response: [String : Any]?) in
                _ = self.navigationController?.popViewController(animated: true)
                self.delegate?.didDeleteRecipient(recipient: recipient)
            })
        }
    }
}

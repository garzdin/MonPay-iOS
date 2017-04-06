//
//  AccountDetailsViewController.swift
//  MonPay
//
//  Created by Teodor on 22/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

protocol AccountDeleteDelegate: class {
    func didDeleteAccount(account: Account)
}

class AccountDetailsViewController: UIViewController {

    @IBOutlet var ibanLabel: UILabel!
    @IBOutlet var swiftLabel: UILabel!
    
    var account: Account?
    
    weak var delegate: AccountDeleteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if account != nil {
            if let iban = account?.iban {
                self.ibanLabel.text = iban
            }
            if let bicSwift = account?.bic_swift {
                self.swiftLabel.text = bicSwift
            } else {
                self.swiftLabel.text = "None"
            }
        }
    }

    @IBAction func removeAction(_ sender: UIButton) {
        if let account = self.account, let iban = account.iban {
            let alert = UIAlertController(title: "Are you sure?", message: "Would you like to delete the account with number \(iban)", preferredStyle: UIAlertControllerStyle.alert)
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
        if let account = self.account {
            let params: Parameters = [
                "id": account.id!
            ]
            Fetcher.shared.accountDelete(params: params, completion: { (response: [String : Any]?) in
                self.dismiss(animated: true, completion: nil)
                self.delegate?.didDeleteAccount(account: account)
            })
        }
    }
}

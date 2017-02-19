//
//  FirstViewController.swift
//  MonPay
//
//  Created by Teodor on 24/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

// MARK: Reuse identifiers

fileprivate let reuseIdentifier = "accountCell"
fileprivate let staticReuseIdentifier = "newAccountCell"
fileprivate let recipientCellReuseIdentifier = "recipientCell"
fileprivate let recipientSearchCellReuseIdentifier = "recipientSearchCell"

class SendViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CurrencyPickerDelegate {
    
    var accounts: [Account] = []
    let recipients: [String] = ["Adam Smith", "John Doe", "Batman"]

    @IBOutlet var accountsCollectionView: AccountsCollectionView!
    @IBOutlet var recipientsCollectionView: RecipientsCollectionView!
    @IBOutlet var fromCurrencyLabel: UILabel!
    @IBOutlet var toCurrencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountsCollectionView.delegate = self
        self.accountsCollectionView.dataSource = self
        self.recipientsCollectionView.delegate = self
        self.recipientsCollectionView.dataSource = self
        let tapFromCurrencyLabel = UITapGestureRecognizer(target: self, action: #selector(didTapFromCurrencyLabel(sender:)))
        fromCurrencyLabel.isUserInteractionEnabled = true
        fromCurrencyLabel.addGestureRecognizer(tapFromCurrencyLabel)
        let tapToCurrencyLabel = UITapGestureRecognizer(target: self, action: #selector(didTapToCurrencyLabel(sender:)))
        toCurrencyLabel.isUserInteractionEnabled = true
        toCurrencyLabel.addGestureRecognizer(tapToCurrencyLabel)
        getAccounts()
    }
    
    // MARK: Data delegation
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if collectionView == accountsCollectionView {
                return self.accounts.count
            } else {
                return self.recipients.count
            }
        } else {
            return 1
        }
    }
    
    // MARK: Cells setup
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            if collectionView == accountsCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: staticReuseIdentifier, for: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipientSearchCellReuseIdentifier, for: indexPath)
                return cell
            }
        } else {
            if collectionView == accountsCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AccountCollectionViewCell
                if let iban = self.accounts[indexPath.row].iban {
                    cell.accountNumberLabel.text = iban
                }
                cell.infoButton.tag = indexPath.row
                cell.infoButton.addTarget(self, action: #selector(didTapInfoButton(sender:)), for: UIControlEvents.touchUpInside)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipientCellReuseIdentifier, for: indexPath) as! RecipientCollectionViewCell
                return cell
            }
        }
    }
    
    // MARK: Cells indication
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if collectionView == accountsCollectionView {
                for cell in collectionView.visibleCells.filter({(cell) in return cell is AccountCollectionViewCell}) as! [AccountCollectionViewCell] {
                    cell.selectedIndicator.isHidden = true
                    cell.accountSelected = false
                }
                let cell = collectionView.cellForItem(at: indexPath) as! AccountCollectionViewCell
                cell.accountSelected = true
                cell.selectedIndicator.isHidden = false
            }
            if collectionView == recipientsCollectionView {
                for cell in collectionView.visibleCells.filter({(cell) in return cell is RecipientCollectionViewCell}) as! [RecipientCollectionViewCell] {
                    cell.recipientSelected = false
                    cell.setUnselected()
                }
                if let cell = collectionView.cellForItem(at: indexPath) as? RecipientCollectionViewCell {
                    cell.recipientSelected = true
                    cell.setSelected()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseCurrency" {
            if let destination = segue.destination as? CurrencyPickerViewController {
                destination.delegate = self
                destination.segueSender = sender
            }
        }
    }
    
    // MARK: Cell info button tapped action
    
    func didTapInfoButton(sender: UIButton?) {
        performSegue(withIdentifier: "showAccountDetails", sender: sender)
    }
    
    // MARK: Cell add new account button tapped action
    
    @IBAction func addNewAccount(_ sender: UIButton) {
        performSegue(withIdentifier: "addNewAccount", sender: sender)
    }
    
    // MARK: Transfer intiated
    
    @IBAction func goToConfirmScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "confirmSend", sender: sender)
    }
    
    // MARK: From currency label tap
    
    func didTapFromCurrencyLabel(sender: UILabel) {
        performSegue(withIdentifier: "chooseCurrency", sender: sender)
    }
    
    // MARK: To currency label tap
    
    func didTapToCurrencyLabel(sender: UILabel) {
        performSegue(withIdentifier: "chooseCurrency", sender: sender)
    }
    
    func didSelectCurrency(index: Int, currency: String, sender: Any?) {
        if let gesture = sender as? UITapGestureRecognizer {
            if let label = gesture.view as? UILabel {
                label.text = currency
            }
        }
    }
    
    @IBAction func unwindToSendScreen(segue: UIStoryboardSegue) {}
    
    func getAccounts() {
        Networking.sharedInstance.authenticatedRequest(url: "account", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:]) { (response) in
            if response.1 == nil {
                if let accounts = response.0?["accounts"] as? [Any] {
                    for account in accounts {
                        if let account = account as? [String: Any] {
                            self.accounts.append(Account(values: account))
                        }
                    }
                }
            } else {
                if let errorDict = response.1 as [String: Any]? {
                    print(errorDict)
                }
                return
            }
            self.accountsCollectionView.reloadData()
        }
    }
}


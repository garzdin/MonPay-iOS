//
//  FirstViewController.swift
//  MonPay
//
//  Created by Teodor on 24/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

struct SenderWithData {
    let sender: Any
    let data: Any
}

// MARK: Reuse identifiers

fileprivate let reuseIdentifier = "accountCell"
fileprivate let staticReuseIdentifier = "newAccountCell"
fileprivate let recipientCellReuseIdentifier = "recipientCell"
fileprivate let recipientSearchCellReuseIdentifier = "recipientSearchCell"

class SendViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, CurrencyPickerDelegate, AddNewAccountDelegate, AccountDeleteDelegate, ConfirmTransferDelegate {
    
    var accounts: [Account] = []
    var recipients: [Beneficiary] = []
    var transfer: Transaction = Transaction()

    @IBOutlet var accountsCollectionView: AccountsCollectionView!
    @IBOutlet var recipientsCollectionView: RecipientsCollectionView!
    @IBOutlet var fromCurrencyLabel: UILabel!
    @IBOutlet var toCurrencyLabel: UILabel!
    @IBOutlet var fromAmount: UITextField! {
        didSet {
            fromAmount.delegate = self
        }
    }
    @IBOutlet var toAmount: UITextField! {
        didSet {
            toAmount.delegate = self
        }
    }
    
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
        getRecipients()
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
                if let active = self.accounts[indexPath.row].active {
                    self.transfer.account = self.accounts[indexPath.row]
                    cell.accountSelected = active
                    cell.selectedIndicator.isHidden = !active
                }
                cell.infoButton.tag = indexPath.row
                cell.infoButton.addTarget(self, action: #selector(didTapInfoButton(sender:)), for: UIControlEvents.touchUpInside)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipientCellReuseIdentifier, for: indexPath) as! RecipientCollectionViewCell
                if let first_name = self.recipients[indexPath.row].first_name, let last_name = self.recipients[indexPath.row].last_name {
                    if let firstNameInitial = first_name.characters.first, let lastNameInitial = last_name.characters.first {
                        cell.initialsLabel.text = "\(firstNameInitial)\(lastNameInitial)"
                    }
                    cell.nameLabel.text = "\(first_name) \(last_name)"
                }
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
                if let accountId = self.accounts[indexPath.row].id {
                    Fetcher.sharedInstance.accountActivate(id: accountId, completion: { (response: [String : Any]?) in
                        if let _ = response?["account"] as? [String: Any] {
                            self.transfer.account = self.accounts[indexPath.row]
                            self.accounts[indexPath.row].active = true
                            cell.accountSelected = true
                            cell.selectedIndicator.isHidden = false
                        }
                    })
                }
            }
            if collectionView == recipientsCollectionView {
                for cell in collectionView.visibleCells.filter({(cell) in return cell is RecipientCollectionViewCell}) as! [RecipientCollectionViewCell] {
                    cell.recipientSelected = false
                    cell.setUnselected()
                }
                if let cell = collectionView.cellForItem(at: indexPath) as? RecipientCollectionViewCell {
                    self.transfer.beneficiary = self.recipients[indexPath.row]
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
                destination.data = ["BGN", "EUR", "DKK"]
            }
        }
        if segue.identifier == "addNewAccount" {
            if let destination = segue.destination as? AddNewAccountViewController {
                destination.delegate = self
            }
        }
        if segue.identifier == "showAccountDetails" {
            if let destination = segue.destination as? AccountDetailsViewController {
                if let payload = sender as? SenderWithData {
                    if let account = payload.data as? Account {
                        destination.delegate = self
                        destination.account = account
                    }
                }
            }
        }
        if segue.identifier == "confirmSend" {
            if let destination = segue.destination as? ConfirmViewController {
                destination.delegate = self
                destination.transfer = self.transfer
                if let fromAmountText = self.fromAmount.text,
                    let toAmountText = self.toAmount.text,
                    let fromAmountCurrency = self.fromCurrencyLabel.text,
                    let toAmountCurrency = self.toCurrencyLabel.text {
                    if let fromAmount = Float(fromAmountText),
                        let toAmount = Float(toAmountText) {
                        let pairs = CurrencyPairs(fromAmount: fromAmount, fromCurrency: fromAmountCurrency, toAmount: toAmount, toCurrency: toAmountCurrency)
                        destination.pairs = pairs
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == fromAmount {
            toAmount.becomeFirstResponder()
        }
        return false
    }
    
    // MARK: Cell info button tapped action
    
    func didTapInfoButton(sender: UIButton?) {
        if let index = sender?.tag {
            if let sender = sender {
                let customSender = SenderWithData(sender: sender, data: self.accounts[index])
                performSegue(withIdentifier: "showAccountDetails", sender: customSender)
            }
        }
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
    
    func didAddNewAccount(account: Account) {
        self.accounts.append(account)
        self.accountsCollectionView.reloadData()
    }
    
    func didDeleteAccount(account: Account) {
        if let index = self.accounts.index(of: account) {
            self.accounts.remove(at: index)
            self.accountsCollectionView.reloadData()
        }
    }
    
    func didConfirmTransfer() {
        self.fromAmount.text = ""
        self.toAmount.text = ""
        for cell in self.recipientsCollectionView.visibleCells.filter({(cell) in return cell is RecipientCollectionViewCell}) as! [RecipientCollectionViewCell] {
            cell.recipientSelected = false
            cell.setUnselected()
        }
    }
    
    @IBAction func unwindToSendScreen(segue: UIStoryboardSegue) {}
    
    func getAccounts() {
        Fetcher.sharedInstance.accountList { (response: [String : Any]?) in
            if let accounts = response?["accounts"] as? [Any] {
                self.accounts = []
                for account in accounts {
                    if let account = account as? [String: Any] {
                        self.accounts.append(Account(values: account))
                    }
                }
            }
            self.accountsCollectionView.reloadData()
        }
    }
    
    func getRecipients() {
        Fetcher.sharedInstance.beneficiaryList { (response: [String : Any]?) in
            if let recipients = response?["beneficiaries"] as? [Any] {
                self.recipients = []
                for recipient in recipients {
                    if let recipient = recipient as? [String: Any] {
                        self.recipients.append(Beneficiary(values: recipient))
                    }
                }
            }
            self.recipientsCollectionView.reloadData()
        }
    }
}


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
fileprivate let cellReuseIdentifier = "recipientCell"
fileprivate let staticCellReuseIdentifier = "recipientSearchCell"

class SendViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, PickerDelegate, ConfirmTransactionDelegate {
    
    var transaction: Transaction = Transaction()

    @IBOutlet var recipientsCollectionView: UICollectionView!
    @IBOutlet var recipientsErrorLabel: UILabel!
    @IBOutlet var fromCurrencyLabel: UILabel!
    @IBOutlet var toCurrencyLabel: UILabel!
    @IBOutlet var fromAmount: UITextField! {
        didSet {
            fromAmount.delegate = self
        }
    }
    @IBOutlet var fromAmountErrorLabel: UILabel!
    @IBOutlet var toAmount: UITextField! {
        didSet {
            toAmount.delegate = self
        }
    }
    @IBOutlet var toAmountErrorLabel: UILabel!
    @IBOutlet var feeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipientsCollectionView.delegate = self
        self.recipientsCollectionView.dataSource = self
        let tapFromCurrencyLabel = UITapGestureRecognizer(target: self, action: #selector(didTapFromCurrencyLabel(sender:)))
        fromCurrencyLabel.isUserInteractionEnabled = true
        fromCurrencyLabel.addGestureRecognizer(tapFromCurrencyLabel)
        let tapToCurrencyLabel = UITapGestureRecognizer(target: self, action: #selector(didTapToCurrencyLabel(sender:)))
        toCurrencyLabel.isUserInteractionEnabled = true
        toCurrencyLabel.addGestureRecognizer(tapToCurrencyLabel)
        self.refreshData()
    }
    
    func refreshData() {
        DataStore.shared.getBeneficiaries { 
            self.recipientsCollectionView.reloadData()
        }
        DataStore.shared.getCurrencies(completion: nil)
    }
    
    // MARK: Data delegation
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return DataStore.shared.beneficiaries.count
        } else {
            return 1
        }
    }
    
    // MARK: Cells setup
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: staticCellReuseIdentifier, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! RecipientCollectionViewCell
            if let first_name = DataStore.shared.beneficiaries[indexPath.row].first_name, let last_name = DataStore.shared.beneficiaries[indexPath.row].last_name {
                if let firstNameInitial = first_name.characters.first, let lastNameInitial = last_name.characters.first {
                    cell.initialsLabel.text = "\(firstNameInitial)\(lastNameInitial)"
                }
                cell.nameLabel.text = "\(first_name) \(last_name)"
            }
            return cell
        }
    }
    
    // MARK: Cells indication
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            for cell in collectionView.visibleCells.filter({(cell) in return cell is RecipientCollectionViewCell}) as! [RecipientCollectionViewCell] {
                cell.recipientSelected = false
                cell.setUnselected()
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? RecipientCollectionViewCell {
                self.transaction.beneficiary = DataStore.shared.beneficiaries[indexPath.row].id
                cell.recipientSelected = true
                cell.setSelected()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseCurrency" {
            if let destination = segue.destination as? PickerViewController {
                destination.delegate = self
                destination.segueSender = sender
                destination.data = DataStore.shared.currencies
            }
        }
        if segue.identifier == "confirmSend" {
            if let destination = segue.destination as? ConfirmViewController {
                destination.delegate = self
                destination.transaction = self.transaction
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
            createConversion()
        }
        return false
    }
    
    func createConversion() {
        self.fromAmountErrorLabel.text = ""
        self.toAmountErrorLabel.text = ""
        if self.fromAmount.text == "" {
            self.fromAmountErrorLabel.text = "Please enter an amount"
            return
        }
        if self.fromCurrencyLabel.text == "NONE" {
            self.fromAmountErrorLabel.text = "Please select a currency"
            return
        }
        if self.toCurrencyLabel.text == "NONE" {
            self.toAmountErrorLabel.text = "Please select a currency"
            return
        }
        var fromCurrencyId: Int?
        var toCurrencyId: Int?
        let amount = Float(self.fromAmount.text!)
        for currency in DataStore.shared.currencies {
            if currency.isoCode == fromCurrencyLabel.text {
                fromCurrencyId = currency.id!
            }
            if currency.isoCode == toCurrencyLabel.text {
                toCurrencyId = currency.id!
            }
        }
        if let fromCurrencyId = fromCurrencyId, let toCurrencyId = toCurrencyId {
            let params: Parameters = [
                "from": fromCurrencyId,
                "to": toCurrencyId,
                "amount": amount ?? 0
            ]
            Fetcher.sharedInstance.conversionCreate(params: params) { (response: [String : Any]?) in
                if let conversion = response?["conversion"] as? [String: Any],
                    let fromCurrency = conversion["from_currency"] as? String,
                    let _ = conversion["to_currency"] as? String,
                    let _ = conversion["from_amount"] as? Float,
                    let toAmount = conversion["to_amount"] as? Float,
                    let fee = conversion["fee"] as? Float {
                    self.toAmount.text = "\(toAmount - fee)"
                    self.feeLabel.text = "\(fee) \(fromCurrency)"
                }
            }
        }
    }
    
    // MARK: Transaction intiated
    
    @IBAction func goToConfirmScreen(_ sender: UIButton) {
        self.recipientsErrorLabel.text = ""
        if self.transaction.beneficiary == nil {
            self.recipientsErrorLabel.text = "Please select a beneficiary"
        } else {
            performSegue(withIdentifier: "confirmSend", sender: sender)
        }
    }
    
    // MARK: From currency label tap
    
    func didTapFromCurrencyLabel(sender: UILabel) {
        performSegue(withIdentifier: "chooseCurrency", sender: sender)
    }
    
    // MARK: To currency label tap
    
    func didTapToCurrencyLabel(sender: UILabel) {
        performSegue(withIdentifier: "chooseCurrency", sender: sender)
    }
    
    func didSelect(item: Any?, at: Int?, sender: Any?) {
        self.fromAmountErrorLabel.text = ""
        self.toAmountErrorLabel.text = ""
        if let gesture = sender as? UITapGestureRecognizer {
            if let label = gesture.view as? UILabel {
                if let currency = item as? Currency {
                    label.text = currency.isoCode
                }
            }
        }
    }
    
    func didConfirm(transation: Transaction) {
        self.fromAmount.text = ""
        self.toAmount.text = ""
        for cell in self.recipientsCollectionView.visibleCells.filter({(cell) in return cell is RecipientCollectionViewCell}) as! [RecipientCollectionViewCell] {
            cell.recipientSelected = false
            cell.setUnselected()
        }
        self.transaction = Transaction()
    }
    
    @IBAction func unwindToSendScreen(segue: UIStoryboardSegue) {}
}


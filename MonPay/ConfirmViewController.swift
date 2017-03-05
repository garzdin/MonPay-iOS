//
//  ConfirmViewController.swift
//  MonPay
//
//  Created by Teodor on 25/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

struct CurrencyPairs {
    let fromAmount: Float
    let fromCurrency: String
    let toAmount: Float
    let toCurrency: String
}

protocol ConfirmTransactionDelegate: class {
    func didConfirm(transation: Transaction)
}

class ConfirmViewController: UIViewController {
    
    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ibanLabel: UILabel!
    @IBOutlet var fromCurrencyLabel: UILabel!
    @IBOutlet var fromCurrencyAmount: UILabel!
    @IBOutlet var toCurrencyLabel: UILabel!
    @IBOutlet var toCurrencyAmount: UILabel!
    
    var transaction: Transaction?
    var pairs: CurrencyPairs?
    
    weak var delegate: ConfirmTransactionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.transaction != nil && self.pairs != nil {
            if let first_name = self.transaction?.beneficiary?.first_name, let last_name = self.transaction?.beneficiary?.last_name {
                if let firstNameInitial = first_name.characters.first, let lastNameInitial = last_name.characters.first {
                    self.initialsLabel.text = "\(firstNameInitial)\(lastNameInitial)"
                }
                self.nameLabel.text = "\(first_name) \(last_name)"
            }
            self.ibanLabel.text = self.transaction?.beneficiary?.account?.iban
            self.fromCurrencyLabel.text = self.pairs?.fromCurrency
            self.toCurrencyLabel.text = self.pairs?.toCurrency
            if let fromAmountCurrency = self.pairs?.fromAmount, let toAmountCurrency = self.pairs?.toAmount {
                self.fromCurrencyAmount.text = "\(fromAmountCurrency)"
                self.toCurrencyAmount.text = "\(toAmountCurrency)"
            }
        }
    }

    @IBAction func confirm(_ sender: UIButton) {
        if let amount = pairs?.fromAmount,
            let currency = pairs?.fromCurrency,
            let beneficiary = transaction?.beneficiary?.id,
            let account = transaction?.beneficiary?.account?.id {
            let params: Parameters = [
                "amount": amount,
                "currency": currency,
                "reason": "Transaction \(pairs?.fromAmount) \(pairs?.fromCurrency) to \(transaction?.beneficiary?.first_name)",
                "beneficiary": beneficiary,
                "account": account,
                ]
            Fetcher.sharedInstance.transactionCreate(params: params) { (response: [String : Any]?) in
                if let transaction = response?["transaction"] as? [String: Any] {
                    self.delegate?.didConfirm(transation: Transaction(values: transaction))
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

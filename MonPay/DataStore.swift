//
//  DataStore.swift
//  MonPay
//
//  Created by Teodor on 05/03/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import Foundation

class DataStore: NSObject {
    static let shared: DataStore = {
        return DataStore()
    }()
    
    typealias CompletionHandler = () -> ()
    
    var user: User?
    var accounts: [Account] = []
    var beneficiaries: [Beneficiary] = []
    var currencies: [Currency] = []
    var transactions: [Transaction] = []
    
    override init() {
        super.init()
        self.getUser(completion: nil)
        self.getCurrencies(completion: nil)
        self.getBeneficiaries(completion: nil)
        self.getAccounts(completion: nil)
        self.getTransactions(completion: nil)
    }
    
    func getUser(completion: CompletionHandler?) {
        Fetcher.sharedInstance.userGet { (response: [String : Any]?) in
            if let user = response?["user"] as? [String: Any] {
                self.user = User(values: user)
                if completion != nil {
                    completion!()
                }
            }
        }
    }
    
    func getCurrencies(completion: CompletionHandler?) {
        Fetcher.sharedInstance.currencyList { (response: [String : Any]?) in
            if let currencies = response?["currencies"] as? [Any] {
                self.currencies = []
                for currency in currencies {
                    if let currency = currency as? [String: Any] {
                        self.currencies.append(Currency(values: currency))
                    }
                }
            }
            if completion != nil {
                completion!()
            }
        }
    }
    
    func getBeneficiaries(completion: CompletionHandler?) {
        Fetcher.sharedInstance.beneficiaryList { (response: [String : Any]?) in
            if let beneficiaries = response?["beneficiaries"] as? [Any] {
                self.beneficiaries = []
                for beneficiary in beneficiaries {
                    if let beneficiary = beneficiary as? [String: Any] {
                        self.beneficiaries.append(Beneficiary(values: beneficiary))
                    }
                }
            }
            if completion != nil {
                completion!()
            }
        }
    }
    
    func getAccounts(completion: CompletionHandler?) {
        Fetcher.sharedInstance.accountList { (response: [String : Any]?) in
            if let accounts = response?["accounts"] as? [Any] {
                self.accounts = []
                for account in accounts {
                    if let account = account as? [String: Any] {
                        self.accounts.append(Account(values: account))
                    }
                }
            }
            if completion != nil {
                completion!()
            }
        }
    }
    
    func getTransactions(completion: CompletionHandler?) {
        Fetcher.sharedInstance.transactionList { (response: [String : Any]?) in
            if let transactions = response?["transactions"] as? [Any] {
                self.transactions = []
                for transaction in transactions {
                    if let transaction = transaction as? [String: Any] {
                        self.transactions.append(Transaction(values: transaction))
                    }
                }
            }
            if completion != nil {
                completion!()
            }
        }
    }
    
    func refresh() {
        self.getUser(completion: nil)
        self.getCurrencies(completion: nil)
        self.getBeneficiaries(completion: nil)
        self.getAccounts(completion: nil)
        self.getTransactions(completion: nil)
    }
}

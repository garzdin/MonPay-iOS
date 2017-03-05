//
//  AccountViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

struct SenderWithData {
    let sender: Any
    let data: Any
}

fileprivate let reuseIdentifier = "accountCell"
fileprivate let staticReuseIdentifier = "newAccountCell"

class AccountViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NewAccountDelegate, AccountDeleteDelegate  {

    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var accountsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountsCollectionView.delegate = self
        self.accountsCollectionView.dataSource = self
        self.setupUser()
    }
    
    func setupUser() {
        if let user = DataStore.shared.user {
            if let first_name = user.first_name, let last_name = user.last_name {
                self.nameLabel.text = "\(first_name) \(last_name)"
                if let firstNameInitial = first_name.characters.first, let lastNameInitial = last_name.characters.first {
                    self.initialsLabel.text = "\(firstNameInitial)\(lastNameInitial)"
                }
            }
        }
    }
    
    func refreshData() {
        DataStore.shared.getUser {
            self.setupUser()
        }
        DataStore.shared.getAccounts { 
            self.accountsCollectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return DataStore.shared.accounts.count
        } else {
            return 1
        }
    }
    
    // MARK: Cells setup
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: staticReuseIdentifier, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!AccountCollectionViewCell
            if let iban = DataStore.shared.accounts[indexPath.row].iban {
                cell.accountNumberLabel.text = iban
            }
            if let active = DataStore.shared.accounts[indexPath.row].active {
                cell.accountSelected = active
                cell.selectedIndicator.isHidden = !active
            }
            cell.infoButton.tag = indexPath.row
            cell.infoButton.addTarget(self, action: #selector(didTapInfoButton(sender:)), for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    
    // MARK: Cells indication
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            for cell in collectionView.visibleCells.filter({(cell) in return cell is AccountCollectionViewCell}) as! [AccountCollectionViewCell] {
                cell.selectedIndicator.isHidden = true
                cell.accountSelected = false
            }
            let cell = collectionView.cellForItem(at: indexPath) as! AccountCollectionViewCell
            if let accountId = DataStore.shared.accounts[indexPath.row].id {
                Fetcher.sharedInstance.accountActivate(id: accountId, completion: { (response: [String : Any]?) in
                    if let _ = response?["account"] as? [String: Any] {
                        DataStore.shared.accounts[indexPath.row].active = true
                        cell.accountSelected = true
                        cell.selectedIndicator.isHidden = false
                    }
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewAccount" {
            if let destination = segue.destination as? NewAccountViewController {
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
    }
    
    // MARK: Cell info button tapped action
    
    func didTapInfoButton(sender: UIButton?) {
        if let index = sender?.tag {
            if let sender = sender {
                let customSender = SenderWithData(sender: sender, data: DataStore.shared.accounts[index])
                performSegue(withIdentifier: "showAccountDetails", sender: customSender)
            }
        }
    }
    
    // MARK: Cell add new account button tapped action
    
    @IBAction func addNewAccount(_ sender: UIButton) {
        performSegue(withIdentifier: "addNewAccount", sender: sender)
    }
    
    func didAddNewAccount(account: Account) {
        DataStore.shared.accounts.append(account)
        self.accountsCollectionView.reloadData()
    }
    
    func didDeleteAccount(account: Account) {
        if let index = DataStore.shared.accounts.index(of: account) {
            DataStore.shared.accounts.remove(at: index)
            self.accountsCollectionView.reloadData()
        }
    }
    
    @IBAction func unwindToAccount(segue: UIStoryboardSegue) {}
}

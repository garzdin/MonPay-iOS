//
//  FirstViewController.swift
//  MonPay
//
//  Created by Teodor on 24/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

// MARK: Reuse identifiers

fileprivate let reuseIdentifier = "accountCell"
fileprivate let staticReuseIdentifier = "newAccountCell"
fileprivate let recipientCellReuseIdentifier = "recipientCell"
fileprivate let recipientSearchCellReuseIdentifier = "recipientSearchCell"

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let data: [String] = ["BG12JSW61293812093", "BG12JSW61293812093", "BG12JSW61293812093"]
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
    }
    
    // MARK: Data delegation
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if collectionView == accountsCollectionView {
                return self.data.count
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
                cell.accountNumberLabel.text = self.data[indexPath.row]
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
        }
    }
    
    // MARK: Cell info button tapped action
    
    func didTapInfoButton(sender: UIButton?) {
        
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
    
    @IBAction func unwindToSendScreen(segue: UIStoryboardSegue) {}
}


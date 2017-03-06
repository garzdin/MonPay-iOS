//
//  RecipientsTableViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

fileprivate let reuseIdentifier = "recipientCell"

class RecipientsTableViewController: UITableViewController, BeneficiaryCreateDelegate, RecipientDeleteDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
    }
    
    func refreshData() {
        DataStore.shared.getBeneficiaries { 
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.beneficiaries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecipientTableViewCell
        cell.setupCell(beneficiary: DataStore.shared.beneficiaries[indexPath.row])
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipientDetails" {
            if let detailsViewController = segue.destination as? RecipientDetailsViewController {
                if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
                    detailsViewController.delegate = self
                    detailsViewController.recipient = DataStore.shared.beneficiaries[selectedRow]
                }
            }
        }
        if segue.identifier == "addNewRecipient" {
            if let newRecipientViewController = segue.destination as? RecipientCreateViewController {
                newRecipientViewController.delegate = self
            }
        }
    }
    
    func didDeleteRecipient(recipient: Beneficiary) {
        if let index = DataStore.shared.beneficiaries.index(of: recipient) {
            DataStore.shared.beneficiaries.remove(at: index)
            self.tableView.reloadData()
        }
    }
    
    func didAdd(beneficiary: Beneficiary) {
        DataStore.shared.beneficiaries.append(beneficiary)
        self.tableView.reloadData()
    }
}

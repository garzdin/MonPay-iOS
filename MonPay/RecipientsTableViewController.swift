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

class RecipientsTableViewController: UITableViewController, AddNewRecipientDelegate, RecipientDeleteDelegate {
    
    var recipients: [Beneficiary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
        self.getRecipientsData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecipientTableViewCell
        if let first_name = self.recipients[indexPath.row].first_name, let last_name = self.recipients[indexPath.row].last_name {
            cell.nameLabel.text = "\(first_name) \(last_name)"
            if let firstNameInitial = first_name.characters.first, let lastNameInitial = last_name.characters.first {
                cell.initialsLabel.text = "\(firstNameInitial)\(lastNameInitial)"
            }
        }
        if let account = self.recipients[indexPath.row].account?.iban {
            cell.accountLabel.text = account
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipientDetails" {
            if let detailsViewController = segue.destination as? RecipientDetailsViewController {
                if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
                    detailsViewController.delegate = self
                    detailsViewController.recipient = self.recipients[selectedRow]
                }
            }
        }
        if segue.identifier == "addNewRecipient" {
            if let addNewRecipientViewController = segue.destination as? AddNewRecipientViewController {
                addNewRecipientViewController.delegate = self
            }
        }
    }
    
    func didDeleteRecipient(recipient: Beneficiary) {
        if let index = self.recipients.index(of: recipient) {
            self.recipients.remove(at: index)
            self.tableView.reloadData()
        }
    }
    
    func didAddNewRecipient(recipient: Beneficiary) {
        self.recipients.append(recipient)
        self.tableView.reloadData()
    }
    
    func getRecipientsData() {
        Fetcher.sharedInstance.beneficiaryList { (response: [String : Any]?) in
            if let beneficiaries = response?["beneficiaries"] as? [Any] {
                for beneficiary in beneficiaries {
                    if let beneficiary = beneficiary as? [String: Any] {
                        self.recipients.append(Beneficiary(values: beneficiary))
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
}

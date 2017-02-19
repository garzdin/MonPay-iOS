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

class RecipientsTableViewController: UITableViewController, RecipientDeleteDelegate {
    
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
        }
        cell.accountLabel.text = "18927309123701923"
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
    }
    
    func didDeleteRecipient(recipient: Beneficiary) {
        if let index = self.recipients.index(of: recipient) {
            self.recipients.remove(at: index)
            self.tableView.reloadData()
        }
    }
    
    func getRecipientsData() {
        Networking.sharedInstance.authenticatedRequest(url: "beneficiary", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:]) { (response) in
            if response.1 == nil {
                if let beneficiaries = response.0?["beneficiaries"] as? [Any] {
                    for beneficiary in beneficiaries {
                        if let beneficiary = beneficiary as? [String: Any] {
                            self.recipients.append(Beneficiary(values: beneficiary))
                        }
                    }
                }
            } else {
                if let errorDict = response.1 as [String: Any]? {
                    print(errorDict)
                }
                return
            }
            self.tableView.reloadData()
        }
    }
}

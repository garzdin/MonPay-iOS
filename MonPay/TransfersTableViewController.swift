//
//  TransfersTableViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

fileprivate let reuseIdentifier = "transferCell"

class TransfersTableViewController: UITableViewController, TransactionDeleteDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
    }
    
    func refreshData() {
        DataStore.shared.getTransactions { 
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TransferTableViewCell
        if let id = DataStore.shared.transactions[indexPath.row].id, let amount = DataStore.shared.transactions[indexPath.row].amount, let currency = DataStore.shared.transactions[indexPath.row].currency, let status = DataStore.shared.transactions[indexPath.row].completed {
            for beneficiary in DataStore.shared.beneficiaries {
                if beneficiary.id == id {
                    cell.nameLabel.text = "\(beneficiary.first_name) \(beneficiary.last_name)"
                }
            }
            cell.amountLabel.text = "\(amount) \(currency)"
            cell.statusLabel.text = status ? "Completed on 20 Sept 2016" : "Processing"
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTransferDetails" {
            if let detailsViewController = segue.destination as? TransferDetailsViewController {
                if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
                    detailsViewController.delegate = self
                    detailsViewController.transaction = DataStore.shared.transactions[selectedRow]
                }
            }
        }
    }
    
    func didDelete(transaction: Transaction) {
        if let index = DataStore.shared.transactions.index(of: transaction) {
            DataStore.shared.transactions.remove(at: index)
            self.tableView.reloadData()
        }
    }
}

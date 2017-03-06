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
        cell.setupCell(transaction: DataStore.shared.transactions[indexPath.row])
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

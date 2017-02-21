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

class TransfersTableViewController: UITableViewController, TransferDeleteDelegate {
    
    var transfers: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
        self.getTransfersData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transfers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TransferTableViewCell
        if let amount = self.transfers[indexPath.row].amount, let currency = self.transfers[indexPath.row].currency {
            cell.amountLabel.text = "\(amount) \(currency)"
        }
        cell.nameLabel.text = "Jane Doe"
        cell.statusLabel.text = "Completed on 20 Sept 2016"
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTransferDetails" {
            if let detailsViewController = segue.destination as? TransferDetailsViewController {
                if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
                    detailsViewController.delegate = self
                    detailsViewController.transfer = self.transfers[selectedRow]
                }
            }
        }
    }
    
    func didDeleteTransfer(transfer: Transaction) {
        if let index = self.transfers.index(of: transfer) {
            self.transfers.remove(at: index)
            self.tableView.reloadData()
        }
    }
    
    func getTransfersData() {
        Fetcher.sharedInstance.transactionList { (response: [String : Any]?) in
            if let transfers = response?["transactions"] as? [Any] {
                for transfer in transfers {
                    if let transfer = transfer as? [String: Any] {
                        self.transfers.append(Transaction(values: transfer))
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
}

//
//  TransfersTableViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "transferCell"

class TransfersTableViewController: UITableViewController {
    
    let data: [[String:Any]] = [
        ["name": "John Doe", "status": "Completed on 20 Sept 2016", "amount": "1000.00 GBP"],
        ["name": "Jane Doe", "status": "Completed on 20 Aug 2016", "amount": "300.00 GBP"],
        ["name": "John Smith", "status": "Completed on 20 Dec 2016", "amount": "800.00 GBP"],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TransferTableViewCell
        cell.nameLabel.text = data[indexPath.row]["name"] as? String
        cell.statusLabel.text = data[indexPath.row]["status"] as? String
        cell.amountLabel.text = data[indexPath.row]["amount"] as? String
        return cell
    }
}

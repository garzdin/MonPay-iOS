//
//  RecipientsTableViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "recipientCell"

class RecipientsTableViewController: UITableViewController {
    
    let data: [[String:Any]] = [
        ["name": "John Doe", "account": "BG••••••••••••123"],
        ["name": "Jane Doe", "account": "BG••••••••••••456"],
        ["name": "John Smith", "account": "BG••••••••••••789"]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecipientTableViewCell
        cell.nameLabel.text = data[indexPath.row]["name"] as? String
        cell.accountLabel.text = data[indexPath.row]["account"] as? String
        return cell
    }
}

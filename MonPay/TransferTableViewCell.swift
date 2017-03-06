//
//  TransferTableViewCell.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

fileprivate let dateTimeFormat: String = "yyyy-MM-dd HH:mm:ss.S"

class TransferTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: self.frame)
        selectedView.backgroundColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0)
        self.selectedBackgroundView = selectedView
        self.dateFormatter.dateFormat = dateTimeFormat
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(transaction: Transaction?) {
        if let transaction = transaction {
            if let beneficiaryId = transaction.beneficiary {
                for beneficiary in DataStore.shared.beneficiaries {
                    if beneficiary.id == beneficiaryId {
                        if let firstName = beneficiary.first_name, let lastName = beneficiary.last_name {
                            self.nameLabel.text = "\(firstName) \(lastName)"
                        }
                    }
                }
            }
            if let amount = transaction.amount, let currencyId = transaction.currency {
                for currency in DataStore.shared.currencies {
                    if currency.id == currencyId {
                        if let isoCode = currency.isoCode {
                            self.amountLabel.text = "\(amount) \(isoCode)"
                        }
                    }
                }
            }
            if let updatedOn = transaction.updated_on {
                self.statusLabel.text = self.dateFormatter.string(from: updatedOn)
            } else {
                self.statusLabel.text = "Processing"
            }
        }
    }

}

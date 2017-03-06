//
//  RecipientTableViewCell.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class RecipientTableViewCell: UITableViewCell {

    @IBOutlet var profileView: UIView!
    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var accountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: self.frame)
        selectedView.backgroundColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0)
        self.selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            profileView.backgroundColor = UIColor(red: 12/255.0, green: 27/255.0, blue: 42/255.0, alpha: 1.0)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            profileView.backgroundColor = UIColor(red: 12/255.0, green: 27/255.0, blue: 42/255.0, alpha: 1.0)
        }
    }
    
    func setupCell(beneficiary: Beneficiary?) {
        if let beneficiary = beneficiary {
            if let firstName = beneficiary.first_name, let lastName = beneficiary.last_name {
                self.nameLabel.text = "\(firstName) \(lastName)"
                if let firstNameInitial = firstName.characters.first, let lastNameInitial = lastName.characters.first {
                    self.initialsLabel.text = "\(firstNameInitial)\(lastNameInitial)"
                }
            }
            if let account = beneficiary.account?.iban {
                self.accountLabel.text = account
            }
        }
    }
}

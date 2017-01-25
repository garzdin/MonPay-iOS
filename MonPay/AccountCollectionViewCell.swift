//
//  AccountCollectionViewCell.swift
//  MonPay
//
//  Created by Teodor on 25/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class AccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var accountNumberLabel: UILabel!
    @IBOutlet var selectedIndicator: UIView!
    @IBOutlet var infoButton: UIButton!
    var accountSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedIndicator.isHidden = true
    }
}

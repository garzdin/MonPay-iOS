//
//  RecipientCollectionViewCell.swift
//  MonPay
//
//  Created by Teodor on 25/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class RecipientCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var profileView: UIView!
    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    let selectedView = UIView()
    let checkMark = UIImage(named: "tick")
    let selectedCheckMark = UIImageView()
    var recipientSelected = false
    
    func setSelected() {
        selectedView.backgroundColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 0.8)
        selectedView.frame = self.profileView.frame
        selectedView.layer.cornerRadius = self.profileView.frame.height / 2
        self.profileView.addSubview(selectedView)
        self.profileView.bringSubview(toFront: selectedView)
        
        selectedCheckMark.image = checkMark
        selectedCheckMark.backgroundColor = UIColor.clear
        selectedCheckMark.frame.size = CGSize(width: 16.0, height: 20.0)
        selectedCheckMark.center = profileView.center
        self.profileView.addSubview(selectedCheckMark)
        self.profileView.bringSubview(toFront: selectedCheckMark)
    }
    
    func setUnselected() {
        self.selectedView.removeFromSuperview()
        self.selectedCheckMark.removeFromSuperview()
    }
}

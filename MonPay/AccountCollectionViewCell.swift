//
//  AccountCollectionViewCell.swift
//  MonPay
//
//  Created by Teodor on 25/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

fileprivate let selectedIndicatorHeight: CGFloat = 2.0

class AccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var accountNumberLabel: UILabel!
    @IBOutlet var infoButton: UIButton!
    
    var accountSelected: Bool = false
    
    var highlighView: UIView?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if self.window == nil {
            self.setDeselected()
        }
    }
    
    func setSelected(collectionView: UICollectionView, cell: UICollectionViewCell) {
        if let view = self.highlighView {
            collectionView.addSubview(view)
        } else {
            let frame = CGRect(x: cell.frame.origin.x, y: collectionView.frame.height - selectedIndicatorHeight, width: self.contentView.frame.size.width, height: selectedIndicatorHeight)
            self.highlighView = UIView(frame: frame)
            self.highlighView?.backgroundColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0)
            collectionView.addSubview(self.highlighView!)
        }
    }
    
    func setDeselected() {
        self.highlighView?.removeFromSuperview()
    }
}

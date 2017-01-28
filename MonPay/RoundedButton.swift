//
//  RoundedButton.swift
//  MonPay
//
//  Created by Teodor on 27/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0) {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 20.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}

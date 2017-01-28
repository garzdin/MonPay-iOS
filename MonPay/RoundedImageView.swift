//
//  RoundedImageView.swift
//  MonPay
//
//  Created by Teodor on 28/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

@IBDesignable class RoundedImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 20.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}

//
//  UnderlinedTextField.swift
//  MonPay
//
//  Created by Teodor on 27/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {
    
    let color: UIColor = UIColor(red: 90/255.0, green: 111/255.0, blue: 131/255.0, alpha: 1.0)

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName: color])
    }

}

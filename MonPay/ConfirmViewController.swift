//
//  ConfirmViewController.swift
//  MonPay
//
//  Created by Teodor on 25/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func confirm(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

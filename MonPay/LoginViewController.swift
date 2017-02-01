//
//  LoginViewController.swift
//  MonPay
//
//  Created by Teodor on 26/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        performSegue(withIdentifier: "authenticated", sender: sender)
    }
}

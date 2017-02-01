//
//  InitialViewController.swift
//  MonPay
//
//  Created by Teodor on 26/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    @IBAction func loginAction(_ sender: UIButton) {
        performSegue(withIdentifier: "login", sender: sender)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        performSegue(withIdentifier: "register", sender: sender)
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        performSegue(withIdentifier: "forgotPassword", sender: sender)
    }
    
    @IBAction func unwindToInitialScreen(segue: UIStoryboardSegue) {}
}

//
//  AccountSettingsViewController.swift
//  MonPay
//
//  Created by Teodor on 31/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        Keychain.sharedInstance.delete("token")
        Keychain.sharedInstance.delete("refresh_token")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController")
        initialViewController.view.alpha = 0
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            UIApplication.shared.keyWindow?.rootViewController = initialViewController
            initialViewController.view.alpha = 1
        }, completion: nil)
    }
}

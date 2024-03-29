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
        Keychain.shared.delete("token")
        Keychain.shared.delete("refresh_token")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController")
        
        initialViewController.view.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.size.height)
        initialViewController.view.center = self.view.center
        
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.4, options:.curveEaseInOut, animations: {
            initialViewController.view.transform = CGAffineTransform.identity
            UIApplication.shared.keyWindow?.rootViewController = initialViewController
        })
    }
}

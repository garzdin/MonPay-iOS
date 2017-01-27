//
//  InitialViewController.swift
//  MonPay
//
//  Created by Teodor on 26/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0).cgColor
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0).cgColor
        registerButton.layer.cornerRadius = registerButton.frame.size.height / 2
        forgotPasswordButton.layer.borderWidth = 2
        forgotPasswordButton.layer.borderColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0).cgColor
        forgotPasswordButton.layer.cornerRadius = forgotPasswordButton.frame.size.height / 2
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

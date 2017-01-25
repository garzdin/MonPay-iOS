//
//  ConfirmViewController.swift
//  MonPay
//
//  Created by Teodor on 25/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {

    @IBOutlet var confirmationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationButton.layer.borderWidth = 2
        confirmationButton.layer.borderColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0).cgColor
        confirmationButton.layer.cornerRadius = confirmationButton.frame.size.height / 2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func dismissConfirmation(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func confirm(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

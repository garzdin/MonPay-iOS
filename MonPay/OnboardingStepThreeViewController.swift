//
//  OnboardingStepThreeViewController.swift
//  MonPay
//
//  Created by Teodor on 31/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

class OnboardingStepThreeViewController: UIViewController, IDRecognizerDelegate {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openCamera" {
            if let cameraViewController = segue.destination as? CameraViewController {
                cameraViewController.delegate = self
            }
        }
    }
    
    func didDetectIDCard(image: UIImage) {
        let data = UIImageJPEGRepresentation(image, 1.0)
        if let data = data {
            print("Data:", data)
        }
    }

    @IBAction func registerAction(_ sender: UIButton) {
        if let user = self.user {
            
        }
    }
}

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
    var imageData: Data?
    var alert: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.alert = UIAlertController(title: "", message: "You account has been created", preferredStyle: .alert)
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
            self.imageData = data
        }
    }

    @IBAction func registerAction(_ sender: UIButton) {
        if let user = user, let image = imageData {
            let params: Parameters = [
                "email": user.email!,
                "password": user.password!,
                "first_name": user.first_name!,
                "last_name": user.last_name!,
                "entity_type": 0,
                "date_of_birth": user.date_of_birth!,
            ]
            let addressParams: Parameters = [
                "address": user.address!.address!,
                "city": user.address!.city!,
                "postal_code": user.address!.postal_code!,
                "country": user.address!.country!
            ]
            Fetcher.sharedInstance.authCreate(params: params, completion: { (response: [String : Any]?) in
                if let _ = response?["user"] as? [String: Any] {
                    Fetcher.sharedInstance.userAddressUpdate(params: addressParams, completion: { (addressResponse: [String : Any]?) in
                        if let _ = addressResponse?["address"] as? [String: Any] {
                            self.present(self.alert!, animated: true, completion: nil)
                            let when = DispatchTime.now() + 8
                            DispatchQueue.main.asyncAfter(deadline: when, execute: { 
                                self.alert?.dismiss(animated: true, completion: { 
                                    self.dismiss(animated: true, completion: nil)
                                })
                            })
                        }
                    })
                }
            })
        }
    }
}

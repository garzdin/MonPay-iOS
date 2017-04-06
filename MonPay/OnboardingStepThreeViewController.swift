//
//  OnboardingStepThreeViewController.swift
//  MonPay
//
//  Created by Teodor on 31/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

fileprivate let dateFormat: String = "yyyy-MM-dd"

class OnboardingStepThreeViewController: UIViewController, IDRecognizerDelegate {
    
    var user: User?
    var imageData: Data?
    var alert: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.alert = UIAlertController(title: "", message: "Your account has been created", preferredStyle: .alert)
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
        if let user = user, let _ = imageData {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            let date_of_birth = dateFormatter.string(from: user.date_of_birth!)
            let params: Parameters = [
                "email": user.email!,
                "password": user.password!,
                "first_name": user.first_name!,
                "last_name": user.last_name!,
                "entity_type": 0,
                "date_of_birth": date_of_birth,
                "address": [
                    "address": user.address!.address!,
                    "city": user.address!.city!,
                    "postal_code": user.address!.postal_code!,
                    "country": user.address!.country!
                ]
            ]
            Fetcher.shared.authCreate(params: params, completion: { (response: [String : Any]?) in
                if let _ = response?["user"] as? [String: Any] {
                    self.present(self.alert!, animated: true, completion: nil)
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when, execute: {
                        self.alert?.dismiss(animated: true, completion: {
                            self.performSegue(withIdentifier: "unwindFromRegistration", sender: self)
                        })
                    })
                }
            })
        }
    }
}

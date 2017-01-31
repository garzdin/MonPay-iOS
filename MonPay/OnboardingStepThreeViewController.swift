//
//  OnboardingStepThreeViewController.swift
//  MonPay
//
//  Created by Teodor on 31/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class OnboardingStepThreeViewController: UIViewController, IDRecognizerDelegate {

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
        print(image.size.width, image.size.height)
    }

}

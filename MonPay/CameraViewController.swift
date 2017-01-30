//
//  CameraViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var takePhotoButton: RoundedButton!
    
    @IBInspectable var rectangleBorderWidth: CGFloat = 2.0 {
        didSet {
            self.highlightView?.layer.borderWidth = rectangleBorderWidth
        }
    }
    
    @IBInspectable var rectangleBorderColor: UIColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0) {
        didSet {
            self.highlightView?.layer.borderColor = rectangleBorderColor.cgColor
        }
    }
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var highlightView: UIView?
    
    var detector: CIDetector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        takePhotoButton.isEnabled = false
        
        detector = CIDetector(
            ofType: CIDetectorTypeRectangle,
            context: nil,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        )
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
        } catch {
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "AVCaptureSession"))
        
        captureSession.addOutput(videoOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = self.view.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        self.view.layer.addSublayer(previewLayer!)
        
        highlightView = UIView()
        
        highlightView?.backgroundColor = UIColor.clear
        highlightView?.layer.borderColor = rectangleBorderColor.cgColor
        highlightView?.layer.borderWidth = rectangleBorderWidth
        
        self.view.addSubview(highlightView!)
        
        self.view.bringSubview(toFront: self.takePhotoButton)
        self.view.bringSubview(toFront: self.dismissButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        let cvImage = CMSampleBufferGetImageBuffer(sampleBuffer)
        let outputImage = CIImage(cvImageBuffer: cvImage!)
        let scale = (self.previewLayer?.bounds.size.width)! / (self.previewLayer?.bounds.size.height)!
        if let feature = detector?.features(in: outputImage).first as? CIRectangleFeature {
            let frame = CGRect(x: (feature.topRight.x * scale) - ((feature.topLeft.y * scale) - (feature.bottomLeft.y * scale)), y: feature.bottomLeft.y * scale, width: (feature.topLeft.y * scale) - (feature.bottomLeft.y * scale), height: (feature.topRight.x * scale) - (feature.topLeft.x * scale))
            DispatchQueue.main.async {
                self.highlightView?.frame = frame
            }
            takePhotoButton.isEnabled = true
        } else {
            DispatchQueue.main.async {
                self.highlightView?.frame = CGRect.zero
            }
            takePhotoButton.isEnabled = false
        }
    }

    @IBAction func takePhoto(_ sender: UIButton) {
        
    }
    
    @IBAction func dismissCameraView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

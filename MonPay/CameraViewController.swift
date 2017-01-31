//
//  CameraViewController.swift
//  MonPay
//
//  Created by Teodor on 29/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import AVFoundation

protocol IDRecognizerDelegate: class {
    func didDetectIDCard(image: UIImage)
}

enum DeviceOrientation: Int {
    case photos_EXIF_0ROW_TOP_0COL_LEFT = 1,
    photos_EXIF_0ROW_TOP_0COL_RIGHT = 2,
    photos_EXIF_0ROW_BOTTOM_0COL_RIGHT = 3,
    photos_EXIF_0ROW_BOTTOM_0COL_LEFT = 4,
    photos_EXIF_0ROW_LEFT_0COL_TOP = 5,
    photos_EXIF_0ROW_RIGHT_0COL_TOP = 6,
    photos_EXIF_0ROW_RIGHT_0COL_BOTTOM = 7,
    photos_EXIF_0ROW_LEFT_0COL_BOTTOM = 8
}

@IBDesignable class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet var dismissButton: UIButton!
    
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
    
    weak var delegate: IDRecognizerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detector = CIDetector(
            ofType: CIDetectorTypeRectangle,
            context: nil,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        )
        
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720
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
        previewLayer?.backgroundColor = UIColor.black.cgColor
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
        
        self.view.layer.addSublayer(previewLayer!)
        
        highlightView = UIView()
        
        highlightView?.backgroundColor = UIColor.clear
        highlightView?.layer.borderColor = rectangleBorderColor.cgColor
        highlightView?.layer.borderWidth = rectangleBorderWidth
        
        self.view.addSubview(highlightView!)
        
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
        
        let curDeviceOrientation : UIDeviceOrientation = UIDevice.current.orientation
        var exifOrientation : Int
        
        switch curDeviceOrientation {
            
        case UIDeviceOrientation.portraitUpsideDown:
            exifOrientation = DeviceOrientation.photos_EXIF_0ROW_LEFT_0COL_BOTTOM.rawValue
        case UIDeviceOrientation.landscapeLeft:
            exifOrientation = DeviceOrientation.photos_EXIF_0ROW_TOP_0COL_LEFT.rawValue
        case UIDeviceOrientation.landscapeRight:
            exifOrientation = DeviceOrientation.photos_EXIF_0ROW_BOTTOM_0COL_RIGHT.rawValue
        default:
            exifOrientation = DeviceOrientation.photos_EXIF_0ROW_RIGHT_0COL_TOP.rawValue
        }
        
        let imageOptions : NSDictionary = [CIDetectorImageOrientation : NSNumber(value: exifOrientation as Int)]
        
        if let feature = detector?.features(in: outputImage, options: imageOptions as? [String : AnyObject]).first as? CIRectangleFeature {
            
            let fdesc: CMFormatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)!
            let clap: CGRect = CMVideoFormatDescriptionGetCleanAperture(fdesc, false)
            
            let frame = self.drawBoxForFeature(feature, clap: clap, orientation: curDeviceOrientation)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.highlightView?.frame = frame
                if frame.width / frame.height > 1.5 {
                    self.delegate?.didDetectIDCard(image: UIImage(ciImage: outputImage.cropping(to: frame)))
                    self.dismiss(animated: true, completion: {
                        self.captureSession.stopRunning()
                    })
                }
            })
        }
    }
    
    func drawBoxForFeature(_ feature: CIFeature, clap: CGRect, orientation: UIDeviceOrientation) -> CGRect {
        let parentFrameSize: CGSize = self.view.frame.size
        let gravity: NSString = previewLayer!.videoGravity as NSString
        
        let previewBox : CGRect = self.videoPreviewBoxForGravity(gravity, frameSize: parentFrameSize, apertureSize: clap.size)
        
        var faceRect : CGRect = feature.bounds
        
        var temp: CGFloat = faceRect.width
        faceRect.size.width = faceRect.height
        faceRect.size.height = temp
        temp = faceRect.origin.x
        faceRect.origin.x = faceRect.origin.y
        faceRect.origin.y = temp
        let widthScaleBy = previewBox.size.width / clap.size.height
        let heightScaleBy = previewBox.size.height / clap.size.width
        faceRect.size.width *= widthScaleBy
        faceRect.size.height *= heightScaleBy
        faceRect.origin.x *= widthScaleBy
        faceRect.origin.y *= heightScaleBy
        
        return faceRect.offsetBy(dx: previewBox.origin.x, dy: previewBox.origin.y)
    }
    
    func videoPreviewBoxForGravity(_ gravity : NSString, frameSize : CGSize, apertureSize : CGSize) -> CGRect {
        let apertureRatio : CGFloat = apertureSize.height / apertureSize.width
        let viewRatio : CGFloat = frameSize.width / frameSize.height
        
        var size : CGSize = CGSize.zero
        if gravity.isEqual(to: AVLayerVideoGravityResizeAspectFill) {
            if viewRatio > apertureRatio {
                size.width = frameSize.width
                size.height = apertureSize.width * (frameSize.width / apertureSize.height)
            } else {
                size.width = apertureSize.height * (frameSize.height / apertureSize.width)
                size.height = frameSize.height
            }
        } else if gravity.isEqual(to: AVLayerVideoGravityResizeAspect) {
            if viewRatio > apertureRatio {
                size.width = apertureSize.height * (frameSize.height / apertureSize.width)
                size.height = frameSize.height
            } else {
                size.width = frameSize.width
                size.height = apertureSize.width * (frameSize.width / apertureSize.height)
            }
        } else if gravity.isEqual(to: AVLayerVideoGravityResize) {
            size.width = frameSize.width
            size.height = frameSize.height
        }
        
        var videoBox: CGRect = CGRect.zero
        videoBox.size = size
        if size.width < frameSize.width {
            videoBox.origin.x = (frameSize.width - size.width) / 2;
        } else {
            videoBox.origin.x = (size.width - frameSize.width) / 2;
        }
        
        if size.height < frameSize.height {
            videoBox.origin.y = (frameSize.height - size.height) / 2;
        } else {
            videoBox.origin.y = (size.height - frameSize.height) / 2;
        }
        
        return videoBox
    }
    
    @IBAction func dismissCameraView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

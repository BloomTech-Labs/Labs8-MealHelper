//
//  CameraViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 15.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class CameraViewController: UIViewController {
    
    // MARK: - Properties
    private var captureSession: AVCaptureSession!
    private var previewView = CameraPreview()
    private var barcodeScanner = BarcodeScanner()
    private var scanLayer = CAShapeLayer()
    private var blurView = UIVisualEffectView (effect: UIBlurEffect (style: UIBlurEffect.Style.dark))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcodeScanner.delegate = self
        
        setupCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: - User actions
    
    
    // MARK: - Configuration
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
    }
    
    private func setupCapture() {
        // Setup: AVCaptureDeviceInput --> AVCaptureSession --> AVCaptureOutput (i.e. AVCaptureVideoPreviewLayer & AVCaptureVideoDataOutput)
        
        // VideoPreviewLayer - Sets up a blur view with a see-through rectangle in the middle in which the barcode should be scanned
        view.addSubview(previewView)
        previewView.frame = view.frame
        
        //let blurView = UIVisualEffectView (effect: UIBlurEffect (style: UIBlurEffect.Style.extraLight))
        blurView.frame = previewView.frame
        blurView.isUserInteractionEnabled = false
        self.previewView.addSubview(blurView)
        
        let blurViewPath = UIBezierPath (
            roundedRect: blurView.frame,
            cornerRadius: 0)
        
        let scanPathWidth: CGFloat = 300.0
        let scanPath = UIBezierPath(roundedRect: CGRect(x: (view.bounds.width - scanPathWidth) / 2, y: 175.0, width: scanPathWidth, height: 250.0), cornerRadius: 10.0)
        
        blurViewPath.append(scanPath)
        blurViewPath.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = blurViewPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        
        // var scanLayer = CAShapeLayer()
        scanLayer.path = scanPath.cgPath
        scanLayer.strokeColor = UIColor.white.cgColor
        scanLayer.fillColor = UIColor.clear.cgColor
        scanLayer.lineWidth = 6.5
        
        blurView.layer.addSublayer(scanLayer)
        
        if #available(iOS 11.0, *) {
            blurView.alpha = 0.65
            blurView.layer.mask = maskLayer
        } else {
            let maskView = UIView(frame: self.view.frame)
            maskView.backgroundColor = UIColor.black
            maskView.layer.mask = scanLayer
            blurView.mask = maskView
        }
        
        // Session
        let captureSession = AVCaptureSession()
        
        // Input
        let device = bestCamera()
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(videoDeviceInput) else { // check if it can be added or not
                // fatalError()
                // TODO: Handle absence of appropriate capture device (e.g. alert view "No camera available")
                return
        }
        captureSession.addInput(videoDeviceInput)
        
        // VideoDataOutput
        let videoDataOutput = AVCaptureVideoDataOutput()
        // TODO: Set Videosettings (compression settings)
        // DispatchQueue that will handle video frames
        let dataOutputQueue = DispatchQueue(label: "video-data-queue",
                                            qos: .userInitiated,
                                            attributes: [],
                                            autoreleaseFrequency: .workItem)
        videoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String) : NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)]
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }
        
        captureSession.sessionPreset = .medium
        captureSession.commitConfiguration() // Save all configurations and set up captureSession
        
        self.captureSession = captureSession
        
        previewView.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fills entire screen
        
        previewView.videoPreviewLayer.session = captureSession
    }
    
    // Choose the best camera on the device
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            // TODO: Handle absence of appropriate capture device (e.g. alert view "No camera available")
            fatalError("Missing expected back camera device")
        }
    }
    
    private func animateScanLayerAsProcessing() {
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.fromValue = UIColor.white.cgColor
        animation.toValue = UIColor.green.cgColor
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = 6
        animation.isRemovedOnCompletion = false
        scanLayer.add(animation, forKey: "processing")
    }
    
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Detect video frames with Firebase MLVisionBarcodeModel
        if barcodeScanner.isScanning {
            barcodeScanner.detectBarcodes(with: .buffer(sampleBuffer))
        }
    }
    
    // Keep in case we need to work with images (e.g. compression)
    private func imageFromSampleBuffer(_ sampleBuffer : CMSampleBuffer) -> UIImage {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        // Get the number of bytes per row, width and height for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!)
        let width = CVPixelBufferGetWidth(imageBuffer!)
        let height = CVPixelBufferGetHeight(imageBuffer!)
        
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage = context?.makeImage()
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly)
        
        // Create an image object from the Quartz image
        let image = UIImage.init(cgImage: quartzImage!)
        
        return (image)
    }
    
}

extension CameraViewController: BarcodeScannerDelegate {
    
    func barcodeScanner(_ controller: BarcodeScanner, didFinishScanningWithCode barcode: String) {
        animateScanLayerAsProcessing()
        
        // Make call to usda api
        print("Barcode: \(barcode)")
        FoodClient.shared.fetchUsdaIngredients(with: barcode) { (response) in
            switch response {
            case .success(let ingredients):
                DispatchQueue.main.async {
                    self.scanLayer.strokeColor = UIColor.green.cgColor
                    self.barcodeScanner.startScanning()
                    let swipeVC = SwipableViewController()
                    swipeVC.view.translatesAutoresizingMaskIntoConstraints = false
                    let titleLabel = UILabel()
                    if let name = ingredients.first?.name {
                        titleLabel.text = name
                        titleLabel.textAlignment = .center
                        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
                    }
                    self.addChild(swipeVC)
                    swipeVC.didMove(toParent: self)
                    self.view.addSubview(swipeVC.view)
                    swipeVC.popupView.addSubview(titleLabel)
                    
                    swipeVC.view.fillSuperview()
                    titleLabel.anchor(top: swipeVC.popupView.topAnchor, leading: swipeVC.popupView.leadingAnchor, bottom: nil, trailing: swipeVC.popupView.trailingAnchor)
                }
            
            case .error(let error):
                DispatchQueue.main.async {
                    self.scanLayer.strokeColor = UIColor.red.cgColor
                    self.barcodeScanner.startScanning()
                    print(error)
                }
            }
        }
    }
    
    func barcodeScanner(_ controller: BarcodeScanner, didReceiveError error: Error) {
        // Handle error
    }
    
    private func display(_ ingredientDetails: UIViewController) {
        
    }
    
}

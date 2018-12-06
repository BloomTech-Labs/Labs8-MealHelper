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
    
    weak var delegate: SearchIngredientDetailDelegate?
    var searchedIngredient: Ingredient?
    var barcode: String?
    
    private var captureSession: AVCaptureSession!
    private var previewView = CameraPreview()
    private var barcodeScanner = BarcodeScanner()
    private var ingredientDetailView: SwipableViewController?
    private var scanLayer = CAShapeLayer()
    private var blurView = UIVisualEffectView (effect: UIBlurEffect (style: UIBlurEffect.Style.dark))
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Scan a barcode"
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcodeScanner.delegate = self
        
        setupCapture()
        setupViews()
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
    
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDismissSwipeView() {
        guard let barcode = barcode else { return }
        
        // Remove dismissed ingredient's barcode from cache so user can scan it again if need be
        barcodeScanner.remove(barcode)
        
        ingredientDetailView?.dismissView()
        
        // Reset ingredient detail
        self.searchedIngredient = nil
        self.ingredientDetailView = nil
        self.barcode = nil
        
        // When ingredient swipe view is dismissed we start the barcode scanner again
        self.barcodeScanner.startScanning()
    }
    
    // MARK: - Configuration
    
    private func setupCapture() {
        // Setup: AVCaptureDeviceInput --> AVCaptureSession --> AVCaptureOutput (i.e. AVCaptureVideoPreviewLayer & AVCaptureVideoDataOutput)
        
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
    
    private func setupViews() {
        // VideoPreviewLayer - Sets up a blur view with a see-through rectangle in the middle in which the barcode should be scanned
        view.addSubview(previewView)
        previewView.frame = view.frame
        blurView.frame = previewView.frame
        blurView.isUserInteractionEnabled = false
        self.previewView.addSubview(blurView)
        
        let blurViewPath = UIBezierPath (
            roundedRect: blurView.frame,
            cornerRadius: 0)
        
        let scanPathWidth: CGFloat = 300.0
        let scanPath = UIBezierPath(roundedRect: CGRect(x: (view.bounds.width - scanPathWidth) / 2, y: 250.0, width: scanPathWidth, height: 250.0), cornerRadius: 7.0)
        
        blurViewPath.append(scanPath)
        blurViewPath.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = blurViewPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        scanLayer.path = scanPath.cgPath
        scanLayer.strokeColor = UIColor.white.cgColor
        scanLayer.fillColor = UIColor.clear.cgColor
        scanLayer.lineWidth = 3
        
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
        
        // Other views
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: blurView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 20), size: CGSize(width: 20, height: 20))
    }
    
    private func display(_ ingredient: Ingredient) {
        
        let swipeVC = SwipableViewController()
        swipeVC.delegate = self
        ingredientDetailView = swipeVC
        swipeVC.openHeight = UIScreen.main.bounds.height - 150
        swipeVC.closedHeight = 300
        
        let ingredientDetailVC = SearchIngredientDetailViewController()
        ingredientDetailVC.closeButton.isHidden = true
        ingredientDetailVC.backgroundIsTransparent = true
        ingredientDetailVC.ingredient = ingredient
        
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(named: "plus-icon")!, for: .normal)
        addButton.addTarget(self, action: #selector(self.addToRecipe), for: .touchUpInside)
        addButton.backgroundColor = .sunRed
        addButton.tintColor = .white
        addButton.layer.cornerRadius = 35 / 2
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        cancelButton.tintColor = .white
        cancelButton.addTarget(self, action: #selector(handleDismissSwipeView), for: .touchUpInside)
        
        self.add(swipeVC)
        
        swipeVC.addChild(ingredientDetailVC)
        swipeVC.popupView.addSubview(ingredientDetailVC.view)
        ingredientDetailVC.didMove(toParent: swipeVC)
        
        swipeVC.view.addSubview(addButton)
        swipeVC.view.addSubview(cancelButton)
        
        swipeVC.view.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0))
        addButton.anchor(top: swipeVC.popupView.topAnchor, leading: nil, bottom: nil, trailing: swipeVC.popupView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 20), size: CGSize(width: 35, height: 35))
        cancelButton.anchor(top: swipeVC.popupView.topAnchor, leading: swipeVC.popupView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 0), size: CGSize(width: 22, height: 22))
        ingredientDetailVC.view.anchor(top: addButton.bottomAnchor, leading: swipeVC.popupView.leadingAnchor, bottom: nil, trailing: swipeVC.popupView.trailingAnchor, padding: UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0))
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
        // Make call to usda api
        print("Barcode: \(barcode)")
        FoodClient.shared.fetchUsdaIngredients(with: barcode) { (response) in
            switch response {
            case .success(let ingredients):
                DispatchQueue.main.async {
                    guard let ingredient = ingredients.first else { return }
                    self.searchedIngredient = ingredient
                    self.barcode = barcode
                    self.display(ingredient)
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
        self.showAlert(with: "An issue occured while scanning the barcode. Please try again")
    }
    
    @objc private func addToRecipe(_ sender: UIButton) {
        if let ingredient = searchedIngredient, let ingredientDetailView = ingredientDetailView {
            delegate?.updateIngredient(ingredient, indexPath: nil)
            ingredientDetailView.dismissView()
            searchedIngredient = nil
            self.ingredientDetailView = nil
            self.barcode = nil
            
            self.barcodeScanner.startScanning()
        }
    }
    
}

extension CameraViewController: SwipeableViewControllerDelegate {
    
    func willDismissSwipeableView(_ swipeableView: SwipableViewController) {
        // TODO: when swipeVC is dismissed by sliding down then it won't show a ingred detail view anymore. it does scan though...
        //handleDismissSwipeView()
    }
    
}

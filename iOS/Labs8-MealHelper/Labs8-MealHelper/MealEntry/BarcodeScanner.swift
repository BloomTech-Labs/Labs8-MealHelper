//
//  BarcodeScanner.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 19.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import Firebase

public protocol BarcodeScannerDelegate: class {
    // func barcodeScanner(_ controller: BarcodeScanner, didChangeStatus status: BarcodeScanner.Status)
    func barcodeScanner(_ controller: BarcodeScanner, didFinishScanningWithCode barcode: String)
    func barcodeScanner(_ controller: BarcodeScanner, didReceiveError error: Error)
    // func barcodeScannerWillDismiss(_ controller: BarcodeScanner)
}

open class BarcodeScanner {
    
    public enum Status: String {
        case scanning // Scanning, but no barcode yet being detected
        case processing // Barcode detected
    }
    
    public enum ScanType {
        case image(UIImage)
        case buffer(CMSampleBuffer)
    }
    
    // MARK: - Public properties

    public weak var delegate: BarcodeScannerDelegate?
    public var isScanning = true
    public var scannedBarcodes = [String]()
    
    // MARK: - Private properties
    
    private lazy var vision = Vision.vision() // Firebase vision API
    
    // MARK: - Public methods
    
    public func startScanning() {
        isScanning = true
    }
    
    public func endScanning() {
        isScanning = false
    }
    
    public func detectBarcodes(with scan: ScanType) {
        guard isScanning == true else { return }
        
        // Define options for barcode detector
        let format = VisionBarcodeFormat.all // TODO: restrict format for better performance
        let barcodeOptions = VisionBarcodeDetectorOptions(formats: format)
        
        // Create barcode detector
        let barcodeDetector = vision.barcodeDetector(options: barcodeOptions)
        let image = visionImage(for: scan)
        
        barcodeDetector.detect(in: image) { (features, error) in
            if let error = error {
                NSLog("On-device barcode detection failed with error \(String(describing: error))")
                self.delegate?.barcodeScanner(self, didReceiveError: error)
                return
            }
            
            guard let features = features, !features.isEmpty else {
                print("No barcode detected")
                return
            }
            
            // Check if item has already been scanned
            guard let barcodeString = features.first?.rawValue, !self.scannedBarcodes.contains(barcodeString) else {
                print("already scanned")
                return
            }
            
            self.scannedBarcodes.append(barcodeString)
            self.delegate?.barcodeScanner(self, didFinishScanningWithCode: barcodeString)
            self.isScanning = false
        }
    }
    
    public func remove(_ barcode: String) {
        guard let index = scannedBarcodes.index(of: barcode) else { return }
        scannedBarcodes.remove(at: index)
    }
    
    // MARK: - Private methods
    
    private func visionImage(for image: ScanType) -> VisionImage {
        switch image {
        case .image(let image):
            return VisionImage(image: image)
        case .buffer(let buffer):
            return VisionImage(buffer: buffer)
        }
    }

}

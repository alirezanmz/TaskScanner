//
//  QRCodeScannerViewController.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import UIKit
import AVFoundation

// Protocol to receive the scanned QR code string.
protocol QRCodeScannerViewControllerDelegate: AnyObject {
    func didFindQRCode(_ code: String)
}

// ViewController for scanning QR codes using the device camera.
class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    weak var delegate: QRCodeScannerViewControllerDelegate?  // Delegate to handle the found QR code.
    private var captureSession: AVCaptureSession?  // Manages the camera session.
    
    // Preview layer that shows the camera input.
    private lazy var previewLayer: AVCaptureVideoPreviewLayer? = {
        guard let captureSession = captureSession else { return nil }
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.frame = view.layer.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        return layer
    }()
    
    // Initialize the capture session and setup the camera input/output.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession?.canAddInput(videoInput) == true else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                guard let self = self else {return}
                
                self.failed()
            })
            return
        }
        captureSession?.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        guard captureSession?.canAddOutput(metadataOutput) == true else {
          
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                guard let self = self else {return}
                
                self.failed()
            })
            return
        }
        captureSession?.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [.qr]  // Detect QR codes only.
        
        _ = previewLayer  // Ensure the preview layer is created and added.
        captureSession?.startRunning()
       
    }
    
    // Handle failure by showing an alert and stopping the session.
    func failed() {
        let alertController = UIAlertController(
            title: "Scanning not supported",
            message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { _ in
            self.dismiss(animated: true)
        }))
        present(alertController, animated: true)
        captureSession = nil
    }
    
    // Stop the session when the view is about to disappear.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    // Handle detected QR codes by stopping the session and notifying the delegate.
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        if let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    // Notify the delegate of the found QR code.
    func found(code: String) {
        delegate?.didFindQRCode(code)
    }
    
    // Hide the status bar for a full-screen experience.
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Restrict the interface orientation to portrait only.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

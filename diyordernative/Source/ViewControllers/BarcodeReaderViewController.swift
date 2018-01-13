//
//  BarcodeReaderViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-11.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeReaderViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate, QRCodeHandlerDelegate {
    
    static let tabTitle = "scan"
    
    static let icon = #imageLiteral(resourceName: "icon_qrcode")
    
    var session: AVCaptureSession!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var qrCodeFrameView: UIView!
    
    @IBOutlet weak var scanRectView: UIView!
    
    @IBOutlet weak var borderImageView: UIImageView!
    
    @IBOutlet weak var lineImageView: UIImageView!
    
    @IBOutlet weak var lineImageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var borderHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var maskView: UIView!
    
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barStyle = .blackTranslucent
        tabBarItem = UITabBarItem (title: BarcodeReaderViewController.tabTitle, image: BarcodeReaderViewController.icon, tag: 2)
        self.title = LanguageControl.shared.getLocalizeString(by: BarcodeReaderViewController.tabTitle)
        
        dismissButton.title = LanguageControl.shared.getLocalizeString(by: "close")
        dismissButton.target = self
        dismissButton.action = #selector(handleOnDismissButtonTapped(_:))
        
        session = AVCaptureSession()
        
        var deviceDiscoverySession: AVCaptureDevice.DiscoverySession?
        if #available(iOS 10.2, *) {
            deviceDiscoverySession = AVCaptureDevice.DiscoverySession (deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        } else {
            // Fallback on earlier versions
        }
        
        guard let captureDevice = deviceDiscoverySession!.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput (device: captureDevice)
            session.addInput(videoInput)
        } catch {
            print(error)
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        session.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer (session: session)
        previewLayer.frame = view.layer.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
        
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if session != nil && !session!.isRunning {
            session.startRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setMask ()
        view.bringSubview(toFront: scanRectView)
        startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if session != nil && session!.isRunning {
            session.stopRunning()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implementation
    
    func barcodeDetected (code: String) {
        let handler = QRCodeHandler.create(result: code)
        handler.delegate = self
        handler.execute()
    }
    
    private func startAnimation () {
        lineImageView.layer.removeAllAnimations()
        
        lineImageViewBottomConstraint.constant = -borderHeightConstraint.constant
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.0, animations: {
            self.lineImageViewBottomConstraint.constant = 0
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        })
    }
    
    private func setMask () {
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
        let maskPath = UIBezierPath (rect: CGRect(x: 0, y: 0, width: maskView.frame.width, height: maskView.frame.height))
        maskPath.append(UIBezierPath (roundedRect: scanRectView.frame, cornerRadius: 1).reversing())
        let maskLayer = CAShapeLayer ()
        maskLayer.path = maskPath.cgPath
        maskView.layer.mask = maskLayer
        view.bringSubview(toFront: maskView)
    }
    
    @objc private func handleOnDismissButtonTapped (_ sender: AnyObject?) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            barcodeDetected (code: metadataObj.stringValue ?? "Empty")
        }
        
        session.stopRunning()
    }
    
    // MARK: - QRCodeHandlerDelegate
    
    func onQRCodeExecuteSuccess () {
        dismiss(animated: true, completion: nil)
    }
    
    func onQRCodeExecuteFailure () {
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


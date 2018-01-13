//
//  BarcodeReaderViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-11.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeReaderViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {

    static let tabTitle = "scan"
    
    static let icon = #imageLiteral(resourceName: "icon_qrcode")
    
    var session: AVCaptureSession!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var qrCodeFrameView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: BarcodeReaderViewController.tabTitle, image: BarcodeReaderViewController.icon, tag: 2)
        self.title = LanguageControl.shared.getLocalizeString(by: BarcodeReaderViewController.tabTitle)
        
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
    
    func barcodeDetected (code: String) {
        QRCodeHandler.create(result: code).execute(completion: {
            self.qrCodeFrameView?.frame = CGRect.zero
            if self.session != nil && !self.session!.isRunning {
                self.session.startRunning()
            }
        })
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

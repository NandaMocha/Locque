//
//  ScannerVC.swift
//  Locque
//
//  Created by Nanda Mochammad on 18/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let shared = DataManager.shared
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanQRCode()
    }
    
    @IBAction func cancelBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func scanQRCode() {
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else{return}
        let videoInput : AVCaptureDeviceInput
        
        do{
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch{
            return
        }
        
        if(captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        }else{
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if(captureSession.canAddOutput(metadataOutput)){
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }else{
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(previewLayer)
        view.layer.insertSublayer(previewLayer, at: 0)
        
        captureSession.startRunning()
    }
    
    func failed(){
        shared.setAlert(title: "Sorry", message: "Scanning is not supported", sender: self) { (done) in}
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(captureSession.isRunning == false){
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if(captureSession.isRunning == true){
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first{
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else{return}
            guard let stringValue = readableObject.stringValue else{return}
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
//        dismiss(animated: true, completion: nil)
        
    }
    
    private var dataSpecificLocker: LockerData!
    private var code = 0
    func found(code: String){
        let viewLayer = UIView()
        viewLayer.backgroundColor = UIColor.white
        viewLayer.alpha = 0.7
        viewLayer.frame = self.view.frame
        
        let activityInd = UIActivityIndicatorView()
        activityInd.style = .gray
        activityInd.center = self.view.center
        
        viewLayer.addSubview(activityInd)
        
        activityInd.startAnimating()
        activityInd.hidesWhenStopped = true
        
        self.view.addSubview(viewLayer)
        
        print("The code is ", code)
        shared.CheckSpecificLocker(number: Int(code) ?? 0) { (data) in
            activityInd.stopAnimating()
            
            self.code = Int(code) ?? 0
            
            print("DataHasilRequest, ", data)
            self.dataSpecificLocker = data.first
            self.performSegue(withIdentifier: "showResult", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ResultScannerVC, segue.identifier == "showResult"{
            print("data locker : ", dataSpecificLocker as Any)
            destination.numberLocker = code
            print("Code: ", code)
            destination.typeLocker = dataSpecificLocker.lockerType
            destination.number = "\(dataSpecificLocker.lockerType) - \(dataSpecificLocker.lockerNumber)"
            if dataSpecificLocker.lockerOwner != ""{
                destination.status = "Unavailable"
                destination.owner = dataSpecificLocker.lockerOwner
                destination.timer = dataSpecificLocker.lockerTimer
                destination.notes = dataSpecificLocker.lockerNotes
            }else{
                destination.status = "Available"

            }
            
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }

}

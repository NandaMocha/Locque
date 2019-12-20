//
//  extension.swift
//  Locque
//
//  Created by Nanda Mochammad on 20/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import AVKit

extension UIViewController{
//    func createScanner(){
//        let captureSession = AVCaptureSession()
//
//        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else{return}
//        let videoInput : AVCaptureDeviceInput
//
//        do{
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//        }catch{
//            return
//        }
//
//        if(captureSession.canAddInput(videoInput)){
//            captureSession.addInput(videoInput)
//        }else{
//            failed()
//            return
//        }
//
//        let metadataOutput = AVCaptureMetadataOutput()
//        if(captureSession.canAddOutput(metadataOutput)){
//            captureSession.addOutput(metadataOutput)
//
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.qr]
//        }else{
//            failed()
//            return
//        }
//
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = view.layer.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//        //        view.layer.addSublayer(previewLayer)
//        view.layer.insertSublayer(previewLayer, at: 0)
//
//        captureSession.startRunning()
//    }
//
//    private func failed(){
//        shared.setAlert(title: "Sorry", message: "Scanning is not supported", sender: self) { (done) in}
//        captureSession = nil
//    }
//
//    private override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if(captureSession.isRunning == false){
//            captureSession.startRunning()
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if(captureSession.isRunning == true){
//            captureSession.stopRunning()
//        }
//    }
//
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//
//        captureSession.stopRunning()
//        if let metadataObject = metadataObjects.first{
//            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else{return}
//            guard let stringValue = readableObject.stringValue else{return}
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            found(code: stringValue)
//        }
//        //        dismiss(animated: true, completion: nil)
//
//    }
}

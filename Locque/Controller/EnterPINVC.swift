//
//  EnterPINVC.swift
//  Locque
//
//  Created by Nanda Mochammad on 17/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreLocation

class EnterPINVC: UIViewController, CLLocationManagerDelegate {

    let shared = DataManager.shared
    let locationManager = CLLocationManager()

    @IBOutlet weak var textfieldPIN: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        locationManager.delegate = self
        // 2
        locationManager.requestAlwaysAuthorization()
        // 3
//        loadAllGeotifications()
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
////        mapView.showsUserLocation = (status == .authorizedAlways)
//    }
//    
//    func region(with geotification: Geotification) -> CLCircularRegion {
//        // 1
//        let region = CLCircularRegion(center: geotification.coordinate,
//                                      radius: geotification.radius,
//                                      identifier: geotification.identifier)
//        // 2
//        region.notifyOnEntry = (geotification.eventType == .onEntry)
//        region.notifyOnExit = !region.notifyOnEntry
//        return region
//    }
//    
//    func startMonitoring(geotification: Geotification) {
//        // 1
//        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
//            return
//        }
//        // 2
//        if CLLocationManager.authorizationStatus() != .authorizedAlways {
//            let message = """
//      Your geotification is saved but will only be activated once you grant
//      Geotify permission to access the device location.
//      """
//            showAlert(withTitle:"Warning", message: message)
//        }
//        // 3
//        let fenceRegion = region(with: geotification)
//        // 4
//        locationManager.startMonitoring(for: fenceRegion)
//    }


    
    

    
    override func viewWillAppear(_ animated: Bool) {
        print("Enter PIN")
        if checkGeofencing() == true{
            if shared.isUsingBiometric == true{
                checkBiometric()
            }
        }else{
            shared.setAlert(title: "Attention", message: "Make sure you are around the Apple Academy", sender: self) { (done) in}
        }
        
    }
    
    func checkGeofencing()->Bool{
        return true
    }
    
    func checkBiometric() {
        
        Authenticate { (success) in
            print("Success")
            if success != false{
                
                DispatchQueue.main.async {
                    self.textfieldPIN.text = self.shared.PINUser
                    self.performSegue(withIdentifier: "goToMainPage", sender: self)

                }
            }
        }
    }
    
    func Authenticate(completion: @escaping ((Bool) -> ())){
        
        //Create a context
        let authenticationContext = LAContext()
        var error:NSError?
        
        //Check if device have Biometric sensor
        let isValidSensor : Bool = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if isValidSensor {
            //Device have BiometricSensor
            //It Supports TouchID
            
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Touch / Face ID authentication",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if(success) {
                        // Touch / Face ID recognized success here
                        completion(true)
                    } else {
                        //If not recognized then
                        if let error = error {
                            let strMessage = self.errorMessage(errorCode: error._code)
                            if strMessage != ""{
                                self.showAlertWithTitle(title: "Error", message: strMessage)
                            }
                        }
                        completion(false)
                    }
            })
        } else {
            
            let strMessage = self.errorMessage(errorCode: (error?._code)!)
            if strMessage != ""{
                self.showAlertWithTitle(title: "Error", message: strMessage)
            }
        }
        
    }
    
    func errorMessage(errorCode:Int) -> String{
        
        var strMessage = ""
        
        switch errorCode {
            
        case LAError.Code.authenticationFailed.rawValue:
            strMessage = "Authentication Failed"
            
        case LAError.Code.userCancel.rawValue:
            strMessage = "User Cancel"
            
        case LAError.Code.systemCancel.rawValue:
            strMessage = "System Cancel"
            
        case LAError.Code.passcodeNotSet.rawValue:
            strMessage = "Please goto the Settings & Turn On Passcode"
            
        case LAError.Code.appCancel.rawValue:
            strMessage = "App Cancel"
            
        case LAError.Code.invalidContext.rawValue:
            strMessage = "Invalid Context"
            
        default:
            strMessage = ""
            
        }
        return strMessage
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }

}

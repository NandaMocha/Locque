//
//  MainPageVC.swift
//  Locque
//
//  Created by Nanda Mochammad on 17/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import AVKit
import CoreLocation

class MainPageVC: UIViewController {

    @IBOutlet weak var lockerStatus: UILabel!
    @IBOutlet weak var numberLocker: UILabel!
    @IBOutlet weak var timeOfLock: UILabel!
    @IBOutlet weak var notesOfLocker: UILabel!
    @IBOutlet weak var actionLocker: UIButton!
    @IBOutlet weak var findLocker: UIButton!
    
    let shared = DataManager.shared
    
    var myLocker : LockerData?
    
    let locationManager = CLLocationManager()
    
    var statusLocation = "InsideFence"
    
    let geofenceRegionCenter = CLLocationCoordinate2DMake(-6.3021887,106.652015)
    
    /* Create a region centered on desired location,
     choose a radius for the region (in meters)
     choose a unique identifier for that region */
    var geofenceRegion = CLCircularRegion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if shared.lockerNumber == ""{
            numberLocker.text = "-"
            timeOfLock.text = "-"
            notesOfLocker.text = "-"
        }
        
        print("ID ", self.shared.ID_lockerUser)
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        geofenceRegion = CLCircularRegion(center: geofenceRegionCenter,
                                          radius: 100,
                                          identifier: "UniqueIdentifier")
        
        geofenceRegion.notifyOnEntry = true
        geofenceRegion.notifyOnExit = true
    }
    
    @IBAction func actionLocker(_ sender: UIButton) {
        if actionLocker.titleLabel?.text == "Get a Locker"{
            performSegue(withIdentifier: "goToScannerVC", sender: self)
        }else{
            let alert = UIAlertController(title: "Attention", message: "You will free up your locker?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (done) in
                print(self.shared.ID_lockerUser)
                self.shared.FreeTheLocker(number: self.shared.ID_lockerUser, completion: { (done) in
                    self.shared.ID_lockerUser = 0
                    self.shared.lockerNotes = ""
                    self.shared.lockerNumber = ""
                    self.shared.lockerTimer = ""

                    self.shared.saveDataUserToUserDefaults()

                    self.myLocker = nil
                    self.loadData()
                })
            }))
            self.present(alert, animated: true)
        }
    }
    
    
    @IBAction func Settings(_ sender: Any) {
    }
    
    @IBAction func unwindToMainPage(segue: UIStoryboardSegue){
    }
    
    func updateView(data: LockerData) {
        lockerStatus.text = data.lockerOwner == shared.emailUser ? "YOU HAVE LOCKER" : "NO LOCKER"
        numberLocker.text = data.lockerOwner == shared.emailUser ? "\(data.lockerType) - \(data.lockerNumber)" : "-"
        timeOfLock.text = data.lockerOwner == shared.emailUser ? data.lockerTimer : "-"
        notesOfLocker.text = data.lockerOwner == shared.emailUser ? data.lockerNotes : "-"
        let title = data.lockerOwner == shared.emailUser ? "Free my Locker" : "Get a Locker"
        actionLocker.setTitle(title, for: .normal)
    }
    
    func loadData() {
        if statusLocation == "InsideFence"{
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
            
            shared.GetLockerData { (dataLocker) in
                for data in dataLocker{
                    if data.lockerOwner == self.shared.emailUser{
                        self.myLocker = data
                        self.shared.ID_lockerUser = Int(self.myLocker!.lockerID)!
                    }
                }
                self.shared.saveDataUserToUserDefaults()
                viewLayer.removeFromSuperview()
                if self.myLocker == nil{
                    self.myLocker = LockerData(lockerID: "A", lockerType: "A", lockerNumber: "A", lockerOwner: "A", lockerTimer: "A", lockerNotes: "A")
                }
                self.updateView(data: self.myLocker!)
            }
        }else{
            let alert = UIAlertController(title: "Attention", message: "Make sure you're inside the academy", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (done) in
                self.numberLocker.text = "-"
                self.timeOfLock.text = "-"
                self.notesOfLocker.text = "-"
                self.actionLocker.isEnabled = false
                self.findLocker.isEnabled = false
            }))
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
}

extension MainPageVC: CLLocationManagerDelegate {
    // called when user Exits a monitored region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.statusLocation = "OutsideFence"
            print("Out the Academy")
        }
    }
    
    // called when user Enters a monitored region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.statusLocation = "InsideFence"
            print("Enter the Academy")
        }
    }
    
    
}

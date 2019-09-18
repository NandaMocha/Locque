//
//  MainPageVC.swift
//  Locque
//
//  Created by Nanda Mochammad on 17/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import AVKit

class MainPageVC: UIViewController {

    @IBOutlet weak var lockerStatus: UILabel!
    @IBOutlet weak var numberLocker: UILabel!
    @IBOutlet weak var timeOfLock: UILabel!
    @IBOutlet weak var notesOfLocker: UILabel!
    @IBOutlet weak var actionLocker: UIButton!
    
    let shared = DataManager.shared
    
    var myLocker : LockerData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if shared.lockerNumber == ""{
            numberLocker.text = "-"
            timeOfLock.text = "-"
            notesOfLocker.text = "-"
        }
        
        print("ID ", self.shared.ID_lockerUser)
    }
    
    @IBAction func actionLocker(_ sender: UIButton) {
        if actionLocker.titleLabel?.text == "Get a Locker"{
            performSegue(withIdentifier: "goToScannerVC", sender: self)
        }else{
            let alert = UIAlertController(title: "Attention", message: "You will free up your locker?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (done) in
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
                }
            }
            
            viewLayer.removeFromSuperview()
            if self.myLocker == nil{
                self.myLocker = LockerData(lockerType: "A", lockerNumber: "A", lockerOwner: "A", lockerTimer: "A", lockerNotes: "A")
            }
            self.updateView(data: self.myLocker!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
}

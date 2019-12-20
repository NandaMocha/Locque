//
//  ResultScannerVC.swift
//  Locque
//
//  Created by Nanda Mochammad on 18/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class ResultScannerVC: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var lockerTitle: UILabel!
    @IBOutlet weak var lockerNumber: UILabel!
    @IBOutlet weak var lockerStatus: UILabel!
    @IBOutlet weak var lockerOwner: UITextField!
    @IBOutlet weak var lockerTimer: UITextField!
    @IBOutlet weak var lockerNotes: UITextField!
    @IBOutlet weak var actionLocker: UIButton!
    
    var numberLocker : Int = 0
    var typeLocker : String = "-"
    
    var number = "-"
    var status: String = "-"
    var owner: String = ""
    var timer: String = ""
    var notes: String = ""
    
    let shared = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOpacity = 1
        background.layer.shadowOffset = .zero
        background.layer.shadowRadius = 10
        
        lockerNumber.text = number
        lockerStatus.text = status
        lockerOwner.text = owner
        lockerTimer.text = timer
        lockerNotes.text = notes
        
        if status == "Available"{
            lockerTitle.text = "Locker is Ready"
            actionLocker.setTitle("Get the Locker", for: .normal)
            lockerOwner.text = shared.emailUser
            lockerTimer.isEnabled = false
            print("Email USer: ", shared.emailUser)
        }else{
            lockerTitle.text = "Sorry, It's Booked"
            actionLocker.setTitle("Find Other Locker", for: .normal)
            lockerOwner.isEnabled = false
            lockerTimer.isEnabled = false
            lockerNotes.isEnabled = false
            
        }
        
        lockerStatus.textColor = status == "Available" ? UIColor.green : UIColor.red

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    @IBAction func getTheLocker(_ sender: Any) {
        notes = lockerNotes.text!
        if actionLocker.titleLabel?.text == "Get the Locker"{
            shared.UpdateLocker(number: numberLocker, typeLocker, timer: self.dateFormatting(), notes: notes) { status  in
                if status == true{
                    self.shared.ID_lockerUser = self.numberLocker
                    self.shared.saveDataUserToUserDefaults()
                    let alert = UIAlertController(title: "Done", message: "You got your locker", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (done) in
                        self.performSegue(withIdentifier: "unwindToMainPageWithSegue", sender: self)
                    }))
                    
                    self.present(alert, animated: true)
                }else{
                    
                    let alert = UIAlertController(title: "Sorry", message: "There is a mistake, we will fix it soon", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (done) in
                        self.performSegue(withIdentifier: "unwindToMainPageWithSegue", sender: self)
                    }))
                    
                    self.present(alert, animated: true)
                }
            }
        }else{
            print("Locker is booked")
            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "unwindToMainPageWithSegue", sender: self)
        }
        
        
    }
    
    func dateFormatting() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy - HH:mm:ss"//"EE" to get short style
        let timer = dateFormatter.string(from: date).capitalized

        
        return "\(timer)"
    }
    
}

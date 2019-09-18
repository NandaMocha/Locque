//
//  DataManager.swift
//  Locque
//
//  Created by Nanda Mochammad on 17/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class DataManager{
    
    static let shared = DataManager()
    
    private init(){}
    
    var isLoggedIn = false
    var isUsingBiometric = true
    var nameUser = ""
    var emailUser = ""
    var PINUser = ""
    
    var lockerNumber = ""
    var lockerNotes = ""
    var lockerTimer = ""
    
    var lockerData : [LockerData] = []
    
    let defaults = UserDefaults.standard
    

    func saveDataUserToUserDefaults(){
        defaults.set(isLoggedIn, forKey: "isLoggedIn")
        defaults.set(nameUser, forKey: "nameUser")
        defaults.set(emailUser, forKey: "emailUser")
        defaults.set(PINUser, forKey: "PINUser")
    }
    
    func loadDataUserFromUserDefaults(){
        isLoggedIn = defaults.bool(forKey: "isLoggedIn")
        if let dataName = defaults.string(forKey: "nameUser"),
            let dataEmail = defaults.string(forKey: "emailUser"),
            let dataPIN = defaults.string(forKey: "PINUser"){
            nameUser = dataName
            emailUser = dataEmail
            PINUser = dataPIN
        }
    }
    
    func setAlert(title: String, message: String, sender: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        sender.present(alert, animated: true)
    }
    
    func userBeginLogin(email: String, password: String)-> Bool{
        var errors = false
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil{
                print("Login Error, ",error!)
                errors = true
            }else{
                print(authResult?.user.email!)
                print("userBeginLogin Did It! -> Login Success")
                errors = false
                
                self.isLoggedIn = true
                self.emailUser = email
                self.nameUser = email
                self.saveDataUserToUserDefaults()
            }
        }
        return errors
    }
    
    func GetLockerData(completion: @escaping ([LockerData]) -> Void){
        
        var lockertype = ""
        var lockernum = 0
        var lockerowner = ""
        var lockertimer = ""
        var lockernotes = ""
        
        let ref = Database.database().reference().child("locquee")
        print("Cek retrieve")
        //Closure
        ref.observe(.value) { (snapshot) in
            print("Data Snapshot, ", snapshot)
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                self.lockerData.removeAll()
                for snap in snapshot{
                    if let data = snap.value as? Dictionary<String, Any>{
                        lockertype = data["lockerType"] as! String
                        lockernum = data["lockerNumber"] as! Int
                        lockerowner = data["lockerOwner"] as! String
                        lockertimer = data["lockerTimer"] as! String
                        lockernotes = data["lockerNotes"] as! String
                        
                        let dataOfLocker = LockerData.init(lockerType:lockertype, lockerNumber: lockernum, lockerOwner: lockerowner, lockerTimer: lockertimer, lockerNotes: lockernotes)
                        
                        self.lockerData.append(dataOfLocker)

                    }
                }
            }
            completion(self.lockerData)
        }
    }
    
    
}

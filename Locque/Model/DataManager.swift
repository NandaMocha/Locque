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
    
    var ID_lockerUser = 0
    var lockerNumber = ""
    var lockerNotes = ""
    var lockerTimer = ""
    
    var lockerData : [LockerData] = []
    var dataSpecificLocker : [LockerData] = []
    
    let defaults = UserDefaults.standard
    

    func saveDataUserToUserDefaults(){
        defaults.set(isLoggedIn, forKey: "isLoggedIn")
        defaults.set(nameUser, forKey: "nameUser")
        defaults.set(emailUser, forKey: "emailUser")
        defaults.set(PINUser, forKey: "PINUser")
        defaults.set(ID_lockerUser, forKey: "ID_lockerUser")
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
        
        ID_lockerUser = defaults.integer(forKey: "ID_lockerUser")
    }
    
    func setAlert(title: String, message: String, sender: UIViewController, completion: @escaping(Bool)->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        sender.present(alert, animated: true)
        completion(true)
    }
    
//    func setAlertToView(title: String, message: String, sender: UIViewController, handler: @escaping()->Void){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        sender.present(alert, animated: true)
//    }
    
    func userBeginLogin(email: String, password: String)-> Bool{
        var errors = false
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil{
                print("Login Error, ",error!)
                errors = true
            }else{
                print(authResult?.user.email! as Any)
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
        var lockernum = ""
        var lockerowner = ""
        var lockertimer = ""
        var lockernotes = ""
        
        let ref = Database.database().reference(withPath: "LockerData")
        print("Cek retrieve")
        //Closure
        ref.observe(.value) { (snapshot) in
//            print("Data Snapshot, ", snapshot)
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                self.lockerData.removeAll()
                for snap in snapshot{
                    if let data = snap.value as? Dictionary<String, Any>{
                        lockertype = data["lockerType"] as! String
                        lockernum = "\(data["lockerNumber"] as! Int)"
                        lockerowner = data["lockerOwner"] as! String
                        lockertimer = data["lockerTimer"] as! String
                        lockernotes = data["lockerNotes"] as! String
                        
                        let dataOfLocker = LockerData.init(lockerType:lockertype, lockerNumber: lockernum, lockerOwner: lockerowner, lockerTimer: lockertimer, lockerNotes: lockernotes)
                        
                        self.lockerData.append(dataOfLocker)

                    }
                }
            }
            completion(self.lockerData)
            print("LockerData : ", self.lockerData)
        }
    }
    
    func CheckSpecificLocker(number: Int, completion: @escaping ([LockerData]) -> Void){
        var lockertype = ""
        var lockernum = ""
        var lockerowner = ""
        var lockertimer = ""
        var lockernotes = ""
        
        let ref = Database.database().reference(withPath: "LockerData/\(number)")
        print("Cek retrieve specific data")

        ref.observe(.value) { (snapshot) in
            print("DataSnapshot0, ", snapshot)

            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                self.dataSpecificLocker.removeAll()
                print("DataSnapshot1, ", snapshot)
                for snap in snapshot{
                    print("Snap")
                    print(snap.key)
                    print(snap.value as Any)
                    if snap.key == "lockerNumber"{
                        lockernum = "\((snap.value) ?? "0")"
                    }else if snap.key == "lockerType"{
                        lockertype = snap.value as! String
                    }else if snap.key == "lockerOwner"{
                        lockerowner = snap.value as! String
                    }else if snap.key == "lockerTimer"{
                        lockertimer = snap.value as! String
                    }else{
                        lockernotes = snap.value as! String
                    }
                    
                }
                let data = LockerData.init(lockerType: lockertype, lockerNumber: lockernum, lockerOwner: lockerowner, lockerTimer: lockertimer, lockerNotes: lockernotes)
                
                self.dataSpecificLocker.append(data)
            }
            print("LockerData : ", self.dataSpecificLocker)
            completion(self.dataSpecificLocker)
        }
    }
    
    func UpdateLocker(number: Int, _ type: String = "A", timer: String, notes: String, completion: @escaping(Bool)->Void){
        
        let ref = Database.database().reference(withPath: "LockerData/\(number)")
        
        let dataUpdateLocker = ["lockerOwner": emailUser,
                                 "lockerTimer": timer,
                                 "lockerNotes": notes
            ]
        
        print(number, emailUser, timer, notes)
        
        if timer != "" && notes != "" && emailUser != ""{
            ref.updateChildValues(dataUpdateLocker) { (error, ref) in
                print("Reference, ", ref, "\nError, ", error as Any)
                completion(true)
            }
        }else{
            print("Data not valid")
            completion(false)
            
        }
        
    }
    
    func FreeTheLocker(number: Int, completion: @escaping(Bool)->Void){
        
        let ref = Database.database().reference(withPath: "LockerData/\(number)")
        
        let dataUpdateLocker = ["lockerOwner": "",
                                "lockerTimer": "",
                                "lockerNotes": ""
        ]

        ref.updateChildValues(dataUpdateLocker) { (error, ref) in
                print("Reference, ", ref, "\nError, ", error as Any)
                completion(true)
        }
    }
    
    
}

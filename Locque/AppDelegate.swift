//
//  AppDelegate.swift
//  Locque
//
//  Created by Nanda Mochammad on 16/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let shared = DataManager.shared
    var initialViewController = UIViewController()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        shared.loadDataUserFromUserDefaults()
        if shared.isLoggedIn == false{
            initialViewController = (storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC)!
            print("move to sign in")
        }else{
            if shared.PINUser == ""{
                initialViewController = storyboard.instantiateViewController(withIdentifier: "SetPINVC")
                print("move to set pin")
            }else{
                initialViewController = storyboard.instantiateViewController(withIdentifier: "enterPIN")
                print("move to enter pin")
            }
        }
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}


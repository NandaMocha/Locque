//
//  ViewController.swift
//  Locque
//
//  Created by Nanda Mochammad on 16/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {
    
    let shared = DataManager.shared
    
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func SignInBTN(_ sender: Any) {
        let email = textfieldEmail.text!
        let password = textfieldPassword.text!
        if email != "" && password != ""{
            if shared.userBeginLogin(email: email, password: password) == false{
                
                shared.emailUser = email
                
                print("Success Login, Continue to Set PIN VC")
                performSegue(withIdentifier: "setPINVC", sender: self)
            }
        }else{
            shared.setAlert(title: "Sorry", message: "Please check your data \nor contact admin", sender: self) { (done) in
                
            }
        }
    }
    
    @IBAction func forgotPasswordBTN(_ sender: Any) {
        shared.setAlert(title: "Attention", message: "Please contact admin", sender: self) { (done) in
            
        }
    }
    
    @IBAction func unwindToSignIn(segue: UIStoryboardSegue){
    }
    
    
    
    
    
    
    
}




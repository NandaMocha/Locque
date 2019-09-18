//
//  SettingsVC.swift
//  Locque
//
//  Created by Nanda Mochammad on 18/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    let shared = DataManager.shared
    @IBOutlet weak var emailUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailUser.text = shared.emailUser
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOut(_ sender: Any) {
        let alert = UIAlertController(title: "Attention", message: "You want to Sign Out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (done) in
            self.removeData()
        }))
        
        self.present(alert, animated: true)
    }
    
    func removeData(){
        shared.isLoggedIn = false
        shared.isUsingBiometric = true
        shared.nameUser = ""
        shared.emailUser = ""
        shared.PINUser = ""
        
        shared.saveDataUserToUserDefaults()
        
        performSegue(withIdentifier: "unwindToSignIn", sender: self)
        
    }
}

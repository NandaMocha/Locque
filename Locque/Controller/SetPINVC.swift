//
//  SetPINVC.swift
//  Locque
//
//  Created by Nanda Mochammad on 18/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class SetPINVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var PinTF: UITextField!
    @IBOutlet weak var ConfirmPINTF: UITextField!
    
    let shared = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PinTF.keyboardType = .numberPad
        ConfirmPINTF.keyboardType = .numberPad
        
    }
    
    @IBAction func setPIN(_ sender: Any) {
        let pin = PinTF.text!
        let pinConfirm = ConfirmPINTF.text!
        
        if pin != "" && pinConfirm != "" && pin == pinConfirm{
            shared.PINUser = pin
            shared.saveDataUserToUserDefaults()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
            self.present(initialViewController, animated: true)
            
            print("move to enter pin")
        }else{
            shared.setAlert(title: "Sorry", message: "Please check your PIN", sender: self)
        }
    }

}

//
//  MainPageVC.swift
//  Locque
//
//  Created by Nanda Mochammad on 17/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class MainPageVC: UIViewController {

    @IBOutlet weak var lockerStatus: UILabel!
    @IBOutlet weak var numberLocker: UILabel!
    @IBOutlet weak var timeOfLock: UILabel!
    @IBOutlet weak var notesOfLocker: UILabel!
    
    let shared = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if shared.lockerNumber == ""{
            numberLocker.text = "-"
            timeOfLock.text = "-"
            notesOfLocker.text = "-"
        }
    }

    @IBAction func GetLocker(_ sender: Any) {
    }
    
    @IBAction func FindALocker(_ sender: Any) {
    }
    
    @IBAction func Settings(_ sender: Any) {
    }
    
    
    
}

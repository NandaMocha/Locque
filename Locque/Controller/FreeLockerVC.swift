//
//  FreeLockerVC.swift
//  Locque
//
//  Created by Nanda Mochammad on 18/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class FreeLockerVC: UIViewController, UITabBarDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let shared = DataManager.shared
    var lockerData : [LockerData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    @IBAction func segmentedDidChange(_ sender: UISegmentedControl) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lockerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        return UITableViewCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        shared.GetLockerData { (lockerData) in
            self.activityIndicator.stopAnimating()
            self.lockerData = lockerData
        }
    }
    
}

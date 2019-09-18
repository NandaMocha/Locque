//
//  FreeLockerVC.swift
//  Locque
//
//  Created by Nanda Mochammad on 18/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class FreeLockerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let shared = DataManager.shared
    var lockerData : [LockerData] = []
    var lockerType : [LockerData] = []
    
    var segmentPosition = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func segmentedDidChange(_ sender: UISegmentedControl) {
        var type = "A"
        switch sender.selectedSegmentIndex{
        case 0:
            type = "A"
            segmentPosition = "A"
        case 1:
            type = "B"
            segmentPosition = "B"
        case 2:
            type = "C"
            segmentPosition = "C"
        default:
            type = "D"
            segmentPosition = "D"
        }
        
        setLockerType(type: type)
    }
    
    func setLockerType(type: String){
        lockerType.removeAll()
        for data in lockerData{
            if data.lockerType == type && data.lockerOwner == ""{
                lockerType.append(data)
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lockerType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellLocker") as! CellLocker
        
        cell.lockerName.text = "Locker : \(lockerType[indexPath.row].lockerType) - \(lockerType[indexPath.row].lockerNumber)"
        
        return cell
    }
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        shared.setAlert(title: "Locker Ready", message: "Go to the locker and scan the barcode", sender: self) { (done) in}
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Find a Locker"
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.blue
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        shared.GetLockerData { (lockerData) in
            self.activityIndicator.stopAnimating()
            self.lockerData = lockerData
            print("Locker Data All Data ", self.lockerData)
            
            self.setLockerType(type: "A")
            print(self.lockerType)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func updateData(){
        shared.GetLockerData { (lockerData) in
            self.tableView.refreshControl?.endRefreshing()
            self.lockerData = lockerData
            print("Locker Data All Data ", self.lockerData)
            
            self.setLockerType(type: self.segmentPosition)
            print(self.lockerType)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

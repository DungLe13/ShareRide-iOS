//
//  SettingsViewController.swift
//  ShareRide
//
//  Created by Hamza Alsarhan on 5/6/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  THIS IS THE SETTING VIEW CONTROLLER with LOGOUT BUTTON

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sections = ["ABOUT", "CONTACT", ""]
    var cellLabels = ["About Us", "Contact Us"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = sections[section]
        return title
    }
    
    // MARK: - Table view data sourc
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = cellLabels[0]
            return cell
        } else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = cellLabels[1]
            return cell
        } else {
            let logOutCell = tableView.dequeueReusableCell(withIdentifier: "logOutCell", for: indexPath) as! SettingsTableViewCell
            logOutCell.logOutButton.setTitle("LOG OUT", for: .normal)
            logOutCell.logOutButton.backgroundColor = UIColor.red
            logOutCell.logOutButton.titleColor(for: .normal)
            logOutCell.logOutButton.layer.cornerRadius = 5
            logOutCell.logOutButton.layer.borderWidth = 1
            logOutCell.logOutButton.layer.borderColor = UIColor.red.cgColor
            logOutCell.logOutButton.addTarget(self, action: #selector(SettingsViewController.logOutPressed(sender:)), for: .touchUpInside)
            return logOutCell
        }
        
    }
    
    func logOutPressed(sender: UIButton!) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInView")
                present(vc!, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            let alertController = UIAlertController(title: "About Us", message: "The mission of ShareRide is to connect Middlebury College students in need of rides with their colleagues offering rides. Our goal is to make use of rides already going to certain places by filling up empty spaces with riders who are open to agree on a compensation.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else if (indexPath.section == 1) {
            let alertController = UIAlertController(title: "Contact Us", message: "Please send us an email with any questions, concerns, or suggestions you may have after using ShareRide @ \n shareridecontact@gmail.com", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }

    }

}

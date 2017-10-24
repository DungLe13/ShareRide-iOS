//
//  ActivitiesViewController.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/24/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  THE ACTIVITES TABLEVIEW (showing the current user's all posted rides and all requested rides)

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ActivitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activitiesTableView: UITableView!
    
    // MARK: Properties
    var myPostedRideItems = [RideInformationItem]()
    var myRequestedRideItems = [RequestInformationItem]()
    let ref = FIRDatabase.database().reference(withPath: "list-of-rides")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    let requestedRef = FIRDatabase.database().reference(withPath: "my-requested-rides")
    let sections = ["My Posted Rides", "My Requested Rides"]
    var selectedItemIndex: Int = 0
    var indexValueToPass: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUserID = FIRAuth.auth()?.currentUser?.uid
        let currentUserEmail = FIRAuth.auth()?.currentUser?.email
        // Retrieve the data from Firebase and display it to the tableView
        ref.observe(.value, with: { snapshot in
            var newPostedRideItem = [RideInformationItem]()

            for item in snapshot.children {
                let rideItemEmail = RideInformationItem(snapshot: item as! FIRDataSnapshot).driverEmail
                if currentUserEmail == rideItemEmail {
                    let postedItem = RideInformationItem(snapshot: item as! FIRDataSnapshot)
                    newPostedRideItem.append(postedItem)
                }
            }
            
            self.myPostedRideItems = newPostedRideItem
            self.activitiesTableView.reloadData()
        })
        
        self.usersRef.child(currentUserID!).observe(.value, with: { (snapshot) in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            let currentUserName = "\(firstName) \(lastName)"
            
            self.requestedRef.child(currentUserName).observe(.value, with: { snapshot in
                var newRequestedRideItem = [RequestInformationItem]()
                
                for item in snapshot.children {
                    let requestedItem = RequestInformationItem(snapshot: item as! FIRDataSnapshot)
                    newRequestedRideItem.append(requestedItem)
                }
                
                self.myRequestedRideItems = newRequestedRideItem
                self.activitiesTableView.reloadData()
            })
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView datasource and delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = sections[section]
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myPostedRideItems.count
        } else {
            return myRequestedRideItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activitiesCell", for: indexPath) as! ActivitiesTableViewCell
        
        if (indexPath.section == 0) {
            if myPostedRideItems.count == 0 {
                cell.destinationLabel.text = "You have no recent posted rides"
                cell.dateTimeLabel.text = ""
                cell.smallArrowLabel.text = ""
            } else {
                let rideInfoItem = myPostedRideItems[indexPath.row]
                cell.destinationLabel.text = rideInfoItem.departure + " to " + rideInfoItem.arrival
                cell.dateTimeLabel.text = rideInfoItem.date + " - " + rideInfoItem.time
            }
        } else {
            let rideInfoItem = myRequestedRideItems[indexPath.row]
            cell.destinationLabel.text = rideInfoItem.departure + " to " + rideInfoItem.arrival
            cell.dateTimeLabel.text = rideInfoItem.date + " - " + rideInfoItem.time
        }
        
        return cell
    }
    
    // delete my requested rides and my posted rides
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (indexPath.section == 0) {
                let postedItem = myPostedRideItems[indexPath.row]
                myPostedRideItems.remove(at: indexPath.row)
                activitiesTableView.deleteRows(at: [indexPath], with: .automatic)
                postedItem.ref?.removeValue()
                //activitiesTableView.reloadData()
            } else {
                let requestedItem = myRequestedRideItems[indexPath.row]
                myRequestedRideItems.remove(at: indexPath.row)
                activitiesTableView.deleteRows(at: [indexPath], with: .automatic)
                requestedItem.requestedRef?.removeValue()
                //activitiesTableView.reloadData()
            }
        }
    }
    
    // choosing the table view cell pressed
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedItemIndex = indexPath.row
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myRideDetailsSegue" {
            indexValueToPass = (activitiesTableView.indexPathForSelectedRow?.row)!
            print(indexValueToPass)
            let controller = segue.destination as! MyRideDetailsViewController
            controller.selectedPostItem = myPostedRideItems
            controller.selectedRequestItem = myRequestedRideItems
            controller.indexSelected = indexValueToPass
            let currentSection = activitiesTableView.indexPathForSelectedRow?.section
            controller.sectionSelected = currentSection!
        }
    }


}

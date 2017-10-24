//
//  NotificationsViewController.swift
//  ShareRide
//
//  Created by Hamza Alsarhan on 5/1/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  NOTIFICATIONS TABLEVIEW (display the ride requests as well as the acceptance annd/or denial on both driver's and requester's phone; also updating seats available when accepted;
//  this class also creates chat channel once the ride has been accepted

import UIKit
import FirebaseAuth
import FirebaseDatabase

enum Section: Int {
    case acceptDenySection = 0
    case acceptedSection
    case deniedSection
}

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notificationsTableView: UITableView!
    
    // MARK: Properties
    var myRequestedRideItems = [RequestInformationItem]()
    // requester's accepted ride item
    var myAcceptedRideItems = [RequestInformationItem]()
    // requester's denied ride item
    var myDeniedRideItems = [RequestInformationItem]()
    
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    let driverRequestedRef = FIRDatabase.database().reference(withPath: "driver-requested-rides")
    let requestedRef = FIRDatabase.database().reference(withPath: "my-requested-rides")
    
    let listOfRidesRef = FIRDatabase.database().reference(withPath: "list-of-rides")
    let acceptedRideRef = FIRDatabase.database().reference(withPath: "accepted-rides")
    let driverAcceptedRideRef = FIRDatabase.database().reference(withPath: "driver-accepted-rides")
    let deniedRideRef = FIRDatabase.database().reference(withPath: "denied-rides")
    let driverDeniedRideRef = FIRDatabase.database().reference(withPath: "driver-denied-rides")
    
    var currentUserName = ""
    var isAccepted = false
    var isDenied = false
    
    private var indexPath: IndexPath?
    private var index: Int?
    
    // Prepare for the messages
    var channelRef = FIRDatabase.database().reference().child("channels")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUserID = FIRAuth.auth()?.currentUser?.uid
        
        // get the current user name
        self.usersRef.child(currentUserID!).observe(.value, with: { (snapshot) in
            
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            self.currentUserName = "\(firstName) \(lastName)"
            print("the current user is \(self.currentUserName)")
        })
        
        // Make the acceptDenyCell appear on the driver's phone
        self.usersRef.child(currentUserID!).observe(.value, with: { (snapshot) in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            let currentUserName = "\(firstName) \(lastName)"
            
            self.driverRequestedRef.child(currentUserName).observe(.value, with: { snapshot in
                var newMyRequestedRideItems = [RequestInformationItem]()
                for item in snapshot.children {
                    let requestedItem = RequestInformationItem(snapshot: item as! FIRDataSnapshot)
                    newMyRequestedRideItems.append(requestedItem)
                }
                
                self.myRequestedRideItems = newMyRequestedRideItems
                self.notificationsTableView.reloadData()
                
            })
            
        })
        
        // Make the acceptedCell appear on requester's phone
        self.usersRef.child(currentUserID!).observe(.value, with: { (snapshot) in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            let currentUserName = "\(firstName) \(lastName)"
            
            self.acceptedRideRef.child(currentUserName).observe(.value, with: { snapshot in
                
                for item in snapshot.children {
                    let acceptedItem = RequestInformationItem(snapshot: item as! FIRDataSnapshot)
                    self.myAcceptedRideItems.append(acceptedItem)
                }
                
                self.notificationsTableView.reloadData()
            })
        })
        
        
        // Make the deniedCell appear on requester's phone
        self.usersRef.child(currentUserID!).observe(.value, with: { (snapshot) in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            let currentUserName = "\(firstName) \(lastName)"
            
            self.deniedRideRef.child(currentUserName).observe(.value, with: { snapshot in
                for item in snapshot.children {
                    let deniedItem = RequestInformationItem(snapshot: item as! FIRDataSnapshot)
                    self.myDeniedRideItems.append(deniedItem)
                }
                
                self.notificationsTableView.reloadData()
            })
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .acceptDenySection:
                return myRequestedRideItems.count
            case .acceptedSection:
                return myAcceptedRideItems.count
            case .deniedSection:
                return myDeniedRideItems.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // deals with different types of cells differently based on their reuse identifier
        let currentSection: Section = Section(rawValue: indexPath.section)!
        index = indexPath.row
        
        // check which section the user is in
        // the first case is in the driver's phone
        // the last two cases are in the requester's phone
        switch currentSection {
        case Section.acceptDenySection:
            let acceptDenyCell = tableView.dequeueReusableCell(withIdentifier: "acceptDenyNotificationsCell", for: indexPath) as! NotificationsTableViewCell
            
            // Configure the cell...
            let rideInfoItem = myRequestedRideItems[indexPath.row]
            acceptDenyCell.acceptDenyLabel.text = rideInfoItem.requesterName + " requested your " + rideInfoItem.departure + "-" + rideInfoItem.arrival + " ride."
            acceptDenyCell.acceptButton.setTitle("Accept", for: .normal)
            acceptDenyCell.acceptButton.backgroundColor = UIColor(colorLiteralRed: 50.0/255.0, green: 205.0/255.0, blue: 50.0/255.0, alpha: 0.9)
            acceptDenyCell.acceptButton.layer.cornerRadius = 5
            acceptDenyCell.acceptButton.layer.borderWidth = 1
            acceptDenyCell.acceptButton.layer.borderColor = UIColor.white.cgColor
            acceptDenyCell.acceptButton.addTarget(self, action: #selector(NotificationsViewController.acceptButtonPressed(sender:)), for: .touchUpInside)
            
            acceptDenyCell.denyButton.setTitle("Deny", for: .normal)
            acceptDenyCell.denyButton.backgroundColor = UIColor(colorLiteralRed: 220.0/255.0, green: 20.0/255.0, blue: 60.0/255.0, alpha: 0.9)
            acceptDenyCell.denyButton.layer.cornerRadius = 5
            acceptDenyCell.denyButton.layer.borderWidth = 1
            acceptDenyCell.denyButton.layer.borderColor = UIColor.white.cgColor
            acceptDenyCell.denyButton.addTarget(self, action: #selector(NotificationsViewController.denyButtonPressed(sender:)), for: .touchUpInside)
            
            return acceptDenyCell
        case Section.acceptedSection:
            let acceptedCell = tableView.dequeueReusableCell(withIdentifier: "acceptedNotificationsCell", for: indexPath) as! NotificationsTableViewCell
            
            // Configure the cell...
            let rideInfoItem = myAcceptedRideItems[indexPath.row]
            acceptedCell.acceptedLabel.text = rideInfoItem.driverName + " accepted your " + rideInfoItem.departure + "-" + rideInfoItem.arrival + " ride request. You can now message your driver under the Messages Tab."
            
            return acceptedCell
        case Section.deniedSection:
            let deniedCell = tableView.dequeueReusableCell(withIdentifier: "deniedNotificationsCell", for: indexPath) as! NotificationsTableViewCell
            
            // Configure the cell...
            let rideInfoItem = myDeniedRideItems[indexPath.row]
            deniedCell.deniedLabel.text = rideInfoItem.driverName + " denied your " + rideInfoItem.departure + "-" + rideInfoItem.arrival + " ride request."
            
            return deniedCell
        }
        
    }
    
    /* Accept Button is pressed */
    func acceptButtonPressed(sender: UIButton!){
        let buttonPosition:CGPoint = sender.convert(CGPoint.init(x:0, y:0), to: self.notificationsTableView)
        indexPath = self.notificationsTableView.indexPathForRow(at: buttonPosition)
        index = self.notificationsTableView.indexPathForRow(at: buttonPosition)?.row
        isAccepted = true
        print("The indexPath after accepted is \(indexPath)")
        
        let requestInfo = ["requester": myRequestedRideItems[index!].requesterName, "requesterEmail": myRequestedRideItems[index!].requesterEmail, "driverName": myRequestedRideItems[index!].driverName, "driverEmail":myRequestedRideItems[index!].driverEmail, "departure": myRequestedRideItems[index!].departure, "arrival": myRequestedRideItems[index!].arrival, "time": myRequestedRideItems[index!].time, "date": myRequestedRideItems[index!].date, "seatsAvailable": myRequestedRideItems[index!].seatsAvailable, "isRequested": "1", "isAccepted": "1", "isDenied": "0"] as [String : Any]
        // Requester is the child of this database
        let acceptedRideRequestRef = self.acceptedRideRef.child(myRequestedRideItems[index!].requesterName).childByAutoId()
        acceptedRideRequestRef.setValue(requestInfo)
        
        // Driver is the child of this database
        let driverAcceptedRideRequestRef = self.driverAcceptedRideRef.child(myRequestedRideItems[index!].driverName).childByAutoId()
        driverAcceptedRideRequestRef.setValue(requestInfo)
        
        // Create a new Channel database on Firebase when accepted
        let channelItem = ["name": "\(myRequestedRideItems[index!].departure) - \(myRequestedRideItems[index!].arrival)"]
        let newChannelRef = channelRef.childByAutoId()
        newChannelRef.setValue(channelItem)
        
        // Update seats available
        if myRequestedRideItems[index!].seatsAvailable >= 1 {
            listOfRidesRef.child("\(myRequestedRideItems[index!].departure) to \(myRequestedRideItems[index!].arrival)").updateChildValues([
                "seatsAvailable": myRequestedRideItems[index!].seatsAvailable - 1
            ])
        }
        
        // After clicking accept -> delete myRequestedRideItems[index!] and remove from firebase also
        myRequestedRideItems[index!].driverRequestedRef?.removeValue()
        myRequestedRideItems.remove(at: index!)
        // Reload the table
        notificationsTableView.reloadData()
        
    }
    
    // Deny Button is pressed
    func denyButtonPressed(sender: UIButton!){
        let buttonPosition:CGPoint = sender.convert(CGPoint.init(x:0, y:0), to: self.notificationsTableView)
        indexPath = self.notificationsTableView.indexPathForRow(at: buttonPosition)
        index = self.notificationsTableView.indexPathForRow(at: buttonPosition)?.row
        isDenied = true
        
        let requestInfo = ["requester": myRequestedRideItems[index!].requesterName, "requesterEmail": myRequestedRideItems[index!].requesterEmail, "driverName": myRequestedRideItems[index!].driverName, "driverEmail":myRequestedRideItems[index!].driverEmail, "departure": myRequestedRideItems[index!].departure, "arrival": myRequestedRideItems[index!].arrival, "time": myRequestedRideItems[index!].time, "date": myRequestedRideItems[index!].date, "seatsAvailable": myRequestedRideItems[index!].seatsAvailable, "isRequested": "1", "isAccepted": "0", "isDenied": "1"] as [String : Any]
        // Requester is the child of this database
        let deniedRideRequestRef = self.deniedRideRef.child(myRequestedRideItems[index!].requesterName).childByAutoId()
        deniedRideRequestRef.setValue(requestInfo)
        
        // Driver is the child of this database
        let driverDeniedRideRequestRef = self.driverDeniedRideRef.child(myRequestedRideItems[index!].driverName).childByAutoId()
        driverDeniedRideRequestRef.setValue(requestInfo)
        
        // After clicking accept -> delete myRequestedRideItems[index!] and remove from firebase also
        myRequestedRideItems[index!].driverRequestedRef?.removeValue()
        myRequestedRideItems.remove(at: index!)
        // Reload the table
        notificationsTableView.reloadData()

    }
    
    func isSameRide(rideA: RequestInformationItem, rideB: RequestInformationItem) -> Bool {
        if rideA.arrival == rideB.arrival && rideA.departure == rideB.departure && rideA.driverName == rideB.driverName && rideA.driverEmail == rideB.driverEmail && rideA.date == rideB.date && rideA.time == rideB.time && rideA.seatsAvailable == rideB.seatsAvailable {
            return true
        } else {
            return false
        }
    }

}

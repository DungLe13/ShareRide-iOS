//
//  MessagesViewController.swift
//  ShareRide
//
//  Created by Hamza Alsarhan on 5/6/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  MESSAGE VIEW CONTROLLER (diplay the other messenger names and the trip once ride was accepted)

import UIKit
import Firebase
import FirebaseDatabase

enum Section2: Int {
    case driverSection = 0
    case requesterSection
}

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messagesTableView: UITableView!
    
    // MARK: Properties
    var channelRefHandle: FIRDatabaseHandle?
    var channels: [Channel] = []
    var channelRef = FIRDatabase.database().reference().child("channels")
    
    var requesterAcceptedRideItems = [RequestInformationItem]()
    var driverAcceptedRideItems = [RequestInformationItem]()
    let acceptedRideRef = FIRDatabase.database().reference(withPath: "accepted-rides")
    let driverAcceptedRideRef = FIRDatabase.database().reference(withPath: "driver-accepted-rides")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    
    var currentUserName = ""
    var otherSenderName = ""
    //var currentSection: Section2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeChannels()
        
        // Get current username
        let currentUserID = FIRAuth.auth()?.currentUser?.uid
        self.usersRef.child(currentUserID!).observe(.value, with: { (snapshot) in
            
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            self.currentUserName = "\(firstName) \(lastName)"
            print("the current user is \(self.currentUserName)")
        })

        // At the requester phone
        self.usersRef.child(currentUserID!).observe(.value, with: { (snapshot) in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            let currentUserName = "\(firstName) \(lastName)"
            
            self.acceptedRideRef.child(currentUserName).observe(.value, with: { snapshot in
                var newRequesterAcceptedRideItems = [RequestInformationItem]()
                //self.currentSection = Section2.requesterSection
                
                for item in snapshot.children {
                    let acceptedItem = RequestInformationItem(snapshot: item as! FIRDataSnapshot)
                    newRequesterAcceptedRideItems.append(acceptedItem)
                }
            
                self.requesterAcceptedRideItems = newRequesterAcceptedRideItems
                print("Requester Accepted Rides are \(self.requesterAcceptedRideItems)")
                self.messagesTableView.reloadData()
            })
            
        })
        
        // At the driver phone
        self.usersRef.child(currentUserID!).observe(.value, with: { (snapshot) in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            let currentUserName = "\(firstName) \(lastName)"
            
            self.driverAcceptedRideRef.child(currentUserName).observe(.value, with: { snapshot in
                var newDriverAcceptedRideItems = [RequestInformationItem]()
                //self.currentSection = Section2.driverSection
                
                for item in snapshot.children {
                    let acceptedItem = RequestInformationItem(snapshot: item as! FIRDataSnapshot)
                    //print("the accepted Item is \(acceptedItem)")
                    newDriverAcceptedRideItems.append(acceptedItem)
                }
                
                self.driverAcceptedRideItems = newDriverAcceptedRideItems
                print("Driver Accepted Rides are \(self.driverAcceptedRideItems)")
                self.messagesTableView.reloadData()
            })
            
        })
        
    }

    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Observe the channel and append to appropriate array
    private func observeChannels() {
        channelRefHandle = channelRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let channelItem = Channel(snapshot: item as! FIRDataSnapshot)
                print("the channel Item is \(channelItem)")
                self.channels.append(channelItem)
            }
        })
        print("the channel Ref Handle is \(channelRefHandle!)")
    }

    // MARK: UITableViewDelegate and UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let currentSection: Section2 = Section2(rawValue: section) {
            switch currentSection {
            case .driverSection:
                return driverAcceptedRideItems.count
            case .requesterSection:
                return requesterAcceptedRideItems.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentSection: Section2 = Section2(rawValue: indexPath.section)!
            if (currentSection == Section2.driverSection) {
                let chatItem = channels[indexPath.row]
                driverAcceptedRideItems.remove(at: indexPath.row)
                messagesTableView.deleteRows(at: [indexPath], with: .automatic)
                chatItem.channelRef?.removeValue()
            } else {
                let chatItem = channels[indexPath.row]
                requesterAcceptedRideItems.remove(at: indexPath.row)
                messagesTableView.deleteRows(at: [indexPath], with: .automatic)
                chatItem.channelRef?.removeValue()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection: Section2 = Section2(rawValue: indexPath.section)!
        let currentUserID = FIRAuth.auth()?.currentUser?.uid
        
        switch currentSection {
        case Section2.driverSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "driverMessageCell", for: indexPath) as! MessagesTableViewCell
            let driverRideInfoItem: RequestInformationItem
            driverRideInfoItem = driverAcceptedRideItems[indexPath.row]
            
            self.usersRef.child(currentUserID!).observe(.value, with: { (snapshot) in
                let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
                let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
                let currentUserName = "\(firstName) \(lastName)"
                if currentUserName == driverRideInfoItem.driverName {
                    cell.nameLabel.text! = driverRideInfoItem.requesterName
                    cell.tripLabel.text! = "\(driverRideInfoItem.departure) - \(driverRideInfoItem.arrival)"
                    cell.smallArrowLabel.text! = ">"
                    self.otherSenderName = cell.nameLabel.text!
                }
                
            })
            return cell
            
        case Section2.requesterSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "requesterMessageCell", for: indexPath) as! MessagesTableViewCell
            let requesterRideInfoItem: RequestInformationItem
            requesterRideInfoItem = requesterAcceptedRideItems[indexPath.row]
            
            self.usersRef.child(currentUserID!).observe(.value, with: { (snapshot) in
                let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
                let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
                let currentUserName = "\(firstName) \(lastName)"
                
                if currentUserName == requesterRideInfoItem.requesterName {
                    cell.nameLabel.text! = requesterRideInfoItem.driverName
                    cell.tripLabel.text! = "\(requesterRideInfoItem.departure) - \(requesterRideInfoItem.arrival)"
                    cell.smallArrowLabel.text! = ">"
                    self.otherSenderName = cell.nameLabel.text!
                }
                
            })
            return cell
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexValue = (messagesTableView.indexPathForSelectedRow?.row)!
        let chatVC = segue.destination as! ChatViewController
        
        chatVC.otherSenderName = otherSenderName
        chatVC.senderDisplayName = currentUserName
        chatVC.channel = self.channels[indexValue]

        chatVC.channelRef = self.channelRef.child(self.channels[indexValue].id)
        print("Iiiiiiihrgtgfdffsfsfs \(self.channelRef.child(self.channels[indexValue].id))")

    }

}

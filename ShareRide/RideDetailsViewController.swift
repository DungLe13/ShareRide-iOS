//
//  RideDetailsViewController.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/19/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  THIS IS RIDE DETAILS OF SELECTED RIDE (can be accessed form List Of Rides TableView) + Request button

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RideDetailsViewController: UIViewController {

    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seatsAvailLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverEmailLabel: UILabel!
    
    @IBOutlet weak var requestButton: UIButton!
    
    // MARK: Properties
    let ref = FIRDatabase.database().reference(withPath: "list-of-rides")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    let requestedRef = FIRDatabase.database().reference(withPath: "my-requested-rides")
    let driverRequestedRef = FIRDatabase.database().reference(withPath: "driver-requested-rides")
    var selectedItem = [RideInformationItem]()
    var indexSelected: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestButton.backgroundColor = .clear
        requestButton.layer.cornerRadius = 5
        requestButton.layer.borderWidth = 1
        requestButton.layer.borderColor = UIColor.black.cgColor

        // Do any additional setup after loading the view.
        departureLabel.text = selectedItem[self.indexSelected].departure
        arrivalLabel.text = selectedItem[self.indexSelected].arrival
        timeLabel.text = selectedItem[self.indexSelected].time
        dateLabel.text = selectedItem[self.indexSelected].date
        seatsAvailLabel.text = String(selectedItem[self.indexSelected].seatsAvailable)
        driverNameLabel.text = selectedItem[self.indexSelected].driverName
        driverEmailLabel.text = selectedItem[self.indexSelected].driverEmail
        
    }
    
    // change the Request button into Request Sent label
    override func viewWillAppear(_ animated: Bool) {
        let currentUserID = FIRAuth.auth()?.currentUser?.uid
        self.usersRef.child(currentUserID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            let currentUserName = "\(firstName) \(lastName)"
            
            // deactivate the request button for this request
            self.requestedRef.child(currentUserName).observe(.value, with: { snapshot in
                for item in snapshot.children {
                    let rideInfoItem = RequestInformationItem(snapshot: item as! FIRDataSnapshot)
                    if rideInfoItem.isRequested == 1 && rideInfoItem.arrival == self.arrivalLabel.text! && rideInfoItem.departure == self.departureLabel.text! && rideInfoItem.driverName == self.driverNameLabel.text! && rideInfoItem.driverEmail == self.driverEmailLabel.text! && rideInfoItem.date == self.dateLabel.text! && rideInfoItem.time == self.timeLabel.text! && String(rideInfoItem.seatsAvailable) == self.seatsAvailLabel.text! {
                        self.requestButton.isEnabled = false
                        self.requestButton.setTitle("Request Sent!", for: .normal)
                    }
                }
                
            })
            
        })
    }
    
    
    @IBAction func requestAction(_ sender: Any) {
        // create my-ride-requests database in Firebase
        let currentUserID = FIRAuth.auth()?.currentUser?.uid
        let currentUserEmail = FIRAuth.auth()?.currentUser?.email
        var currentUserName = ""
        self.usersRef.child(currentUserID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            currentUserName = "\(firstName) \(lastName)"
            
            let requestInfo = ["requester": currentUserName, "requesterEmail": currentUserEmail!, "driverName": self.driverNameLabel.text!, "driverEmail": self.driverEmailLabel.text!, "departure": self.departureLabel.text!, "arrival": self.arrivalLabel.text!, "time": self.timeLabel.text!, "date": self.dateLabel.text!, "seatsAvailable": self.seatsAvailLabel.text!, "isRequested": "1", "isAccepted": "0", "isDenied": "0"] as [String : Any]
            print("it issssssssssss \(requestInfo)")
            // Requester is the child of this database
            let myRideRequestRef = self.requestedRef.child(currentUserName).childByAutoId()
            myRideRequestRef.setValue(requestInfo)
            // Driver is the child of this database
            let driverRideRequestRef = self.driverRequestedRef.child(self.driverNameLabel.text!).childByAutoId()
            driverRideRequestRef.setValue(requestInfo)
        })
        
        //Tells the user that there is an error and then gets firebase to tell them the error
        let alertController = UIAlertController(title: "Ride Request Sent", message: "You have successully sent a ride request! \n Thank you", preferredStyle: .alert)
        
        let requestAnotherRideAction = UIAlertAction(title: "Request Another Ride", style: .default, handler: {action in self.performSegue(withIdentifier: "requestAnotherRideSegue", sender: self)})
        let goToActivityAction = UIAlertAction(title: "Go to Rides", style: .default, handler: {action in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainTabController")
            self.present(vc!, animated: true, completion: nil)
        })
        
        alertController.addAction(requestAnotherRideAction)
        alertController.addAction(goToActivityAction)
        
        self.present(alertController, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

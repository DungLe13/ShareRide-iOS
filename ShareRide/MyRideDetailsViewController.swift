//
//  MyRideDetailsViewController.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/26/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  THIS IS THE DETAIL OF RIDES that the current user posted and requested (access through ACTIVITIES TABLEVIEW)

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MyRideDetailsViewController: UIViewController {
    
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seatsAvailLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverEmailLabel: UILabel!
    
    // MARK: Properties
    let ref = FIRDatabase.database().reference(withPath: "list-of-rides")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    let requestedRef = FIRDatabase.database().reference(withPath: "my-requested-rides")
    var selectedPostItem = [RideInformationItem]()
    var selectedRequestItem = [RequestInformationItem]()
    var indexSelected: Int!
    var sectionSelected: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show the details of selected ride
        if sectionSelected == 0 {
            departureLabel.text = selectedPostItem[self.indexSelected].departure
            arrivalLabel.text = selectedPostItem[self.indexSelected].arrival
            timeLabel.text = selectedPostItem[self.indexSelected].time
            dateLabel.text = selectedPostItem[self.indexSelected].date
            seatsAvailLabel.text = String(selectedPostItem[self.indexSelected].seatsAvailable)
            driverNameLabel.text = selectedPostItem[self.indexSelected].driverName
            driverEmailLabel.text = selectedPostItem[self.indexSelected].driverEmail
        } else {
            departureLabel.text = selectedRequestItem[self.indexSelected].departure
            arrivalLabel.text = selectedRequestItem[self.indexSelected].arrival
            timeLabel.text = selectedRequestItem[self.indexSelected].time
            dateLabel.text = selectedRequestItem[self.indexSelected].date
            seatsAvailLabel.text = String(selectedRequestItem[self.indexSelected].seatsAvailable)
            driverNameLabel.text = selectedRequestItem[self.indexSelected].driverName
            driverEmailLabel.text = selectedRequestItem[self.indexSelected].driverEmail
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "backButtonSegue"){
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "mainTabController") as! MainTabBarViewController
            destination.selectedIndex = 2
            
            print("it isssssssssssss")
            print(destination.selectedIndex)
            print("heereeeeeeeeeeeeeee")
            //performSegue(withIdentifier: "backButtonSegue", sender: self)
        }
    }

}

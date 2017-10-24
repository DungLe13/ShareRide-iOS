//
//  RidesViewController.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/19/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  THIS IS THE RIDES TABBAR with two images Available Rides and Post a Ride

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RidesViewController: UIViewController {

    @IBOutlet weak var availableRidesImage: UIImageView!
    @IBOutlet weak var postRideImage: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    // MARK: Properties
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(RidesViewController.image1Tapped(gesture:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(RidesViewController.image2Tapped(gesture:)))
        
        // add it to the image view;
        availableRidesImage.addGestureRecognizer(tapGesture1)
        postRideImage.addGestureRecognizer(tapGesture2)
        // make sure imageView can be interacted with by user
        availableRidesImage.isUserInteractionEnabled = true
        postRideImage.isUserInteractionEnabled = true
        
        // Display the current user name
        let currentUserID = FIRAuth.auth()?.currentUser?.uid
        self.usersRef.child(currentUserID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            self.greetingLabel.text = "Hello \(firstName) \(lastName)!"
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // list of available rides clicked
    func image1Tapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            //Initiate your new ViewController
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "availableRides")
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    // post ride image clicked
    func image2Tapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            //Initiate your new ViewController
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "postARide")
            self.present(vc!, animated: true, completion: nil)
        }
    }

}

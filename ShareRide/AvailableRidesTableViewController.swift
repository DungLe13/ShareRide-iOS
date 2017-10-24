//
//  AvailableRidesTableViewController.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/19/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  THIS IS A TABELVIEW THAT SHOWS ALL AVAILABLE RIDES POSTED BY USERS

import UIKit
import FirebaseDatabase

class AvailableRidesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: Properties
    var rideItems = [RideInformationItem]()
    let ref = FIRDatabase.database().reference(withPath: "list-of-rides")
    var selectedItemIndex: Int = 0
    var indexValueToPass: Int = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredRides = [RideInformationItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Seach Bar code
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar

        // Retrieve the data from Firebase and display it to the tableView
        ref.observe(.value, with: { snapshot in
            var newItems: [RideInformationItem] = []
            
            for item in snapshot.children {
                let rideItem = RideInformationItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(rideItem)
                
                if rideItem.seatsAvailable == 0 {
                    rideItem.ref?.removeValue()
                }
            }
            
            self.rideItems = newItems
            self.tableView.reloadData()
        })
    }
    
    // Helper functions for searchBar
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredRides = rideItems.filter { ride in
            let searchArrival = ride.arrival.lowercased().contains(searchText.lowercased())
            let searchDeparture = ride.departure.lowercased().contains(searchText.lowercased())
            if searchArrival {
                return searchArrival
            } else {
                return searchDeparture
            }
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView Delegate and Data Source methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredRides.count
        }
        return rideItems.count
    }

    // choosing the table view cell pressed
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedItemIndex = indexPath.row
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rideDetailsSegue" {
            indexValueToPass = (self.tableView.indexPathForSelectedRow?.row)!
            let controller = segue.destination as! RideDetailsViewController
            if searchController.isActive && searchController.searchBar.text != nil {
                controller.selectedItem = filteredRides
            } else {
                controller.selectedItem = rideItems
            }
            controller.indexSelected = indexValueToPass
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "availableRideCell", for: indexPath) as! AvailableRidesCell
        let rideInfoItem: RideInformationItem
        if searchController.isActive && searchController.searchBar.text != "" {
            rideInfoItem = filteredRides[indexPath.row]
        } else {
            rideInfoItem = rideItems[indexPath.row]
        }

        cell.destinationLabel.text = rideInfoItem.departure + " to " + rideInfoItem.arrival
        cell.dateTimeLabel.text = rideInfoItem.date + " - " + rideInfoItem.time
        cell.seatsAvailLabel.text = String(rideInfoItem.seatsAvailable) + " seats avail"

        return cell
    }
    
    
    @IBAction func availableRidesBackAction(_ sender: Any) {
        performSegue(withIdentifier: "availableRidesBackSegue", sender: nil)
    }

}

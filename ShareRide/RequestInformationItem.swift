//
//  RequestInformationItem.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/26/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct RequestInformationItem {
    
    let ref: FIRDatabaseReference?
    let requestedRef: FIRDatabaseReference?
    let driverRequestedRef: FIRDatabaseReference?
    let key: String
    
    let departure: String
    let arrival: String
    let date: String
    let time: String
    let seatsAvailable: Int
    
    let driverName: String
    let driverEmail: String
    
    let requesterName: String
    let requesterEmail: String
    let isRequested: Int
    let isAccepted: Int
    let isDenied: Int
    
    init(departure: String, arrival: String, date: String, time: String, key: String = "", driverName: String, driverEmail: String, requesterName: String, requesterEmail: String, seatsAvailable: Int, isRequested: Int, isAccepted: Int, isDenied: Int) {
        self.key = key
        self.driverName = driverName
        self.driverEmail = driverEmail
        self.departure = departure
        self.arrival = arrival
        self.date = date
        self.time = time
        self.seatsAvailable = seatsAvailable
        self.requesterName = requesterName
        self.requesterEmail = requesterEmail
        self.isRequested = isRequested
        self.isAccepted = isAccepted
        self.isDenied = isDenied
        self.ref = nil
        self.requestedRef = nil
        self.driverRequestedRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        driverName = snapshotValue["driverName"] as! String
        driverEmail = snapshotValue["driverEmail"] as! String
        departure = snapshotValue["departure"] as! String
        arrival = snapshotValue["arrival"] as! String
        date = snapshotValue["date"] as! String
        time = snapshotValue["time"] as! String
        seatsAvailable = (snapshotValue["seatsAvailable"]?.intValue)!
        requesterName = snapshotValue["requester"] as! String
        requesterEmail = snapshotValue["requesterEmail"] as! String
        isRequested = (snapshotValue["isRequested"]?.intValue)!
        isAccepted = (snapshotValue["isAccepted"]?.intValue)!
        isDenied = (snapshotValue["isDenied"]?.intValue)!
        ref = snapshot.ref
        requestedRef = snapshot.ref
        driverRequestedRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "requester": requesterName,
            "requesterEmail": requesterEmail,
            "driverName": driverName,
            "driverEmail": driverEmail,
            "departure": departure,
            "arrival": arrival,
            "date": date,
            "time": time,
            "seatsAvailable": seatsAvailable,
            "isRequested": isRequested,
            "isAccepted": isAccepted,
            "isDenied": isDenied
        ]
    }
}

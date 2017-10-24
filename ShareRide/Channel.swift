//
//  Channel.swift
//  ShareRide
//
//  Created by Hamza Alsarhan on 5/8/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Channel {
    let id: String
    let name: String
    let channelRef: FIRDatabaseReference?
    
    init(id: String = "", name: String) {
        self.id = id
        self.name = name
        self.channelRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshot.key
        name = snapshotValue["name"] as! String
        channelRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
}

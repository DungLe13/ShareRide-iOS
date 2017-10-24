//
//  NotificationsTableViewCell.swift
//  ShareRide
//
//  Created by Hamza Alsarhan on 4/30/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  CELL CONFIGURATION FOR NOTIFICATION TABLEVIEW

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var acceptDenyLabel: UILabel!
    
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    
    @IBOutlet weak var acceptedLabel: UILabel!
    @IBOutlet weak var deniedLabel: UILabel!
    
    
    var myAcceptedRideItems = [RequestInformationItem]()
    var myDeniedRideItems = [RequestInformationItem]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

//
//  AvailableRidesCell.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/19/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  THIS IS THE CELL FIGURATION FOR AVAILABLE RIDES TABLEVIEW

import UIKit

class AvailableRidesCell: UITableViewCell {

    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var seatsAvailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

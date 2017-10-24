//
//  ActivitiesTableViewCell.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/24/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  CELL CONFIGURATION for ACTIVITIES TABLEVIEW

import UIKit

class ActivitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var smallArrowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

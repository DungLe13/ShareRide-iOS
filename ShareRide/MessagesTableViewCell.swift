//
//  MessagesTableViewCell.swift
//  ShareRide
//
//  Created by Hamza Alsarhan on 5/8/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  CELL CONFIGURATION for MESSAGE VIEW CONTROLLER

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tripLabel: UILabel!
    
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

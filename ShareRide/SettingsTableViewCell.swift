//
//  SettingsTableViewCell.swift
//  ShareRide
//
//  Created by Hamza Alsarhan on 4/24/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  CELL CONFIGURATION FOR SETTINGS TABLEVIEW

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

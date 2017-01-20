//
//  TimeSlotTableViewCell.swift
//  DelyBazar
//
//  Created by OSX on 06/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class TimeSlotTableViewCell: UITableViewCell {
    @IBOutlet weak var btnSelect: UIButton!

    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

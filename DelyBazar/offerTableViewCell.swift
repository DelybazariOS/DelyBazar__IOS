//
//  offerTableViewCell.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class offerTableViewCell: UITableViewCell {

    @IBOutlet weak var OOff: UILabel!
    @IBOutlet weak var OName: UILabel!
    @IBOutlet weak var OImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

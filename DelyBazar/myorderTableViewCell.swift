//
//  myorderTableViewCell.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class myorderTableViewCell: UITableViewCell {

    @IBOutlet weak var RTime: UILabel!
    @IBOutlet weak var DDate: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var noItems: UILabel!
    @IBOutlet weak var OrderTime: UILabel!
    @IBOutlet weak var OrderId: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

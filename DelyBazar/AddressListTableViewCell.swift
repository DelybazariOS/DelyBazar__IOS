//
//  AddressListTableViewCell.swift
//  DelyBazar
//
//  Created by OSX on 06/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {
    @IBOutlet weak var address: UILabel!

    @IBOutlet weak var btnDeleteAdd: UIButton!
    @IBOutlet weak var AddressCount: UILabel!
    @IBOutlet weak var btnChangeAddress: UIButton!
    @IBOutlet weak var btnRadio: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

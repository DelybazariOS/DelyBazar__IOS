//
//  BannerTableViewCell.swift
//  DelyBazar
//
//  Created by OSX on 17/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    @IBOutlet weak var OneBanner: UIView!

    @IBOutlet weak var imageBg: UIImageView!
    @IBOutlet weak var btn_OneBanner: UIButton!
    @IBOutlet weak var btnTwo_TwoBanner: UIButton!
    @IBOutlet weak var btnOne_TwoBanner: UIButton!
    @IBOutlet weak var TwoBanner: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

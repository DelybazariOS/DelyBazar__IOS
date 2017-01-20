//
//  BundelTableViewCell.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class BundelTableViewCell: UITableViewCell {
    @IBOutlet weak var BName: UILabel!
    @IBOutlet weak var BCost: UILabel!

    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var BtnViewProduct: UIButton!
    @IBOutlet weak var BItems: UILabel!
    @IBOutlet weak var BImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        BtnViewProduct.layer.cornerRadius = 8
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

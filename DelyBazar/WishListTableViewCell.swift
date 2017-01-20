//
//  WishListTableViewCell.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var PImage: UIImageView!
    @IBOutlet weak var IName: UILabel!
    @IBOutlet weak var PWeight: UILabel!
    @IBOutlet weak var PCost: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnSub.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1).cgColor
        btnSub.layer.borderWidth = 1
        btnSub.layer.cornerRadius = btnSub.frame.size.height/2
        btnAdd.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1).cgColor
        btnAdd.layer.borderWidth = 1
        btnAdd.layer.cornerRadius = btnSub.frame.size.height/2
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  CategoryTableViewCell.swift
//  DelyBazar
//
//  Created by OSX on 05/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

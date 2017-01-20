//
//  VegetableTableViewCell.swift
//  DelyBazar
//
//  Created by OSX on 23/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class VegetableTableViewCell: UITableViewCell {
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var btnFav: UIButton!

    @IBOutlet weak var lblOutOfStock: UILabel!
    @IBOutlet weak var btnSelectedButton: UIButton!
    @IBOutlet weak var BtnDelete: UIButton!
    @IBOutlet weak var vIMage: UIImageView!
    @IBOutlet weak var btnQuantity: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var Number: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
         btnSub.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1).cgColor
        btnSub.layer.borderWidth = 1
        btnSub.layer.cornerRadius = btnSub.frame.size.height/2
        btnAdd.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1).cgColor
        btnAdd.layer.borderWidth = 1
        btnAdd.layer.cornerRadius = btnSub.frame.size.height/2
        btnQuantity.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1).cgColor
        btnQuantity.layer.borderWidth = 1
        btnQuantity.layer.cornerRadius = 16
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func Sub(_ sender: Any) {
        
//        let str = Number.text
//
//        var i = Int(str!)
//        
//        if i != 0 {
//            i = i! - 1
//
//        }
//        
//        
//        Number.text = String(describing: i!)
//        
//        
        
        
    }
    
    @IBOutlet weak var Sub: UIButton!
    @IBAction func Add(_ sender: Any) {
//        let str = Number.text
//        
//        var i = Int(str!)
//        
//    
//            i = i! + 1
//            
//        
//        
//        
//        Number.text = String(describing: i!)
//        

    }
}

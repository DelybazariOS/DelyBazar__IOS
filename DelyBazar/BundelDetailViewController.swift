//
//  BundelDetailViewController.swift
//  DelyBazar
//
//  Created by OSX on 08/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class BundelDetailViewController: UIViewController {

    
    
    
    
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var btnSub: UIButton!
    
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var btnCartBottom: UIButton!
    @IBOutlet weak var btnQuantity: UIButton!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var ViewTitle: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblProductDetail: UITextView!
    @IBOutlet weak var lblStockStatus: UILabel!
    @IBOutlet weak var viewCount: UIView!
    @IBOutlet weak var QuantityTableView: UITableView!
    @IBOutlet weak var BundelTableView: UITableView!
    @IBOutlet weak var C_Bundel_TableView_H: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        C_Bundel_TableView_H.constant = 0
    }
    
    
    @IBAction func Continue(_ sender: Any) {
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cartBottom(_ sender: Any) {
    }
    @IBAction func Search(_ sender: Any) {
    }
    @IBOutlet weak var Cart: UIButton!
    @IBAction func Cart(_ sender: Any) {
    }
    @IBAction func LikeUnLike(_ sender: Any) {
    }
    @IBAction func Add(_ sender: Any) {
    }
    @IBOutlet weak var Add: UIButton!
    @IBAction func Sub(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SuccessViewController.swift
//  DelyBazar
//
//  Created by OSX on 15/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    var Msg : String = ""
    
    @IBOutlet weak var btnMyOrdet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       txtMsg.text = Msg
        
  
        btnMyOrdet.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MyOrder(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderViewController") as! MyOrderViewController
        
        
        
        self.present(vc, animated: true, completion: nil)
        
    }

    @IBOutlet weak var txtMsg: UILabel!
    @IBAction func back(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        self.present(vc, animated: true, completion: nil)
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

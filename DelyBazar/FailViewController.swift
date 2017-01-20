//
//  FailViewController.swift
//  DelyBazar
//
//  Created by OSX on 16/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class FailViewController: UIViewController {

    var Msg : String = ""

    
    @IBOutlet weak var failMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        failMessage.text = Msg

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        
        
        
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func CallUS(_ sender: Any) {
        
        if (UIApplication.shared.canOpenURL(NSURL(string: "tel://03368888007")! as URL)) {
            
            
            
            
            UIApplication.shared.open(NSURL(string: "tel://03368888007" )! as URL)
            
            
            
            
        }

    }
    @IBAction func MyOrders(_ sender: Any) {
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

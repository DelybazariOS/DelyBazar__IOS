//
//  HelpViewController.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var txtHelp: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtHelp.text = "\n1. delybazar.com provides ‘no question asked refund and replacement policy’ within 24hrs after delivery.\n\n2. delybazar.com is liable to alter the products in case of wrong delivery or defective products.\n\n3. Customer must check out the products when it will be delivered & he can return the wrong products during the time of delivery.\n\n5.In case few products are return back by the customer during the time of deliver, the price of returned product will be deducted from the invoice in delivery time.\n\n6. In case of online payment price of returned product will be transferred in customer’s account within 3-4 business days.\n\n7. In case of replacement or refund customer have to return back the previous product to get the new product as replacement or money as refund…\n\n8. In order to ask for refund/replacement please call us on 03368888007 or mail us on orders@delybazar.com."
        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var back: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

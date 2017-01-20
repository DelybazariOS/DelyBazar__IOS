//
//  AboutUsViewController.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var txtAboutUs: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        txtAboutUs.text = "\nOnline Delybazar Internet Retail Market Private Limited (delybazar.com) is an online retail shop of Kolkata that aims to provide the best quality products of daily needs of every family such as grocery, vegetables, fruits, fish, meat etc. etc… It has been founded by six reputed engineers from different prestigious institutes of our country.\n\nDelybazar.com accept orders online and over phone also.\n\nDelybazar.com deliver the ordered product within few hours (maximum 24 hours).\n\nOur creativity - \nIn 2017 life has become very fast with heavy schedule for almost every working people in a metropolitan city. Thus maximum people would not get enough time to shop their daily needs. So we are trying to make their life much easier by providing the best quality products in reasonable price at their doorstep.\n\nAll the products starting from vegetables to fish & meat delivered by us are absolutely fresh   (not frozen) as we never store any product & we bring it directly from the firms on the day of delivery as per the order.\n\nThanking you \n\nDelybazar.com\n\nBazar at your door"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

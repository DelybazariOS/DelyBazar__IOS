//
//  MyWalletViewController.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MyWalletViewController: UIViewController , NVActivityIndicatorViewable {

    @IBOutlet weak var viewUnderButton: UIView!
    @IBOutlet weak var btnTransaction: UIButton!
    @IBOutlet weak var btnWallet: UIButton!
    
    var activityIndicatorView : NVActivityIndicatorView?

    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewUnderButton.frame = CGRect.init(x: 0, y: 56, width: self.view.frame.size.width/2, height: 4)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    @IBAction func ActionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func ActionWalletBalence(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [ .curveLinear], animations: {

         self.viewUnderButton.frame = CGRect.init(x: 0, y: 56, width: self.view.frame.size.width/2, height: 4)
        },  completion: { (true) in
            
            
        })

    }
    @IBAction func ActionTransaction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [ .curveLinear], animations: {

         self.viewUnderButton.frame = CGRect.init(x: self.view.frame.size.width/2, y: 56, width: self.view.frame.size.width/2, height: 4)
    },  completion: { (true) in
    
    
    })
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

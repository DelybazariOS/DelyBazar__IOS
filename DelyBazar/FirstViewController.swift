//
//  FirstViewController.swift
//  DelyBazar
//
//  Created by OSX on 16/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FirstViewController: UIViewController , NVActivityIndicatorViewable{

    
    
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var activityIndicatorView : NVActivityIndicatorView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.startAnimating(CGSize(width: 50, height:50), message: "Getting Data", type: NVActivityIndicatorType.ballZigZagDeflect)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let str = UserDefaults.standard.value(forKey: "id") as? String
        
        if str != nil {
            
//            self.GetBanner()

            self.stopAnimating()
//
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "KYDrawerController") as! KYDrawerController
            self.present(nextViewController, animated:false, completion:nil)
            
        }
        else{
            self.stopAnimating()

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(nextViewController, animated:false, completion:nil)
            
            
            
            
            
        }

    }
    
    
        func ShowAlertOK(sender : NSString)  {
            
            let alert = UIAlertController(title: "Alert", message: sender as String, preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }

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

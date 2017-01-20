//
//  EditEmailViewController.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class EditEmailViewController: UIViewController , NVActivityIndicatorViewable{

    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    var dataModel = DataModel()
    var DataCollection : NSDictionary?

    var activityIndicatorView : NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
     btnSave.layer.cornerRadius = 4
        
        let email1 = UserDefaults.standard.string(forKey: "email")
        let mobile_no = UserDefaults.standard.string(forKey: "mobile_no")
        
        
        email.text = email1!
        userName.text = mobile_no!
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func Save(_ sender: Any) {
//        let email1 = UserDefaults.standard.string(forKey: "email")
//        let mobile_no = UserDefaults.standard.string(forKey: "mobile_no")

        if email.text?.characters.count == 0 && !(email.text?.contains("@"))!{
            ShowAlertOK(sender: "Enter valid email")
        }
        else if userName.text?.characters.count != 10 {
            ShowAlertOK(sender: "Enter valid mobile number")
            
        }
        else{
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            
            let url = "apiEditProfile.php"
         
            let dict = [
                "customer_id" : UserDefaults.standard.value(forKey: "id")! ,
                "mobile_no" : userName.text!,
                "email" : email.text!
                
                //
                
            ]
//            customer_id:8286
//            mobile_no:9638518000
//            email:viswanath.ravi@gmail.com

            
            
            self.dataModel.GetApi(Url: url as String as NSString, dict: dict as NSDictionary){ (data) in
                
                
                self.stopAnimating()
                
                
                if data.1 as String == "FAILURE"{
                    self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                    
                }
                else{
                    self.DataCollection = data.0
                    
                    
                    if self.DataCollection?.value(forKey: "status") as! String == "success"{
                        
                        
                        
                    }
                    else if self.DataCollection?.value(forKey: "status") as! String == "Added Successfully"{
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    else{
                        self.ShowAlertOK(sender: self.DataCollection?.value(forKey: "status")  as! NSString)
//                        self.dismiss(animated: true, completion: nil)
                        
                        
                    }
                }
            }
        }
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func ShowAlertOK(sender : NSString)  {
        
        let alert = UIAlertController(title: "Alert", message: sender as String, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }

}

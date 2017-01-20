//
//  ForgotPasswordViewController.swift
//  DelyBazar
//
//  Created by OSX on 14/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ForgotPasswordViewController: UIViewController,NVActivityIndicatorViewable  , UIGestureRecognizerDelegate {

    @IBOutlet weak var txtConPwd: UITextField!
    @IBOutlet weak var txtEnternewPwd: UITextField!
    @IBOutlet weak var viewChangePw: UIView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var C_Phone_St: NSLayoutConstraint!
   
    @IBOutlet weak var C_Con_NewPDW: NSLayoutConstraint!
    @IBOutlet weak var C_Con_PWD_H: NSLayoutConstraint!
    @IBOutlet weak var C_Chage_Button: NSLayoutConstraint!
    @IBOutlet weak var C_NewPWDView_H: NSLayoutConstraint!
    @IBOutlet weak var C_Button_H: NSLayoutConstraint!
    @IBOutlet weak var C_Phone_H: NSLayoutConstraint!
    @IBOutlet weak var btnCancelActopn: UIButton!
    
    
    var UserID : String!
    var OTPString : NSNumber!
    var ViewFrom : String! = ""

    
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var activityIndicatorView : NVActivityIndicatorView?
    var tap = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()

        txtPhone.attributedPlaceholder = NSAttributedString(string:"Enter Your Mobile Number",
                                                        attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        
        txtEnternewPwd.attributedPlaceholder = NSAttributedString(string:"Enter New Password",
                                                            attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        txtConPwd.attributedPlaceholder = NSAttributedString(string:"Confirm Password",
                                                            attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        
        txtConPwd.layer.borderColor = UIColor.black.cgColor
        txtEnternewPwd.layer.borderColor = UIColor.black.cgColor
        
        txtConPwd.layer.borderWidth = 1
        txtEnternewPwd.layer.borderWidth = 1

        btnCancel.layer.cornerRadius = 8
        btnSubmit.layer.cornerRadius = 8
        btnSave.layer.cornerRadius = 8
        btnCancelActopn.layer.cornerRadius = 8

        viewChangePw.layer.cornerRadius = 8

        
        // Do any additional setup after loading the view.
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTapRate))
        //        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        self.viewBg.isHidden = true
        self.viewChangePw.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var c_FPhone_H: NSLayoutConstraint!
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "otpmatched")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if OTPString != nil {
            
            if UserDefaults.standard.bool(forKey: "otpmatched") == true{
            
            self.viewBg.isHidden = false
            self.viewChangePw.isHidden = false
            }
        }
        
      
        
        
        if UIDevice.current.model .hasPrefix("iPad")
        {
            print("iPad")
            
            C_Phone_H.constant = 70
            C_Button_H.constant = 70
            C_Con_PWD_H.constant = 70
            C_Chage_Button.constant = 70
            C_NewPWDView_H.constant = 400
            C_Chage_Button.constant = 70
            C_Phone_St.constant = 100
            c_FPhone_H.constant = 100
            C_Con_NewPDW.constant = 70
        }
        else{
            print("iPhone")
            
        }
    }

    func handleTapRate(panGesture: UITapGestureRecognizer) {
        
        txtPhone.endEditing(true)
       
        txtEnternewPwd.endEditing(true)
        txtConPwd.endEditing(true)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var Cancel: UIButton!
    @IBAction func Submit(_ sender: Any) {
        
        if txtPhone.text?.characters.count != 10 {
            self.ShowAlertOK(sender: "Enter your mobile number")
        }
            
        else{
            
            
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            
            let url = "apiSendOtp.php"
            
            
            //            name
            //            mobile_no
            //            password
            //            login_type            ()
            
            
            
            let dict = [
                "mobile_no" : txtPhone.text!
                
                
            ]
            
            print(dict)

            
            self.dataModel.GetApi(Url: url as String as NSString, dict: dict as NSDictionary){ (data) in
                
                
                self.stopAnimating()
                
                
                if data.1 as String == "FAILURE"{
                    self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                    
                }
                else{
                    self.DataCollection = data.0
                    
                    print(self.DataCollection!)
                    
                    if self.DataCollection?.value(forKey: "status") as! String == "success"{
                        
                    

                        self.UserID = self.DataCollection?.value(forKey: "id") as! String
                        self.OTPString = self.DataCollection?.value(forKey: "otp") as! NSNumber

                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                        vc.OtpString = self.DataCollection?.value(forKey: "otp") as! NSNumber
                        
                        vc.MobileNo = self.txtPhone.text!
                        vc.UserID = self.DataCollection?.value(forKey: "id") as! String
                        
                        self.present(vc, animated: true, completion: nil)
                        
                        
                        
                    }
                    else if self.DataCollection?.value(forKey: "status") as! String == "Mobile No is Incorrect"{
                        
                        self.ShowAlertOK(sender: "Mobile No is Incorrect")
                        
                    }
                    else{
                        self.ShowAlertOK(sender: self.DataCollection?.value(forKey: "status")  as! NSString)
                        
                        
                    }
                }
            }
            
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

    @IBAction func CancelPWDView(_ sender: Any) {
        
        self.viewBg.isHidden = true
        self.viewChangePw.isHidden = true

        
    }
    @IBOutlet weak var CancelPWD: UIButton!
    @IBAction func SaveNewPwd(_ sender: Any) {
        
        if (txtEnternewPwd.text?.characters.count)! < 6 {
            self.ShowAlertOK(sender: "Enter atlest 6 characters in password")
        }
        else if txtEnternewPwd.text! != txtConPwd.text! {
             self.ShowAlertOK(sender: "Password not match")
        }
        else{
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            
            let url = "apiChangePassword.php"
            
            
//            id
//            mobile_no
//            password
            
            let dict = [
                "mobile_no" : "\(txtPhone.text!)" ,
                "id" : UserID! ,
                "password" : txtEnternewPwd.text!
                
            ]
            
            print(dict)
            
            self.dataModel.GetApi(Url: url as String as NSString, dict: dict as NSDictionary){ (data) in
                
                
                self.stopAnimating()
                
                
                if data.1 as String == "FAILURE"{
                    self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                    
                }
                else{
                    self.DataCollection = data.0
                    
                    print(self.DataCollection!)
                    
                    if self.DataCollection?.value(forKey: "status") as! String == "Password Changed Successfully"{
                        
                        self.viewBg.isHidden = true
                        self.viewChangePw.isHidden = true
                        
                        let str = UserDefaults.standard.value(forKey: "id") as? String
                        
                        if str != nil {
                        
                        UserDefaults.standard.set(nil, forKey: "id")
                        UserDefaults.standard.set(nil, forKey: "name")
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "mobile_no")
                        UserDefaults.standard.synchronize()
                        }
                       let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if self.DataCollection?.value(forKey: "status") as! String == "Mobile No is Incorrect"{
                        
                        self.ShowAlertOK(sender: "Mobile No is Incorrect")
                        
                    }
                    else{
                        self.ShowAlertOK(sender: self.DataCollection?.value(forKey: "status")  as! NSString)
                        
                        
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

}

//
//  OTPViewController.swift
//  DelyBazar
//
//  Created by OSX on 14/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class OTPViewController: UIViewController, UITextFieldDelegate , NVActivityIndicatorViewable  , UIGestureRecognizerDelegate {

    @IBOutlet weak var otp6: UITextField!
    @IBOutlet weak var otp5: UITextField!
    @IBOutlet weak var otp4: UITextField!
    @IBOutlet weak var otp3: UITextField!
    @IBOutlet weak var otp2: UITextField!
    @IBOutlet weak var otp1: UITextField!
    @IBOutlet weak var txtOtp: UITextField!
    @IBOutlet weak var btnVerify: UIButton!
    
    @IBOutlet weak var C_Verify_H: NSLayoutConstraint!
    var OtpString : NSNumber!
    var MobileNo : String!
    var UserID : String! = ""

    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var activityIndicatorView : NVActivityIndicatorView?
    var tap = UITapGestureRecognizer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        otp1.attributedPlaceholder = NSAttributedString(string:"-",
                                                            attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        otp2.attributedPlaceholder = NSAttributedString(string:"-",
                                                        attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        otp3.attributedPlaceholder = NSAttributedString(string:"-",
                                                        attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        otp4.attributedPlaceholder = NSAttributedString(string:"-",
                                                        attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        otp5.attributedPlaceholder = NSAttributedString(string:"-",
                                                        attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        otp6.attributedPlaceholder = NSAttributedString(string:"-",
                                                        attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        otp1.becomeFirstResponder()

        
        btnVerify.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTapRate))
        //        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    func handleTapRate(panGesture: UITapGestureRecognizer) {
        
        otp1.endEditing(true)
        otp2.endEditing(true)
        otp3.endEditing(true)
        otp4.endEditing(true)
        otp5.endEditing(true)
        otp6.endEditing(true)

        
    }
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.model .hasPrefix("iPad")
        {
            print("iPad")
        
            C_Verify_H.constant = 70
            
            
        }
        else{
            print("iPhone")
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resendOTP(_ sender: Any) {
        
        
        
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        
        let url = "apiSendOtp.php"
      
        
        //            name
        //            mobile_no
        //            password
        //            login_type            ()
        

        let dict = [
                        "mobile_no" : "\(MobileNo!)" ,
            
            
            ]
        
        
        
        self.dataModel.GetApi(Url: url as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            self.stopAnimating()
            
            
            if data.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                let data = data.0
                
                print(self.DataCollection!)
                
                if self.DataCollection?.value(forKey: "status") as! String == "success"{
                    
                    self.otp1.text = ""
                    self.otp2.text = ""
                    self.otp3.text = ""
                    self.otp4.text = ""
                    self.otp5.text = ""
                    self.otp6.text = ""

                    self.OtpString = data.value(forKey: "otp") as! NSNumber
                    
                    
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

    @IBAction func DonotReceive(_ sender: Any) {
//        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
//        
//        let url = "apiSendOtp.php"
//        
//        
//        //            name
//        //            mobile_no
//        //            password
//        //            login_type            ()
//        
//        
//        let dict = [
//            "mobile_no" : "\(MobileNo!)" ,
//            
//            
//        ]
//        
//        
//        
//        self.dataModel.GetApi(Url: url as String as NSString, dict: dict as NSDictionary){ (data) in
//            
//            
//            self.stopAnimating()
//            
//            
//            if data.1 as String == "FAILURE"{
//                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
//                
//            }
//            else{
//                self.DataCollection = data.0
//                
//                print(self.DataCollection)
//                
//                if self.DataCollection?.value(forKey: "status") as! String == "success"{
//                    
//                    self.otp1.text = ""
//                    self.otp2.text = ""
//                    self.otp3.text = ""
//                    self.otp4.text = ""
//                    self.otp5.text = ""
//                    self.otp6.text = ""
//                    
//                    self.OtpString = self.DataCollection?.value(forKey: "otp") as! NSNumber
//
//                    
//                }
//                else if self.DataCollection?.value(forKey: "status") as! String == "Mobile No is Incorrect"{
//                    
//                    self.ShowAlertOK(sender: "Mobile No is Incorrect")
//                    
//                }
//                else{
//                    self.ShowAlertOK(sender: self.DataCollection?.value(forKey: "status")  as! NSString)
//                    
//                    
//                }
//            }
//        }

    }
    @IBAction func ActionVerify(_ sender: Any) {
        
      
            if otp1.text?.characters.count == 0 {
                self.ShowAlertOK(sender: "Fill OTP")
            }
       
        else if otp2.text?.characters.count == 0 {
                self.ShowAlertOK(sender: "Fill OTP")

            }
        
        else  if otp3.text?.characters.count == 0 {
                self.ShowAlertOK(sender: "Fill OTP")

            
        }else if otp4.text?.characters.count == 0 {
                self.ShowAlertOK(sender: "Fill OTP")

            
        }else if otp5.text?.characters.count == 0 {
                self.ShowAlertOK(sender: "Fill OTP")

            
        }else  if otp6.text?.characters.count == 0 {
                self.ShowAlertOK(sender: "Fill OTP")

            
        }
            else{
               
                
                
                //            name
                //            mobile_no
                //            password
                //            login_type            ()
                otp1.endEditing(true)
                otp2.endEditing(true)
                otp3.endEditing(true)
                otp4.endEditing(true)
                otp5.endEditing(true)
                otp6.endEditing(true)

                let oTP = "\(otp1.text!)\(otp2.text!)\(otp3.text!)\(otp4.text!)\(otp5.text!)\(otp6.text!)" as String
                print(OtpString)
                if oTP == OtpString.stringValue {
                    
                    
                    
                    
                    
                    UserDefaults.standard.set(true, forKey: "otpmatched")
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    if UserID.characters.count == 0 {
                                           let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
                        
                        print(self.DataCollection!)
                        
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "id") as! String, forKey: "id")
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "name") as! String, forKey: "name")
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "email") as! String, forKey: "email")
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "mobile_no") as! String, forKey: "mobile_no")
                        UserDefaults.standard.synchronize()
                        self.Verified(Status: "Yes" , moblie: self.DataCollection?.value(forKey: "mobile_no") as! String)

                                            self.present(vc, animated: true, completion: nil)

                    }
                    else {
                        
                        
                        UserDefaults.standard.set(MobileNo, forKey: "mobile_no")
                          self.Verified(Status: "Yes" , moblie: MobileNo)
                    self.dismiss(animated: true, completion: nil)
                    }
                }
                else{

                    self.ShowAlertOK(sender: "OTP is not matched")
                }
                
               
        }
        
        
    }
    func Verified(Status: String , moblie: String)  {
        var Baseurl = "apiOtpVerifiedStatus.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
            "mobile_no" : moblie ,
            "verified_status" : Status
            
            //            "city_id" : "1"
        ]
        
        
        
        
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetHomeCatApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
            
            
            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0[0]
                
                
                
                
                if (dataCount as AnyObject).value(forKey: "status") as? String != nil {
//                    self.ShowAlertOK(sender: )
                    
                }
                    
                else{
                    
                    print("banner  \(dataCoun.0.count)")
                    //                    let dataCount = dataCoun.0[0]
                    
                    
                    
                    
                    
                    
                }
                
                
            }
        }
        
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == otp1 {
            if otp1.text?.characters.count == 1 {
                otp2.becomeFirstResponder()
            }
        }
        else if textField == otp2 {
            if otp2.text?.characters.count == 1 {
                otp3.becomeFirstResponder()
            }
        }
        else if textField == otp3 {
            if otp3.text?.characters.count == 1 {
                otp4.becomeFirstResponder()
            }
        }else if textField == otp4 {
            if otp4.text?.characters.count == 1 {
                otp5.becomeFirstResponder()
            }
        }else if textField == otp5 {
            if otp5.text?.characters.count == 1 {
                otp6.becomeFirstResponder()
            }
        }else if textField == otp6 {
            if otp6.text?.characters.count == 1 {
                otp6.endEditing(true)
            }
        }
        
        let  char = string.cString(using: String.Encoding.utf8)!

        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
           otp1.text = ""
            otp2.text = ""

            otp3.text = ""

            otp4.text = ""

            otp5.text = ""

            otp6.text = ""
            otp1.becomeFirstResponder()


        }
        
        return true
    }
    
    
    
    func ShowAlertOK(sender : NSString)  {
        
        let alert = UIAlertController(title: "Alert", message: sender as String, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.Verified(Status: "NO", moblie: MobileNo)

    }
}

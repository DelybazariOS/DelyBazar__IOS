//
//  UpdateAddressViewController.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UpdateAddressViewController: UIViewController , NVActivityIndicatorViewable , UITextFieldDelegate{

    @IBOutlet weak var ViewTitle: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var u_Pincode: UIView!
    @IBOutlet weak var u_City: UIView!
    @IBOutlet weak var u_LandMark: UIView!
    @IBOutlet weak var u_Area: UIView!
    @IBOutlet weak var u_HNumber: UIView!
    @IBOutlet weak var u_Snumber: UIView!
    @IBOutlet weak var u_Pnumber: UIView!
    @IBOutlet weak var u_Fname: UIView!
    @IBOutlet weak var U_Lname: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var pincode: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var LandMark: UITextField!
    @IBOutlet weak var area: UITextField!
    @IBOutlet weak var HNumver: UITextField!
    @IBOutlet weak var SNumber: UITextField!
    @IBOutlet weak var pNumber: UITextField!
    @IBOutlet weak var Lname: UITextField!
    @IBOutlet weak var Fname: UITextField!
    
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    
    var UserData : NSDictionary?

    var product_id : String! = " "
    var type : String! = ""
    var Menutype : String! = ""

    var address_id : String! = ""

    
    var activityIndicatorView : NVActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
        btnSave.layer.cornerRadius = 4
        pincode.delegate = self
        Getdata()
        let str = UserDefaults.standard.string(forKey: "mobile_no")
        
        if str?.characters.count != 0 {
            pNumber.isUserInteractionEnabled = false
            pNumber.text = str
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Menutype == "menu" {
            
        }
        
        
        
        
        if type == "add"
        {
            ViewTitle.text = "Add Address"
            btnAdd.isHidden = true
            
            
            
            
            
            
        }
        else {
            ViewTitle.text = "Update Address"
            btnAdd.isHidden = false
            
            
            print(UserData!)
            
            Fname.text = UserData?.value(forKey: "first_name") as? String
            Lname.text = UserData?.value(forKey: "last_name") as? String
            HNumver.text = UserData?.value(forKey: "shipping_address") as? String
            LandMark.text = UserData?.value(forKey: "shipping_landmark") as? String
            city.text = UserData?.value(forKey: "city_name") as? String
            pincode.text = UserData?.value(forKey: "shipping_pincode") as? String
            if pNumber.text?.characters.count == 0 {
                pNumber.isUserInteractionEnabled = true
            }
            
        }    }
    
    
    func Getdata()  {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionButtonSave(_ sender: Any) {
       
        
        if Fname.text?.characters.count == 0 {
            u_Fname.backgroundColor = UIColor.red
            
        }
        
        else {
            u_Fname.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        }
        
          if Lname.text?.characters.count == 0 {
            U_Lname.backgroundColor = UIColor.red

        }
          else {
            U_Lname.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        }
          if pNumber.text?.characters.count == 0 {
            u_Pnumber.backgroundColor = UIColor.red

        }
          else {
            u_Pnumber.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        }
        
          if HNumver.text?.characters.count == 0 {
            u_HNumber.backgroundColor = UIColor.red

          } else {
            u_HNumber.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        }
            if city.text?.characters.count == 0 {
            u_City.backgroundColor = UIColor.red

          } else {
            u_City.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        }
          if pincode.text?.characters.count == 0 {
            u_Pincode.backgroundColor = UIColor.red

          } else {
            u_Pincode.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        }
        
        
        if Fname.text?.characters.count == 0 {
            ShowAlertOK(sender: "First Name is required.")
        }
        else  if Lname.text?.characters.count == 0 {
            ShowAlertOK(sender: "Last Name is required.")
        }
        else  if pNumber.text?.characters.count == 0 {
            ShowAlertOK(sender: "Primary Mobile Number is required.")
        }
      
        else  if HNumver.text?.characters.count == 0 {
            ShowAlertOK(sender: "House Number & Detail is required.")
        }
     
        else  if city.text?.characters.count == 0 {
            ShowAlertOK(sender: "City is required.")
        }
        else  if pincode.text?.characters.count == 0 {
            ShowAlertOK(sender: "Pincode is required.")
        }
        else{
            
            
                self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
                
                let url = "apiPincodeCheck.php"
                
                let dict = [
                    "pincode" : pincode.text
                ]
                
                
                self.dataModel.GetApi(Url: url as String as NSString, dict: dict as NSDictionary){ (data) in
                    
                    
                    self.stopAnimating()
                    
                    
                    if data.1 as String == "FAILURE"{
                        self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                        
                    }
                    else{
                        self.DataCollection = data.0
                        
                        //                    print(self.DataCollection)
                        
                        if self.DataCollection?.value(forKey: "status") as! String == "Pincode is not available"{
                            self.ShowAlertOK(sender: self.DataCollection?.value(forKey: "status")  as! NSString)
                            
                            
                           
                            
                            
                        }
                        else if self.DataCollection?.value(forKey: "status") as! String == "Pincode is available"{
                            
                          self.updateAddress()
                        
                            
                        }
                        else{
                            self.ShowAlertOK(sender: self.DataCollection?.value(forKey: "status")  as! NSString)
                            
                            
                        }
                    }
                }
                
            }
            
            
            
            


        
        
        
    }
    
    
    func updateAddress()  {
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        
        let url = "apiAddEditAddress.php"
        //            customer_id:1
        //            city_id:1
        //            first_name:Viswanath
        //            last_name:R
        //            shipping_email:viswanath.ravi@ymail.com
        //            shipping_mobile:7348822236
        //            shipping_address:XXXXX
        //            shipping_landmark:Diamond  Plazael
        //            shipping_pincode:700055
        //            address_id:  (if “type : add”  means address_id is blank / If “type :edit” means address_id need to pass )
        //            type:   (add/edit)
        
        let dict = [
            "customer_id" : UserDefaults.standard.value(forKey: "id")! ,
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "first_name" : Fname.text! ,
            "last_name" : Lname.text! ,
            "shipping_email" : UserDefaults.standard.value(forKey: "email")! ,
            "shipping_mobile" : pNumber.text! ,
            
            "shipping_address" : "\(HNumver.text!)" ,
            "secondary_mobile" : "\(SNumber.text!)" ,

            "shipping_landmark" : LandMark.text! ,
            "shipping_pincode" : pincode.text! ,
            
            "address_id" : address_id ,
            "type" : type ,
            
            
            //
            
        ]
        
        
        
        self.dataModel.GetApi(Url: url as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            self.stopAnimating()
            
            
            if data.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                self.DataCollection = data.0
                
                print(self.DataCollection)
                
                if self.DataCollection?.value(forKey: "status") as! String == "success"{
                    
                    
                    
                }
                else if self.DataCollection?.value(forKey: "status") as! String == "Added Successfully"{
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                else{
                    self.ShowAlertOK(sender: self.DataCollection?.value(forKey: "status")  as! NSString)
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }
            }
        }
    }
    @IBAction func ActionBackButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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

    @IBAction func ActionAddAddress(_ sender: Any) {
        
        
        type = "add"
        
        
        if type == "add"
        {
            ViewTitle.text = "Add Address"
            btnAdd.isHidden = true
            Fname.text = ""
            Lname.text = ""
            pNumber.text = ""
            HNumver.text = ""
            LandMark.text = ""
            city.text = ""
            
            pincode.text = ""
            

        }
        else {
            ViewTitle.text = "Update Address"
            btnAdd.isHidden = false

            
        }
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (pincode.text?.characters.count)! >= 6 {
            
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 6
        }
        return true
    }

}

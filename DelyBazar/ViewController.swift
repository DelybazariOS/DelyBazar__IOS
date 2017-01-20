//
//  ViewController.swift
//  DelyBazar
//
//  Created by OSX on 14/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class ViewController: UIViewController , NVActivityIndicatorViewable  , UIGestureRecognizerDelegate , UITextFieldDelegate{

    @IBOutlet weak var C_Pin_Str_W: NSLayoutConstraint!
    @IBOutlet weak var C_Sumbit_H: NSLayoutConstraint!
    @IBOutlet weak var C_Pin_H: NSLayoutConstraint!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var txtPinCode: UITextField!
    @IBOutlet weak var lblLocation: UILabel!
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var activityIndicatorView : NVActivityIndicatorView?
    
    
    var ViewFrom : String? = ""
    
    
    var tap = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSubmit.layer.cornerRadius = 8

        txtPinCode.delegate = self
        
        txtPinCode.attributedPlaceholder = NSAttributedString(string:"Pincode",
                                                               attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTapRate))
        //        tap.delegate = self
        self.view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view, typically from a nib.
    }
    func handleTapRate(panGesture: UITapGestureRecognizer) {
        
        txtPinCode.endEditing(true)
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.txtPinCode.isUserInteractionEnabled = true

        
        if UIDevice.current.model .hasPrefix("iPad")
        {
            print("iPad")
            C_Pin_H.constant = 70
            C_Sumbit_H.constant = 70
            C_Pin_Str_W.constant = 90
        }
        else{
            print("iPhone")

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ActionSubmit(_ sender: Any) {
        
        if btnSubmit.title(for: UIControlState.normal) == "Shop Now" {
            
            if ViewFrom == "Home" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
                
                self.present(vc, animated: true, completion: nil)
                
            }
            else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            self.present(vc, animated: true, completion: nil)
            }
        }
        else {
        
        
        if txtPinCode.text?.characters.count != 6 {
            self.ShowAlertOK(sender: "Enter 6-digit pin code")
        }
        else{
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            
            let url = "apiPincodeCheck.php"
            
            let dict = [
                "pincode" : txtPinCode.text
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
                        
                        self.txtPinCode.text = ""

                        
                        self.ShowAlertVisitOK(sender: "Sorry we are not availabel in your area.")
                        
                        
                    }
                        else if self.DataCollection?.value(forKey: "status") as! String == "Pincode is available"{
                        
                        self.lblLocation.isHidden = false
                        self.lblTime.isHidden = true
                        self.lblLocation.text = "Namaskar \(self.DataCollection?.value(forKey: "city_name") as! String )! We deliver to \(self.txtPinCode.text!)"
                        self.txtPinCode.isUserInteractionEnabled = false
                        self.btnSubmit.setTitle("Shop Now", for: UIControlState.normal)
                        
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "city_id") as! String, forKey: "city_id")
                        UserDefaults.standard.set(self.txtPinCode.text, forKey: "city_pin")
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "city_name") as! String, forKey: "city_name")
                        UserDefaults.standard.synchronize()
                        
                        
                    }
                    else{
                        self.ShowAlertOK(sender: self.DataCollection?.value(forKey: "status")  as! NSString)
                        self.txtPinCode.text = ""

                        
                    }
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
    func ShowAlertVisitOK(sender : NSString)  {
        
        let alert = UIAlertController(title: "Alert", message: sender as String, preferredStyle: UIAlertControllerStyle.alert)
        let retryAction = UIAlertAction(title:  "Try another pincode", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            
        }
        alert.addAction(retryAction)
        let cancelAction = UIAlertAction(title:  "Visit the app", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if self.ViewFrom == "Home" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
                
                self.present(vc, animated: true, completion: nil)
                
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                
                self.present(vc, animated: true, completion: nil)
            }

        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBAction func SkipButton(_ sender: Any) {
        
        
        if ViewFrom == "Home" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
            
            
            
            self.present(vc, animated: true, completion: nil)

        }
        else{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            UserDefaults.standard.set("1", forKey: "city_id")
            UserDefaults.standard.set("700001", forKey: "city_pin")
            UserDefaults.standard.set("", forKey: "city_name")
            UserDefaults.standard.synchronize()
        self.present(vc, animated: true, completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (txtPinCode.text?.characters.count)! >= 6 {
            
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


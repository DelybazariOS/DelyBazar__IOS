//
//  LoginViewController.swift
//  DelyBazar
//
//  Created by OSX on 14/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, NVActivityIndicatorViewable  , UIGestureRecognizerDelegate , GIDSignInUIDelegate , UITextFieldDelegate{

    @IBOutlet weak var C_Login_H: NSLayoutConstraint!
    @IBOutlet weak var C_Login_But: NSLayoutConstraint!
    @IBOutlet weak var C_PWD_St: NSLayoutConstraint!
    @IBOutlet weak var C_Email_St: NSLayoutConstraint!
    @IBOutlet weak var C_PWD_H: NSLayoutConstraint!
    @IBOutlet weak var C_Email_H: NSLayoutConstraint!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var activityIndicatorView : NVActivityIndicatorView?
    var tap = UITapGestureRecognizer()

    var ShowPasswordOn : Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.attributedPlaceholder = NSAttributedString(string:"Email/Mobile",
                                                              attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",
                                                              attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTapRate))
        //        tap.delegate = self
//        self.view.addGestureRecognizer(tap)
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.CheckLogin), name: NSNotification.Name.FBSDKAccessTokenDidChange, object: nil)
        btnLogin.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.model .hasPrefix("iPad")
        {
            print("iPad")
        C_Email_H.constant = 70
            C_PWD_H.constant = 70
            C_Login_H.constant = 70
            C_Login_But.constant = 70
            C_Email_St.constant = 100
            C_PWD_St.constant = 100
        
        }
        else{
            print("iPhone")
            
        }
    }

    func CheckLogin()  {
        self.FbLogin()
        
    }
    func GoogleSignIn()  {
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        
    }
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        self.stopAnimating()
        
    }
    private func signIn(signIn: GIDSignIn!,
                        presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    private func signIn(signIn: GIDSignIn!,
                        dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func handleTapRate(panGesture: UITapGestureRecognizer) {
        
        txtPassword.endEditing(true)
        txtEmail.endEditing(true)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionForgotPassword(_ sender: Any) {
      
        
              
    }

    @IBAction func ActionLogin(_ sender: Any) {
        
        
        if txtEmail.text?.characters.count == 0 {
            self.ShowAlertOK(sender: "Enter your Email/Mobile number")
        }
       
        else  if (txtPassword.text?.characters.count)! < 6 {
            self.ShowAlertOK(sender: "Enter atlest 6 characters in password")
        }
        else{
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            
            let url = "apiLogin.php"
            txtPassword.endEditing(true)
            txtEmail.endEditing(true)

//            email_mobile
//            password
//            login_type    (normal)
            
            var device = ""
            
            if (UserDefaults.standard.string(forKey: "deviceToken") != nil) {

            
            
           device =  (UserDefaults.standard.value(forKey: "deviceToken")! as? String)!
            
            }
            
            else{
                device = "NoDevice"
            }
            
            
    let dict = [
                "email_mobile" : "\(txtEmail.text!)" ,
                "password" : "\(txtPassword.text!)" ,
                "login_type" : "normal" ,
                "device_token" : device,
                 "device_type" : "IOS"
//
        
        ]
//            device_token
//            device_type    (android / IOS)

            print(dict)
            
            
            self.dataModel.GetApi(Url: url as String as NSString, dict: dict as NSDictionary){ (data) in
                
                
                self.stopAnimating()
                
                
                if data.1 as String == "failure"{
                    self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                    
                }
                else{
                    self.DataCollection = data.0
                    
                    print(self.DataCollection!)
                    
                    if self.DataCollection?.value(forKey: "status") as! String == "success"{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
                        
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "id") as! String, forKey: "id")
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "name") as! String, forKey: "name")
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "email") as! String, forKey: "email")
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "mobile_no") as! String, forKey: "mobile_no")
                        UserDefaults.standard.synchronize()
                        
                        self.present(vc, animated: true, completion: nil)
                        
                        
                    }
                    else if self.DataCollection?.value(forKey: "status") as! String == "failure"{
                        
                        self.ShowAlertOK(sender: "Email/Mobile number or password is wrong")
                        
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

    @IBAction func TermsAndConditions(_ sender: Any) {
    }
    @IBAction func ShowPassword(_ sender: Any) {
        
        if ShowPasswordOn == false
        {
        txtPassword.isSecureTextEntry = false
            
            ShowPasswordOn = true
            
        }
        else{
            txtPassword.isSecureTextEntry = true
            ShowPasswordOn = false

        }
        
    }
    
    func FbLogin()  {
        //        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        //        self.view.addSubview(loginView)
        //        loginView.center = self.view.center
        
        btnFacebook.readPermissions = ["public_profile", "email"]
        //        btnFacebookLogin.delegate = self
  self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        // If we have an access token, then let's display some info
        
        if (FBSDKAccessToken.current() != nil)
        {
            // Display current FB premissions
            print (FBSDKAccessToken.current().permissions)
            
            // Since we already logged in we can display the user datea and taggable friend data.
            self.showUserData()
        }
        else{
            self.showUserData()

            
            self.stopAnimating()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
    }
    func showUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, gender, first_name, last_name, locale, email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
                self.stopAnimating()

                self.ShowAlertOK(sender: "Did not able to login")
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
            }
            else
            {
                
                let userName = result as! NSDictionary
                print("User Name is: \(userName)")
                self.stopAnimating()

                
                
                if userName.value(forKey: "email") == nil {
                
                
                _ =  self.SocalSignUp(social_id: userName.value(forKey: "id") as! String, Name: userName.value(forKey: "name") as! String, email: "", login_type: "facebook" ){_ in
                    
                }
                }
                else{
                    _ =  self.SocalSignUp(social_id: userName.value(forKey: "id") as! String, Name: userName.value(forKey: "name") as! String, email: userName.value(forKey: "email") as! String, login_type: "facebook" ){_ in
                        
                    }

                }
                //
                //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                //                self.present(vc , animated: true, completion: nil)
                
                
                //                if let userEmail : NSString = result.valueForKey("email") as? NSString {
                //                    print("User Email is: \(userEmail)")
                //                }
                
                
                
            }
        })
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addGestureRecognizer(tap)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.removeGestureRecognizer(tap)
        
    }
    func SocalSignUp( social_id : String , Name : String , email: String , login_type : String , withCompletionHandler:@escaping (_ result: String ) -> Void) -> Bool {
        
        var IsTrue = false
        
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        
        let url = "apiLogin.php"
        
        
        
        //        social_id
        //        Name
        //        email
        //        login_type            (facebook / googleplus)
        
        var device = ""
        
        if (UserDefaults.standard.string(forKey: "deviceToken") != nil) {
            
            
            
            device =  (UserDefaults.standard.value(forKey: "deviceToken")! as? String)!
            
        }
            
        else{
            device = "NoDevice"
        }
        

        let dict = [
            "social_id" : social_id ,
            "name" : Name ,
            "email" : email ,
            "login_type" : login_type ,
            "device_token" : device,
            "device_type" : "IOS"

            
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
                    if login_type == "facebook"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "id") as! String, forKey: "id")
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "name") as! String, forKey: "name")
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "email") as! String, forKey: "email")
                        UserDefaults.standard.set(self.DataCollection?.value(forKey: "mobile_no") as! String, forKey: "mobile_no")
                        UserDefaults.standard.synchronize()

                        
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                        
                    else{
                    }
                    
                    IsTrue = true
                    
                    withCompletionHandler("True")
                }
                else if self.DataCollection?.value(forKey: "status") as! String == "failure"{
                    
                    self.ShowAlertOK(sender: "Unable to signup. Try again ")
                    IsTrue = false
                    withCompletionHandler("False")
                    
                    
                }
                else{
                    self.ShowAlertOK(sender: self.DataCollection?.value(forKey: "status")  as! NSString)
                    
                    IsTrue = false
                    withCompletionHandler("False")
                    
                }
            }
        }
        
        
        return IsTrue
    }

    
    @IBAction func GoogleLogin(_ sender: Any) {
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        
        //        [[GIDSignIn sharedInstance] signIn]
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func Google(_ sender: Any) {
       

    }
    @IBAction func Facebook(_ sender: Any) {
        
      

        btnFacebook.sendActions(for: .allEvents)

    }
    @IBAction func SignUp(_ sender: Any) {
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

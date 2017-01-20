//
//  AppDelegate.swift
//  DelyBazar
//
//  Created by OSX on 14/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import GLKit
import Google.Core
import Google.SignIn
import NVActivityIndicatorView
import UserNotifications
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  , GIDSignInDelegate ,UNUserNotificationCenterDelegate, NVActivityIndicatorViewable{

    var window: UIWindow?
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var activityIndicatorView : NVActivityIndicatorView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "KYDrawerController") as! KYDrawerController
//        self.present(nextViewController, animated:true, completion:nil)

        
        IQKeyboardManager.sharedManager().enable = true

        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                
            }
        } else {
            
            
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            let pushNotificationSettings = UIUserNotificationSettings.init(types: notificationTypes, categories: nil)
            
            application.registerUserNotificationSettings(pushNotificationSettings)
            
            // Fallback on earlier versions
        }
        application.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
        UserDefaults.standard.synchronize()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
                
                switch setttings.soundSetting{
                case .enabled:
                    
                    print("enabled sound setting")
                    
                case .disabled:
                    
                    print("setting has been disabled")
                    
                case .notSupported:
                    print("something vital went wrong here")
                }
            }
        } else {
            // Fallback on earlier versions
            
            
        }
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url as URL!,
                                                                   sourceApplication:  sourceApplication,
                                                                   annotation: annotation)
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return googleDidHandle || facebookDidHandle
//        return googleDidHandle
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if (error == nil) {
            // Perform any operations on signed in user here.
                        let userId = user.userID                  // For client-side use only!
                     //   let idToken = user.authentication.idToken // Safe to send to the server
                        let fullName = user.profile.name
//                        let givenName = user.profile.givenName
//                        let familyName = user.profile.familyName
                        let email = user.profile.email
            
            
            // ...
            
            
            
            let sVC = SignUpViewController()
            _ =  sVC.SocalSignUp(social_id: userId!, Name: fullName!, email: email!, login_type: "googleplus"){ (data) in
                
                if data == "True"{
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
                    
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
            }
            }
           
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
//    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
//                withError error: NSError!) {
//        if (error == nil) {
//            // Perform any operations on signed in user here.
////            let userId = user.userID                  // For client-side use only!
////            let idToken = user.authentication.idToken // Safe to send to the server
////            let fullName = user.profile.name
////            let givenName = user.profile.givenName
////            let familyName = user.profile.familyName
////            let email = user.profile.email
//            // ...
//        } else {
//            print("\(error.localizedDescription)")
//        }
//    }
     public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
    }
   
//    func SocalSignUp( social_id : String , Name : String , email: String , login_type : String)  {
//        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
//        
//        let url = "apiLogin.php"
//              
//        //        social_id
//        //        Name
//        //        email
//        //        login_type            (facebook / googleplus)
//        
//        
//        let dict = [
//            "social_id" : social_id ,
//            "Name" : Name ,
//            "email" : email ,
//            "login_type" : login_type ,
//            
//            
//            ]
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
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                    
//                    self.present(vc, animated: true, completion: nil)
//                    
//                    
//                }
//                else if self.DataCollection?.value(forKey: "status") as! String == "failure"{
//                    
//                    self.ShowAlertOK(sender: "Unable to signup. Try again ")
//                    
//                }
//                else{
//                    self.ShowAlertOK(sender: self.DataCollection?.value(forKey: "status")  as! NSString)
//                    
//                    
//                }
//            }
//        }
//        
//    }
//    
//    func ShowAlertOK(sender : NSString)  {
//        
//        let alert = UIAlertController(title: "Alert", message: sender as String, preferredStyle: UIAlertControllerStyle.alert)
//        let cancelAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.cancel) {
//            UIAlertAction in
//        }
//        alert.addAction(cancelAction)
//        self.present(alert, animated: true, completion: nil)
//        
//    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


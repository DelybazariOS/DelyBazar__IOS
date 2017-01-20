//
//  MenuViewController.swift
//  HVMAPP
//
//  Created by OSX on 20/09/16.
//  Copyright © 2016 Jaipreet. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FBSDKCoreKit
import FBSDKLoginKit


class MenuViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , NVActivityIndicatorViewable {

    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var MyAccountTableview: UITableView!
    @IBOutlet weak var catTableView: UITableView!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var c_Table_H: NSLayoutConstraint!
    @IBOutlet weak var C_Acc_View_H: NSLayoutConstraint!
    @IBOutlet weak var C_L_View_H: NSLayoutConstraint!
    
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var activityIndicatorView : NVActivityIndicatorView?

    
    var isCatOpen : Bool = false
    var isMyAccOpen : Bool = false

//    var ArrMyAccount : NSMutableArray = [ "My order" , "Refund/Replacement" , "Change Password" , "Edit Mobile Number/Email" , "Rate Our App" , "My Watchlist" ]
//    var ArrMyAccountImage : NSMutableArray = [ #imageLiteral(resourceName: "truck") , #imageLiteral(resourceName: "refund") , #imageLiteral(resourceName: "lock") , #imageLiteral(resourceName: "edit")  , #imageLiteral(resourceName: "star") , #imageLiteral(resourceName: "heart") ]
    var ArrMyAccount : NSMutableArray = [ "My order"  , "Change Password" , "Edit Mobile Number/Email" , "Rate Our App" , "My Watchlist" ]
    var ArrMyAccountImage : NSMutableArray = [ #imageLiteral(resourceName: "truck")  , #imageLiteral(resourceName: "lock") , #imageLiteral(resourceName: "edit")  , #imageLiteral(resourceName: "star") , #imageLiteral(resourceName: "heart") ]
    
    var ArrRecentName : NSMutableArray = [ ]

    @IBOutlet weak var c_bundel_H: NSLayoutConstraint!
    @IBOutlet weak var c_offers_H: NSLayoutConstraint!
    @IBOutlet weak var viewBundel: UIView!
    @IBOutlet weak var viewOffers: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.isNavigationBarHidden = true
        
        
        UserImage.layer.cornerRadius = 40
        UserImage.layer.borderWidth = 2
        UserImage.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor
        UserImage.layer.masksToBounds = true
        
        c_bundel_H.constant = 0
        c_offers_H.constant = 0
        
        viewBundel.isHidden = true
        viewOffers.isHidden = true
        
        let str = UserDefaults.standard.string(forKey: "name")
        
        if str != nil{
        
        lblname.text = "Hi,\(UserDefaults.standard.string(forKey: "name")! )"
        }
        else{
            lblname.text = "Hi "

        }
        if (UserDefaults.standard.string(forKey: "city_id") == nil) {
        }
        else
        {
        self.GetCatData()
        }
        // Do any additional setup after loading the view.
    }
    func GetCatData()  {
//        http://delybazar.in/mobile-app/apiSubCategory.php
        
//        let city_id =
        
        
        if (UserDefaults.standard.string(forKey: "city_id") == nil) {
            
        }
        else
        {
        
        
        var Baseurl = "apiCategory.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
                                    "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            
//            "city_id" : "1"
        ]
        
        
        
        
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetCatApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            self.stopAnimating()
            
            
            if data.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataBanner = data.0[0]
                
                
                
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String != nil {
                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    
                    print("banner  \(data.0.count)")
                    
                    for i in 0...data.0.count - 1 {
                        self.ArrRecentName.add(data.0[i])
                    }
                    self.catTableView.reloadData()
                    
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

    override func viewWillAppear(_ animated: Bool) {

        c_Table_H.constant = 0
        C_Acc_View_H.constant = 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == MyAccountTableview {
            return ArrMyAccount.count
        }
        else {
            return ArrRecentName.count

        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        if tableView == MyAccountTableview {
            
            cell.textLabel?.text = "\(self.ArrMyAccount[indexPath.row] as! String)"
            
            cell.imageView?.image = ArrMyAccountImage[indexPath.row] as? UIImage
            
        }
        else {
           
            let data = ArrRecentName[indexPath.row]

            
            cell.textLabel?.text = "       \((data as AnyObject).value(forKey: "category_name") as! String)"

        }

        
       

        
        
        
        return cell
    }
    
    func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                    
                })
            }
        }
        
        // Run task
        task.resume()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == MyAccountTableview {
            
            if indexPath.row == 0 {
                let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyOrderViewController") as! MyOrderViewController
                self.present(nextViewController, animated:true, completion:nil)
                //                        self.navigationController?.pushViewController(vc, animated: true)
                
                parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)
                
            }
//            else if indexPath.row == 1 {
//                let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RefundViewController") as! RefundViewController
//                self.present(nextViewController, animated:true, completion:nil)
//                //                        self.navigationController?.pushViewController(vc, animated: true)
//                
//                parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)
//            }
            else if indexPath.row == 1 {
                let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                self.present(nextViewController, animated:true, completion:nil)
                //                        self.navigationController?.pushViewController(vc, animated: true)
                
                parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)

            }
            else if indexPath.row == 2 {
                let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditEmailViewController") as! EditEmailViewController
                self.present(nextViewController, animated:true, completion:nil)
                //                        self.navigationController?.pushViewController(vc, animated: true)
                
                parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)

            }
//            else if indexPath.row == 4 {
//                let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
//                self.present(nextViewController, animated:true, completion:nil)
//                //                        self.navigationController?.pushViewController(vc, animated: true)
//                
//                parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)
//                
//            }
            else if indexPath.row == 3 {
       
                
                if (UIApplication.shared.canOpenURL(NSURL(string : "itms-apps://itunes.apple.com/app/id959379869")! as URL)) {
                    
                    
                    
                    
                    UIApplication.shared.open(NSURL(string : "itms-apps://itunes.apple.com/app/id959379869")! as URL)
                    
                    
                    
                    
                }
                


            }
            else if indexPath.row == 4 {
                let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
                self.present(nextViewController, animated:true, completion:nil)
                //                        self.navigationController?.pushViewController(vc, animated: true)
                
                parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)

            }
            
        }
        else {
            
            let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
            let data = ArrRecentName[indexPath.row]
//
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubCatViewController") as! SubCatViewController
//            nextViewController.category_id = (data as AnyObject).value(forKey: "category_id") as! String
//            nextViewController.CatName = (data as AnyObject).value(forKey: "category_name") as! String
//            
//        nextViewController.View_From = "MENU"
////            self.navigationController?.pushViewController(nextViewController, animated: true)
//
//            self.present(nextViewController, animated:true, completion:nil)
////            self.navigationController?.present(nextViewController, animated: true, completion: nil)
//
////                        self.navigationController?.pushViewController(nextViewController, animated: true)

            
 let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            nextViewController.HomeToCart_Is_From = "YES"
            nextViewController.HomeToCart_ID = (data as AnyObject).value(forKey: "category_id") as! String
            nextViewController.HomeToCart_Name = (data as AnyObject).value(forKey: "category_name") as! String
            
            UserDefaults.standard.set("YES", forKey: "HomeToCart_Is_From")
            UserDefaults.standard.set((data as AnyObject).value(forKey: "category_id") as! String, forKey: "HomeToCart_ID")
            UserDefaults.standard.set((data as AnyObject).value(forKey: "category_name") as! String, forKey: "HomeToCart_Name")

            
            
            
            parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)
            
            
//      _ = vc.CallViewFromLeftMenu(type: "cat", cat: "1")
            
            
//            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
 
    
    
  
    
    

    


    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func LogOut(_ sender: Any) {
    
        
        UserDefaults.standard.set(nil, forKey: "id")
        UserDefaults.standard.set(nil, forKey: "name")
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "mobile_no")
        UserDefaults.standard.set(nil, forKey: "city_pin")
        UserDefaults.standard.set(nil, forKey: "city_id")

        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        UserDefaults.standard.synchronize()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func MyAccount(_ sender: Any) {
        if isMyAccOpen == false {
            isMyAccOpen = true
            
            UIView.animate(withDuration: 1, delay: 0.0, options: [ .curveLinear], animations: {

            
            self.C_Acc_View_H.constant = CGFloat(self.ArrMyAccount.count * 40)
            
            
            if self.isCatOpen == true {
                self.C_L_View_H.constant = CGFloat(510) + CGFloat(self.ArrRecentName.count * 40) + CGFloat(self.ArrMyAccount.count * 40)
                
            }
            else{
                self.C_L_View_H.constant = CGFloat(510) + CGFloat(self.ArrMyAccount.count * 40)
                
            }
            }, completion:{  finished in
                
            })

            
        }
        else if isMyAccOpen == true {
            isMyAccOpen = false
            UIView.animate(withDuration: 1, delay: 0.0, options: [ .curveLinear], animations: {

            self.C_Acc_View_H.constant = 0
            
            if self.isCatOpen == true {
                self.C_L_View_H.constant = CGFloat(510) + CGFloat(self.ArrRecentName.count * 40)
                
            }
            else{
                self.C_L_View_H.constant = CGFloat(510)
                
            }
        }, completion:{  finished in
            
        })

        
//            C_L_View_H.constant = CGFloat(510)

        }

    }
    @IBAction func ButtonShopCat(_ sender: Any) {
    
        
        
        if isCatOpen == false {
            isCatOpen = true
            UIView.animate(withDuration: 1, delay: 0.0, options: [ .curveLinear], animations: {

            if self.isMyAccOpen == true {
                self.C_L_View_H.constant = CGFloat(510) + CGFloat(self.ArrRecentName.count * 40) + CGFloat(self.ArrMyAccount.count * 40)

            }
            else{
                self.C_L_View_H.constant = CGFloat(510) + CGFloat(self.ArrRecentName.count * 40)

            }
            
            self.c_Table_H.constant = CGFloat(self.ArrRecentName.count * 40)

        }, completion:{  finished in
            
        })

        }
        else if isCatOpen == true {
            isCatOpen = false
            UIView.animate(withDuration: 1, delay: 0.0, options: [ .curveLinear], animations: {

            self.c_Table_H.constant = 0
            if self.isMyAccOpen == true {
                self.C_L_View_H.constant = CGFloat(510) +  CGFloat(self.ArrMyAccount.count * 40)
                
            }
            else{
                self.C_L_View_H.constant = CGFloat(510)
                
            }
    }, completion:{  finished in
    
    })

        }
        
        

        
    }
    @IBAction func ActionAddress(_ sender: Any) {
        let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddresslistViewController") as! AddresslistViewController
     nextViewController.Menutype = "menu"
        self.present(nextViewController, animated:true, completion:nil)
        //                        self.navigationController?.pushViewController(vc, animated: true)
        
        parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)

    }
    @IBAction func ReferAndEarn(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        self.present(nextViewController, animated:false, completion:nil)
        
//        let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.present(nextViewController, animated:true, completion:nil)
//                                self.navigationController?.pushViewController(nextViewController, animated: true)
        
//        parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)
    }
    @IBAction func BundelPack(_ sender: Any) {
        let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BundelpackViewController") as! BundelpackViewController
        self.present(nextViewController, animated:true, completion:nil)
        //                        self.navigationController?.pushViewController(vc, animated: true)
        
        parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)
       
    }
    @IBAction func Offer(_ sender: Any) {
        let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OfferViewController") as! OfferViewController
        self.present(nextViewController, animated:true, completion:nil)
        //                        self.navigationController?.pushViewController(vc, animated: true)
        
        parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)
    }
    @IBAction func CallUs(_ sender: Any) {
//        
       
        
        if (UIApplication.shared.canOpenURL(NSURL(string: "tel://03368888007")! as URL)) {
            
            
            
            
            UIApplication.shared.open(NSURL(string: "tel://03368888007" )! as URL)
            
            
            
            
        }

        
//
    }
    @IBOutlet weak var ShareApp: UIButton!
    @IBAction func ShareApp(_ sender: Any) {
        let textToShare = "DelyBazar is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
        
        
        
        
    }
    @IBAction func HelpAndSupport(_ sender: Any) {
        let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        self.present(nextViewController, animated:true, completion:nil)
        //                        self.navigationController?.pushViewController(vc, animated: true)
        
        parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)
    }
    @IBAction func TermAndCondition(_ sender: Any) {
        let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        self.present(nextViewController, animated:true, completion:nil)
        //                        self.navigationController?.pushViewController(vc, animated: true)
        
        parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)
    }
    @IBAction func AboutUs(_ sender: Any) {
        let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
        self.present(nextViewController, animated:true, completion:nil)
        //                        self.navigationController?.pushViewController(vc, animated: true)
        
        parentVC .setDrawerState(KYDrawerController.DrawerState.closed, animated:true)
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

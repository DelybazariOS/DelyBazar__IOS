//
//  WishlistViewController.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class WishlistViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , NVActivityIndicatorViewable {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnSelectAll: UIButton!
    var activityIndicatorView : NVActivityIndicatorView?
    
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var DataWishListArr : NSMutableArray? = []
    var SelectedArr : NSMutableArray? = []
    var SelectedProductIDArr : NSMutableArray? = []

    var AllSelected : Bool = false
    var SelectedRow : Int! = 0
    
    @IBAction func SelectAllButton(_ sender: Any) {
        
        if AllSelected == false {
            AllSelected = true
            for i in 0...(DataWishListArr?.count)! - 1 {
                let data = DataWishListArr?[i] as! NSDictionary
                SelectedArr?.add((data.value(forKey: "product_id") as? String)!)
                
                let dataPriceType = data.value(forKey: "pricetype") as? NSArray
                
                
                let dataDict = dataPriceType?[0] as! NSDictionary

                
                SelectedProductIDArr?.add((dataDict.value(forKey: "product_type_id") as? String)!)

                
            }
            
            
            
            btnSelectAll.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_check_box"), for: .normal)
        }
        else {
            AllSelected = false
            SelectedArr?.removeAllObjects()
            SelectedProductIDArr?.removeAllObjects()
            
             btnSelectAll.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_check_box_outline_blank"), for: .normal)
        }
        tableView.reloadData()
        
    }
    @IBAction func ClearList(_ sender: Any) {
        
        
        if SelectedArr?.count == 0 {
        }
        else{
        
        
          self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiRemoveWishlist.php"
        
        //       city_id:1
        //        customer_id:11
        //        product_id:1
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!,
            "product_id" : (SelectedArr?.componentsJoined(by: ","))! as String,
            
            
            ]
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
            
            
            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0
                
                
                
                
                if (dataCount as AnyObject).value(forKey: "status") as? String == "Deleted Successfully" {
                    
                    
                    self.GetWatchListData("GET")
                    
                    
                    
                    
                    
                }
                    
                else{
                    //
                    //                    let dataCount = dataCoun.0[0]
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    
                    
                    
                    
                    
                    
                }
                
                
            }
            
            
            
        }
        }

    }
    @IBAction func AddtoCart(_ sender: Any) {
        
        
        if SelectedArr?.count == 0 {
        }
        else{
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiAddCart.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!,
            "product_id" : (SelectedArr?.componentsJoined(by: ","))! as String,
            "product_type_id" : (SelectedProductIDArr?.componentsJoined(by: ","))! as String,
            "product_quantity_type" : "adding",
            
            ]
        
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
            
            
            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0
                
                
                self.GetWatchListData("GET")
                
                
                if (dataCount as AnyObject).value(forKey: "status") as? String == "Updated Successfully" {
                    
                    
                    
                    
                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Product Deleted Successfully" {
                    
                    
                    
                    
                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Added Successfully" {
                    
                    
                    
                    
                    
                }
                    
                else{
                    //
                    
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    
                    
                    
                }
                
                
            }
            
            
            
            
        }
        
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        GetWatchListData("GET")
        
    }
    func GetWatchListData(_ type : String)  {
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiListingWishlist.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!
            
            //            "city_id" : "1"
        ]
        
        
        
        
        
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetHomeCatApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            self.stopAnimating()
            
            
            if data.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataBanner = data.0[0]
                
                
                
                
                //                if (dataBanner as AnyObject).value(forKey: "status") as? String != "Inactive" {
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String == "No Wishlist Products" {
                    
                    self.DataWishListArr?.removeAllObjects()

                    self.ShowAlertOK(sender: "No Wishlist Products")
                    self.tableView.reloadData()

                    
                                   }
                else{
                    //                        self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    //
                    //                    }
                    //                }
                    
                    //                else{
                    
                    //                    let dataCate = data.0[0] as! NSDictionary
                    
                    self.DataWishListArr?.removeAllObjects()
                    for i in 0...data.0.count - 1 {
                        self.DataWishListArr?.add(data.0[i])
                    }
                    
                    
                    if self.DataWishListArr?.count == 0 {
                    }
                    else{
                        
                        if type == "GET"{
                            self.stopAnimating()
                            
                            self.tableView.reloadData()
                            
                        }
                        else {
                            let indexPath = NSIndexPath.init(row: self.SelectedRow!, section: 0)
                            self.stopAnimating()
                            
                            self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
                        }                    }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionBacklist(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (DataWishListArr?.count)!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WishListTableViewCell
        
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let data = DataWishListArr?[indexPath.row] as? NSDictionary

          cell.IName.text = data?.value(forKey: "product_name") as? String
        
        let dataPriceType = data?.value(forKey: "pricetype") as? NSArray

        
        let dataDict = dataPriceType?[0] as! NSDictionary

        
        
        cell.PCost.text = "₹\((dataDict.value(forKey: "selling_price") as! String))"
        
        
        cell.PWeight.text = "\((dataDict.value(forKey: "product_weight") as! String)) \((dataDict.value(forKey: "product_unit") as! String))"
        
        cell.number.text = "\((dataDict.value(forKey: "product_quantity") as! String))"
        
        
        
        
        cell.btnDelete.addTarget(self, action: #selector(WishlistViewController.btnDelete(_:)) , for: .touchDown)
        cell.btnDelete.accessibilityLabel = data?.value(forKey: "product_id") as? String
        
        
        cell.btnCheck.addTarget(self, action: #selector(WishlistViewController.btnCheck(_:)) , for: .touchDown)
        cell.btnCheck.accessibilityLabel = data?.value(forKey: "product_id") as? String

        
        cell.btnAdd.addTarget(self, action: #selector(WishlistViewController.btnAdd(_:)) , for: .touchDown)
        cell.btnAdd.accessibilityLabel = data?.value(forKey: "product_id") as? String
        cell.btnAdd.accessibilityLanguage = dataDict.value(forKey: "product_type_id") as? String
        cell.btnAdd.tag = indexPath.row

        
        
        cell.btnSub.addTarget(self, action: #selector(WishlistViewController.btnSub(_:)) , for: .touchDown)
        cell.btnSub.accessibilityLabel = data?.value(forKey: "product_id") as? String
        cell.btnSub.accessibilityLanguage = dataDict.value(forKey: "product_type_id") as? String
        cell.btnSub.tag = indexPath.row
        loadImageFromUrl(url: (dataDict.value(forKey: "product_image") as? String)!, view: cell.PImage)
        
//  

        if (SelectedArr?.contains((data?.value(forKey: "product_id") as? String)!))! {
            cell.btnCheck.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_check_box"), for: .normal)

        }
        else{
            cell.btnCheck.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_check_box_outline_blank"), for: .normal)

        }
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

    
    @IBAction func btnDelete(_ sender: UIButton) {
        
        var Baseurl = "apiRemoveWishlist.php"
        
        //       city_id:1
        //        customer_id:11
        //        product_id:1
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!,
            "product_id" : sender.accessibilityLabel!,
            
            
            ]
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
            
            
            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0
                
                
                
                
                if (dataCount as AnyObject).value(forKey: "status") as? String == "Deleted Successfully" {
                    
                    
                    self.GetWatchListData("GET")

                   
                    
                    
                    
                }
                    
                else{
                    //
                    //                    let dataCount = dataCoun.0[0]
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    
                    
                    
                    
                    
                    
                }
                
                
            }
            
            
            
        }

        

    }
    @IBAction func btnCheck(_ sender: UIButton) {
        
        if  (SelectedArr?.contains(sender.accessibilityLabel!))! {
            SelectedArr?.remove(sender.accessibilityLabel!)
            SelectedProductIDArr?.remove(sender.accessibilityLabel!)
            
        }
        else{
            SelectedArr?.add(sender.accessibilityLabel!)
            SelectedProductIDArr?.add(sender.accessibilityLabel!)

        }
        
        tableView.reloadData()
        
    }
    @IBAction func btnAdd(_ sender: UIButton) {
        
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        
        var Baseurl = "apiAddCart.php"
        
        
        //        city_id  :1
        //        customer_id :29
        //        product_id   :2
        //        product_type_id :2
        //        product_quantity_type : (adding/reducing)
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!,
            "product_id" : sender.accessibilityLabel!,
            "product_type_id" : sender.accessibilityLanguage!,
            "product_quantity_type" : "adding",
            
            ]
        
        print(dict)
        
        
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
            
            
            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0
                
                // print(dataCount)
                
                self.SelectedRow = sender.tag
                
                self.GetWatchListData("UPDATE")
                
                
                
                
                
                if (dataCount as AnyObject).value(forKey: "status") as? String == "Updated Successfully" {
                    
                    
                    
                    
                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Added Successfully" {
                    
                    
                    
                    
                    
                    
                    
                }
                    
                else{
                    //
                    //                    let dataCount = dataCoun.0[0]
                    
                    
                    
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    
                    
                    
                    
                    
                    
                }
                
                
            }
        }
        
        
        
        //        tableView.reloadData()
        
        
        
    }
    @IBAction func btnSub(_ sender: UIButton) {
        
        
        
        
        
        
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiAddCart.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!,
            "product_id" : sender.accessibilityLabel!,
            "product_type_id" : sender.accessibilityLanguage!,
            "product_quantity_type" : "reducing",
            
            ]
        
        
        
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
            
            
            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0
                self.SelectedRow = sender.tag

                
                self.GetWatchListData("UPDATE")
                
                
                if (dataCount as AnyObject).value(forKey: "status") as? String == "Updated Successfully" {
                    
                    
                    
                    
                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Product Deleted Successfully" {
                    
                    
                    
                    
                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Added Successfully" {
                    
                    
                    
                    
                    
                }
                    
                else{
                    //
                    
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    
                    
                    
                }
                
                
            }
            
            
            
            
        }
        
        
        //        tableView.reloadData()
        
        
        
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

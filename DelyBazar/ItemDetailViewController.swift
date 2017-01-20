//
//  ItemDetailViewController.swift
//  DelyBazar
//
//  Created by OSX on 28/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ItemDetailViewController: UIViewController , NVActivityIndicatorViewable , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var c_Image_Height: NSLayoutConstraint!
    @IBOutlet weak var btnQuantity: UIButton!
    @IBOutlet weak var ViewCount: UIView!
    @IBOutlet weak var lblStock: UILabel!
    @IBOutlet weak var C_Quanity_H: NSLayoutConstraint!
    @IBOutlet weak var btnCart: UIButton!
//    @IBOutlet weak var viewQuantity: UIView!
    @IBOutlet weak var lblViewTitle: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var btnCartBottom: UIButton!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var btnSetQuantity: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var isSetQuentityOpen : Bool! = false
    var isLiked : Bool! = false

    
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var SelectedIndex : Int! = 0

    var DataQuantityList : NSMutableArray? = []

    var product_id : String! = " "
    var product_Type_id : String! = " "

    
    var activityIndicatorView : NVActivityIndicatorView?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSub.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1).cgColor
        btnSub.layer.borderWidth = 1
        btnSub.layer.cornerRadius = btnSub.frame.size.height/2
        btnAdd.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1).cgColor
        btnAdd.layer.borderWidth = 1
        btnAdd.layer.cornerRadius = btnAdd.frame.size.height/2
        
        tableView.layer.borderColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1).cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 4
        btnSetQuantity.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1).cgColor
        btnSetQuantity.layer.borderWidth = 1
        btnSetQuantity.layer.cornerRadius = 16
        
        self.ViewCount.isHidden = true
        self.btnSetQuantity.isHidden = true
        self.lblStock.isHidden = true
        self.lblCost.isHidden = true
        self.tableView.isHidden = true

        
        GetData()
        GetCartCountData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.frame = CGRect.init(x: 20, y: tableView.frame.origin.y, width: 178, height: 0)

        isSetQuentityOpen = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.model .hasPrefix("iPad"){
            c_Image_Height.constant = 400
        }
    }
    func GetCartCountData()  {
        var Baseurl = "apiCartCount.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!
            
            //            "city_id" : "1"
        ]
        
        
        
        
        
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetHomeCatApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
//            self.stopAnimating()
            
            
            if data.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataBanner = data.0[0]
                
                
                
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String != nil {
                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    
                    let dataCart = data.0[0]
                    
                    
                    self.btnCart.setTitle((dataCart as AnyObject).value(forKey: "total_cart") as? String , for: .normal)
                    
                    self.btnCartBottom.setTitle((dataCart as AnyObject).value(forKey: "total_cart") as? String , for: .normal)
                    
                    self.lblTotalCost.text = "₹\(((dataCart as AnyObject).value(forKey: "total_amount")! as? String)!)"
                    
                }
                
                
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func GetData()  {
        var Baseurl = "apiProductDetail.php"
          self.startAnimating(CGSize(width: 50, height:50), message: "Getting Product Detail", type: NVActivityIndicatorType.ballZigZagDeflect)
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "product_id" : product_id,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!
        ]
//        city_id, product_id, customer_id
        //         print(dict)
        
        print(dict)
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        
        self.dataModel.GetBannerApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
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
                let data1 = data.0[0] as? NSDictionary
                    
                    
                    
                    
                 self.lblViewTitle.text = (data1 as AnyObject).value(forKey: "product_name") as? String
                    
                     self.name.text = (data1 as AnyObject).value(forKey: "product_name") as? String
                    self.lblDescription.text = (data1 as AnyObject).value(forKey: "product_desc") as? String

                    if (data1 as AnyObject).value(forKey: "wishlist_status") as? String == "added"{
                        self.isLiked = true
                        self.btnLike.setBackgroundImage(#imageLiteral(resourceName: "greenfav"), for: .normal)
                        
                    }
                    else{
                        self.isLiked = false

                        self.btnLike.setBackgroundImage(#imageLiteral(resourceName: "GrayFav"), for: .normal)

                    }
                    
                    if (data1 as AnyObject).value(forKey: "stock_status") as? String == "In Stock"{
                        self.ViewCount.isHidden = false
                        self.btnSetQuantity.isHidden = false
                        self.lblStock.isHidden = true
                        self.lblCost.isHidden = false
                    }
                    else{
                        self.ViewCount.isHidden = true
                        self.btnSetQuantity.isHidden = true
                        self.lblStock.isHidden = false
                        self.lblCost.isHidden = true

                    }

                    
                    
                    print(data1!)

//                    self.DataQuantityList = dataType
                    
                   
                    let dataPriceType = data1?.value(forKey: "pricetype") as! NSArray
                    
//                    self.DataQuantityList = data1?.value(forKey: "pricetype") as? NSMutableArray
                    self.DataQuantityList?.removeAllObjects()
                    for i in 0...dataPriceType.count - 1 {
                        
                        self.DataQuantityList?.add(dataPriceType[i])
                        
                    }
                    
                    
                    print(self.DataQuantityList!)

                    let dataDict = dataPriceType[self.SelectedIndex]
                    //            let price = (dataDict as AnyObject).value(forKey: "pricetype") as? NSArray
                    let Sellprice = (dataDict as AnyObject).value(forKey: "selling_price") as? String
                    let SellImage = (dataDict as AnyObject).value(forKey: "product_image") as? String
//                    let Sellproduct_id = (dataDict as AnyObject).value(forKey: "product_id") as? String
                    
                    let SellType_id = (dataDict as AnyObject).value(forKey: "product_type_id") as? String
                    let SellWeight = (dataDict as AnyObject).value(forKey: "product_weight") as? String
                    let Sellunit = (dataDict as AnyObject).value(forKey: "product_unit") as? String
                    let SellQuantity = (dataDict as AnyObject).value(forKey: "product_quantity") as? String

                    let str =  SellImage!.replacingOccurrences(of: " ", with: "%20")

                    self.loadImageFromUrl(url: str, view: self.ItemImage)
                    
                   self.product_Type_id = SellType_id
                    self.lblCost.text = "Rs \(Sellprice!)"
                    
                    self.lblTotalCost.text = "Rs \(Sellprice!)"
                    
                    self.lblCount.text = SellQuantity
                    
                    self.btnSetQuantity.setTitle("   Quantity- \(SellWeight!) \(Sellunit!)", for: .normal)
                    
                 
                }
                
                
            }
        }
        

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

    func ShowAlertOK(sender : NSString)  {
        
        let alert = UIAlertController(title: "Alert", message: sender as String, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func next(_ sender: Any) {
        if btnCart.title(for: .normal)! as String == "0"{
            ShowAlertOK(sender: "There is no item in the cart")
        }
        else{
            
            
            let CVC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            self.present(CVC, animated: true, completion: nil)
        }

    }
    @IBAction func bottomCart(_ sender: Any) {
        let CVC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.present(CVC, animated: true, completion: nil)
    }
    @IBAction func SetQuantity(_ sender: Any) {
        
        if isSetQuentityOpen == true {
            isSetQuentityOpen = false
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: { 
                self.tableView.frame = CGRect.init(x: 20, y: self.tableView.frame.origin.y, width: 178, height: 0)


            }, completion: { (suc) in
//                self.viewQuantity.isHidden = true
                self.tableView.isHidden = true
            })
            

            
        }
        else {
            isSetQuentityOpen = true
            
            self.tableView.isHidden = false

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                
                if (self.DataQuantityList?.count)! <= 4 {
                
                self.tableView.frame = CGRect.init(x: 20, y: Int(self.tableView.frame.origin.y), width: 178, height: (self.DataQuantityList?.count)! * 50)
                    
                    print(self.DataQuantityList?.count)
                    
                }
                else{
                     self.tableView.frame = CGRect.init(x: 20, y: Int(self.tableView.frame.origin.y), width: 178, height: 200)
                }
//                self.viewQuantity.isHidden = false

                self.tableView.reloadData()

            }, completion: { (suc) in

            })
        }
        
        
    }
    
    @IBAction func Add(_ sender: Any) {
        
        var Baseurl = "apiAddCart.php"
        
        //        city_id  :1
        //        customer_id :29
        //        product_id   :2
        //        product_type_id :2
        //        product_quantity_type : (adding/reducing)
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!,
            "product_id" : product_id!,
            "product_type_id" : product_Type_id!,
            "product_quantity_type" : "adding",
            
            ]
        
        
        
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
            
            
            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0
                
                
                let num = self.lblCount.text
                
                var i = Int(num!)
                
                i = i! + 1
                let str = String(describing: i!)
                
                if (dataCount as AnyObject).value(forKey: "status") as? String == "Updated Successfully" {
                    
                    
                    
                    
                    self.lblCount.text = str
                    
                    self.GetCartCountData()
                    
                    
                    
                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Product Deleted Successfully" {
                    
                    
                    self.lblCount.text = str
                    
                    
                    self.GetCartCountData()
                    
                    
                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Added Successfully" {
                    
                    self.lblCount.text = str
                    
                    
                    self.GetCartCountData()
                    
                    
                }
                    
                else{
                    //
                    //                    let dataCount = dataCoun.0[0]
                    
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    
                    self.GetCartCountData()
                    
                    
                    
                    
                    
                    
                }
                
                
            }
            
            
            
            
        }
        
    }
    @IBAction func sub(_ sender: Any) {
        

        //        let num = data?.value(forKey: "product_quantity") as! Any?
        
        
        
        
        var Baseurl = "apiAddCart.php"
        
        //        city_id  :1
        //        customer_id :29
        //        product_id   :2
        //        product_type_id :2
        //        product_quantity_type : (adding/reducing)
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!,
            "product_id" : product_id!,
            "product_type_id" : product_Type_id!,
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
                
                
                let num = self.lblCount.text
                
                var i = Int(num!)
                
                i = i! - 1
                let str = String(describing: i!)
                
                if (dataCount as AnyObject).value(forKey: "status") as? String == "Updated Successfully" {
                    
                    
                    
                  
                    self.lblCount.text = str
                    
                    self.GetCartCountData()
                    
                    
                    
                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Product Deleted Successfully" {
                    
                    
                    self.lblCount.text = str

            
                    self.GetCartCountData()
                    
                    
                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Added Successfully" {
                    
                    self.lblCount.text = str

               
                    self.GetCartCountData()
                    
                    
                }
                    
                else{
                    //
                    //                    let dataCount = dataCoun.0[0]
                    
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    
                    self.GetCartCountData()
                    
                    
                    
                    
                    
                    
                }
                
                
            }
            
            
            
            
        }

        
    }
    @IBAction func LikeUnLike(_ sender: Any) {
        
        if isLiked == true {
            isLiked = false
            
            var Baseurl = "apiRemoveWishlist.php"
            
            //       city_id:1
            //        customer_id:11
            //        product_id:1
            let dict = [
                "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
                "customer_id" : UserDefaults.standard.value(forKey: "id")!,
                "product_id" : product_id!,
                
                
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
                        
                        
                    
                        self.btnLike.setBackgroundImage(#imageLiteral(resourceName: "GrayFav"), for: .normal)
                        
                        self.isLiked = false
                        
                        
                        
                    }
                        
                    else{
                        //
                        //                    let dataCount = dataCoun.0[0]
                        self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                
            }

            
            
        }
        else {
            var Baseurl = "apiAddWishlist.php"
            
            //       city_id:1
            //        customer_id:11
            //        product_id:1
            let dict = [
                "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
                "customer_id" : UserDefaults.standard.value(forKey: "id")!,
                "product_id" : product_id!,
                
                
                ]
            
            
        
            
            // print(dict)
            
            Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
            
            
            self.dataModel.GetApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
                
                
                self.stopAnimating()
                
                
                if dataCoun.1 as String == "FAILURE"{
                    self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                    
                }
                else{
                    
                    let dataCount = dataCoun.0
                    
                    
                    
                    
                    if (dataCount as AnyObject).value(forKey: "status") as? String == nil {
                        //                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                        //                    self.NoDataView.isHidden = false
                        
                    }
                        
                    else{
                        //
                        let dataCount = dataCoun.0
                        
                        
                        
                        
                        if (dataCount as AnyObject).value(forKey: "status") as? String == "Added Successfully" {
                            
                           
                            self.btnLike.setBackgroundImage(#imageLiteral(resourceName: "greenfav"), for: .normal)
                            
                            self.isLiked = true

                            
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
        
        
    }
    @IBAction func Menu(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func search(_ sender: Any) {
        let SCV = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        self.present(SCV!, animated: true, completion: nil)

    }

    @IBAction func Cart(_ sender: Any) {
        if btnCart.title(for: .normal)! as String == "0"{
            ShowAlertOK(sender: "There is no item in the cart")
        }
        else{
            
            
            let CVC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            self.present(CVC, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var ItemImage: UIImageView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (DataQuantityList?.count)!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        cell.selectionStyle = UITableViewCellSelectionStyle.default
        let dataDict = DataQuantityList?[indexPath.row]
        //            let price = (dataDict as AnyObject).value(forKey: "pricetype") as? NSArray
      
        let SellWeight = (dataDict as AnyObject).value(forKey: "product_weight") as? String
        let Sellunit = (dataDict as AnyObject).value(forKey: "product_unit") as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        
        
        cell.textLabel?.text = "Quantity- \(SellWeight!) \(Sellunit!)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataDict = DataQuantityList?[indexPath.row]
        //            let price = (dataDict as AnyObject).value(forKey: "pricetype") as? NSArray
        
        let SellWeight = (dataDict as AnyObject).value(forKey: "product_weight") as? String
        let Sellunit = (dataDict as AnyObject).value(forKey: "product_unit") as? String

        btnSetQuantity.setTitle("   Quantity- \(SellWeight!) \(Sellunit!)"  , for: UIControlState.normal)
        isSetQuentityOpen = false
        SelectedIndex = indexPath.row
        GetData()

        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.tableView.frame = CGRect.init(x: 20, y: self.tableView.frame.origin.y, width: 178, height: 0)
            
            
        }, completion: { (suc) in
            //                self.viewQuantity.isHidden = true
            
        })
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

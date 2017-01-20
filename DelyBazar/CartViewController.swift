//
//  CartViewController.swift
//  DelyBazar
//
//  Created by OSX on 01/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CartViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , NVActivityIndicatorViewable , UIGestureRecognizerDelegate{
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var DataTimeSlot : NSMutableArray? = []
    var DataDateSlot : NSMutableArray? = []

    var activityIndicatorView : NVActivityIndicatorView?

    
    var DataCart : NSMutableArray? = []

    @IBOutlet weak var btnSelecttimeSlot: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmailPhone: UITextField!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var TimeTable: UITableView!
    @IBOutlet weak var DateTable: UITableView!
    @IBOutlet weak var Viewtimeslot: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTotalCost: UILabel!

    var tap : UITapGestureRecognizer! = nil
    var isTimeSlotOpen : Bool = false
    var type : String! = ""
    var DateSelect : Int! = 0
    var TimeSelect : Int! = -1
    var TotalAmount : String! = ""
    
    @IBOutlet weak var btnCart: UIButton!
    
    var TimeID : String! = ""
    var Timename : String! = ""
    var TimeDate : String! = ""


    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
 tableView.register(UINib(nibName: "VegetableTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
         DateTable.register(UINib(nibName: "TimeSlotTableViewCell", bundle: nil), forCellReuseIdentifier: "DateCell")
         TimeTable.register(UINib(nibName: "TimeSlotTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        
        
        tap = UITapGestureRecognizer.init(target: self, action: #selector(CartViewController.BackgroundTap))
        
        bgView.addGestureRecognizer(tap)
        
        btnSubmit.layer.borderWidth = 1
        btnSubmit.layer.cornerRadius = 4

        self.GetCartData()
        self.GetCartCountData()

        GetTimeSlotData()
        UserDefaults.standard.set(TimeSelect, forKey: "TimeSelect")

        // Do any additional setup after loading the view.
    }
    func GetCartCountData()  {
        var Baseurl = "apiCartCount.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!
            
            //            "city_id" : "1"
        ]
        
        
        
        
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetHomeCatApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
            
            
//            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0[0]
                
                
                
                
                if (dataCount as AnyObject).value(forKey: "status") as? String != nil {
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    
                    print("banner  \(dataCoun.0.count)")
                    //                    let dataCount = dataCoun.0[0]
                    
                    self.btnCart.setTitle((dataCount as AnyObject).value(forKey: "total_cart") as? String , for: .normal)
                self.lblTotalCost.text = "Total - ₹\(((dataCount as AnyObject).value(forKey: "total_amount")! as? String)!)"
                    
                    
                    
                    
                    
                }
                
                
            }
        }
        
    }
    func BackgroundTap()  {
        isTimeSlotOpen = false
        bgView.isHidden = true
        Viewtimeslot.isHidden = true
        viewEmail.isHidden = true
        txtEmailPhone.endEditing(true)

    }
    
    @IBAction func Continue(_ sender: Any) {
        if btnCart.title(for: .normal)! as String == "0"{
            ShowAlertOK(sender: "There is no item in the cart")
        }
        else{
            
          
        let email = UserDefaults.standard.string(forKey: "email")
        let mobile_no = UserDefaults.standard.string(forKey: "mobile_no")

        
        
        if email?.characters.count == 0
        {
            txtEmailPhone.attributedPlaceholder = NSAttributedString(string:"Enter Your Email",
                                                                attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
            bgView.isHidden = false
            viewEmail.isHidden = false
            
            type = "email"
            

        }
        else if mobile_no?.characters.count == 0
        {
            txtEmailPhone.attributedPlaceholder = NSAttributedString(string:"Enter Your Mobile No",
                                                                     attributes:[NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
            bgView.isHidden = false
            viewEmail.isHidden = false
            type = "mobile"

        }
        else{
            
            let timeSelected = UserDefaults.standard.integer(forKey: "TimeSelect")
            
            if timeSelected == -1 {
                isTimeSlotOpen = true
                
                bgView.isHidden = false
                Viewtimeslot.isHidden = false
                
                TimeTable.reloadData()
                DateTable.reloadData()

            }
            else{

            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddresslistViewController") as! AddresslistViewController
            self.present(vc, animated: true, completion: nil)
            }
        }
        }
    }
    @IBAction func Submit(_ sender: Any) {
        
        
        if txtEmailPhone.text?.characters.count == 0 {
            ShowAlertOK(sender: "Enter your \(type!)" as NSString)
        }
        else {
        
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiMobEmailVerf.php"
        
        let dict = [
            "customer_id" : UserDefaults.standard.value(forKey: "id")! ,
            "email_mobile" : txtEmailPhone.text!,
            "type" : type
        ]
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        
        
        self.dataModel.GetBannerApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            self.stopAnimating()
            
            
            if data.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataBanner = data.0[0]
                
                
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String == "Mobile No is Aready Exists" {
                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
//                                        self.DataSubCat?.removeAllObjects()
//                                        self.ArrRecentName.removeAllObjects()
                                        // print("banner  \(data.0.count)")
                    
                    if self.type == "mobile" {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                        
                        vc.MobileNo = self.txtEmailPhone.text
                        vc.UserID = UserDefaults.standard.value(forKey: "id") as! String
                        vc.OtpString = (dataBanner as AnyObject).value(forKey: "otp")  as! NSNumber
                        self.present(vc, animated: true, completion: nil)

                    }
                    else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddresslistViewController") as! AddresslistViewController
                        
                        UserDefaults.standard.set(self.txtEmailPhone.text, forKey: "email")
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    
                    self.bgView.isHidden = true
                    self.viewEmail.isHidden = true

                   
                    //                // print(data1)
                    
                  
                    }
                
                
            }
        }
        
        
        }
        
        
        
        
        
        
        
    }
    func GetTimeSlotData()  {
        var Baseurl = "apiListingSlot.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
      
     
        
        
        
        
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
         self.dataModel.GetTimeSlotApi(Url: Baseurl as String as NSString){ (dataCoun) in
            
            
            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0[0]
                
                
                
                
                if (dataCount as AnyObject).value(forKey: "status") as? String != nil {
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    
                    print("banner  \(dataCoun.0.count)")
                    //                    let dataCount = dataCoun.0[0]
                    
                    for i in 0...dataCoun.0.count - 1 {
                        self.DataTimeSlot?.add(dataCoun.0[i])
                    }
                    self.DataDateSlot?.add(dataCoun.0[0])
                    self.TimeTable.reloadData()
                    self.DateTable.reloadData()
                    

                }
                
                
            }
        }
        
    }

    func GetCartData()  {
        //        http://delybazar.in/mobile-app/apiSubCategory.php
        var Baseurl = "apiListingCart.php"
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)

        //        var url = "\(Baseurl)apiBanner.php"
//        city_id  :1
//        customer_id :3

        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")! ,

            //            "city_id" : "1"
        ]
        
        
        
        
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        DataCart?.removeAllObjects()
        self.dataModel.GetHomeCatApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCat) in
            
            
            self.stopAnimating()
            
            
            if dataCat.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCate = dataCat.0[0]
                
                
                
                
                if (dataCate as AnyObject).value(forKey: "status") as? String != nil {
                    self.ShowAlertOK(sender: (dataCate as AnyObject).value(forKey: "status")  as! NSString)
                    self.tableView.reloadData()

                }
                    
                else{
                    
                    print("banner  \(dataCat.0.count)")
                    
                    for i in 0...dataCat.0.count - 1 {
                        self.DataCart?.add(dataCat.0[i])
                    }
                                    self.tableView.reloadData()
                    
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
    

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == DateTable {
            return (DataDateSlot?.count)!

        }
        else if tableView == TimeTable {
            return (DataTimeSlot?.count)!

        }
        else {
            return (DataCart?.count)!

        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == DateTable {
            return 50
        }
        else if tableView == TimeTable {
            return 50
            
        }
        else {
            if UIDevice.current.model .hasPrefix("iPad")
            {
                return 200
            }
            else {
                
                return 143
            }
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == DateTable {
  let cell = self.DateTable.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! TimeSlotTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let data = DataTimeSlot?[0] as? NSDictionary

            cell.name.text = (data as AnyObject).value(forKey: "delivery_date") as? String

            if indexPath.row == DateSelect {
                 cell.btnSelect.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: .normal)
            }
            else{
                 cell.btnSelect.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
            }
            
            btnDate.setTitle((data as AnyObject).value(forKey: "delivery_date") as? String, for: .normal)

            
            TimeDate = (data as AnyObject).value(forKey: "delivery_date") as? String
            
            
            return cell

        }
        else if tableView == TimeTable {
  let cell = self.TimeTable.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeSlotTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none

            let data = DataTimeSlot?[indexPath.row] as? NSDictionary
            
            cell.name.text = (data as AnyObject).value(forKey: "name") as? String
            if indexPath.row == TimeSelect {
                cell.btnSelect.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: .normal)
            }
            else{
                cell.btnSelect.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
            }
//            btnTime.setTitle((data as AnyObject).value(forKey: "name") as? String, for: .normal)

            cell.btnSelect.accessibilityHint = (data as AnyObject).value(forKey: "slot_id") as? String
            return cell

        }
        else {

        
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VegetableTableViewCell
        
        cell.btnFav.isHidden = true
        cell.BtnDelete.isHidden = false
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        let data = DataCart?[indexPath.row] as? NSDictionary

        cell.name.text = (data as AnyObject).value(forKey: "product_name") as? String
        loadImageFromUrl(url: ((data as AnyObject).value(forKey: "product_image") as? String)!, view: cell.vIMage)
        
        cell.cost.text = "Rs \(((data as AnyObject).value(forKey: "product_price") as? String)!)"
        cell.btnQuantity.setTitle("   Quantity- \(((data as AnyObject).value(forKey: "product_weight_unit") as? String)!)", for: .normal)
        cell.BtnDelete.addTarget(self, action: #selector(CartViewController.BtnDelete(_:)) , for: .touchDown)
        
        cell.Number.text =  (data as AnyObject).value(forKey: "product_quantity") as? String
        
        cell.BtnDelete.tag = indexPath.row
        cell.BtnDelete.accessibilityLabel = (data as AnyObject).value(forKey: "cart_id") as? String
        
        
        cell.BtnDelete.accessibilityLanguage = (data as AnyObject).value(forKey: "product_type_id") as? String
        
        
        
        cell.btnSub.addTarget(self, action: #selector(SubCatViewController.SetSub(_:)) , for: .touchDown)
        
        
        
        cell.btnSub.tag = indexPath.row
        cell.btnSub.accessibilityLabel = (data as AnyObject).value(forKey: "product_id") as? String
        cell.btnSub.accessibilityLanguage = (data as AnyObject).value(forKey: "product_type_id") as? String
        
        cell.btnAdd.addTarget(self, action: #selector(SubCatViewController.SetAdd(_:)) , for: .touchDown)
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.accessibilityLabel = (data as AnyObject).value(forKey: "product_id") as? String
        cell.btnAdd.accessibilityLanguage = (data as AnyObject).value(forKey: "product_type_id") as? String

        
        
            cell.btnSelectedButton.addTarget(self, action: #selector(SubCatViewController.DetailView(_:)) , for: .touchDown)
            
            cell.btnSelectedButton.tag  = indexPath.row
        
        
        return cell
        }
    }
    @IBAction func DetailView(_ sender: UIButton) {
        
        let IVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        let data = DataCart?[sender.tag]
        IVC.product_id = (data as AnyObject).value(forKey: "product_id") as? String
        self.present(IVC, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == DateTable {
            
            
            DateSelect = indexPath.row
            
            TimeSelect = -1
            TimeTable.reloadData()
            DateTable.reloadData()
            let data = DataTimeSlot?[0] as? NSDictionary

            
            btnDate.setTitle((data as AnyObject).value(forKey: "name") as? String, for: .normal)
            
            
            
        }
        else if tableView == TimeTable {
            TimeSelect = indexPath.row
            TimeTable.reloadData()

            let data = DataTimeSlot?[indexPath.row] as? NSDictionary
            
            
            TimeID  = (data as AnyObject).value(forKey: "slot_id") as? String
            Timename = (data as AnyObject).value(forKey: "name") as? String

      
            btnTime.setTitle((data as AnyObject).value(forKey: "name") as? String, for: .normal)

            
        }
        else {
//            let IVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
//            let data = DataCart?[indexPath.row]
//            IVC.product_id = (data as AnyObject).value(forKey: "product_id") as? String
//            self.present(IVC, animated: true, completion: nil)

        }

    }
    @IBAction func BtnDelete(_ sender: UIButton) {
        
        var Baseurl = "apiDeleteCart.php"
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)

        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
            "cart_id" : sender.accessibilityLabel! ,
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
                
                
                self.GetCartData()
                self.GetCartCountData()

                
                if (dataBanner as AnyObject).value(forKey: "status") as? String != nil {
                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    
                    
                    
                    
                    
                }
                
                
            }
        }

        
        
    }
    
    
    
    @IBAction func SetSub(_ sender: UIButton) {
        
        
        let x  = sender.tag
        
    
        
        
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
                
                
                self.GetCartData()
                self.GetCartCountData()

                
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
    @IBAction func SetAdd(_ sender: UIButton) {
        
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
                
                
                
                self.GetCartData()

                self.GetCartCountData()

                
                
                
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

    @IBAction func ActionReset(_ sender: Any) {
        
//     DateSelect = 0
//        TimeSelect = -1
//       
//      UserDefaults.standard.set(String(TimeSelect!), forKey: "TimeSelect")
//        
//        btnSelecttimeSlot.setTitle("Select Time Slot", for: .normal)
//        
//        TimeTable.reloadData()
//        DateTable.reloadData()

    }
    
    @IBAction func Confirm(_ sender: Any) {
        
        
        UserDefaults.standard.set(TimeID!, forKey: "TimeSelect")
        UserDefaults.standard.set(Timename!, forKey: "time_slot_name")
        UserDefaults.standard.set(TimeDate!, forKey: "Date_slot_name")

        btnSelecttimeSlot.setTitle("\(TimeDate!),\(Timename!)", for: .normal)

        
                isTimeSlotOpen = false
                bgView.isHidden = true
                Viewtimeslot.isHidden = true
    }
    @IBAction func ActionDone(_ sender: Any) {
//        isTimeSlotOpen = false
//        bgView.isHidden = true
//        Viewtimeslot.isHidden = true
    }
    
    
    func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        
        let   Strurl = url.replacingOccurrences(of: " ", with: "%20")
        
        let url = NSURL(string: Strurl)!
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
    
    @IBAction func SelectTimeSlot(_ sender: Any) {
        if isTimeSlotOpen == false {
            isTimeSlotOpen = true
            
            bgView.isHidden = false
            Viewtimeslot.isHidden = false
            
            TimeTable.reloadData()
            DateTable.reloadData()
            
            
        }
        else{
            isTimeSlotOpen = false
            bgView.isHidden = true
            Viewtimeslot.isHidden = true
        }
        
        
    }
    @IBAction func DeliveryTime(_ sender: Any) {
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

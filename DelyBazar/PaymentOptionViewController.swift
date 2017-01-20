//
//  PaymentOptionViewController.swift
//  DelyBazar
//
//  Created by OSX on 06/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PaymentOptionViewController: UIViewController , NVActivityIndicatorViewable  {

    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewCoupon: UIView!
    @IBOutlet weak var lblPayableAmount: UILabel!
    @IBOutlet weak var lblamount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnApplyCoupon: UIButton!
    @IBOutlet weak var txtCoupon: UITextField!
    @IBOutlet weak var btnGetCoupon: UIButton!
    @IBOutlet weak var btnPayU: UIButton!
    @IBOutlet weak var btnCashOn: UIButton!
    @IBOutlet weak var btnPtm: UIButton!
    @IBOutlet weak var lblCouMsg: UILabel!
    
    var mutDictTransactionDetails = [AnyHashable: Any]()

    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var DataAddressList : NSMutableArray? = []
    var activityIndicatorView : NVActivityIndicatorView?
    var Merchant_Key = "kgaqj9"
    var Merchant_ID = "4928174"
    
    var Salt = "8BUUrpjV"
    var Base_URL = "https://secure.payu.in"
    var Success_URL = "http://delybazar.in/mobile-app/apiPayumoney_Success.php"
    var Failure_URL = "http://delybazar.in/mobile-app/apiPayumoney_Failure.php"

    var PayBy : String! = ""
    var shipping_address_id : String! = ""
    var userName : String! = ""
    var Product_ID : String! = ""
    var Product_count : String! = ""
    var Product_amount : String! = ""
    var Discount_amount : String! = "0"

    var Total : String! = ""
    var AmountPayable : String! = ""
    var DictTransactionDetails : NSMutableDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewCoupon.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1).cgColor
        viewCoupon.layer.borderWidth = 1
        viewCoupon.layer.cornerRadius = 16
        viewCoupon.layer.masksToBounds = true

        btnApplyCoupon.layer.masksToBounds = true
        
        GetCartCountData()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if DictTransactionDetails != nil {
            print(DictTransactionDetails!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    
                    
                    self.lblTotalAmount.text = "₹\(((dataCount as AnyObject).value(forKey: "total_amount")! as? String)!)"
                    
                    
                    self.Total = ((dataCount as AnyObject).value(forKey: "total_amount")! as? String)!
                    self.lblamount.text = "00.00"
                    
                    self.lblPayableAmount.text = "₹\(((dataCount as AnyObject).value(forKey: "total_amount")! as? String)!)"
                    
                    
                    self.AmountPayable = ((dataCount as AnyObject).value(forKey: "total_amount")! as? String)!
                    
                    self.Product_ID = ((dataCount as AnyObject).value(forKey: "total_amount")! as? String)!
                    
                    self.Product_count = ((dataCount as AnyObject).value(forKey: "total_cart")! as? String)!

                }
                
                
            }
        }
        
    }
    @IBAction func GetCouponCode(_ sender: Any) {
        
//        apiCouponCode.php
        
        if btnGetCoupon.title(for: .normal) ==  "Get a Coupon Code ?"{
            
            
                        viewCoupon.isHidden = false
            btnGetCoupon.isHidden = true
        }
        else{
        
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            var Baseurl = "apiRemoveCoupon.php"
            //        :TEST101
            //        total_amt:300
            let dict = [
                "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
                "customer_id" : UserDefaults.standard.value(forKey: "id")! ,
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
                    
                    
                    
                    if (dataBanner as AnyObject).value(forKey: "status") as? String == "Deleted Successfully" {
                        
                        _ = data.0[0]
                        
                        
                        self.btnGetCoupon.setTitle("Get a Coupon Code ?", for: .normal)
                        self.AmountPayable = self.Total
                        
                        self.lblPayableAmount.text = "₹\(self.Total!)"

                        
                    }
                        
                    else  if (dataBanner as AnyObject).value(forKey: "status") as? String != nil {
                        
                        self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                        
                        
                        
                        //                // print(data1)
                        
                        
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

    @IBAction func RcashOnDel(_ sender: Any) {
        btnCashOn.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: .normal)
        btnPayU.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
        btnPtm.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)

        PayBy = "cashondelivery"
        btnContinue.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)


    }
    @IBOutlet weak var RcashOnDel: UIButton!
    @IBAction func CashOnDel(_ sender: Any) {
        
        
        btnCashOn.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: .normal)
        btnPayU.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
        btnContinue.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
        btnPtm.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)

        
        PayBy = "cashondelivery"

    }

    @IBAction func RPayU(_ sender: Any) {
        btnCashOn.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
        btnPayU.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: .normal)
        btnPtm.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)

        
        PayBy = "payumoney"
        btnContinue.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)

        

    }
    @IBAction func RPayTM(_ sender: Any) {
        btnCashOn.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
        btnPayU.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
        btnPtm.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: .normal)
        
        
        
        PayBy = "paytm"
        btnContinue.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)

    }
    @IBAction func PayTm(_ sender: Any) {
        btnCashOn.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
        btnPayU.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
        btnPtm.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: .normal)
        
        
        
        PayBy = "paytm"
        btnContinue.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)

    }
    @IBAction func PayU(_ sender: Any) {
        btnCashOn.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
        btnPayU.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: .normal)
        btnPtm.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)

        
        
        PayBy = "payumoney"
        btnContinue.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)


        
    }
    @IBAction func Applycoupon(_ sender: Any) {
        
        
        if btnApplyCoupon.title(for: .normal) == "Remove" {
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            var Baseurl = "apiRemoveCoupon.php"
            //        :TEST101
            //        total_amt:300
            let dict = [
                "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
                "customer_id" : UserDefaults.standard.value(forKey: "id")! ,
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
                    
                    
                    
                    if (dataBanner as AnyObject).value(forKey: "status") as? String == "Deleted Successfully" {
                        
                        _ = data.0[0]
                        
                        self.btnApplyCoupon.setTitle("Apply", for: .normal)

                        self.btnGetCoupon.setTitle("Get a Coupon Code ?", for: .normal)
                        self.AmountPayable = self.Total
                        self.lblamount.text = "₹0.00"

                        self.lblPayableAmount.text = "₹\(self.Total!)"
                        
                        self.txtCoupon.isEnabled = true

                    }
                        
                    else  if (dataBanner as AnyObject).value(forKey: "status") as? String != nil {
                        
                        self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                        
                        
                        
                        //                // print(data1)
                        
                        
                    }
                    
                    
                }
            }
            
            

        }
        else{
        
        if txtCoupon.text?.characters.count == 0 {
            ShowAlertOK(sender: "Fill Your Coupon Code First")
        }
        else{
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            var Baseurl = "apiCouponCode.php"
            //        :TEST101
            //        total_amt:300
            let dict = [
                "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
                "customer_id" : UserDefaults.standard.value(forKey: "id")! ,
                "coupon_code" : txtCoupon.text! ,
                "total_amt" : Total! ,
                ]
            
            print(dict)
            
            Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
            
            
            txtCoupon.endEditing(true)
            
            
            
            self.dataModel.GetBannerApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
                
                
                self.stopAnimating()
                
                
                if data.1 as String == "FAILURE"{
                    self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                    
                }
                else{
                    
                    let dataBanner = data.0[0]
                    
                    
                    
                    if (dataBanner as AnyObject).value(forKey: "status") as? String == "success" {
                        
                        
                        
                        
                        
                        let data1 = data.0[0]


                        self.btnApplyCoupon.setTitle("Remove", for: .normal)

                        let myString = ((dataBanner as AnyObject).value(forKey: "coupon_message")  as? String)!
                        let myAttribute = [ NSForegroundColorAttributeName: #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1) ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        
                        
                        self.lblCouMsg.attributedText = myAttrString
//
                        self.txtCoupon.isEnabled = false
                        
                        
                        
                            let T_Cost = Int(self.Total)
                        
                        let D_Cost = (((dataBanner as AnyObject).value(forKey: "discount_value") as? Int)!)
                        
                        
                        self.lblamount.text = "₹\(D_Cost)"
                        self.Discount_amount = "\(D_Cost)"
                        

                         let min_order_amt = 300
                        
//                        if T_Cost! > min_order_amt {
                            self.AmountPayable = String(T_Cost! - D_Cost)
                            
                            self.lblPayableAmount.text = "₹\(String(T_Cost! - D_Cost))"
                            
                            
                            
//                        }
                        
                        
                        
                        
                        
                                                               }
                        
                    else  if (dataBanner as AnyObject).value(forKey: "status") as? String != nil {
                        
                        self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                        

                        
                        //                // print(data1)
                        
                        
                    }
                    
                    
                }
            }
            
            
            
            
            }
            

        }
        
        
        
    }
    @IBAction func Continue(_ sender: Any) {
        
        
        
        if Int(AmountPayable!)! <= 300 {
            ShowAlertOK(sender: "Our minimum order amount is Rs. 300/-")
        }
        
        else {
        
        if PayBy == "payumoney" {
            
            
            
            
            
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            var Baseurl = "payumoney_hash.php"
            //        key:dRQuiA   (merchant key)
            //        merchantId:4928174   (merchant Id)
            //        txnid:                              (order Id)
            //        amount:318                    (total Amount)
            //        SURL:http://delybazar.in/mobile-app/apiPayumoney_Success.php
            //        FURL:http://delybazar.in/mobile-app/apiPayumoney_Failure.php
            //        productInfo:  1,2016-12-28,8 AM         (slot_id),(delivery date(Format :2016-12-01)),(slot_name)
            //        email: viswanath.ravi@ymail.com
            //        firstName: Viswanath
            //        phone:7348822236
            //        udf1:8237                                                    (customer_id)
            //        udf2:1                                                              (city_id)
            //        udf3:7553                                                  (shipping_address_id)
            //        udf4:2                                                      (total product count)
            //        udf5:
            //
            let dict = [
                
                "key" : "\(Merchant_Key)" ,
                "txnid" : "" ,
                "merchantId" : "\(Merchant_ID)" ,
                "amount" : "\(AmountPayable!)" ,
//                 "amount" : "1" ,
                "firstName" : "\(DataCollection?.value(forKey: "first_name") as! String)",
                "phone" : "\(UserDefaults.standard.string(forKey: "mobile_no")!)",
                "email" : "\(UserDefaults.standard.string(forKey: "email")!)",
//                "email" : "jaipreetsingh.orem@gmail.com",
                "productInfo" : "\(UserDefaults.standard.value(forKey: "TimeSelect")!),\(UserDefaults.standard.value(forKey: "Date_slot_name")!) ,\(UserDefaults.standard.value(forKey: "time_slot_name")!))",
                "FURL" : "\(Failure_URL)",
                "SURL" : "\(Success_URL)",
                
                "udf5" : Discount_amount!,
                
                "udf4" : "\(Product_count!)",
                "udf3" :  "\(DataCollection?.value(forKey: "address_id") as! String)",
                "udf2" :"\( UserDefaults.standard.value(forKey: "city_id")!)" ,
                "udf1" :  "\(UserDefaults.standard.value(forKey: "id")!)",
                
                ]
            
            print(dict)
            
            Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
            
            
            
            
            self.dataModel.GetPayuMoneyApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
                
                
                self.stopAnimating()
                
                
                if data.1 as String == "FAILURE"{
                    self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                    
                }
                else{
                    
                    let dataBanner = data.0
                    
                    
                    
                    if dataBanner.value(forKey: "status") as! Int64 == 0 {
                    
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayUMoneyViewController") as! PayUMoneyViewController
                        //
                        
                                    vc.Paid_Amount = self.AmountPayable!
//                        vc.Paid_Amount = "1"
                        vc.Payee_Number =  UserDefaults.standard.string(forKey: "mobile_no")!
                        vc.Shipping_address = "\(self.DataCollection?.value(forKey: "address_id") as! String)"
                        vc.order_id = (dataBanner as AnyObject).value(forKey: "txnId") as! String
                        vc.Total_Count = self.Product_count

                        vc.Api_hash = (dataBanner as AnyObject).value(forKey: "result") as! String
                        vc.Payee_Name = "\(self.DataCollection?.value(forKey: "first_name") as! String)"
                        vc.Product_Info = "\(UserDefaults.standard.value(forKey: "TimeSelect")!),\(UserDefaults.standard.value(forKey: "Date_slot_name")!) ,\(UserDefaults.standard.value(forKey: "time_slot_name")!))"
                        self.present(vc, animated: true, completion: nil)
                        
                        
                        
                    }
                        
                    else {
                        
                        
                        //                         self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                        //                // print(data1)
                  
                        
                    }
                    
                    
                }
            }
            

            
            
            
            
            
            
            
            
           
        }
        
        else if PayBy == "paytm" {
            
            
                
                
                
                
                
                self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
                var Baseurl = "before_paytm_checksum.php"

           
//
//
            
                let dict = [
                    "city_id" :"\( UserDefaults.standard.value(forKey: "city_id")!)" ,
                    "customer_id" :  "\(UserDefaults.standard.value(forKey: "id")!)",
                    "total_amount" : AmountPayable ,
                    "discount_amount" :  Discount_amount,
                    "time_slot_id" : "\(UserDefaults.standard.value(forKey: "TimeSelect")!)",
                    "time_slot_name" : "\(UserDefaults.standard.value(forKey: "time_slot_name")!)",
                    "delivery_date" : "\(UserDefaults.standard.value(forKey: "Date_slot_name")!)",
                    "shipping_address_id" :  "\(DataCollection?.value(forKey: "address_id") as! String)",

                    "total_product_count" : "\(Product_count!)",


             
                
                   
                    
//                    "payment_type" : "paytm",
                    
                    
                ]
                
                print(dict)
            
                Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
                
                
                
                
                self.dataModel.GetPayTmApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
                    
                    
                    self.stopAnimating()
                    
                    
                    if data.1 as String == "FAILURE"{
                        self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                        
                    }
                    else{
                        
                        let dataBanner = data.0
                        
                        
                        
                        if dataBanner.value(forKey: "status") as! String == "Success" {
                            
                            
                            
                            
                            
                            
                            
                            
                                self.stopAnimating()
                                
            
                              
                                
                                    
                                    
                                    
                                
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayTmViewController") as! PayTmViewController
                                        //
                                        
//                                        vc.Paid_Amount = self.AmountPayable!
                                        vc.Paid_Amount = self.AmountPayable
                                        vc.Payee_Name = self.userName!
                                        vc.Product_ID = (dataBanner as AnyObject).value(forKey: "order_id") as! String
//                                    vc.Product_ID = "order_ios_\(txnid1)"
                                        self.present(vc, animated: true, completion: nil)
                                        
                                
                        }
                            
                        else {
                            
                            
                                                     self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                            //                // print(data1)
                            
                            
                        }
//
                    
                    }
                }
            
//
            
                
                
                
                
                
                
                
                
            
            
            
            //Step 1: Create a default merchant config object
            
           

                       }
        
       else {
            
        
        if btnContinue.backgroundColor == #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1) {
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            var Baseurl = "apiCheckout.php"
            //        :TEST101
            //        total_amt:300
            
//            
//            city_id:1
//            customer_id:14
//            payment_type:cashondelivery
//            payment_gateway_id:
//            payment_status:pending
//            total_amount:510
//            discount_amount:0
//            time_slot_id:1
//            time_slot_name:9 AM to 12 PM
//            shipping_address_id:9

            
            let dict = [
                "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
                "customer_id" : UserDefaults.standard.value(forKey: "id")! ,
                "payment_type" : PayBy ,
                "payment_gateway_id" : "" ,
                "payment_status" : "pending" ,
                "total_amount" : AmountPayable! ,
                "discount_amount" : Discount_amount,
                "time_slot_id" : UserDefaults.standard.value(forKey: "TimeSelect")! ,
                "time_slot_name" : UserDefaults.standard.value(forKey: "time_slot_name")! ,
                "shipping_address_id" : shipping_address_id ,

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
                    
                    
                    
                    if (dataBanner as AnyObject).value(forKey: "status") as? String == "Success" {
//                        let data1 = data.0[0]

                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                        
                        vc.Msg = ((dataBanner as AnyObject).value(forKey: "success_message")  as! NSString) as String
                        
                        self.present(vc, animated: true, completion: nil)
//                          self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "success_message")  as! NSString)
                        
                        
                       
                        
                        
                    }
                        
                    else if (dataBanner as AnyObject).value(forKey: "status") as? String != nil{
                        
                        
//                         self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                        //                // print(data1)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailViewController") as! FailViewController
                        
                        vc.Msg = ((dataBanner as AnyObject).value(forKey: "status")  as! NSString) as String
                        
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    
                    
                }
            }

        }
        else{
            ShowAlertOK(sender: "Select Payment")
        }
        
        }
        }
    }
    
 
    func createSHA512(_ string: String) -> String {
        
        let cstr = string.cString(using: String.Encoding.utf8)
        var data = Data(bytes: cstr!, count: string.characters.count)
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        
        data.withUnsafeBytes {
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        }
        
        let output = NSMutableString(capacity: Int(CC_SHA512_DIGEST_LENGTH*2))
        
        for i in 0..<Int(CC_SHA512_DIGEST_LENGTH) {
            
            output.appendFormat("%02x", digest[i])
        }
        return output as String
        
    }
    

    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

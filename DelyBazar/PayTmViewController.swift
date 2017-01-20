//
//  PayTmViewController.swift
//  DelyBazar
//
//  Created by OSX on 26/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class PayTmViewController: UIViewController , PGTransactionDelegate , NVActivityIndicatorViewable {
    var dataModel = DataModel()

    @IBOutlet weak var viewPtm: UIView!
    var Product_ID = ""
    var Paid_Amount = "00"
    var Payee_Name = ""
    var Payee_Email = ""
    var CUST_ID = ""

    
    var TXN_AMOUNT = ""
    var TXNID = ""
    var ORDER_ID = ""
    var CUST_ID_r = ""
    var RESPCODE = ""
    var RESPMSG = ""

    var txnController = PGTransactionViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mc: PGMerchantConfiguration = PGMerchantConfiguration.default()
        
//        mc.checksumGenerationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp"
//        mc.checksumValidationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"

        mc.checksumGenerationURL = "http://delybazar.in/mobile-app/sample_checksum.php"
        mc.checksumValidationURL = "http://delybazar.in/mobile-app/verifyChecksum.php"
        

        let dict = [
            
//            "MERCHANT_KEY" : "lbIceDOqIId_5M0p",
            "MID" : "Online14759468219727",//   ""
//            "MID" : "WorldP64425807474247",
            "CHANNEL_ID" : "WAP",
            "INDUSTRY_TYPE_ID" : "Retail",
            "WEBSITE" : "DbazarWAP",  
//            "WEBSITE" : "worldpressplg",
            "TXN_AMOUNT" : Paid_Amount, // "121"
            "ORDER_ID" : Product_ID,
            "REQUEST_TYPE" : "DEFAULT",
            "CUST_ID" :  "\(UserDefaults.standard.value(forKey: "id")!)",
//            "CALLBACK_URL" : "http://delybazar.in/mobile-app/verifyChecksum.php",

            ] as [String : String]
            print(dict)
        
        let order: PGOrder = PGOrder(params: dict)
        
        
        
        self.txnController = PGTransactionViewController.init(transactionFor: order)
//        PGServerEnvironment.selectServerDialog(self.view, completionHandler: {(type: ServerType) -> Void in
            self.txnController = PGTransactionViewController(transactionFor: order)

            self.txnController.serverType = eServerTypeStaging
            self.txnController.merchant = mc
            self.txnController.delegate = self
//            self.txnController.
            self.showController(self.txnController)
//
//            if type != eServerTypeNone {
//                self.txnController.serverType = type
//                self.txnController.merchant = mc
//                self.txnController.delegate = self
////                self.txnController.loggingEnabled = true
////                self.txnController.sendAllChecksumResponseParamsToPG = true
//                self.showController(self.txnController)
//            }
//        })

        // Do any additional setup after loading the view.
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var back: UIButton!
    @IBAction func Back(_ sender: Any) {
        
        
        
        
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiPaytmReturn.php"
        
        
        
        let dict = [
            
            "TXN_AMOUNT" : Paid_Amount ,
            "TXNID" : ""  ,
            "ORDER_ID" : Product_ID ,
            "CUST_ID" : CUST_ID ,
            "RESPCODE" : "141"  ,
            "RESPMSG" : "Transaction cancelled by customer after landing on Payment Gateway Page." ,
            
            
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
                
                
               
                    
                    
                    //                         self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    //                // print(data1)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailViewController") as! FailViewController
                    
                    vc.Msg = ((dataBanner as AnyObject).value(forKey: "success_message")  as! NSString) as String
                    
                    self.present(vc, animated: true, completion: nil)
                    
                
                
                
            }
        }
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: Delegate methods of Payment SDK.
    func didSucceedTransaction(_ controller: PGTransactionViewController, response: [AnyHashable: Any]) {
        
        // After Successful Payment
        
        print("ViewController::didSucceedTransactionresponse= %@", response)
        let msg: String = "Your order was completed successfully.\n Rs. \(response["TXNAMOUNT"]!)"
        
//        self.removeController(txnController)
        
        TXN_AMOUNT = response["TXNAMOUNT"] as! String
        TXNID = response["TXNID"] as! String
        ORDER_ID = response["ORDERID"] as! String
        CUST_ID_r = CUST_ID
        RESPCODE = response["RESPCODE"] as! String
        RESPMSG = response["RESPMSG"] as! String

      
       
        sendResponse()
        
    }
    
    public func didFailTransaction(_ controller: PGTransactionViewController!, error: Error!, response: [AnyHashable : Any]!) {
        // Called when Transation is Failed
        print("ViewController::didFailTransaction error = %@ response= %@", error, response)
        //        self.removeController(txnController)
        
        if (response != nil) {
            let json = response as NSDictionary
            
            
            ShowAlertOK(sender: json.value(forKey: "RESPMSG") as! NSString)
            
        }
        else if (error != nil) {
            
            
            
        }
        
        
    }
    func ShowAlertOK(sender : NSString)  {
        
        let alert = UIAlertController(title: "Alert", message: sender as String, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailViewController") as! FailViewController
            
            vc.Msg = "Sorry ! Your order has not been completed Succesfully.\nPlease contact our customer support on 03368888007.\nIf you are facing any issue while placing an order.\n\nWe shall be happy to help you"
            
            self.present(vc, animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    func showController(_ controller: PGTransactionViewController) {
        
        if self.navigationController != nil {
            self.navigationController!.pushViewController(controller, animated: true)
        }
        else {
            
         self.displayContentController(content: controller)
            
//            self.present(controller, animated: true, completion: {() -> Void in
//            })
//            
            
            
            
            
            
            
            
            
        }
    }
    func displayContentController(content: UIViewController) {
        addChildViewController(content)
        self.viewPtm.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    func removeController(_ controller: PGTransactionViewController) {
        if self.navigationController != nil {
            self.navigationController!.popViewController(animated: true)
        }
        else {
            
            
            
            
            controller.dismiss(animated: true, completion: {() -> Void in
            })
        }
    }
    
    public func didCancelTransaction(_ controller: PGTransactionViewController!, error: Error!, response: [AnyHashable : Any]!) {
        
        //Cal when Process is Canceled
        var msg: String? = nil
        //        self.removeController(txnController)
        
        if (error != nil) {
            
            msg = String(format: "Successful")
        }
        else {
            msg = String(format: "UnSuccessful")
        }
        
        
        
        
    }
    
    func didFinishCASTransaction(_ controller: PGTransactionViewController, response: [AnyHashable: Any]) {
        
        print("ViewController::didFinishCASTransaction:response = %@", response);
        
    }
    func sendResponse()  {
        
        
            
            
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            var Baseurl = "apiPaytmReturn.php"
            
            
            
            let dict = [
                
                "TXN_AMOUNT" : TXN_AMOUNT ,
                "TXNID" : TXNID  ,
                "ORDER_ID" : ORDER_ID ,
                "CUST_ID" : CUST_ID_r ,
                "RESPCODE" : RESPCODE  ,
                "RESPMSG" : RESPMSG ,

                
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
                        
                        
                        
                    }
                        
                    else if (dataBanner as AnyObject).value(forKey: "status") as? String != nil{
                        
                        
                        //                         self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                        //                // print(data1)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailViewController") as! FailViewController
                     vc.Msg = ((dataBanner as AnyObject).value(forKey: "success_message")  as! NSString) as String
                        
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    
                    
                }
            }
        
        
        
    }

    //        let dict1 = [
    //
    //            //            "MERCHANT_KEY" : "lbIceDOqIId_5M0p",
    //            "MID" : "Online14759468219727",
    //            "CHANNEL_ID" : "WAP",
    //            "INDUSTRY_TYPE_ID" : "Retail",
    //            "WEBSITE" : "delybazarweb",
    //            "TXN_AMOUNT" : "1",
    //            "ORDER_ID" : Product_ID,
    ////            "REQUEST_TYPE" : "DEFAULT",
    //            "CUST_ID" :  "\(UserDefaults.standard.value(forKey: "id")!)",
    //            "CALLBACK_URL" :"http://delybazar.in/mobile-app/verifyChecksum.php",
    //            "EMAIL" : "jaipreetsingh.orem@gmail.com",
    //            "MOBILE_NO" : "9888801596",
    //            "THEME" : "merchant",
    ////            "time_slot_name" : "\(UserDefaults.standard.value(forKey: "time_slot_name")!)",
    ////            "payment_type" : "paytm",
    ////            "delivery_date" : "\(UserDefaults.standard.value(forKey: "Date_slot_name")!)",
    ////            "total_product_count" : "5",
    //            
    //            ] as [String : String]
    //
    //
    
}

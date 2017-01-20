//
//  PayUMoneyViewController.swift
//  DelyBazar
//
//  Created by OSX on 13/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class PayUMoneyViewController: UIViewController , UIWebViewDelegate , NVActivityIndicatorViewable {
    @IBOutlet weak var webviewPaymentPage: UIWebView!
    var activityIndicator : NVActivityIndicatorView?

    
    var Merchant_Key = "kgaqj9"
    var Merchant_ID = "4928174"
    var Salt = "8BUUrpjV"
    var Base_URL = "https://secure.payu.in"
    var Success_URL = "http://delybazar.in/mobile-app/apiPayumoney_Success.php"
    var Failure_URL = "http://delybazar.in/mobile-app/apiPayumoney_Failure.php"
    var Product_Info = ""
    var Paid_Amount = "00"
    var Payee_Name = ""
    var Payee_Number = ""

    var Payee_Email = ""
    var Shipping_address : String = ""
    var Total_Count = ""
    var order_id = ""
    var Api_hash = ""
    var status = ""

    var dataModel = DataModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.center = self.view.center
        activityIndicatorView.color = UIColor.black
        self.view.addSubview(activityIndicatorView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        
        
        
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiPayumoney_Failure.php"
        
        
        
        let dict = [
            
            "txnid" : self.strMIHPayID ,
            "mihpayid" : ""  ,
            "amount" : Paid_Amount ,
            
            
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
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailViewController") as! FailViewController
                
                vc.Msg = "Sorry ! Your order has not been completed Succesfully.\nPlease contact our customer support on 03368888007.\nIf you are facing any issue while placing an order.\n\nWe shall be happy to help you"
                
                self.present(vc, animated: true, completion: nil)
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String == "Order Failure" {
                    //                        let data1 = data.0[0]
                    
                    
                    
//                    self.dismiss(animated: true, completion: nil)

                }
                    
                    
                    
                    
                    
                else if (dataBanner as AnyObject).value(forKey: "status") as? String != nil{
                    
                    
//                   self.dismiss(animated: true, completion: nil)
                    
                }
                
                
            }
        }
    }
    
    var activityIndicatorView: UIActivityIndicatorView!
    var strMIHPayID = ""
    
   
    var mutDictTransactionDetails : NSMutableDictionary!
//    let Merchant_Key = "gtKFFx"
//    let Salt = "eCwWELxi"
//    let Base_URL = "https://test.payu.in"
//    let Success_URL = "https://www.google.co.in/"
//    let Failure_URL = "http://www.bing.com/"
//    let Product_Info = "Denim Jeans"
//    let Paid_Amount = "1549.00"
//    let Payee_Name = "Suraj Mirajkar"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Make A Payment"
        self.initPayment()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.title = ""
    }
    
    func initPayment() {
        let i = arc4random() % 999999999
        _ = self.createSHA512("\(i)\(Date())")
//         Generatehash512(rnd.ToString() + DateTime.Now);
        let txnid1 = order_id
//        let txnid1 = strHash.substring(to: strHash.index(strHash.startIndex, offsetBy: 20))

//        let txnid1 = "ODDB-38010"
        strMIHPayID = txnid1
        let key = Merchant_Key
        let amount = Paid_Amount
        let productInfo = Product_Info
        let firstname = Payee_Name
//         let email = "jaipreetsingh.orem@gmail.com"
                let email = UserDefaults.standard.string(forKey: "email")!
        // Generated a fake mail id for testing
        let phone = UserDefaults.standard.value(forKey: "mobile_no")!
        let serviceprovider = "payu_paisa"
        let hashValue = "\(key)|\(txnid1)|\(amount)|\(productInfo)|\(firstname)|\(email)|||||||||||\(Salt)"
        
//        NSString *hashValue = [NSString stringWithFormat:"%@|%@|%@|%@|%@|%@|||||||||||%@",key,txnid1,amount,productInfo,firstname,email,Salt];

        
        let hash = self.createSHA512(hashValue)

        let add_id : String = (Shipping_address)
        
        let parameters : NSDictionary = ["txnid": txnid1 ,
                                         "key" : key ,
                                         "amount" :amount ,
                                         "productInfo" :productInfo,
                                         "firstname" :firstname,
                                         "email" :email,
                                         "phone": phone,
                                         "surl": Success_URL,
                                         "furl": Failure_URL,
                                         "hash" : hash,
                                         "service_provider": serviceprovider,
//                                         "udf5" : "",
//                                         "udf4" : "\(Total_Count)",
//            "udf3" : add_id ,
//            "udf2" :"\( UserDefaults.standard.value(forKey: "city_id")!)" ,
//            "udf1" :  "\(UserDefaults.standard.value(forKey: "id")!)",
        ]
        print(parameters)
        
        var post = "http://delybazar.in/mobile-app/payumoney_hash.php"
        parameters.enumerateKeysAndObjects({ (key, obj, stop) -> Void in
            if (post == "") {
                post = "\(key)=\(obj)"
            }
            else {
                post = "\(post)&\(key)=\(obj)"
            }
        })
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let postLength = "\(UInt((postData?.count)!))"
        let request = NSMutableURLRequest()
        request.url = URL(string: "\(Base_URL)/_payment")!
        request.httpMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Current-Type")
        request.httpBody = postData
        webviewPaymentPage.loadRequest(request as URLRequest)
        activityIndicatorView.startAnimating()
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
    //#pragma UIWebView - Delegate Methods
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("WebView started loading")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorView.stopAnimating()
        if webView.isLoading {
            return
        }
        let requestURL = webviewPaymentPage.request?.url!
        print("WebView finished loading with requestURL: \(requestURL)")
        let getStringFromUrl = "\(requestURL!)"
        if self.contains(getStringFromUrl, substring: Success_URL) {
            self.perform(#selector(self.delayedDidFinish), with: getStringFromUrl)
            print("WebView finished loading with description: \(webviewPaymentPage.request)")

            
            //            self.performwithSelector(#selector(self.delayedDidFinish), withObject: getStringFromUrl, afterDelay: 0.0)
        }
        else if self.contains(getStringFromUrl, substring: Failure_URL) {
            // FAILURE ALERT

            self.status = "Failure"
            self.sendResponse()
            
        }
        
    }
    
    
    
    func sendResponse()  {
        
        if self.status == "Success" {

        
        
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiPayumoney_Success.php"

          
        
        let dict = [
            
            "txnid" : self.strMIHPayID ,
            "mihpayid" : self.strMIHPayID  ,
            "amount" : Paid_Amount ,
            
            
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
                
                
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String == "Order Success" {
                    //                        let data1 = data.0[0]
                    
                    
            
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                    
                    vc.Msg = ((dataBanner as AnyObject).value(forKey: "message") as? String)!
                    
                    self.present(vc, animated: true, completion: nil)
   
                
                    
                    
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
            
            
            
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
            var Baseurl = "apiPayumoney_Failure.php"
            
            
            
            let dict = [
                
                "txnid" : self.strMIHPayID ,
                "mihpayid" : self.strMIHPayID  ,
                "amount" : Paid_Amount ,
                
                
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
                    
                    
                    
                    if (dataBanner as AnyObject).value(forKey: "status") as? String == "Order Failure" {
                        //                        let data1 = data.0[0]
                        
                        
                   
                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailViewController") as! FailViewController
                        
                                               vc.Msg = "Sorry ! Your order has not been completed Succesfully.\nPlease contact our customer support on 03368888007.\nIf you are facing any issue while placing an order.\n\nWe shall be happy to help you"
                        
                                                self.present(vc, animated: true, completion: nil)
                        //
                                            }
                    
                        
                        
                    
            
                    else if (dataBanner as AnyObject).value(forKey: "status") as? String != nil{
                        
            
                                                 self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                                        // print(data1)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailViewController") as! FailViewController
                        
                        vc.Msg = "Sorry ! Your order has not been completed Succesfully.\nPlease contact our customer support on 03368888007.\nIf you are facing any issue while placing an order.\n\nWe shall be happy to help you"
                        
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    
                    
                }
            }
        }
        
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicatorView.stopAnimating()
        let requestURL = webviewPaymentPage.request?.url!
        print("WebView failed loading with requestURL: \(requestURL) with error: \(error.localizedDescription) & error code: \(Int(error._code))")
        if error._code == -1009 || error._code == -1003 || error._code == -1001 {
            //error.code == -999
//            let alert = UIAlertView(title: "Oops !!!", message: "Please check your internet connection!", delegate: self, cancelButtonTitle: "", otherButtonTitles: "OK")
//            alert.tag = 1
//            alert.show()
            
            ShowAlertOK(sender:  "Please check your internet connection!")
            
        }
    }
    func ShowAlertOK(sender : NSString)  {
        
        
        
        
        let alert = UIAlertController(title: "Alert", message: sender as String, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
//            
//            let mutDictTransactionDetails = [
//                "Transaction_ID" : self.strMIHPayID,
//                "Transaction_Status" : "Failed",
//                "Payee_Name" : self.Payee_Name,
//                "Product_Info" : self.Product_Info,
//                "Paid_Amount" : self.Paid_Amount,
//                ] as NSMutableDictionary
//            self.navigate(toPaymentStatusScreen: mutDictTransactionDetails)
//            self.status = "Failure"
//            self.sendResponse()
//            self.dismiss(animated: true, completion: nil)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailViewController") as! FailViewController
            
            vc.Msg = "Sorry ! Your order has not been completed Succesfully.\nPlease contact our customer support on 03368888007.\nIf you are facing any issue while placing an order.\n\nWe shall be happy to help you"
            
            self.present(vc, animated: true, completion: nil)

            
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    func delayedDidFinish(_ getStringFromUrl: String) {
        
//        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
//        
//        vc.Msg = "Success"
//        self.present(vc, animated: true, completion: nil)

        self.status = "Success"
        self.sendResponse()
        
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            let mutDictTransactionDetails = [
                "Transaction_ID" : self.strMIHPayID,
                "Transaction_Status" : "Success",
                "Payee_Name" : self.Payee_Name,
                "Product_Info" : self.Product_Info,
                "Paid_Amount" : self.Paid_Amount,
                ] as NSMutableDictionary
            self.navigate(toPaymentStatusScreen: mutDictTransactionDetails)
        })
        
    }
    
  
    func contains(_ string: String, substring: String) -> Bool {
        return(string as NSString).range(of:substring).location != NSNotFound
    }
    
    func navigate(toPaymentStatusScreen mutDictTransactionDetails: NSMutableDictionary) {
//        DispatchQueue.main.async(execute: {() -> Void in
//            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let paymentStatusVC: PaymentOptionViewController = storyboard.instantiateViewController(withIdentifier: "PaymentOptionViewController") as! PaymentOptionViewController
//            
//            paymentStatusVC.DictTransactionDetails = mutDictTransactionDetails
//            self.present(paymentStatusVC, animated: true, completion: nil)
//            
//        })
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

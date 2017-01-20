//
//  DataModel.swift
//  BnkUp
//
//  Created by OSX on 04/10/16.
//  Copyright © 2016 Jaipreet. All rights reserved.
//

import Alamofire
import UIKit


typealias CompletionBlock = (_ result: Any, _ error: NSError?) -> Void




class DataModel: NSObject {

    
    //blocks
    var completion: CompletionBlock = { result, error in print(error) }
    

    
    func GetCatApi( Url: NSString, withCompletionHandler:@escaping (_ result:NSDictionary ) -> Void) {
        
    
        
        
        Alamofire.request("http://webmantechnologies.com/himanshu/Workspot/api/apis/category?lang=\(Url)").responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary )
            }
        }//
//        
            }
    func GetCancelOptionApi( Url: NSString, withCompletionHandler:@escaping (_ result:NSDictionary ) -> Void) {
        
        
        
        
        Alamofire.request("http://delybazar.com/mobile-app/apiCancelReason.php").responseJSON { response in
            //            print(response.request)  // original URL request
            //            print(response.response) // HTTP URL response
            //            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary )
            }
        }//
        //        
    }

    
    func GetRegisterApi( Url: NSString, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/apiCity.php/"
        
        var url = "\(Baseurl)\(Url)"
        

        
       url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post).responseJSON { response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString )
            }
            else{
//                withCompletionHandler()
//                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )

            }
        }//
        //
    }
    
    func GetApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
              // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                
                let DictJson = arr[0] as! NSDictionary
                
                withCompletionHandler( DictJson , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }
    
    func GetPaytmApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
               
                
                let DictJson = JSON
                
                withCompletionHandler( DictJson as! NSDictionary , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }
    
    func GetPayuMoneyApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSDictionary
                
                let DictJson = arr 
                
                withCompletionHandler( DictJson , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }
    func GetPayTmApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                
                let DictJson = arr[0]
                
                withCompletionHandler( DictJson as! NSDictionary , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }
    func GetBannerApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
//                let dict = arr[0] as? NSDictionary
//                try dict?.value(forKey: "status"){
//                    
//                }
//                catch{
//                    
//                }
               
                
//                do {
//                    contents = try dict?.value(forKey: "status") as! NSString?
//                } catch _ {
//                    contents = nil
//                }
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error"] 
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        //
    }
    func GetCatListApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                //                let dict = arr[0] as? NSDictionary
                //                try dict?.value(forKey: "status"){
                //
                //                }
                //                catch{
                //
                //                }
                
                
                //                do {
                //                    contents = try dict?.value(forKey: "status") as! NSString?
                //                } catch _ {
                //                    contents = nil
                //                }
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        //
    }

    func GetProduct_ListApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                //                let dict = arr[0] as? NSDictionary
                //                try dict?.value(forKey: "status"){
                //
                //                }
                //                catch{
                //
                //                }
                
                
                //                do {
                //                    contents = try dict?.value(forKey: "status") as! NSString?
                //                } catch _ {
                //                    contents = nil
                //                }
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        //
    }

    
    
    func GetCancelApi( Url: NSString, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: nil).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                //                let dict = arr[0] as? NSDictionary
                //                try dict?.value(forKey: "status"){
                //
                //                }
                //                catch{
                //
                //                }
                
                
                //                do {
                //                    contents = try dict?.value(forKey: "status") as! NSString?
                //                } catch _ {
                //                    contents = nil
                //                }
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        //
    }

    func GetLowerBannerApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                //                let dict = arr[0] as? NSDictionary
                //                try dict?.value(forKey: "status"){
                //
                //                }
                //                catch{
                //
                //                }
                
                
                //                do {
                //                    contents = try dict?.value(forKey: "status") as! NSString?
                //                } catch _ {
                //                    contents = nil
                //                }
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        //
    }

    func GetCatApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
      
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
             
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        
    }
    func GetRecentApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        
    }
    func GetTimeSlotApi( Url: NSString , withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: nil).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        
    }
    
    func GetHomeCatApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        
        //Allow cookies if needed.
        config.httpCookieStorage = HTTPCookieStorage.shared
        
        
        
        
        

        //Create a manager with the non-caching configuration that you created above.
//          let manager = Alamofire
        
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        
    }
    func GetHomeCartCountApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        
    }
    func GetDiscountApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                //                let dict = arr[0] as? NSDictionary
                //                try dict?.value(forKey: "status"){
                //
                //                }
                //                catch{
                //
                //                }
                
                
                //                do {
                //                    contents = try dict?.value(forKey: "status") as! NSString?
                //                } catch _ {
                //                    contents = nil
                //                }
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        //
    }

    func GetPriceApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                //                let dict = arr[0] as? NSDictionary
                //                try dict?.value(forKey: "status"){
                //
                //                }
                //                catch{
                //
                //                }
                
                
                //                do {
                //                    contents = try dict?.value(forKey: "status") as! NSString?
                //                } catch _ {
                //                    contents = nil
                //                }
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        //
    }
    func GetbrandApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSArray , _ Error : NSString ) -> Void) {
        
        let Baseurl = "http://delybazar.com/mobile-app/"
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let arr = JSON as! NSArray
                //                let dict = arr[0] as? NSDictionary
                //                try dict?.value(forKey: "status"){
                //
                //                }
                //                catch{
                //
                //                }
                
                
                //                do {
                //                    contents = try dict?.value(forKey: "status") as! NSString?
                //                } catch _ {
                //                    contents = nil
                //                }
                
                
                
                withCompletionHandler( arr , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error"]
                withCompletionHandler( JSON as NSArray  , response.result.description as NSString )
                
            }
        }//
        //
    }


    func GetRegApi( urlString: NSString, dict: NSDictionary , withCompletionHandler:@escaping (_ result:NSDictionary ) -> Void) {
        let request = Alamofire.request("https://httpbin.org/get", parameters: ["foo": "bar"])

//        Alamofire.request(urlString, method: .get, parameters: dict, encoding: JSONEncoding.default)
//            .downloadProgress(queue: DispatchQueue.utility) { progress in
//                print("Progress: \(progress.fractionCompleted)")
//            }
//            .validate { request, response, data in
//                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
//                return .success
//            }
//            .responseJSON { response in
//                debugPrint(response)
//        }
    }

   
}

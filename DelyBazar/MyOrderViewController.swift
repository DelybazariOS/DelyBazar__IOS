//
//  MyOrderViewController.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MyOrderViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource , NVActivityIndicatorViewable {

    @IBOutlet weak var btnMyCart: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var DataOrderList : NSMutableArray? = []
    
    
    var activityIndicatorView : NVActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 150
        
              // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(UINib(nibName: "myorderTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        if (UserDefaults.standard.string(forKey: "city_id") == nil) {
        }
        else
        {
            GetCartCountData()
            GetData()
        }

    }
    @IBAction func ActionMyCart(_ sender: Any) {
        
        if btnMyCart.title(for: .normal)! as String == "0"{
            ShowAlertOK(sender: "There is no item in the cart")
        }
        else{
            
            
            let CVC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            self.present(CVC, animated: true, completion: nil)
        }
    }
    func GetCartCountData()  {
        var Baseurl = "apiCartCount.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!
//            "customer_id" : "20" ,

            //            "city_id" : "1"
        ]
        
        
        print(dict)
        
        
        
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
                    
                    
                    self.btnMyCart.setTitle((dataCart as AnyObject).value(forKey: "total_cart") as? String , for: .normal)
                    
                    
                }
                
                
            }
        }
        
    }

    func GetData()  {
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiListingOrder.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")! ,
//                        "customer_id" : "20" ,

            ]
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        
        
        self.dataModel.GetBannerApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            self.stopAnimating()
            
            
            if data.1 as String == "FAILURE"{
                //                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataBanner = data.0[0]
                
                self.DataOrderList?.removeAllObjects()
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String == "No Orders Available" {
                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    //                                        self.DataSubCat?.removeAllObjects()
                    //                                        self.ArrRecentName.removeAllObjects()
                    // print("banner  \(data.0.count)")
                    
                    
                    for i in 0...data.0.count - 1 {
                        self.DataOrderList?.add(data.0[i])
                        
                        
                    }
                    self.tableView.reloadData()
                    
                    //                // print(data1)
                    
                    
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

    
    @IBAction func backbutton(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        
      
        
        self.present(vc, animated: true, completion: nil)

        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (DataOrderList?.count)!
        return (DataOrderList?.count)!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! myorderTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        let data = DataOrderList?[indexPath.row] as? NSDictionary
        
        cell.cost.text = "Total Amount ₹\((data?.value(forKey: "total_amt")! as! String?)!)"
        cell.noItems.text = "\((data?.value(forKey: "product_count")! as! String?)!) items"
        cell.OrderTime.text = data?.value(forKey: "ordered_date")! as! String?
        cell.OrderId.text = data?.value(forKey: "purchase_id")! as! String?

//        cell.RTime.text = data?.value(forKey: "slot_name")! as! String?
        
        let status = data?.value(forKey: "order_status")! as! String?
        cell.RTime.isHidden = true

        if status == "Received" {
            cell.status.textColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
            cell.DDate.text = "Delivery On \(getDayOfWeek(today: (data?.value(forKey: "delivery_date")! as! String?)!))"
            cell.DDate.isHidden = false
//            cell.RTime.isHidden = false


        }
        else  if status == "Processing" {
            cell.status.textColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
            cell.DDate.text = "Delivery On \(getDayOfWeek(today: (data?.value(forKey: "delivery_date")! as! String?)!))"
            cell.DDate.isHidden = false
            //            cell.RTime.isHidden = false
            
            
        }
        else  if status == "Delivered" {
            cell.status.textColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
            cell.DDate.text = "Delivered On \(getDayOfWeek(today: (data?.value(forKey: "delivery_date")! as! String?)!))"
            cell.DDate.isHidden = false
            //            cell.RTime.isHidden = false
            
            
        }


        else if status == "Canceled" {
            cell.status.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
//            cell.DDate.text = "Delivered On \((data?.value(forKey: "delivery_date")! as! String?)!)"
            cell.DDate.isHidden = true
            cell.RTime.isHidden = true
        }
        else{
            cell.status.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            cell.DDate.text = "Delivered On \(getDayOfWeek(today: (data?.value(forKey: "delivery_date")! as! String?)!))"
            cell.DDate.isHidden = true

//            cell.DDate.isHidden = false
//            cell.RTime.isHidden = false
        }
        
        cell.status.text = data?.value(forKey: "order_status")! as! String?

        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               let data = DataOrderList?[indexPath.row] as? NSDictionary

        
        let status = data?.value(forKey: "order_status")! as! String?

        if status != "Payment Failure" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderDetailViewController") as! orderDetailViewController
            vc.order_id = (data?.value(forKey: "order_id")! as! String?)!
            self.present(vc, animated: true, completion: nil)

        }
        
        
        
        
        
    }
    func getDayOfWeek(today:String)->String {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponentsday = myCalendar.components(.day, from: todayDate)
        let myComponentsMonth = myCalendar.components(.month, from: todayDate)
        let myComponentsYear = myCalendar.components(.year, from: todayDate)
        let myComponentsdayStr = myCalendar.components(.day, from: todayDate)

        let weekDay = myComponentsdayStr.weekdayOrdinal
        let month = myComponentsMonth.month
        let day = myComponentsday.day
        let year = myComponentsYear.year
        
        let c = NSDateComponents()
        c.year = year!
        c.month = month!
        c.day = day!
        
        formatter.dateStyle = .full
        
        let date = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: c as DateComponents)

        
        let cdate = formatter.string(from: date!)
        
        return cdate
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

//
//  orderDetailViewController.swift
//  DelyBazar
//
//  Created by OSX on 07/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class orderDetailViewController: UIViewController ,NVActivityIndicatorViewable , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var LblSubTotal: UILabel!
    @IBOutlet weak var btnCancelOrder: UIButton!
    @IBOutlet weak var lblCanceled: UILabel!
    @IBOutlet weak var lblCancelTitle: UILabel!
    @IBOutlet weak var lblBwOrdAndPro: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblBwProAndDel: UILabel!
    @IBOutlet weak var imgDelivered: UIImageView!
    @IBOutlet weak var imgProcessing: UIImageView!
    @IBOutlet weak var imgOrderReceived: UIImageView!
    @IBOutlet weak var viewUnderLine: UIView!
    @IBOutlet weak var btnItems: UIButton!
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var lblShippingAddress: UILabel!
    @IBOutlet weak var lblDeliveryType: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblShippingCost: UILabel!
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var btnReplacement: UIButton!
    @IBOutlet weak var btnRefund: UIButton!
    
    @IBOutlet weak var bgDarkView: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var OptionView: UIView!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var txtComment: UITextView!
    
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var DataOrder : NSMutableArray? = []
    var DataOption : NSMutableArray? = []

    var activityIndicatorView : NVActivityIndicatorView?
    var order_id : String = ""

    var cancelOption : String = ""
    var purchase_id : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "ItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
       GetData()
        
        btnSubmit.setTitle("Next", for: .normal)
        
        // Do any additional setup after loading the view.
    }
    func GetData()  {
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiOrderDetails.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")! ,
//            "customer_id" : "20" ,

            "order_id" : order_id
            
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
                
                self.DataOrder?.removeAllObjects()
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String == "Mobile No is Aready Exists" {
                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    //                                        self.DataSubCat?.removeAllObjects()
                    //                                        self.ArrRecentName.removeAllObjects()
                    // print("banner  \(data.0.count)")
                    
                    
                    self.lblShippingAddress.text = "\(((dataBanner as AnyObject).value(forKey: "shipping_address") as? String)!), \(((dataBanner as AnyObject).value(forKey: "shipping_city") as? String)!), \(((dataBanner as AnyObject).value(forKey: "shipping_pincode") as? String)!) "
                    
                    self.lblDeliveryType.text = (dataBanner as AnyObject).value(forKey: "payment_type") as? String
                    let status = (dataBanner as AnyObject).value(forKey: "order_status") as? String

                    if status == "Payment Failure" {
                    
                    let sub_to = Int((dataBanner as AnyObject).value(forKey: "total_amt") as! String)
                    let dis_to = Int((dataBanner as AnyObject).value(forKey: "discount_amount") as! String)

                    let total_am : Int = sub_to! + dis_to!
                    
                    self.LblSubTotal.text = "\(total_am)"

                    
                    self.lblTotalCost.text = (dataBanner as AnyObject).value(forKey: "total_amt") as? String
                    
                    
                    }
                    
                    self.lblDiscount.text = (dataBanner as AnyObject).value(forKey: "discount_amount") as? String
                    self.purchase_id = ((dataBanner as AnyObject).value(forKey: "purchase_id") as? String)!
                    
                    
//                    self.lblDeliveryType.text = (dataBanner as AnyObject).value(forKey: "payment_type") as? String
//                    self.lblDeliveryType.text = (dataBanner as AnyObject).value(forKey: "payment_type") as? String

                   

                    if status == "Received" {
                        self.imgOrderReceived.image = #imageLiteral(resourceName: "ic_button_on")
                        self.imgDelivered.image = #imageLiteral(resourceName: "ic_button_off")
                        self.imgProcessing.image = #imageLiteral(resourceName: "ic_button_off")
                        self.lblBwOrdAndPro.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                        self.lblBwProAndDel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                        self.lblCanceled.isHidden = true

                    }
                    else  if status == "Processing" {
                        self.imgOrderReceived.image = #imageLiteral(resourceName: "ic_button_on")
                        self.imgDelivered.image = #imageLiteral(resourceName: "ic_button_off")
                        self.imgProcessing.image = #imageLiteral(resourceName: "ic_button_on")
                        self.lblBwOrdAndPro.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
                        self.lblBwProAndDel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                        self.lblCanceled.isHidden = true

                    }
                    else  if status == "Cancelled" {
                        self.lblCanceled.isHidden = false
                    self.btnRefund.isHidden = true
                        self.lblCanceled.text = "Cancelled"

                        self.btnReplacement.isHidden = true
                        self.btnCancelOrder.isHidden = true

                    }
                    else  if status == "Payment Failure" {
                        self.lblCanceled.isHidden = false
                        self.lblCanceled.text = "Payment Failure"
                        self.btnRefund.isHidden = true
                        self.btnReplacement.isHidden = true
                        self.btnCancelOrder.isHidden = true
                        
                    }

                    else if status == "Delivered"
                    {
                        self.imgOrderReceived.image = #imageLiteral(resourceName: "ic_button_on")
                        self.imgDelivered.image = #imageLiteral(resourceName: "ic_button_on")
                        self.imgProcessing.image = #imageLiteral(resourceName: "ic_button_on")
                        self.lblBwOrdAndPro.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
                        self.lblBwProAndDel.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
                        self.lblCanceled.isHidden = true

                    }
                    
                    let da = (dataBanner as AnyObject).value(forKey: "product_list") as? NSArray
                    
                    if (da != nil) {
                    
                    
                    for i in 0...(da?.count)! - 1 {
                        self.DataOrder?.add(da?[i] as Any)
                        
                        
                    }
                    }
                                     print(self.DataOrder!)
                    
                    
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


    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        viewUnderLine.frame = CGRect.init(x: 0, y: viewUnderLine.frame.origin.y, width: self.view.frame.size.width/2, height: 2)

       
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func CancelOrder(_ sender: Any){
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        
    
        
        
        var Baseurl = "apiCancelReason.php"
        
        
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        
        
        self.dataModel.GetCancelApi(Url: Baseurl as String as NSString){ (data1) in
            
            
            self.stopAnimating()
            
            
            if data1.1 as String == "FAILURE"{
                                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataBanner = data1.0
                
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String == "Mobile No is Aready Exists" {
                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    
                    self.DataOption?.removeAllObjects()
                    
                    for i in 0...data1.0.count - 1 {
                        self.DataOption?.add(data1.0[i])
                    }
                    
                    self.bgDarkView.isHidden = false
                    self.OptionView.isHidden = false

                    self.optionTableView.reloadData()
                    
                    
                }
                
                
            }
        }

        
        
        
     
        
        
        
        
        
        
        
    }

        
        
        
    @IBAction func SUMBIT(_ sender: Any) {
        
        if btnSubmit.title(for: .normal) == "Next" {
            if cancelOption.characters.count == 0 {
                ShowAlertOK(sender: "Select Your Option...")
            }
            else{
            optionTableView.isHidden = true;
            txtComment.isHidden = false;
            btnSubmit.setTitle("Submit", for: .normal)
            lblCancelTitle.text = "Comment"
                
                
                txtComment.becomeFirstResponder()
            }
        }
        
        else{
        
            if txtComment.text.characters.count == 0 {
                ShowAlertOK(sender: "Please Comment...")
            }
            
            else{
            
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiCancelOrder.php"
//        order_id :1
//        purchase_id :ODDB-35001
//        customer_id :8235
//        cancel_reason :No cash (Dynamic value,this can be a dropdown box with API calling for listing)
//        cancel_comments :Test

        let dict = [
            "order_id" :order_id ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")! ,
            //                        "customer_id" : "20" ,
            "purchase_id":purchase_id,
            "cancel_reason": cancelOption,
            "cancel_comments" : txtComment.text
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
                
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String == "Please fill all the fields..." {
                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    //                                        self.DataSubCat?.removeAllObjects()
                    //                                        self.ArrRecentName.removeAllObjects()
                    // print("banner  \(data.0.count)")
                    
                    
                    self.bgDarkView.isHidden = true
                    self.OptionView.isHidden = true
                    self.optionTableView.isHidden = true
                    self.txtComment.isHidden = true
                    self.cancelOption = ""
                    self.txtComment.endEditing(true)
                    self.btnSubmit.setTitle("Next", for: .normal)

                    self.dismiss(animated: true, completion: nil)
                    //                // print(data1)
                    
                    
                }
                
                
            }
        }
        
    }
        }
    }
    
        
          @IBAction func ReFund(_ sender: Any) {
    }
    

    @IBAction func Replacement(_ sender: Any) {
    }
    @IBAction func Items(_ sender: Any) {
        
        
         UIView.animate(withDuration: 0.5, delay: 0.0, options: [ .curveLinear], animations: {
        
         self.viewUnderLine.frame = CGRect.init(x: self.view.frame.size.width/2, y: self.viewUnderLine.frame.origin.y, width: self.view.frame.size.width/2, height: 2)
            
        
            
            
            
            self.tableView.isHidden = false
            self.tableView.reloadData()
            
         }, completion:{  finished in
         })
        
    }
    @IBAction func Detail(_ sender: Any) {
        
        
          UIView.animate(withDuration: 0.5, delay: 0.0, options: [ .curveLinear], animations: {
        
         self.viewUnderLine.frame = CGRect.init(x: 0, y: self.viewUnderLine.frame.origin.y, width: self.view.frame.size.width/2, height: 2)
            self.tableView.isHidden = true

          }, completion:{  finished in
        })
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == optionTableView {
            return (DataOption?.count)!

        }
        else{
        
        return (DataOrder?.count)!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == optionTableView {
            return 40

        }
        else{
        
        return 77
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == optionTableView {
            
            
            
            
            let cellIdentifier = "ElementCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
            
            
            // set the text from the data model
            let data = DataOption?[indexPath.row] as! NSDictionary

            cell.textLabel?.text = data.value(forKey: "cancel_reason") as? String
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
            
            return cell
            
            
            
        }
        else{
        
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemsTableViewCell
        
        
        print(indexPath.row)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let data = DataOrder?[indexPath.row] as! NSDictionary
        
        print(data)

    
        loadImageFromUrl(url: data.value(forKey: "product_image") as! String , view: cell.img)
        
        cell.name.text = "\(data.value(forKey: "product_name") as! String) \(data.value(forKey: "product_weight") as! String)\(data.value(forKey: "product_unit") as! String)  ₹\(data.value(forKey: "unit_price") as! String)"
        
        return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == optionTableView {
            
            let cell = optionTableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            
            
            
            
            let data = DataOption?[indexPath.row] as! NSDictionary
            
            cancelOption = (data.value(forKey: "cancel_reason") as? String)!
            
            
         
            
            }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == optionTableView {
            
            let cell = optionTableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
            
        }
    }
    
    func loadImageFromUrl(url: String, view: UIImageView){
        
        
        // Create Url from string
        if url.characters.count == 0 {
        }
        else {
            
          let   url = url.replacingOccurrences(of: " ", with: "%20")
            
            
        let Strurl = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: Strurl as URL) { (responseData, responseUrl, error) -> Void in
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
    }


    
    @IBAction func CloseOptionView(_ sender: Any) {
        self.bgDarkView.isHidden = true
        self.OptionView.isHidden = true
        self.optionTableView.isHidden = false
        self.txtComment.isHidden = true
        lblCancelTitle.text = "Select Option"
        cancelOption = ""
        self.txtComment.endEditing(true)

        btnSubmit.setTitle("Next", for: .normal)

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

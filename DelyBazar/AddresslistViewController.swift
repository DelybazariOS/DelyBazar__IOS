//
//  AddresslistViewController.swift
//  DelyBazar
//
//  Created by OSX on 06/12/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddresslistViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , NVActivityIndicatorViewable , UIGestureRecognizerDelegate{

    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var DataSelectedCollection : NSDictionary?

    var DataAddressList : NSMutableArray? = []
    var activityIndicatorView : NVActivityIndicatorView?
    var DataTimeSlot : NSMutableArray? = []
    var DataDateSlot : NSMutableArray? = []
    
    @IBOutlet weak var C_Continue_H: NSLayoutConstraint!
    
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var TimetableView: UITableView!
    @IBOutlet weak var DateTableView: UITableView!
    @IBOutlet weak var viewTimeSlot: UIView!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var tableView: UITableView!
    var DateSelect : Int! = 0
    var TimeSelect : Int! = -1
    var tap : UITapGestureRecognizer! = nil
    var isTimeSlotOpen : Bool = false
    
    var TimeID : String! = ""
    var Timename : String! = ""
    var Datename : String! = ""

    var Menutype : String! = ""

    var SelectedAddressID : String! = ""
    var SelectedAddressName : String! = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "AddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        
        DateTableView.register(UINib(nibName: "TimeSlotTableViewCell", bundle: nil), forCellReuseIdentifier: "DateCell")
         TimetableView.register(UINib(nibName: "TimeSlotTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        
        
        tap = UITapGestureRecognizer.init(target: self, action: #selector(AddresslistViewController.BackgroundTap))
        
        if Menutype == "menu" {
            C_Continue_H.constant = 0
        }
        
        bgview.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    func BackgroundTap()  {
        isTimeSlotOpen = false
        bgview.isHidden = true
        viewTimeSlot.isHidden = true
        
    }
    func GetCartCountData()  {
        var Baseurl = "apiListingSlot.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        
        
        
        
        
        
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetTimeSlotApi(Url: Baseurl as String as NSString){ (dataCoun) in
            
            
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
                    
                    for i in 0...dataCoun.0.count - 1 {
                        self.DataTimeSlot?.add(dataCoun.0[i])
                    }
                    self.DataDateSlot?.add(dataCoun.0[0])
                    
                }
                
                
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if (UserDefaults.standard.string(forKey: "city_id") == nil) {
        }
        else
        {
            GetCartCountData()

        GetAddressData()
        }
    }
    func GetAddressData()  {
        var Baseurl = "apiListingAddress.php"
        
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
                
                
                
                
                self.DataAddressList?.removeAllObjects()
                
//                if (dataBanner as AnyObject).value(forKey: "status") as? String != "Inactive" {
                
                    if (dataBanner as AnyObject).value(forKey: "status") as? String == "No Shipping Address Available" {
                    
                    let alert = UIAlertController(title: "No Shipping Address Available", message: "Add Your Shipping Address", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title:  "Cancel", style: UIAlertActionStyle.cancel) {
                        UIAlertAction in
                        
                    }
                    alert.addAction(cancelAction)
                        let addAction = UIAlertAction(title:  "Add", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAddressViewController") as! UpdateAddressViewController
                            vc.type = "add"
                            vc.address_id = ""
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                        alert.addAction(addAction)

                    self.present(alert, animated: true, completion: nil)
                    }
                    else{
//                        self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
//
//                    }
//                }
                    
//                else{
                    
//                    let dataCate = data.0[0] as! NSDictionary
                    
                    
                    for i in 0...data.0.count - 1 {
                        self.DataAddressList?.add(data.0[i])
                    }
                    
                    
                    if self.DataAddressList?.count == 0 {
                        self.tableView.reloadData()

                                           }
                    else{
                    
                    self.tableView.reloadData()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @IBAction func ActionResetTime(_ sender: Any) {
        
//        DateSelect = 0
//        TimeSelect = -1
//        
//        UserDefaults.standard.set(String(TimeSelect!), forKey: "TimeSelect")
//        
//        
//        TimetableView.reloadData()
//        DateTableView.reloadData()
        
    }
    
    @IBAction func ActionConfirm(_ sender: Any) {
        
        UserDefaults.standard.set(TimeID!, forKey: "TimeSelect")
        UserDefaults.standard.set(Timename!, forKey: "time_slot_name")
        UserDefaults.standard.set(Datename!, forKey: "Date_slot_name")

//        btnSelecttimeSlot.setTitle(Timename!, for: .normal)

        
        isTimeSlotOpen = false
                bgview.isHidden = true
                viewTimeSlot.isHidden = true
        
    }
    @IBAction func ActionDone(_ sender: Any) {
//        isTimeSlotOpen = false
//        bgview.isHidden = true
//        viewTimeSlot.isHidden = true
    }
    
    
    @IBAction func Next(_ sender: Any) {
        
        if SelectedAddressID.characters.count == 0 {
            ShowAlertOK(sender: "Select Your Shipping Address ")
        }
        
        else {
        
            let timeSelected = UserDefaults.standard.integer(forKey: "TimeSelect")
            
            if timeSelected == -1 {
                viewTimeSlot.isHidden = false
                bgview.isHidden = false
                
                DateTableView.reloadData()
                TimetableView.reloadData()
            }
            else{
            
        let pVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentOptionViewController") as! PaymentOptionViewController
            
            pVC.shipping_address_id = SelectedAddressID
                pVC.DataCollection = DataSelectedCollection
                pVC.userName = SelectedAddressName
                
        self.present(pVC, animated: true, completion: nil)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == DateTableView {
            return (DataDateSlot?.count)!
        }
        else if tableView == TimetableView {
            return (DataTimeSlot?.count)!
            
        }
        else {
            return (DataAddressList?.count)!
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == DateTableView {
            return 50
        }
        else if tableView == TimetableView {
            return 50
            
        }
        else {
            return 140
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                if tableView == DateTableView {
        
        let cell = DateTableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! TimeSlotTableViewCell
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
                    
                    return cell
                    
        }
        else if tableView == TimetableView {
            
            let cell = TimetableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeSlotTableViewCell
            
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    
                    let data = DataTimeSlot?[indexPath.row] as? NSDictionary
                    
                    cell.name.text = (data as AnyObject).value(forKey: "name") as? String
                    if indexPath.row == TimeSelect {
                        cell.btnSelect.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: .normal)
                    }
                    else{
                        cell.btnSelect.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
                    }
                    

                    cell.btnSelect.accessibilityHint = (data as AnyObject).value(forKey: "slot_id") as? String
            return cell
        }
                else   {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AddressListTableViewCell
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    let data = DataAddressList?[indexPath.row] as? NSDictionary
                    
                    cell.AddressCount.text = "Address \(indexPath.row + 1)"
                    cell.address.text  = "\((data?.value(forKey: "shipping_address")! as! String?)!) \((data?.value(forKey: "shipping_area")! as! String?)!)  \((data?.value(forKey: "city_name")! as! String?)! )  \n \((data?.value(forKey: "shipping_pincode")! as! String?)!)"
                    
                    if Menutype == "menu" {
                       cell.btnRadio.isHidden = true
                    }
                    
                        cell.btnChangeAddress.addTarget(self, action: #selector(AddresslistViewController.ChangeAddress(_:)) , for: .touchDown)
                    
                     cell.btnDeleteAdd.addTarget(self, action: #selector(AddresslistViewController.DeleteAdd(_:)) , for: .touchDown)
                    cell.btnDeleteAdd.accessibilityHint = data?.value(forKey: "address_id")! as! String?

                    
                    cell.btnChangeAddress.accessibilityHint = data?.value(forKey: "address_id")! as! String?
                    
                    cell.btnChangeAddress.tag = indexPath.row
                    
                    
                    cell.btnRadio.addTarget(self, action: #selector(AddresslistViewController.SelectAddress(_:)) , for: .touchDown)
                    
                    cell.btnRadio.accessibilityHint = data?.value(forKey: "address_id")! as! String?
                    
                    cell.btnRadio.accessibilityLabel = "\((data?.value(forKey: "first_name")! as! String?)!) \((data?.value(forKey: "last_name")! as! String?)!)"

                    
                    cell.btnRadio.tag = indexPath.row
                    
                    if SelectedAddressID == data?.value(forKey: "address_id")! as! String? {
                        cell.btnRadio.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: .normal)
                    }
                    else{
                          cell.btnRadio.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: .normal)
                    }
                    
                    
                    return cell
                    
        }


    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == DateTableView {
            
            
            DateSelect = indexPath.row
            
            TimeSelect = -1
            TimetableView.reloadData()
            DateTableView.reloadData()
            let data = DataTimeSlot?[0] as? NSDictionary
            
            Datename = (data as AnyObject).value(forKey: "name") as? String
            btnDate.setTitle((data as AnyObject).value(forKey: "name") as? String, for: .normal)

            
            
        }
        else if tableView == TimetableView {
            TimeSelect = indexPath.row
            TimetableView.reloadData()
            
            let data = DataTimeSlot?[indexPath.row] as? NSDictionary
            
            
            TimeID = (data as AnyObject).value(forKey: "slot_id") as? String
            Timename = (data as AnyObject).value(forKey: "name") as? String
            
        
            btnTime.setTitle((data as AnyObject).value(forKey: "name") as? String, for: .normal)
            
            
        }
        else {
            
            let data = DataAddressList?[indexPath.row] as? NSDictionary

            DataSelectedCollection = data
            SelectedAddressID = data?.value(forKey: "address_id")! as! String?
            SelectedAddressName = "\((data?.value(forKey: "first_name")! as! String?)!) \((data?.value(forKey: "last_name")! as! String?)!)"
            
            if SelectedAddressID == data?.value(forKey: "address_id")! as! String? {
                
            }
            
            //        let indexPath = NSIndexPath.init(row: sender.tag , section: 0)
            //
            //        self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
            
            tableView.reloadData()
            
        }

    }
    @IBOutlet weak var btnAddAddress: UIButton!
    @IBAction func AddAddress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAddressViewController") as! UpdateAddressViewController
        vc.type = "add"
        vc.address_id = ""
        self.present(vc, animated:true, completion:nil)

    }
    @IBAction func SelectAddress(_ sender: UIButton) {
        let data = DataAddressList?[sender.tag] as? NSDictionary
        
        DataSelectedCollection = data
        
        SelectedAddressID = sender.accessibilityHint!
        SelectedAddressName = sender.accessibilityLabel!
        
        if SelectedAddressID == sender.accessibilityHint! {
            
        }
        
//        let indexPath = NSIndexPath.init(row: sender.tag , section: 0)
//        
//        self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
        
        tableView.reloadData()
        
    }
    @IBAction func DeleteAdd(_ sender: UIButton) {
        var Baseurl = "apiRemoveAddress.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
            "address_id" : sender.accessibilityHint! ,
            
            //            "city_id" : "1"
        ]
        
        
        
        
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetHomeCatApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
            
            
            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0[0]
                
                

                
                if (dataCount as AnyObject).value(forKey: "status") as? String != nil {
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    self.GetAddressData()

                }
                    
                else{
                    
                    print("banner  \(dataCoun.0.count)")
                    //                    let dataCount = dataCoun.0[0]
                    
                    self.GetAddressData()

                    
                    

                    
                }
                
                
            }
        }
        
    }
    @IBAction func ChangeAddress(_ sender: UIButton) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAddressViewController") as! UpdateAddressViewController
        vc.type = "edit"
        vc.address_id = sender.accessibilityHint!
        
        

        vc.UserData = DataAddressList?[sender.tag] as? NSDictionary
        
        
        
        self.present(vc, animated: true, completion: nil)
        
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

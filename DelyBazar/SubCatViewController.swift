//
//  SubCatViewController.swift
//  DelyBazar
//
//  Created by OSX on 22/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SubCatViewController: UIViewController , UIScrollViewDelegate , UITableViewDelegate , UITableViewDataSource , NVActivityIndicatorViewable , UIGestureRecognizerDelegate{

    @IBOutlet weak var btnDiscount: UIButton!
    @IBOutlet weak var Bottomcart: UIButton!
    @IBOutlet weak var btnSelectcategory: UIButton!
    @IBOutlet weak var TitleView: UILabel!
    @IBOutlet weak var C_Quantity_H: NSLayoutConstraint!
    @IBOutlet weak var QuantityTable: UITableView!
    @IBOutlet weak var QuantityView: UIView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgDarkView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnlowtoHigh: UIButton!
    @IBOutlet weak var btnHighToLow: UIButton!
    @IBOutlet weak var btnAlphabetical: UIButton!
    @IBOutlet weak var CategoryTableView: UITableView!
    
    @IBOutlet weak var TotalAmount: UILabel!
    @IBOutlet weak var C_ChildScroll_H: NSLayoutConstraint!
    @IBOutlet weak var C_Scroll_H: NSLayoutConstraint!
    @IBOutlet weak var childScrollView: UIScrollView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var btnBrand: UIButton!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var C_Scroll_W: NSLayoutConstraint!
    var segmentedControl:UISegmentedControl!
    var ChildsegmentedControl:UISegmentedControl!
    var ViewSegmetButtom:UIView!
    var ChildUnderLineView:UIView!
    var tap : UITapGestureRecognizer! = nil
    
    
    var limitarr : Int = 0

    var isBrandSelect : Bool = false
    var isPriceSelect : Bool = true
    var isDiscountSelect : Bool = true

    var isCatSelect : Bool = false

    var category_id : String! = ""
    
    var View_From : String! = ""

    var ApiCallFor : String! = "ALL"

    
    var SubCatID : String! = ""
    var ChildCatID : String! = ""
    var CatName : String! = ""
    var SelectedSortType : String! = ""
    var IsSortType : String! = ""

    var SelectedPriceID : String! = "0"
    var SelectedBrandID : String! = "0"
    var SelectedDiscountID : String! = "0"

    var FilterPriceSelect : String! = ""
    var SortTypeSelect : String! = ""

    var SelectedIndex : Int! = 0
    var SelectedIndexOfIndex : Int! = -1
    var ArrSelectedIndex : NSMutableArray? = []

    var SelectedRow : Int! = 0
    var ArrProductList : NSMutableArray? = []
    var ArrAllCategory : NSMutableArray? = []
    var ArrDiscount : NSMutableArray? = []
    var ArrPriceFilter : NSMutableArray? = []
    var ArrBrandFilter : NSMutableArray? = []
    
    var ArrFinalProductList : NSMutableArray? = []

 
    var DataSubCat : NSMutableArray? = []
    var DataChildCat : NSMutableArray? = []
    var DataProductList : NSMutableArray? = []

    var DataQuantityList : NSMutableArray? = []
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var activityIndicatorView : NVActivityIndicatorView?

    
    
    
     var ArrRecentName : NSMutableArray = [ ]
    
    var ArrChildCatName : NSMutableArray = [ ]

    
    var ArrChildCat : NSMutableArray = [ ]

    
    
    var ArrFilterCost : NSArray = [ "Rs 100-Rs 500" , "Rs 500-Rs 1000" , "Rs 1000-Rs 5000" ]
    var ArrFilterBrand : NSArray = [ "Tomato" , "Lemon" , "Apple" , "Cherry" , "Tomato"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        TitleView.text = CatName!

//        SegmentControl = UISegmentedControl.init(items: [ "Tomato" , "Lemon" , "Apple" , "Cherry" , "Tomato"] )
      
        scrollView.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
        

        tableView.register(UINib(nibName: "VegetableTableViewCell", bundle: nil), forCellReuseIdentifier: "VEGCell")
        CategoryTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CatCell")
        
        
        CategoryTableView.layer.borderColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1).cgColor
        CategoryTableView.layer.borderWidth = 1
        CategoryTableView.layer.cornerRadius = 2
        

        
        tap = UITapGestureRecognizer.init(target: self, action: #selector(SubCatViewController.BackgroundTap))
        
        
        bgDarkView.addGestureRecognizer(tap)
       
            
        
      
        
        self.ChildUnderLineView = UIView.init(frame: CGRect.init(x: 0, y: 35, width: 150 , height: 5))
        self.ViewSegmetButtom = UIView.init(frame: CGRect.init(x: 0, y: 35, width: 150 , height: 5))

        GetDiscountList()
        GetFilterBrandList()
        GetFilterPriceList()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if "YES" == UserDefaults.standard.string(forKey: "HomeToCart_Is_From") {
            UserDefaults.standard.set("NO", forKey: "HomeToCart_Is_From")

            HomeToCart()
            
        }
        else{
        
        
        self.GetAllCatData()
        
        self.GetCatData()
        self.GetCartCountData()
        }
    }
    
    
    func HomeToCart()  {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubCatViewController") as! SubCatViewController
//        nextViewController.category_id  = UserDefaults.standard.string(forKey: "HomeToCart_ID")!
//        nextViewController.CatName  = UserDefaults.standard.string(forKey: "HomeToCart_Name")!
//        nextViewController.View_From = "HOME"
//        
//        
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//        self.CategoryTableView.isHidden = true
        self.TitleView.text = UserDefaults.standard.string(forKey: "HomeToCart_Name")!
        
        self.category_id = UserDefaults.standard.string(forKey: "HomeToCart_ID")!
        
        
        if self.DataChildCat?.count != 0{
            self.ChildsegmentedControl.removeAllSegments()
        }
        
        self.ArrProductList?.removeAllObjects()
        self.ArrDiscount?.removeAllObjects()
        self.ArrPriceFilter?.removeAllObjects()
        self.ArrBrandFilter?.removeAllObjects()
        
        self.ArrFinalProductList?.removeAllObjects()
        
        self.DataSubCat?.removeAllObjects()
        self.DataChildCat?.removeAllObjects()
        self.DataProductList?.removeAllObjects()
        
        self.DataQuantityList?.removeAllObjects()
        
        
        self.ArrRecentName.removeAllObjects()
        self.ArrChildCatName.removeAllObjects()
        self.ArrChildCat.removeAllObjects()
        
        
        self.segmentedControl.removeAllSegments()
        
        limitarr = 0
        self.tableView.reloadData()
        ApiCallFor = "ALL"
        self.GetCatData()

    }

    func BackgroundTap()  {
        bgDarkView.isHidden = true
        QuantityView.isHidden = true
        filterView.isHidden = true
        sortView.isHidden = true

    }
    @IBAction func NextButton(_ sender: Any) {
        if btnCart.title(for: .normal)! as String == "0"{
            ShowAlertOK(sender: "There is no item in the cart")
        }
        else{
            
            
            let CVC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            self.present(CVC, animated: true, completion: nil)
        }

        
    }
    
    func GetDiscountList()  {
//        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiDiscountFilterList.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            ]
        
//        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        ArrDiscount?.removeAllObjects()
        
        
        self.dataModel.GetDiscountApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            
            
            if data.1 as String == "FAILURE"{
//                self.stopAnimating()
                
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataDis = data.0[0]
                
                
                
                if (dataDis as AnyObject).value(forKey: "status") as? String != nil {
                    self.stopAnimating()
                    
                    self.ShowAlertOK(sender: (dataDis as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    
                    for i in 0...data.0.count - 1 {
                        self.ArrDiscount?.add(data.0[i])
                    }
                    
                }
                
                
            }
        }
        
        
        
    }
    func GetFilterPriceList()  {
//        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiPriceFilterList.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            ]
        
//        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        ArrPriceFilter?.removeAllObjects()
        
        
        self.dataModel.GetPriceApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            
            
            if data.1 as String == "FAILURE"{
//                self.stopAnimating()
                
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataDis = data.0[0]
                
                
                
                if (dataDis as AnyObject).value(forKey: "status") as? String != nil {
                    self.stopAnimating()
                    
                    self.ShowAlertOK(sender: (dataDis as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    
                    for i in 0...data.0.count - 1 {
                        self.ArrPriceFilter?.add(data.0[i])
                    }
                    
                }
                
                
            }
        }
        
        
        
    }
    func GetFilterBrandList()  {
        //        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiBrandFilterList.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            ]
        
//        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        ArrBrandFilter?.removeAllObjects()
        
        
        self.dataModel.GetbrandApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            
            
            if data.1 as String == "FAILURE"{
                //                self.stopAnimating()
                
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataDis = data.0[0]
                
                
                
                if (dataDis as AnyObject).value(forKey: "status") as? String != nil {
                    self.stopAnimating()
                    
                    self.ShowAlertOK(sender: (dataDis as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    
                    for i in 0...data.0.count - 1 {
                        self.ArrBrandFilter?.add(data.0[i])
                    }
                    
                }
                
                
            }
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
                    self.Bottomcart.setTitle((dataCart as AnyObject).value(forKey: "total_cart") as? String , for: .normal)
                    self.TotalAmount.text = "Total - ₹\(((dataCart as AnyObject).value(forKey: "total_amount")! as? String)!)"

                }
                
                
            }
        }
        
    }
    func GetAllCatData()  {
        //        http://delybazar.in/mobile-app/apiSubCategory.php
        var Baseurl = "apiCategory.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            
            //            "city_id" : "1"
        ]
        
        
        
        
        
//        print(dict)
        ArrAllCategory?.removeAllObjects()
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetHomeCatApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCat) in
            
            
//            self.stopAnimating()
            
            
            if dataCat.1 as String == "FAILURE"{
                self.stopAnimating()

                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCate = dataCat.0[0]
                
                
                
                
                if (dataCate as AnyObject).value(forKey: "status") as? String != nil {
                    self.stopAnimating()

                    self.ShowAlertOK(sender: (dataCate as AnyObject).value(forKey: "status")  as! NSString)

                }
                    
                else{
                    
//                    print("banner  \(dataCat.0.count)")
                    
                    for i in 0...dataCat.0.count - 1 {
                        self.ArrAllCategory?.add(dataCat.0[i])
                    }
//                                       self.CategoryTableView.reloadData()
                    
                }
                
                
            }
        }
        
        
        
    }

    
   
    func GetCatData()  {
          self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiSubCategory.php"
        
               let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "category_id" : category_id
        ]
        
//          print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        
        
        self.dataModel.GetCatListApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            
            
            if data.1 as String == "FAILURE"{
                self.stopAnimating()

                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataBanner = data.0[0]
                
                
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String != nil {
                    self.stopAnimating()

                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)

                    self.C_Scroll_H.constant = 0
                }
                    
                else{
                    self.ArrRecentName.removeAllObjects()

                    self.DataSubCat?.removeAllObjects()
//                    self.ArrRecentName.removeAllObjects()
//                    // print("banner  \(data.0.count)")
                    
                    
                    
                    
                    for i in -1...data.0.count - 1{
                        
                        let allDict = data.0[0] as! NSDictionary
                        
                        let dict = [
                            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
                            "category_id" : self.category_id ,
                            "sub_category_id" : allDict.value(forKey: "sub_category_id")! ,
                            "sub_category_name" : "All" ,
                            
                            //            "city_id" : "1"
                        ]
                        
                        
                        if i == -1 {
                            self.ArrRecentName.add("All")
                            self.DataSubCat?.add(dict)

                        }
                        else {
                        
                        self.DataSubCat?.add(data.0[i])
                        
                        let data = data.0[i]
                        
                        
                        self.ArrRecentName.add((data as AnyObject).value(forKey: "sub_category_name") as! String)
                        
                        }
                        
                    }
//                    // print(self.DataSubCat!)

//                    let arr1 = self.DataSubCat?[0]
                    let data1 = data.0[0]

                    
//                // print(data1)
                    
                    if self.DataSubCat?.count != 0
                    {
                        self.C_Scroll_H.constant = 40

                        let arr = self.ArrRecentName as NSArray
                        
                        self.segmentedControl = UISegmentedControl (items: arr as? [Any] )
                        
                        self.segmentedControl.frame = CGRect.init(x: 0, y: 0, width: 150 * arr.count, height: 35)
                        
                        self.segmentedControl.selectedSegmentIndex = 0
                        self.segmentedControl.addTarget(self, action: #selector(SubCatViewController.segmentedControlAction(_:)), for: .valueChanged)
                        self.segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName:   #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)], for: UIControlState.selected)
                        
                        self.segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName:   #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)], for: UIControlState.normal)
                        
                        self.scrollView.contentSize = CGSize.init(width: 150 * arr.count, height: 40)
                        
                        self.scrollView.addSubview(self.segmentedControl)
                        
                        self.ViewSegmetButtom.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        self.scrollView.addSubview(self.ViewSegmetButtom)

                        self.segmentedControl.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
                        self.segmentedControl.tintColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
                        self.GetSubCatData(id: (data1 as AnyObject).value(forKey: "sub_category_id") as! String)

                    }
                    else{
                        self.stopAnimating()

                        self.C_Scroll_H.constant = 0

                    }
                                   }
                
                
            }
        }
        
        
        
    }
    func GetSubCatData( id : String)  {
        
        
        if self.ApiCallFor == "ALL"{
            self.stopAnimating()
            self.C_ChildScroll_H.constant = 0

            self.GetChildCatData(cid :  "0"  , sid: "0" , type : "GET" , price_filter_id: "0" , discount_filter_id:  "0" , brand_filter_id:  "0" , limitVal:  "0")
            
        }
        else {
        
          self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiChildCategory.php"
        
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "category_id" : category_id,
            "sub_category_id" : id

            //            "city_id" : "1"
        ]


        
        
        // print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        self.ChildUnderLineView.frame = CGRect.init(x: 0, y: 35, width: 150, height: 5)

        DataChildCat?.removeAllObjects()
        self.ArrChildCatName.removeAllObjects()

        
        
        if ChildsegmentedControl != nil {
            ChildsegmentedControl.removeAllSegments()
        }
        
        self.dataModel.GetBannerApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
//            self.stopAnimating()
            
            
            if data.1 as String == "FAILURE"{
                 self.stopAnimating()
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataBanner = data.0[0]
                
                
                
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String != nil {
//                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                    if self.ApiCallFor == "ALL"{
                        self.GetChildCatData(cid :  "0"  , sid: "0" , type : "GET" , price_filter_id: "0" , discount_filter_id:  "0" , brand_filter_id:  "0",limitVal: "0")

                    }
                    else{
                    
                    self.GetChildCatData(cid :  "0"  , sid: id , type : "GET" , price_filter_id: "0" , discount_filter_id:  "0" , brand_filter_id:  "0" , limitVal:  "0")
//                                      }
                    self.stopAnimating()
                    self.C_ChildScroll_H.constant = 0
                    }
                }
                    
                else{
//                    self.DataChildCat?.removeAllObjects()
//                    self.ArrChildCatName.removeAllObjects()

//                    // print("banner  \(data.0.count)")
                    self.C_ChildScroll_H.constant = 40

                    for i in 0...data.0.count - 1 {
                        self.DataChildCat?.add(data.0[i])
                        let data = data.0[i]
                        
                        
                        
                        
                        
                        self.ArrChildCatName.add((data as AnyObject).value(forKey: "child_category_name") as! String)
               
                    }
                    
                    let data1 = data.0[0]
                    
                    
                    
                    if self.DataChildCat?.count != 0
                    {
                        self.C_ChildScroll_H.constant = 40

                        
                        if self.ApiCallFor == "ALL"{
                            self.GetChildCatData(cid :  "0"  , sid: "0" , type : "GET" , price_filter_id: "0" , discount_filter_id:  "0" , brand_filter_id:  "0" , limitVal:  "0")
                            
                        }
                        else{
//
                        self.GetChildCatData(cid :  (data1 as AnyObject).value(forKey: "child_category_id") as! String  , sid: id , type : "GET" , price_filter_id: "0" , discount_filter_id:  "0" , brand_filter_id:  "0" , limitVal:  "0")
                        }
                    let arr = self.ArrChildCatName as NSArray

                    
                    self.ChildsegmentedControl = UISegmentedControl (items: arr as? [Any] )
                        
                        // print(arr.count)

                    
                    self.ChildsegmentedControl.frame = CGRect.init(x: 0, y: 0, width: 150 * arr.count, height: 35)
                    self.ChildsegmentedControl.selectedSegmentIndex = 0
                    self.ChildsegmentedControl.addTarget(self, action: #selector(SubCatViewController.ChildsegmentedControlAction(_:)), for: .valueChanged)
                    self.ChildsegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName:   #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)], for: UIControlState.selected)
                    
                    self.ChildsegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName:   #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)], for: UIControlState.normal)
                    
                    self.childScrollView.contentSize = CGSize.init(width: 150 * arr.count, height: 40)
                    
                    self.childScrollView.addSubview(self.ChildsegmentedControl)
                        
                        
                        self.ChildUnderLineView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        self.childScrollView.addSubview(self.ChildUnderLineView)
                        
                    self.ChildsegmentedControl.backgroundColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)
                    self.ChildsegmentedControl.tintColor = #colorLiteral(red: 0.5256986618, green: 0.7295455933, blue: 0.01036952622, alpha: 1)

                        
               
                    
                    
                    }
                    else{
                         self.stopAnimating()
                        self.C_ChildScroll_H.constant = 0

                    }
                    
                 
                }
                
                
            }
        }
        }
        
        
    }
    func GetChildCatData( cid : String , sid : String , type : String , price_filter_id : String , discount_filter_id : String , brand_filter_id : String , limitVal : String )  {
          self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiProductListing.php"
        
     
        
        

        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "category_id" : category_id,
            "sub_category_id" : sid,
            "child_category_id" : cid,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!,
            "price_filter_id" : SelectedPriceID,
            "discount_filter_id" : SelectedDiscountID,

            "brand_filter_id" : SelectedBrandID,

            "limitVal" : limitVal

            //            "city_id" : "1"
        ]
        
        SubCatID = sid
        ChildCatID = cid
        
         print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        if type != "LoadMore" {
            DataProductList?.removeAllObjects()
            ArrProductList?.removeAllObjects()
        }
        
       
        self.dataModel.GetProduct_ListApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (data) in
            
            
            
            
            if data.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                self.stopAnimating()

                
            }
            else{
                
                if data.0.count == 0 {
                    self.ShowAlertFilterOK(sender: "No item")
                    self.ArrFinalProductList?.removeAllObjects()
//                    self.ArrSelectedIndex?.removeAllObjects()

                    self.tableView.reloadData()
                    
                }
                else{
                
                
                let dataBanner = data.0[0]
                
                
                
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String != nil {
                    
                    if type == "LoadMore"{
                        self.stopAnimating()
                        
//                        self.ShowAlertOK(sender: "No More Product Available")
                    }
                    else{
                    self.stopAnimating()

                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    self.tableView.reloadData()
                    self.tableView.setContentOffset(CGPoint.zero, animated: true)

                    }
                }
                    
                else{
                    
//                    if type != "LoadMore" {

                    
                    
                    self.ArrFinalProductList?.removeAllObjects()

                    
                    
                    
                    
                
                    print("product count ==========\(data.0.count)")
                    
                    
                    
                    for i in 0...data.0.count - 1 {
                        self.DataProductList?.add(data.0[i])

                        let dataDict = data.0[i]
                        
                        let price = (dataDict as AnyObject).value(forKey: "pricetype") as? NSArray
                        let Sellprice = price?.value(forKey: "selling_price") as? NSArray
                        let SellImage = price?.value(forKey: "product_image") as? NSArray
                        let SellType_id = price?.value(forKey: "product_type_id") as? NSArray
                        let SellWeight = price?.value(forKey: "product_weight") as? NSArray
                        let Sellunit = price?.value(forKey: "product_unit") as? NSArray
                        let SellQuantity = price?.value(forKey: "product_quantity") as? NSArray

               

                        let dict : NSDictionary?
                        
                        
                        dict = [
                            "product_id" :   (dataDict as AnyObject).value(forKey: "product_id") as Any,
                            "product_name" :   (dataDict as AnyObject).value(forKey: "product_name") as? String as Any,

                            "stock_status" :   (dataDict as AnyObject).value(forKey: "stock_status") as? String as Any,

                            "sub_category_id" :   (dataDict as AnyObject).value(forKey: "sub_category_id") as? String as Any,
                            "wishlist_status" :   (dataDict as AnyObject).value(forKey: "wishlist_status") as? String as Any,
                            "product_code" :   (dataDict as AnyObject).value(forKey: "product_code") as? String as Any,
                            "category_id" :   (dataDict as AnyObject).value(forKey: "category_id") as? String as Any,
                            "child_category_id" :   (dataDict as AnyObject).value(forKey: "child_category_id") as? String as Any,
                            "selling_price" :  Sellprice?[0] as! String ,

                            "product_image" :   SellImage?[0] as! String,

                            "product_type_id" :   SellType_id?[0] as! String,
                            "product_weight" :   SellWeight?[0] as! String,
                            "product_unit" :   Sellunit?[0] as! String,
                            "product_quantity" :   SellQuantity?[0] as! NSString,
                            
                            "pricetype" :   (dataDict as AnyObject).value(forKey: "pricetype") as? NSArray as Any

                            

                            

                        ]
                        
                        
                        // print("data \(dict)")

                        self.ArrFinalProductList?.add(dict!)

                        
                        
                        
                        
                        
                        
                        
//                        if self.FilterPriceSelect.characters.count != 0
//                        {
//                        
//                        let TempListArr : NSMutableArray! = []
//                        
//                        TempListArr.removeAllObjects()
//                        
//                        for i in 0...(self.ArrFinalProductList?.count)! - 1 {
//                            
//                            TempListArr.add(self.ArrFinalProductList?[i] as Any)
//                            
//                            
//                        }
//                        
//                        
//                        self.ArrProductList?.removeAllObjects()
//                        
//                        var DataMim : Int!
//                        var DataMix : Int!
//                        
//                        
//                        if self.FilterPriceSelect == "0" {
//                            DataMim = 100
//                            DataMix = 500
//                        }
//                        else  if self.FilterPriceSelect == "1" {
//                            DataMim = 500
//                            DataMix = 1000
//                        }
//                            
//                        else  if self.FilterPriceSelect == "2" {
//                            DataMim = 1000
//                            DataMix = 5000
//                        }
//                        
//                        for i in 0...TempListArr.count - 1 {
//                            
//                            
//                            let dict = TempListArr[i] as! NSDictionary
//                            
//                            let price = dict.value(forKey: "selling_price") as! String
//                            
//                            if (Int(price)! >= DataMim) && (Int(price)! <= DataMix){
//                                self.ArrProductList?.add(dict)
//                                
//                                
//                            }
//                            
//                            
//                            
//                        }
//                        self.tableView.reloadData()
//                         self.tableView.setContentOffset(CGPoint.zero, animated: true)
//                        
//                        
//                        
//                        }
//                        else{
                            self.ArrProductList?.add(dict!)

//                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                     print("banner  \(self.DataProductList)")
                    
                    if type == "GET"{
                        self.stopAnimating()

                  self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: true)

                    
                    }
                     else if type == "LoadMore"{
                        self.stopAnimating()
                        
                        self.tableView.reloadData()
//                        self.tableView.setContentOffset(CGPoint.zero, animated: true)

                    }
                    else {
                        let indexPath = NSIndexPath.init(row: self.SelectedRow!, section: 0)
//                        self.stopAnimating()

                        self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
                    }
                    
                    self.IsSortType = "NO"

                    
                    if self.SelectedSortType == "SortAlphabetical"{
                        self.SortAlphabetical()
                    }
                    else if self.SelectedSortType == "SortHighToLow"{
                        
                        self.SortHighToLowF()
                        
                    }
                    else if self.SelectedSortType == "SortLowToHigh"{
                        self.SortLowToHighF()
                    }

                    
                    }
                    
//                    }
//
//                    else{
//                        
//                    }
                }
                
                
            }
        }
        
        
        
    }

    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == childScrollView {
            self.ChildUnderLineView.frame = CGRect.init(x: CGFloat(ChildUnderLineView.frame.origin.x), y: 35, width: 150, height: 5)
            
        }
        else {
            self.ViewSegmetButtom.frame = CGRect.init(x: CGFloat(ViewSegmetButtom.frame.origin.x), y: 35, width: 150, height: 5)
            
        }

        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//
        if scrollView == childScrollView {
            self.ChildUnderLineView.frame = CGRect.init(x: CGFloat(ChildUnderLineView.frame.origin.x), y: 35, width: 150, height: 5)
//
        }
        else {
        self.ViewSegmetButtom.frame = CGRect.init(x: CGFloat(ViewSegmetButtom.frame.origin.x), y: 35, width: 150, height: 5)

        }
    }
    @IBAction func segmentedControlAction(_ sender: Any) {
        
        
        
        
        let data = DataSubCat?[segmentedControl.selectedSegmentIndex]

//        // print(DataSubCat!)

//        // print(segmentedControl.selectedSegmentIndex)

        
//        // print(data!)
      
        if segmentedControl.selectedSegmentIndex == 0 {
            ApiCallFor = "ALL"
        }
        else{
            ApiCallFor = ""

        }
        self.ArrSelectedIndex?.removeAllObjects()
        self.tableView.setContentOffset(CGPoint.zero, animated: true)

        self.limitarr = 0

        self.GetSubCatData(id: (data as AnyObject).value(forKey: "sub_category_id") as! String)

            UIView.animate(withDuration: 0.5, delay: 0.0, options: [ .curveLinear], animations: {
          self.scrollView.scrollRectToVisible(CGRect(x: CGFloat(self.segmentedControl.selectedSegmentIndex * 150) - 100, y: 0 , width: self.scrollView.frame.size.width, height: 35), animated: true)
                self.ViewSegmetButtom.frame = CGRect.init(x: CGFloat(self.segmentedControl.selectedSegmentIndex * 150), y: 35, width: 150, height: 5)
               

                
            },  completion: { (true) in

                 self.ViewSegmetButtom.frame = CGRect.init(x: CGFloat(self.segmentedControl.selectedSegmentIndex * 150), y: 35, width: 150, height: 5)
            })

        
        
        
        
        
    }
    @IBAction func ChildsegmentedControlAction(_ sender: Any) {
        
       
        
        
        let Subdata = DataSubCat?[segmentedControl.selectedSegmentIndex]
        
        
//        // print(segmentedControl.selectedSegmentIndex)
        let Cdata = DataChildCat?[ChildsegmentedControl.selectedSegmentIndex]

        
//        // print(Subdata!)
//        // print(Cdata!)

        
        
        
        // print(ChildsegmentedControl.selectedSegmentIndex)
        self.ArrSelectedIndex?.removeAllObjects()
        self.tableView.setContentOffset(CGPoint.zero, animated: true)

        self.limitarr = 0

        
        self.GetChildCatData(cid: (Cdata as AnyObject).value(forKey: "child_category_id") as! String , sid : (Subdata as AnyObject).value(forKey: "sub_category_id") as! String , type : "GET" , price_filter_id: "0" , discount_filter_id:  "0" , brand_filter_id:  "0" , limitVal:  "0")
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [ .curveLinear], animations: {
            self.childScrollView.scrollRectToVisible(CGRect(x: CGFloat(self.ChildsegmentedControl.selectedSegmentIndex * 150) - 100 , y: 0 , width: self.childScrollView.frame.size.width, height: 35), animated: true)
            self.ChildUnderLineView.frame = CGRect.init(x: CGFloat(self.ChildsegmentedControl.selectedSegmentIndex * 150), y: 35, width: 150, height: 5)
            
            
            
        },  completion: { (true) in

            self.ChildUnderLineView.frame = CGRect.init(x: CGFloat(self.ChildsegmentedControl.selectedSegmentIndex * 150), y: 35, width: 150, height: 5)
        })
        
        
        
        
        
        
    }

    override func viewWillLayoutSubviews() {
      
        
        

        scrollView.contentSize = CGSize.init(width: 150 * ArrRecentName.count, height: 30)
        
//        scrollView.contentSize = CGSize(width: 150 * ArrRecentName.count, height: SegmentControl.frame.size.height)
    }

    @IBAction func buttonFilter(_ sender: Any) {
        
        bgDarkView.isHidden = false
        filterView.isHidden = false
        filterTableView.reloadData()
        
        
    }
    @IBAction func SelectCategory(_ sender: Any) {
        
        if isCatSelect == false {
            isCatSelect = true
            
//            bgDarkView.isHidden = false
            
            var i = (ArrAllCategory?.count)! * 50
            
            
            if i >= 450 {
              i = 450
            }
          
            
            
            UIView.animate(withDuration: 1, delay: 0.0, options: [ .curveLinear], animations: {
                self.CategoryTableView.isHidden = false
                self.CategoryTableView.reloadData()
                
                
                self.CategoryTableView.frame = CGRect.init(x: self.CategoryTableView.frame.origin.x, y: self.CategoryTableView.frame.origin.y, width: self.CategoryTableView.frame.size.width, height: CGFloat(i))
                
                
            }, completion:{  finished in
            })
            
         
        }
        else {
            
            UIView.animate(withDuration: 1, delay: 0.0, options: [ .curveLinear], animations: {
//                self.bgDarkView.isHidden = true
                
                self.isCatSelect = false

                
                
                self.CategoryTableView.frame = CGRect.init(x: self.CategoryTableView.frame.origin.x, y: self.CategoryTableView.frame.origin.y, width: self.CategoryTableView.frame.size.width, height: 0)
                
                
            }, completion:{  finished in
                self.CategoryTableView.isHidden = true

            })
            
            
                   }
    }
    @IBAction func ButtonSort(_ sender: Any) {
        bgDarkView.isHidden = false
        sortView.isHidden = false
        
    }
    @IBAction func Menu(_ sender: Any) {
        
        if View_From == "MENU" {
            self.dismiss(animated: true, completion: nil)
        }
        else{
        let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
        
        
        parentVC .setDrawerState(KYDrawerController.DrawerState.opened, animated:true)
        }
//
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == filterTableView {
            
            if isBrandSelect == true {
                return (ArrBrandFilter?.count)!
            }
            else if isPriceSelect == true
            
            {
                return (ArrPriceFilter?.count)!

            }
            else {
                return (ArrDiscount?.count)!
            }
            
            
        }
        
        else if tableView == QuantityTable {
            return (DataQuantityList?.count)!
        }
        else if tableView == CategoryTableView {
            return (ArrAllCategory?.count)!
        }
        
        
        return ArrProductList!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == filterTableView {
            return 50
        }
        else if tableView == QuantityTable {
            return 50
        }
        else if tableView == CategoryTableView {
            return 50
        }
        if UIDevice.current.model .hasPrefix("iPad")
        {
            return 200
        }
        else {

        return 143
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == filterTableView {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

            if isBrandSelect == true {
                let data = ArrBrandFilter?[indexPath.row] as? NSDictionary

                if SelectedBrandID ==  data?.value(forKey: "brand_filter_id") as! String?{
                    cell.setSelected(true, animated: true)
                    
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    
                }
                
                
                
                cell.textLabel?.text = data?.value(forKey: "brand_filter_name") as! String?

            }
            else if isPriceSelect == true {
                let data = ArrPriceFilter?[indexPath.row] as? NSDictionary
                if SelectedPriceID ==  data?.value(forKey: "price_filter_id") as! String?{
                    cell.setSelected(true, animated: true)
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)

                }

                cell.textLabel?.text = data?.value(forKey: "price_filter_name") as! String?            }
            else {
                let data = ArrDiscount?[indexPath.row] as? NSDictionary
                if SelectedDiscountID ==  data?.value(forKey: "discount_filter_id") as! String?{
                    cell.setSelected(true, animated: true)
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)

                }

                cell.textLabel?.text = data?.value(forKey: "discount_filter_name") as! String?
                
            }

            
            return cell
            
        }
            
        else if tableView == QuantityTable {
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            let data = DataQuantityList?[indexPath.row] as? NSDictionary

            let weight = data?.value(forKey: "product_weight")! as! String?
            let unit = data?.value(forKey: "product_unit")! as! String?
            
            

            cell.textLabel?.text = "   Quantity- \(weight!) \(unit!)"

            
            return cell

            
        }
        else if tableView == CategoryTableView {
            
            let cell = self.CategoryTableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CategoryTableViewCell
            let data = ArrAllCategory?[indexPath.row] as? NSDictionary
            
            
            self.loadImageFromUrl(url: ((data as AnyObject).value(forKey: "category_image") as? String)!, view: cell.catImage)
            cell.catName.text = (data as AnyObject).value(forKey: "category_name") as? String
            
            return cell
            
            
        }
            
        else if tableView == self.tableView {
        
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "VEGCell", for: indexPath) as! VegetableTableViewCell
            
            
            
            if ArrProductList?.count == 0{
                return cell
            }
            
            
            let data = ArrProductList?[indexPath.row] as? NSDictionary
            
//             print(data!)
            
            self.stopAnimating()
          
            var index : Int = 0
            
            let dataPriceType = data?.value(forKey: "pricetype") as? NSArray
            
            if ArrSelectedIndex?.count != 0 {
                
            
            for i in 0...(ArrSelectedIndex?.count)! - 1{
                
                
                let data1 = ArrSelectedIndex?[i] as! NSDictionary

                if data1.value(forKey: "SelectedIndexOfIndex") as! Int == indexPath.row{
                    index = data1.value(forKey: "SelectedIndex") as! Int
                }

            }
            
            }
            
            
            let dataDict = dataPriceType?[index]
//            let price = (dataDict as AnyObject).value(forKey: "pricetype") as? NSArray
            let Sellprice = (dataDict as AnyObject).value(forKey: "selling_price") as? String
            let SellImage = (dataDict as AnyObject).value(forKey: "product_image") as? String
            let Sellproduct_id = (dataDict as AnyObject).value(forKey: "product_id") as? String

            let SellType_id = (dataDict as AnyObject).value(forKey: "product_type_id") as? String
            let SellWeight = (dataDict as AnyObject).value(forKey: "product_weight") as? String
            let Sellunit = (dataDict as AnyObject).value(forKey: "product_unit") as? String
            let SellQuantity = (dataDict as AnyObject).value(forKey: "product_quantity") as? String

           let selling_price =  Sellprice!
            
         let   product_image =   SellImage!
            let   product_id =   Sellproduct_id!

          let  product_type_id =   SellType_id!
         let   product_weight =   SellWeight!
         let   product_unit =   Sellunit!
         let   product_quantity =   SellQuantity!
            
//            let num = data?.value(forKey: "product_quantity")
            
            cell.Number.text = String(describing: product_quantity)

            
        cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.btnQuantity.addTarget(self, action: #selector(SubCatViewController.SetQuantity(_:)) , for: .touchDown)
            
            cell.btnQuantity.accessibilityElements = dataPriceType as! [Any]?
            cell.btnQuantity.tag = indexPath.row
            
               cell.btnSub.addTarget(self, action: #selector(SubCatViewController.SetSub(_:)) , for: .touchDown)
            
            
            
            cell.btnSub.tag = indexPath.row
            cell.btnSub.accessibilityLabel = product_id
            cell.btnSub.accessibilityLanguage = product_type_id
            cell.btnSub.accessibilityHint = String(describing: product_quantity)
            
               cell.btnAdd.addTarget(self, action: #selector(SubCatViewController.SetAdd(_:)) , for: .touchDown)
            cell.btnAdd.tag = indexPath.row
            cell.btnAdd.accessibilityLabel = product_id
            cell.btnAdd.accessibilityLanguage = product_type_id
            cell.btnAdd.accessibilityHint = String(describing: product_quantity)

            
            if (data as AnyObject).value(forKey: "stock_status") as? String == "In Stock" {
                cell.cost.isHidden = false
                cell.btnAdd.isHidden = false
                cell.btnSub.isHidden = false
                cell.Number.isHidden = false
                cell.lblOutOfStock.isHidden = true
            }
            else{
                cell.cost.isHidden = true
                cell.btnAdd.isHidden = true
                cell.btnSub.isHidden = true
                cell.Number.isHidden = true
                cell.lblOutOfStock.isHidden = false

            }
            
            if (data as AnyObject).value(forKey: "wishlist_status") as? String == "added" {
                cell.btnFav.addTarget(self, action: #selector(SubCatViewController.btnUNFav(_:)) , for: .touchDown)
                
                cell.btnFav.setBackgroundImage(#imageLiteral(resourceName: "greenfav"), for: .normal)
                
            }
            else{
            
            cell.btnFav.addTarget(self, action: #selector(SubCatViewController.btnFav(_:)) , for: .touchDown)
                cell.btnFav.setBackgroundImage(#imageLiteral(resourceName: "GrayFav"), for: .normal)

            }
            
             cell.btnSelectedButton.addTarget(self, action: #selector(SubCatViewController.DetailView(_:)) , for: .touchDown)
            
            cell.btnSelectedButton.tag  = indexPath.row
            
            
            cell.btnFav.tag = indexPath.row
            cell.btnFav.accessibilityLabel = product_id
            cell.btnFav.accessibilityLanguage = product_type_id
            
            
            let weight = product_weight
            let unit = product_unit

            
               cell.btnQuantity.setTitle("   Quantity- \(weight) \(unit)", for: .normal)
        
            

            
            
            loadImageFromUrl(url: product_image , view: cell.vIMage)

            
            cell.name.text = (data as AnyObject).value(forKey: "product_name") as? String
            
            let cost = selling_price
            
            cell.cost.text = "Rs \(cost)"
//                        self.SelectedIndex = 0

            
            return cell

        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView == QuantityTable {
            bgDarkView.isHidden = true
            QuantityView.isHidden = true
            self.SelectedIndex = indexPath.row
            self.SelectedIndexOfIndex = self.SelectedRow
            
            let dict = [
                "SelectedIndex" : SelectedIndex,
                "SelectedIndexOfIndex" : SelectedIndexOfIndex
            ]
            
            
            if ArrSelectedIndex?.count != 0 {
            
            
            for i in 0...(ArrSelectedIndex?.count)! - 1 {
                let data = ArrSelectedIndex?[i] as! NSDictionary
               
                
                if data.value(forKey: "SelectedIndexOfIndex") as! Int == SelectedRow{
                    ArrSelectedIndex?.removeObject(at: i)
                }
                
                
            }
            
            }
            
            
            ArrSelectedIndex?.add(dict)
            
            let indexPath = NSIndexPath.init(row: self.SelectedRow!, section: 0)
            
            
            
            
            
            
            self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
            
            
        }
        
        if tableView == filterTableView {
            
            
            FilterPriceSelect = ""
            
            if isBrandSelect == true {
                let data = ArrBrandFilter?[indexPath.row] as? NSDictionary
                
                SelectedBrandID = data?.value(forKey: "brand_filter_id") as! String?
                
            }
            else if isPriceSelect == true {
                let data = ArrPriceFilter?[indexPath.row] as? NSDictionary
                
                SelectedPriceID = data?.value(forKey: "price_filter_id") as! String?            }
            else {
                let data = ArrDiscount?[indexPath.row] as? NSDictionary
                
                SelectedDiscountID = data?.value(forKey: "discount_filter_id") as! String?
                
            }

            
            
            
        }
        
        
        if tableView == CategoryTableView {
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [ .curveLinear], animations: {
                //                self.bgDarkView.isHidden = true
                
                self.isCatSelect = false
                
                self.ChildUnderLineView.frame =  CGRect.init(x: 0, y: 35, width: 150 , height: 5)
                self.ViewSegmetButtom.frame =  CGRect.init(x: 0, y: 35, width: 150 , height: 5)
//                self.segmentedControl.selectedSegmentIndex = 0
                self.CategoryTableView.frame = CGRect.init(x: self.CategoryTableView.frame.origin.x, y: self.CategoryTableView.frame.origin.y, width: self.CategoryTableView.frame.size.width, height: 0)
                
                
            }, completion:{  finished in
                self.CategoryTableView.isHidden = true
                let data = self.ArrAllCategory?[indexPath.row] as? NSDictionary
                self.TitleView.text = (data as AnyObject).value(forKey: "category_name") as? String
                
                self.category_id = (data as AnyObject).value(forKey: "category_id") as? String
                
                
                if self.DataChildCat?.count != 0{
                    self.ChildsegmentedControl.removeAllSegments()
                }
                
//                self.ArrProductList?.removeAllObjects()
                self.ArrDiscount?.removeAllObjects()
                self.ArrPriceFilter?.removeAllObjects()
                self.ArrBrandFilter?.removeAllObjects()
                
                self.ArrFinalProductList?.removeAllObjects()
                
                self.DataSubCat?.removeAllObjects()
                self.DataChildCat?.removeAllObjects()
                self.DataProductList?.removeAllObjects()
                
                self.DataQuantityList?.removeAllObjects()

                
                self.ArrRecentName.removeAllObjects()
                self.ArrChildCatName.removeAllObjects()
                self.ArrChildCat.removeAllObjects()

              
                self.segmentedControl.removeAllSegments()
                self.limitarr = 0
                self.tableView.reloadData()
                self.ApiCallFor = "ALL"

                self.GetCatData()
                
                
            })

            
            
            
            


          

            
        }
            
        else {
        
//        let IVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
//        let data = DataProductList?[indexPath.row]
//        IVC.product_id = (data as AnyObject).value(forKey: "product_id") as? String
//        self.present(IVC, animated: true, completion: nil)
        
        
        }
        
        
        
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            
        
        
        let lastElement = (ArrProductList?.count)! - 1
        
        

        if indexPath.row == lastElement {
            // handle your logic here to get more items, add it to dataSource and reload tableview
            print("Table View\(lastElement)")
            print("Table View index\(indexPath.row)")
            limitarr = limitarr + 1

            
            
                   self.GetChildCatData(cid :  ChildCatID  , sid: SubCatID , type : "LoadMore" , price_filter_id: "0" , discount_filter_id:  "0" , brand_filter_id:  "0" , limitVal:  "\(limitarr)")
            
        }
        }
    }
    
    @IBAction func DetailView(_ sender: UIButton) {
        
        let IVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        let data = DataProductList?[sender.tag]
        IVC.product_id = (data as AnyObject).value(forKey: "product_id") as? String
        self.present(IVC, animated: true, completion: nil)

    }
    @IBAction func SetQuantity(_ sender: Any) {
        
        bgDarkView.isHidden = false
        QuantityView.isHidden = false
        
        
        let x  = (sender as AnyObject).tag
        DataQuantityList?.removeAllObjects()
        // print(x)
        
        
        let data = ArrProductList?.object(at: x!) as? NSDictionary
        
        
        let dataPriceType = data?.value(forKey: "pricetype") as? NSArray
        
//        QuantityView.frame = CGRect.init(x: QuantityView.frame.origin.x, y: QuantityView.frame.origin.y, width: QuantityView.frame.size.width, height: )
        C_Quantity_H.constant = CGFloat((dataPriceType?.count)! * 50) + 50
        

        for i in 0...(dataPriceType?.count)! - 1 {

            let dataDict = dataPriceType?[i]
            
            let Sellprice = (dataDict as AnyObject).value(forKey: "selling_price") as? String
            let SellImage = (dataDict as AnyObject).value(forKey: "product_image") as? String
            let Sellproduct_id = (dataDict as AnyObject).value(forKey: "product_id") as? String
            
            let SellType_id = (dataDict as AnyObject).value(forKey: "product_type_id") as? String
            let SellWeight = (dataDict as AnyObject).value(forKey: "product_weight") as? String
            let Sellunit = (dataDict as AnyObject).value(forKey: "product_unit") as? String
            let SellQuantity = (dataDict as AnyObject).value(forKey: "product_quantity") as? String
            let dict : NSDictionary?

             dict = [
                "selling_price" :  Sellprice! ,
                
                "product_image" :   SellImage!,
                
                "product_type_id" :   SellType_id!,
                "product_weight" :   SellWeight!,
                "product_unit" :   Sellunit!,
                "product_quantity" :   SellQuantity!,
                "product_id" : Sellproduct_id!
            
            ]
            DataQuantityList?.add(dict!)
            
        
        }
        SelectedRow = x!
       self.QuantityTable.reloadData()
        
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
    @IBAction func btnFav(_ sender: UIButton) {
        
        
        var Baseurl = "apiAddWishlist.php"
        
        //       city_id:1
//        customer_id:11
//        product_id:1
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!,
            "product_id" : sender.accessibilityLabel!,
         
            
            ]
        
        
        let x  = sender.tag
        
        // print(x)
        
        
        let data = ArrProductList?.object(at: x) as? NSDictionary

       
        
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
                            
                            
                            let   dataend = [
                                "product_quantity" :   (data as AnyObject).value(forKey: "product_quantity") as Any,
                                
                                "product_id" :   (data as AnyObject).value(forKey: "product_id") as Any,
                                "product_name" :   (data as AnyObject).value(forKey: "product_name") as? String as Any,
                                
                                "stock_status" :   (data as AnyObject).value(forKey: "stock_status") as? String as Any,
                                
                                "sub_category_id" :   (data as AnyObject).value(forKey: "sub_category_id") as? String as Any,
                                "wishlist_status" :  "added",
                                "product_code" :   (data as AnyObject).value(forKey: "product_code") as? String as Any,
                                "category_id" :   (data as AnyObject).value(forKey: "category_id") as? String as Any,
                                "child_category_id" :   (data as AnyObject).value(forKey: "child_category_id") as? String as Any,
                                "selling_price" :  (data as AnyObject).value(forKey: "selling_price") as? String as Any ,
                                
                                "product_image" :   (data as AnyObject).value(forKey: "product_image") as? String as Any,
                                
                                "product_type_id" :   (data as AnyObject).value(forKey: "product_type_id") as? String as Any,
                                "product_weight" :   (data as AnyObject).value(forKey: "product_weight") as? String as Any,
                                "product_unit" :   (data as AnyObject).value(forKey: "product_unit") as? String as Any,
                                
                                 "pricetype" :   (data as AnyObject).value(forKey: "pricetype") as? NSArray as Any,
                                ]
                            
                            self.ArrProductList?.removeObject(at: x)
                            
                            self.ArrProductList?.insert(dataend, at: x)
                            
                            let indexPath = NSIndexPath.init(row: x, section: 0)
                            
                            self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
                            
                            
                            
                            
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
    @IBAction func btnUNFav(_ sender: UIButton) {
        
        
        var Baseurl = "apiRemoveWishlist.php"
        
        //       city_id:1
        //        customer_id:11
        //        product_id:1
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "customer_id" : UserDefaults.standard.value(forKey: "id")!,
            "product_id" : sender.accessibilityLabel!,
            
            
            ]
        
        let x  = sender.tag
        
        
        
        let data = ArrProductList?.object(at: x) as? NSDictionary

     
        
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
            
            self.dataModel.GetApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
                
                
                self.stopAnimating()
                
                
                if dataCoun.1 as String == "FAILURE"{
                    self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                    
                }
                else{
                    
                    let dataCount = dataCoun.0
                    
                    
                    
                    
                    if (dataCount as AnyObject).value(forKey: "status") as? String == "Deleted Successfully" {
                        
                        
                        let   dataend = [
                            "product_quantity" :   (data as AnyObject).value(forKey: "product_quantity") as Any,
                            
                            "product_id" :   (data as AnyObject).value(forKey: "product_id") as Any,
                            "product_name" :   (data as AnyObject).value(forKey: "product_name") as? String as Any,
                            
                            "stock_status" :   (data as AnyObject).value(forKey: "stock_status") as? String as Any,
                            
                            "sub_category_id" :   (data as AnyObject).value(forKey: "sub_category_id") as? String as Any,
                            "wishlist_status" :  "",
                            "product_code" :   (data as AnyObject).value(forKey: "product_code") as? String as Any,
                            "category_id" :   (data as AnyObject).value(forKey: "category_id") as? String as Any,
                            "child_category_id" :   (data as AnyObject).value(forKey: "child_category_id") as? String as Any,
                            "selling_price" :  (data as AnyObject).value(forKey: "selling_price") as? String as Any ,
                            
                            "product_image" :   (data as AnyObject).value(forKey: "product_image") as? String as Any,
                            
                            "product_type_id" :   (data as AnyObject).value(forKey: "product_type_id") as? String as Any,
                            "product_weight" :   (data as AnyObject).value(forKey: "product_weight") as? String as Any,
                            "product_unit" :   (data as AnyObject).value(forKey: "product_unit") as? String as Any,
                            
                            "pricetype" :   (data as AnyObject).value(forKey: "pricetype") as? NSArray as Any,
                            ]
                        
                        self.ArrProductList?.removeObject(at: x)
                        
                        self.ArrProductList?.insert(dataend, at: x)
                        
                        let indexPath = NSIndexPath.init(row: x, section: 0)
                        
                        self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)

                        
                        
                        
                    }
                        
                    else{
                        //
                        //                    let dataCount = dataCoun.0[0]
                             self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                        

                        
                        
                        
                
            }
            
            
        }
        
        
        
        }
        
    }

   
    @IBAction func SetSub(_ sender: UIButton) {
        
        
        
        let count = Int(sender.accessibilityHint!)
        
        if count! <= 0 {
            
        }
        else{
        
        let x  = sender.tag
         let data = ArrProductList?.object(at: x) as? NSDictionary

        
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
                
                self.SelectedRow = x

                let num = (data?.value(forKey: "product_quantity") as! NSString).doubleValue
                
                var i = Int(num)
                
                i = i - 1
                let str = String(i)
                self.GetChildCatData(cid: self.ChildCatID!, sid: self.SubCatID!, type: "UPDATE" ,  price_filter_id: "0" , discount_filter_id:  "0" , brand_filter_id:  "0" , limitVal:  "0")

                if (dataCount as AnyObject).value(forKey: "status") as? String == "Updated Successfully" {

                
                    
                    

                    self.GetCartCountData()
                    
                    
                    
                }
                    else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Product Deleted Successfully" {
                    
                    
                
                    
                                      self.GetCartCountData()
                    

                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Added Successfully" {
                    
                    
                
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
//        tableView.reloadData()
        
        
        
    }
    @IBAction func SetAdd(_ sender: UIButton) {
        
        
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
        
        
        
        
        
//        let num : String = sender.accessibilityValue!
//        var x  = Int(num)
        let x  = sender.tag
//        if SelectedRow != x {
//            SelectedIndex = 0
//        }
      
        
        let data = ArrProductList?.object(at: x) as? NSDictionary

        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCoun) in
            
            
            self.stopAnimating()
            
            
            if dataCoun.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCount = dataCoun.0

                // print(dataCount)
                
                
                let num = (data?.value(forKey: "product_quantity") as! NSString).doubleValue
                
                var i = Int(num)
                
                i = i + 1
                
                self.SelectedRow = x

                
                self.GetChildCatData(cid: self.ChildCatID!, sid: self.SubCatID!, type: "UPDATE" ,  price_filter_id: "0" , discount_filter_id:  "0" , brand_filter_id:  "0" , limitVal:  "0")
                
                
                if (dataCount as AnyObject).value(forKey: "status") as? String == "Updated Successfully" {
                    
                    
                 
                                      self.GetCartCountData()
                    
                    
                    
                }
                else   if (dataCount as AnyObject).value(forKey: "status") as? String == "Added Successfully" {
                    
                    
                   

                    
                  
                    
                                      self.GetCartCountData()
                    
                    
                }
                    
                else{
                    //
                    //                    let dataCount = dataCoun.0[0]
                    
                    
                    self.GetCartCountData()
                    
                    self.ShowAlertOK(sender: (dataCount as AnyObject).value(forKey: "status")  as! NSString)
                    

                    
                    
                    
                    
                }
                
                
            }
        }
        

        
//        tableView.reloadData()

        
        
    }
    @IBAction func PriceButton(_ sender: Any) {
        
//        if isPriceSelect == true{
        btnBrand.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        btnPrice.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            isBrandSelect = false
        isPriceSelect = true
        btnDiscount.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        isDiscountSelect = false

        filterTableView.reloadData()

//
//        }
//        else {
//            btnBrand.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//            btnPrice.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            isBrandSelect = true
//            
//        }

        
    }
    
    @IBAction func CloseFilterButton(_ sender: Any) {
        bgDarkView.isHidden = true
        filterView.isHidden = true
        
    }
    
    @IBAction func DiscountButton(_ sender: Any) {
        btnBrand.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        btnPrice.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        btnDiscount.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        isPriceSelect = false
        isBrandSelect = false
        isDiscountSelect = true
        filterTableView.reloadData()
    }
    @IBAction func BrandButton(_ sender: Any) {
        
//        if isBrandSelect == false{
            btnBrand.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            btnPrice.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        btnDiscount.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
            isPriceSelect = false
        isBrandSelect = true
        isDiscountSelect = false
        filterTableView.reloadData()

//
//        }
//        else {
//            btnBrand.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//            btnPrice.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            isBrandSelect = false
//
//        }
        
    }
    
    @IBAction func CancelSortView(_ sender: Any) {
        
        bgDarkView.isHidden = true
        sortView.isHidden = true
        SelectedSortType = ""
        IsSortType = "NO"

    }
    @IBAction func ActionSort(_ sender: Any) {
        bgDarkView.isHidden = true
        sortView.isHidden = true
        IsSortType = "YES"
        if SortTypeSelect == "SortAlphabetical"{
          SortAlphabetical()
        }
        else if SortTypeSelect == "SortHighToLow"{
        
       SortHighToLowF()
           
                  }
        else if SortTypeSelect == "SortLowToHigh"{
           SortLowToHighF()
        }

        
        
    }
    
    func SortLowToHighF()  {
        let sortedArray =  ArrProductList?.sorted{
            Int((($0 as! Dictionary<String, AnyObject>)["selling_price"] as? String)!)! < Int((($1 as! Dictionary<String, AnyObject>)["selling_price"] as! String))!
        }
        
        SelectedSortType = "SortLowToHigh"
        
        ArrProductList?.removeAllObjects()
        
        for i in 0...(sortedArray?.count)! - 1 {
            ArrProductList?.add(sortedArray?[i] ?? NSDictionary.self)
        }
        if IsSortType == "NO"{
            tableView.reloadData()

        }
        else{
        IsSortType = "YES"
        tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    func SortHighToLowF()  {
        let sortedArray =  ArrProductList?.sorted{
            Int((($0 as! Dictionary<String, AnyObject>)["selling_price"] as? String)!)! > Int((($1 as! Dictionary<String, AnyObject>)["selling_price"] as! String))!
        }
        
        SelectedSortType = "SortHighToLow"
        
        ArrProductList?.removeAllObjects()
        
        for i in 0...(sortedArray?.count)! - 1 {
            ArrProductList?.add(sortedArray?[i] ?? NSDictionary.self)
        }
        if IsSortType == "NO"{
            tableView.reloadData()

        }
        else{
            IsSortType = "YES"
        tableView.reloadData()
        
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    func SortAlphabetical()  {
        let sortedArray =  ArrProductList?.sorted{
            (($0 as! Dictionary<String, AnyObject>)["product_name"] as? String)! < (($1 as! Dictionary<String, AnyObject>)["product_name"] as! String)
        }
        
        SelectedSortType = "SortAlphabetical"
        ArrProductList?.removeAllObjects()
        
        for i in 0...(sortedArray?.count)! - 1 {
            ArrProductList?.add(sortedArray?[i] ?? NSDictionary.self)
        }
        
        if IsSortType == "NO"{
            tableView.reloadData()

        }
        else{
            IsSortType = "YES"
        
        tableView.reloadData()
        
        
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    @IBAction func SortAlphabetical(_ sender: Any) {
        
        btnlowtoHigh.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: UIControlState.normal)
        btnHighToLow.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: UIControlState.normal)
        btnAlphabetical.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: UIControlState.normal)

        SortTypeSelect = "SortAlphabetical"

        
        
        
        
        
    }
    @IBAction func SortHighToLow(_ sender: Any) {
        
        btnlowtoHigh.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: UIControlState.normal)
        btnHighToLow.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: UIControlState.normal)
        btnAlphabetical.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: UIControlState.normal)
        SortTypeSelect = "SortHighToLow"

        
    }
    @IBOutlet weak var SortHighToLow: UIButton!
    @IBAction func SortLowToHigh(_ sender: Any) {
        btnHighToLow.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: UIControlState.normal)
        btnlowtoHigh.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_on"), for: UIControlState.normal)
        btnAlphabetical.setBackgroundImage(#imageLiteral(resourceName: "ic_action_toggle_radio_button_off"), for: UIControlState.normal)
        
        SortTypeSelect = "SortLowToHigh"
        
    }
    @IBAction func resetButton(_ sender: Any) {
        
        resetFilter()
    }
    
    func resetFilter() {
        FilterPriceSelect = ""
        
        SelectedDiscountID = "0"
        SelectedPriceID = "0"
        SelectedBrandID = "0"
        
        ArrSelectedIndex?.removeAllObjects()
        
        self.GetCatData()
        bgDarkView.isHidden = true
        filterView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [ .curveLinear], animations: {
            self.childScrollView.scrollRectToVisible(CGRect(x: 0 , y: 0 , width: self.childScrollView.frame.size.width, height: 35), animated: true)
            self.ChildUnderLineView.frame = CGRect.init(x: 0, y: 35, width: 150, height: 5)
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0 , width: self.scrollView.frame.size.width, height: 35), animated: true)
            self.ViewSegmetButtom.frame = CGRect.init(x: 0, y: 35, width: 150, height: 5)
            
            
        },  completion: { (true) in
            
            self.ChildUnderLineView.frame = CGRect.init(x: 0, y: 35, width: 150, height: 5)
            self.ViewSegmetButtom.frame = CGRect.init(x: 0, y: 35, width: 150, height: 5)
        })
        

    }
    
    
    @IBAction func ApplyButton(_ sender: Any) {
        bgDarkView.isHidden = true
        filterView.isHidden = true
        self.GetCatData()

        
//        let TempListArr : NSMutableArray! = []
//        
//        TempListArr.removeAllObjects()
//        
//        for i in 0...(ArrFinalProductList?.count)! - 1 {
//
//            TempListArr.add(ArrFinalProductList?[i] as Any)
//            
//            
//        }
//        
//        
//        ArrProductList?.removeAllObjects()
//
//        var DataMim : Int!
//        var DataMix : Int!
//
//        
//        if FilterPriceSelect == "0" {
//            DataMim = 100
//            DataMix = 500
//        }
//        else  if FilterPriceSelect == "1" {
//            DataMim = 500
//            DataMix = 1000
//        }
//        
//        else  if FilterPriceSelect == "2" {
//            DataMim = 1000
//            DataMix = 5000
//        }
//        
//        for i in 0...TempListArr.count - 1 {
//            
//            
//            let dict = TempListArr[i] as! NSDictionary
//            
//            let price = dict.value(forKey: "selling_price") as! String
//            
//            if (Int(price)! >= DataMim) && (Int(price)! <= DataMix){
//                ArrProductList?.add(dict)
//                
//                
//            }
//            
//            
//            
//        }
//        tableView.reloadData()
//
        
        
        
        
        
        
        
        
        
        
    }
    @IBAction func MyCart(_ sender: Any) {
        
        
        if btnCart.title(for: .normal)! as String == "0"{
            ShowAlertOK(sender: "There is no item in the cart")
        }
        else{
        
        
        let CVC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.present(CVC, animated: true, completion: nil)
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

    @IBAction func Search(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.present(vc, animated: true, completion: nil)
        
        
    }
    func ShowAlertOK(sender : NSString)  {
        
        let alert = UIAlertController(title: "Alert", message: sender as String, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    func ShowAlertFilterOK(sender : NSString)  {
        
        let alert = UIAlertController(title: "Alert", message: sender as String, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
            self.resetFilter()
            
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }

}

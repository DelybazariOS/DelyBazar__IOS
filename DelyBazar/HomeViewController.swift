//
//  HomeViewController.swift
//  DelyBazar
//
//  Created by OSX on 15/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import Alamofire

import NVActivityIndicatorView

class HomeViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UITableViewDelegate , UITableViewDataSource , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblRecentview: UILabel!
    
    
    @IBOutlet weak var viewPin: UIView!
    @IBOutlet weak var btnCart: UIButton!
    
    @IBOutlet weak var catimg4: UIImageView!
    @IBOutlet weak var lblPincode: UILabel!
    @IBOutlet weak var catTitle3: UILabel!

    @IBOutlet weak var catTitle2: UILabel!
    @IBOutlet weak var catTitle1: UILabel!
    @IBOutlet weak var NoDataView: UIView!
    @IBOutlet weak var catimg3: UIImageView!
    @IBOutlet weak var catImg2: UIImageView!
    @IBOutlet weak var catImg1: UIImageView!
    @IBOutlet weak var C_More_View_H: NSLayoutConstraint!
    @IBOutlet weak var MoreView: UIView!
    @IBOutlet weak var moreCollectionView: UICollectionView!
    @IBOutlet weak var C_Cat_Btn_W: NSLayoutConstraint!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var C_Table_H: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var RecentCollectionView: UICollectionView!
    @IBOutlet weak var SliderCollectionView: UICollectionView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnCat1: UIButton!
    @IBOutlet weak var btnCat2: UIButton!
    @IBOutlet weak var btnCat3: UIButton!
    @IBOutlet weak var btnMore: UIButton!

    
    
    var ScrollIndex : Int = 0
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var activityIndicatorView : NVActivityIndicatorView?
    
    var HomeToCart_ID : String = ""
    var HomeToCart_Name : String = ""
    var HomeToCart_Is_From : String = ""

    var isMoreOpen : Bool = false
    
    var ArrSlider : NSMutableArray = [  ]
//    var ArrRecent : NSMutableArray = [ #imageLiteral(resourceName: "tom") , #imageLiteral(resourceName: "lem") , #imageLiteral(resourceName: "apple") , #imageLiteral(resourceName: "strab") , #imageLiteral(resourceName: "tom")]
    var ArrRecentName : NSMutableArray = [ ]
//    var ArrRecentCode : NSMutableArray = [ "1Kg Rs/-20" , "1Kg Rs/-70" , "1Kg Rs/-120" , "1Kg Rs/-220" , "1Kg Rs/-20"]

    
    var ArrBanner : NSMutableArray = [  ]
    var ArrMore : NSMutableArray = []

    var ArrMoreName : NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MoreView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor
        MoreView.layer.borderWidth = 1
        MoreView.layer.cornerRadius = 2
       
       tableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
//        let city_id = UserDefaults.standard.string(forKey: "city_id")! as! String

        
        
        if (UserDefaults.standard.string(forKey: "city_id") == nil) {
            viewPin.isHidden = false
            btnCart.isEnabled = false
            
            
            
            
        }
        else
        {
            viewPin.isHidden = true
            btnCart.isEnabled = true

        self.GetBannerData()
        self.GetLowerBannerData()
        self.GetCatData()
        self.GetRecentData()
            lblPincode.text = UserDefaults.standard.value(forKey: "city_pin")! as? String

        }

              // Do any additional setup after loading the view.
    }
    func ScrollBanner() {
        // Something cool
        let count = ArrSlider.count
        
        if ArrSlider.count > 0{
           
            
            if ScrollIndex > count - 1
            {
                ScrollIndex = 0
            }
            
//            print(ScrollIndex)
            let indexPath = NSIndexPath.init(row: ScrollIndex, section: 0)
            ScrollIndex += 1
            SliderCollectionView.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.C_More_View_H.constant = 0
        isMoreOpen = false
        catimg4.image = #imageLiteral(resourceName: "more")
        btnMore.setTitle("More", for: .normal)
        if (UserDefaults.standard.string(forKey: "city_id") == nil) {
            viewPin.isHidden = false
        }
        else
        {
        self.GetCartCountData()
        }
        C_Cat_Btn_W.constant = self.view.frame.size.width/4
        
        self.navigationController?.isNavigationBarHidden = true
//        UserDefaults.standard.set("NO", forKey: "HomeToCart_Is_From")

        if "YES" == UserDefaults.standard.string(forKey: "HomeToCart_Is_From") {
            UserDefaults.standard.set("NO", forKey: "HomeToCart_Is_From")

            HomeToCart()

        }
        
    }
    
    func HomeToCart()  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubCatViewController") as! SubCatViewController
        nextViewController.category_id  = UserDefaults.standard.string(forKey: "HomeToCart_ID")!
        nextViewController.CatName  = UserDefaults.standard.string(forKey: "HomeToCart_Name")!
        nextViewController.View_From = "HOME"
        
        
        self.navigationController?.pushViewController(nextViewController, animated: true)

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
                    self.NoDataView.isHidden = false
                    
                }
                    
                else{
                    
                    print("banner  \(dataCoun.0.count)")
//                    let dataCount = dataCoun.0[0]

                    
                   self.btnCart.setTitle((dataCount as AnyObject).value(forKey: "total_cart") as? String , for: .normal)
                 
                    
                }
                
                
            }
        }
        
    }
    func GetCatData()  {
        //        http://delybazar.in/mobile-app/apiSubCategory.php
        var Baseurl = "apiCategory.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
                        "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            
//            "city_id" : "1"
        ]
        
        
        
        
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetHomeCatApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataCat) in
            
            
            self.stopAnimating()
            
            
            if dataCat.1 as String == "FAILURE"{
                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataCate = dataCat.0[0]
                
                
                
                
                if (dataCate as AnyObject).value(forKey: "status") as? String != nil {
//                    self.ShowAlertOK(sender: (dataCate as AnyObject).value(forKey: "status")  as! NSString)
                    self.NoDataView.isHidden = false

                }
                    
                else{
                    
                    print("banner  \(dataCat.0.count)")
                    
                    for i in 0...dataCat.0.count - 1 {
                        self.ArrMoreName.add(dataCat.0[i])
                    }
                    let data1 = self.ArrMoreName[0]
                    
                    let data2 = self.ArrMoreName[1]
                    
                    let data3 = self.ArrMoreName[2]
                  
                    self.btnMore.isHidden = false
                    self.catTitle1.text = (data1 as AnyObject).value(forKey: "category_name") as? String
                    
                    self.btnCat1.accessibilityValue = (data1 as AnyObject).value(forKey: "category_id") as? String
                    
                    
                    self.loadImageFromUrl(url: (data1 as AnyObject).value(forKey: "category_image") as! String, view: self.catImg1)
                    
                   
                    
                    self.catTitle2.text = (data2 as AnyObject).value(forKey: "category_name") as? String
                    
                    self.btnCat2.accessibilityValue = (data2 as AnyObject).value(forKey: "category_id") as? String

                    self.loadImageFromUrl(url: (data2 as AnyObject).value(forKey: "category_image") as! String, view: self.catImg2)
                    
                  
                     self.catTitle3.text = (data3 as AnyObject).value(forKey: "category_name") as? String
                    self.btnCat3.accessibilityValue = (data3 as AnyObject).value(forKey: "category_id") as? String

                    self.loadImageFromUrl(url: (data3 as AnyObject).value(forKey: "category_image") as! String, view: self.catimg3)
                    
                    self.moreCollectionView.reloadData()
                    
                }
                
                
            }
        }
        
        
        
    }

   
    
    
       
    func GetBannerData()  {
     
        var Baseurl = "apiAdvertisement.php"
        
//        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
                        "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            
//            "city_id" : "1"
        ]
        
        
        
        
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetBannerApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataAd) in
            
            
            self.stopAnimating()
            
            
            if dataAd.1 as String == "FAILURE"{
//                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let DataCate = dataAd.0[0]
                
                
                

                if (DataCate as AnyObject).value(forKey: "status") as? String != nil {
//                    self.ShowAlertOK(sender: (DataCate as AnyObject).value(forKey: "status")  as! NSString)
                    self.NoDataView.isHidden = false

                }
                
                else{
                    
                   print("banner  \(dataAd.0.count)")
                    
                    for i in 0...dataAd.0.count - 1 {
                    self.ArrBanner.add(dataAd.0[i])
                    }
                    var i = 0
                    if UIDevice.current.model .hasPrefix("iPad")
                    {
                         i = (self.ArrBanner.count) * 250
                    }
                    else {
                         i = (self.ArrBanner.count) * 178
                    }

                    
                    
                    self.C_Table_H.constant = CGFloat(i)
                    
                    self.tableView.reloadData()
                }
                

            }
        }
        

        
    }
    func GetRecentData()  {
        
        var Baseurl = "apiRecentViewed.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
                                    "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            
//            "city_id" : "1"
        ]
        
        
        
        
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetRecentApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataRec) in
            
            
            self.stopAnimating()
            
            
            if dataRec.1 as String == "FAILURE"{
//                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataRece = dataRec.0[0]
                
                
                
                
                if (dataRece as AnyObject).value(forKey: "status") as? String != nil {
//                    self.ShowAlertOK(sender: (dataRece as AnyObject).value(forKey: "status")  as! NSString)
                    
                    self.NoDataView.isHidden = false
                    
                    
                }
                    
                else{
                    
                    print("banner  \(dataRec.0.count)")
                    
                    for i in 0...dataRec.0.count - 1 {
                        self.ArrRecentName.add(dataRec.0[i])
                    }
                  
                    self.lblRecentview.isHidden = false
                    self.RecentCollectionView.reloadData()
                }
                
                
            }
        }
        
        
        
    }

    func GetLowerBannerData()  {
        
        var Baseurl = "apiBanner.php"
        
        //        var url = "\(Baseurl)apiBanner.php"
        
        let dict = [
                                    "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            
//            "city_id" : "1"
        ]
        
        
        
        
        
        print(dict)
        
        Baseurl = Baseurl.replacingOccurrences(of: " ", with: "%20")
        
        
        self.dataModel.GetLowerBannerApi(Url: Baseurl as String as NSString, dict: dict as NSDictionary){ (dataBann) in
            
            
            self.stopAnimating()
            
            
            if dataBann.1 as String == "FAILURE"{
//                self.ShowAlertOK(sender: "Server not respond. Try after some time..")
                
            }
            else{
                
                let dataBanner = dataBann.0[0]
                
                
                
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String != nil {
//                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    self.NoDataView.isHidden = false

                }
                    
                else{
                    
                    print("banner  \(dataBann.0.count)")
                    
                    for i in 0...dataBann.0.count - 1 {
                        self.ArrSlider.add(dataBann.0[i])
                    }
                    
                    
                    
                    self.SliderCollectionView.reloadData()
                    _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(HomeViewController.ScrollBanner), userInfo: nil, repeats: true)

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

    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
//        tableView.frame = CGRect.init(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: 1280)
//        ScrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height: 1600)

//        let i = (ArrBanner.count) * 128
//        
//        C_Table_H.constant = CGFloat(i)
      
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MyCart(_ sender: Any) {
        
        if (btnCart.title(for: .normal)! as String) == "0"{
            ShowAlertOK(sender: "There is no item in the cart")
        }
        else{
            
            
            let CVC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            self.present(CVC, animated: true, completion: nil)
        }

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == RecentCollectionView{
            return ArrRecentName.count
            
        }
        else if collectionView == moreCollectionView{
            
            return ArrMoreName.count - 3
            
        }
        else{
            return ArrSlider.count
            
        }    }
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        if collectionView == RecentCollectionView{
            return CGSize.init(width: 130 , height: 138)

        }
        else if collectionView == moreCollectionView{
            
            return CGSize.init(width: self.view.frame.size.width/4 - 10 , height: self.view.frame.size.width/4 + 10)
            
        }
     else{
            return CGSize.init(width: self.view.frame.size.width, height: 250)

        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == RecentCollectionView{
            let cell = RecentCollectionView.dequeueReusableCell(withReuseIdentifier: "RCell", for: indexPath) as! RecentCollectionViewCell
       
            
            let dataRec = ArrRecentName[indexPath.row]
            print(indexPath.row)

            print(dataRec)
            let strImg = (dataRec as AnyObject).value(forKey: "product_image") as! String
            print(strImg)

            loadImageFromUrl(url: strImg , view: cell.RImage!)
            cell.Rname.text =  (dataRec as AnyObject).value(forKey: "product_name") as? String
            cell.RDis.text = "\((dataRec as AnyObject).value(forKey: "product_weight")! as! String)\((dataRec as AnyObject).value(forKey: "product_unit")! as! String) Rs.\((dataRec as AnyObject).value(forKey: "selling_price")! as! String)/-"

            return cell

        }
        else  if collectionView == moreCollectionView{
            let cell = moreCollectionView.dequeueReusableCell(withReuseIdentifier: "MCell", for: indexPath) as! MoreCollectionViewCell
            
            let dataMore = ArrMoreName[indexPath.row + 3]
            
           

            loadImageFromUrl(url: (dataMore as AnyObject).value(forKey: "category_image") as! String, view: cell.Mimage!)
            

          

            cell.Mname.text = (dataMore as AnyObject).value(forKey: "category_name") as? String
            
            return cell
        }
            
        else {
        
      let cell = SliderCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SliderCollectionViewCell
            
//            cell.frame.size.width = self.view.frame.size.width
            
            let dataS = ArrSlider[indexPath.row]
            loadImageFromUrl(url: (dataS as AnyObject).value(forKey: "carousel_image") as! String, view: (cell.Slidimage)!)

        return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == RecentCollectionView{
            
            let IVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
            let data = ArrRecentName[indexPath.row]
            IVC.product_id = (data as AnyObject).value(forKey: "product_id") as? String
            self.present(IVC, animated: true, completion: nil)

    
        }
        else  if collectionView == moreCollectionView{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let data = ArrMoreName[indexPath.row + 3]

            
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubCatViewController") as! SubCatViewController
            
            nextViewController.category_id = (data as AnyObject).value(forKey: "category_id") as! String
            nextViewController.CatName = (data as AnyObject).value(forKey: "category_name") as! String
            nextViewController.View_From = "HOME"
               self.navigationController?.pushViewController(nextViewController, animated: true)
//            self.present(nextViewController, animated:true, completion:nil)

        }
            
        else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let dataS = ArrSlider[indexPath.row]
            
            
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubCatViewController") as! SubCatViewController
            
            nextViewController.category_id = (dataS as AnyObject).value(forKey: "category_id") as! String
            nextViewController.CatName = (dataS as AnyObject).value(forKey: "main_title") as! String
            nextViewController.View_From = "HOME"
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }

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
    
    @IBAction func LeftManu(_ sender: Any) {
        
        let parentVC: KYDrawerController = (self.navigationController?.parent)! as! KYDrawerController
        
        
        parentVC .setDrawerState(KYDrawerController.DrawerState.opened, animated:true)
        
     
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrBanner.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UIDevice.current.model .hasPrefix("iPad")
        {
            return 250
        }
        else {
        return 178
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BannerTableViewCell
        
                   let data = ArrBanner[indexPath.row]

        
            
            
            loadImageFromUrl(url: (data as AnyObject).value(forKey: "carousel_image") as! String, view: cell.imageBg!)

            
        
            
            
        
        
        
        
        
                return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let Sub = self.storyboard?.instantiateViewController(withIdentifier: "SubCatViewController") as? SubCatViewController
//        self.navigationController?.pushViewController(Sub!, animated: true)
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let dataS = ArrSlider[indexPath.row]
        
        
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubCatViewController") as! SubCatViewController
        
        nextViewController.category_id = (dataS as AnyObject).value(forKey: "category_id") as! String
        nextViewController.CatName = (dataS as AnyObject).value(forKey: "main_title") as! String
        nextViewController.View_From = "HOME"
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    
    func CallViewFromLeftMenu(type : String , cat : String)  {
        let Sub = self.storyboard?.instantiateViewController(withIdentifier: "SubCatViewController") as? SubCatViewController
        self.navigationController?.pushViewController(Sub!, animated: true)
    }
    
    
    @IBAction func MoreButton(_ sender: Any) {
        
        
        
        
        if isMoreOpen == false {
            
            isMoreOpen = true
            
            btnMore.setTitle("Less", for: .normal)
            
            catimg4.image = #imageLiteral(resourceName: "less")
           UIView.animate(withDuration: 1, delay: 0.0, options: [ .curveLinear], animations: {
                
                
//                
//                if self.ArrMoreName.count == 0 {
//                    self.C_More_View_H.constant = self.view.frame.size.width/4 * 0
//                }
//                else if self.ArrMoreName.count <= 3 {
//                    self.C_More_View_H.constant = self.view.frame.size.width/4 * 1
//                }
//                else  if self.ArrMoreName.count >= 4 && self.ArrMoreName.count <= 6{
//                    self.C_More_View_H.constant = self.view.frame.size.width/4 * 2
//                }
//                else  if self.ArrMoreName.count >= 7 && self.ArrMoreName.count <= 9{
//                    self.C_More_View_H.constant = self.view.frame.size.width/4 * 3
//                }
//                else  if self.ArrMoreName.count >= 9 && self.ArrMoreName.count <= 12{
//                    self.C_More_View_H.constant = self.view.frame.size.width/4 * 4
//                }

                
                self.C_More_View_H.constant = self.moreCollectionView.contentSize.height
                
                self.moreCollectionView.reloadData()
                
                
            }, completion:{  finished in
                
            })
            

        }
        else {
            btnMore.setTitle("More", for: .normal)

            isMoreOpen = false
            catimg4.image = #imageLiteral(resourceName: "more")

            UIView.animate(withDuration: 1, delay: 0.0, options: [ .curveLinear], animations: {
                
                self.C_More_View_H.constant = 0
                
            }, completion:{  finished in
                
            })

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
    @IBAction func CheckPinCode(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        nextViewController.ViewFrom = "Home"
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func ChangePinCode(_ sender: Any) {
        
     
      
        
    }

    @IBAction func category2(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubCatViewController") as! SubCatViewController
        nextViewController.category_id = btnCat2.accessibilityValue
        nextViewController.CatName = catTitle2.text
        nextViewController.View_From = "HOME"

        self.navigationController?.pushViewController(nextViewController, animated: true)
//        self.present(nextViewController, animated:true, completion:nil)

    }
    @IBAction func Category3(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubCatViewController") as! SubCatViewController
        nextViewController.category_id = btnCat3.accessibilityValue
        nextViewController.CatName = catTitle3.text
        nextViewController.View_From = "HOME"

        self.navigationController?.pushViewController(nextViewController, animated: true)

//        self.present(nextViewController, animated:true, completion:nil)

    }
    @IBOutlet weak var category2: UIButton!
    @IBAction func category1(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubCatViewController") as! SubCatViewController
        nextViewController.category_id = btnCat1.accessibilityValue
        nextViewController.CatName = catTitle1.text
        nextViewController.View_From = "HOME"

        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
//        self.present(nextViewController, animated:true, completion:nil)

        
        
        
        
        
    }
    @IBAction func Search(_ sender: Any) {
        
        let SCV = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        self.present(SCV!, animated: true, completion: nil)
        
        
    }
}

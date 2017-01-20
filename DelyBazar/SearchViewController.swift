//
//  SearchViewController.swift
//  DelyBazar
//
//  Created by OSX on 28/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SearchViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , UIGestureRecognizerDelegate , UISearchBarDelegate , NVActivityIndicatorViewable{
    @IBOutlet weak var tableView: UITableView!
    var tap = UITapGestureRecognizer()
    
    
    var dataModel = DataModel()
    var DataCollection : NSDictionary?
    var activityIndicatorView : NVActivityIndicatorView?
    var DataSearchresult : NSMutableArray! = []

    @IBOutlet weak var searchbar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTapRate))

        // Do any additional setup after loading the view.
    }
    func handleTapRate(panGesture: UITapGestureRecognizer) {
        
//        searchbar.endEditing(true)
        self.Search()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        tableView.isUserInteractionEnabled = false
        
        
         self.view.addGestureRecognizer(tap)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isUserInteractionEnabled = true

         self.view.removeGestureRecognizer(tap)
    }
    
    @IBAction func Back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Recently search"
        }
        else {
            return "Popular search"

        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if section == 0 {
//            return 4
//        }
//        else{
//            return 10
//
//        }
        return DataSearchresult.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        let data = DataSearchresult[indexPath.row] as! NSDictionary
         print(data)
        
        cell?.textLabel?.text = data.value(forKey: "product_name") as? String
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        let data = DataSearchresult[indexPath.row] as! NSDictionary

        vc.product_id = data.value(forKey: "product_id") as? String
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText()
    }
    
    
    
    func searchText()  {
//        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballZigZagDeflect)
        var Baseurl = "apiSearchSuggestion.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "search_data" : searchbar.text!,
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
                
                self.DataSearchresult.removeAllObjects()
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String == "Mobile No is Aready Exists" {
                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    //                                        self.DataSubCat?.removeAllObjects()
                    //                                        self.ArrRecentName.removeAllObjects()
                    // print("banner  \(data.0.count)")
                    
                
                    for i in 0...data.0.count - 1 {
                        self.DataSearchresult?.add(data.0[i])
                        
                        
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
     self.Search()
        

    }

    func Search()  {
        searchbar.resignFirstResponder()
        
        
        var Baseurl = "apiSearchResult.php"
        
        let dict = [
            "city_id" : UserDefaults.standard.value(forKey: "city_id")! ,
            "search_data" : searchbar.text!,
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
                
                self.DataSearchresult.removeAllObjects()
                
                if (dataBanner as AnyObject).value(forKey: "status") as? String == "Mobile No is Aready Exists" {
                    self.ShowAlertOK(sender: (dataBanner as AnyObject).value(forKey: "status")  as! NSString)
                    
                }
                    
                else{
                    //                                        self.DataSubCat?.removeAllObjects()
                    //                                        self.ArrRecentName.removeAllObjects()
                    // print("banner  \(data.0.count)")
                    
                    
                    for i in 0...data.0.count - 1 {
                        self.DataSearchresult?.add(data.0[i])
                        
                        
                    }
                    self.tableView.reloadData()
                    
                    //                // print(data1)
                    
                    
                }
                
                
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

}

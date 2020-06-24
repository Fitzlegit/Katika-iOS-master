//
//  PurchasesAndReviewsViewController.swift
//  Katika
//
//  Created by Katika on 26/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import Cosmos

class PurchasesAndReviewsViewController: UIViewController {

    var arr_Main : NSMutableArray = []
    
    var tbl_reload_Number : NSIndexPath!
    
    //Other Declaration
    @IBOutlet weak var tbl_Main: UITableView!
    
    var bool_LoadData : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true,animated:false)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
     
        self.commanMethod()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Other Files -
    func commanMethod(){
        self.navigationController?.isNavigationBarHidden = false
        self.Post_purchaseHistory()
//        
//       for cout in 0..<2 {
//            
//            //Fill Dictionary Declaration
//            let obj = PurchaseObject()
//            obj.str_Title = "$20.99 - Long sleeve Martin T-Shirt"
//            obj.str_Detail = "The Mecca Store"
//            obj.str_Date = "Ordered: August 15,2017"
//            obj.str_Profile = "icon_Demo_Person"
//            obj.str_ReviewDate = "Review August 17,2017"
//            obj.str_Star = "5"
//            obj.str_Description = "The shirt fit great. The febric was of great quality and I war this shirt one a month now. I always get compliments on it. Thanks Mecca Store!"
//        
//            arr_Main.append(obj)
//        }
    }
    func indexPaths(forSection section: Int, withNumberOfRows numberOfRows: Int) -> [Any] {
        var indexPaths = [Any]()
        for i in 0..<numberOfRows {
            let indexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_Section(_ sender: Any) {
        //Get animation with table view reload data
        tbl_Main.beginUpdates()
        if ((tbl_reload_Number) != nil) {
            if (tbl_reload_Number.section == (sender as AnyObject).tag) {
                
                //Delete Cell
               // let objDelete : PurchaseObject = arr_Main[tbl_reload_Number.section]
                let arr_DeleteIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows: 1)
                tbl_Main.deleteRows(at: arr_DeleteIndex as! [IndexPath], with: .automatic)
                
                tbl_reload_Number = nil;
            }else{
                //Delete Cell
               // let objDelete : PurchaseObject = arr_Main[tbl_reload_Number.section]
                let arr_DeleteIndex = self.indexPaths(forSection: tbl_reload_Number.section, withNumberOfRows:1)
                tbl_Main.deleteRows(at: arr_DeleteIndex as! [IndexPath], with: .automatic)
                
                let obj : PurchaseObject = arr_Main[(sender as AnyObject).tag] as! PurchaseObject
                if obj.str_Star != "" {
                    tbl_reload_Number = IndexPath(row: 0, section: (sender as AnyObject).tag) as NSIndexPath!
                    
                    //Add Cell
                    //let obj : PurchaseObject = arr_Main[(sender as AnyObject).tag]
                    let arr_AddIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows:1)
                    tbl_Main.insertRows(at: arr_AddIndex as! [IndexPath], with: .automatic)
                }else{
                  tbl_reload_Number = nil;
                  self.performSegue(withIdentifier: "postpurchasereview", sender: (sender as AnyObject).tag)
                }
            }
        }else{
            let obj : PurchaseObject = arr_Main[(sender as AnyObject).tag] as! PurchaseObject
            if obj.str_Star != "" {
                tbl_reload_Number = IndexPath(row: 0, section: (sender as AnyObject).tag) as NSIndexPath!
                
                //Add Cell
                //let obj : PurchaseObject = arr_Main[(sender as AnyObject).tag]
                let arr_AddIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows: 1)
                tbl_Main.insertRows(at: arr_AddIndex as! [IndexPath], with: .automatic)
            }else{
                self.performSegue(withIdentifier: "postpurchasereview", sender: (sender as AnyObject).tag)
            }
        }
        
        tbl_Main.endUpdates()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.tbl_Main.reloadData()
        })
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "postpurchasereview"{
            
            let objHere : PurchaseObject = arr_Main[sender as! Int] as! PurchaseObject
            
            let view : PurchaseProductReviewViewController = segue.destination as! PurchaseProductReviewViewController
            view.objGet = objHere
        }
    }
}

//MARK: - Object Decalration -
class PurchaseObject: NSObject {
    
    var str_ID : NSString = ""
    var str_Product_id : NSString = ""
    var str_Shop_id : NSString = ""
    var str_Title : NSString = ""
    var str_Detail : NSString = ""
    var str_Date : NSString = ""
    var str_Profile : NSString = ""
    var str_ImgLine : NSString = ""
    var str_ReviewDate : NSString = ""
    var str_Star : NSString = ""
    var str_Description : NSString = ""
    var str_Prize : NSString = ""
    
}
class PurchaseCell: UITableViewCell {
    
    @IBOutlet var lbl_Title: UILabel!
    @IBOutlet var lbl_Detail: UILabel!
    @IBOutlet var lbl_Date: UILabel!
    @IBOutlet var img_Profile: UIImageView!
    @IBOutlet var img_ImgLine: UIImageView!
    @IBOutlet var lbl_ReviewDate: UILabel!
    @IBOutlet var lbl_Star: UILabel!
    @IBOutlet var lbl_Description: UILabel!
    @IBOutlet var lbl_Reviewd: UILabel!
    
    @IBOutlet var btn_Click: UIButton!
    
    @IBOutlet var vw_Review : CosmosView!
    
}

extension PurchasesAndReviewsViewController : UITableViewDelegate,UITableViewDataSource{
    // MARK: - Table View -
    func numberOfSections(in tableView: UITableView) -> Int{
       
        if arr_Main.count == 0 && self.bool_LoadData == false{
            return 1
        }
        
        return arr_Main.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arr_Main.count == 0 && self.bool_LoadData == false{
            return 1
        }
        
        //If search and result 0 than show no data cell
         if ((tbl_reload_Number) != nil) {
            if (tbl_reload_Number.section == section) {
                
                //Count declaration
                //let obj : HomeObject = arr_Main[section]
                return 1;
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 108
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if arr_Main.count == 0 && self.bool_LoadData == false{
            return 0
        }
        
       return 96
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "section")as! PurchaseCell
        
        
        let obj : PurchaseObject = arr_Main[section] as! PurchaseObject
        
        cell.lbl_Title.text = "\(obj.str_Prize as String) - \(obj.str_Title as String)"
        cell.lbl_Detail.text = obj.str_Detail as String
//        cell.lbl_Date.text = obj.str_Date as String
        cell.lbl_Date.text = "Ordered"
        
        //Image set
        cell.img_Profile.sd_setImage(with: URL(string: obj.str_Profile as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        
        cell.img_Profile.layer.cornerRadius = 20
        cell.img_Profile.layer.masksToBounds = true
        
        //Button Event
        cell.btn_Click.tag = section;
        cell.btn_Click.addTarget(self, action:#selector(btn_Section(_:)), for: .touchUpInside)
      
        if tbl_reload_Number != nil {
            if tbl_reload_Number.section == section {
                cell.img_ImgLine.isHidden = true
            }else{
                cell.img_ImgLine.isHidden = false
            }
        }
        if obj.str_Star != "" {
            cell.lbl_Reviewd.isHidden = false
        }else{
            cell.lbl_Reviewd.isHidden = true
        }

        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIdentifier : String = "cell"
        
        if arr_Main.count == 0{
            cellIdentifier = "nodata"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! PurchaseCell
        
        if arr_Main.count != 0{
            let obj : PurchaseObject = arr_Main[indexPath.section] as! PurchaseObject
            
            cell.lbl_ReviewDate.text = "Review: \(localDateToStrignDate(date : obj.str_ReviewDate as String))"

            
    //        cell.lbl_ReviewDate.text = "Review \(obj.str_ReviewDate as String)"
            cell.lbl_Detail.text = obj.str_Description as String
            if obj.str_Star == "" {
                cell.vw_Review.rating = 0
            }else{
                cell.vw_Review.rating = Double(obj.str_Star as String)!
            }
        }
        return cell;
    }

    // MARK: - Get/Post Method -
    func Post_purchaseHistory(){
        self.bool_LoadData = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)purchasehistory"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "purchasehistory"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
}



extension PurchasesAndReviewsViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        self.bool_LoadData = false
        
        let response = data as! NSDictionary
        if strRequest == "purchasehistory" {
            
            //Product detail
            let arr_result = response["result"] as! NSArray
            
            arr_Main = []
            for i in (0..<arr_result.count) {
                
                let dict_ProductDetail = arr_result[i] as! NSDictionary
                
                let arr_ProductDetail = dict_ProductDetail["product_detail"] as! NSArray
                let dict_ProductDetailSub = arr_ProductDetail[0] as! NSDictionary
                let arr_Image = dict_ProductDetailSub["product_images"] as! NSArray
                
                let obj = PurchaseObject()
                obj.str_ID = ("\(dict_ProductDetail["id"] as! Int)" as NSString)
                obj.str_Product_id = ("\(dict_ProductDetail["product_id"] as! Int)" as NSString)
                
                obj.str_Shop_id =  ("\(dict_ProductDetailSub["shop_id"] as! Int)" as NSString)
                obj.str_Title =  dict_ProductDetailSub["p_title"] as! NSString
                obj.str_Detail = dict_ProductDetailSub["shop_name"] as? NSString ?? ""
                obj.str_Date = dict_ProductDetail["orderdate"] as! NSString
                obj.str_Prize = dict_ProductDetail["total_price"] as! NSString
                
                //Product Image
                for i in (0..<arr_Image.count) {
                    let dict_ImageData = arr_Image[i] as! NSDictionary
                    
                    obj.str_Profile = dict_ImageData["image"] as! NSString
                    break
                }
                
                
                obj.str_ReviewDate = dict_ProductDetail["review_date"] as! NSString
                obj.str_Star = dict_ProductDetail["review_count"] as! NSString
                obj.str_Description = dict_ProductDetail["review_detail"] as! NSString

                arr_Main.add(obj)
            }
            tbl_Main.reloadData()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
        self.bool_LoadData = false
        tbl_Main.reloadData()
    }
    
}







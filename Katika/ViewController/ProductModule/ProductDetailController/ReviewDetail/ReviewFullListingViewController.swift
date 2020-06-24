//
//  ReviewFullListingViewController.swift
//  Katika
//
//  Created by Katika_07 on 29/07/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import Cosmos

class ReviewFullListingViewController: UIViewController {
    
    @IBOutlet var lbl_ShopName : UILabel!
    @IBOutlet var lbl_ReviewTotal : UILabel!
    
    @IBOutlet var img_ShopImage : UIImageView!
    
    @IBOutlet var vw_ShopRate: CosmosView!
    @IBOutlet var vw_Header: UIView!
    
    //Declaration Tableview
    @IBOutlet var tbl_Review : UITableView!
    
    //Get Data From Other view
    var str_ShopIDGet : NSString!
    
    //Max Min Limit
    var int_CountLoad_FeatureReview: Int = 0
    
    //Declaration Array
    var arr_Reviews : NSMutableArray = []
    
    //Bool Declaration
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    var bool_SearchMore_FeatureReview: Bool = true
    var str_Type : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commanMethod()
        
        int_CountLoad_FeatureReview = Constant.int_LoadMax
        
        //calling service for shop product listing
        int_CountLoad_FeatureReview = Constant.int_LoadMax
        bool_ViewWill = true
        self.Get_ShopReviews(count:int_CountLoad_FeatureReview)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Scrollview Delegate -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(bool_Load)
        if scrollView == tbl_Review{
            //   view.endEditing(true)
            if tbl_Review.contentSize.height <= tbl_Review.contentOffset.y + tbl_Review.frame.size.height && tbl_Review.contentOffset.y >= 0 {
                if bool_Load == false && arr_Reviews.count != 0 {
                    self.Get_ShopReviews(count: int_CountLoad_FeatureReview + Constant.int_LoadMax)
                }
            }
        }
    }
    
    
    //MARK: - Other Files -
    func commanMethod(){
        
    }
    func completedServiceCalling(){
        
        bool_Load = false
    }
    
    //MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_ProductDetail(_sender : Any){
        if str_Type == "" {
            let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
            view.str_ShopIDGet = str_ShopIDGet
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    
    func Get_ShopReviews(count : Int){
        bool_Load = true
        
        //Declaration URL
        var strURL = "\(Constant.BaseURL)get_shop_reviews"
        if str_Type != "" {
            strURL = "\(Constant.BaseURL)get_business_reviews"
        }
        
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
            "shop_id" : str_ShopIDGet,
        ]
        if str_Type != "" {
            jsonData = [
                "user_id" : (objUser?.str_Userid as! String),
                "skip" : "\(count - Constant.int_LoadMax)",
                "total" : "\(count)",
                "business_id" : str_ShopIDGet,
            ]
        }
        
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_shop_reviews"
        if str_Type != "" {
            webHelper.strMethodName = "get_business_reviews"
        }
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        //If first time call than only show loader otherwise not showing loader
        (arr_Reviews.count == 0) ? (webHelper.indicatorShowOrHide = true) : (webHelper.indicatorShowOrHide = false)
        
        if bool_SearchMore_FeatureReview == true{
            webHelper.startDownload()
        }
    }
    
    @IBAction func btn_ProductDetailReview (_ sender : Any){
        let obj : ReviewObjet = arr_Reviews[(sender as AnyObject).tag] as! ReviewObjet
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        view.str_ProductIDGet = obj.str_Product_id as String as NSString
        self.navigationController?.pushViewController(view, animated: false)
        
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


// MARK: - Tableview Files -
extension ReviewFullListingViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_Review {
            return arr_Reviews.count;
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var str_Identifier : String = "reviewCell"
        if str_Type != "" {
            str_Identifier = "reviewCell2"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: str_Identifier, for:indexPath as IndexPath) as! ReviewTableviewCell
        
        cell.selectionStyle = .none;
        let objReview:ReviewObjet = arr_Reviews[indexPath.row] as! ReviewObjet
        
        cell.lbl_ReviewBy.text = objReview.str_ReviewUserName as String
        cell.lbl_ReviewDate.text = localDateToStrignDate2(date : objReview.str_ReviewDate as String)
        cell.lbl_ReviewDescription.text = objReview.str_ReviewDescription as String
        
        if str_Type == "" {
            cell.lbl_ProductName.text = objReview.str_Product_Name as String
            
            let arr_Images : NSMutableArray = objReview.arr_Images;
            if arr_Images.count != 0 {
                let obj2 : ReviewObjet = arr_Images[0] as! ReviewObjet
                cell.img_Product.sd_setImage(with: URL(string: obj2.str_Product_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
            }
        }
        
         cell.imgView_ReviewUserPhoto.sd_setImage(with: URL(string: objReview.str_ReviewUserImage as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        
        cell.imgView_ReviewUserPhoto.layoutIfNeeded()
        cell.imgView_ReviewUserPhoto.layer.cornerRadius = cell.imgView_ReviewUserPhoto.frame.size.width/2;
        cell.imgView_ReviewUserPhoto.layer.masksToBounds = true
        
        //Mange Relating
        cell.rate_UserRate.rating = Double(objReview.str_ReviewStar as String)!
        
        if str_Type == "" {
            //Product Button
            cell.btn_Product.tag = indexPath.row
            cell.btn_Product.addTarget(self, action: #selector(self.btn_ProductDetailReview(_:)), for:.touchUpInside)
        }
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}




extension ReviewFullListingViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        self.completedServiceCalling()
        tbl_Review.isHidden = false
        
        let response = data as! NSDictionary
        if strRequest == "get_shop_reviews" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            lbl_ShopName.text = response["shop_name"] as? String
            img_ShopImage.sd_setImage(with: URL(string: response["shop_logo"] as! String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
            lbl_ReviewTotal.text = response["TotalRecord"] as? String
            vw_ShopRate.rating = Double(response["AvgReview"] as! String)!
            vw_Header.isHidden = false
            
            let arr_StoreTemp : NSMutableArray = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                let objReview = ReviewObjet()
                objReview.str_ReviewDate = dict_Data["datetime"] as! String as NSString
                objReview.str_ReviewUserName = dict_Data["name"] as! String as NSString
                objReview.str_ReviewDescription = dict_Data["review"] as! String as NSString
                objReview.str_ReviewStar = dict_Data["rate"] as! String as NSString
                objReview.str_imageshop_id = ("\(dict_Data["shop_id"] as! Int)" as NSString)
                objReview.str_imageuser_id = ("\(dict_Data["userid"] as! Int)" as NSString)
                objReview.str_Product_id = ("\(dict_Data["product_id"] as! Int)" as NSString)
                objReview.str_Product_Name = dict_Data["product_name"] as! String as NSString
                objReview.str_ReviewUserImage =  dict_Data["profile_image"] as! NSString
                
                //Image Array
                let arr_Image = dict_Data["product_image"] as! NSArray
                let arr_Image_Store : NSMutableArray = []
                for j in (0..<arr_Image.count){
                    let dict_DataOther = arr_Image[j] as! NSDictionary
                    
                    let obj1 = ReviewObjet ()
                    obj1.str_Product_Image = dict_DataOther["image"] as! NSString
                    
                    arr_Image_Store.add(obj1)
                }
                
                objReview.arr_Images = arr_Image_Store
                
                arr_StoreTemp.add(objReview)
            }
            
            
            //Refresh code
            if bool_ViewWill == true {
                arr_Reviews = []
                int_CountLoad_FeatureReview = arr_StoreTemp.count
            }else{
                int_CountLoad_FeatureReview = int_CountLoad_FeatureReview + arr_StoreTemp.count
            }
            
            for i in (0...arr_StoreTemp.count-1){
                arr_Reviews.add(arr_StoreTemp[i])
            }
            
            //Load more data or not
            if Constant.int_LoadMax > arr_StoreTemp.count {
                //Bool Load more
                bool_SearchMore_FeatureReview = false
            }
            else {
                //Bool Load more
                bool_SearchMore_FeatureReview = true
            }
            
            bool_ViewWill = false
            tbl_Review.reloadData()
            
        }else if strRequest == "get_business_reviews"{
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            let arr_Image = response["shop_logo"] as! NSArray
            
            lbl_ShopName.text = response["business_name"] as? String
            
            if arr_Image.count != 0{
                let dict_Data = arr_Image[0] as! NSDictionary
                img_ShopImage.sd_setImage(with: URL(string: dict_Data["image"] as! String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
            }
            
            lbl_ReviewTotal.text = response["TotalRecord"] as? String
            vw_ShopRate.rating = Double(response["AvgReview"] as! String)!
            vw_Header.isHidden = false
            
            let arr_StoreTemp : NSMutableArray = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                let objReview = ReviewObjet()
                objReview.str_ReviewDate = dict_Data["datetime"] as! String as NSString
                objReview.str_ReviewUserName = dict_Data["name"] as! String as NSString
                objReview.str_ReviewDescription = dict_Data["review"] as! String as NSString
                objReview.str_ReviewStar = dict_Data["rate"] as! String as NSString
                objReview.str_imageshop_id = ("\(dict_Data["business_id"] as! Int)" as NSString)
                objReview.str_imageuser_id = ("\(dict_Data["userid"] as! Int)" as NSString)
                objReview.str_Product_id = ""
                objReview.str_Product_Name = ""
                objReview.str_ReviewUserImage =  dict_Data["profile_image"] as! NSString

                //Image Save
                let arr_Image_Store : NSMutableArray = []
                let obj1 = ReviewObjet ()
                obj1.str_Product_Image = dict_Data["profile_image"] as! String as NSString
                arr_Image_Store.add(obj1)
                objReview.arr_Images = arr_Image_Store
                
                arr_StoreTemp.add(objReview)
            }
            
            
            //Refresh code
            if bool_ViewWill == true {
                arr_Reviews = []
                int_CountLoad_FeatureReview = arr_StoreTemp.count
            }else{
                int_CountLoad_FeatureReview = int_CountLoad_FeatureReview + arr_StoreTemp.count
            }
            
            for i in (0...arr_StoreTemp.count-1){
                arr_Reviews.add(arr_StoreTemp[i])
            }
            
            //Load more data or not
            if Constant.int_LoadMax > arr_StoreTemp.count {
                //Bool Load more
                bool_SearchMore_FeatureReview = false
            }
            else {
                //Bool Load more
                bool_SearchMore_FeatureReview = true
            }
            
            bool_ViewWill = false
            tbl_Review.reloadData()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
        self.completedServiceCalling()
    }
    
}


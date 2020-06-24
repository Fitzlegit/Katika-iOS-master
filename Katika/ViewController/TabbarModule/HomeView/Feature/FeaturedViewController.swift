//
//  FeaturedViewController.swift
//  Katika
//
//  Created by Katika_07 on 31/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController {

    //Declaration CollectionView
    @IBOutlet var cv_Main : UICollectionView!
    
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    @IBOutlet var pg_Header : UIPageControl!
    
    //Declaration Array
    var arr_Header_Collectionview : NSMutableArray = []
    var arr_HeaderAdvertice_Collectionview : NSMutableArray = []
    var arr_Featured : NSMutableArray = []
    
    //Refresh Controller
    var refresh_FeaturedTab: UIRefreshControl?
    
    //Bool Declaration
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    var bool_SearchMore_Feature: Bool = true
    
    //Max Min Limit
    var int_CountLoad_Feature: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //First time sevice call for featured product
        int_CountLoad_Feature = Constant.int_LoadMax
        bool_ViewWill = true
        self.Get_Product(count:int_CountLoad_Feature)
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(commanMethod), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Scrollview Delegate -
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag >= 100 && scrollView is UICollectionView{
            let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
            let indexpath_Cell : NSIndexPath = NSIndexPath(row: scrollView.tag - 100, section: 0)
            print(indexpath_Cell.row)
            
            let obj : HomeObject = arr_Featured[scrollView.tag - 100] as! HomeObject
            let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
            
            if (tbl_Main.indexPathsForVisibleRows?.contains(indexpath_Cell as IndexPath))! {
                let cellLocally = tbl_Main.cellForRow(at: indexpath_Cell as IndexPath) as! HomeTableviewCell
                let indexPath = cellLocally.cv_Sub.indexPathForItem(at: visiblePoint)
                
                cellLocally.pg_Product.currentPage = (indexPath?.row)!
                //  tbl_Main.reloadData()
            }
            
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.tag)
        if cv_Main == scrollView{
            let visibleRect = CGRect(origin: cv_Main.contentOffset, size: cv_Main.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let indexPath = cv_Main.indexPathForItem(at: visiblePoint)
            
            pg_Header.currentPage = (indexPath?.row)!
        }else if scrollView == tbl_Main{
            if tbl_Main.contentSize.height <= tbl_Main.contentOffset.y + tbl_Main.frame.size.height && tbl_Main.contentOffset.y >= 0 {
                if bool_Load == false && arr_Featured.count != 0 {
                    self.Get_Product(count: int_CountLoad_Feature + Constant.int_LoadMax)
                }
            }
        }
    }
    
    
    //MARK: - Other Files -
    @objc func commanMethod(){
        
        //Table view header heigh set
        let vw : UIView = tbl_Main.tableHeaderView!
        vw.frame = CGRect(x: 0, y: 0, width: CGFloat(Constant.windowWidth), height: CGFloat((Constant.windowHeight * 180)/Constant.screenHeightDeveloper))
        tbl_Main.tableHeaderView = vw;
        
  
        //Refresh Controller
        refresh_FeaturedTab = UIRefreshControl()
        refresh_FeaturedTab?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tbl_Main.addSubview(refresh_FeaturedTab!)
        
        
        //Temp Data set
        if arr_Featured.count == 0 {
            int_CountLoad_Feature = Constant.int_LoadMax
        }
        
        //Page header color set
        pg_Header.pageIndicatorTintColor = UIColor(patternImage:UIImage(named: "img_Page")!)
        pg_Header.currentPageIndicatorTintColor = UIColor(red: CGFloat((207 / 255.0)), green: CGFloat((198 / 255.0)), blue: CGFloat((188 / 255.0)), alpha: CGFloat(1.0))
        
        
    }
    func completedServiceCalling(){
        //Comman fuction action
        refresh_FeaturedTab?.endRefreshing()
        bool_Load = false
    }
    func reloadData(){
        tbl_Main.reloadData()
        cv_Main.reloadData()
    }
    
    // MARK: - refersh controller -
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        if bool_Load == false {
            int_CountLoad_Feature = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_Feature = true
            
            self.Get_Product(count:int_CountLoad_Feature)
        }else{
            refresh_FeaturedTab?.endRefreshing()
        }
    }
    
    // MARK: - Button Event -
    @IBAction func btn_FavTab(_ sender: Any){
        let obj : HomeObject = arr_Featured[(sender as AnyObject).tag] as! HomeObject
        
        let indexpath_Cell : NSIndexPath = NSIndexPath(row: (sender as AnyObject).tag, section: 0)
        let cell = tbl_Main.cellForRow(at: indexpath_Cell as IndexPath) as! HomeTableviewCell
        
        if obj.str_Fav_OtherTab == "1" {
            obj.str_Fav_OtherTab = "0"
            cell.btn_Favorite.isSelected = false
            cell.img_Favorite.image = UIImage.init(named: "icon_Save_Product")
            self.Post_Fav(flag : "0",Productid : obj.str_ID_OtherTab as String)
        }else{
            obj.str_Fav_OtherTab = "1"
            cell.btn_Favorite.isSelected = true
            cell.img_Favorite.image = UIImage.init(named: "icon_Save_Product_Selected")
            self.Post_Fav(flag : "1",Productid : obj.str_ID_OtherTab as String)
        }
        
        arr_Featured[(sender as AnyObject).tag] = obj
    }
    
    // MARK: - Get/Post Method -
    func Get_Product(count : Int){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_products"
        
        //Get type when click on tab bar in header
        var set_Type : NSString = "Featured"
       
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
            "type" : set_Type,
        ]
        
        //Input Contry name
        jsonData["country_id"] = "0"
   
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_products"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        
        

        //If first time call than only show loader otherwise not showing loader
        (arr_Featured.count == 0) ? (webHelper.indicatorShowOrHide = true) : (webHelper.indicatorShowOrHide = false)
        
        //Not limit for end data than only service call
        if bool_SearchMore_Feature == true{
            webHelper.startDownload()
        }
    }
    
    func Post_Fav(flag : String , Productid : String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)addremove_favourite"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid as! String,
            "product_id" : Productid,
            "status" : flag,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "addremove_favourite"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
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


//MARK: - Collection View -
extension FeaturedViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returen number of cell with content available in array
         if cv_Main == collectionView {
            //            pg_Header.numberOfPages = arr_Header_Collectionview.count
            //            return arr_Header_Collectionview.count
            
            pg_Header.numberOfPages = arr_HeaderAdvertice_Collectionview.count
            return arr_HeaderAdvertice_Collectionview.count
            
        }
        else{
            if (arr_Featured.count != 0){
                let obj : HomeObject = arr_Featured[collectionView.tag - 100] as! HomeObject
                let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
                return arr_Images.count
            }
        }
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Returen number of cell with content available in array
        if cv_Main == collectionView {
            
            return CGSize(width: cv_Main.frame.size.width, height: cv_Main.frame.size.height)
        }else{
            //This box for array in tableview cell
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var str_Identifier : String = "cell"
        
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: str_Identifier, for: indexPath) as! HomeViewCollectioncell
        
       if cv_Main == collectionView {
            
            //            let obj : HomeObject = arr_Header_Collectionview[indexPath.row] as! HomeObject
            
            //            //Set text in label
            //            cell.lbl_Title_Header.text = obj.str_Title as String
            //            cell.lbl_SubTitle_Header.text = obj.str_SubTitle as String
            //            cell.lbl_PrizeMainPrice_Header.text = ("\(obj.str_PriceSymbol as String)\(obj.str_DiscountPrize as String)")
            //            cell.lbl_PrizeFinal_Header.text = ("\(obj.str_PriceSymbol as String)\(obj.str_Prize as String)")
            //
            //            //Image set
            //            cell.img_Image_Header.sd_setImage(with: URL(string: obj.str_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
            
            let obj : HomeObject = arr_HeaderAdvertice_Collectionview[indexPath.row] as! HomeObject
            
            cell.lbl_Title_Header.text = ""
            cell.lbl_SubTitle_Header.text = ""
            cell.lbl_PrizeMainPrice_Header.text = ""
            cell.lbl_PrizeFinal_Header.text = ""
            
            //Image set
            cell.img_Image_Header.sd_setImage(with: URL(string: obj.str_Adv_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
            
            
        }else{
            let obj : HomeObject = arr_Featured[collectionView.tag - 100] as! HomeObject
            let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
            
            let obj2 : HomeObject = arr_Images[indexPath.row] as! HomeObject
            
            //This box for array in tableview cell
            cell.img_Product.sd_setImage(with: URL(string: obj2.str_Image_OtherTab as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var obj = HomeObject ()
        var str_ID : NSString = ""
        
         if cv_Main == collectionView {
            
            obj = arr_HeaderAdvertice_Collectionview[indexPath.row] as! HomeObject
            
            if obj.str_Adv_Type == "PRO"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
                view.str_ProductIDGet = obj.str_Adv_ID
                self.navigationController?.pushViewController(view, animated: false)
            }else{
                let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
                view.str_ShopIDGet = obj.str_Adv_ID
                self.navigationController?.pushViewController(view, animated: true)
            }
            
        }
    }
}


// MARK: - Tableview Files -
extension FeaturedViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(Int((Constant.windowHeight * 190)/Constant.screenHeightDeveloper))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Featured.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath as IndexPath) as! HomeTableviewCell
        
        let obj : HomeObject = arr_Featured[indexPath.row] as! HomeObject
        
        //Value Set
        cell.lbl_Title.text = (obj.str_Title_OtherTab ) as String
        cell.lbl_Price.text = ("\(obj.str_PriceSymbol_OtherTab as String)\(obj.str_Prize_OtherTab as String)")
        cell.lbl_Website.text = (obj.str_ShopName_OtherTab ) as String
        
        //Manage Count for pagination
        let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
        cell.pg_Product.numberOfPages = arr_Images.count
        cell.pg_Product.tag = indexPath.row
        cell.pg_Product.pageIndicatorTintColor = UIColor(patternImage:UIImage(named: "img_Page")!)
        cell.pg_Product.currentPageIndicatorTintColor = UIColor(red: CGFloat((207 / 255.0)), green: CGFloat((198 / 255.0)), blue: CGFloat((188 / 255.0)), alpha: CGFloat(1.0))
        
        cell.btn_Favorite.tag = indexPath.row
        cell.btn_Favorite.addTarget(self, action: #selector(self.btn_FavTab(_:)), for:.touchUpInside)
        
        if obj.str_Fav_OtherTab == "1"{
            cell.img_Favorite.image = UIImage.init(named: "icon_Save_Product_Selected")
            cell.btn_Favorite.isSelected = true
        }else{
            cell.img_Favorite.image = UIImage.init(named: "icon_Save_Product")
            cell.btn_Favorite.isSelected = false
        }
        
        //Layer set
        cell.vw_SubView.layer.cornerRadius = 5.0
        cell.vw_SubView.layer.masksToBounds = true
        
        cell.cv_Sub.tag = indexPath.row + 100
        cell.cv_Sub.delegate = self
        cell.cv_Sub.dataSource = self
        cell.cv_Sub.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj : HomeObject = arr_Featured[indexPath.row] as! HomeObject
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        view.str_ProductIDGet = obj.str_ID_OtherTab
        self.navigationController?.pushViewController(view, animated: false)
    }
    
}


extension FeaturedViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        self.completedServiceCalling()
        
        let response = data as! NSDictionary
        if strRequest == "get_products" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            var arr_StoreTemp : NSMutableArray = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                //Other Tab Demo data
                let obj = HomeObject ()
                obj.str_ID_OtherTab = ("\(dict_Data["product_id"] as! Int)" as NSString)
                obj.str_Title_OtherTab = dict_Data["p_title"] as! String as NSString
                obj.str_SubTitle_OtherTab = dict_Data["p_descriiption"] as! String as NSString
                obj.str_Prize_OtherTab = ("\(dict_Data["price"] as! Float)" as NSString)
                obj.str_DiscountPrize_OtherTab = ("\(dict_Data["discount_price"] as! Int)" as NSString)
                obj.str_Site_OtherTab = dict_Data["site"] as! String as NSString
                obj.str_Fav_OtherTab = ("\(dict_Data["is_favourite"] as! Int)" as NSString)
                obj.str_ShopName_OtherTab = dict_Data["shop_name"] as! String as NSString
                obj.str_PriceSymbol_OtherTab = dict_Data["price_symbole"] as! String as NSString
                
                //Image Array
                let arr_Image = dict_Data["product_images"] as! NSArray
                let arr_Image_Store : NSMutableArray = []
                for j in (0..<arr_Image.count){
                    let dict_DataOther = arr_Image[j] as! NSDictionary
                    
                    let obj1 = HomeObject ()
                    obj1.str_Image_OtherTab = dict_DataOther["image"] as! NSString
                    
                    arr_Image_Store.add(obj1)
                }
                
                obj.arrImage_OtherTab = arr_Image_Store
                
                arr_StoreTemp.add(obj)
            }
            
            //Get type when click on tab bar in header
            //Refresh code
            if bool_ViewWill == true {
                arr_Featured = []
                int_CountLoad_Feature = arr_StoreTemp.count
            }else{
                int_CountLoad_Feature = int_CountLoad_Feature + arr_StoreTemp.count
            }
            
            for i in (0...arr_StoreTemp.count-1){
                arr_Featured.add(arr_StoreTemp[i])
            }
            
            //Load more data or not
            if Constant.int_LoadMax > arr_StoreTemp.count {
                //Bool Load more
                bool_SearchMore_Feature = false
            }
            else {
                //Bool Load more
                bool_SearchMore_Feature = true
            }
                
            
            
            //Manage Header Data
            if bool_ViewWill == true {
                arr_Header_Collectionview = []
            }
            let arr_Header = response["HeaderFeature"] as! NSArray
            if bool_ViewWill == true {
                arr_Header_Collectionview = []
                for i in (0..<arr_Header.count) {
                    let dict_Data = arr_Header[i] as! NSDictionary
                    
                    //Other Tab Demo data
                    let obj = HomeObject ()
                    obj.str_ID = ("\(dict_Data["product_id"] as! Int)" as NSString)
                    obj.str_Title = dict_Data["p_title"] as! String as NSString
                    obj.str_SubTitle = dict_Data["p_descriiption"] as! String as NSString
                    obj.str_Prize = ("\(dict_Data["price"] as! Float)" as NSString)
                    obj.str_DiscountPrize = ("\(dict_Data["discount_price"] as! Int)" as NSString)
                    obj.str_Site = dict_Data["site"] as! String as NSString
                    obj.str_Image = dict_Data["image"] as! String as NSString
                    obj.str_ShopName = dict_Data["shop_name"] as! String as NSString
                    obj.str_PriceSymbol = dict_Data["price_symbole"] as! String as NSString
                    
                    arr_Header_Collectionview.add(obj)
                }
            }
            
            //Manage Header Data
            if bool_ViewWill == true {
                arr_HeaderAdvertice_Collectionview = []
            }
            let arr_Header2 = response["Advertisement"] as! NSArray
            if bool_ViewWill == true {
                arr_Header_Collectionview = []
                for i in (0..<arr_Header2.count) {
                    let dict_Data = arr_Header2[i] as! NSDictionary
                    
                    //Other Tab Demo data
                    let obj = HomeObject ()
                    obj.str_Adv_ID = dict_Data["adv_redirect_id"] as! String as NSString
                    obj.str_Adv_Type = dict_Data["adv_type"] as! String as NSString
                    obj.str_Adv_Image = dict_Data["adv_image"] as! String as NSString
                    
                    arr_HeaderAdvertice_Collectionview.add(obj)
                }
            }
            
            bool_ViewWill = false
            self.reloadData()
        }else if strRequest == "addremove_favourite" {
            
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
        self.completedServiceCalling()
        self.reloadData()
    }
    
}






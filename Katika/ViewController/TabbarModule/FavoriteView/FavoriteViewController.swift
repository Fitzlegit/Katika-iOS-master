//
//  FavoriteViewController.swift
//  Katika
//
//  Created by Katika on 18/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import Firebase

class FavoriteViewController: UIViewController {

    //Button Event
    @IBOutlet var btn_Item : UIButton!
    @IBOutlet var btn_Shops : UIButton!
    @IBOutlet var btn_Business : UIButton!
    
    @IBOutlet var img_Item : UIImageView!
    @IBOutlet var img_Shops : UIImageView!
    @IBOutlet var img_Business : UIImageView!
    
    //Array Declaration
    var arr_Items : NSMutableArray = []
    var arr_Shops : NSMutableArray = []
    var arr_Business : NSMutableArray = []
  
    var int_CountLoad: Int = 0
    var int_CountLoad2: Int = 0
    var int_CountLoad3: Int = 0
    
    //Bool Declaration
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    var bool_SearchMore: Bool = true
    
    var bool_Load2: Bool = false
    var bool_ViewWill2: Bool = false
    var bool_SearchMore2: Bool = true
    
    var bool_Load3: Bool = false
    var bool_ViewWill3: Bool = false
    var bool_SearchMore3: Bool = true
    
    //Other Declaration
    @IBOutlet var cv_Main : UICollectionView!
    @IBOutlet var cv_Main2 : UICollectionView!
    @IBOutlet var cv_Main3 : UICollectionView!
    
    //Refresh Controller
    var refresh_Item: UIRefreshControl?
    var refresh_Item2: UIRefreshControl?
    var refresh_Item3: UIRefreshControl?
    
    //Constaint Declaration
    @IBOutlet var con_Items_x : NSLayoutConstraint!
    @IBOutlet var con_Shops_x : NSLayoutConstraint!
    @IBOutlet var con_Business_x : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commanMethod()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.manageNavigation()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        arr_Items = []
        arr_Shops = []
        arr_Business = []
        cv_Main.reloadData()
        cv_Main2.reloadData()
        cv_Main3.reloadData()
        
        if img_Item.isHidden == false{
            //First time sevice call for featured product
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore = true
            self.Get_FavProduct(count:int_CountLoad)
        }else if img_Shops.isHidden == false{
            //First time sevice call for featured product
            int_CountLoad2 = Constant.int_LoadMax
            bool_ViewWill2 = true
            bool_SearchMore2 = true
            self.Get_FavProduct_Shop(count:int_CountLoad2)
        }else{
            //First time sevice call for featured product
            int_CountLoad3 = Constant.int_LoadMax
            bool_ViewWill3 = true
            bool_SearchMore3 = true
            self.Get_FavProduct_Business(count:int_CountLoad3)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Scrollview Delegate -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == cv_Main{
            if cv_Main.contentSize.height <= cv_Main.contentOffset.y + cv_Main.frame.size.height && cv_Main.contentOffset.y >= 0 {
                if bool_Load == false && arr_Items.count != 0 {
                    self.Get_FavProduct(count: int_CountLoad + Constant.int_LoadMax)
                }
            }
        }else if scrollView == cv_Main2{
            if cv_Main2.contentSize.height <= cv_Main2.contentOffset.y + cv_Main2.frame.size.height && cv_Main2.contentOffset.y >= 0 {
                if bool_Load == false && arr_Shops.count != 0 {
                    self.Get_FavProduct_Shop(count: int_CountLoad2 + Constant.int_LoadMax)
                }
            }
        }else if scrollView == cv_Main3{
            if cv_Main3.contentSize.height <= cv_Main3.contentOffset.y + cv_Main3.frame.size.height && cv_Main3.contentOffset.y >= 0 {
                if bool_Load == false && arr_Business.count != 0 {
                    self.Get_FavProduct_Business(count: int_CountLoad3 + Constant.int_LoadMax)
                }
            }
        }
    }

    //MARK: - Other Files -
    func commanMethod(){
        
        //Image hide show
        img_Shops.isHidden = true
        img_Business.isHidden = true
        img_Item.isHidden = false
        
        //Refresh Controller
        refresh_Item = UIRefreshControl()
        refresh_Item?.tintColor = UIColor.red
        refresh_Item?.addTarget(self, action: #selector(self.refreshItem), for: .valueChanged)
        cv_Main.addSubview(refresh_Item!)
        
        refresh_Item2 = UIRefreshControl()
        refresh_Item2?.tintColor = UIColor.red
        refresh_Item2?.addTarget(self, action: #selector(self.refreshItem2), for: .valueChanged)
        cv_Main2.addSubview(refresh_Item2!)
        
        refresh_Item3 = UIRefreshControl()
        refresh_Item3?.tintColor = UIColor.red
        refresh_Item3?.addTarget(self, action: #selector(self.refreshItem3), for: .valueChanged)
        cv_Main3.addSubview(refresh_Item3!)

        //Constant Manage
        con_Items_x.constant = 0
        con_Shops_x.constant = CGFloat(Constant.windowWidth)
        con_Business_x.constant = CGFloat(Constant.windowWidth * 2)
        
    }
    @objc func refreshItem(_ refresh: UIRefreshControl) {
        if bool_Load == false {
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore = true
            
            self.Get_FavProduct(count:int_CountLoad)
        }else{
            refresh_Item?.endRefreshing()
        }
    }
    @objc func refreshItem2(_ refresh: UIRefreshControl) {
        if bool_Load == false {
            int_CountLoad2 = Constant.int_LoadMax
            bool_ViewWill2 = true
            bool_SearchMore2 = true
            
            self.Get_FavProduct_Shop(count:int_CountLoad2)
        }else{
            refresh_Item2?.endRefreshing()
        }
    }
    @objc func refreshItem3(_ refresh: UIRefreshControl) {
        if bool_Load == false {
            int_CountLoad3 = Constant.int_LoadMax
            bool_ViewWill3 = true
            bool_SearchMore3 = true
            
            self.Get_FavProduct_Business(count:int_CountLoad3)
        }else{
            refresh_Item3?.endRefreshing()
        }
    }
    
    func manageNavigation(){
        
        let titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 150, height: 28))
        titleView.contentMode = .scaleAspectFit
        titleView.image = UIImage(named: "katikaTextNavigation")
        
        self.navigationItem.titleView = titleView
    }
    func completedServiceCalling(){
        refresh_Item?.endRefreshing()
        refresh_Item2?.endRefreshing()
        refresh_Item3?.endRefreshing()
        
        bool_Load = false
    }
    func reloadData(){
        cv_Main.reloadData()
        cv_Main2.reloadData()
        cv_Main3.reloadData()
    }
    
    // MARK: - Button Event -
    @IBAction func Sidebar_Left(_ sender: Any) {
        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }
        else{
            toggleLeft()
        }
    }
    // MARK: - TabBar Button -
    @IBAction func btn_Tab_Home(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_home", parameters: nil)
        
        vw_BaseView?.callmethod(_int_Value: 0)
    }
    @IBAction func btn_Tab_Fav(_ sender: Any) {
        
        //SET ANALYTICS
        Analytics.logEvent("tab_favorite", parameters: nil)
        
        vw_BaseView?.callmethod(_int_Value: 1)
    }
    @IBAction func btn_Tab_Katika(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_directory", parameters: nil)
        
        vw_BaseView?.callmethod(_int_Value: 2)
    }
    @IBAction func btn_Tab_Search(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_search", parameters: nil)
        
        vw_BaseView?.callmethod(_int_Value: 3)
    }
    @IBAction func btn_Tab_Inbox(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_inbox", parameters: nil)
        
        vw_BaseView?.callmethod(_int_Value: 4)
    }
    @IBAction func btn_Item(_ sender : Any){
        //Image hide show
        img_Shops.isHidden = true
        img_Business.isHidden = true
        img_Item.isHidden = false
        
        if arr_Items.count == 0 {
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore = true
            
            self.Get_FavProduct(count:int_CountLoad)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            //Constant Manage
            self.con_Items_x.constant = 0
            self.con_Shops_x.constant = CGFloat(Constant.windowWidth)
            self.con_Business_x.constant = CGFloat(Constant.windowWidth * 2)
            
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.reloadData()
        })
    }
    @IBAction func btn_Shops(_ sender : Any){
        //Image hide show
        img_Shops.isHidden = false
        img_Item.isHidden = true
        img_Business.isHidden = true
        
        if arr_Shops.count == 0 {
            //First time sevice call for featured product
            int_CountLoad2 = Constant.int_LoadMax
            bool_ViewWill2 = true
            bool_SearchMore2 = true
            self.Get_FavProduct_Shop(count:int_CountLoad2)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            //Constant Manage
            self.con_Business_x.constant = CGFloat(Constant.windowWidth)
            self.con_Items_x.constant = -CGFloat(Constant.windowWidth)
            self.con_Shops_x.constant = 0
            
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.reloadData()
        })
    }
    @IBAction func btn_Business(_ sender : Any){
        //Image hide show
        img_Shops.isHidden = true
        img_Item.isHidden = true
        img_Business.isHidden = false
        
        if arr_Business.count == 0 {
            //First time sevice call for featured product
            int_CountLoad3 = Constant.int_LoadMax
            bool_ViewWill3 = true
            bool_SearchMore3 = true
            self.Get_FavProduct_Business(count:int_CountLoad3)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            //Constant Manage
            self.con_Business_x.constant = 0
            self.con_Items_x.constant = -CGFloat(Constant.windowWidth * 2)
            self.con_Shops_x.constant = -CGFloat(Constant.windowWidth)
            
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.reloadData()
        })
    }
    
    // MARK: - Get/Post Method -
    func Get_FavProduct(count : Int){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_favourite_products"
      
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_favourite_products"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        
        if bool_SearchMore == true{
            bool_Load = true
            webHelper.startDownload()
        }
    }
    
    func Get_FavProduct_Shop(count : Int){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_favourite_shops"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_favourite_shops"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        
        if bool_SearchMore2 == true{
            bool_Load = true
            webHelper.startDownload()
        }
    }
    
    func Get_FavProduct_Business(count : Int){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_favourite_business"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_favourite_business"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        
        if bool_SearchMore3 == true{
            bool_Load = true
            webHelper.startDownload()
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

//MARK: - Favorite Object -

class FavoriteObject: NSObject {
    var str_Title : NSString = ""
    var str_SubTitle : NSString = ""
    var str_Prize : NSString = ""
    var str_Image : NSString = ""
    
    //Shop Detail
    var str_Shop_Id : NSString = ""
    var str_Shop_Name : NSString = ""
    var str_Shop_Title : NSString = ""
    var str_Shop_Icon : NSString = ""
    var str_Shop_Open_Hr : NSString = ""
    var str_Shop_Description : NSString = ""
    var str_Shop_Location : NSString = ""
    var str_Shop_Lat : NSString = ""
    var str_Shop_Long : NSString = ""
    var str_Shop_Logo : NSString = ""
    var str_Shop_BG : NSString = ""
    var str_Shop_Email : NSString = ""
    var str_Shop_Website : NSString = ""
    var str_Shop_Twitter : NSString = ""
    var str_Shop_FBlink : NSString = ""
    var str_Shop_Favotite : NSString = ""
    var str_Shop_Policy : NSString = ""
    var str_Shop_More : NSString = ""
    var str_Shop_PolicyDate : NSString = ""
    var str_Shop_MoreDate : NSString = ""
    var str_Shop_TotalReview : NSString = ""
    var str_Shop_AvgReview : NSString = ""
}


//MARK: - Favorite View -
extension FavoriteViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returen number of cell with content available in array
        if cv_Main == collectionView {
            if arr_Items.count == 0 && bool_Load == false{
                return 1
            }
            return arr_Items.count
        }else if cv_Main2 == collectionView {
            if arr_Shops.count == 0 && bool_Load == false{
                return 1
            }
            return arr_Shops.count
        }else if cv_Main3 == collectionView {
            if arr_Business.count == 0 && bool_Load == false{
                return 1
            }
            return arr_Business.count
        }
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Returen number of cell with content available in array
        if cv_Main == collectionView {
            if arr_Items.count == 0 {
                return CGSize(width: collectionView.frame.size.width, height: 30)
            }
            return CGSize(width: collectionView.frame.size.width/2, height: CGFloat(((collectionView.frame.size.width/2)*200)/175))
        }else if cv_Main2 == collectionView {
            if arr_Shops.count == 0 {
                return CGSize(width: collectionView.frame.size.width, height: 30)
            }
            return CGSize(width: collectionView.frame.size.width/2, height: CGFloat(((collectionView.frame.size.width/2)*200)/175))
        }else if cv_Main3 == collectionView {
            if arr_Business.count == 0 {
                return CGSize(width: collectionView.frame.size.width, height: 30)
            }
            return CGSize(width: collectionView.frame.size.width/2, height: CGFloat(((collectionView.frame.size.width/2)*200)/175))
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var str_CellIdentifier : NSString = "cell"
        if cv_Main == collectionView {
            if arr_Items.count == 0 {
                str_CellIdentifier = "nodata"
            }
        }else if cv_Main2 == collectionView {
            if arr_Shops.count == 0 {
                str_CellIdentifier = "nodata"
            }
        }else if cv_Main3 == collectionView {
            if arr_Business.count == 0 {
                str_CellIdentifier = "nodata"
            }
        }
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: str_CellIdentifier as String, for: indexPath) as! FavoriteViewCollectioncell
        
        if cv_Main == collectionView {
            if arr_Items.count != 0 {
                let obj : HomeObject = arr_Items[indexPath.row] as! HomeObject
                let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
                
                //SET TILE FONT
                cell.lbl_Title.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                
                //Set text in label
                cell.lbl_Title.text = obj.str_Title_OtherTab as String
                cell.lbl_SubTitle.text = obj.str_SubTitle_OtherTab as String
                cell.lbl_Prize.text = ("\(obj.str_PriceSymbol_OtherTab as String)\(obj.str_Prize_OtherTab as String)")
                
                
                if arr_Images.count != 0 {
                    let obj2 : HomeObject = arr_Images[0] as! HomeObject
                    
                    //Image set
                    cell.img_Product.sd_setImage(with: URL(string: obj2.str_Image_OtherTab as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                }else{
                    cell.img_Product.image = UIImage(named:Constant.placeHolder_Comman)
                }
                
                //Layer set
                cell.vw_Back.layer.cornerRadius = 5.0
                cell.vw_Back.layer.masksToBounds = true

            }else{
                cell.lbl_Title.text = "No favorite product available"
            }
           
        }else if cv_Main2 == collectionView {
            if arr_Shops.count != 0 {
                let obj : FavoriteObject = arr_Shops[indexPath.row] as! FavoriteObject
                
                //Set text in label
                cell.lbl_Title.text = obj.str_Shop_Name as String
                cell.lbl_SubTitle.text = obj.str_Shop_Title as String
                cell.lbl_Prize.text = "" as String
                
                //Image set
                cell.img_Product.sd_setImage(with: URL(string: obj.str_Shop_Logo as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
               
                //Layer set
                cell.vw_Back.layer.cornerRadius = 5.0
                cell.vw_Back.layer.masksToBounds = true
            }else{
                cell.lbl_Title.text = "No favorite shop available"
            }
        }else if cv_Main3 == collectionView {
            if arr_Business.count != 0 {
                let obj : FavoriteObject = arr_Business[indexPath.row] as! FavoriteObject
                
                //Set text in label
                cell.lbl_Title.text = obj.str_Shop_Name as String
                cell.lbl_SubTitle.text = obj.str_Shop_Title as String
                cell.lbl_Prize.text = "" as String
                
                //Image set
                cell.img_Product.sd_setImage(with: URL(string: obj.str_Shop_Logo as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                
                //Layer set
                cell.vw_Back.layer.cornerRadius = 5.0
                cell.vw_Back.layer.masksToBounds = true
            }else{
                cell.lbl_Title.text = "No favorite business available"
            }
        }else{
            //This box for array in tableview cell
            cell.img_Product.image = UIImage(named:"Img_SignInView")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cv_Main {
            let obj : HomeObject = arr_Items[indexPath.row] as! HomeObject
            let str_ID : NSString = obj.str_ID_OtherTab
            
            if str_ID.length != 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
                view.str_ProductIDGet = str_ID
                self.navigationController?.pushViewController(view, animated: false)
            }
        }else if collectionView == cv_Main2 {
            let obj : FavoriteObject = arr_Shops[indexPath.row] as! FavoriteObject
            let str_ID : NSString = obj.str_Shop_Id as NSString
            
            let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
            view.str_ShopIDGet = str_ID
            self.navigationController?.pushViewController(view, animated: true)
        }else if collectionView == cv_Main3 {
            let obj : FavoriteObject = arr_Business[indexPath.row] as! FavoriteObject
            let str_ID : NSString = obj.str_Shop_Id as NSString
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
            view.str_ProductIDGet = str_ID
            self.navigationController?.pushViewController(view, animated: false)
        }
        //Move to shop detail view
        
    }
}
//MARK: - Collection View Cell -
class FavoriteViewCollectioncell : UICollectionViewCell{
    //Label Declaration
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_SubTitle : UILabel!
    @IBOutlet weak var lbl_Prize : UILabel!
    
    //Image Declaration
    @IBOutlet weak var img_Product : UIImageView!
    @IBOutlet weak var vw_Back : UIView!
    
}




extension FavoriteViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        self.completedServiceCalling()
        
        let response = data as! NSDictionary
        if strRequest == "get_favourite_products" {
            
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
                obj.str_Prize_OtherTab = dict_Data.getStringForID(key:"price") as! NSString
                obj.str_DiscountPrize_OtherTab = ("\(dict_Data["discount_price"] as! Int)" as NSString)
                obj.str_Site_OtherTab = dict_Data["site"] as! String as NSString
                obj.str_Fav_OtherTab = ("\(dict_Data["is_favourite"] as! Int)" as NSString)
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
            
            //Refresh code
            if bool_ViewWill == true {
                arr_Items = []
                int_CountLoad = arr_StoreTemp.count
            }else{
                int_CountLoad = int_CountLoad + arr_StoreTemp.count
            }
            
            for i in (0...arr_StoreTemp.count-1){
                arr_Items.add(arr_StoreTemp[i])
            }
            
            //Load more data or not
            if Constant.int_LoadMax > arr_StoreTemp.count {
                //Bool Load more
                bool_SearchMore = false
            }
            else {
                //Bool Load more
                bool_SearchMore = true
            }
            
            bool_ViewWill = false
            cv_Main.reloadData()
        }else if strRequest == "get_favourite_shops" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            let arr_StoreTemp : NSMutableArray = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                //Other Tab Demo data
                let obj = FavoriteObject ()
                obj.str_Shop_Id = ("\(dict_Data["shop_id"] as! Int)" as NSString)
                obj.str_Shop_Name = dict_Data["shop_name"] as! String as NSString
                obj.str_Shop_Title = dict_Data["shop_title"] as! String as NSString
                obj.str_Shop_Website = dict_Data["website"] as! String as NSString
                obj.str_Shop_BG = dict_Data["shop_background"] as! String as NSString
                obj.str_Shop_Logo = dict_Data["shop_logo"] as! String as NSString
                
                arr_StoreTemp.add(obj)
            }
            
            //Refresh code
            if bool_ViewWill2 == true {
                arr_Shops = []
                int_CountLoad2 = arr_StoreTemp.count
            }else{
                int_CountLoad2 = int_CountLoad2 + arr_StoreTemp.count
            }
            
            for i in (0...arr_StoreTemp.count-1){
                arr_Shops.add(arr_StoreTemp[i])
            }
            
            //Load more data or not
            if Constant.int_LoadMax > arr_StoreTemp.count {
                //Bool Load more
                bool_SearchMore2 = false
            }
            else {
                //Bool Load more
                bool_SearchMore2 = true
            }
            
            bool_ViewWill2 = false
            cv_Main2.reloadData()
        }else if strRequest == "get_favourite_business" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            let arr_StoreTemp : NSMutableArray = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                //Other Tab Demo data
                let obj = FavoriteObject ()
                obj.str_Shop_Id = ("\(dict_Data["business_id"] as! Int)" as NSString)
                obj.str_Shop_Name = dict_Data["business_name"] as! String as NSString
                obj.str_Shop_Title = ""
                obj.str_Shop_Website = ""
                obj.str_Shop_BG = ""
                obj.str_Shop_Logo = dict_Data["business_logo"] as! String as NSString
                
                let arr_BG = dict_Data["business_background"] as! NSArray
                if arr_BG.count != 0{
                    let dict_BG = arr_BG[0] as! NSDictionary
                    obj.str_Shop_BG = dict_BG["image"] as! String as NSString
                    obj.str_Shop_Logo = dict_BG["image"] as! String as NSString
                }
                
                arr_StoreTemp.add(obj)
            }
            
            //Refresh code
            if bool_ViewWill3 == true {
                arr_Business = []
                int_CountLoad3 = arr_StoreTemp.count
            }else{
                int_CountLoad3 = int_CountLoad3 + arr_StoreTemp.count
            }
            
            for i in (0...arr_StoreTemp.count-1){
                arr_Business.add(arr_StoreTemp[i])
            }
            
            //Load more data or not
            if Constant.int_LoadMax > arr_StoreTemp.count {
                //Bool Load more
                bool_SearchMore3 = false
            }
            else {
                //Bool Load more
                bool_SearchMore3 = true
            }
            
            bool_ViewWill3 = false
            cv_Main3.reloadData()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        cv_Main.reloadData()
        cv_Main2.reloadData()
        cv_Main3.reloadData()
        
        bool_SearchMore = false
        self.completedServiceCalling()
    }
    
}





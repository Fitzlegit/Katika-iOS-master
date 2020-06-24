//
//  HomeProductListViewController.swift
//  Katika
//
//  Created by Apple on 03/04/19.
//  Copyright © 2019 icoderz123. All rights reserved.
//

import UIKit

class HomeProductListViewController: UIViewController {
    @IBOutlet weak var objCollectionView: UICollectionView!
    
    //OTHER VALUE
    var strheaderName : String = ""
    var selectIndex : Int = 0
    var foryouID : NSString = ""
    var arr_Main : NSMutableArray = []
    
    //Refresh Controller
    var objRefreshControl: UIRefreshControl?
    
    //Bool Declaration
    var bool_Load: Bool = false
    var bool_SearchMore: Bool = true
    
    //Max Min Limit
    var int_CountLoad: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = strheaderName
        
        //SET VIEW
        commanMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //SET NAVIGATION
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        int_CountLoad = Constant.int_LoadMax
        self.Get_Product(count:int_CountLoad)
    }
    
    //MARK: - Other Files -
    func commanMethod(){
        //Refresh Controller
        objRefreshControl = UIRefreshControl()
        objRefreshControl?.tintColor = UIColor.red
        objRefreshControl?.addTarget(self, action: #selector(self.refreshControl), for: .valueChanged)
        objCollectionView.addSubview(objRefreshControl!)
    }

    @objc func refreshControl(_ refreshControl: UIRefreshControl) {
        //        print("call from refresh_RecommendedTab")
        arr_Main = []
        int_CountLoad = Constant.int_LoadMax
        bool_SearchMore = true
        bool_Load = false
        self.Get_Product(count:int_CountLoad)
       
    }
    
    // MARK: - LOAD MORE
    
    // MARK: - UIScrollViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == objCollectionView {
            if objCollectionView.contentSize.height <= objCollectionView.contentOffset.y + objCollectionView.frame.size.height && objCollectionView.contentOffset.y >= 0 {
                if bool_Load == false && arr_Main.count != 0 {
                    self.Get_Product(count: int_CountLoad)
                }
            }
        }
    }
    

    // MARK: - Get/Post Method -
    func Get_Product(count : Int){
        var strURL : String = ""
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()
        
        if foryouID != ""{
            strURL = "\(Constant.BaseURL)get_ForYouProducts"

            jsonData = [
                "user_id" : objUser?.str_Userid ?? "",
                "skip" : "\(count - Constant.int_LoadMax)",
                "total" : "\(Constant.int_LoadMax)",
                "collection_id" : foryouID,
            ]
        }
        else{
            //Declaration URL
            strURL = "\(Constant.BaseURL)get_products_new"
            if selectIndex == 101{
                strURL = "\(Constant.BaseURL)get_products"
            }else if selectIndex == 104{
                strURL = "\(Constant.BaseURL)get_recentview_products"
            }
            
            jsonData = [
                "user_id" : objUser?.str_Userid ?? "",
                "skip" : "\(count - Constant.int_LoadMax)",
                "total" : "\(Constant.int_LoadMax)",
                "type" : strheaderName,
            ]
        }
       
        
        
        print(jsonData)
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_products"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        (arr_Main.count == 0) ? (webHelper.indicatorShowOrHide = true) : (webHelper.indicatorShowOrHide = false)

        //Not limit for end data than only service call
        if bool_SearchMore == true{
            bool_Load = true
            webHelper.startDownload()
        }
        
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func btnBackClicked(_ sender: Any) {
        //BACK
        self.navigationController?.popViewController(animated: true)
    }
}



//MARK: - Collection View -
extension HomeProductListViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arr_Main.count == 0{
            return 1
        }
        return arr_Main.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if arr_Main.count == 0 && bool_Load == false{
            return CGSize(width: collectionView.frame.size.width, height: 30)
        }
        return CGSize(width: collectionView.frame.size.width/2, height: CGFloat(((collectionView.frame.size.width/2)*200)/175))

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var str_Identifier : String = "NewHomeViewCollectioncell"
        if arr_Main.count == 0{
            str_Identifier = "nodata"
        }
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: str_Identifier, for: indexPath) as! NewHomeViewCollectioncell
        
        if arr_Main.count != 0{
            let obj = arr_Main[indexPath.row] as! HomeObject
            let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
            
            //SET TILE FONT
            cell.lbl_Title_OtherTab.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
            cell.lbl_SubTitle_OtherTab.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
            cell.lbl_Prize_OtherTab.font = UIFont(name: Constant.kFontSemiBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
            
            //Set text in label
            cell.lbl_Title_OtherTab.text = obj.str_Title_OtherTab as String
            cell.lbl_SubTitle_OtherTab.text = obj.str_ShopName_OtherTab as String
            
            let int_Value = obj.str_Prize_OtherTab as String
            cell.lbl_Prize_OtherTab.text = ("\(obj.str_PriceSymbol_OtherTab as String)\(int_Value)")
            
            if arr_Images.count != 0 {
                let obj2 : HomeObject = arr_Images[0] as! HomeObject
                
                //Image set
                cell.img_Image_OtherTab.sd_setImage(with: URL(string: obj2.str_Image_OtherTab as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
            }else{
                cell.img_Image_OtherTab.image = UIImage(named:Constant.placeHolder_Comman)
            }
            
            //Layer set
            cell.vw_Back_OtherTab.layer.cornerRadius = 5.0
            cell.vw_Back_OtherTab.layer.masksToBounds = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let obj = arr_Main[indexPath.row] as! HomeObject
        //MOVE PROFUCT DETAILS SCREEN
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        view.str_ProductIDGet = obj.str_ID_OtherTab
        self.navigationController?.pushViewController(view, animated: true)
    }
}



extension HomeProductListViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        objRefreshControl?.endRefreshing()

        let response = data as! NSDictionary
        if strRequest == "get_products" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            let arr_StoreTemp : NSMutableArray = []

            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                print("=============================")
                print(dict_Data)
                print("=============================")
                
                //Other Tab Demo data
                let obj = HomeObject ()
                obj.str_ID_OtherTab = ("\(dict_Data["product_id"] as! Int)" as NSString)
                obj.str_Title_OtherTab = dict_Data["p_title"] as! String as NSString
                obj.str_SubTitle_OtherTab = dict_Data["p_descriiption"] as! String as NSString
                obj.str_Prize_OtherTab = ("\(String(format: "%.2f", dict_Data["price"] as! Double))" as NSString)
                
                
                obj.str_DiscountPrize_OtherTab = ("\(dict_Data["discount_price"] as! Double)" as NSString)
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
            
            //SET DATA
            for i in (0...arr_StoreTemp.count-1){
                arr_Main.add(arr_StoreTemp[i])
            }
            
            
            //Refresh code
            int_CountLoad = int_CountLoad + arr_StoreTemp.count

            
            //Load more data or not
            if Constant.int_LoadMax == arr_StoreTemp.count {
                //Bool Load more
                bool_SearchMore = true
                bool_Load = false
              
            }
            else {
                //Bool Load more
                bool_SearchMore = false
                bool_Load = true
            }
            
            //RELOAD CPLLECTION VIEW
            objCollectionView.reloadData()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
        objRefreshControl?.endRefreshing()
        //RELOAD CPLLECTION VIEW
        objCollectionView.reloadData()
    }
    
}

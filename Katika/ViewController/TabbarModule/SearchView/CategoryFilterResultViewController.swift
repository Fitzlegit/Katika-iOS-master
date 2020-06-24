//
//  CategoryFilterResultViewController.swift
//  Katika
//
//  Created by Katika on 15/06/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class CategoryFilterResultViewController: UIViewController {
    //view declaration
    @IBOutlet var vw_SearchBar : UIView!
    
    //Other declaration
    @IBOutlet var tf_Search : UITextField!
    
    //Button Event
    @IBOutlet var btn_CancelSearch : UIButton!
    
    //Other Declaration
    @IBOutlet var cv_Main : UICollectionView!
    
    //Array Declaration
    var arr_Main : NSMutableArray = []
    var arr_Main_Store : NSMutableArray = []
    
    //Label declaration
    @IBOutlet var lbl_Categoryname : UILabel!
    @IBOutlet var lbl_SubCategoryname : UILabel!
    
    var category_List : NSString = ""
    var category_List_Path : NSString = ""
    
    var category_Filter_1 : NSString = ""
    var category_Filter_2 : NSString = ""
    var category_Filter_3 : NSString = ""
    var category_SearchValue : NSString = ""
    
    var int_CountLoad: Int = 0
    
    var str_TotalReview: NSString = "0"
    
    //Bool Declaration
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    var bool_SearchMore: Bool = true
    var bool_ViewDidload: Bool = false
    
    //Refresh Controller
    var refresh_Item: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commanMethod()
        bool_ViewDidload = true
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if bool_ViewDidload == true {
            bool_ViewDidload = false
            
            if category_SearchValue != ""{
                tf_Search.text = category_SearchValue as String
                category_SearchValue = ""
            }
            
            self.Post_CategoryUpdate()
        }else{
            //First time sevice call for Product listing depend on search condition
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore = true
            
            arr_Main = []
            cv_Main.reloadData()
            
            self.Get_CategoryFilter(count:int_CountLoad)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Scrollview Delegate -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        if scrollView == cv_Main{
            if cv_Main.contentSize.height <= cv_Main.contentOffset.y + cv_Main.frame.size.height && cv_Main.contentOffset.y >= 0 {
                if bool_Load == false && arr_Main.count != 0 {
                    self.Get_CategoryFilter(count: int_CountLoad + Constant.int_LoadMax)
                }
            }
        }
    }
    
    // MARK: - TextField Manage -
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btn_CancelSearch.isHidden = false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if tf_Search == textField && tf_Search.text == "" {
            
            cv_Main.reloadData()
            btn_CancelSearch.isHidden = true
            
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if tf_Search == textField {
            view.endEditing(true)
            
            if tf_Search.text != "" {
                arr_Main = []
                int_CountLoad = Constant.int_LoadMax
                bool_ViewWill = true
                bool_SearchMore = true
                self.Get_CategoryFilter(count:int_CountLoad)
            }else{
                arr_Main = []
                int_CountLoad = Constant.int_LoadMax
                bool_ViewWill = true
                bool_SearchMore = true
                self.Get_CategoryFilter(count:int_CountLoad)
            }
        }
        cv_Main.reloadData()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.phase == .began {
            view.endEditing(true)
        }
    }
    @objc func textFieldDidChange(textField: UITextField){
        
    }
    
    
    //MARK: - Other Files -
    func commanMethod(){
        
        //Layer declaration
        vw_SearchBar.layer.cornerRadius = 5
        vw_SearchBar.layer.borderColor = UIColor.darkGray.cgColor
        vw_SearchBar.layer.borderWidth = 0.5
        vw_SearchBar.layer.masksToBounds = true
        
        //Refresh Controller
        refresh_Item = UIRefreshControl()
        refresh_Item?.tintColor = UIColor.red
        refresh_Item?.addTarget(self, action: #selector(self.refreshItem), for: .valueChanged)
        cv_Main.addSubview(refresh_Item!)
        
        //Text change method in textfield
        tf_Search.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        //Manage Lenth for string
        lbl_SubCategoryname.text = category_List as String
        
        //If we get category list in previous view than we devide into 3 category
        if category_List_Path != "" {
            print(category_List_Path)

            //Get array with provided filter string
            let fullNameArr = category_List_Path.components(separatedBy: ".")

            //First filter init
            category_Filter_1 = fullNameArr[0] as NSString
            
            //Second filter condition
            if fullNameArr.count > 1 {
                category_Filter_2 = fullNameArr[1] as NSString
            }else{
                category_Filter_2 = "0"
            }
            
            //Third filter condition
            if fullNameArr.count > 2 {
                category_Filter_3 = fullNameArr[2] as NSString
            }else{
                category_Filter_3 = "0"
            }
        }
    }
    func completedServiceCalling(){
        refresh_Item?.endRefreshing()
        
        bool_Load = false
    }
    @objc func refreshItem(_ refresh: UIRefreshControl) {
        if bool_Load == false {
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore = true
            
            self.Get_CategoryFilter(count:int_CountLoad)
        }else{
            refresh_Item?.endRefreshing()
        }
    }
    
    //MARK: - Button Event -
    @IBAction func btn_CancelSearch(_ sender : Any){
        btn_CancelSearch.isHidden = true
//        tf_Search.text = ""
//        self.view.endEditing(true)
        
        
        if tf_Search.text != "" {
            tf_Search.text = ""
            
            //Get data for all text defualt
            arr_Main = []
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore = true
            self.Get_CategoryFilter(count:int_CountLoad)
        }
        
        self.view.endEditing(true)
    }
    @IBAction func btn_Back(_ sender : Any){
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Filter(_ sender : Any){
        self.performSegue(withIdentifier: "productfilter", sender: self)
    }
    
    // MARK: - Get/Post Method -
    func Get_CategoryFilter(count : Int){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_search_products"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
            "searchkey" : tf_Search.text!
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_search_products"
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
    func Post_CategoryUpdate(){
        
        //Declaration URL
        var strURL = "\(Constant.BaseURL)updatefilter_category_product"
   
       
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String ,
            "categoryid" : "\(category_Filter_1),\(category_Filter_2),\(category_Filter_3)",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "updatefilter_category"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "productfilter"{
            
            let view : FilterViewController = segue.destination as! FilterViewController
            view.str_ValueType = "product"
        }
     }
    
    
}

//MARK: - Search Object -

class CategoryFilterViewObject: NSObject {
    var str_Title : NSString = ""
    var str_SubTitle : NSString = ""
    var str_Prize : NSString = ""
    var str_Image : NSString = ""
}


//MARK: - Collectionview Delegate -
extension CategoryFilterResultViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returen number of cell with content available in array
        if cv_Main == collectionView {
            if arr_Main.count == 0 {
                return 1
            }
            return arr_Main.count
        }
        
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Returen number of cell with content available in array
        if cv_Main == collectionView {
            if arr_Main.count == 0 {
                return CGSize(width: collectionView.frame.size.width, height: 30)
            }
            return CGSize(width: collectionView.frame.size.width/2, height: CGFloat(((collectionView.frame.size.width/2)*200)/175))
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var str_CellIdentifier : NSString = "cell"
        if arr_Main.count == 0 {
            str_CellIdentifier = "nodata"
        }
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier:str_CellIdentifier as String, for: indexPath) as! CategoryFilterViewCollectioncell
        
        if cv_Main == collectionView {
            if arr_Main.count != 0 {
                let obj : HomeObject = arr_Main[indexPath.row] as! HomeObject
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
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj : HomeObject = arr_Main[indexPath.row] as! HomeObject
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        view.str_ProductIDGet = obj.str_ID_OtherTab
        self.navigationController?.pushViewController(view, animated: false)
    }
}
//MARK: - Collection View Cell -
class CategoryFilterViewCollectioncell : UICollectionViewCell{
    //Label Declaration
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_SubTitle : UILabel!
    @IBOutlet weak var lbl_Prize : UILabel!
    
    //Image Declaration
    @IBOutlet weak var img_Product : UIImageView!
    @IBOutlet weak var vw_Back : UIView!
}


//MARK: - Webservice Helper Response Class -
extension CategoryFilterResultViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        self.completedServiceCalling()
        
        let response = data as! NSDictionary
        print(response)
        if strRequest == "get_search_products" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            let arr_Category = response["Categoryselected"] as! NSArray

            
            if arr_result.count != 0 {
                str_TotalReview = ("\(response["TotalRecord"] as! Int)" as NSString)
                lbl_Categoryname.text = "Result : \(str_TotalReview as String)"
                
                var arr_StoreTemp : NSMutableArray = []
                for i in (0..<arr_result.count) {
                    let dict_Data = arr_result[i] as! NSDictionary
                    
                    print(dict_Data["price"]!)
                    print(dict_Data["price"] as? Float! as Any)
                    //Other Tab Demo data
                    let obj = HomeObject ()
                    obj.str_ID_OtherTab = ("\(dict_Data["product_id"] as! Int)" as NSString)
                    obj.str_Title_OtherTab = dict_Data["p_title"] as! String as NSString
                    obj.str_SubTitle_OtherTab = dict_Data["p_descriiption"] as! String as NSString
//                    obj.str_Prize_OtherTab = ("\(dict_Data["price"] as? Double ?? 0)" as NSString)
                    obj.str_Prize_OtherTab = ("\(String(format: "%.2f", dict_Data["price"] as! Double))" as NSString)

                    obj.str_DiscountPrize_OtherTab = ("\(dict_Data["discount_price"] as! Double)" as NSString)
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
                    arr_Main = []
                    int_CountLoad = arr_StoreTemp.count
                }else{
                    int_CountLoad = int_CountLoad + arr_StoreTemp.count
                }
                
                for i in (0...arr_StoreTemp.count-1){
                    arr_Main.add(arr_StoreTemp[i])
                }
                //arr_Main_Store = NSMutableArray(array: arr_Main);

                
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
            }else{
                lbl_Categoryname.text = "Result : 0"
            }
            
            //Set category value
            if arr_Category.count != 0{
                for i in (0..<arr_Category.count) {
                    let dict_Data = arr_Category[i] as! NSDictionary
                    
                    if i == 0 {
                        lbl_SubCategoryname.text = dict_Data["c_title"] as! String
                    }else{
                        lbl_SubCategoryname.text = "\(lbl_SubCategoryname.text as! String) > \(dict_Data["c_title"] as! String as NSString)"
                    }
                }
                if arr_Category.count == 0 {
                    lbl_SubCategoryname.text = "All Category"
                }
            }
            
        }else if strRequest == "updatefilter_category" {
            //First time sevice call for Product listing depend on search condition
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore = true
            self.Get_CategoryFilter(count:int_CountLoad)
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        lbl_Categoryname.text = "Result : 0"
        
        bool_SearchMore = false
        self.completedServiceCalling()
    }
    
}




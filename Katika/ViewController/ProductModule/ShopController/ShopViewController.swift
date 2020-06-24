//
//  ShopViewController.swift
//  Katika
//
//  Created by Katika on 25/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//


import UIKit
import FTImageViewer
import MessageUI
import SwiftMessages
import Cosmos
import ActionSheetPicker_3_0

class ShopViewController: UIViewController ,MFMailComposeViewControllerDelegate,UITextFieldDelegate,DismissShareViewDelegate{

    // View review
    @IBOutlet var view_Reviews: UIView!

    //View Declaration
    @IBOutlet var view_MoreInformation: UIView!
    @IBOutlet var view_AboutShop: UIView!
    @IBOutlet var view_Policies: UIView!
    
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    @IBOutlet var tbl_Review : UITableView!
    @IBOutlet var tbl_About : UITableView!
    
    //Declaration Button
    @IBOutlet var btn_Shop : UIButton!
    @IBOutlet var btn_About : UIButton!
    @IBOutlet var btn_Reviews : UIButton!
    @IBOutlet var btn_Policies : UIButton!
    @IBOutlet var btn_More : UIButton!
    @IBOutlet var btn_Favorite : UIButton!
    @IBOutlet var btn_Contact : UIButton!
    var  btn_Filter_Section_Save : UIButton!
    
    //Declaratino Images
    @IBOutlet var img_Shop_BG_Header : UIImageView!
    @IBOutlet var img_Shop_Profile : UIImageView!
    @IBOutlet var img_Fav_Share_About : UIImageView!
    
    //Declaratino Label
    @IBOutlet var lbl_Shop_UserName : UILabel!
    @IBOutlet var lbl_Shop_Location : UILabel!
    @IBOutlet var lbl_About_ProductName : UILabel!
    @IBOutlet var lbl_Policy_Date : UILabel!
    @IBOutlet var lbl_Shop_TotalReview : UILabel!
    @IBOutlet var lbl_NoPolicy : UILabel!
    
    //Page view controller
    @IBOutlet var pg_Header : UIPageControl!
    
    //Collection view declaration
    @IBOutlet var cv_AboutusHeader : UICollectionView!
    
    //Get Data From Other view
    var str_ShopIDGet : NSString!
    var objShopDetailData = ShopObject ()
    var tf_Search_Main : UITextField!
    var btn_CancelSearch_Main : UIButton!
    
    //Declaration Array
    var arr_SortProduct : NSMutableArray = []
    var arr_Reviews : NSMutableArray = []
    var arr_AboutUs : [AboutObject] = []
    
    //Constant Declaration
    @IBOutlet var con_Shop : NSLayoutConstraint!
    @IBOutlet var con_About : NSLayoutConstraint!
    @IBOutlet var con_Reviws : NSLayoutConstraint!
    @IBOutlet var con_Policy : NSLayoutConstraint!

    
    //Constact Declaration
    @IBOutlet var con_TabSelecetd : NSLayoutConstraint!
    
    //Bool Declaration
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    var bool_SearchMore_Feature: Bool = true
    var bool_SearchMore_FeatureReview: Bool = true
    var bool_EditOn: Bool = false
    
    //Max Min Limit
    var int_CountLoad: Int = 0
    var int_CountLoadReview: Int = 0
    
    //Max Min Limit
    var int_CountLoad_Feature: Int = 0
    var int_CountLoad_FeatureReview: Int = 0
    
    //Declaration Textview
    @IBOutlet var tv_Policy : UITextView!
    @IBOutlet var tv_More : UITextView!
    
    //Other Declaration
    @IBOutlet var rate_ShopRate: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commanMethod()
        
        //Caling service for get product detail
        self.Get_ShopDetail()
        self.Post_recent_view_shop()
        tbl_Main.isHidden = true
        
        
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
        if cv_AboutusHeader == scrollView{
            let visibleRect = CGRect(origin: cv_AboutusHeader.contentOffset, size: cv_AboutusHeader.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let indexPath = cv_AboutusHeader.indexPathForItem(at: visiblePoint)
            
            pg_Header.currentPage = (indexPath?.row)!
        }else if scrollView == tbl_Main{
            if tbl_Main.contentSize.height <= tbl_Main.contentOffset.y + tbl_Main.frame.size.height && tbl_Main.contentOffset.y >= 0 {
                if bool_Load == false && arr_SortProduct.count != 0 {
                    self.Get_ShopProduct(count: int_CountLoad_Feature + Constant.int_LoadMax)
                }
            }
        }else if scrollView == tbl_Review{
         //   view.endEditing(true)
            if tbl_Review.contentSize.height <= tbl_Review.contentOffset.y + tbl_Review.frame.size.height && tbl_Review.contentOffset.y >= 0 {
                if bool_Load == false && arr_Reviews.count != 0 {
                    self.Get_ShopReviews(count: int_CountLoad_FeatureReview + Constant.int_LoadMax)
                }
            }
        }
    }
    
    // MARK: - MessageView controller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: { _ in })
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        bool_EditOn = true
        btn_CancelSearch_Main.isHidden = false
        
        //manage Footer View for depend on text
        if arr_SortProduct.count != 0 {
            
            let intTotalRequired : Int = Int(tbl_Main.frame.size.height - 80)
            
            var int_Count : Int = Int(arr_SortProduct.count/2)
            if arr_SortProduct.count % 2 != 0 {
                int_Count = int_Count + 1
            }
            var NowAvailableHeight : Int = Int(CGFloat(((tbl_Main.frame.size.width/2)*200)/175))
            NowAvailableHeight = NowAvailableHeight * int_Count
            
            if intTotalRequired > NowAvailableHeight  {
                let vw : UIView = tbl_Main.tableFooterView!
                vw.frame = CGRect(x: 0, y: 0, width: Int(CGFloat(Constant.windowWidth)), height: intTotalRequired - NowAvailableHeight)
                tbl_Main.tableFooterView = vw;
            }
        }
        
        //Scroll to top View
        let indexPaths = IndexPath(row: 0, section: 1)
        tbl_Main.scrollToRow(at: indexPaths, at: .top, animated: true)
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(reloadTable), userInfo: nil, repeats: false)
        
    }
    @objc func reloadTable() {
        tbl_Main.reloadData()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if bool_EditOn == false {
            view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
                //Set constant with screen size
                let vw : UIView = self.tbl_Main.tableFooterView!
                vw.frame = CGRect(x: 0, y: 0, width: CGFloat(Constant.windowWidth), height: 0)
                self.tbl_Main.tableFooterView = vw
                self.view .layoutIfNeeded()
            }, completion: nil)
            
            
            Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(reloadTable), userInfo: nil, repeats: false)
            btn_CancelSearch_Main.isHidden = true
            return true
        }

        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bool_EditOn = false
        
        view.endEditing(true)
        
        let trimmedString = tf_Search_Main.text?.trimmingCharacters(in: .whitespaces)
        
        if trimmedString != "" {
            arr_SortProduct = []
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_Feature = true
            self.Get_ShopProduct(count:int_CountLoad)
        }else{
            arr_SortProduct = []
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_Feature = true
            self.Get_ShopProduct(count:int_CountLoad)
        }
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
        
        let obj2 = AboutObject ()
        obj2.str_Image = "Img_SignInView"
        arr_AboutUs.append(obj2)
        arr_AboutUs.append(obj2)
        arr_AboutUs.append(obj2)
        arr_AboutUs.append(obj2)
        arr_AboutUs.append(obj2)
        
        //Layer set
        btn_Favorite.layer.cornerRadius = 5
        btn_Favorite.layer.borderWidth = 1
        btn_Favorite.layer.borderColor = UIColor.darkGray.cgColor
        btn_Favorite.layer.masksToBounds = true
        
        btn_Contact.layer.cornerRadius = 5
        btn_Contact.layer.borderWidth = 1
        btn_Contact.layer.borderColor = UIColor.darkGray.cgColor
        btn_Contact.layer.masksToBounds = true
        
        //Table view header heigh set
        var vw : UIView = tbl_Main.tableHeaderView!
        vw.frame = CGRect(x: 0, y: 0, width: CGFloat(Constant.windowWidth), height: CGFloat((Constant.windowHeight * 245)/Constant.screenHeightDeveloper))
        tbl_Main.tableHeaderView = vw;
        vw = tbl_About.tableHeaderView!
        vw.frame = CGRect(x: 0, y: 0, width: CGFloat(Constant.windowWidth), height: CGFloat((Constant.windowHeight * 284)/Constant.screenHeightDeveloper))
        tbl_About.tableHeaderView = vw;
        
        //View more manage
        view_MoreInformation.isHidden = true;
        
        // Review view Setup
        setupReviewView()
        
        // View Policies Setup
        view_Policies.isHidden = false
        
        // View About Shop
        view_AboutShop.isHidden = false
        
        //Temp Data set
        if arr_SortProduct.count == 0 {
            int_CountLoad_Feature = Constant.int_LoadMax
        }
        
        //Page header color set
        pg_Header.pageIndicatorTintColor = UIColor(patternImage:UIImage(named: "img_Page")!)
        pg_Header.currentPageIndicatorTintColor = UIColor(red: CGFloat((207 / 255.0)), green: CGFloat((198 / 255.0)), blue: CGFloat((188 / 255.0)), alpha: CGFloat(1.0))
        
        //Hide footer view
        tbl_Review.tableFooterView = UIView()
        
        //Constant Manage
        con_Shop.constant = 0
        con_About.constant = CGFloat(Constant.windowWidth)
        con_Reviws.constant = CGFloat(Constant.windowWidth) * 2
        con_Policy.constant = CGFloat(Constant.windowWidth) * 3
        
        lbl_NoPolicy.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 16)/Constant.screenWidthDeveloper))
    }
    func manageTabBarButton() {
        btn_Shop.isSelected = false
        btn_About.isSelected = false
        btn_Reviews.isSelected = false
        btn_Policies.isSelected = false
    }

    func setupReviewView() {
      
        view_Reviews.isHidden = true
    }
    func manageDataFill(){
        
        //Shop Tab
        img_Shop_BG_Header.sd_setImage(with: URL(string: objShopDetailData.str_Shop_BG as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        img_Shop_Profile.sd_setImage(with: URL(string: objShopDetailData.str_Shop_Logo as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))

        lbl_Shop_UserName.text = objShopDetailData.str_Shop_Name as String
        lbl_Shop_Location.text = objShopDetailData.str_Shop_Location as String
        
        //About Tab
        lbl_About_ProductName.text = ("About \(objShopDetailData.str_Shop_Name)")

        //About and Plicy tab
        let attrMore = try! NSAttributedString(
            data: objShopDetailData.str_Shop_More.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([ convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html)]),
            documentAttributes: nil)
        tv_More.attributedText = attrMore
        
        let attrPolicy = try! NSAttributedString(
            data: objShopDetailData.str_Shop_Policy.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([ convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html)]),
            documentAttributes: nil)
        tv_Policy.attributedText = attrPolicy
        lbl_Policy_Date.text = objShopDetailData.str_Shop_PolicyDate as String
        
//        lbl_NoPolicy.isHidden = false
        if objShopDetailData.str_Shop_Policy == ""{
            lbl_NoPolicy.isHidden = false
        }
        
        //Fav and Unfav
        if objShopDetailData.str_Shop_Favotite == "0" {
            btn_Favorite.isSelected = false
        }else{
            btn_Favorite.isSelected = true
        }
        
        //Mange Relating
        rate_ShopRate.rating = (objShopDetailData.str_Shop_AvgReview).boolValue ? (Double(objShopDetailData.str_Shop_AvgReview as String)!) : 0.0
        lbl_Shop_TotalReview.text = "(\(objShopDetailData.str_Shop_TotalReview))"
        
    }
    func relaodDataView(){
        tbl_Main.reloadData()
        tbl_About.reloadData()
        tbl_Review.reloadData()
        cv_AboutusHeader.reloadData()
    }
    func completedServiceCalling(){
        //Comman fuction action
        bool_Load = false
    }
    func shareMail(receiverMain : String,Body: String){
        if MFMailComposeViewController.canSendMail() {
            
            let emailDialog = MFMailComposeViewController()
            emailDialog.mailComposeDelegate = self
            let htmlMsg: String = "<html><body><p>\(Body)</p></body></html>"
             emailDialog.setToRecipients([receiverMain])
            
            emailDialog.setSubject("email subject")
            emailDialog.setMessageBody(htmlMsg, isHTML: true)
            present(emailDialog, animated: true, completion: { _ in })
        }else{
              messageBar.MessageShow(title: "Mail account not comfortable in your device.", alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
        }
    }
    func manageTypeOfFilter() -> String{
        
        let arr_Data: [Any] = ["All","Most Recent","Lowest Price","Highest Price","Most Popular"]
        var int_Sort = selectedIndex(arr: arr_Data as NSArray, value: (btn_Filter_Section_Save.titleLabel?.text as? NSString)!)
        
        switch int_Sort {
        case 0:
            return ""
            break
        case 1:
            return "MostRecent"
            break
        case 2:
            return "LowestPrice"
            break
        case 3:
            return "HighestPrice"
            break
        case 4:
            return "MostPopular"
            break
            
            default:
                return ""
            break
        }
        
    }
    func ShareOption(info: NSInteger) {
        if info == 1 {
           self .performSegue(withIdentifier: "messagetoshopowner", sender: nil)
        }else if info == 2 {

        }
    }
 
    
        
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
       var _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btt_Shop(_ sender:Any){
        self.manageTabBarButton()
        btn_Shop.isSelected = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.con_TabSelecetd.constant = 0;
            
            self.con_Shop.constant = 0
            self.con_About.constant = CGFloat(Constant.windowWidth)
            self.con_Reviws.constant = CGFloat(Constant.windowWidth) * 2
            self.con_Policy.constant = CGFloat(Constant.windowWidth) * 3
            
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
           // self.reloadData()
        })
    }
    @IBAction func btn_About(_ sender:Any){
        self.manageTabBarButton()
        view_AboutShop.isHidden = false
        btn_About.isSelected = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.con_TabSelecetd.constant = CGFloat(Float(Constant.windowWidth/4));

            self.con_Shop.constant = -CGFloat(Constant.windowWidth)
            self.con_About.constant = 0
            self.con_Reviws.constant = CGFloat(Constant.windowWidth)
            self.con_Policy.constant = CGFloat(Constant.windowWidth) * 2
            
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            // self.reloadData()
        })
    }
    @IBAction func btn_Reviews(_ sender:Any){
        self.manageTabBarButton()
        
        view_Reviews.isHidden = false
        btn_Reviews.isSelected = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.con_TabSelecetd.constant = CGFloat(Float(Constant.windowWidth/4) * 2);
            
            self.con_Shop.constant = -CGFloat(Constant.windowWidth) * 2
            self.con_About.constant = -CGFloat(Constant.windowWidth)
            self.con_Reviws.constant = 0
            self.con_Policy.constant = CGFloat(Constant.windowWidth)
            
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            // self.reloadData()
        })
        
        if arr_Reviews.count == 0 {
            int_CountLoad_FeatureReview = Constant.int_LoadMax
            
            //calling service for shop product listing
            int_CountLoadReview = Constant.int_LoadMax
            bool_ViewWill = true
            self.Get_ShopReviews(count:int_CountLoadReview)
        }
    }
    @IBAction func btn_Policies(_ sender:Any){
        self.manageTabBarButton()
        btn_Policies.isSelected = true
         view_Policies.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.con_TabSelecetd.constant = CGFloat(Float(Constant.windowWidth/4) * 3);
            
            self.con_Shop.constant = -CGFloat(Constant.windowWidth) * 3
            self.con_About.constant = -CGFloat(Constant.windowWidth) * 2
            self.con_Reviws.constant = -CGFloat(Constant.windowWidth)
            self.con_Policy.constant = 0
            
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            // self.reloadData()
        })
    }
    @IBAction func btn_More (_ sender:Any){
        self.manageTabBarButton()
        view_MoreInformation.isHidden = false
        btn_More.isSelected = true
        
        con_TabSelecetd.constant = CGFloat(Float(Constant.windowWidth/4) * 4);
    }
    @IBAction func btn_Favorite (_ sender:Any){
        if btn_Favorite.isSelected == true {
            btn_Favorite.isSelected = false
            self.Post_Fav(flag:"0")
            
            if img_Fav_Share_About != nil {
                img_Fav_Share_About.image = UIImage.init(named: "icon_Save_Shop")
            }
        }else{
            btn_Favorite.isSelected = true
            self.Post_Fav(flag:"1")
            
            if img_Fav_Share_About != nil {
                img_Fav_Share_About.image = UIImage.init(named: "icon_Save_Shop_Selected")
                
            }
        }
    }
    @IBAction func btn_Share_Contact (_ sender:Any){
        self .performSegue(withIdentifier: "sharepopup", sender: nil)
    }
    
    @IBAction func btn_Contact (_ sender:Any){
        let str_Value : String = "Shop Name : \(objShopDetailData.str_Shop_Name)"
        self.shareMail(receiverMain:objShopDetailData.str_Shop_Email as String,Body : str_Value)
    }
    @IBAction func btn_Share_About (_ sender : Any){
        shareFunction(textData : "I saw this shop on Katika and wanted to share it with you \n\nshop Name : \(objShopDetailData.str_Shop_Name as String)\n\nKatika is an International Directory and Marketplace where people around the world connect to find local businesses and buy and sell products.",image : img_Shop_Profile.image! ,viewPresent: self)
        
    }
    @IBAction func btn_ProductClick (_ sender : Any){
        bool_EditOn = false
        self.view.endEditing(true)
        
        let obj : HomeObject = arr_SortProduct[(sender as AnyObject).tag] as! HomeObject
        if obj.str_ID_OtherTab.length != 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            view.str_ProductIDGet = obj.str_ID_OtherTab
            self.navigationController?.pushViewController(view, animated: false)
        }
    }
    @IBAction func btn_Filter_Section (_ sender : Any){
        let btn : UIButton? = (sender as? UIButton)
        let arr_Data: [Any] = ["All","Most Recent","Lowest Price","Highest Price","Most Popular"]
        
        let str_Title = (btn?.titleLabel?.text == "Sort") ? "All" : (btn?.titleLabel?.text)
        
        let picker = ActionSheetStringPicker(title: "Select TYPE", rows: arr_Data, initialSelection:selectedIndex(arr: arr_Data as NSArray, value: (str_Title as? NSString)!), doneBlock: { (picker, indexes, values) in
           
            if indexes == 0{
                //Set button title for selected button and save button
                btn?.setTitle("Sort", for: .normal)
                self.btn_Filter_Section_Save?.setTitle("Sort", for: .normal)
            }else{
                //Set button title for selected button and save button
                btn?.setTitle(values as! String?, for: .normal)
                self.btn_Filter_Section_Save?.setTitle(values as! String?, for: .normal)
            }
            
            //Service calling with remove arry and all other paramater
            self.arr_SortProduct = []
            self.tbl_Main.reloadData()
            
            self.int_CountLoad = Constant.int_LoadMax
            self.bool_ViewWill = true
            self.bool_SearchMore_Feature = true
            self.Get_ShopProduct(count:self.int_CountLoad)
           
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
        picker?.hideCancel = false
        picker?.setDoneButton(UIBarButtonItem(title: "DONE", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()

    }
    @IBAction func btn_CancelSearch(_ sender : Any){
        //btn_CancelSearch.isHidden = true
        
        if tf_Search_Main.text != "" {
            tf_Search_Main.text = ""
            //Get data for all text defualt
            arr_SortProduct = []
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_Feature = true
            self.Get_ShopProduct(count:int_CountLoad)
        }
        
        bool_EditOn = false
        self.view.endEditing(true)
        
    }
    @IBAction func btn_ProductDetailReview (_ sender : Any){
        
        let obj : ReviewObjet = arr_Reviews[(sender as AnyObject).tag] as! ReviewObjet
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        view.str_ProductIDGet = obj.str_Product_id as String as NSString
        self.navigationController?.pushViewController(view, animated: false)
        
    }
    @IBAction func btn_ClickMessage (_ sender : Any){
        let obj : ReviewObjet = arr_Reviews[(sender as AnyObject).tag] as! ReviewObjet
        
        if obj.str_QuickBoxId != ""{
            if obj.str_QuickBoxId as String != objUser?.str_Quickbox as! String {
                createGroupWithQuickBox(str_ID:Int(obj.str_QuickBoxId as String)!,view:self)
            }
        }
    }
    
    
    // MARK: - Get/Post Method -
    func Get_ShopDetail(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_shop_details"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
            "shopid" : str_ShopIDGet,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_shop_details"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
    
    func Get_ShopProduct(count : Int){
        bool_Load = true
       // view.endEditing(true)
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_shop_products"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
            "shopid" : str_ShopIDGet,
            "searchkey" : (tf_Search_Main != nil) ? (tf_Search_Main.text) : "",
            "type" : manageTypeOfFilter()
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_shop_products"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        //If first time call than only show loader otherwise not showing loader
        let searchKey : String = (tf_Search_Main != nil) ? (tf_Search_Main.text)! : ""
        if (arr_SortProduct.count == 0 && searchKey != "") {
            webHelper.indicatorShowOrHide = true
        }else{
            webHelper.indicatorShowOrHide = false
        }
        
        if bool_SearchMore_Feature == true{
            webHelper.startDownload()
        }
        
       
    }
    
    func Get_ShopReviews(count : Int){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_shop_reviews"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
            "shop_id" : str_ShopIDGet,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_shop_reviews"
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
    
    
    func Post_Fav(flag : String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)addremove_favourite_shop"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
            "shop_id" : str_ShopIDGet,
            "status" : flag,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "addremove_favourite_shop"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
        
    }

    func Post_recent_view_shop(){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)add_recent_view_shop"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
            "shop_id" : str_ShopIDGet,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "add_recent_view_shop"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        //If first time call than only show loader otherwise not showing loader
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sharepopup" {
            let  popUpView  = segue.destination as! ShareSelection
            popUpView.delegate = self
        }
    }
    
}


//MARK: - Shop Object -

class ShopObject: NSObject {
    
    //Product listing Other
    var str_Title_Sort : NSString = ""
    var str_SubTitle_Sort : NSString = ""
    var str_Prize_Sort : NSString = ""
    var str_Image_Sort : NSString = ""
    
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
    var str_Shop_Instalink : NSString = ""

    var str_Shop_Favotite : NSString = ""
    var str_Shop_Policy : NSString = ""
    var str_Shop_More : NSString = ""
    var str_Shop_PolicyDate : NSString = ""
    var str_Shop_MoreDate : NSString = ""
    var str_Shop_TotalReview : NSString = ""
    var str_Shop_AvgReview : NSString = ""
    
    var arr_Image : NSMutableArray = []
    var str_Shop_Images : NSString = ""
    
    var arr_OwnerMember : NSMutableArray = []
    var str_Owner_Images : NSString = ""
    var str_Owner_Name : NSString = ""
    var str_Owner_Position : NSString = ""
    var str_Owner_Description : NSString = ""
    
}

class ReviewObjet: NSObject {
    var str_Reviewrid : NSString = ""
    var str_ReviewUserName : NSString = ""
    var str_ReviewUserImage : NSString = ""
    var str_ReviewDate : NSString = ""
    var str_ReviewDescription : NSString = ""
    var str_ReviewStar: NSString = ""
    var str_ReviewUserComment : NSString = ""
    var str_ReviewUserType : NSString = ""
    var str_Thumb_Image : NSString = ""
    var str_ReviewUseful : NSString = ""
    var str_ReviewFunny : NSString = ""
    var str_ReviewCool : NSString = ""
    var str_ReviewUsefulCount : NSString = ""
    var str_ReviewFunnyCount : NSString = ""
    var str_ReviewCoolCount : NSString = ""
    var str_QuickBoxId : NSString = ""
    var str_Category_name : NSString = ""
    
    var str_imageName: NSString = ""
    var str_imageshop_id: NSString = ""
    var str_imageuser_id: NSString = ""
    var str_Product_id: NSString = ""
    var str_Product_Name: NSString = ""
    var str_Product_Image: NSString = ""
    
    var arr_Images : NSMutableArray = []
    
    //User uloaded Imaage and video
    var str_UserUpload_ReviewUserComment: NSString = ""
    var str_UserUpload_ReviewUserImage: NSString = ""
    var str_UserUpload_ReviewUserType: NSString = ""
    var str_UserUpload_Thumb_Image: NSString = ""
    var arr_UserUpload_Image : NSMutableArray = []
    
}

class AboutObject: NSObject {
    var str_Image : NSString = ""
}

class ShopMember: NSObject {
    var str_Name : NSString = ""
    var str_Position : NSString = ""
    var str_Description : NSString = ""
    var str_Picture : NSString = ""
}


// MARK: - Tableview Files -
extension ShopViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tbl_Main {
            return 2
        }else if tableView == tbl_About{
            return 3
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tbl_Main {
            if section == 0 {
                return 0
            } else if section == 1 {
                return 80
            }
        }else if tableView == tbl_About {

            switch section {
                case 1:
                    return 80
                case 2:
                    return 80
                default:
                    return 0
                
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl_Main {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    //This for Detail of product cell
                    return UITableView.automaticDimension
                default:
                    return 0
                }
            } else if indexPath.section == 1 {
                if arr_SortProduct.count == 0 {
                    return CGFloat(Int(Constant.windowHeight - 125))
                }else{
                    return CGFloat(((tableView.frame.size.width/2)*200)/175)
                }
            }
        } else if tableView == tbl_Review {
            
            return UITableView.automaticDimension
        }else if tableView == tbl_About {
            //First section for detail and share feature
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    return UITableView.automaticDimension
                case 1:
                    return 45
                default:
                    return 0
                }
            }else if indexPath.section == 1 {
                if indexPath.row == 0{
                    return 60
                }else{
                    return 40
                }
                //Section for Relating Links
            }else if indexPath.section == 2 {
                //Section for Relating Links
//                return UITableViewAutomaticDimension
                return 60
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
         if tableView == tbl_Main {
            if indexPath.section == 0 {
                
                switch indexPath.row {
                case 0:
                    //This for Detail of product cell
                    return 35

                default:
                    return 0
                }
            } else if indexPath.section == 1 {
                if arr_SortProduct.count == 0 {
                    return CGFloat(Int(Constant.windowHeight - 125))
                }else{
//                    return CGFloat(((tableView.frame.size.width/2)*200)/175)
                    return 60
                }
            }
         } else if tableView == tbl_Review {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == tbl_Main {
            if section == 0 {
                return 2
            }else{
                if arr_SortProduct.count == 0 {
                    return 1
                }else{
                    let int_Count : Int = Int(arr_SortProduct.count/2)
                    if arr_SortProduct.count % 2 != 0 {
                        return int_Count+1
                    }
                    return int_Count
                }
            }
         } else if tableView == tbl_Review {
            if bool_Load == false && arr_Reviews.count == 0 {
                return 1;
            }
            
            return arr_Reviews.count;
         } else if tableView == tbl_About {
            //First section for detail and share feature
            if section == 0 {
                return 2;
            }else if section == 1 {
                //Section for Relating Links
                return 4;
            }else if section == 2 {
                //Section for Owner and shop members
                
                if objShopDetailData.arr_OwnerMember.count != 0 {
                    return objShopDetailData.arr_OwnerMember.count
                }
                
                return 0
            }

         }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tbl_Main {
            let cell = tableView.dequeueReusableCell(withIdentifier: "section")as! ShopTableviewCell
            
            cell.lbl_Title_Section.text = "Sort"
            
            cell.tf_Search.delegate = self
            btn_CancelSearch_Main = cell.btn_CancelSearch
            cell.btn_CancelSearch.addTarget(self, action: #selector(self.btn_CancelSearch(_:)), for:.touchUpInside)
            if tf_Search_Main == nil {
                tf_Search_Main = cell.tf_Search
            }else{
                cell.tf_Search.text = tf_Search_Main.text
                tf_Search_Main = cell.tf_Search
            }
            cell.tf_Search.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
            cell.btn_Filter_Section.addTarget(self, action: #selector(self.btn_Filter_Section(_:)), for:.touchUpInside)
            if (btn_Filter_Section_Save == nil){
                btn_Filter_Section_Save = cell.btn_Filter_Section
            }else{
                cell.btn_Filter_Section.setTitle(btn_Filter_Section_Save.titleLabel?.text,for: .normal)
                
            }
            
            //Layer declaration
            cell.vw_SearchBar.layer.cornerRadius = 5
            cell.vw_SearchBar.layer.borderColor = UIColor.darkGray.cgColor
            cell.vw_SearchBar.layer.borderWidth = 0.5
            cell.vw_SearchBar.layer.masksToBounds = true
            
            return cell;
        }else if tableView == tbl_About {
            let cell = tableView.dequeueReusableCell(withIdentifier: "section")as! AboutTableviewCell
            
            switch section {
            case 1:
                cell.lbl_Title_Section_RelatedLink.text = "Related Links"
                break
            case 2:
                cell.lbl_Title_Section_RelatedLink.text = "Owner"
                break
            default:
                break
            }
            cell.backgroundColor = UIColor.white
            
            return cell;
        }else {
            return nil;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_Main {
            var str_CellIdentifier : NSString = "cell"
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    //This for Detail of product cell
                    str_CellIdentifier = "detail"
                    break
                default:
                    break
                }
            }else if indexPath.section == 1{
                if arr_SortProduct.count == 0 {
                    str_CellIdentifier = "nodata"
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: str_CellIdentifier as String, for:indexPath as IndexPath) as! ShopTableviewCell
            
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    //This for Detail of product cell
//                    cell.lbl_Title_PoductDetailCell.text = objShopDetailData.str_Shop_Description as String
                    cell.lbl_Title_PoductDetailCell.text = ""
                    break
                default:
                    break
                }
            } else if indexPath.section == 1 {
                
                if arr_SortProduct.count == 0 {
                    
                }else{
                    cell.vw_Back_2.isHidden = false
                    
                    let obj : HomeObject = arr_SortProduct[indexPath.row*2] as! HomeObject
                    var obj2  = HomeObject ()
                    if ((indexPath.row * 2)+1) < arr_SortProduct.count{
                        obj2 = arr_SortProduct[(indexPath.row*2)+1] as! HomeObject
                    }else{
                        cell.vw_Back_2.isHidden = true
                    }
                    
                    cell.lbl_Title_1.text = obj.str_Title_OtherTab as String
                    cell.lbl_Title_2.text = obj2.str_Title_OtherTab as String
                    cell.lbl_Prize_1.text = "\(obj.str_PriceSymbol as String)\(obj.str_Prize_OtherTab as String)"
                    cell.lbl_Prize_2.text = "\(obj.str_PriceSymbol as String)\(obj2.str_Prize_OtherTab as String)"
                    cell.lbl_SubTitle_1.text = obj.str_Product_CateogryName as String
                    cell.lbl_SubTitle_2.text = obj2.str_Product_CateogryName as String
                    
                    let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
                    let arr_Images2 : NSMutableArray = obj2.arrImage_OtherTab;
                    
                    if arr_Images.count != 0 {
                        let obj2 : HomeObject = arr_Images[0] as! HomeObject
                        cell.img_Image_1.sd_setImage(with: URL(string: obj2.str_Image_OtherTab as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                    }
                    if arr_Images2.count != 0 {
                        let obj2 : HomeObject = arr_Images2[0] as! HomeObject
                        cell.img_Image_2.sd_setImage(with: URL(string: obj2.str_Image_OtherTab as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                    }
                    
                    cell.btn_ProductDetail.tag = indexPath.row*2
                    cell.btn_ProductDetail2.tag = (indexPath.row*2)+1
                    
                    cell.btn_ProductDetail.addTarget(self, action: #selector(self.btn_ProductClick(_:)), for:.touchUpInside)
                    cell.btn_ProductDetail2.addTarget(self, action: #selector(self.btn_ProductClick(_:)), for:.touchUpInside)
                    
                    //Layer set
                    cell.vw_Back_1.layer.cornerRadius = 5.0
                    cell.vw_Back_1.layer.masksToBounds = true
                    cell.vw_Back_2.layer.cornerRadius = 5.0
                    cell.vw_Back_2.layer.masksToBounds = true
                }
            }
            
            return cell

        }
        else if(tableView == tbl_Review ) {
            
            var str_CellIdentifier : NSString = "reviewCell"
            if  arr_Reviews.count == 0 {
                str_CellIdentifier = "nodata"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: str_CellIdentifier as String, for:indexPath as IndexPath) as! ReviewTableviewCell

            if  arr_Reviews.count != 0 {
                
                cell.selectionStyle = .none;
                let objReview:ReviewObjet = arr_Reviews[indexPath.row] as! ReviewObjet
                
                cell.lbl_ReviewBy.text = objReview.str_ReviewUserName as String
                cell.lbl_ReviewDate.text = localDateToStrignDate2(date : objReview.str_ReviewDate as String)
                cell.lbl_ReviewDescription.text = objReview.str_ReviewDescription as String
                cell.lbl_ProductName.text = objReview.str_Product_Name as String
                cell.imgView_ReviewUserPhoto.sd_setImage(with: URL(string: objReview.str_ReviewUserImage as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                
                let arr_Images : NSMutableArray = objReview.arr_Images;
                
                if arr_Images.count != 0 {
                    let obj2 : ReviewObjet = arr_Images[0] as! ReviewObjet
                    cell.img_Product.sd_setImage(with: URL(string: obj2.str_Product_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                }
                
                
                cell.imgView_ReviewUserPhoto.layoutIfNeeded()
                cell.imgView_ReviewUserPhoto.layer.cornerRadius = cell.imgView_ReviewUserPhoto.frame.size.width/2;
                cell.imgView_ReviewUserPhoto.layer.masksToBounds = true
                
                //Mange Relating
                cell.rate_UserRate.rating = Double(objReview.str_ReviewStar as String)!
                
                //Product Button
                cell.btn_Product.tag = indexPath.row
                cell.btn_Product.addTarget(self, action: #selector(self.btn_ProductDetailReview(_:)), for:.touchUpInside)
                
                //Product Button
                cell.btn_Click.tag = indexPath.row
                cell.btn_Click.addTarget(self, action: #selector(self.btn_ClickMessage(_:)), for:.touchUpInside)
                
            }
            
            return cell
        }
        else if(tableView == tbl_About ) {
            
            var str_CellIdentifier : NSString = "aboutdetail"

            //First section for detail and share feature
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    str_CellIdentifier = "aboutdetail"
                    break
                case 1:
                    str_CellIdentifier = "share"
                    break
                default:
                    str_CellIdentifier = "aboutdetail"
                    break
                }
            }else if indexPath.section == 1 {
                if indexPath.row == 0{
                    str_CellIdentifier = "webrelatedlinks"
                }else{
                    str_CellIdentifier = "relatedlinks"
                }
                
            }else if indexPath.section == 2 {
                str_CellIdentifier = "owneranshop"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: str_CellIdentifier as String, for:indexPath as IndexPath) as! AboutTableviewCell
            
            //First section for detail and share feature
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    
                    cell.lblMon.text = ""
                    cell.lblMonTime.text = ""

                    
                    cell.LblTus.text = ""
                    cell.lblTusTime.text = ""

                    cell.lblWen.text = ""
                    cell.lblWenTime.text = ""

                    cell.lblThur.text = ""
                    cell.lblThuTimer.text = ""

                    cell.lblFir.text = ""
                    cell.lblFirTime.text = ""

                    cell.lblSat.text = ""
                    cell.lblSatTime.text = ""

                    cell.lblSun.text = ""
                    cell.lblSunTime.text = ""

                    
                    
                    print(objShopDetailData.str_Shop_Open_Hr)
                    let str = objShopDetailData.str_Shop_Open_Hr as String
                    if str != ""{
                        var arr = Array(objShopDetailData.str_Shop_Open_Hr as String)
                        
                        var arr2 = convertString(toDictionary: objShopDetailData.str_Shop_Open_Hr as String)
                        
                        var arr_Mutable : NSArray = arr2 as! NSArray
                        var str_Time : String = ""
                        for i in 0..<arr_Mutable.count{
                            let dic = arr_Mutable[i] as! NSDictionary
                            print(dic)
                            let strDay = dic["day"] as! String
                            let isOpen = dic["start_time"] as! String
                            
                            //GET SATRT TIME
                            var strStartTime = dic["start_time"] as! String
                            if isOpen != "Closed"{
                                //GET FIRST TO CHARACTER IN STRING
                                let Start = strStartTime.prefix(2)
                                let StartTime:Int? = Int(Start)
                                if StartTime! < 10{
                                    //REMOVE FIRST CHARACTER IN STRING
                                    strStartTime.remove(at: strStartTime.startIndex)
                                }
                            }
                            
                            //GET END TIME
                            var strEndTime = dic["end_time"] as! String
                            if isOpen != "Closed"{
                                //GET FIRST TO CHARACTER IN STRING
                                let End = strEndTime.prefix(2)
                                let EndTime:Int? = Int(End)
                                if EndTime! < 10{
                                    //REMOVE FIRST CHARACTER IN STRING
                                    strEndTime.remove(at: strEndTime.startIndex)
                                }
                            }
                            
                            
                            //SET TIME IN LOWERCASE
                            var strTime :String = ""
                            if isOpen == "Closed"{
                                strTime = isOpen
                            }
                            else{
                                strTime = strStartTime + " - " + strEndTime
                            }
                            
                            if strDay == "Mon" {
                                //SET TIME
                                cell.lblMon.text = "Monday"
                                cell.lblMonTime.text = strTime.lowercased()
                                
                                if isOpen == "Closed"{
                                    //SET TILE FONT
                                    cell.lblMon.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblMonTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                                else{
                                    //SET TILE FONT
                                    cell.lblMon.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblMonTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                            }
                            else if strDay == "Tue" {
                                //SET TIME
                                cell.LblTus.text = "Tuesday"
                                cell.lblTusTime.text = strTime.lowercased()
                                if isOpen == "Closed"{
                                    //SET TILE FONT
                                    cell.LblTus.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblTusTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                                else{
                                    //SET TILE FONT
                                    cell.LblTus.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblTusTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                            }
                            else if strDay == "Wed" {
                                //SET TIME
                                cell.lblWen.text = "Wednesday"
                                cell.lblWenTime.text = strTime.lowercased()
                                if isOpen == "Closed"{
                                    //SET TILE FONT
                                    cell.lblWen.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblWenTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                                else{
                                    //SET TILE FONT
                                    cell.lblWen.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblWenTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                            }
                            else if strDay == "Thu" {
                                //SET TIME
                                cell.lblThur.text = "Thursday"
                                cell.lblThuTimer.text = strTime.lowercased()
                                if isOpen == "Closed"{
                                    //SET TILE FONT
                                    cell.lblThur.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblThuTimer.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                                else{
                                    //SET TILE FONT
                                    cell.lblThur.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblThuTimer.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                            }
                            else if strDay == "Fri" {
                                //SET TIME
                                cell.lblFir.text = "Friday"
                                cell.lblFirTime.text = strTime.lowercased()
                                if isOpen == "Closed"{
                                    //SET TILE FONT
                                    cell.lblFir.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblFirTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                                else{
                                    //SET TILE FONT
                                    cell.lblFir.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblFirTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                            }
                            else if strDay == "Sat" {
                                //SET TIME
                                cell.lblSat.text = "Saturday"
                                cell.lblSatTime.text = strTime.lowercased()
                                if isOpen == "Closed"{
                                    //SET TILE FONT
                                    cell.lblSat.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblSatTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                                else{
                                    //SET TILE FONT
                                    cell.lblSat.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblSatTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                            }
                            else if strDay == "Sun" {
                                //SET TIME
                                cell.lblSun.text = "Sunday"
                                cell.lblSunTime.text = strTime.lowercased()
                                if isOpen == "Closed"{
                                    //SET TILE FONT
                                    cell.lblSun.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblSunTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                                else{
                                    //SET TILE FONT
                                    cell.lblSun.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                    cell.lblSunTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                                }
                            }
                        }
                        
                        
                        
                        
                    }
                    
                    
            
                    
                        cell.lbl_Title.text = objShopDetailData.str_Shop_Title as String
//                        cell.lbl_Time.text = objShopDetailData.str_Shop_Open_Hr as String
                        cell.lbl_Description.text = objShopDetailData.str_Shop_Description as String
                        
                    break
                case 1:
                        //Layer set
                        cell.vw_Favorite_Share.layer.cornerRadius = 5
                        cell.vw_Favorite_Share.layer.borderWidth = 1
                        cell.vw_Favorite_Share.layer.borderColor = UIColor.lightGray.cgColor
                        cell.vw_Favorite_Share.layer.masksToBounds = true
                        
                        cell.vw_Share_Share.layer.cornerRadius = 5
                        cell.vw_Share_Share.layer.borderWidth = 1
                        cell.vw_Share_Share.layer.borderColor = UIColor.lightGray.cgColor
                        cell.vw_Share_Share.layer.masksToBounds = true
                        
                        cell.vw_Contact_Share.layer.cornerRadius = 5
                        cell.vw_Contact_Share.layer.borderWidth = 1
                        cell.vw_Contact_Share.layer.borderColor = UIColor.lightGray.cgColor
                        cell.vw_Contact_Share.layer.masksToBounds = true
                        
                        if btn_Favorite.isSelected == true {
                            cell.img_Fav_Share.image = UIImage.init(named: "icon_Save_Shop_Selected")
                        }else{
                            cell.img_Fav_Share.image = UIImage.init(named: "icon_Save_Shop")
                        }
                        img_Fav_Share_About = cell.img_Fav_Share

                        cell.btn_ClickFavorite_Share.addTarget(self, action: #selector(self.btn_Favorite(_:)), for:.touchUpInside)
                        cell.btn_ClickShare_Share.addTarget(self, action: #selector(self.btn_Share_About(_:)), for:.touchUpInside)
                        cell.btn_ClickContact_Share.addTarget(self, action: #selector(self.btn_Share_Contact(_:)), for:.touchUpInside)

                    break
                default:
                    
                    break
                }
            }else if indexPath.section == 1 {
                cell.lbl_Title_Share_RelatedLink.textColor = UIColor.black
                cell.img_Next.isHidden = false
                imgColor(imgColor: cell.img_Icon_RelatedLink, colorHex: "000000")
                switch indexPath.row {
                case 0:
                    cell.lbl_Title_Share_RelatedLink.text = "Website"
                    cell.img_Icon_RelatedLink.image = UIImage.init(named: "icon_Website_Shop")
                    cell.lbl_webLink.text = objShopDetailData.str_Shop_Website as String
                    if objShopDetailData.str_Shop_Website == ""{
                        cell.lbl_Title_Share_RelatedLink.textColor = UIColor.lightGray
                        cell.img_Next.isHidden = true
                        imgColor(imgColor: cell.img_Icon_RelatedLink, colorHex: "9a9a9a")
                    }
                  
                    break
                case 1:
                    cell.lbl_Title_Share_RelatedLink.text = "Twitter"
                    cell.img_Icon_RelatedLink.image = UIImage.init(named: "icon_Twitter_Shop")
                    if objShopDetailData.str_Shop_Twitter == ""{
                        cell.lbl_Title_Share_RelatedLink.textColor = UIColor.lightGray
                        cell.img_Next.isHidden = true
                        imgColor(imgColor: cell.img_Icon_RelatedLink, colorHex: "9a9a9a")
                    }
                  
                    break
                case 2:
                    cell.lbl_Title_Share_RelatedLink.text = "Facebook"
                    cell.img_Icon_RelatedLink.image = UIImage.init(named: "icon_Facebook_Shop")
                    if objShopDetailData.str_Shop_FBlink == ""{
                        cell.lbl_Title_Share_RelatedLink.textColor = UIColor.lightGray
                        cell.img_Next.isHidden = true
                        cell.img_Icon_RelatedLink.image = UIImage.init(named: "icon_Facebook_light")
                    }
                    break
                case 3:
                    cell.lbl_Title_Share_RelatedLink.text = "Instagram"
                    cell.img_Icon_RelatedLink.image = UIImage.init(named: "ic_Instagram_shop")
                    if objShopDetailData.str_Shop_Instalink == ""{
                        cell.lbl_Title_Share_RelatedLink.textColor = UIColor.lightGray
                        cell.img_Next.isHidden = true
                        imgColor(imgColor: cell.img_Icon_RelatedLink, colorHex: "9a9a9a")
                    }
                    
                    break
                default:
                    break
                    
                }
            }else if indexPath.section == 2 {
                let arr_Image : NSMutableArray = objShopDetailData.arr_OwnerMember
                
                let obj : ShopObject = arr_Image[indexPath.row] as! ShopObject
                
                cell.lbl_Title_Owner.text = obj.str_Owner_Name as String
                cell.lbl_Detail_Owner.text =  obj.str_Owner_Position as String
                cell.lbl_Description_Owner.text = obj.str_Owner_Description as String
                
                cell.img_Profile_Owner.sd_setImage(with: URL(string: obj.str_Owner_Images as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                
                //Layer set
                cell.img_Profile_Owner.layer.cornerRadius = cell.img_Profile_Owner.frame.size.height/2
                cell.img_Profile_Owner.layer.masksToBounds = true
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutdetail" as String, for:indexPath as IndexPath) as! AboutTableviewCell
            
            return cell
        }
    }
        func convertString(toDictionary str: String?) -> [Any]? {
            var jsonError: Error?
            let objectData: Data? = str?.data(using: .utf8)
            var json: [Any]? = nil
            if let aData = objectData {
                json = try! JSONSerialization.jsonObject(with: aData, options: .mutableContainers) as? [Any]
            }
            return json
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tbl_About ) {
            if indexPath.section == 1 {
                switch indexPath.row {
                case 0:
                    //Open url
                    if let url = URL(string: objShopDetailData.str_Shop_Website as String) {
                        if UIApplication.shared.canOpenURL(url) {
                            openURLToWeb(url : url)
                        }
                        else{
                            messageBar.MessageShow(title: "Invalid URL", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                        }
                    }
                    break
                case 1:
                    if let url = URL(string: objShopDetailData.str_Shop_Twitter as String) {
                        if UIApplication.shared.canOpenURL(url) {
                            openURLToWeb(url : url)
                        }
                        else{
                            messageBar.MessageShow(title: "Invalid URL", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                        }
                    }
                    break
                case 2:
                    if let url = URL(string: objShopDetailData.str_Shop_FBlink as String) {
                        if UIApplication.shared.canOpenURL(url) {
                            openURLToWeb(url : url)
                        }
                        else{
                            messageBar.MessageShow(title: "Invalid  URL", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                        }
                    }
                    break
                case 3:
                    if let url = URL(string: objShopDetailData.str_Shop_Instalink as String) {
                        if UIApplication.shared.canOpenURL(url) {
                            openURLToWeb(url : url)
                        }
                        else{
                            messageBar.MessageShow(title: "Invalid URL", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                        }
                    }
                    break
                default:
                    break
                    
                }
            }
        }else if(tableView == tbl_Review ) {
            if arr_Reviews.count != 0 {
                let objHere : ReviewObjet = arr_Reviews[indexPath.row] as! ReviewObjet
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "ReviewDetailViewController") as! ReviewDetailViewController
                view.getObject = objHere
                self.navigationController?.pushViewController(view, animated: false)
                
            }
            
        }
    }
}

//MARK: - Tableview View Cell -
class ShopTableviewCell : UITableViewCell{
    //Product Detail cell
    @IBOutlet weak var lbl_Title_PoductDetailCell: UILabel!
    
    //Search Controller
    @IBOutlet weak var sb_Main : UISearchBar!
    
    //Product Listing Here
    @IBOutlet weak var lbl_Title_1 : UILabel!
    @IBOutlet weak var lbl_SubTitle_1 : UILabel!
    @IBOutlet weak var lbl_Prize_1 : UILabel!
    @IBOutlet weak var img_Image_1 : UIImageView!
    @IBOutlet weak var vw_Back_1 : UIView!
    @IBOutlet weak var lbl_Title_2 : UILabel!
    @IBOutlet weak var lbl_SubTitle_2 : UILabel!
    @IBOutlet weak var lbl_Prize_2 : UILabel!
    @IBOutlet weak var img_Image_2 : UIImageView!
    @IBOutlet weak var vw_Back_2 : UIView!
    
    
    @IBOutlet weak var lbl_Title_Section : UILabel!
    @IBOutlet weak var btn_ProductDetail : UIButton!
    @IBOutlet weak var btn_ProductDetail2 : UIButton!
    @IBOutlet weak var btn_CancelSearch : UIButton!
    @IBOutlet weak var btn_Filter_Section : UIButton!
    
    //Search Bar Declartion
    @IBOutlet weak var tf_Search : UITextField!
    @IBOutlet weak var vw_SearchBar : UIView!
    
}

//Review Cell
class ReviewTableviewCell: UITableViewCell {
    @IBOutlet weak var lbl_ReviewBy : UILabel!
    @IBOutlet weak var lbl_ReviewDate : UILabel!
    @IBOutlet weak var lbl_ReviewDescription : UILabel!
    @IBOutlet weak var lbl_ProductName : UILabel!
    @IBOutlet weak var lbl_TotalReview : UILabel!
    
    @IBOutlet weak var imgView_ReviewUserPhoto : UIImageView!
    @IBOutlet weak var img_Product : UIImageView!
    
    @IBOutlet var rate_UserRate: CosmosView!
    
    @IBOutlet var btn_Product: UIButton!
    @IBOutlet var btn_Click: UIButton!
}

class AboutTableviewCell: UITableViewCell {
    //Cell for aboutdetail
    @IBOutlet weak var lbl_Title:UILabel!
    @IBOutlet weak var lbl_Time:UILabel!
    @IBOutlet weak var lbl_Description:UILabel!
    
    //DECLARATION TIME LABEL
    @IBOutlet var lblMon: UILabel!
    @IBOutlet var LblTus: UILabel!
    @IBOutlet var lblWen: UILabel!
    @IBOutlet var lblThur: UILabel!
    @IBOutlet var lblFir: UILabel!
    @IBOutlet var lblSat: UILabel!
    @IBOutlet var lblSun: UILabel!
    @IBOutlet var lblMonTime: UILabel!
    @IBOutlet var lblTusTime: UILabel!
    @IBOutlet var lblWenTime: UILabel!
    @IBOutlet var lblThuTimer: UILabel!
    @IBOutlet var lblFirTime: UILabel!
    @IBOutlet var lblSatTime: UILabel!
    @IBOutlet var lblSunTime: UILabel!
    

    
    
    //Cell for share function
    @IBOutlet weak var vw_Favorite_Share:UIView!
    @IBOutlet weak var vw_Share_Share:UIView!
    @IBOutlet weak var vw_Contact_Share:UIView!
    @IBOutlet weak var lbl_ShareShop_Share:UILabel!
    @IBOutlet weak var lbl_Share_Share:UILabel!
    @IBOutlet weak var lbl_Contact_Share:UILabel!
    @IBOutlet weak var btn_ClickFavorite_Share:UIButton!
    @IBOutlet weak var btn_ClickShare_Share:UIButton!
    @IBOutlet weak var btn_ClickContact_Share:UIButton!
    @IBOutlet weak var img_Fav_Share:UIImageView!

    //Cell for Related Links
    @IBOutlet weak var lbl_Title_Section_RelatedLink:UILabel!
    @IBOutlet weak var lbl_Title_Share_RelatedLink:UILabel!
    @IBOutlet weak var img_Icon_RelatedLink:UIImageView!
    @IBOutlet weak var lbl_webLink:UILabel!
    @IBOutlet weak var img_Next:UIImageView!

    //Cell for Owner and shop members
    @IBOutlet weak var img_Profile_Owner:UIImageView!
    @IBOutlet weak var lbl_Title_Owner:UILabel!
    @IBOutlet weak var lbl_Detail_Owner:UILabel!
    @IBOutlet weak var lbl_Description_Owner:UILabel!
}



//MARK: - Collection View -
extension ShopViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returen number of cell with content available in array
        if cv_AboutusHeader == collectionView {
//            pg_Header.numberOfPages = arr_AboutUs.count
//            return arr_AboutUs.count
            
            if objShopDetailData.arr_Image.count != 0 {
                pg_Header.numberOfPages = objShopDetailData.arr_Image.count
                return objShopDetailData.arr_Image.count
            }
            return 1
        }
        
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Returen number of cell with content available in array
        if cv_AboutusHeader == collectionView {
            //This box for array in tableview cell
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShopviewCollectionViewCell
        
        if cv_AboutusHeader == collectionView {
           
            if objShopDetailData.arr_Image.count != 0 {
                //Get data in NSObject
                let arr_Image : NSMutableArray = objShopDetailData.arr_Image
                
                let obj : ShopObject = arr_Image[indexPath.row] as! ShopObject
                
                //Set image in header
                cell.img_Main.sd_setImage(with: URL(string: obj.str_Shop_Images as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                
                
                
            }else{
                
                //Set image in header
                cell.img_Main.image = UIImage(named:Constant.placeHolder_Comman)!
                
            }
            
           
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if objShopDetailData.arr_Image.count != 0 {
            //Create arr for Slide image post to FTImageviewer
            var imageArray : [String] = []
            let arr_Image : NSMutableArray = objShopDetailData.arr_Image
            for i in 0...arr_Image.count-1{
                let obj : ShopObject = arr_Image[i] as! ShopObject
                imageArray += [obj.str_Shop_Images as String]
            }
            
            //Create arr for frame with all images position
            var views = [UIView]()
            for _ in 0...arr_Image.count-1 {
                views.append(cv_AboutusHeader)
            }
            
            //Call method present imageviewer
            FTImageViewer.showImages(imageArray, atIndex: indexPath.row, fromSenderArray: views)
        }
    }
}



//MARK: - Collection View Cell -
class ShopviewCollectionViewCell : UICollectionViewCell{
    //Cell for tab view in about us tab
    @IBOutlet weak var img_Main: UIImageView!
    
}



extension ShopViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        self.completedServiceCalling()
        tbl_Main.isHidden = false
        
        let response = data as! NSDictionary
        if strRequest == "get_shop_details" {
            
            //Product detail
            let arr_result = response["Result"] as! NSArray
            let dict_Product = arr_result[0] as! NSDictionary
            let arr_Image = dict_Product["shop_images"] as! NSArray
            var arr_Owner : NSArray = []
            let dict_Owner = dict_Product["owner"] as! NSDictionary
            
            if (dict_Product["ShopMember"] != nil){
                arr_Owner = dict_Product["ShopMember"] as! NSArray
            }
            
            //Store data into object
            let obj = ShopObject ()
            obj.str_Shop_Id = ("\(dict_Product["shop_id"] as! Int)" as NSString)
            obj.str_Shop_Name = dict_Product["shop_name"] as! NSString
            obj.str_Shop_Title = dict_Product["shop_title"] as! NSString
            obj.str_Shop_Open_Hr = dict_Product["open_hrs"] as! NSString
            obj.str_Shop_Description = dict_Product["shop_description"] as! NSString
            obj.str_Shop_Location = dict_Product["shop_location"] as! NSString
            obj.str_Shop_Lat = dict_Product["shop_lat"] as! NSString
            obj.str_Shop_Long = dict_Product["shop_long"] as! NSString
            obj.str_Shop_Logo = dict_Product["shop_logo"] as! NSString
            obj.str_Shop_BG = dict_Product["shop_background"] as! NSString
            obj.str_Shop_Email = dict_Product["shop_email"] as! NSString
            obj.str_Shop_Website = dict_Product["website"] as! NSString
            obj.str_Shop_Twitter = dict_Product["twitter"] as! NSString
            obj.str_Shop_FBlink = dict_Product["fblink"] as! NSString
            obj.str_Shop_Instalink = dict_Product["instagram"] as! NSString
            obj.str_Shop_Favotite = dict_Product["is_shop_favourite"] as! NSString
            obj.str_Shop_Policy = (dict_Product["Policy"] != nil) ? (dict_Product["Policy"] as! NSString) : ""
            obj.str_Shop_More = (dict_Product["More"] != nil) ? dict_Product["More"] as! NSString : ""
            obj.str_Shop_PolicyDate = (dict_Product["PolicyDate"] != nil) ? dict_Product["PolicyDate"] as! NSString : ""
            obj.str_Shop_MoreDate = (dict_Product["MoreDate"] != nil) ? dict_Product["MoreDate"] as! NSString : ""
            obj.str_Shop_TotalReview = (dict_Product["TotalReview"] != nil) ? dict_Product["TotalReview"] as! NSString : ""
            obj.str_Shop_AvgReview = (dict_Product["AvgReview"] != nil) ? dict_Product["AvgReview"] as! NSString : ""
            
            //Product Image
            let arr_TempImage : NSMutableArray = []
            for i in (0..<arr_Image.count) {
                let dict_ImageData = arr_Image[i] as! NSDictionary
                
                //Other Tab Demo data
                let objImage = ShopObject ()
                objImage.str_Shop_Images = dict_ImageData["image"] as! NSString
                
                arr_TempImage.add(objImage)
            }
            
            //Product Owner
            let arr_TempOwner : NSMutableArray = []
            
            //Other Tab Demo data
            let objImage = ShopObject ()
            objImage.str_Owner_Images = dict_Owner["profile_image"] as! NSString
            objImage.str_Owner_Name = "\(dict_Owner["firstname"] as! NSString) \(dict_Owner["lastname"] as! NSString)" as NSString
            objImage.str_Owner_Position = ""
            objImage.str_Owner_Description = ""
            arr_TempOwner.add(objImage)
            
            
            obj.arr_Image = arr_TempImage
            obj.arr_OwnerMember = arr_TempOwner
            
            objShopDetailData = obj
            
            self.relaodDataView()
            self.manageDataFill()
            
            //calling service for shop product listing
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            self.Get_ShopProduct(count:int_CountLoad)
            
        }else if strRequest == "addremove_favourite" {
            
        }else if strRequest == "get_shop_products" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            let arr_StoreTemp : NSMutableArray = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                //Other Tab Demo data
                let obj = HomeObject ()
                obj.str_ID_OtherTab = ("\(dict_Data["product_id"] as! Int)" as NSString)
                obj.str_Title_OtherTab = dict_Data["p_title"] as! String as NSString
                obj.str_SubTitle_OtherTab = dict_Data["p_descriiption"] as! String as NSString
                obj.str_Prize_OtherTab = dict_Data.getStringForID(key:"price")! as NSString
                obj.str_DiscountPrize_OtherTab = dict_Data.getStringForID(key:"discount_price")! as NSString
                obj.str_Site_OtherTab = dict_Data["site"] as! String as NSString
                obj.str_Fav_OtherTab = ("\(dict_Data["is_favourite"] as! Int)" as NSString)
                obj.str_Product_CateogryName = dict_Data["categoryname"] as! String as NSString
                obj.str_PriceSymbol = dict_Data["price_symbole"] as! NSString
                
                //Image Array
                let arr_Image = dict_Data["product_images"] as! NSArray
                let arr_Image_Store : NSMutableArray = []
                for j in (0..<arr_Image.count){
                    let dict_DataOther = arr_Image[j] as! NSDictionary
                    
                    let obj1 = HomeObject ()
                    obj1.str_Image_OtherTab = dict_DataOther.getStringForID(key:"image")! as NSString 
                    
                    arr_Image_Store.add(obj1)
                }
                
                obj.arrImage_OtherTab = arr_Image_Store
                
                arr_StoreTemp.add(obj)
            }
            
            
            //Refresh code
            if bool_ViewWill == true {
                arr_SortProduct = []
                int_CountLoad_Feature = arr_StoreTemp.count
            }else{
                int_CountLoad_Feature = int_CountLoad_Feature + arr_StoreTemp.count
            }
            
            for i in (0...arr_StoreTemp.count-1){
//                if arr_SortProduct.count == 0 {
                    arr_SortProduct.add(arr_StoreTemp[i])
//                }
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
            
            bool_ViewWill = false
            self.relaodDataView()
        }else if strRequest == "get_shop_reviews" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            let arr_StoreTemp : NSMutableArray = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                let objReview = ReviewObjet()
                objReview.str_Reviewrid = ("\(dict_Data["rid"] as! Int)" as NSString)
                objReview.str_ReviewDate = dict_Data["datetime"] as! String as NSString
                objReview.str_ReviewUserName = dict_Data["name"] as! String as NSString
                objReview.str_ReviewUserImage = dict_Data["profile_image"] as! String as NSString
                objReview.str_QuickBoxId = dict_Data["quickblox_id"] as! String as NSString
                
                objReview.str_ReviewDescription = dict_Data["review"] as! String as NSString
                objReview.str_ReviewStar = dict_Data["rate"] as! String as NSString
                objReview.str_imageshop_id = ("\(dict_Data["shop_id"] as! Int)" as NSString)
                objReview.str_imageuser_id = ("\(dict_Data["userid"] as! Int)" as NSString)
                objReview.str_Product_id = ("\(dict_Data["product_id"] as! Int)" as NSString)
                objReview.str_Product_Name = dict_Data["product_name"] as! String as NSString
                objReview.str_ReviewUseful = ("\(dict_Data["is_useful"] as! Int)" as NSString)
                objReview.str_ReviewFunny = ("\(dict_Data["is_funny"] as! Int)" as NSString)
                objReview.str_ReviewCool = ("\(dict_Data["is_cool"] as! Int)" as NSString)
                objReview.str_ReviewUsefulCount = ("\(dict_Data["useful"] as! Int)" as NSString)
                objReview.str_ReviewFunnyCount = ("\(dict_Data["funny"] as! Int)" as NSString)
                objReview.str_ReviewCoolCount = ("\(dict_Data["cool"] as! Int)" as NSString)
                
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
            self.relaodDataView()
    
        }else if strRequest == "add_recent_view_shop" {
            
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
        self.completedServiceCalling()
    }
    
}


//func stringFromHTML( string: String?) -> String
//{
//    do{
//        let str = try NSAttributedString(data:string!.data(usingEncoding: NSUTF8StringEncoding, allowLossyConversion: true
//            )!, options:[NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSNumber(unsignedLong: NSUTF8StringEncoding.rawValue)], documentAttributes: nil)
//        return str.string
//    } catch
//    {
//        print("html error\n",error)
//    }
//    return ""
//}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}

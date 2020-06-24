//
//  BusinessDetailViewController.swift
//  Katika
//
//  Created by Katika on 24/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import FTImageViewer
import FRHyperLabel
import MIBadgeButton_Swift
import AVFoundation
import AVKit
import SwiftMessages
import MessageUI
import MapKit
import Cosmos

class BusinessDetailViewController: UIViewController,MKMapViewDelegate{
    
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    //Label Declaration
    @IBOutlet var lbl_ShopTitle: UILabel!
    @IBOutlet var lbl_ShopLocation: UILabel!
    @IBOutlet var lbl_ShopAddress: UILabel!
    @IBOutlet var lbl_ShopReview: UILabel!
    @IBOutlet var lbl_Header : UILabel!
    @IBOutlet var lbl_KeyBottom : UILabel!
    @IBOutlet var lbl_KeyBottomTitle : UILabel!
    @IBOutlet var imgShop : UIImageView!
//    @IBOutlet var viewCellHeader : uiview!

    //Image Declaration
    @IBOutlet var img_Fav : UIImageView!
    @IBOutlet weak var imgCheckIn: UIImageView!
    
    //Bool Declaration
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    
    //Product Data
    var objProductDetailData = ProductObject ()
    var str_ProductIDGet : NSString!
    
    //Other Declaration
    var arr_Tableview : [ProductObject] = []
    var tbl_reload_Number : NSIndexPath!
    var arr_Reviews : NSMutableArray = []
    let messageComposer = MessageComposer()
    var arrCertificat: NSMutableArray = []

    //Header tableview animation Declaration
    var vw_HeaderView: UIView?
    var kTableHeaderHeight: Int = 0
    var str_TotalReview: NSString = "0"
    
    @IBOutlet weak var lblVideo: UILabel!
    @IBOutlet weak var imgVideo: UIImageView!
    //Constan delaration
    @IBOutlet var con_SaveBox : NSLayoutConstraint!
    
    //Button Declaration
    @IBOutlet var btn_Fav : UIButton!
    @IBOutlet weak var btnCheckIn: UIButton!
    
//    let btn_NavRight = MIBadgeButton()
    
    //View Declaration
    @IBOutlet var vw_Header : UIView!
    
    //Other Declaration
    @IBOutlet var vw_RateTotal: CosmosView!
    @IBOutlet var vw_RateUser: CosmosView!
    
    
    @IBOutlet var viewGesture: UILongPressGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()

        vw_RateUser.rating = 0
        
        self.commanMethod()
        self.Post_recent_view_business()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        tbl_reload_Number = nil
        
        //Get Data
        self.Get_ProductDetail()
        
        //When time of load data hide view
        tbl_Main.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.removeObserver("cosmostouch")
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "cosmostouch"), object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver("cosmostouch")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "cosmostouch"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Scroollview delegate -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.tag)
       if scrollView == tbl_Main{
            //self.update_Header_collectionview()
            
            switch scrollView.panGestureRecognizer.state {

            default:
                self.update_Header_collectionview()
                break
            }
        }
    }

    
    //MARK: - Other Files -
    func commanMethod(){
        //Tableview collectin view Demo data
        
        var obj2 = ProductObject ()
        obj2.str_Title = ""
        arr_Tableview.append(obj2)
        
        obj2 = ProductObject ()
        obj2.str_Title = "Photos"
        arr_Tableview.append(obj2)
        
        obj2 = ProductObject ()
        obj2.str_Title = "Affiliation & Certification"
        arr_Tableview.append(obj2)
        
        obj2 = ProductObject ()
        obj2.str_Title = "Reviews"
        arr_Tableview.append(obj2)
        
        //Table view header heigh set
        //SET HEADER
        let vw_Table = tbl_Main.tableHeaderView
        vw_Table?.frame = CGRect(x: 0, y: 0, width: tbl_Main.frame.size.width, height: (vw_Table?.frame.size.height)!)
        tbl_Main.tableHeaderView = vw_Table
        tbl_Main.reloadData()
        
    }
    @objc func loadList(notification: NSNotification){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "PostReviewViewController") as! PostReviewViewController
        view.objGet = self.objProductDetailData
        view.str_Type = "business"
        view.str_Value = String(vw_RateUser.rating)
        self.navigationController?.pushViewController(view, animated: false)
        
        vw_RateUser.rating = 0
    }
   
    func indexPaths(forSection section: Int, withNumberOfRows numberOfRows: Int) -> [Any] {
        var indexPaths = [Any]()
        for i in 0..<numberOfRows {
            let indexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    func completedServiceCalling(){
        //Comman fuction action
        bool_Load = false
    }
    func manageDataFill(){
       
        //SET HEADER
        let vw_Table = tbl_Main.tableHeaderView
        vw_Table?.frame = CGRect(x: 0, y: 0, width: tbl_Main.frame.size.width, height: (vw_Table?.frame.size.height)!)
        tbl_Main.tableHeaderView = vw_Table
        tbl_Main.reloadData()

        //SET DETAILS
        imgShop.sd_setImage(with: URL(string: objProductDetailData.str_Business_image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        lbl_ShopTitle.text = objProductDetailData.str_Business_name as String
        lbl_ShopLocation.text = objProductDetailData.str_Business_distance as String
        if Int(objProductDetailData.str_Total_business_review as String)! > 1{
            lbl_ShopReview.text = "\(objProductDetailData.str_Total_business_review as String) Reviews"
        }else{
            lbl_ShopReview.text = "\(objProductDetailData.str_Total_business_review as String) Review"
        }
        lbl_ShopAddress.text = objProductDetailData.str_Category_name as String
        if objProductDetailData.str_SubCategory_name != ""{
            lbl_ShopAddress.text = "\(objProductDetailData.str_Category_name) > \(objProductDetailData.str_SubCategory_name)"
        }
        self.navigationItem.title = objProductDetailData.str_Business_name as String
        lbl_Header.text = objProductDetailData.str_Business_name as String
        
        //SET FAV BUTTON
        if objProductDetailData.str_Is_business_favourite == "0" {
            btn_Fav.isSelected = false
            img_Fav.image = UIImage.init(named: "icon_Save_Product")
        }else{
            btn_Fav.isSelected = true
            img_Fav.image = UIImage.init(named: "icon_Save_Product_Selected")
        }
        
        //SET CHECKIN BUTTON
        if objProductDetailData.is_checkin != 0 {
            btnCheckIn.isSelected = false
            imgCheckIn.image = UIImage.init(named: "icon_SelectCheck-in")
        }else{
            btnCheckIn.isSelected = true
            imgCheckIn.image = UIImage.init(named: "icon_check-in")
        }
//        if objProductDetailData.str_Checkin_date != "" {
//            lblCheckInTime.text = "\("Check-In :") \(objProductDetailData.str_Checkin_date as String)"
//
//        }

        
        vw_RateTotal.rating = Double(objProductDetailData.str_Avg_business_review as String)!
        vw_RateUser.rating = Double(objProductDetailData.str_ReviewUserRate as String)!
        
        //Set bottome key value
        if objProductDetailData.str_Product_Keyword as String != "" {
            lbl_KeyBottom.text = objProductDetailData.str_Product_Keyword as String
        }else{
            lbl_KeyBottom.text = "No Keyword"
        }
        lbl_KeyBottom.font = UIFont(name: Constant.kFontRegular, size: 13)
        lbl_KeyBottomTitle.font = UIFont(name: Constant.kFontBold, size: 13)
//        lblCheckInTime.font = UIFont(name: Constant.kFontRegular, size: 13)

    }


    func update_Header_collectionview() {

    }
    func playVideo(_ url: URL) {
        //        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        
        let avPlayer = AVPlayer(url: (url as? URL)!)
        let player = AVPlayerViewController()
        player.player = avPlayer
        
        avPlayer.play()
        
        self.present(player, animated: true, completion: nil)
    }

    func coordinateRegionForCoordinates(coords: NSMutableArray, coordCount: Int,mapview:MKMapView) { //-> MKCoordinateRegion
        
        let center : CLLocationCoordinate2D = (coords[0] as? CLLocationCoordinate2D)!
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapview.setRegion(region, animated: true)
    }
    
    //MARK: - Message controller -
    class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
        
        // A wrapper function to indicate whether or not a text message can be sent from the user's device
        func canSendText() -> Bool {
            return MFMessageComposeViewController.canSendText()
        }
        
        // Configures and returns a MFMessageComposeViewController instance
        func configuredMessageComposeViewController() -> MFMessageComposeViewController {
            let messageComposeVC = MFMessageComposeViewController()
            messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
            messageComposeVC.recipients = []
            messageComposeVC.body =  "Sending Text Message through SMS in Swift"
            return messageComposeVC
        }
        
        // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    
     //MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
 
    
    @IBAction func btn_Fav(_ sender : Any){
        
        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }else{
            if objProductDetailData.str_Is_business_favourite == "0" {
                btn_Fav.isSelected = true
                objProductDetailData.str_Is_business_favourite = "1"
                img_Fav.image = UIImage.init(named: "icon_Save_Product_Selected")
                
                self.Post_Fav(flag : "1",Productid : objProductDetailData.str_Business_id as String)
                
            }else{
                btn_Fav.isSelected = false
                objProductDetailData.str_Is_business_favourite = "0"
                img_Fav.image = UIImage.init(named: "icon_Save_Product")
                
                self.Post_Fav(flag : "0",Productid : objProductDetailData.str_Business_id as String)
            }
        }
    }
    
    @IBAction func btn_Share (_ sender : Any){
         shareFunction(textData : "I saw this business on Katika and wanted to share it with you, \n\n \(objProductDetailData.str_Business_name as String)",image : UIImage() ,viewPresent: self)
     
    }
    @IBAction func btn_CheckOut(_ sender : Any){
        
        var str_ValueName : NSString = "Review"
        if objProductDetailData.str_ReviewUserTitle != ""{
            str_ValueName = "Edit Review"
        }
    
        //Logout alert for user
        let alert = UIAlertController(title: Constant.appName, message:nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: str_ValueName as String, style: UIAlertAction.Style.default, handler: { (action) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "PostReviewViewController") as! PostReviewViewController
            view.objGet = self.objProductDetailData
            view.str_Type = "business"
            self.navigationController?.pushViewController(view, animated: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

        
    }

   
    @IBAction func Sidebar_Right(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        self.navigationController?.pushViewController(view, animated: false)
    }
    @IBAction func btn_PlayProductVideo(_ sender: Any) {
        if objProductDetailData.str_BusinessVideo != ""{
            self.playVideo(URL(string: objProductDetailData.str_BusinessVideo as String)!)
        }
    }
    
    @IBAction func viewGesture(_ sender: Any) {
        print("2323")
    }
    
    //MARK: -- Tableview Method --
    @IBAction func btn_Section(_ sender: Any) {

            //Get animation with table view reload data
            tbl_Main.beginUpdates()
            if ((tbl_reload_Number) != nil) {
                if (tbl_reload_Number.section == (sender as AnyObject).tag) {
                    
     
                        let arr_DeleteIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows: arr_Reviews.count+1)
                        tbl_Main.deleteRows(at: arr_DeleteIndex as! [IndexPath], with: .automatic)
                    
                    tbl_reload_Number = nil;
                }else{
                    //Delete Cell
                    // let objDelete : PurchaseObject = arr_Main[tbl_reload_Number.section]
                    
                   
                        let arr_DeleteIndex = self.indexPaths(forSection: tbl_reload_Number.section, withNumberOfRows:arr_Reviews.count+1)
                        tbl_Main.deleteRows(at: arr_DeleteIndex as! [IndexPath], with: .automatic)
                    
                    
                    tbl_reload_Number = IndexPath(row: 0, section: (sender as AnyObject).tag) as NSIndexPath!
                    
                    //Add Cell
                    //let obj : PurchaseObject = arr_Main[(sender as AnyObject).tag]
                    

                        let arr_AddIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows:arr_Reviews.count+1)
                        tbl_Main.insertRows(at: arr_AddIndex as! [IndexPath], with: .automatic)
                    
                }
            }else{
                tbl_reload_Number = IndexPath(row: 0, section: (sender as AnyObject).tag) as NSIndexPath!
                
               
                    let arr_AddIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows: arr_Reviews.count+1)
                    tbl_Main.insertRows(at: arr_AddIndex as! [IndexPath], with: .automatic)
            }
            
            tbl_Main.endUpdates()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.tbl_Main.reloadData()
                
            })
        
    }
    
    @IBAction func btn_ProductDetailReview (_ sender : Any){
        let obj : ReviewObjet = arr_Reviews[(sender as AnyObject).tag] as! ReviewObjet
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
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

    @IBAction func btnCheckInClicked(_ sender: Any) {
        
        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }else{
            if objProductDetailData.is_checkin == 0 {
                //CALL API
                Post_CheckIn()
            }
        }
            
        
    }
    @IBAction func btnYoutubVideoClicked(_ sender: Any) {
        print(objProductDetailData.str_YoutubLink)
        if objProductDetailData.str_YoutubLink as String != ""{
            let url = URL(string:objProductDetailData.str_YoutubLink as String)!
            openURLToWeb(url : url)
        }
        else{
            messageBar.MessageShow(title: "Invalid URL", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }
    }

    
    @IBAction func btn_Call (_ sender : Any){
        if let url = URL(string: "tel://\(objProductDetailData.str_Phone_number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func btn_Direction (_ sender : Any){
        let str_Start : String = objProductDetailData.str_Business_lat as String
        let str_End : String = objProductDetailData.str_Business_long as String
        let str_CurrentStart : String = String(format:"%.5f", (currentLocation?.coordinate.latitude)!)
        let str_CurrentEnd : String = String(format:"%.5f", (currentLocation?.coordinate.longitude)!)
        
        let directionsURL = "http://maps.apple.com/?saddr=\(str_CurrentStart),\(str_CurrentEnd)&daddr=\(str_Start),\(str_End)"
        UIApplication.shared.openURL(URL(string: directionsURL)!)
    }
    @IBAction func btn_WebsideView (_ sender : Any){
        if objProductDetailData.str_Website as String != ""{
            let url = URL(string:objProductDetailData.str_Website as String)!
            openURLToWeb(url : url)
        }
    }
    @IBAction func btn_Address (_ sender : Any){
        
    }
    @IBAction func btn_More (_ sender : Any){
        self.performSegue(withIdentifier: "more", sender: nil)

    }
    
    
    // MARK: - Get/Post Method -
    func Get_ProductDetail(){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_business_details"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
            "skip" : "0",
            "total" : "20",
            "business_id" : str_ProductIDGet,
            "latitude" : String(format:"%.5f", (currentLocation?.coordinate.latitude)!),
            "longitude" : String(format:"%.5f", (currentLocation?.coordinate.longitude)!),
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_business_details"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }
    
    func Post_recent_view_business(){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)add_recent_view_business"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
            "business_id" : str_ProductIDGet,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "recent_view_products"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
    }
    
    
    func Post_Fav(flag : String , Productid : String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)addremove_favourite_business"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
            "business_id" : Productid,
            "status" : flag,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "addremove_favourite_business"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
    }
    
    func Get_ShopReviews(shopID : NSString){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_business_reviews"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "skip" : "0",
            "total" : "5",
            "business_id" : str_ProductIDGet,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_business_reviews"
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
    
    func Post_CheckIn(){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)business_checkin"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
            "business_id" : str_ProductIDGet,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "CheckIn"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
    }
    
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "reivewpreview"{

        }else if segue.identifier == "more"{
            let view : BusinessDetailMoreViewController = segue.destination as! BusinessDetailMoreViewController
            view.obj_Get = objProductDetailData
            
        }
    }
}



//MARK: - Collection View -
extension BusinessDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returen number of cell with content available in array
        if collectionView.tag == 101 {
            
            if objProductDetailData.arr_Business_images.count != 0 {
                return objProductDetailData.arr_Business_images.count
            }
            return 0
        }
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Returen number of cell with content available in array
        if collectionView.tag == 101 {
            return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
        }
        return CGSize(width: 0, height: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductViewCollectioncell
        
       if collectionView.tag == 101 {
        
            var arr_Image : NSMutableArray = objProductDetailData.arr_Business_images
        
            let obj : ProductObject = arr_Image[indexPath.row] as! ProductObject
        
            //Image set
            cell.img_Header.sd_setImage(with: URL(string: obj.str_ImageProductURL as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 101 {

            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductViewCollectioncell

            //Create arr for Slide image post to FTImageviewer
            var imageArray : [String] = []
            let arr_Image : NSMutableArray = objProductDetailData.arr_Business_images
            for i in 0...arr_Image.count-1{
                let obj : ProductObject = arr_Image[i] as! ProductObject
                imageArray += [obj.str_ImageProductURL as String]
            }
            
            //Create arr for frame with all images position
            var views = [UIView]()
            for _ in 0...arr_Image.count-1 {
                views.append(cell.img_Header)
            }
            
            //Call method present imageviewer
            FTImageViewer.showImages(imageArray, atIndex: indexPath.row, fromSenderArray: views)
        }
    }
}



// MARK: - Tableview Files -
extension BusinessDetailViewController : UITableViewDelegate,UITableViewDataSource {
    // MARK: - Table View -
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 4;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //For data 0 section is map
        if section == 0 {
            print(objProductDetailData.str_Business_lat)
            if objProductDetailData.str_Business_lat as String == "" {
                return 0
            }else{
                return 1
            }
        }else if section == 1 {
                return 1
        }else if section == 2 {
            return arrCertificat.count
        }else if section == 3 {
            if arr_Reviews.count != 0 {
                return arr_Reviews.count + 1;
            }else{
                return 1
            }
        }
   
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Review Section 0 map
        if (indexPath.section == 0){
//            return 0
            return UITableView.automaticDimension
        }else if (indexPath.section == 1){
            return  CGFloat((Constant.windowWidth)/3)
        }
        else if (indexPath.section == 2){
            return  CGFloat((Constant.windowHeight * 60)/Constant.screenHeightDeveloper)
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 108
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Review Section 0 map
        if (section == 0){
            return 0
        }

        return  CGFloat((Constant.windowHeight * 55)/Constant.screenHeightDeveloper)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "section")as! ProductTableviewCell
        
        
        //Create object for ProductObject
        let obj : ProductObject = arr_Tableview[section]
        
        //Assign value
        cell.lbl_Title.text = obj.str_Title as String
        
        
        cell.img_ImgLine.isHidden = true
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Identifier cell with based on section
        var cellIdentifier : String = "productdetail"
        switch indexPath.section {
            case 0:
                cellIdentifier = "map"
            break
            case 1:
                cellIdentifier = "photogallery"
            break
            case 2:
                cellIdentifier = "certification"
            break
            case 3:
                cellIdentifier = "reviewCell"
                
                //Set validation for see more review cell present last cell in review section
                if indexPath.row == arr_Reviews.count{
                    cellIdentifier = "reviewDetailCell"
                }
                break
            default:
                cellIdentifier = "productdetail"
                break
        }
        
        if(indexPath.section == 0 ) {
            //Create cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! ProductTableviewCell
            cell.vw_MapView.delegate = self
            
//            // Add annotations to the manager.
            let arr_Location : NSMutableArray = []
            let annotation = Annotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(objProductDetailData.str_Business_lat as String)!, longitude: Double(objProductDetailData.str_Business_long as String)!)
            annotation.title = "SHOP LOCATION"
            
            let color = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
            annotation.type = .image(UIImage(named: "pin")?.filled(with: color))
            arr_Location.add(annotation.coordinate)
            
            let myAnnotation: MKPointAnnotation = MKPointAnnotation()
            myAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(objProductDetailData.str_Business_lat as String)!, longitude: Double(objProductDetailData.str_Business_long as String)!)
            myAnnotation.title = objProductDetailData.str_Business_name as String
            cell.vw_MapView.addAnnotation(myAnnotation)
            
            self.coordinateRegionForCoordinates(coords: arr_Location, coordCount: arr_Location.count,mapview:cell.vw_MapView)
            
            //Fill data
            cell.btn_Website.addTarget(self, action: #selector(self.btn_WebsideView(_:)), for:.touchUpInside)
            cell.btn_Call.addTarget(self, action: #selector(self.btn_Call(_:)), for:.touchUpInside)
            cell.btn_Direction.addTarget(self, action: #selector(self.btn_Direction(_:)), for:.touchUpInside)
             cell.btn_Address.addTarget(self, action: #selector(self.btn_Address(_:)), for:.touchUpInside)
            cell.btn_More.addTarget(self, action: #selector(self.btn_More(_:)), for:.touchUpInside)
            
            cell.lbl_WebDirection.text = objProductDetailData.str_Business_location as String
            cell.lbl_CallShop.text = objProductDetailData.str_Phone_number as String
            cell.lbl_Address.text = objProductDetailData.str_Business_location as String
        
            //SET WEBURL
            cell.con_weburl.constant = 5
            cell.imgWebUrl.isHidden = false
            cell.lbl_Website.textColor =  UIColor.black
            imgColor(imgColor: cell.imgWebsite, colorHex: "000000")
            if objProductDetailData.str_Website as String == ""{
                cell.con_weburl.constant = 15
                cell.imgWebUrl.isHidden = true
                cell.lbl_Website.textColor =  UIColor.lightGray
                imgColor(imgColor: cell.imgWebsite, colorHex: "9a9a9a")
            }
            cell.lbl_WebUrl.text = objProductDetailData.str_Website as String

            
            return cell
        }else if(indexPath.section == 1) {
            //Create cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! ProductTableviewCell
            cell.cv_Photos.tag = 101
            cell.cv_Photos.delegate = self
            cell.cv_Photos.dataSource = self
            cell.cv_Photos.reloadData()
            
            return cell
            
        }else if(indexPath.section != 2 && indexPath.section != 3 ) {
            //Create cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! ProductTableviewCell
            
            //Assign text
            switch indexPath.section {
                case 1:
                    cell.lbl_ProductDetail.text = objProductDetailData.str_ProductInfo  as String
                    break
                case 2:
                    cell.lbl_ShippingPolicy.text = objProductDetailData.str_ProductShippingAndReturn  as String
                    cell.lbl_ReturnPolicy.text = objProductDetailData.str_ProductReturn  as String
                    break
                case 3:
                    cell.lbl_ProductDetail.text = ""
                    break
                    
                default:
                    cellIdentifier = "productdetail"
                    break
            }
            
            return cell;

        }else if(indexPath.section == 2 ) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for:indexPath as IndexPath) as! ProductTableviewCell
            
            let dicData = arrCertificat[indexPath.row] as! NSDictionary
            print(dicData)

            //SET IMAGE
            cell.imgCertificat.sd_setImage(with: URL(string: dicData["image"] as! String), placeholderImage: UIImage(named: Constant.placeHolder_User))

            //SET DETAILS
            cell.lblCerName.text = dicData["title"] as? String
            cell.lblCerSubName.text = dicData["subtitle"] as? String

            return cell
        }else{
    
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for:indexPath as IndexPath) as! ReviewTableviewCell
            
            if indexPath.row != arr_Reviews.count{

                cell.selectionStyle = .none;
                let objReview:ReviewObjet = arr_Reviews[indexPath.row] as! ReviewObjet
                
                cell.lbl_ReviewBy.text = objReview.str_ReviewUserName as String
                cell.lbl_ReviewDate.text = localDateToStrignDate2(date : objReview.str_ReviewDate as String)
                cell.lbl_ReviewDescription.text = objReview.str_ReviewDescription as String
//                cell.lbl_ProductName.text = objReview.str_Product_Name as String
                cell.imgView_ReviewUserPhoto.sd_setImage(with: URL(string: objReview.str_ReviewUserImage as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))

                cell.imgView_ReviewUserPhoto.layoutIfNeeded()
                cell.imgView_ReviewUserPhoto.layer.cornerRadius = cell.imgView_ReviewUserPhoto.frame.size.width/2;
                cell.imgView_ReviewUserPhoto.layer.masksToBounds = true
                
                //Mange Relating
                cell.rate_UserRate.rating = Double(objReview.str_ReviewStar as String)!

                //Product Button
                cell.btn_Click.tag = indexPath.row
                cell.btn_Click.addTarget(self, action: #selector(self.btn_ClickMessage(_:)), for:.touchUpInside)
                
            }else{
                if arr_Reviews.count != 0 {
                    cell.lbl_TotalReview.text = "See All \(str_TotalReview) Reviews"
                }else{
                    cell.lbl_TotalReview.text = "No review available"
                }
            }
            
            return cell;
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            //annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "map_Pin")
        }
        
        return annotationView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {

            if indexPath.row == arr_Reviews.count{
                if arr_Reviews.count != 0 {
                    let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewFullListingViewController") as! ReviewFullListingViewController
                    view.str_ShopIDGet = str_ProductIDGet
                    view.str_Type = "business"
                    self.navigationController?.pushViewController(view, animated: true)
                }
            }else{
                let objHere : ReviewObjet = arr_Reviews[indexPath.row] as! ReviewObjet
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewGet = storyboard.instantiateViewController(withIdentifier: "ReviewDetailViewController") as! ReviewDetailViewController
                viewGet.getObject = objHere
                viewGet.str_Type = "business"
                self.navigationController?.pushViewController(viewGet, animated: false)
            }
        }
    }
}


extension BusinessDetailViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        print(response)
        if strRequest == "get_business_details" {
            self.completedServiceCalling()
            tbl_Main.isHidden = false
            
            //Product detail
            let arr_result = response["Result"] as! NSArray
            let dict_Product = arr_result[0] as! NSDictionary
            let arr_Image = dict_Product["business_images"] as! NSArray
            let arr_ReviewDetail = dict_Product["review_detail"] as! NSArray
            let arr_MyReviewDetail = dict_Product["review_added_detail"] as! NSArray
            let arr_Affiliates = dict_Product["affiliates"] as! NSArray
            

            arrCertificat = []
            if arr_Affiliates.count != 0{
                arrCertificat = NSMutableArray(array:arr_Affiliates)

            }
            //Product Data
            let obj = ProductObject ()
            obj.str_Business_id = ("\(dict_Product["business_id"] as! Int)" as NSString)
            obj.str_ProductShopID = ("\(dict_Product["business_id"] as! Int)" as NSString)
            obj.str_Business_owner_id = ("\(dict_Product["business_owner_id"] as! Int)" as NSString)
            obj.str_Business_name = dict_Product["business_name"] as! NSString
            obj.str_Business_image = dict_Product["banner_image"] as! NSString
            obj.str_Business_title = dict_Product["business_title"] as! NSString
            obj.str_Business_location = dict_Product["business_location"] as! NSString
            obj.str_Business_lat = dict_Product["business_lat"] as! NSString
            obj.str_Business_long = dict_Product["business_long"] as! NSString
            obj.str_Business_email = dict_Product["business_email"] as! NSString
            obj.str_Phone_number = dict_Product["phone_number"] as! NSString
            obj.str_Business_country = dict_Product["business_country"] as! NSString
            obj.str_Business_category = dict_Product["business_category"] as! NSString
            obj.str_Business_sub_category = dict_Product["business_sub_category"] as! NSString
            obj.str_Website = dict_Product["website"] as! NSString
            
            print(("\(dict_Product["business_id"] as! Int)" as NSString))
            print(dict_Product["youtube"] as! NSString)
            obj.str_YoutubLink = dict_Product["youtube"] as! NSString
            obj.is_checkin = dict_Product["is_check_in"] as! Int
            obj.str_Checkin_date = dict_Product["is_check_date"] as! NSString
            obj.str_Explore_menu = dict_Product["explore_menu"] as! NSString
            obj.str_Business_description = dict_Product["business_description"] as! NSString
            obj.str_Avg_business_review = dict_Product["avg_business_review"] as! NSString
            obj.str_Total_business_review = ("\(dict_Product["total_business_review"] as! Int)" as NSString)
            obj.str_Business_view_count = ("\(dict_Product["business_view_count"] as! Int)" as NSString)
            obj.str_Active_shop = ("\(dict_Product["active_shop"] as! Int)" as NSString)
            obj.str_Is_approved = ("\(dict_Product["is_approved"] as! Int)" as NSString)
            obj.str_Is_business_favourite = dict_Product["is_business_favourite"] as! NSString
            obj.str_TotalReview = dict_Product["TotalReview"] as! NSString
            obj.str_AvgReview = dict_Product["AvgReview"] as! NSString
            obj.str_Business_distance  = dict_Product["distance"] as? NSString ?? "2.0 m"
            obj.str_BusinessVideo = dict_Product["business_video"] as? NSString ?? ""
            obj.str_Category_name = dict_Product["category_name"] as? NSString ?? ""
            obj.str_SubCategory_name = dict_Product["sub_category_name"] as? NSString ?? ""
            obj.str_Open_hr_json = dict_Product["open_hr_json"] as? NSString ?? ""
            obj.str_ExporeMenuShow = dict_Product.getStringForID(key:"explore_menu_visible") as! NSString
            obj.str_FB = dict_Product["fb_url"] as? NSString ?? ""
            obj.str_Twitter = dict_Product["twitter_url"] as? NSString ?? ""
            obj.str_Insta = dict_Product["insta_url"] as? NSString ?? ""

            //Keyword Array
            obj.str_Product_Keyword = ""
            let arr_keyword = dict_Product["keywords"] as! NSArray
            for j in (0..<arr_keyword.count){
                if j == 0{
                    obj.str_Product_Keyword = arr_keyword[j] as! NSString
                }else{
                    obj.str_Product_Keyword = "\(obj.str_Product_Keyword), \(arr_keyword[j] as! String)" as NSString
                }
            }
            
            
            let arr_TempImage : NSMutableArray = []
            for i in (0..<arr_Image.count) {
                let dict_ImageData = arr_Image[i] as! NSDictionary
            
                //Other Tab Demo data
                let objImage = ProductObject ()
//                objImage.str_ImageProductID = ("\(dict_ImageData["product_id"] as! Int)" as NSString)
                objImage.str_ImageProductURL = dict_ImageData["image"] as! NSString
                
                arr_TempImage.add(objImage)
            }
            obj.arr_Business_images = arr_TempImage
            
            //Manage Product review by user
            obj.str_ReviewUserRate = "0"
            obj.str_ReviewUserTitle = ""
            
            if arr_MyReviewDetail.count != 0{
                 let dict_Review = arr_ReviewDetail[0] as! NSDictionary
                
                obj.str_ReviewUserRate = dict_Review.getStringForID(key:"rate") as! NSString
                obj.str_ReviewUserTitle = dict_Review.getStringForID(key:"review") as! NSString
            }
            
            if arr_ReviewDetail.count != 0 {

                let dict_Review = arr_ReviewDetail[0] as! NSDictionary
                let arr_ReviewComment = dict_Review["product_refrence"] as! NSArray

                let arr_ReviewTemp : NSMutableArray = []
                for i in (0..<arr_ReviewComment.count) {
                    let dict_DataComment = arr_ReviewComment[i] as! NSDictionary

                    //Comment get
                    let objImage2 = ProductObject ()
                    objImage2.str_ReviewUserComment = dict_DataComment["comment"] as! NSString
                    objImage2.str_ReviewUserImage = dict_DataComment["reference_file"] as! NSString
                    objImage2.str_ReviewUserType = dict_DataComment["type"] as! NSString
                    objImage2.str_Thumb_Image = dict_DataComment["thumb_image"] as! String as NSString

                    arr_ReviewTemp.add(objImage2)
                }
                obj.arr_ReviewUserComment = arr_ReviewTemp

            }else{
                obj.str_ReviewUserTitle = ""
            }
           
            //Save local object to global object
            objProductDetailData = obj
            
            //SET VIDEO
            if objProductDetailData.str_YoutubLink as String == ""{
                lblVideo.textColor = UIColor.lightGray
                let templateImage = imgVideo.image?.withRenderingMode(UIImage.UIImage.RenderingMode.alwaysTemplate)
                imgVideo.image = templateImage
                imgVideo.tintColor = UIColor.lightGray
            }
            
            
            tbl_Main.reloadData()
            
            self.manageDataFill()
            self.Get_ShopReviews(shopID:objProductDetailData.str_ProductShopID)
            
        }else if strRequest == "CheckIn"{
            //Alert show for Header
            messageBar.MessageShow(title: "Check-In successfully", alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
            
            objProductDetailData.is_checkin = 1
            manageDataFill()
        }
        else if strRequest == "addremove_favourite_business" {
            
        }else if strRequest == "add_recent_view_business" {
            
        }else if strRequest == "get_business_reviews" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            str_TotalReview = response["TotalRecord"] as! String as NSString
            
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
                objReview.str_imageshop_id = ("\(dict_Data["business_id"] as! Int)" as NSString)
                objReview.str_imageuser_id = ("\(dict_Data["userid"] as! Int)" as NSString)
                objReview.str_Product_id = ("\(dict_Data["business_id"] as! Int)" as NSString)
                objReview.str_Product_Name = ""
                objReview.str_ReviewUseful = ("\(dict_Data["is_useful"] as! Int)" as NSString)
                objReview.str_ReviewFunny = ("\(dict_Data["is_funny"] as! Int)" as NSString)
                objReview.str_ReviewCool = ("\(dict_Data["is_cool"] as! Int)" as NSString)
                objReview.str_ReviewUsefulCount = ("\(dict_Data["useful"] as! Int)" as NSString)
                objReview.str_ReviewFunnyCount = ("\(dict_Data["funny"] as! Int)" as NSString)
                objReview.str_ReviewCoolCount = ("\(dict_Data["cool"] as! Int)" as NSString)
                
                //Image Array
                let arr_Image_Store : NSMutableArray = []

                objReview.arr_Images = arr_Image_Store
                
                //Refer Image
                let arr_ReviewComment = dict_Data["product_refrence"] as! NSArray
                let arr_ReviewTemp : NSMutableArray = []
                for i in (0..<arr_ReviewComment.count) {
                    let dict_DataComment = arr_ReviewComment[i] as! NSDictionary
                    
                    //Comment get
                    let objImage2 = ReviewObjet ()
                    objImage2.str_UserUpload_ReviewUserComment = dict_DataComment["comment"] as! NSString
                    objImage2.str_UserUpload_ReviewUserImage = dict_DataComment["reference_file"] as! NSString
                    objImage2.str_UserUpload_ReviewUserType = dict_DataComment["type"] as! NSString
                    objImage2.str_UserUpload_Thumb_Image = dict_DataComment["thumb_image"] as! String as NSString
                    
                    arr_ReviewTemp.add(objImage2)
                }
                objReview.arr_UserUpload_Image = arr_ReviewTemp
                
                
                arr_StoreTemp.add(objReview)
            }
          
            //Restore array
            arr_Reviews = []
            for i in (0...arr_StoreTemp.count-1){
                arr_Reviews.add(arr_StoreTemp[i])
            }
            tbl_Main.reloadData()
        }else if strRequest == "add_to_cart" {
            
            var int_Count : Int = Int((objUser?.str_CardCount as! NSString) as String)! + 1
            
            objUser?.str_CardCount = String(int_Count) as NSString
            saveCustomObject(objUser!, key: "userobject");
            
//            btn_NavRight.badgeString = objUser?.str_CardCount as! String
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
        self.completedServiceCalling()
    }
    
}



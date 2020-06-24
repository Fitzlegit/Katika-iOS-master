//
//  ProductDetailViewController.swift
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

class ProductDetailViewController: UIViewController,MKMapViewDelegate{

    //Declaration CollectionView
    @IBOutlet var cv_Main_Header : UICollectionView!
    @IBOutlet var cv_Main_PaymentCart : UICollectionView!
    
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    //Label Declaration
    @IBOutlet var lbl_Color : UILabel!
    @IBOutlet var lbl_Size: UILabel!
    @IBOutlet var lbl_ProductPrice: UILabel!
    @IBOutlet var lbl_ProductDescription: UILabel!
    @IBOutlet var lbl_ShopTitle: UILabel!
    @IBOutlet var lbl_ShopLocation: UILabel!
    @IBOutlet weak var lbl_PurchaseGuildLink: FRHyperLabel!
    @IBOutlet var lbl_BookSelected : UILabel!
    @IBOutlet var lbl_BookSizeSelected : UILabel!
    @IBOutlet var lbl_Header : UILabel!
    @IBOutlet var lbl_KeyBottom : UILabel!
    @IBOutlet var lbl_KeyBottomTitle : UILabel!
    
    //Product Section Module
    @IBOutlet var lbl_SelectionTitle1 : UILabel!
    @IBOutlet var lbl_SelectionTitle2 : UILabel!
    @IBOutlet var lbl_SelectionTitle3 : UILabel!
    @IBOutlet var lbl_SelectionTitle4 : UILabel!
    @IBOutlet var lbl_SelectionAns1 : UILabel!
    @IBOutlet var lbl_SelectionAns2 : UILabel!
    @IBOutlet var lbl_SelectionAns3 : UILabel!
    @IBOutlet var btn_Selection1 : UIButton!
    @IBOutlet var btn_Selection2 : UIButton!
    @IBOutlet var btn_Selection3 : UIButton!
    @IBOutlet var img_Selection1 : UIImageView!
    @IBOutlet var img_Selection2 : UIImageView!
    @IBOutlet var img_Selection3 : UIImageView!
    
    @IBOutlet var vw_Selection1 : UIView!
    @IBOutlet var vw_Selection2 : UIView!
    @IBOutlet var vw_Selection3 : UIView!
    
    @IBOutlet var vw_SelectionNew1 : UIView!
    @IBOutlet var vw_SelectionNew2 : UIView!
    @IBOutlet var vw_SelectionNew3 : UIView!
    @IBOutlet var vw_SelectionNew4 : UIView!
    
    @IBOutlet var lbl_QTY : UILabel!
    
    //Image Declaration
    @IBOutlet var img_ShopImage: UIImageView!
    @IBOutlet var img_Fav : UIImageView!
    @IBOutlet var img_ShareIcon_Header : UIImageView!
    
    //Bool Declaration
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    
    //Product Data
    var objProductDetailData = ProductObject ()
    var str_ProductIDGet : NSString!
    
    //Other Declaration
    @IBOutlet var pg_Header : UIPageControl!
    var arr_Tableview : [ProductObject] = []
    var tbl_reload_Number : NSIndexPath!
    var arr_Reviews : NSMutableArray = []
    let messageComposer = MessageComposer()
    
    //Header tableview animation Declaration
    var vw_HeaderView: UIView?
    var kTableHeaderHeight: Int = 0
    var str_TotalReview: NSString = "0"
    
    //Constan delaration
    @IBOutlet var con_SaveBox : NSLayoutConstraint!
    @IBOutlet var con_TitleBox : NSLayoutConstraint!
    @IBOutlet var con_ColorBox : NSLayoutConstraint!
    @IBOutlet var con_SelectBox : NSLayoutConstraint!
    
    //Button Declaration
    @IBOutlet var btn_Fav : UIButton!
    @IBOutlet var btn_Add_To_Cart : UIButton!
    let btn_NavRight = MIBadgeButton()
    
    //View Declaration
    @IBOutlet var vw_Header : UIView!
    @IBOutlet var vw_Book : UIView!
    @IBOutlet var vw_VideoPreview : UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.headerSet_TableView), userInfo: nil, repeats: false)

        self.commanMethod()
        self.Post_recent_view_products()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        tbl_reload_Number = nil
        
        //Get Data
        self.Get_ProductDetail()
        
        //When time of load data hide view
        tbl_Main.isHidden = true
        img_ShareIcon_Header.isHidden = true
        
        //Cart count badge
        btn_NavRight.badgeString = objUser?.str_CardCount as! String
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Scroollview delegate -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.tag)
        if cv_Main_Header == scrollView{
            let visibleRect = CGRect(origin: cv_Main_Header.contentOffset, size: cv_Main_Header.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let indexPath = cv_Main_Header.indexPathForItem(at: visiblePoint)
            
            pg_Header.currentPage = (indexPath?.row)!
        }else if scrollView == tbl_Main{
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
        obj2.str_Title = "Product information"
        arr_Tableview.append(obj2)
        
        obj2 = ProductObject ()
        obj2.str_Title = "Shipping & Returns"
        arr_Tableview.append(obj2)
        
        obj2 = ProductObject ()
        obj2.str_Title = "Size guide"
        arr_Tableview.append(obj2)
        
        obj2 = ProductObject ()
        obj2.str_Title = "Reviews"
        arr_Tableview.append(obj2)
        
        print(arr_Tableview[0])
        //Table view header heigh set
        let vw : UIView = tbl_Main.tableHeaderView!
        vw.frame = CGRect(x: 0, y: 0, width: CGFloat(Constant.windowWidth), height: CGFloat((Constant.windowHeight * 530)/Constant.screenHeightDeveloper))
        tbl_Main.tableHeaderView = vw;
        
        //Page header color set
        pg_Header.pageIndicatorTintColor = UIColor(patternImage:UIImage(named: "img_Page")!)
        pg_Header.currentPageIndicatorTintColor = UIColor(red: CGFloat((207 / 255.0)), green: CGFloat((198 / 255.0)), blue: CGFloat((188 / 255.0)), alpha: CGFloat(1.0))
        
        //Make Link for purchaseGuild
        lbl_PurchaseGuildLink.numberOfLines = 0;
        let policyString = "purchasing items http://www.shopkatika.com/purchaseguide"
        let attributes = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,
            convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): 0,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: Constant.kFontSemiBold, size: 13)!] as [String : Any]
        let attributedString = NSMutableAttributedString(string: policyString, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        lbl_PurchaseGuildLink?.attributedText = attributedString
 
        let linkRange = NSRange(location: 17, length: 39)
        let attributes2 = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.red,
            convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): 1,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: Constant.kFontSemiBold, size: 13)!] as [String : Any]
        lbl_PurchaseGuildLink?.setLinkFor(linkRange, withAttributes: attributes2, andLinkHandler: { label, string in
            //Open url
            //http://www.buykatika.com/purchaseguild
            
            
            if let url = URL(string: "http://www.shopkatika.com/purchaseguide" as String) {
                if UIApplication.shared.canOpenURL(url) {
                    openURLToWeb(url : url)
                }else{
                    messageBar.MessageShow(title: "Invalid URL", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
            }
        })
        

        //Right Bar Navigation button set
        btn_NavRight.frame = CGRect(x: Constant.windowWidth - 65, y: 0, width: 54, height: 45)
        btn_NavRight.setImage(UIImage(named: "icon_MyStore"), for: .normal)
        btn_NavRight.addTarget(self, action: #selector(self.Sidebar_Right(_:)), for:.touchUpInside)
        btn_NavRight.badgeString = objUser?.str_CardCount as! String
        btn_NavRight.badgeTextColor = UIColor.white
        btn_NavRight.badgeEdgeInsets = UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 27)
        vw_Header.addSubview(btn_NavRight)
        
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
        lbl_ProductPrice.text = "\(objProductDetailData.str_ProductPriceSymbol as String)\(objProductDetailData.str_ProductPrice as String)"
        lbl_ProductDescription.text = objProductDetailData.str_ProductTitle as String
        self.navigationItem.title = objProductDetailData.str_ProductTitle as String
        lbl_Header.text = objProductDetailData.str_ProductTitle as String
        
        let font = UIFont(name: Constant.kFontSemiBold, size: 15)
        let height = heightForView( text: lbl_ProductDescription.text!, font: font!, width: CGFloat(Constant.windowWidth))
        print(height)
        
        con_TitleBox.constant = 40 + height
        tbl_Main.tableHeaderView?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(tbl_Main.bounds.size.width), height: CGFloat(522 + height))
        tbl_Main.reloadData()
        
        lbl_ShopTitle.text = objProductDetailData.str_ProductShopName as String
        lbl_ShopLocation.text = objProductDetailData.str_ProductShop_Location as String
        
        if objProductDetailData.str_ProductFav == "0" {
            btn_Fav.isSelected = false
            img_Fav.image = UIImage.init(named: "icon_Save_Product")
        }else{
            btn_Fav.isSelected = true
            img_Fav.image = UIImage.init(named: "icon_Save_Product_Selected")
        }
        
        img_ShopImage.sd_setImage(with: URL(string: objProductDetailData.str_ProductShop_logo as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        
        lbl_Color.text = "Select"
        lbl_QTY.text = "SELECT"
        lbl_Size.text = "Select"
        
        //Color set
        let arr_Color: NSMutableArray = objProductDetailData.arr_ColorSelect
        if arr_Color.count != 0 {
            let obj : ProductObject = arr_Color[0] as! ProductObject
            print(obj.str_ColorName)
            lbl_Color.text = obj.str_ColorName as String
            
            let arr_ColorSub: NSMutableArray = obj.arr_ColorSize
            if arr_ColorSub.count != 0 {
                let obj2 : ProductObject = arr_ColorSub[0] as! ProductObject
                lbl_Size.text = obj2.str_ColorKey as String
                
                if obj2.str_ColorKey == "0"{
                    lbl_QTY.text = ""
                }else{
                    lbl_QTY.text = "1"
                }
                
            }
        }
        
        //Manage Add to card button
        if objProductDetailData.str_ProductAddedInCart == "1"{
            btn_Add_To_Cart.isSelected = true
        }else{
            btn_Add_To_Cart.isSelected = false
        }
        
        //Book cateogry Manage
        if  objProductDetailData.str_ProductCategoryID == "4" {
            vw_Book.isHidden = false
            
            let arr_Book: NSMutableArray = objProductDetailData.arr_BookSelect
            if arr_Book.count != 0 {
                let obj : ProductObject = arr_Book[0] as! ProductObject

                lbl_BookSelected.text = obj.str_BookName as String
                lbl_BookSizeSelected.text = "1"
            }

            
        }else{
            vw_Book.isHidden = true
        }
        
        
        //Manage Data is avaialble or not
        if Int(objProductDetailData.str_Product_StockRemain as String)! <= 0{
            
            lbl_Color.text = "-"
            lbl_QTY.text = "-"
            lbl_Size.text = "-"
            
            btn_Add_To_Cart.setTitle("Stock not avaialble",for:.normal)
           // btn_Add_To_Cart.isSelected = false
        }
        

        //Random data manageMent
        for i in 0..<objProductDetailData.arr_Random_Key.count{
            switch(i){
            case 0:
                lbl_SelectionTitle1.text = (objProductDetailData.arr_Random_Key[i] as? String)?.uppercased()
                break
            case 1:
                lbl_SelectionTitle2.text = (objProductDetailData.arr_Random_Key[i] as? String)?.uppercased()
                break
            case 2:
                lbl_SelectionTitle3.text = (objProductDetailData.arr_Random_Key[i] as? String)?.uppercased()
                break
            default:
                break
            }
        }
        lbl_SelectionTitle1.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        lbl_SelectionTitle2.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        lbl_SelectionTitle3.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        lbl_SelectionTitle4.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        lbl_SelectionAns1.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        lbl_SelectionAns2.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        lbl_SelectionAns3.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        lbl_QTY.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        lbl_KeyBottom.font = UIFont(name: Constant.kFontRegular, size: 13)
        lbl_KeyBottomTitle.font = UIFont(name: Constant.kFontBold, size: 13)
        
        if objProductDetailData.arr_Random_Key.count == 2{
//            vw_Selection3.removeFromSuperview()
        }else if objProductDetailData.arr_Random_Key.count == 1{
//            vw_Selection2.removeFromSuperview()
//            vw_Selection3.removeFromSuperview()
        }
        
        //Video Preview button setup
        if objProductDetailData.str_ProductVideoURL == ""{
            vw_VideoPreview.alpha = 0.5
        }else{
            vw_VideoPreview.alpha = 1.0
        }
        
        //Set bottome key value
        if objProductDetailData.str_Product_Keyword as String != "" {
            lbl_KeyBottom.text = objProductDetailData.str_Product_Keyword as String
        }else{
            lbl_KeyBottom.text = "No Keyword"
        }
        
        var str_Height : Double = 530
        con_SelectBox.constant = 100
        if objProductDetailData.arr_Random_Key.count == 0{
            str_Height = 530-50
            con_SelectBox.constant = 50
            vw_SelectionNew1.removeFromSuperview()
            vw_SelectionNew2.removeFromSuperview()
            vw_SelectionNew3.removeFromSuperview()
        }
        else if objProductDetailData.arr_Random_Key.count == 1{
            str_Height = 530
            vw_SelectionNew2.removeFromSuperview()
            vw_SelectionNew3.removeFromSuperview()
        }else if objProductDetailData.arr_Random_Key.count == 2{
            con_SelectBox.constant = 150
            str_Height = 530 + 50
            vw_SelectionNew3.removeFromSuperview()
        }else if objProductDetailData.arr_Random_Key.count == 3{
            con_SelectBox.constant = 200
            str_Height = 530 + 100
        }
        //Table view header heigh set
        let vw : UIView = tbl_Main.tableHeaderView!
        vw.frame = CGRect(x: 0, y: 0, width: CGFloat(Constant.windowWidth), height: CGFloat((Constant.windowHeight * str_Height)/Constant.screenHeightDeveloper))
        tbl_Main.tableHeaderView = vw;
        
    }
    
    
    func checkSelectProductOrNot() -> Bool{
        
        if objProductDetailData.arr_Random_Key.count == 3{
            if lbl_SelectionAns1.text != "SELECT" && lbl_SelectionAns2.text != "SELECT" && lbl_SelectionAns3.text != "SELECT" && lbl_QTY.text != "SELECT"{
                return true
            }else
            {
                if lbl_SelectionAns1.text == "SELECT"{
                    let message = "Please select product " + ((objProductDetailData.arr_Random_Key[0] as? String)?.lowercased())!

                    //Alert show for Header
                    messageBar.MessageShow(title: message as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
                else  if lbl_SelectionAns2.text == "SELECT"{
                    let message = "Please select product " + ((objProductDetailData.arr_Random_Key[1] as? String)?.lowercased())!
                    
                    //Alert show for Header
                    messageBar.MessageShow(title: message as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
                else  if lbl_SelectionAns3.text == "SELECT"{
                    let message = "Please select product " + ((objProductDetailData.arr_Random_Key[2] as? String)?.lowercased())!
                    
                    //Alert show for Header
                    messageBar.MessageShow(title: message as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
                else  if lbl_QTY.text == "SELECT"{
                    //Alert show for Header
                    messageBar.MessageShow(title: "Please select product quantity.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
            }
        }else if objProductDetailData.arr_Random_Key.count == 2{
            if lbl_SelectionAns1.text != "SELECT" && lbl_SelectionAns2.text != "SELECT" && lbl_QTY.text != "SELECT"{
                return true
            }
            else{
                if lbl_SelectionAns1.text == "SELECT"{
                    let message = "Please select product " + ((objProductDetailData.arr_Random_Key[0] as? String)?.lowercased())!
                    
                    //Alert show for Header
                    messageBar.MessageShow(title: message as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
                else  if lbl_SelectionAns2.text == "SELECT"{
                    let message = "Please select product " + ((objProductDetailData.arr_Random_Key[1] as? String)?.lowercased())!
                    
                    //Alert show for Header
                    messageBar.MessageShow(title: message as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
                else  if lbl_QTY.text == "SELECT"{
                    //Alert show for Header
                    messageBar.MessageShow(title: "Please select product quantity.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
            }
        }else if objProductDetailData.arr_Random_Key.count == 1 {
            if lbl_SelectionAns1.text != "SELECT" && lbl_QTY.text != "SELECT"{
                return true
            }
            else
            {
                if lbl_SelectionAns1.text == "SELECT"{
                    let message = "Please select product " + ((objProductDetailData.arr_Random_Key[0] as? String)?.lowercased())!
                    
                    //Alert show for Header
                    messageBar.MessageShow(title: message as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
               
                else  if lbl_QTY.text == "SELECT"{
                    //Alert show for Header
                    messageBar.MessageShow(title: "Please select product quantity.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
            }
        }else if objProductDetailData.arr_Random_Key.count == 0 {
            return true
        }
        return false
    }
    func selectDefulatValueForColorSelection(color : String){
        var arr_Data2: [Any] = []
        let arr_Color: NSMutableArray = objProductDetailData.arr_ColorSelect
        for i in (0..<arr_Color.count) {
            let obj : ProductObject = arr_Color[i] as! ProductObject
            
            if obj.str_ColorName as String == lbl_Color.text! {
                let arr_ColorSub: NSMutableArray = obj.arr_ColorSize
                if arr_ColorSub.count != 0 {
                    
                    //First match data available than value continue other wise set default value
                    var bool_Key : Bool = false
                    var bool_Value : Bool = false
                    for j in (0..<arr_ColorSub.count) {
                        let obj2 : ProductObject = arr_ColorSub[j] as! ProductObject
                        
                        if lbl_Size.text  == obj2.str_ColorKey as String {
                            bool_Key = true
                            
                            if Int(lbl_QTY.text!)! <= Int(obj2.str_ColorValue as String)! {
                                bool_Value = true
                            }
                            break
                        }
                    }
                    
                    
                    let obj2 : ProductObject = arr_ColorSub[0] as! ProductObject
                    if bool_Key == false{
                        lbl_Size.text = obj2.str_ColorKey as String
                    }
                    
                    if bool_Value == false{
                        if obj2.str_ColorValue == "0"{
                            lbl_QTY.text = "0"
                        }else{
                            lbl_QTY.text = "1"
                        }
                    }
                }
                break
            }
        }
    }
    func selectQtyDependonSize(size : String){
        let arr_Color: NSMutableArray = objProductDetailData.arr_ColorSelect
        for i in (0..<arr_Color.count) {
            let obj : ProductObject = arr_Color[i] as! ProductObject
            
            if obj.str_ColorName as String == lbl_Color.text! {
                let arr_ColorSub: NSMutableArray = obj.arr_ColorSize
                if arr_ColorSub.count != 0 {
                    
                    //First match data available than value continue other wise set default value
                    var bool_Value : Bool = false
                    for j in (0..<arr_ColorSub.count) {
                        let obj2 : ProductObject = arr_ColorSub[j] as! ProductObject
                        
                        if lbl_Size.text  == obj2.str_ColorKey as String {
                            if Int(lbl_QTY.text!)! <= Int(obj2.str_ColorValue as String)! {
                                bool_Value = true
                            }
                            break
                        }
                    }
                    
                    
                    let obj2 : ProductObject = arr_ColorSub[0] as! ProductObject
                    if bool_Value == false{
                        if obj2.str_ColorValue == "0"{
                            lbl_QTY.text = "0"
                        }else{
                            lbl_QTY.text = "1"
                        }
                    }
                }
                break
            }
        }

    }
    @objc func headerSet_TableView() {
        
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
    func get_Addtocartdetail(type : String) -> String{
        
        if  objProductDetailData.str_ProductCategoryID == "4" {
            if type == "quanitiy" {
                return lbl_BookSizeSelected.text! as String
            }else if type == "color" {
                return lbl_BookSelected.text! as String
            }else if type == "size" {
                return "0"
            }
        }else{
            if type == "quanitiy" {
                return lbl_QTY.text! as String
            }else if type == "color" {
                return lbl_Color.text! as String
            }else if type == "size" {
                return lbl_Size.text! as String
            }
        }
        
        return ""
    }
    func coordinateRegionForCoordinates(coords: NSMutableArray, coordCount: Int,mapview:MKMapView) { //-> MKCoordinateRegion
        
        let center : CLLocationCoordinate2D = (coords[0] as? CLLocationCoordinate2D)!
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapview.setRegion(region, animated: true)
    }
    func reloadTable(){
        
        let btn = UIButton()
        btn.tag = 1
        self.btn_Section(btn)
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
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_HeaderProduct(_ sender : Any){
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
        view.str_ShopIDGet = objProductDetailData.str_ProductShopID
        self.navigationController?.pushViewController(view, animated: true)
    }
    @IBAction func btn_Color(_ sender : Any){
        
        if Int(objProductDetailData.str_Product_StockRemain as String)! >= 0{
            //Color set
            var arr_Data2: [Any] = []
            let arr_Color: NSMutableArray = objProductDetailData.arr_ColorSelect
            for i in (0..<arr_Color.count) {
                let obj : ProductObject = arr_Color[i] as! ProductObject
                arr_Data2.append(obj.str_ColorName)
            }
            
            
            let picker = ActionSheetStringPicker(title: "COLOR", rows: arr_Data2, initialSelection:selectedIndex(arr: arr_Data2 as NSArray, value: lbl_Color.text! as String as NSString), doneBlock: { (picker, indexes, values) in
                if arr_Data2.count != 0{
                    self.lbl_Color.text = values as! String?
                    self.selectDefulatValueForColorSelection(color: self.lbl_Color.text!)
                }
            
            }, cancel: {ActionSheetStringPicker in return}, origin: sender)

            picker?.hideCancel = false
            // picker?.hideWithCancelAction()
            picker?.setDoneButton(UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil))
            picker?.toolbarButtonsColor = UIColor.black
            
            picker?.show()
        }
    }
 
    @IBAction func btn_Quality(_ sender : Any){

        
        if objProductDetailData.arr_Random_BookPrize.count != 0{
//            if lbl_SelectionAns1.text != "SELECT"{
            if Int(objProductDetailData.str_Product_StockRemain as String)! >= 0{
                var arr_Data2: [Any] = []
                var int_Prize : Int = 0
                
                var int_Set : Int = Int(objProductDetailData.str_Product_StockRemain as String)!
                for j in (0..<int_Set) {
                    arr_Data2.append(String(j+1))
                }
                
                for j in (0..<objProductDetailData.arr_Random_1.count) {
                    if lbl_SelectionAns1.text?.capitalized == (objProductDetailData.arr_Random_1[j] as! String).capitalized{
                        
                        int_Prize = Int(objProductDetailData.arr_Random_BookPrize[j] as! String)!
                        break
                    }
                }
                
                let picker = ActionSheetStringPicker(title: "Quantity", rows: arr_Data2, initialSelection:selectedIndex(arr: arr_Data2 as NSArray, value: lbl_QTY.text! as String as NSString), doneBlock: { (picker, indexes, values) in
                    if arr_Data2.count != 0 {
                        self.lbl_QTY.text = values as! String?
                        
//                        var float_Value : Float = Float(self.objProductDetailData.str_ProductPrice)!
                        var float_Value : Float = 0.0
                        
                        //Price set with selected Number of item purchase
                        var int_Total : Int = Int(float_Value * Float((values as! String?)!)!)
                        //Add More cover photo prixe
                        int_Total = int_Total + (int_Prize * Int((values as! String?)!)!)
                        
                        self.lbl_ProductPrice.text = "\(self.objProductDetailData.str_ProductPriceSymbol as String)\(String(int_Total))"
                    }
                }, cancel: {ActionSheetStringPicker in return}, origin: sender)
                
                picker?.hideCancel = false
                picker?.setDoneButton(UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil))
                picker?.toolbarButtonsColor = UIColor.black
                
                picker?.show()
            }
        }else{
            if Int(objProductDetailData.str_Product_StockRemain as String)! >= 0{
                var arr_Data2: [Any] = []
                var int_Set : Int = Int(objProductDetailData.str_Product_StockRemain as String)!
                for j in (0..<int_Set) {
                    arr_Data2.append(String(j+1))
                }
                
                let picker = ActionSheetStringPicker(title: "Quantity", rows: arr_Data2, initialSelection:selectedIndex(arr: arr_Data2 as NSArray, value: lbl_QTY.text! as String as NSString), doneBlock: { (picker, indexes, values) in
                    if arr_Data2.count != 0 {
                        self.lbl_QTY.text = values as! String?
                        
                        var float_Value : Float = Float(self.objProductDetailData.str_ProductPrice)!

                        //Price set with selected Number of item purchase
                        var int_Total : Int = Int(float_Value * Float((values as! String?)!)!)
                        self.lbl_ProductPrice.text = "\(self.objProductDetailData.str_ProductPriceSymbol as String)\(String(int_Total))"
                    }
                }, cancel: {ActionSheetStringPicker in return}, origin: sender)
                
                picker?.hideCancel = false
                picker?.setDoneButton(UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil))
                picker?.toolbarButtonsColor = UIColor.black
                
                picker?.show()
            }
        }
    }
    @IBAction func btn_Size(_ sender : Any){
        
        if Int(objProductDetailData.str_Product_StockRemain as String)! >= 0{
            var int_Set : Int = 0
            //Color set
            var arr_Data2: [Any] = []
            let arr_Color: NSMutableArray = objProductDetailData.arr_ColorSelect
            for i in (0..<arr_Color.count) {
                let obj : ProductObject = arr_Color[i] as! ProductObject
                
                if obj.str_ColorName as String == lbl_Color.text! {
                    let arr_ColorSub: NSMutableArray = obj.arr_ColorSize
                    for j in (0..<arr_ColorSub.count) {
                        let obj2 : ProductObject = arr_ColorSub[j] as! ProductObject
                        arr_Data2.append(obj2.str_ColorKey)
                    }
                }
            }
            
            let picker = ActionSheetStringPicker(title: "SIZE", rows: arr_Data2, initialSelection:selectedIndex(arr: arr_Data2 as NSArray, value: lbl_Size.text! as String as NSString), doneBlock: { (picker, indexes, values) in
                if arr_Data2.count != 0{
                    self.lbl_Size.text = values as! String?
                    self.selectQtyDependonSize(size: self.lbl_Size.text!)
                }
            }, cancel: {ActionSheetStringPicker in return}, origin: sender)
            
            picker?.hideCancel = false
            picker?.setDoneButton(UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil))
            picker?.toolbarButtonsColor = UIColor.black
            
            picker?.show()
        }
    }
    @IBAction func btn_Book(_ sender : Any){
        //Color set
        var arr_Data2: [Any] = []
        let arr_Book: NSMutableArray = objProductDetailData.arr_BookSelect
        for i in (0..<arr_Book.count) {
            let obj : ProductObject = arr_Book[i] as! ProductObject
            arr_Data2.append(obj.str_BookName)
        }
        
        let picker = ActionSheetStringPicker(title: "COLOR", rows: arr_Data2, initialSelection:selectedIndex(arr: arr_Data2 as NSArray, value: lbl_BookSelected.text! as String as NSString), doneBlock: { (picker, indexes, values) in
            if arr_Data2.count != 0 {
                self.lbl_BookSelected.text = values as! String?
                self.selectDefulatValueForColorSelection(color: self.lbl_Color.text!)
            }
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
        picker?.hideCancel = false
        // picker?.hideWithCancelAction()
        picker?.setDoneButton(UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
        
    }
    @IBAction func btn_Book_Size(_ sender : Any){
        
        var arr_Data2: [Any] = []
        var int_Total : Int = Int(objProductDetailData.str_Product_StockRemain as String)!
        for j in (0..<int_Total) {
            arr_Data2.append(String(j+1))
        }
        
        let picker = ActionSheetStringPicker(title: "Quantity", rows: arr_Data2, initialSelection:selectedIndex(arr: arr_Data2 as NSArray, value: lbl_BookSizeSelected.text! as String as NSString), doneBlock: { (picker, indexes, values) in
            if arr_Data2.count != 0 {
                self.lbl_BookSizeSelected.text = values as! String?
                
                //Price set with selected Number of item purchase
                let int_Total : Int = Int((self.objProductDetailData.str_ProductPrice as String) as String)! * Int((values as! String?)!)!
                self.lbl_ProductPrice.text = "\(self.objProductDetailData.str_ProductPriceSymbol as String)\(String(int_Total))"
            }
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
        picker?.hideCancel = true
        picker?.setDoneButton(UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
        
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
            if objProductDetailData.str_ProductFav == "0" {
                btn_Fav.isSelected = true
                objProductDetailData.str_ProductFav = "1"
                img_Fav.image = UIImage.init(named: "icon_Save_Product_Selected")
                
                self.Post_Fav(flag : "1",Productid : objProductDetailData.str_ProductId as String)
                
            }else{
                btn_Fav.isSelected = false
                objProductDetailData.str_ProductFav = "0"
                img_Fav.image = UIImage.init(named: "icon_Save_Product")
                
                self.Post_Fav(flag : "0",Productid : objProductDetailData.str_ProductId as String)
            }
        }
      
    }
    @IBAction func btn_Share (_ sender : Any){
        shareFunction(textData : "I saw this product on Katika and wanted to share it with you \n\nProduct Name : \(objProductDetailData.str_ProductTitle as String)\n\nKatika is an International Directory and Marketplace where people around the world connect to find local businesses and buy and sell products.",image : self.img_ShopImage.image! ,viewPresent: self)
        
    }
    @IBAction func btn_CheckOut(_ sender : Any){

        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }else{
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
                self.navigationController?.pushViewController(view, animated: false)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }

    @IBAction func btn_Add_To_Cart(_ sender : Any){

        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }else{
            if btn_Add_To_Cart.titleLabel?.text != "Stock not avaialble" {
                if !btn_Add_To_Cart.isSelected {
                    if self.checkSelectProductOrNot() == true{
                        self.Post_addToCard()
                    }
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let view = storyboard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
                    self.navigationController?.pushViewController(view, animated: false)
                }
            }
            else{
                
                //Alert show for Header
                messageBar.MessageShow(title: "Sorry this product is not available in stock" as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }
        }
    }
    @IBAction func Sidebar_Right(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        self.navigationController?.pushViewController(view, animated: false)
    }
    @IBAction func btn_PlayProductVideo(_ sender: Any) {
        if objProductDetailData.str_Is_Youtube_Url == "0"{
            if objProductDetailData.str_ProductVideoURL != ""{
                self.playVideo(URL(string: objProductDetailData.str_ProductVideoURL as String)!)
            }
        }else{
            if let url = URL(string: objProductDetailData.str_ProductVideoURL as String){
                openURLToWeb(url : url)
            }
        }
    }
    
    //MARK: -- Global Selectino Method --
     @IBAction func btn_Selection1(_ sender: Any) {

        let str_Title = objProductDetailData.arr_Random_Key[0] as? String
        let picker = ActionSheetStringPicker(title: str_Title?.capitalized, rows: objProductDetailData.arr_Random_1 as! [Any], initialSelection:selectedIndex(arr: objProductDetailData.arr_Random_1, value: lbl_SelectionAns1.text! as String as NSString), doneBlock: { (picker, indexes, values) in
            if self.objProductDetailData.arr_Random_BookPrize.count != 0{
                self.lbl_QTY.text = "SELECT"
            }
            self.lbl_SelectionAns1.text = (values as! String?)?.uppercased()
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
        picker?.hideCancel = false
        // picker?.hideWithCancelAction()
        picker?.setDoneButton(UIBarButtonItem(title: "Select", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
        
    }
    @IBAction func btn_Selection2(_ sender: Any) {
        let str_Title = objProductDetailData.arr_Random_Key[1] as? String
        let picker = ActionSheetStringPicker(title: str_Title?.capitalized, rows: objProductDetailData.arr_Random_2 as! [Any], initialSelection:selectedIndex(arr: objProductDetailData.arr_Random_2, value: lbl_SelectionAns2.text! as String as NSString), doneBlock: { (picker, indexes, values) in
            
            self.lbl_SelectionAns2.text = (values as! String?)?.uppercased()
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
        picker?.hideCancel = false
        // picker?.hideWithCancelAction()
        picker?.setDoneButton(UIBarButtonItem(title: "Select", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
        
    }
    @IBAction func btn_Selection3(_ sender: Any) {
        let str_Title = objProductDetailData.arr_Random_Key[2] as? String
        let picker = ActionSheetStringPicker(title: str_Title?.capitalized, rows: objProductDetailData.arr_Random_3 as! [Any], initialSelection:selectedIndex(arr: objProductDetailData.arr_Random_3, value: lbl_SelectionAns3.text! as String as NSString), doneBlock: { (picker, indexes, values) in
            
            self.lbl_SelectionAns3.text = (values as! String?)?.uppercased()
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
        picker?.hideCancel = false
        // picker?.hideWithCancelAction()
        picker?.setDoneButton(UIBarButtonItem(title: "Select", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
        
    }
    
    //MARK: -- Tableview Method --
    @IBAction func btn_Section(_ sender: Any) {
        //Check if click on SIZE GUIDE section then move to size guide view
        if ((sender as AnyObject).tag) == 3 || ((sender as AnyObject).tag) == 3 {
            self.performSegue(withIdentifier: "sizeguide", sender: self)
        }else{
            //Get animation with table view reload data
            tbl_Main.beginUpdates()
            if ((tbl_reload_Number) != nil) {
                if (tbl_reload_Number.section == (sender as AnyObject).tag) {
                    
                    //Delete Cell
                    // let objDelete : PurchaseObject = arr_Main[tbl_reload_Number.section]
                    if tbl_reload_Number.section != 4 {
                        let arr_DeleteIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows: 1)
                        tbl_Main.deleteRows(at: arr_DeleteIndex as! [IndexPath], with: .automatic)
                    }else{
                        let arr_DeleteIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows: arr_Reviews.count+1)
                        tbl_Main.deleteRows(at: arr_DeleteIndex as! [IndexPath], with: .automatic)
                    }
                    
                    tbl_reload_Number = nil;
                }else{
                    //Delete Cell
                    // let objDelete : PurchaseObject = arr_Main[tbl_reload_Number.section]
                    
                    if tbl_reload_Number.section != 4 {
                        let arr_DeleteIndex = self.indexPaths(forSection: tbl_reload_Number.section, withNumberOfRows:1)
                        tbl_Main.deleteRows(at: arr_DeleteIndex as! [IndexPath], with: .automatic)
                    }else{
                        let arr_DeleteIndex = self.indexPaths(forSection: tbl_reload_Number.section, withNumberOfRows:arr_Reviews.count+1)
                        tbl_Main.deleteRows(at: arr_DeleteIndex as! [IndexPath], with: .automatic)
                    }
                    
                    
                    tbl_reload_Number = IndexPath(row: 0, section: (sender as AnyObject).tag) as NSIndexPath!
                    
                    //Add Cell
                    //let obj : PurchaseObject = arr_Main[(sender as AnyObject).tag]
                    
                    
                    if tbl_reload_Number.section != 4 {
                        let arr_AddIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows:1)
                        tbl_Main.insertRows(at: arr_AddIndex as! [IndexPath], with: .automatic)
                    }else{
                        let arr_AddIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows:arr_Reviews.count+1)
                        tbl_Main.insertRows(at: arr_AddIndex as! [IndexPath], with: .automatic)
                    }
                    
                }
            }else{
                tbl_reload_Number = IndexPath(row: 0, section: (sender as AnyObject).tag) as NSIndexPath!
                
                //Add Cell
                //let obj : PurchaseObject = arr_Main[(sender as AnyObject).tag]
                if tbl_reload_Number.section != 4 {
                    let arr_AddIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows: 1)
                    tbl_Main.insertRows(at: arr_AddIndex as! [IndexPath], with: .automatic)
                }else{
                    let arr_AddIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows: arr_Reviews.count+1)
                    tbl_Main.insertRows(at: arr_AddIndex as! [IndexPath], with: .automatic)
                }
            }
            
            tbl_Main.endUpdates()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.tbl_Main.reloadData()
                
            })
        }
        
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
    @IBAction func btn_Website (_
        sender : Any){
        
        if objProductDetailData.str_ProductShopWebsite as String != ""{
            let url = URL(string:objProductDetailData.str_ProductShopWebsite as String)!
            openURLToWeb(url : url)
        }
    }
    @IBAction func btn_Call (_ sender : Any){
        if let url = URL(string: "tel://\(objProductDetailData.str_ProductShop_PhoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func btn_Direction (_ sender : Any){
        let str_Start : String = objProductDetailData.str_ProductShop_Lat as String
        let str_End : String = objProductDetailData.str_ProductShop_Long as String
        let str_CurrentStart : String = String(format:"%.5f", (currentLocation?.coordinate.latitude)!)
        let str_CurrentEnd : String = String(format:"%.5f", (currentLocation?.coordinate.longitude)!)
        
        let directionsURL = "http://maps.apple.com/?saddr=\(str_CurrentStart),\(str_CurrentEnd)&daddr=\(str_Start),\(str_End)"
        UIApplication.shared.openURL(URL(string: directionsURL)!)
    }
   
    
    
    
    // MARK: - Get/Post Method -
    func Get_ProductDetail(){
        bool_Load = true
        
        //Declaration URL
//        let strURL = "\(Constant.BaseURL)get_products_details"
        let strURL = "\(Constant.BaseURL)get_products_details_new"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "skip" : "0",
            "total" : "20",
            "product_id" : str_ProductIDGet,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_products_details"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }
    
    func Post_recent_view_products(){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)recent_view_products"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
            "product_id" : str_ProductIDGet,
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
        let strURL = "\(Constant.BaseURL)addremove_favourite"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
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
    
    func Get_ShopReviews(shopID : NSString){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_shop_reviews"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "skip" : "0",
            "total" : "5",
            "shop_id" : shopID,
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
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
    }
    

    func Post_addToCard(){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)add_to_cart_new"
        
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "product_id" : str_ProductIDGet,
            "quantity" : lbl_QTY.text! as String,
//            "color" : get_Addtocartdetail(type:"color"),
//            "size" : get_Addtocartdetail(type:"size"),
        ]
        
        let arr_Temp : NSMutableArray = []
        for i in 0..<objProductDetailData.arr_Random_Key.count{
            switch i {
            case 0:
                let dict_Store : NSDictionary = [
                    objProductDetailData.arr_Random_Key[i] as! String : lbl_SelectionAns1.text,
                ]
                arr_Temp.add(dict_Store)
                break
            case 1:
                let dict_Store : NSDictionary = [
                    objProductDetailData.arr_Random_Key[i] as! String : lbl_SelectionAns2.text,
                    ]
                arr_Temp.add(dict_Store)
                break
            case 2:
                let dict_Store : NSDictionary = [
                    objProductDetailData.arr_Random_Key[i] as! String : lbl_SelectionAns3.text,
                    ]
                arr_Temp.add(dict_Store)
                break
            default:
                break
            }
        }
        
        let string = notPrettyString(from : arr_Temp)
        jsonData .setValue(string, forKey: "attrib")

        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "add_to_cart"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData as NSDictionary
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
            
            let objHere : ReviewObjet = arr_Reviews[sender as! Int] as! ReviewObjet
            
            let view : ReviewDetailViewController = segue.destination as! ReviewDetailViewController
            view.getObject = objHere
        }
    }
}

//MARK: - Product Object -

class ProductObject: NSObject {
    var str_Image_Header : NSString = ""
    var str_Title : NSString = ""
    
    var str_Productdetail : NSString = ""
    
    //Image Header
    var arr_ImageHeader : NSMutableArray = []
    var str_ImageProductID : NSString = ""
    var str_ImageProductURL : NSString = ""
    
    //Product Detail
    var str_ProductId : NSString = ""
    var str_ProductTitle : NSString = ""
    var str_ProductInfo : NSString = ""
    var str_ProductShippingAndReturn : NSString = ""
    var str_ProductReturn : NSString = ""
    var str_ProductVideoURL : NSString = ""
    var str_ProductDescription : NSString = ""
    var str_ProductPrice : String = ""
    //var str_ProductVideoURL : NSString = ""
    var str_ProductDiscountPrice : NSString = ""
    var str_ProductSite : NSString = ""
    var str_ProductFav : NSString = ""
    var str_ProductAddedInCart : NSString = ""
    var str_ProductPriceSymbol : NSString = ""
    var str_ProductCategoryID : NSString = ""
    var str_Product_StockRemain : NSString = ""
    var str_Is_Youtube_Url : NSString = ""
    
    //Shop Detail
    var str_ProductShopID : NSString = ""
    var str_ProductShopName : NSString = ""
    var str_ProductShopTitle : NSString = ""
    var str_ProductShopIcon : NSString = ""
    var str_ProductShopHR : NSString = ""
    var str_ProductShopDescription : NSString = ""
    var str_ProductShopWebsite : NSString = ""
    var str_ProductShopTwitter : NSString = ""
    var str_ProductShopFBLink : NSString = ""
    var str_ProductShop_logo : NSString = ""
    var str_ProductShop_Location : NSString = ""
    var str_ProductShop_Lat : NSString = ""
    var str_ProductShop_Long : NSString = ""
    var str_ProductShop_Distance : NSString = ""
    var str_ProductShop_PhoneNumber : NSString = ""
    var str_Product_Keyword: NSString = ""
    
    //Color
    var arr_ColorSelect : NSMutableArray = []
    var str_ColorName : NSString = ""
    var str_ColorKey : NSString = ""
    var str_ColorValue : NSString = ""
    var arr_ColorSize : NSMutableArray = []
    
    //Review
    var str_ReviewTitle : NSString = ""
    var str_ReviewStart : NSString = ""
    var str_ReviewID : NSString = ""
    var arr_ReviewComment : NSMutableArray = []
    var str_ReviewUploadType : NSString = ""
    var str_ReviewUploadURL : NSURL = NSURL(string: "")!
    var arr_MutlipleimagesAndVideo : NSMutableArray = []
    var arr_MutlipleimagesAndVideoType : NSMutableArray = []
    var url_VideoURL : URL = NSURL(string: "")! as URL
    
    //Review user
    var str_ReviewUserTitle : NSString = ""
    var str_ReviewUserRate : NSString = ""
    var str_ReviewUserComment : NSString = ""
    var str_ReviewUserImage : NSString = ""
    var str_ReviewUserType : NSString = ""
    var str_Thumb_Image : NSString = ""
    var arr_ReviewUserComment : NSMutableArray = []
    
    //Random Selection Option
    var str_Random_Title : NSString = ""
    var str_Random_Description : NSString = ""
    var arr_Random_1 : NSMutableArray = []
    var arr_Random_2 : NSMutableArray = []
    var arr_Random_3 : NSMutableArray = []
    var arr_Random_Key : NSArray = []
    var arr_Random_BookPrize : NSMutableArray = []
    var arr_Random_BookStock : NSMutableArray = []
    
    //Book
    var arr_BookSelect : NSMutableArray = []
    var str_BookName : NSString = ""
    var str_BookPrice : NSString = ""
    var str_BookQnt : NSString = ""
    
    //Cart List
    var str_CartTitle : NSString = ""
    var str_CartImage : NSString = ""
    var arr_CartList : NSMutableArray = []
    
    
    //Business Detail
    var str_Business_id : NSString = ""
    var str_Business_owner_id : NSString = ""
    var str_Business_name : NSString = ""
    var str_Business_image : NSString = ""
    var str_Business_title : NSString = ""
    var str_Business_location : NSString = ""
    var str_Business_distance : NSString = ""
    var str_Business_lat : NSString = ""
    var str_Business_long : NSString = ""
    var str_Business_email : NSString = ""
    var str_Phone_number : NSString = ""
    var str_Business_country : NSString = ""
    var str_Business_category : NSString = ""
    var str_Business_sub_category : NSString = ""
    var str_Website : NSString = ""
    var str_YoutubLink : NSString = ""
    var is_checkin : Int = 0
    var str_Checkin_date : NSString = ""

    var str_Explore_menu : NSString = ""
    var str_Business_description : NSString = ""
    var str_Avg_business_review : NSString = ""
    var str_Total_business_review : NSString = ""
    var str_Business_view_count : NSString = ""
    var str_Active_shop : NSString = ""
    var str_Is_approved : NSString = ""
    var str_Is_business_favourite : NSString = ""
    var str_TotalReview : NSString = ""
    var str_AvgReview : NSString = ""
    var str_BusinessVideo : NSString = ""
    var str_Category_name : NSString = ""
    var str_SubCategory_name : NSString = ""
    var str_Open_hr_json : NSString = ""
    var str_ExporeMenuShow : NSString = ""
    var str_FB : NSString = ""
    var str_Twitter : NSString = ""
    var str_Insta : NSString = ""

    var arr_Business_images : NSMutableArray = []
}


//MARK: - Collection View -
extension ProductDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returen number of cell with content available in array
        if cv_Main_Header == collectionView {
            
            if objProductDetailData.arr_ImageHeader.count != 0 {
                pg_Header.numberOfPages = objProductDetailData.arr_ImageHeader.count
                return objProductDetailData.arr_ImageHeader.count
            }
            return 0
        }else if cv_Main_PaymentCart == collectionView{
            return objProductDetailData.arr_CartList.count
        }
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Returen number of cell with content available in array
        if cv_Main_Header == collectionView {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else if cv_Main_PaymentCart == collectionView{
            return CGSize(width: 40, height: 30)
        }
        return CGSize(width: 0, height: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductViewCollectioncell
        
       if cv_Main_Header == collectionView {
        
            var arr_Image : NSMutableArray = objProductDetailData.arr_ImageHeader
        
            let obj : ProductObject = arr_Image[indexPath.row] as! ProductObject
        
            //Image set
            cell.img_Header.sd_setImage(with: URL(string: obj.str_ImageProductURL as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        
        }else if cv_Main_PaymentCart == collectionView{
        
            var arr_Image : NSMutableArray = objProductDetailData.arr_CartList
            
            let obj : ProductObject = arr_Image[indexPath.row] as! ProductObject
            
            //Image set
            cell.img_Cart.sd_setImage(with: URL(string: obj.str_CartImage as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if cv_Main_Header == collectionView {

            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductViewCollectioncell

            //Create arr for Slide image post to FTImageviewer
            var imageArray : [String] = []
            let arr_Image : NSMutableArray = objProductDetailData.arr_ImageHeader
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
extension ProductDetailViewController : UITableViewDelegate,UITableViewDataSource {
    // MARK: - Table View -
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 5;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //For data 0 section is map
        if section == 0 {
            print(objProductDetailData.str_ProductShop_Lat)
            if objProductDetailData.str_ProductShop_Lat as String == "" {
                return 0
            }else{
                return 1
            }
        }
        
        //If search and result 0 than show no data cell
        if ((tbl_reload_Number) != nil) {
            if (tbl_reload_Number.section == section) {
                //Count declaration
                //let obj : HomeObject = arr_Main[section]
                
                //Review Section 3
                if (section == 4){
                    if arr_Reviews.count != 0 {
                        return arr_Reviews.count + 1;
                    }
                }
                
                return 1;
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Review Section 0 map
        if (indexPath.section == 0){
            return 0
//            return 300
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 108
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Review Section 0 map
        if (section == 0 || section == 3){
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
        
        //Button Event
        cell.btn_Click.tag = section;
        cell.btn_Click.addTarget(self, action:#selector(btn_Section(_:)), for: .touchUpInside)
        
        //Mange Right arrow is selected or not set here
        cell.img_ImgLine.image = UIImage.init(named: "icon_Plus")
        if tbl_reload_Number != nil {
            if tbl_reload_Number.section == section {
                cell.img_ImgLine.image = UIImage.init(named: "icon_Subtract")
            }else{
                cell.img_ImgLine.isHidden = false
            }
        }
        
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
                cellIdentifier = "productdetail"
                break
            case 2:
                cellIdentifier = "shippingreturn"
                break
            case 4:
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
        
        print(indexPath.section)
        if(indexPath.section == 0 ) {
            //Create cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! ProductTableviewCell
            cell.vw_MapView.delegate = self
            
//            // Add annotations to the manager.
            let arr_Location : NSMutableArray = []
            let annotation = Annotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(objProductDetailData.str_ProductShop_Lat as String)!, longitude: Double(objProductDetailData.str_ProductShop_Long as String)!)
            annotation.title = "SHOP LOCATION"
            
            let color = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
            annotation.type = .image(UIImage(named: "pin")?.filled(with: color))
            arr_Location.add(annotation.coordinate)
            
            let myAnnotation: MKPointAnnotation = MKPointAnnotation()
            myAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(objProductDetailData.str_ProductShop_Lat as String)!, longitude: Double(objProductDetailData.str_ProductShop_Long as String)!)
            myAnnotation.title = objProductDetailData.str_ProductShopName as String
            cell.vw_MapView.addAnnotation(myAnnotation)
            
            self.coordinateRegionForCoordinates(coords: arr_Location, coordCount: arr_Location.count,mapview:cell.vw_MapView)
            
            //Fill data
            cell.btn_Website.addTarget(self, action: #selector(self.btn_Website(_:)), for:.touchUpInside)
            cell.btn_Call.addTarget(self, action: #selector(self.btn_Call(_:)), for:.touchUpInside)
            cell.btn_Direction.addTarget(self, action: #selector(self.btn_Direction(_:)), for:.touchUpInside)
            cell.btn_Direction.addTarget(self, action: #selector(self.btn_Direction(_:)), for:.touchUpInside)

            cell.lbl_Website.text = objProductDetailData.str_ProductShopWebsite as String
            cell.lbl_WebDirection.text = objProductDetailData.str_ProductShop_Distance as String
            cell.lbl_CallShop.text = objProductDetailData.str_ProductShop_PhoneNumber as String
    
            return cell
        }else if(indexPath.section != 4 ) {
            //Create cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! ProductTableviewCell
            
            //Assign text
            switch indexPath.section {
                case 1:
                    let attrPolicy = try! NSAttributedString(
                        data: objProductDetailData.str_ProductInfo.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
                        options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([ convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html)]),
                        documentAttributes: nil)
//                    tv_Policy.attributedText = attrPolicy
                    cell.lbl_ProductDetail.attributedText = attrPolicy
//                    cell.lbl_ProductDetail.text = objProductDetailData.str_ProductInfo  as String
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

        }else{
    
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for:indexPath as IndexPath) as! ReviewTableviewCell
            
            if indexPath.row != arr_Reviews.count{

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
        
        if indexPath.section == 4 {

            if indexPath.row == arr_Reviews.count{
                if arr_Reviews.count != 0 {
                    let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewFullListingViewController") as! ReviewFullListingViewController
                    view.str_ShopIDGet = objProductDetailData.str_ProductShopID
                    self.navigationController?.pushViewController(view, animated: true)
                }
            }else{
                self.performSegue(withIdentifier: "reivewpreview", sender: indexPath.row)
                
            }
        }
    }
}

//MARK: - Tableview View Cell -
class ProductTableviewCell : UITableViewCell{
    //Header view in cell
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_SelectedArrow: UIImageView!
    @IBOutlet weak var img_ImgLine: UIImageView!
    
    @IBOutlet var btn_Click: UIButton!
    
    //Product Detail view
    @IBOutlet weak var lbl_ProductDetail: UILabel!
    @IBOutlet weak var lbl_ShippingPolicy: UILabel!
    @IBOutlet weak var lbl_ReturnPolicy: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    
    //Map view section
    @IBOutlet weak var vw_MapView: MKMapView!
    @IBOutlet weak var lbl_WebDirection: UILabel!
    @IBOutlet weak var lbl_CallShop: UILabel!
    @IBOutlet weak var lbl_Website: UILabel!
    @IBOutlet weak var lbl_WebUrl: UILabel!
    @IBOutlet weak var btn_Website: UIButton!
    @IBOutlet weak var btn_Call: UIButton!
    @IBOutlet weak var btn_Direction: UIButton!
    @IBOutlet weak var btn_Address: UIButton!
    @IBOutlet weak var btn_More: UIButton!
    @IBOutlet weak var con_weburl: NSLayoutConstraint!
    @IBOutlet weak var imgWebUrl: UIImageView!
    @IBOutlet weak var imgWebsite: UIImageView!

    //CERTIFICAT VIEW
    @IBOutlet weak var imgCertificat: UIImageView!
    @IBOutlet weak var lblCerName: UILabel!
    @IBOutlet weak var lblCerSubName: UILabel!
    
    //Collection view
    @IBOutlet weak var cv_Photos: UICollectionView!
}


//MARK: - Collection View Cell -
class ProductViewCollectioncell : UICollectionViewCell{
    //Cell for Header
    @IBOutlet weak var img_Header: UIImageView!
    @IBOutlet weak var img_BG: UIImageView!
    
    //Cell for Cart
    @IBOutlet weak var img_Cart: UIImageView!
}

extension ProductDetailViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        
        let response = data as! NSDictionary
        if strRequest == "get_products_details" {
            self.completedServiceCalling()
            tbl_Main.isHidden = false
            img_ShareIcon_Header.isHidden = false
            
            //Product detail
            let arr_result = response["Result"] as! NSArray
            let dict_Product = arr_result[0] as! NSDictionary
            let arr_Image = dict_Product["product_images"] as! NSArray
            let arr_Color = dict_Product["ProductAttrib"] as! NSArray
            let arr_ReviewDetail = dict_Product["review_detail"] as! NSArray
            let arr_Book = dict_Product["GetBookAttribute"] as! NSArray
            let arr_Cart = dict_Product["paymentmethod"] as! NSArray
            let arr_RandomSelection = dict_Product["ProductAttrib"] as! NSArray
            let arr_MyReviewDetail = dict_Product["review_added_detail"] as! NSArray

            
            let obj = ProductObject ()
            obj.str_ProductId = ("\(dict_Product["product_id"] as! Int)" as NSString)
            obj.str_ProductTitle = dict_Product["p_title"] as! NSString
            obj.str_ProductInfo = dict_Product["product_info"] as! NSString
            obj.str_ProductShippingAndReturn = dict_Product["shipping_policy"] as! NSString
            obj.str_ProductReturn = dict_Product["return_policy"] as! NSString
            obj.str_ProductVideoURL = dict_Product["product_video"] as! NSString
            obj.str_ProductDescription = dict_Product["p_descriiption"] as! NSString
            obj.str_ProductPrice = dict_Product.getStringForID(key:"price") ?? ""
            obj.str_ProductDiscountPrice = ("\(dict_Product["discount_price"] as! Double)" as NSString)
            obj.str_ProductFav = ("\(dict_Product["is_favourite"] as! Int)" as NSString)
            obj.str_ProductAddedInCart = ("\(dict_Product["is_added_incart"] as! Int)" as NSString)
            obj.str_ProductPriceSymbol = dict_Product["price_symbole"] as! NSString
            obj.str_ProductCategoryID = ("\(dict_Product["ProductCategoryID"] as! Int)" as NSString)
            obj.str_Product_StockRemain = ("\(dict_Product["stock_remain"] as! Int)" as NSString)
            obj.str_Is_Youtube_Url = dict_Product.getStringForID(key:"is_youtube_url") as! NSString
            
            //Product Image
            let arr_TempImage : NSMutableArray = []
            for i in (0..<arr_Image.count) {
                let dict_ImageData = arr_Image[i] as! NSDictionary
            
                //Other Tab Demo data
                let objImage = ProductObject ()
                objImage.str_ImageProductID = ("\(dict_ImageData["product_id"] as! Int)" as NSString)
                objImage.str_ImageProductURL = dict_ImageData["image"] as! NSString
                
                arr_TempImage.add(objImage)
            }
            obj.arr_ImageHeader = arr_TempImage
            
            //Shop Detail
            let arr_ShopDetail = response["ShopDetails"] as! NSArray
            let dict_ShopDetail = arr_ShopDetail[0] as! NSDictionary
            obj.str_ProductShopID = ("\(dict_ShopDetail["shop_id"] as! Int)" as NSString)
            obj.str_ProductShopName = dict_ShopDetail["shop_name"] as! NSString
            obj.str_ProductShopTitle = dict_ShopDetail["shop_title"] as! NSString
            obj.str_ProductShopHR = dict_ShopDetail["open_hr"] as! NSString
            obj.str_ProductShopDescription = dict_ShopDetail["shop_description"] as! NSString
            obj.str_ProductShopWebsite = dict_ShopDetail["website"] as! NSString
            obj.str_ProductShopTwitter = dict_ShopDetail["twitter"] as! NSString
            obj.str_ProductShopFBLink = dict_ShopDetail["fblink"] as! NSString
            obj.str_ProductShop_logo = dict_ShopDetail["shop_logo"] as! NSString
            obj.str_ProductShop_Location = dict_ShopDetail["shop_location"] as! NSString
            obj.str_ProductShop_Lat = dict_ShopDetail["shop_lat"] as! NSString
            obj.str_ProductShop_Long = dict_ShopDetail["shop_long"] as! NSString
            obj.str_ProductShop_Distance = "5 min walk"
            obj.str_ProductShop_PhoneNumber = "(215)476-9455"
            
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
            
            obj.arr_Random_1 = []
            obj.arr_Random_2 = []
            obj.arr_Random_3 = []
            obj.arr_Random_BookPrize = []
            obj.arr_Random_BookStock = []
            
            if arr_MyReviewDetail.count != 0{
                let dict_Review = arr_ReviewDetail[0] as! NSDictionary
                
                obj.str_ReviewUserRate = dict_Review.getStringForID(key:"rate") as! NSString
                obj.str_ReviewUserTitle = dict_Review.getStringForID(key:"review") as! NSString
            }
            
            
            if arr_Book.count != 0{
                var arr_Key : NSArray = ["Cover"]
                obj.arr_Random_Key = arr_Key
                
//                for i in (0..<arr_Book.count) {
                    let dict_ImageData = arr_Book[0] as! NSDictionary
                    let arr_Key2 : NSArray = dict_ImageData.allKeys as NSArray
                
                    for i in (0..<arr_Key2.count) {
                        obj.arr_Random_1.add(arr_Key2[i] as! String)
                        obj.arr_Random_BookPrize.add(dict_ImageData[arr_Key2[i] as! String] as! String)
                        obj.arr_Random_BookStock.add("")
                    }
//                }
            }else{
                
                var arr_Key : NSArray = []
                for i in (0..<arr_RandomSelection.count) {
                    let dict_Review = arr_RandomSelection[i] as! NSDictionary
                    if i == 0{
                        arr_Key = dict_Review.allKeys as NSArray
                        obj.arr_Random_Key = arr_Key
                    }
                    for i in (0..<arr_Key.count) {
                        switch i {
                        case 0:
                            if !obj.arr_Random_1.contains(dict_Review[arr_Key[i] as! String] as! String){
                                obj.arr_Random_1.add(dict_Review[arr_Key[i] as! String] as! String)
                            }
                            break
                        case 1:
                            if !obj.arr_Random_2.contains(dict_Review[arr_Key[i] as! String] as! String){
                                obj.arr_Random_2.add(dict_Review[arr_Key[i] as! String] as! String)

                            }
                            break
                        case 2:
                            if !obj.arr_Random_3.contains(dict_Review[arr_Key[i] as! String] as! String){
                                obj.arr_Random_3.add(dict_Review[arr_Key[i] as! String] as! String)
                            }
                            break
                        default:
                            break
                            
                        }
                    }
                }
                
                
                //Manage Product review by user
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
                
                //Cart available list
                obj.arr_CartList = []
                if arr_Cart.count != 0 {
                    
                    for i in (0..<arr_Cart.count) {
                        let dict_CartMain = arr_Cart[i] as! NSDictionary
                        
                        let obj2 = ProductObject ()
                        obj2.str_CartTitle = dict_CartMain["payname"] as! NSString
                        obj2.str_CartImage = dict_CartMain["payimage"] as! NSString
                        obj.arr_CartList.add(obj2)
                    }
                }
            }
//            obj.arr_CartList = arr_CartColor
            
            //Save local object to global object
            objProductDetailData = obj
            
            tbl_Main.reloadData()
            cv_Main_Header.reloadData()
            cv_Main_PaymentCart.reloadData()
            
            self.manageDataFill()
            self.Get_ShopReviews(shopID:objProductDetailData.str_ProductShopID)
            self.reloadTable()
//            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)

            
        }else if strRequest == "addremove_favourite" {
            
        }else if strRequest == "recent_view_products" {
            
        }else if strRequest == "get_shop_reviews" {
            
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
        }else if strRequest == "add_to_cart" {
            btn_Add_To_Cart.isSelected = true
            
            var int_Count : Int = Int((objUser?.str_CardCount as! NSString) as String)! + 1
            
            objUser?.str_CardCount = String(int_Count) as NSString
            saveCustomObject(objUser!, key: "userobject");
            
            btn_NavRight.badgeString = objUser?.str_CardCount as! String
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
        self.completedServiceCalling()
    }
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

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

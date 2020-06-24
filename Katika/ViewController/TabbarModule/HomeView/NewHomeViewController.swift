//
//  NewHomeViewController.swift
//  Katika
//
//  Created by Apple on 02/04/19.
//  Copyright © 2019 icoderz123. All rights reserved.
//

import UIKit
import Firebase
import MIBadgeButton_Swift
import Crashlytics


class NewHomeViewController: UIViewController {
    //COLLECTION VIEW
    @IBOutlet weak var objHeader: UICollectionView!
    @IBOutlet weak var objBanner: UICollectionView!
    @IBOutlet var pg_Header : UIPageControl!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewForYou: UITableView!

    //OTHER VALUE
    var selectHeaderIndex : Int = 0
    var arrHeaderForeYou : NSMutableArray = []
    var arrHeader : NSMutableArray = []
    var arr_Featured : NSMutableArray = []
    var arr_Latest : NSMutableArray = []
    var arr_Recommended : NSMutableArray = []
    var arr_RecentlyViewed : NSMutableArray = []
    var timer_Adverticement = Timer()
    var timer_Value : Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Crashlytics.sharedInstance().crash()

        //SET VIEEW
        tblView.isHidden = true
        tblViewForYou.isHidden = true
        
        //SET VIEW
        commanMethod()
        Get_ExploreAndForeYouList()
        Get_ProductList()
        
        //RELOAD HEADER VIEW
        objHeader.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer_Adverticement.invalidate()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //SET NAVIGATION
        self.manageNavigation()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    //MARK: - Other Files -
    func commanMethod(){
        
        //Table view header heigh set
        let vw : UIView = tblView.tableHeaderView!
        vw.frame = CGRect(x: 0, y: 0, width: CGFloat(Constant.windowWidth), height: CGFloat((Constant.windowHeight * 180)/Constant.screenHeightDeveloper))
        tblView.tableHeaderView = vw;
        
        
        //SET PAGE
        //Page header color set
        pg_Header.pageIndicatorTintColor = UIColor(patternImage:UIImage(named: "img_Page")!)
        pg_Header.currentPageIndicatorTintColor = UIColor(red: CGFloat((207 / 255.0)), green: CGFloat((198 / 255.0)), blue: CGFloat((188 / 255.0)), alpha: CGFloat(1.0))
    }
    func manageNavigation(){
        
        let titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 150, height: 28))
        titleView.contentMode = .scaleAspectFit
        titleView.image = UIImage(named: "katikaTextNavigation")
        
        self.navigationItem.titleView = titleView
        
        //Right Bar Navigation button set
        let navButton = MIBadgeButton()
        navButton.frame = CGRect(x: 0, y: 0, width: 35, height: 44)
        navButton.setImage(UIImage(named: "icon_MyStore"), for: .normal)
        navButton.addTarget(self, action: #selector(self.Sidebar_Right(_:)), for:.touchUpInside)
        navButton.badgeString = objUser?.str_CardCount as? String
        navButton.badgeTextColor = UIColor.white
        navButton.badgeEdgeInsets = UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 18)
        
        let barButton = UIBarButtonItem()
        barButton.customView = navButton
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    //MARK: - Scrollview Delegate -
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if objBanner == scrollView{
            let visibleRect = CGRect(origin: objBanner.contentOffset, size: objBanner.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let indexPath = objBanner.indexPathForItem(at: visiblePoint)
            
            //SET PAGE
            pg_Header.currentPage = (indexPath?.row)!
            timer_Value = (indexPath?.row)!
        }
    }

    @objc func reloadHeder(){
        if arrHeaderForeYou.count != 0{
            let int_Count = timer_Value + 1
            if int_Count < arrHeaderForeYou.count {
                timer_Value = timer_Value + 1
            }else{
                timer_Value = 0
            }
            
            let indexpathSelect : NSIndexPath = NSIndexPath(row:timer_Value, section: 0)
            pg_Header.currentPage = (indexpathSelect.row)
            objBanner.scrollToItem(at: indexpathSelect as IndexPath, at: UICollectionView.ScrollPosition.left, animated: true)
        }
        
        //        HomePageViewController.scrollToViewController(index: index)
    }
    
    // MARK: - Get/Post Method -
    func Get_ExploreAndForeYouList(){
        
        //Declaration URL
        var strURL : String = ""
        var stName : String = ""
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()

        if selectHeaderIndex == 0{
            strURL = "\(Constant.BaseURL)get_products"
            stName = "get_products"
            
            //SET DICTONARY
            jsonData = [
                "user_id" : objUser?.str_Userid ?? "",
                "skip" : "0",
                "total" : "10",
                "type" : "Featured"
            ]
            
        }else if selectHeaderIndex == 1{
            strURL = "\(Constant.BaseURL)getForyou"
            stName = "getForyou"
            
            //SET DICTONARY
            jsonData = [
                "user_id" : objUser?.str_Userid ?? ""
            ]
        }
        
        
       
        
      
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = stName
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()

    }
    
    func Get_ProductList(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)allProductsViews"
        
        
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid ?? ""
        ]
        
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "allProductsViews"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
        
    }

    // MARK: - BUTTON ACTION
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
    @IBAction func Sidebar_Right(_ sender: Any) {
        self.performSegue(withIdentifier: "checkout", sender: self)
    }
    
    
    // MARK: - TabBar Button -
    @IBAction func btn_Tab_Home(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_home", parameters: nil)
        
        vw_BaseView?.callmethod(_int_Value: 0)
    }
    @IBAction func btn_Tab_Fav(_ sender: Any) {
        
        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }
        else{
            //SET ANALYTICS
            Analytics.logEvent("tab_favorite", parameters: nil)
            
            vw_BaseView?.callmethod(_int_Value: 1)
        }
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
    

}


//............................. Collection View Cell .............................//
//MARK: - Collection View Cell -
class NewHomeViewCollectioncell : UICollectionViewCell{
    //Cell for tabbar
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img_Seleted: UIImageView!
    @IBOutlet weak var lblSellAll: UILabel!

    //cell for header view
    @IBOutlet weak var lbl_Title_Header : UILabel!
    @IBOutlet weak var lbl_SubTitle_Header : UILabel!
    @IBOutlet weak var lbl_PrizeFinal_Header : UILabel!
    @IBOutlet weak var lbl_PrizeMainPrice_Header : UILabel!
    @IBOutlet weak var img_Image_Header : UIImageView!
    
    //cell for in cell product
    @IBOutlet weak var img_Product : UIImageView!
    
    //Other Tab
    @IBOutlet weak var lbl_Title_OtherTab : UILabel!
    @IBOutlet weak var lbl_SubTitle_OtherTab : UILabel!
    @IBOutlet weak var lbl_Prize_OtherTab : UILabel!
    @IBOutlet weak var img_Image_OtherTab : UIImageView!
    @IBOutlet weak var vw_Back_OtherTab : UIView!
}





//MARK: - Collection View -
extension NewHomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returen number of cell with content available in array
        if objHeader == collectionView {
            return 2
        }
        else if objBanner == collectionView {
            pg_Header.numberOfPages = arrHeaderForeYou.count
            if arrHeaderForeYou.count == 0{
                return 1
            }
            return arrHeaderForeYou.count
        }
        else if collectionView.tag == 101{
            if arr_Featured.count != 0{
                return arr_Featured.count + 1
            }
        }
        else if collectionView.tag == 102{
            if arr_Latest.count != 0{
                return arr_Latest.count + 1
            }
        }
        else if collectionView.tag == 103{
            if arr_Recommended.count != 0{
                return arr_Recommended.count + 1
            }
        }
        else if collectionView.tag == 104{
            if arr_RecentlyViewed.count != 0{
                return arr_RecentlyViewed.count + 1
            }
        }
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Returen number of cell with content available in array
        if objHeader == collectionView {
            return CGSize(width: objHeader.frame.size.width / 2, height: objHeader.frame.size.height)
        }
        else if objBanner == collectionView{
            return CGSize(width: objBanner.frame.size.width, height: objBanner.frame.size.height)
        }
        else{
            return CGSize(width: CGFloat(manageFont(font: 130)), height: CGFloat(manageFont(font: 150)))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var str_Identifier : String = "NewHomeViewCollectioncell"
        if objHeader == collectionView {
        }
        else if objBanner == collectionView{
            pg_Header.isHidden = false
            if arrHeaderForeYou.count == 0{
                str_Identifier = "nodata"
                pg_Header.isHidden = true
            }
        }
        else{
            if collectionView.tag == 101{
                if arr_Featured.count == indexPath.row {
                    str_Identifier = "SeeAll"
                }
            }
            else if collectionView.tag == 102{
                if  arr_Latest.count == indexPath.row {
                    str_Identifier = "SeeAll"
                }
            }
            else if collectionView.tag == 103{
                if  arr_Recommended.count == indexPath.row {
                    str_Identifier = "SeeAll"
                }
            }
            else if collectionView.tag == 104{
                if arr_RecentlyViewed.count == indexPath.row {
                    str_Identifier = "SeeAll"
                }
            }
        }
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: str_Identifier, for: indexPath) as! NewHomeViewCollectioncell
        
        if objHeader == collectionView {
            if indexPath.row == 0{
                //Set text in label
                cell.lblTitle.text = "Explore"
            }
            else{
                //Set text in label
                cell.lblTitle.text = "Katika Picks"
                
            }
            
            //Seleted Image always false only selected state they show
            cell.img_Seleted.isHidden = true
            if selectHeaderIndex == indexPath.row {
                cell.img_Seleted.isHidden = false
            }
            
            //Set font size and font name in title
            cell.lblTitle.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
            
    
            
        }
        else if objBanner == collectionView {
            
            if selectHeaderIndex == 0{
                if arrHeaderForeYou.count != 0 {
                    //Set font size and font name in title
                    cell.lblTitle.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 16)/Constant.screenWidthDeveloper))
                    
                    let obj : HomeObject = arrHeaderForeYou[indexPath.row] as! HomeObject
                    
                    cell.lblTitle.isHidden = true
                    if selectHeaderIndex == 1{
                        cell.lblTitle.isHidden = false
                        //SET DETAILS
                        cell.lblTitle.text = obj.str_Title as String
                    }
                    
                    //Image set
                    cell.img_Image_Header.sd_setImage(with: URL(string: obj.str_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                }
            }
            
        }
        else{
             if collectionView.tag == 101 && arr_Featured.count == indexPath.row{
                cell.lblSellAll.text = "See All >"
                cell.lblSellAll.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 18)/Constant.screenWidthDeveloper))
                cell.lblSellAll.isHidden = false
                
            }
            else if collectionView.tag == 102 && arr_Latest.count == indexPath.row{
                cell.lblSellAll.text = "See All >"
                cell.lblSellAll.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 18)/Constant.screenWidthDeveloper))
                cell.lblSellAll.isHidden = false
            }
            else if collectionView.tag == 103 && arr_Recommended.count == indexPath.row{
                cell.lblSellAll.text = "See All >"
                cell.lblSellAll.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 18)/Constant.screenWidthDeveloper))
                cell.lblSellAll.isHidden = false
            }
            else if collectionView.tag == 104 && arr_RecentlyViewed.count == indexPath.row{
                cell.lblSellAll.text = "See All >"
                cell.lblSellAll.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 18)/Constant.screenWidthDeveloper))
                cell.lblSellAll.isHidden = false
            }
            else{
                //SET TILE FONT
                cell.lbl_Title_OtherTab.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 12)/Constant.screenWidthDeveloper))
                cell.lbl_SubTitle_OtherTab.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 8)/Constant.screenWidthDeveloper))
                cell.lbl_Prize_OtherTab.font = UIFont(name: Constant.kFontSemiBold, size: CGFloat((Constant.windowWidth * 10)/Constant.screenWidthDeveloper))
                
                var obj =  HomeObject()
                if collectionView.tag == 101 {
                    obj = arr_Featured[indexPath.row] as! HomeObject
                }
                else if collectionView.tag == 102 {
                    obj = arr_Latest[indexPath.row] as! HomeObject
                }
                else if collectionView.tag == 103 {
                    obj = arr_Recommended[indexPath.row] as! HomeObject
                }
                else if collectionView.tag == 104 {
                    obj = arr_RecentlyViewed[indexPath.row] as! HomeObject
                }
                
              
                //Set text in label
                cell.lbl_Title_OtherTab.text = obj.str_Title_OtherTab as String
                cell.lbl_SubTitle_OtherTab.text = obj.str_ShopName_OtherTab as String
                
                let int_Value = obj.str_Prize_OtherTab as String
                cell.lbl_Prize_OtherTab.text = ("\(obj.str_PriceSymbol_OtherTab as String)\(int_Value)")
                
                print("========== \(collectionView.tag) ==========")
                print(obj.str_Title_OtherTab)
                print(obj.str_ShopName_OtherTab)
                print("\(obj.str_PriceSymbol_OtherTab as String)\(int_Value)")
                

                //SET PRODUCT IMAGE
                let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
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
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if objHeader == collectionView {
            selectHeaderIndex = indexPath.row
            //CALL API
            Get_ExploreAndForeYouList()
        }
        else if objBanner == collectionView{
            var obj = HomeObject ()

            if selectHeaderIndex == 0{
                if arrHeaderForeYou.count != 0{
                    //EXPLOR
                    obj = arrHeaderForeYou[indexPath.row] as! HomeObject
                    if obj.str_Title == "PRO"{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
                        view.str_ProductIDGet = obj.str_ID
                        self.navigationController?.pushViewController(view, animated: false)
                    }else{
                        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
                        view.str_ShopIDGet = obj.str_ID
                        self.navigationController?.pushViewController(view, animated: true)
                    }
                }
                
            }
        }
        else {
            
            //MOVE PROFUCT DETAILS SCREEN
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "HomeProductListViewController") as! HomeProductListViewController
            //SET NAME
            if collectionView.tag == 101 && arr_Featured.count == indexPath.row{
                view.strheaderName = "Featured"
                view.selectIndex = collectionView.tag
                self.navigationController?.pushViewController(view, animated: true)
                
            }
            else if collectionView.tag == 102 && arr_Latest.count == indexPath.row{
                view.strheaderName = "Latest"
                view.selectIndex = collectionView.tag
                self.navigationController?.pushViewController(view, animated: true)
            }
            else if collectionView.tag == 103 &&  arr_Recommended.count == indexPath.row {
                view.strheaderName = "Recommended"
                view.selectIndex = collectionView.tag
                self.navigationController?.pushViewController(view, animated: true)
            }
            else if collectionView.tag == 104 && arr_RecentlyViewed.count == indexPath.row {
                view.strheaderName = "Recently Viewed"
                view.selectIndex = collectionView.tag
                self.navigationController?.pushViewController(view, animated: true)
            }
            else{
                var obj =  HomeObject()
                if collectionView.tag == 101 {
                    obj = arr_Featured[indexPath.row] as! HomeObject
                }
                else if collectionView.tag == 102 {
                    obj = arr_Latest[indexPath.row] as! HomeObject
                }
                else if collectionView.tag == 103 {
                    obj = arr_Recommended[indexPath.row] as! HomeObject
                }
                else if collectionView.tag == 104 {
                    obj = arr_RecentlyViewed[indexPath.row] as! HomeObject
                }
                
                //MOVE PROFUCT DETAILS SCREEN
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
                view.str_ProductIDGet = obj.str_ID_OtherTab
                self.navigationController?.pushViewController(view, animated: true)
            }
          
        }
        
    }
}



//............................. Table View Cell .............................//

class NewHomeTableviewCell : UITableViewCell{
    //MARK: - Tableview View Cell -
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgForeYou: UIImageView!
    @IBOutlet weak var objColllectionView: UICollectionView!
}


// MARK: - Tableview Files -
extension NewHomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tblViewForYou == tableView{
            return  CGFloat(manageFont(font: 130))
        }
        else{
            //SET NAME
            if indexPath.row == 0{
                if arr_Featured.count == 0{
                    return 0
                }
            }
            else if indexPath.row == 1{
                if arr_Latest.count == 0{
                    return 0
                }
            }
            else if indexPath.row == 2{
                if arr_Recommended.count == 0{
                    return 0
                }
            }
            else if indexPath.row == 3{
                if arr_RecentlyViewed.count == 0{
                    return 0
                }
            }
            return CGFloat(manageFont(font: 190))

//            print(arr_Featured)
//            else if arr_Latest.count != 0{
//            }
//            else if arr_Recommended.count != 0{
//                return CGFloat(manageFont(font: 190))
//            }
//            else if arr_RecentlyViewed.count != 0{
//                return CGFloat(manageFont(font: 190))
//            }
//            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tblViewForYou == tableView{
            return arrHeaderForeYou.count
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewHomeTableviewCell", for:indexPath as IndexPath) as! NewHomeTableviewCell
        
        if tblViewForYou == tableView{
            
            if arrHeaderForeYou.count != 0 {
                //Set font size and font name in title
                cell.lblTitle.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 18)/Constant.screenWidthDeveloper))
                
                //GET DATA
                let obj : HomeObject = arrHeaderForeYou[indexPath.row] as! HomeObject
                
                //SET DETAILS
                cell.lblTitle.text = obj.str_Title as String

                //Image set
                cell.imgForeYou.sd_setImage(with: URL(string: obj.str_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
            }
        }
        else{
            //SET FONT
            cell.lblTitle.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 16)/Constant.screenWidthDeveloper))
            
            //SET NAME
            if indexPath.row == 0{
                cell.lblTitle.text = "Featured"
            }
            else if indexPath.row == 1{
                cell.lblTitle.text = "New Arrivals"
            }
            else if indexPath.row == 2{
                cell.lblTitle.text = "Recommended"
            }
            else if indexPath.row == 3{
                cell.lblTitle.text = "Recently Viewed"
            }
            
            //SET VIEW
            cell.lblTitle.isHidden = true
            
//            //RLOAD COLLECTION VIEW
//            if arr_Featured.count != 0 {
                //SET VIEW
                cell.lblTitle.isHidden = false
                
                //SET COLLECTIONVIEW TAG
                cell.objColllectionView.tag = indexPath.row + 101
                cell.objColllectionView.reloadData()
                
//            }
//            //RLOAD COLLECTION VIEW
//            if arr_Latest.count != 0 {
//                //SET VIEW
//                cell.lblTitle.isHidden = false
//                
//                //SET COLLECTIONVIEW TAG
//                cell.objColllectionView.tag = indexPath.row + 101
//                cell.objColllectionView.reloadData()
//                
//            }
//            
//            //RLOAD COLLECTION VIEW
//            if arr_Recommended.count != 0 {
//                //SET VIEW
//                cell.lblTitle.isHidden = false
//                
//                //SET COLLECTIONVIEW TAG
//                cell.objColllectionView.tag = indexPath.row + 101
//                cell.objColllectionView.reloadData()
//                
//            }
//            
//            //RLOAD COLLECTION VIEW
//            if arr_RecentlyViewed.count != 0 {
//                //SET VIEW
//                cell.lblTitle.isHidden = false
//                
//                //SET COLLECTIONVIEW TAG
//                cell.objColllectionView.tag = indexPath.row + 101
//                cell.objColllectionView.reloadData()
//                
//            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tblViewForYou == tableView{
            if arrHeaderForeYou.count != 0 {
               
                //GET DATA
                let obj : HomeObject = arrHeaderForeYou[indexPath.row] as! HomeObject
                
                //FOR YOU
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "HomeProductListViewController") as! HomeProductListViewController
                view.strheaderName = "For You"
                view.foryouID = obj.str_ID
                self.navigationController?.pushViewController(view, animated: true)
            }
        }
    }
    
//    //TABLE BUTTON ACTION
//    @IBAction func btnSellAllClicked(_ sender: Any){
//
//        //SET NAME
//        var strHeader : String = ""
//        if (sender as AnyObject).tag == 0{
//            strHeader = "Featured"
//        }
//        else if (sender as AnyObject).tag == 1{
//            strHeader = "Latest"
//        }
//        else if (sender as AnyObject).tag == 2{
//            strHeader = "Recommended"
//        }
//        else if (sender as AnyObject).tag == 3{
//            strHeader = "Recently Viewed"
//        }
//
//        //MOVE PROFUCT DETAILS SCREEN
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let view = storyboard.instantiateViewController(withIdentifier: "HomeProductListViewController") as! HomeProductListViewController
//        view.strheaderName = strHeader
//        view.selectIndex = (sender as AnyObject).tag
//        self.navigationController?.pushViewController(view, animated: true)
//
//    }
    
}




extension NewHomeViewController : WebServiceHelperDelegate{
  
    
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        let response = data as! NSDictionary
        if strRequest == "getForyou" {
            
            let arr_Header = response["Result"] as! NSArray
            arrHeaderForeYou = []
            for i in (0..<arr_Header.count) {
                let dict_Data = arr_Header[i] as! NSDictionary
                
                //Other Tab Demo data
                let obj = HomeObject ()
                obj.str_ID = dict_Data.getStringForID(key: "id")! as NSString 
                obj.str_Title = dict_Data["title"] as! String as NSString
                obj.str_Image = dict_Data["image"] as! String as NSString
                arrHeaderForeYou.add(obj)
            }
            
            //SET VIEEW
            tblView.isHidden = true
            tblViewForYou.isHidden = false
            
            //RELOAD TABLE
            tblViewForYou.reloadData()
        }
        else if strRequest == "get_products"{
            let arr_Header = response["Advertisement"] as! NSArray
            arrHeaderForeYou = []
            for i in (0..<arr_Header.count) {
                let dict_Data = arr_Header[i] as! NSDictionary
                
                //Other Tab Demo data
                let obj = HomeObject ()
                obj.str_ID = dict_Data.getStringForID(key: "adv_redirect_id")! as NSString
                obj.str_Title = dict_Data["adv_type"] as! String as NSString
                obj.str_Image = dict_Data["adv_image"] as! String as NSString
                arrHeaderForeYou.add(obj)
            }
            
            
            //SET VIEEW
            tblView.isHidden = false
            tblViewForYou.isHidden = true
            
            //RELOAD TABLE
            objBanner.reloadData()
        }
        else if strRequest == "allProductsViews"{
            let dict = response["Result"] as! NSDictionary
            arr_Featured = []
            arr_Latest = []
            arr_Recommended = []
            arr_RecentlyViewed = []
            for i in (0..<4) {
                var arr_Data : NSArray = []

                if i == 0{
                    //GET Featured Data
                    arr_Data = dict["Featured"] as! NSArray
                }
                else if i == 1{
                    //GET Latest Data
                    arr_Data = dict["Latest"] as! NSArray
                }
                else if i == 2{
                    //GET Recommended Data
                    arr_Data = dict["Recommended"] as! NSArray
                }
                else if i == 3{
                    //GET RecentlyViewed Data
                    arr_Data = dict["recentlyViewed"] as! NSArray
                }
                
              
                for j in (0..<arr_Data.count) {
                    let dict_Data = arr_Data[j] as! NSDictionary
                    
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
                    for k in (0..<arr_Image.count){
                        let dict_DataOther = arr_Image[k] as! NSDictionary
                        
                        let obj1 = HomeObject ()
                        obj1.str_Image_OtherTab = dict_DataOther["image"] as! NSString
                        arr_Image_Store.add(obj1)
                    }
                    
                    obj.arrImage_OtherTab = arr_Image_Store
                    
                    if i == 0{
                        //GET Featured Data
                        arr_Featured.add(obj)
                    }
                    else if i == 1{
                        //GET Latest Data
                        arr_Latest.add(obj)
                    }
                    else if i == 2{
                        //GET Recommended Data
                        arr_Recommended.add(obj)
                    }
                    else if i == 3{
                        //GET RecentlyViewed Data
                        arr_RecentlyViewed.add(obj)
                    }
                }
            }
        }

        //SET VIEW
        commanMethod()
        
        //RELOAD TABLE/COLLECTION VIEW
        tblView.reloadData()
        objHeader.reloadData()

        //SET HEADER SCROLLIGN
        timer_Adverticement.invalidate()
        timer_Adverticement = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(reloadHeder), userInfo: nil, repeats: true)
        
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
}





// MARK: - Side Bar Controller -
extension NewHomeViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}






//MARK: - Home Object -
class HomeObject: NSObject {
    var str_ID : NSString = ""
    var str_Title : NSString = ""
    var str_SubTitle : NSString = ""
    var str_Prize : NSString = ""
    var str_DiscountPrize : NSString = ""
    var str_Site : NSString = ""
    var str_Image : NSString = ""
    var arrImage : NSMutableArray = []
    var str_ShopName : NSString = ""
    var str_PriceSymbol : NSString = ""
    
    //Lastest,Recommended,Recently tab
    var str_ID_OtherTab : NSString = ""
    var str_Title_OtherTab : NSString = ""
    var str_SubTitle_OtherTab : NSString = ""
    var str_Prize_OtherTab : NSString = ""
    var str_Site_OtherTab : NSString = ""
    var str_DiscountPrize_OtherTab : NSString = ""
    var str_Image_OtherTab : NSString = ""
    var arrImage_OtherTab : NSMutableArray = []
    var str_Fav_OtherTab : NSString = ""
    var str_ShopName_OtherTab : NSString = ""
    var str_PriceSymbol_OtherTab : NSString = ""
    var str_Product_CateogryName : NSString = ""
    
    //Advertisement
    var str_Adv_ID : NSString = ""
    var str_Adv_Type : NSString = ""
    var str_Adv_Image : NSString = ""
    
    
}


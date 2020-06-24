//
//  HomeViewController.swift
//  Katika
//
//  Created by Katika on 18/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import MIBadgeButton_Swift
import AVFoundation
 import Firebase

//import SlideMenuControllerSwift.Swift

class HomeViewController: UIViewController,FFPullToLoadMoreViewDelegate {

 
    //Declaration CollectionView
    @IBOutlet var cv_Main_TabBar : UICollectionView!
    @IBOutlet var cv_Main : UICollectionView!
    @IBOutlet var cv_Latest : UICollectionView!
    @IBOutlet var cv_Recommended : UICollectionView!
    @IBOutlet var cv_RecentlyViewved : UICollectionView!
    
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    var indexpath_Header : NSIndexPath = NSIndexPath(row: 0, section: 0)
    @IBOutlet var pg_Header : UIPageControl!
    
    //Button Declaration
    @IBOutlet weak var btn_FilterContry : UIButton!
    
    //Declaration Array
    var arr_Category : NSMutableArray = ["Featured","Latest","Recommended","Recently Viewed"]
    var arr_Header_Collectionview : NSMutableArray = []
    var arr_HeaderAdvertice_Collectionview : NSMutableArray = []
    var arr_Featured : NSMutableArray = []
    var arr_Latest : NSMutableArray = []
    var arr_Recommended : NSMutableArray = []
    var arr_RecentlyViewved : NSMutableArray = []
    
    //View Declaration
    @IBOutlet var vw_FeaturedTab : UIView!
    @IBOutlet var vw_SelectContryOption : UIView!
    @IBOutlet var vw_LatestTab : UIView!
    @IBOutlet var vw_Recommended : UIView!
    @IBOutlet var vw_RecentlyViewed : UIView!
    
    //Constant Declaration
    @IBOutlet var con_FeaturedTab : NSLayoutConstraint!
    @IBOutlet var con_SelectContryTab : NSLayoutConstraint!
    @IBOutlet var con_LatestTab : NSLayoutConstraint!
    @IBOutlet var con_RecommendedTab : NSLayoutConstraint!
    @IBOutlet var con_RecentlyViewedTab : NSLayoutConstraint!
    @IBOutlet var con_SelectedTab_X : NSLayoutConstraint!
    @IBOutlet var con_SelectedTab_Width : NSLayoutConstraint!
    
    //Refresh Controller
    var refresh_FeaturedTab: UIRefreshControl?
    var refresh_LatestTab: UIRefreshControl?
    var refresh_Recommended: UIRefreshControl?
    var refresh_RecentlyViewed: UIRefreshControl?
    
    //Bool Declaration
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    var bool_SearchMore_Feature: Bool = false
    var bool_SearchMore_LatestTab: Bool = true
    var bool_SearchMore_RecommendedTab: Bool = true
    var bool_SearchMore_RecentlyViewedTab: Bool = true
    
    //Max Min Limit
    var int_CountLoad_Feature: Int = 0
    var int_CountLoad_LatestTab: Int = 0
    var int_CountLoad_RecommendedTab: Int = 0
    var int_CountLoad_RecentlyViewedTab: Int = 0
    
    //Image Declaration
    @IBOutlet var img_SelectedTab : UIImageView!
    
    //Label Declaration
    @IBOutlet var lbl_Selected_Contry : UILabel!
    
    
    //FOOTER LADER DECLARATION
    var objMainLoadMore: FFPullToLoadMoreView?
    var rectDetail = CGRect()

    //Conuntry validataion
    var str_Latest_Country : NSString = "All"
    var str_Recommended_Country : NSString = "All"
    var str_Recetnly_Country : NSString = "All"
    
    var timer_Adverticement = Timer()
    var timer_Value : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commanMethodInstance()
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(commanMethod), userInfo: nil, repeats: false)

//        print("call from home")
        //First time sevice call for featured product
        int_CountLoad_Feature = Constant.int_LoadMax
        bool_ViewWill = true
        self.Get_Product(count:int_CountLoad_Feature)

        
        // ADD COURSE AS FOOTER VIEW
        let CourseFootView = FFPullToLoadMoreView(frame: CGRect(x: 0, y: 0, width: tbl_Main.bounds.size.width, height: 60))
        CourseFootView.delegate = self
        tbl_Main.tableFooterView = CourseFootView
        tbl_Main.tableFooterView?.backgroundColor = UIColor.clear
        objMainLoadMore = CourseFootView
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.removeObserver("HomeView")
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: NSNotification.Name(rawValue: "HomeView"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.manageNavigation()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        timer_Adverticement.invalidate()
        timer_Adverticement = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(reloadHeder), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(presentModal), userInfo: nil, repeats: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer_Adverticement.invalidate()
        self.completedServiceCalling()
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
            
        }else  if cv_Main == scrollView{
            let visibleRect = CGRect(origin: cv_Main.contentOffset, size: cv_Main.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let indexPath = cv_Main.indexPathForItem(at: visiblePoint)
            
            pg_Header.currentPage = (indexPath?.row)!
            timer_Value = (indexPath?.row)!
        }
    }

    //......................................... FOOTER VIEW ..........................................................//
    
    override func viewDidLayoutSubviews() {
        //GET TABLE SEARCH LISTING FRAM
        rectDetail = tbl_Main.frame
    }
    
    // MARK: - LOAD MORE
    
    // MARK: - UIScrollViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // HIDE THE KEYBOARD
        view.endEditing(true)
       if scrollView == tbl_Main{
            objMainLoadMore?.ffLoadMoreScrollDidScroll(scrollView)
        }else if scrollView == cv_Latest {
            if cv_Latest.contentSize.height <= cv_Latest.contentOffset.y + cv_Latest.frame.size.height && cv_Latest.contentOffset.y >= 0 {
                if bool_Load == false && arr_Latest.count != 0 {
                    self.Get_Product(count: int_CountLoad_LatestTab + Constant.int_LoadMax)
                }
            }
        }else if scrollView == cv_Recommended {
            if cv_Recommended.contentSize.height <= cv_Recommended.contentOffset.y + cv_Recommended.frame.size.height && cv_Recommended.contentOffset.y >= 0 {
                if bool_Load == false && arr_Recommended.count != 0 {
                    self.Get_Product(count: int_CountLoad_RecommendedTab + Constant.int_LoadMax)
                }
            }
        }else if scrollView == cv_RecentlyViewved {
            if cv_RecentlyViewved.contentSize.height <= cv_RecentlyViewved.contentOffset.y + cv_RecentlyViewved.frame.size.height && cv_RecentlyViewved.contentOffset.y >= 0 {
                if bool_Load == false && arr_RecentlyViewved.count != 0 {
                    self.Get_Product(count: int_CountLoad_RecentlyViewedTab + Constant.int_LoadMax)
                }
            }
        }

    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        objMainLoadMore?.ffLoadMoreScrollDidEndDragging(scrollView)
    }
    
    func ffPullToLoadMoreViewDataSourceIsLoading() -> Bool {
        
        if bool_SearchMore_Feature {
            return false
        }
        else{
            //REMOVE LOADER
            self.removeLoaderview()
            return true
            
        }
    }
    
    func ffPullToLoadMoreViewDidTriggerRefresh() {
        
        //SET COURSE FOOTER LOADMORE
        if bool_SearchMore_Feature{
            tbl_Main.frame = CGRect(x: rectDetail.origin.x, y: rectDetail.origin.y, width: rectDetail.size.width, height: rectDetail.size.height-60)
            
            //GET NEW DATA
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GetNewData), userInfo: nil, repeats: false)
                    }
        else{
            
            //REMOVE LOADER
            self.removeLoaderview()
        }
    }
    
    
    @objc func GetNewData(){
        self.Get_Product(count: int_CountLoad_Feature + Constant.int_LoadMax)
    }

    func removeLoaderview() {
        objMainLoadMore?.ffLoadMoreViewDataSourceDidFinishedLoading(tbl_Main)
//        objMainLoadMore?.removeFromSuperview()
//        tbl_Main.tableFooterView?.removeFromSuperview()
        tbl_Main.frame = rectDetail
    }
    
    
    
    
    
    //MARK: - Other Files -
    @objc func commanMethod(){
        
        //Table view header heigh set
        let vw : UIView = tbl_Main.tableHeaderView!
        vw.frame = CGRect(x: 0, y: 0, width: CGFloat(Constant.windowWidth), height: CGFloat((Constant.windowHeight * 180)/Constant.screenHeightDeveloper))
        tbl_Main.tableHeaderView = vw;
        
        //Start view to show first tab
        self.tabBarManage()
        
        //Constant Manage 
        con_FeaturedTab.constant = 0
        con_SelectContryTab.constant = CGFloat(Constant.windowWidth)
        con_LatestTab.constant = CGFloat(Constant.windowWidth)
        con_RecommendedTab.constant = CGFloat(Constant.windowWidth) * 2
        con_RecentlyViewedTab.constant = CGFloat(Constant.windowWidth) * 3
        
        //Refresh Controller
        refresh_FeaturedTab = UIRefreshControl()
        refresh_FeaturedTab?.tintColor = UIColor.red
        refresh_FeaturedTab?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tbl_Main.addSubview(refresh_FeaturedTab!)
        
        //Refresh Controller
        refresh_LatestTab = UIRefreshControl()
        refresh_LatestTab?.tintColor = UIColor.red
        refresh_LatestTab?.addTarget(self, action: #selector(self.refresh_Latest), for: .valueChanged)
        cv_Latest.addSubview(refresh_LatestTab!)
        
        //Refresh Controller
        refresh_Recommended = UIRefreshControl()
        refresh_Recommended?.tintColor = UIColor.red
        refresh_Recommended?.addTarget(self, action: #selector(self.refresh_RecommendedTab), for: .valueChanged)
        cv_Recommended.addSubview(refresh_Recommended!)
        
        //Refresh Controller
        refresh_RecentlyViewed = UIRefreshControl()
        refresh_RecentlyViewed?.tintColor = UIColor.red
        refresh_RecentlyViewed?.addTarget(self, action: #selector(self.refresh_RecentlyViewedTab), for: .valueChanged)
        cv_RecentlyViewved.addSubview(refresh_RecentlyViewed!)
        
        //Temp Data set
        if arr_Featured.count == 0 {
            int_CountLoad_Feature = Constant.int_LoadMax
        }
        
        //Page header color set
        pg_Header.pageIndicatorTintColor = UIColor(patternImage:UIImage(named: "img_Page")!)
        pg_Header.currentPageIndicatorTintColor = UIColor(red: CGFloat((207 / 255.0)), green: CGFloat((198 / 255.0)), blue: CGFloat((188 / 255.0)), alpha: CGFloat(1.0))
        
        
    }
    func commanMethodInstance(){
        //Constant Manage
        con_FeaturedTab.constant = 0
        con_SelectContryTab.constant = CGFloat(Constant.windowWidth)
        con_LatestTab.constant = CGFloat(Constant.windowWidth)
        con_RecommendedTab.constant = CGFloat(Constant.windowWidth) * 2
        con_RecentlyViewedTab.constant = CGFloat(Constant.windowWidth) * 3
        
    }
    @objc func tabBarManage(){
//        print("call from tabBarManage")
        if indexpath_Header.row == 0{
            //Call service when they getting no data
            if arr_Featured.count == 0 && bool_Load == false {
                int_CountLoad_Feature = Constant.int_LoadMax
                bool_ViewWill = true
                bool_SearchMore_Feature = true
                
                self.Get_Product(count:int_CountLoad_Feature)
            }
            
            UIView.animate(withDuration: 0.3, animations: { 
                //Constant Manage
                self.con_FeaturedTab.constant = 0
                self.con_SelectContryTab.constant = CGFloat(Constant.windowWidth)
                self.con_LatestTab.constant = CGFloat(Constant.windowWidth)
                self.con_RecommendedTab.constant = CGFloat(Constant.windowWidth) * 2
                self.con_RecentlyViewedTab.constant = CGFloat(Constant.windowWidth) * 3
                
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                self.reloadData()
            })
        }else if indexpath_Header.row == 1{
            //Call service when they getting no data
            
            if arr_Latest.count == 0 || str_Latest_Country != self.lbl_Selected_Contry.text as! NSString && bool_Load == false{
                str_Latest_Country = self.lbl_Selected_Contry.text as! NSString
                arr_Latest = []
                
                int_CountLoad_LatestTab = Constant.int_LoadMax
                bool_ViewWill = true
                bool_SearchMore_LatestTab = true
                
                self.Get_Product(count:int_CountLoad_LatestTab)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                //Constant Manage
                self.con_FeaturedTab.constant = -CGFloat(Constant.windowWidth)
                self.con_SelectContryTab.constant = 0
                self.con_LatestTab.constant = 0
                self.con_RecommendedTab.constant = CGFloat(Constant.windowWidth)
                self.con_RecentlyViewedTab.constant = CGFloat(Constant.windowWidth) * 2
                
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                self.reloadData()
            })
        }else if indexpath_Header.row == 2{
            //Call service when they getting no data
            if arr_Recommended.count == 0 || str_Recommended_Country != self.lbl_Selected_Contry.text as! NSString && bool_Load == false {
                str_Recommended_Country = self.lbl_Selected_Contry.text as! NSString
                arr_Recommended = []
                
                int_CountLoad_RecommendedTab = Constant.int_LoadMax
                bool_ViewWill = true
                bool_SearchMore_RecommendedTab = true
                
                self.Get_Product(count:int_CountLoad_RecommendedTab)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                //Constant Manage
                self.con_FeaturedTab.constant = -CGFloat(Constant.windowWidth) * 2
                self.con_SelectContryTab.constant = 0
                self.con_LatestTab.constant = -CGFloat(Constant.windowWidth)
                self.con_RecommendedTab.constant = 0
                self.con_RecentlyViewedTab.constant = CGFloat(Constant.windowWidth)
                
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                self.reloadData()
            })
        }else if indexpath_Header.row == 3{
            //Call service when they getting no data
//            if arr_RecentlyViewved.count == 0 {
            if bool_Load == false{
                int_CountLoad_RecentlyViewedTab = Constant.int_LoadMax
                bool_ViewWill = true
                bool_SearchMore_RecentlyViewedTab = true
                
                self.Get_Product(count:int_CountLoad_RecentlyViewedTab)
            }
//            }
            
            UIView.animate(withDuration: 0.3, animations: {
                //Constant Manage
                self.con_FeaturedTab.constant = -CGFloat(Constant.windowWidth) * 3
                self.con_SelectContryTab.constant = 0
                self.con_LatestTab.constant = -CGFloat(Constant.windowWidth) * 2
                self.con_RecommendedTab.constant = -CGFloat(Constant.windowWidth)
                self.con_RecentlyViewedTab.constant = 0
                
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                self.reloadData()
            })
        }
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
        navButton.badgeString = objUser?.str_CardCount as! String
        navButton.badgeTextColor = UIColor.white
        navButton.badgeEdgeInsets = UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 18)
        
        let barButton = UIBarButtonItem()
        barButton.customView = navButton
        self.navigationItem.rightBarButtonItem = barButton

    }
    func reloadData(){
        tbl_Main.reloadData()
        cv_Main.reloadData()
        cv_Latest.reloadData()
        cv_Recommended.reloadData()
        cv_RecentlyViewved.reloadData()
        cv_Main_TabBar.reloadData()
    }
    func completedServiceCalling(){
        //Comman fuction action
        refresh_FeaturedTab?.endRefreshing()
        refresh_LatestTab?.endRefreshing()
        refresh_Recommended?.endRefreshing()
        refresh_RecentlyViewed?.endRefreshing()
        bool_Load = false
    }
    
    func CallServiceForSelectedTab() {
//        print("call from CallServiceForSelectedTab")
        if indexpath_Header.row == 1 {
            arr_Latest = []
            cv_Latest.reloadData()
            
            int_CountLoad_LatestTab = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_LatestTab = true
            
            self.Get_Product(count:int_CountLoad_LatestTab)
        }else  if indexpath_Header.row == 2 {
            arr_Recommended = []
            cv_Recommended.reloadData()
            
            int_CountLoad_RecommendedTab = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_RecommendedTab = true
            
            self.Get_Product(count:int_CountLoad_RecommendedTab)
        }else if indexpath_Header.row == 3 {
            arr_RecentlyViewved = []
            cv_RecentlyViewved.reloadData()
            
            int_CountLoad_RecentlyViewedTab = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_RecentlyViewedTab = true
            
            self.Get_Product(count:int_CountLoad_RecentlyViewedTab)
        }
    }
    @objc func reloadTableView() {
//        print("call from reloadTableView")
        
        if indexpath_Header.row == 1{
            int_CountLoad_LatestTab = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_LatestTab = true
            
            self.Get_Product(count:int_CountLoad_LatestTab)
        }
        else if indexpath_Header.row == 2{
            int_CountLoad_RecommendedTab = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_RecommendedTab = true
            
            self.Get_Product(count:int_CountLoad_RecommendedTab)
        }
        else if indexpath_Header.row == 3{
            int_CountLoad_RecentlyViewedTab = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_RecentlyViewedTab = true
            
            self.Get_Product(count:int_CountLoad_RecentlyViewedTab)
        }
        else if indexpath_Header.row == 0{
            int_CountLoad_Feature = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_Feature = true
            
            self.Get_Product(count:int_CountLoad_Feature)
            
        }
    }
    
    
    @objc func reloadHeder(){
        if arr_HeaderAdvertice_Collectionview.count != 0{
            let int_Count = timer_Value + 1
            if int_Count < arr_HeaderAdvertice_Collectionview.count {
                timer_Value = timer_Value + 1
            }else{
                timer_Value = 0
            }
            
            let indexpathSelect : NSIndexPath = NSIndexPath(row:timer_Value, section: 0)
            pg_Header.currentPage = (indexpathSelect.row)
            cv_Main.scrollToItem(at: indexpathSelect as IndexPath, at: UICollectionView.ScrollPosition.left, animated: true)
        }
        
//        HomePageViewController.scrollToViewController(index: index)
    }
    
    @objc func presentModal(){
        if UserDefaults.standard.value(forKey: "HomeTutorial") == nil{
            UserDefaults.standard.set("1", forKey: "HomeTutorial")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
            view.modalPresentationStyle = .custom
            view.modalTransitionStyle = .crossDissolve
            present(view, animated: true)
        }

    }
    
    
    // MARK: - refersh controller -
    @objc func refresh(_ refreshControl: UIRefreshControl) {
//        print("call from refresh")
        
        if bool_Load == false {
            int_CountLoad_Feature = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_Feature = true
            
            self.Get_Product(count:int_CountLoad_Feature)
        }else{
            refresh_FeaturedTab?.endRefreshing()
        }
    }
    @objc func refresh_Latest(_ refreshControl: UIRefreshControl) {
//        print("call from refresh_Latest")
        if bool_Load == false {
//            arr_Latest = []
//            cv_Latest.reloadData()
            
            int_CountLoad_LatestTab = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_LatestTab = true
            
            self.Get_Product(count:int_CountLoad_LatestTab)
        }else{
            refresh_LatestTab?.endRefreshing()
        }
    }

    @objc func refresh_RecommendedTab(_ refreshControl: UIRefreshControl) {
//        print("call from refresh_RecommendedTab")
        if bool_Load == false {
            
            int_CountLoad_RecommendedTab = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_RecommendedTab = true
            
            self.Get_Product(count:int_CountLoad_RecommendedTab)
        }else{
            refresh_Recommended?.endRefreshing()
        }
    }
    @objc func refresh_RecentlyViewedTab(_ refreshControl: UIRefreshControl) {
//        print("call from refresh_RecentlyViewedTab")
        if bool_Load == false {
            
            int_CountLoad_RecentlyViewedTab = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore_RecentlyViewedTab = true
            
            self.Get_Product(count:int_CountLoad_RecentlyViewedTab)
        }else{
            refresh_RecentlyViewed?.endRefreshing()
        }
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
    @IBAction func Sidebar_Right(_ sender: Any) {
        self.performSegue(withIdentifier: "checkout", sender: self)
    }
    @IBAction func btn_FavTab(_ sender: Any){
        
        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }
        else{
            if networkOnOrOff() == true {
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
        }
    }
    
    @IBAction func btn_FilterContry(_ sender: Any){
        //Open filter view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        view.str_ValueType = "product"
        self.present(view, animated: true, completion: nil)
        
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
    
    // MARK: - Get/Post Method -
    func Get_Product(count : Int){
        
        //Declaration URL
        var strURL = "\(Constant.BaseURL)get_products_new"
        if indexpath_Header.row == 0{
            strURL = "\(Constant.BaseURL)get_products"
        }else if indexpath_Header.row == 3{
            strURL = "\(Constant.BaseURL)get_recentview_products"
        }
        
        
        //Get type when click on tab bar in header
        var set_Type : NSString = "Featured"
        switch indexpath_Header.row {
            case 1:
                set_Type = "Latest"
                break
            case 2:
                set_Type = "Recommended"
                break
            case 3:
                set_Type = "RecentlyViewed"
                break                
            default:
                break
        }
        
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
            "type" : set_Type,
        ]
        
        if indexpath_Header.row == 0{
            jsonData["country_id"] = "0"
        }
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_products"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        
        
        switch indexpath_Header.row {
            case 0:
                //If first time call than only show loader otherwise not showing loader
                (arr_Featured.count == 0) ? (webHelper.indicatorShowOrHide = true) : (webHelper.indicatorShowOrHide = false)
                
                //Not limit for end data than only service call
                if bool_SearchMore_Feature == true{
                    bool_Load = true
                    webHelper.startDownload()
                }
                break
            case 1:
                //If first time call than only show loader otherwise not showing loader
                (arr_Latest.count == 0) ? (webHelper.indicatorShowOrHide = true) : (webHelper.indicatorShowOrHide = false)
                
                //Not limit for end data than only service call
                if bool_SearchMore_LatestTab == true{
                    bool_Load = true
                    webHelper.startDownload()
                }
                
                break
            case 2:
                //If first time call than only show loader otherwise not showing loader
                (arr_Recommended.count == 0) ? (webHelper.indicatorShowOrHide = true) : (webHelper.indicatorShowOrHide = false)
                
                //Not limit for end data than only service call
                if bool_SearchMore_RecommendedTab == true{
                    bool_Load = true
                    webHelper.startDownload()
                }
                
                break
            case 3:
                //If first time call than only show loader otherwise not showing loader
                (arr_RecentlyViewved.count == 0) ? (webHelper.indicatorShowOrHide = true) : (webHelper.indicatorShowOrHide = false)
                
                 print("call from start")
                //Not limit for end data than only service call
                if bool_SearchMore_RecentlyViewedTab == true && bool_Load == false{
                    print("call from end")
                    bool_Load = true
                    webHelper.startDownload()
                }
                
                break
            default:
                break
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
extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returen number of cell with content available in array
        if cv_Main_TabBar == collectionView {
            return arr_Category.count
        }else if cv_Main == collectionView {
            
            if arr_HeaderAdvertice_Collectionview.count == 0 && bool_Load == false{
                return 1
            }
            pg_Header.numberOfPages = arr_HeaderAdvertice_Collectionview.count
            return arr_HeaderAdvertice_Collectionview.count
            
            
        }else if cv_Latest == collectionView {
            if arr_Latest.count == 0 && bool_Load == false{
                return 1
            }
            return arr_Latest.count
        }else if cv_Recommended == collectionView {
            if arr_Recommended.count == 0 && bool_Load == false{
                return 1
            }
            return arr_Recommended.count
        }else if cv_RecentlyViewved == collectionView {
            if arr_RecentlyViewved.count == 0 && bool_Load == false{
                return 1
            }
            return arr_RecentlyViewved.count
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
        if cv_Main_TabBar == collectionView {
            let userAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper)), convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black]
            let text: String = arr_Category[indexPath.row] as! String
            
            //Find out widht of text with depend of font size and font name
            var textSize: CGSize = (text as NSString).size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary(userAttributes))
            textSize.height = collectionView.frame.size.height
            textSize.width = textSize.width + 14
            
            return textSize
        }else if cv_Main == collectionView {
            return CGSize(width: cv_Main.frame.size.width, height: cv_Main.frame.size.height)
        }else if cv_Latest == collectionView {
            if arr_Latest.count == 0 && bool_Load == false{
                return CGSize(width: collectionView.frame.size.width, height: 30)
            }
            return CGSize(width: collectionView.frame.size.width/2, height: CGFloat(((collectionView.frame.size.width/2)*200)/175))
        }else if cv_Recommended == collectionView {
            if arr_Recommended.count == 0 && bool_Load == false{
                return CGSize(width: collectionView.frame.size.width, height: 30)
            }
            return CGSize(width: collectionView.frame.size.width/2, height: CGFloat(((collectionView.frame.size.width/2)*200)/175))
        }else if cv_RecentlyViewved == collectionView {
            if arr_RecentlyViewved.count == 0 && bool_Load == false{
                return CGSize(width: collectionView.frame.size.width, height: 30)
            }
            return CGSize(width: collectionView.frame.size.width/2, height: CGFloat(((collectionView.frame.size.width/2)*200)/175))
        }else{
            //This box for array in tableview cell
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var str_Identifier : String = "cell"
        
        if cv_Main == collectionView {
            if arr_HeaderAdvertice_Collectionview.count == 0{
                str_Identifier = "nodata"
                pg_Header.isHidden = true
            }else{
                pg_Header.isHidden = false
            }
        }else if cv_Latest == collectionView {
            if arr_Latest.count == 0{
                str_Identifier = "nodata"
            }
        }else if cv_Recommended == collectionView {
            if arr_Recommended.count == 0{
                str_Identifier = "nodata"
            }
        }else if cv_RecentlyViewved == collectionView {
            if arr_RecentlyViewved.count == 0{
                str_Identifier = "nodata"
            }
        }
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: str_Identifier, for: indexPath) as! HomeViewCollectioncell
      
      
        
        if cv_Main_TabBar == collectionView {
            //Set text in label
            cell.lblTitle.text = arr_Category[indexPath.row] as? String
            
            //Seleted Image always false only selected state they show
            cell.img_Seleted.isHidden = true
            
            if indexpath_Header.row == indexPath.row {
                cell.img_Seleted.isHidden = false
            }
            
            //Set font size and font name in title
            cell.lblTitle.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
            
            //Current logic
            if con_SelectedTab_X.constant == 0 && indexPath.row == 0 {
                cell.img_Seleted.isHidden = false
                img_SelectedTab.isHidden = true
            }else{
                cell.img_Seleted.isHidden = true
            }

        }else if cv_Main == collectionView {
            
            if arr_HeaderAdvertice_Collectionview.count != 0{
                let obj : HomeObject = arr_HeaderAdvertice_Collectionview[indexPath.row] as! HomeObject
                
                cell.lbl_Title_Header.text = ""
                cell.lbl_SubTitle_Header.text = ""
                cell.lbl_PrizeMainPrice_Header.text = ""
                cell.lbl_PrizeFinal_Header.text = ""
                
                //Image set
                cell.img_Image_Header.sd_setImage(with: URL(string: obj.str_Adv_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))

            }
            
        }else if cv_Latest == collectionView {

            if arr_Latest.count != 0{
                let obj : HomeObject = arr_Latest[indexPath.row] as! HomeObject
                let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
                
                //SET TILE FONT
                cell.lbl_Title_OtherTab.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                
                //Set text in label
                cell.lbl_Title_OtherTab.text = obj.str_Title_OtherTab as String
                cell.lbl_SubTitle_OtherTab.text = obj.str_ShopName_OtherTab as String
                print(obj.str_PriceSymbol_OtherTab as String)
                var int_Value  = obj.str_Prize_OtherTab as String
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
            
          
        }else if cv_Recommended == collectionView {
            
            if arr_Recommended.count != 0{
                let obj : HomeObject = arr_Recommended[indexPath.row] as! HomeObject
                let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
                
                //SET TILE FONT
                cell.lbl_Title_OtherTab.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                
                
                //Set text in label
                cell.lbl_Title_OtherTab.text = obj.str_Title_OtherTab as String
                cell.lbl_SubTitle_OtherTab.text = obj.str_ShopName_OtherTab as String
                print(obj.str_PriceSymbol_OtherTab as String)

                var int_Value = obj.str_Prize_OtherTab as String
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
            
        }else if cv_RecentlyViewved == collectionView {
            
            if arr_RecentlyViewved.count != 0{
                let obj : HomeObject = arr_RecentlyViewved[indexPath.row] as! HomeObject
                let arr_Images : NSMutableArray = obj.arrImage_OtherTab;
                
                //SET TILE FONT
                cell.lbl_Title_OtherTab.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                
                //Set text in label
                cell.lbl_Title_OtherTab.text = obj.str_Title_OtherTab as String
                cell.lbl_SubTitle_OtherTab.text = obj.str_ShopName_OtherTab as String
                print(obj.str_PriceSymbol_OtherTab as String)

                var int_Value = obj.str_Prize_OtherTab as String
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
        
        if cv_Main_TabBar == collectionView {

            //Current code
            indexpath_Header = indexPath as NSIndexPath
//            self.completedServiceCalling()
            refresh_FeaturedTab?.endRefreshing()
            refresh_LatestTab?.endRefreshing()
            refresh_Recommended?.endRefreshing()
            refresh_RecentlyViewed?.endRefreshing()
            
            if cv_Main_TabBar.contentSize.width > cv_Main_TabBar.bounds.size.width {
                if indexPath.row == arr_Category.count - 1 {
                    //Move Right position of collectionview
                    let rightSideMove = CGPoint(x: cv_Main_TabBar.contentSize.width - cv_Main_TabBar.bounds.size.width, y: 0)
                    cv_Main_TabBar.setContentOffset(rightSideMove, animated: true)
                }else if indexPath.row == 0{
                    //Move Left position of collectionview
                    cv_Main_TabBar.setContentOffset(CGPoint.zero, animated: true)
                }
            }

            cv_Main_TabBar.reloadData()

            
            //Tabbar
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(tabBarManage), userInfo: nil, repeats: false)

            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeViewCollectioncell
            let frame2 = (cell.img_Seleted.superview?.convert(cell.img_Seleted.frame.origin, to: nil))! as CGPoint
            
            let fontAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): cell.lblTitle.font] // it says name, but a UIFont works
            let myText = arr_Category[indexPath.row]
            let size = (myText as! NSString).size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary(fontAttributes))
            
            UIView.animate(withDuration: 0.3, animations: {
                self.con_SelectedTab_X.constant = frame2.x
                self.con_SelectedTab_Width.constant = size.width
                
                self.img_SelectedTab.superview?.layoutIfNeeded()
            }, completion: { (finished) in
            })
            
            img_SelectedTab.isHidden = false
            
        }
        else{
            var obj = HomeObject ()
            var str_ID : NSString = ""
            
            //Get Data from array condition for collection view type and get data
            if cv_Main_TabBar == collectionView {
                //Do not move to other view
            }else if cv_Main == collectionView {
                
                if arr_HeaderAdvertice_Collectionview.count != 0{
                    obj = arr_HeaderAdvertice_Collectionview[indexPath.row] as! HomeObject
                    
                    if obj.str_Adv_Type == "PRO"{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
                        print(obj)
                        view.str_ProductIDGet = obj.str_Adv_ID
                        self.navigationController?.pushViewController(view, animated: false)
                    }else{
                        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
                        view.str_ShopIDGet = obj.str_Adv_ID
                        self.navigationController?.pushViewController(view, animated: true)
                    }
                }
              
            }else if cv_Latest == collectionView {
                
                obj = arr_Latest[indexPath.row] as! HomeObject
                str_ID = obj.str_ID_OtherTab
            }else if cv_Recommended == collectionView {
                
                obj = arr_Recommended[indexPath.row] as! HomeObject
                str_ID = obj.str_ID_OtherTab
            }else if cv_RecentlyViewved == collectionView {

                obj = arr_RecentlyViewved[indexPath.row] as! HomeObject
                str_ID = obj.str_ID_OtherTab
            }else{
            
                obj = arr_Featured[collectionView.tag - 100] as! HomeObject
                str_ID = obj.str_ID_OtherTab
            }
            
            if str_ID.length != 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
                view.str_ProductIDGet = str_ID
                self.navigationController?.pushViewController(view, animated: false)
            }
        }
    }
}
extension UICollectionView {
    
    var centerPoint : CGPoint {
        
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }
    
    var centerCellIndexPath: IndexPath? {
        
        if let centerIndexPath = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
}


//MARK: - Collection View Cell -
class HomeViewCollectioncell : UICollectionViewCell{
    //Cell for tabbar
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img_Seleted: UIImageView!
    
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

// MARK: - Tableview Files -
extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(Int((Constant.windowHeight * 190)/Constant.screenHeightDeveloper))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Featured.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath as IndexPath) as! HomeTableviewCell
       
        let obj : HomeObject = arr_Featured[indexPath.row] as! HomeObject
        
        //SET TILE FONT
        cell.lbl_Title.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))
 
        
        print(obj)
        
        //Value Set
        cell.lbl_Title.text = (obj.str_Title_OtherTab ) as String
        let int_Value  = obj.str_Prize_OtherTab as String
        
       
        
//        print(obj.str_Prize_OtherTab as String)
//        print(int_Value)

        cell.lbl_Price.text = ("\(obj.str_PriceSymbol_OtherTab as String)\(int_Value)")
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
        
        if obj.arrImage_OtherTab.count == 0 {
            cell.cv_Sub.isHidden = true
        }else{
            cell.cv_Sub.isHidden = false
        }
        
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


class HomeTableviewCell : UITableViewCell{
    //MARK: - Tableview View Cell -
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_Website: UILabel!
    
    @IBOutlet weak var vw_SubView: UIView!

    @IBOutlet weak var cv_Sub: UICollectionView!
    @IBOutlet var pg_Product : UIPageControl!
    
    @IBOutlet weak var btn_Favorite : UIButton!
    
    @IBOutlet weak var img_Favorite : UIImageView!
}


extension HomeViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        self.completedServiceCalling()
        
        let response = data as! NSDictionary
        print(response)
        if strRequest == "get_products" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            var arr_StoreTemp : NSMutableArray = []
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
            
            //Get type when click on tab bar in header
            switch indexpath_Header.row {
            case 0:
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

                break
            case 1:
                //Refresh code
                if bool_ViewWill == true {
                    arr_Latest = []
                    int_CountLoad_LatestTab = arr_StoreTemp.count
                }else{
                    int_CountLoad_LatestTab = int_CountLoad_LatestTab + arr_StoreTemp.count
                }
                
                for i in (0...arr_StoreTemp.count-1){
                    arr_Latest.add(arr_StoreTemp[i])
                }
                
                //Load more data or not
                if Constant.int_LoadMax > arr_StoreTemp.count {
                    //Bool Load more
                    bool_SearchMore_LatestTab = false
                }
                else {
                    //Bool Load more
                    bool_SearchMore_LatestTab = true
                }
                
                break
            case 2:
                //Refresh code
                if bool_ViewWill == true {
                    arr_Recommended = []
                    int_CountLoad_RecommendedTab = arr_StoreTemp.count
                }else{
                    int_CountLoad_RecommendedTab = int_CountLoad_RecommendedTab + arr_StoreTemp.count
                }
                
                for i in (0...arr_StoreTemp.count-1){
                    arr_Recommended.add(arr_StoreTemp[i])
                }
                
                //Load more data or not
                if Constant.int_LoadMax > arr_StoreTemp.count {
                    //Bool Load more
                    bool_SearchMore_RecommendedTab = false
                }
                else {
                    //Bool Load more
                    bool_SearchMore_RecommendedTab = true
                }
                
                break
            case 3:
                //Refresh code
                if bool_ViewWill == true {
                    arr_RecentlyViewved = []
                    int_CountLoad_RecentlyViewedTab = arr_StoreTemp.count
                }else{
                    int_CountLoad_RecentlyViewedTab = int_CountLoad_RecentlyViewedTab + arr_StoreTemp.count
                }
                
                for i in (0...arr_StoreTemp.count-1){
                    arr_RecentlyViewved.add(arr_StoreTemp[i])
                }

                //Load more data or not
                if Constant.int_LoadMax > arr_StoreTemp.count {
                    //Bool Load more
                    bool_SearchMore_RecentlyViewedTab = false
                }
                else {
                    //Bool Load more
                    bool_SearchMore_RecentlyViewedTab = true
                }
                
                break
                
            default:
                break
            }
            

            let arr_Header = response["HeaderFeature"] as! NSArray
            if indexpath_Header.row == 0 {
                if bool_ViewWill == true {
                    arr_Header_Collectionview = []
                    for i in (0..<arr_Header.count) {
                        let dict_Data = arr_Header[i] as! NSDictionary
                        
                        //Other Tab Demo data
                        let obj = HomeObject ()
                        obj.str_ID = ("\(dict_Data["product_id"] as! Int)" as NSString)
                        obj.str_Title = dict_Data["p_title"] as! String as NSString
                        obj.str_SubTitle = dict_Data["p_descriiption"] as! String as NSString
                        obj.str_Prize =  dict_Data.getStringForID(key:"price") as! NSString
                        obj.str_DiscountPrize = dict_Data.getStringForID(key:"discount_price") as! NSString
                        obj.str_Site = dict_Data["site"] as! String as NSString
                        obj.str_Image = dict_Data["image"] as! String as NSString
                        obj.str_ShopName = dict_Data["shop_name"] as! String as NSString
                        obj.str_PriceSymbol = dict_Data["price_symbole"] as! String as NSString
                        
                        arr_Header_Collectionview.add(obj)
                    }
                }
            }
            
            let arr_Header2 = response["Advertisement"] as! NSArray
            if indexpath_Header.row == 0 {
                if bool_ViewWill == true {
                    arr_HeaderAdvertice_Collectionview = []
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
                
            }
            
            bool_ViewWill = false
            self.reloadData()
        }else if strRequest == "addremove_favourite" {
            
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
        //SET TABLE FRAME
        tbl_Main.frame = rectDetail

        if bool_SearchMore_Feature{
            bool_SearchMore_Feature = false
            
            //REMOVE LOADER
            self.removeLoaderview()
        }
        if bool_SearchMore_LatestTab == true && bool_ViewWill == true{
            arr_Latest = []
        }
        if bool_SearchMore_RecommendedTab == true && bool_ViewWill == true{
            arr_Recommended = []
        }
      
        self.completedServiceCalling()
        self.reloadData()
    }

}




// MARK: - Side Bar Controller -
extension HomeViewController : SlideMenuControllerDelegate {
    
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


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

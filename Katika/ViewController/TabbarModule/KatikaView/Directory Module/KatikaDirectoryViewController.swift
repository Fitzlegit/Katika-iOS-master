//
//  KatikaDirectoryViewController.swift
//  Katika
//
//  Created by Katika on 18/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import MapKit
import Cosmos
import Firebase

class KatikaDirectoryViewController: UIViewController,DismissCategoryViewDelegate ,FFPullToLoadMoreViewDelegate{

    //View declaration
    @IBOutlet var vw_SearchBar : UIView!
    @IBOutlet var vw_SearchBar2 : UIView!
    @IBOutlet weak var vw_MapView: MKMapView!
    @IBOutlet var vw_PinClick : UIView!
    @IBOutlet var vw_ClickPinRateView: CosmosView!
    
    //Textfield declaration
    @IBOutlet var tf_Search : UITextField!
    @IBOutlet var tf_Search2 : UITextField!
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    @IBOutlet var tbl_Search : UITableView!
    @IBOutlet var tbl_SearchListing : UITableView!
    
    //Declaration Image
    @IBOutlet var img_HeaderIcon : UIImageView!

    //Label Declaration
    @IBOutlet var lbl_SearchTitle_1 : UILabel!
    @IBOutlet var lbl_SearchTitle_2 : UILabel!
    @IBOutlet var lbl_ClickPinTitle : UILabel!
    @IBOutlet var lbl_ClickPinAddress : UILabel!
    @IBOutlet var lbl_ClickPinShopCategory : UILabel!
    
    //Image
    
    @IBOutlet var img_HeaderImage : UIImageView!
    
    //Array Declaration
    var arr_Main : NSMutableArray = []
    var arr_Main_Result : NSMutableArray = []
    var arr_Cateogry : NSMutableArray = []
    var arr_SearchLocation : NSMutableArray = []
    var arr_ListingProduct : NSMutableArray = []
    var arr_CateogrySearch : NSMutableArray = []
    
    //Button Event
    @IBOutlet var btn_CancelSearch : UIButton!
    @IBOutlet var btn_Search : UIButton!
    @IBOutlet var btn_SearchReStart : UIButton!
    @IBOutlet var btn_ClickPinShop : UIButton!
    
    //Constant Declation
    @IBOutlet var con_VwSearch : NSLayoutConstraint!
    @IBOutlet var con_SearchX : NSLayoutConstraint!
    @IBOutlet var con_SearchRight : NSLayoutConstraint!
    @IBOutlet var con_SearchX2 : NSLayoutConstraint!
    @IBOutlet var con_SearchRight2 : NSLayoutConstraint!
    @IBOutlet var con_SearchY : NSLayoutConstraint!
    @IBOutlet var con_SearchWidth : NSLayoutConstraint!

    //Bool Decalratin
    var bool_Search_Active : Bool = false
    var bool_SearchMore: Bool = false
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    var isSearch: Bool = false

    //Cluster Object
    var manager = ClusterManager()
    var rectDetail = CGRect()
   
    //Refresh Controller
    var refresh: UIRefreshControl?
    @IBOutlet weak var viewTabBar: UIView!
    
    //Int Declaration
    var int_CountLoad: Int = 0
    
    //FOOTER LADER DECLARATION
    var objDetailsLoadMore: FFPullToLoadMoreView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commanMethod()
        
        NotificationCenter.default.removeObserver("HomeView")
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: NSNotification.Name(rawValue: "businessview"), object: nil)
        
        // ADD COURSE AS FOOTER VIEW
        let CourseFootView = FFPullToLoadMoreView(frame: CGRect(x: 0, y: 0, width: tbl_SearchListing.bounds.size.width, height: 60))
        CourseFootView.delegate = self
        tbl_SearchListing.tableFooterView = CourseFootView
        tbl_SearchListing.tableFooterView?.backgroundColor = UIColor.clear
        objDetailsLoadMore = CourseFootView
        
        //SET MENU BUTTON
        btn_CancelSearch.setTitle(" ", for: .normal)
        btn_CancelSearch.setImage(UIImage(named: "img_NavigationLeft"), for: .normal)
        self.vw_SearchBar2.isHidden = true

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
      
        self.manageNavigation()
        
        //SET NAVIGATION BAR
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        if katikaViewSelection != "1"{
            self.setViewwillAppearCode()
        }
    }
   
 
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - refersh controller -
    @objc func refreshListing(_ refreshControl: UIRefreshControl) {
        if bool_Load == false {
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            
            self.Post_SearchShopListing(count:int_CountLoad)
        }else{
            refresh?.endRefreshing()
        }
    }
    
    //......................................... FOOTER VIEW ..........................................................//
    
    // MARK: - LOAD MORE
    override func viewDidLayoutSubviews() {
        //GET TABLE SEARCH LISTING FRAM
        rectDetail = tbl_SearchListing.frame
    }
    
    // MARK: - UIScrollViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //  isScroll=YES;
        
        // HIDE THE KEYBOARD
        view.endEditing(true)
        if scrollView == tbl_SearchListing{
            objDetailsLoadMore?.ffLoadMoreScrollDidScroll(scrollView)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        objDetailsLoadMore?.ffLoadMoreScrollDidEndDragging(scrollView)
    }
    
    func ffPullToLoadMoreViewDataSourceIsLoading() -> Bool {
        
        if bool_SearchMore {
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
        if bool_SearchMore{
            tbl_SearchListing.frame = CGRect(x: rectDetail.origin.x, y: rectDetail.origin.y, width: rectDetail.size.width, height: rectDetail.size.height - 60)
            
            //GET NEW DATA
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GetNewData), userInfo: nil, repeats: false)
            
        }
        else{
            
            //REMOVE LOADER
            self.removeLoaderview()
        }
    }
    
    @objc func GetNewData(){
        self.Post_SearchShopListing(count: int_CountLoad + Constant.int_LoadMax)
    }
    func removeLoaderview() {
        objDetailsLoadMore?.ffLoadMoreViewDataSourceDidFinishedLoading(tbl_SearchListing)
     //   objDetailsLoadMore?.removeFromSuperview()
       // tbl_SearchListing.tableFooterView?.removeFromSuperview()
        //SET THE TABLE FRAME
        tbl_SearchListing.frame = rectDetail
    }
    
    
    // MARK: - TextField Manage -
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //Start to checking
        btn_Search.isHidden = false
        btn_Search.setTitle("Search", for: .normal)
        btn_CancelSearch.setTitle(" ", for: .normal)
        btn_CancelSearch.setImage(UIImage(named: "img_NavigationLeft"), for: .normal)
        

        if tf_Search == textField {
            self.reloadData()
            self.hideView()
            tbl_Main.isHidden = false
            self.vw_SearchBar.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                //Constant Manage
                self.con_VwSearch.constant = 135;
                self.con_SearchX.constant = 10;
                self.con_SearchRight.constant = 10;
                self.con_SearchX2.constant = 10;
                self.con_SearchRight2.constant = 10;
                self.con_SearchY.constant = 10
                self.con_SearchWidth.constant = 15
                self.img_HeaderImage.image = UIImage(named:"icon_Search")
                
                self.vw_SearchBar2.isHidden = false
                self.img_HeaderIcon.isHidden = false
                self.tf_Search.isHidden = false
                self.btn_SearchReStart.isHidden = true
                self.lbl_SearchTitle_1.isHidden = true
                self.lbl_SearchTitle_2.isHidden = true
                
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.1, animations: {
                    //Constant Manage
                    self.con_VwSearch.constant = 135;
                    self.view.layoutIfNeeded()
                    
                    //Only hide when search not activate
                    if self.bool_Search_Active == false {
                        self.btn_Search.isHidden = false
                    }
                }, completion: { (finished) in
                    
                })
                
            })
        }else if tf_Search2 == textField{
            self.hideView()
            tbl_Search.isHidden = false
            self.vw_SearchBar2.isHidden = false
            if tf_Search2.text == "Current Location"{
                tf_Search2.textColor = UIColor.black
                tf_Search2.text = ""
            }
        }
    }
    
    func searchAnimation() {
        if bool_Search_Active == false {
            btn_Search.isHidden = true
        }
        
        self.btn_Search.setTitle("Search", for: .normal)
        btn_CancelSearch.setTitle(" ", for: .normal)
        btn_CancelSearch.setImage(UIImage(named: "img_NavigationLeft"), for: .normal)

        UIView.animate(withDuration: 0.3, animations: {
            //Constant Manage
            self.con_VwSearch.constant = 100;
            self.img_HeaderImage.image = UIImage(named:"icon_Search")
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
        })
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if tf_Search == textField {
          
            self.vw_SearchBar2.isHidden = true
            searchAnimation()
        }else if tf_Search2 == textField {
            if self.tf_Search2.text == ""{
                self.tf_Search2.text = "Current Location"
                self.tf_Search2.textColor = UIColor(red: 72/255, green: 180/255, blue: 240/255, alpha: 1)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.Get_Product()
        self.returSearch()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.phase == .began {
            view.endEditing(true)
        }

    }
    @objc func textFieldDidChange(textField: UITextField){
        let str_TextField = textField.text?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        if str_TextField == "" {
            arr_CateogrySearch = []
            self.reloadData()
        }else{
//            self.Post_SearchDirectory()
        }
    }
    @objc func textFieldDidChange2(textField: UITextField){
        if textField.text == "" {
            arr_SearchLocation = []
            self.reloadData()
        }else{
            self.Get_Location()
        }
    }

    
    //MARK: - Other Files -
    func commanMethod(){
        vw_Tab2 = self
        
        //Layer declaration
        vw_SearchBar.layer.cornerRadius = 5
        vw_SearchBar.layer.borderColor = UIColor.darkGray.cgColor
        vw_SearchBar.layer.borderWidth = 0.0
        vw_SearchBar.layer.masksToBounds = true
        
        vw_SearchBar2.layer.cornerRadius = 5
        vw_SearchBar2.layer.borderColor = UIColor.darkGray.cgColor
        vw_SearchBar2.layer.borderWidth = 0.0
        vw_SearchBar2.layer.masksToBounds = true
     
        //Text change method in textfield
        tf_Search.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        tf_Search2.addTarget(self, action: #selector(textFieldDidChange2(textField:)), for: .editingChanged)
        tf_Search2.text = "Current Location"
        tf_Search2.textColor = UIColor(red: 72/255, green: 180/255, blue: 240/255, alpha: 1)
        
        //Refresh Controller
        refresh = UIRefreshControl()
        refresh?.tintColor = UIColor.red
        refresh?.addTarget(self, action: #selector(self.refreshListing), for: .valueChanged)
        tbl_SearchListing.addSubview(refresh!)
        
    }
    @objc func reloadTableView() {
       self.setViewwillAppearCode()
    }
    
    func setViewwillAppearCode(){
        //Service Calling
        if btn_CancelSearch.titleLabel?.text == " "{
            self.Get_SearchCategory()
            self.Get_Product_FirstTime()
        }else{
            if bool_Load == false{
                int_CountLoad = Constant.int_LoadMax
                bool_SearchMore = true
                bool_ViewWill = true
                
                arr_ListingProduct = []
                
                self.reloadData()
                
                self.Post_SearchShopListing(count:int_CountLoad)
            }
        }
    }
    func manageNavigation(){
        
        let titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 150, height: 28))
        titleView.contentMode = .scaleAspectFit
        titleView.image = UIImage(named: "katikaTextNavigation")
        
        self.navigationItem.titleView = titleView
    }
    
    func returSearch(){
        self.hideView()
        if self.btn_Search.isSelected == false {
            //Only hide when search not activate
            if self.bool_Search_Active == true {
                 tbl_SearchListing.isHidden = false
                self.vw_SearchBar.isHidden = false
            }else{
                tbl_Main.isHidden = false
                self.vw_SearchBar.isHidden = false
            }
        }else{
            vw_MapView.isHidden = false
        }
        
        self.reloadData()
        
        view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            //Constant Manage
            self.con_VwSearch.constant = 85;
            self.img_HeaderImage.image = UIImage(named:"icon_Search")
            
            
            //Only hide when search not activate
            if self.bool_Search_Active == false {
                self.btn_Search.isHidden = true
              
                
                self.btn_Search.setTitle("Search", for: .normal)
                self.btn_CancelSearch.setTitle(" ", for: .normal)
                self.btn_CancelSearch.setImage(UIImage(named: "img_NavigationLeft"), for: .normal)
            }else{
                
                self.con_VwSearch.constant = 50;
                self.con_SearchX.constant = 65;
                self.con_SearchRight.constant = 80;
                self.con_SearchX2.constant = 65;
                self.con_SearchRight2.constant = 80;
                self.con_SearchY.constant = -40
                self.con_SearchWidth.constant = 30
                self.img_HeaderImage.image = UIImage(named:"icon_backBlack")
                
                self.vw_SearchBar2.isHidden = true
                self.img_HeaderIcon.isHidden = true
                self.tf_Search.isHidden = true
                self.btn_SearchReStart.isHidden = false
                self.lbl_SearchTitle_1.isHidden = false
                self.lbl_SearchTitle_2.isHidden = false
                self.lbl_SearchTitle_1.text = self.tf_Search.text
                self.lbl_SearchTitle_2.text = self.tf_Search2.text
                
                if self.btn_Search.isSelected == false {
                    self.btn_Search.setTitle("Map", for: .normal)
                }else{
                    self.btn_Search.setTitle("List", for: .normal)
                }
                self.btn_CancelSearch.setTitle("Filter", for: .normal)
                self.btn_CancelSearch.setImage(UIImage(named: ""), for: .normal)

            }
            
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            if self.tf_Search2.text == ""{
                self.tf_Search2.text = "Current Location"
                self.tf_Search2.textColor = UIColor(red: 72/255, green: 180/255, blue: 240/255, alpha: 1)
            }
        })
    }
    
    func reloadData(){
        tbl_Main.reloadData()
        tbl_Search.reloadData()
        tbl_SearchListing.reloadData()
    }
    func hideView(){
        tbl_Main.isHidden = true
        self.vw_SearchBar.isHidden = true
        tbl_Search.isHidden = true
        self.vw_SearchBar2.isHidden = true
        tbl_SearchListing.isHidden = true
        vw_MapView.isHidden = true
        vw_PinClick.isHidden = true
    }
    func completedServiceCalling(){
        //Comman fuction action
        refresh?.endRefreshing()
        bool_Load = false
    }
    
    // MARK: -- Mapview Methods --
    func manageMapView(){
        
        vw_MapView.removeAnnotations(vw_MapView.annotations)
        manager = ClusterManager()
        
        if arr_ListingProduct.count != 0 {
            let locations : NSMutableArray = []
            
            for i in (0...arr_ListingProduct.count - 1){
                var dict_Data : NSDictionary = NSDictionary()
                
                let obj : KatikaViewObject = arr_ListingProduct[i] as!KatikaViewObject
                
                if obj.str_shop_name.length != 0 && obj.str_shop_lat.length != 0 && obj.str_shop_long.length != 0 &&  obj.str_shop_lat != "" && obj.str_shop_long != ""{
                    dict_Data = [
                        "title" : obj.str_shop_name,
                        "latitude" : obj.str_shop_lat,
                        "longitude" : obj.str_shop_long,
                    ]
                    locations.add(dict_Data)
                }
            }
            
            //Start to nil
            manager = ClusterManager()
            
            // Add annotations to the manager.
            let arr_Location : NSMutableArray = []
            let annotations: [Annotation] = (0..<locations.count).map { i in
                var arr : NSDictionary = (locations[i] as? NSDictionary)!

                let annotation = Annotation()
                
//                CATransaction.setAnimationDuration(CAAnimation)
                annotation.coordinate = CLLocationCoordinate2D(latitude: (arr["latitude"] as! NSString).doubleValue, longitude: (arr["longitude"] as! NSString).doubleValue)
                annotation.title = String(i)
                let color = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
                
                annotation.type = .image(UIImage(named: "pin")?.filled(with: color))
                
                arr_Location.add(annotation.coordinate)
                
                return annotation
            }
//            manager.add(annotations)
            vw_MapView.addAnnotations(annotations)
            
            coordinateRegionForCoordinates(coords: arr_Location, coordCount: arr_Location.count)
            //        vw_MapView.setRegion(coordinateRegionForCoordinates(coords: arr_Location, coordCount: arr_Location.count), animated: false)
        }else{
            
            vw_MapView.removeAnnotations(vw_MapView.annotations)
            manager = ClusterManager()
        }
    }
    func coordinateRegionForCoordinates(coords: NSMutableArray, coordCount: Int) { //-> MKCoordinateRegion
        //If find only one pin than true first condition
        if coords.count == 1 {
            
            let center : CLLocationCoordinate2D = (coords[0] as? CLLocationCoordinate2D)!
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            vw_MapView.setRegion(region, animated: true)
            
        }else{
        
            var r: MKMapRect = MKMapRect.null
            for i in 0..<coordCount {
                let cordinate : CLLocationCoordinate2D = (coords[i] as? CLLocationCoordinate2D)!
                let p: MKMapPoint = MKMapPoint.init(cordinate)
                r = r.union(MKMapRect.init(x: p.x, y: p.y, width: 0, height: 0))
            }
            
            //Set region in map view
            vw_MapView.setRegion(MKCoordinateRegion.init(r), animated: true)
            
            //Reduce zoom level
            let f = vw_MapView.mapRectThatFits(r, edgePadding: UIEdgeInsets.init(top: CGFloat((Int(Constant.windowHeight)*20)/100),left: CGFloat((Int(Constant.windowWidth)*20)/100), bottom: CGFloat((Int(Constant.windowHeight)*20)/100), right: CGFloat((Int(Constant.windowWidth)*20)/100)))
            vw_MapView.setVisibleMapRect(f, animated: true)
        }

//        return MKCoordinateRegionForMapRect(r)
    }
    func mapPinClick(tag : Int){
        //Manage Data
        let obj : KatikaViewObject = arr_ListingProduct[tag] as!KatikaViewObject
        
        vw_ClickPinRateView.rating = Double(obj.str_TotalReview as String)!
        lbl_ClickPinTitle.text = obj.str_shop_name as String
        lbl_ClickPinAddress.text = obj.str_shop_location as String
        lbl_ClickPinShopCategory.text = obj.str_shop_name as String
        
        vw_PinClick.isHidden = false
        btn_ClickPinShop.tag = Int(obj.str_shop_id as String)!
    }
    //MARK: -- Category selection Delegate Method --
    func SelectionOption(info: String) {
        tf_Search.text = info
        
        self.Get_Product()
        self.returSearch()
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
        vw_BaseView?.callmethod(_int_Value: 0)
    }
    @IBAction func btn_Tab_Fav(_ sender: Any) {
        vw_BaseView?.callmethod(_int_Value: 1)
    }
    @IBAction func btn_Tab_Katika(_ sender: Any) {
//        vw_BaseView?.callmethod(_int_Value: 2)
    }
    @IBAction func btn_Tab_Search(_ sender: Any) {
        vw_BaseView?.callmethod(_int_Value: 3)
    }
    @IBAction func btn_Tab_Inbox(_ sender: Any) {
        vw_BaseView?.callmethod(_int_Value: 4)
    }

    @IBAction func btn_CancelSearch(_ sender : Any){
        //Only hide when search not activate
        
        if btn_CancelSearch.titleLabel?.text == " "{

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
            }//
//            if bool_Search_Active == false {
//           
//            }
            self.view.endEditing(true)
        }else{
            self.performSegue(withIdentifier: "shopfilter", sender: self)
        }
        
    }
    @IBAction func btn_MyLocationClick(_ sender : Any){
        self.vw_SearchBar.isHidden = false

        if btn_Search.titleLabel?.text == "Search"{
            
            self.Get_Product()
            self.returSearch()
        }else{
            vw_PinClick.isHidden = true
            
            if btn_Search.isSelected == false{
                btn_Search.isSelected = true
                self.hideView()
                vw_MapView.isHidden = false
                
                self.btn_Search.setTitle("List", for: .normal)
                
                //Call map view when open map
                self.manageMapView()

                
            }else{
                btn_Search.isSelected = false
                self.hideView()
                tbl_Main.isHidden = false
                self.vw_SearchBar.isHidden = false
                 tbl_SearchListing.isHidden = false
                self.vw_SearchBar.isHidden = false
                self.btn_Search.setTitle("Map", for: .normal)
            }
        }
    }
    
    @IBAction func btn_SearchReStart(_ sender : Any){
        tf_Search.becomeFirstResponder()
        btn_SearchReStart.isHidden = true
        bool_Search_Active = false
    }
    
    @IBAction func btn_ClickPinShop(_sender : Any){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
        view.str_ProductIDGet = String(btn_ClickPinShop.tag) as NSString
        self.navigationController?.pushViewController(view, animated: false)
    }
    
    
    // MARK: - Get/Post Method -
    func Get_Location(){
        
        //Declaration URL
        let strURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(tf_Search2.text!)&types=establishment|geocode&radius=500&language=en&key=\(Constant.apiKeyGoogle)"
        print(strURL)
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "googleLocation"
        webHelper.methodType = "get"
        webHelper.strURL = strURL
        webHelper.dictType = NSDictionary()
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
    }
    func Get_LocationPlace(str_PlaceId : NSString){
        
        //Declaration URL
        let strURL = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(str_PlaceId)&key=\(Constant.apiKeyGoogle)"
        print(strURL)
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "googlePlaceAPI"
        webHelper.methodType = "get"
        webHelper.strURL = strURL
        webHelper.dictType = NSDictionary()
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
    }
    
    func Get_Product(){
        
        int_CountLoad = Constant.int_LoadMax
        bool_SearchMore = false
        bool_ViewWill = true
        arr_ListingProduct = []
        self.reloadData()
        self.Post_SearchShopListing(count:int_CountLoad)
        
        bool_Search_Active = true
        if btn_Search.isSelected == false {
            self.btn_Search.setTitle("Map", for: .normal)
        }else{
            self.btn_Search.setTitle("List", for: .normal)
        }
//        self.btn_CancelSearch.setImage(UIImage(named: "filter_white"), for: .normal)
        self.btn_CancelSearch.setTitle("Filter", for: .normal)
        self.btn_CancelSearch.setImage(UIImage(named: ""), for: .normal)

        
        self.reloadData();
        
        //Show both Top Bar Button
        self.btn_Search.isHidden = false
    }
    func Get_Product_FirstTime(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)recent_view_business_list"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid as! String,
            "skip" : "0",
            "total" : "20",
            "latitude" : String(Float((currentLocation?.coordinate.latitude)!)),
            "longitude" : String(Float((currentLocation?.coordinate.longitude)!)),
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "recent_view_business_list"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }
   
    func Get_SearchCategory(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_directory_category_new"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "categoryid" : "0",
            "skip" : "0",
            "total" : "5",
            "type" : "0",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_category"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }
    
    func Post_SearchDirectory(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)search_directory_business"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "searchkey" : tf_Search.text ?? "",
            "latitude" : String(float_Latitude),
            "longitude" : String(float_Longitude),
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "search_directory_business"
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
    
    func Post_SearchShopListing(count:Int){
        bool_Load = true
        
        //Confition for search bar
        if float_Latitude == Float((currentLocation?.coordinate.latitude)!) && float_Longitude  == Float((currentLocation?.coordinate.longitude)!){
            tf_Search2.text = "Current Location"
            tf_Search2.textColor = UIColor(red: 72/255, green: 180/255, blue: 240/255, alpha: 1)
        }
        
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_business"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "latitude" : String(float_Latitude),
            "longitude" : String(float_Longitude),
            "searchkey" : tf_Search.text ?? "",
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)"
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_business"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        
        (arr_ListingProduct.count == 0) ? (webHelper.indicatorShowOrHide = true) : (webHelper.indicatorShowOrHide = false)
        
//        if bool_SearchMore == true{
            webHelper.startDownload()
//        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "shopfilter"{
            
            let view : FilterViewController = segue.destination as! FilterViewController
            view.str_ValueType = "shop"
            view.str_Type = "business"
        }else if segue.identifier == "categorydetail" {
            let  categoryView  = segue.destination as! CategoryListingDictionaryViewController
            categoryView.delegate = self
        }
        
        //
    }
    
}

// MARK: - Tableview Files -
extension KatikaDirectoryViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tbl_Search == tableView {
            return 45
        }else if tbl_SearchListing == tableView {
            return 80
        }else if tbl_Main == tableView {
            
            //Condition for If data category search than show category other wise show as a defualt
            if arr_CateogrySearch.count == 0 {
                if indexPath.section == 0 {
                    return 45
                }else if indexPath.section == 1{
                    if arr_Main.count == 0 && tf_Search.text != "" {
                        return 40
                    }else{
                        return CGFloat(manageFont(font: 180))
                    }
                }
            }else{
               return 45
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tbl_Search == tableView {
            return 0
        }else if tbl_SearchListing == tableView {
            return 0
        }else if tbl_Main == tableView {
            
            //Condition for If data category search than show category other wise show as a defualt
            if arr_CateogrySearch.count == 0 {
                if section == 0{
                    return 0
                }else if section == 1{
                    if arr_Main.count == 0 {
                        return 0
                    }else{
                        return 45
                    }
                }
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
    {
        if tbl_Search == tableView {
            return 1
        }else if tbl_SearchListing == tableView {
            return 1
        }else if tbl_Main == tableView {
            
            //Condition for If data category search than show category other wise show as a defualt
            if arr_CateogrySearch.count == 0 {
                return 2
            }else{
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tbl_Search == tableView {
            return arr_SearchLocation.count + 1
        }else if tbl_SearchListing == tableView {
                if arr_ListingProduct.count == 0 {
                    return 1
                }else{
                    return arr_ListingProduct.count
                }
        }else if tbl_Main == tableView {
            //If search result 0 than only show defualt value in list
            if arr_CateogrySearch.count == 0 {
                if section == 0 {
                    return arr_Cateogry.count
                }else  if section == 1 {
                    if arr_Main.count == 0{
                        return 0
                    }
                    return 1
                }
            }else{
                return arr_CateogrySearch.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tbl_Search == tableView {
            return nil
        }else if tbl_SearchListing == tableView {
            return nil
        }else if tbl_Main == tableView {
            //If search result 0 than only show defualt value in list
            
            if arr_CateogrySearch.count == 0 {
                if section == 0{
                    return nil;
                }else if section == 1{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "section")as! KatikaTableviewCell
                    
                    cell.lbl_Title_Section.text = "WHAT'S NEW AROUND YOU"
                    
                    return cell
                }else {
                    return nil
                }
            }
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tbl_Search == tableView {
            var cell_Identifier = "list"
            if indexPath.row == 0 {
                cell_Identifier = "currentlocation"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_Identifier, for:indexPath as IndexPath) as! KatikaTableviewCell
            
            if indexPath.row != 0 {
                
                let obj = arr_SearchLocation[indexPath.row-1] as? KatikaSearchLocationObject
                
                cell.lbl_LocationName.text = obj?.str_LocationName as String?
            }
            
            return cell
        }else  if tbl_SearchListing == tableView {
            var cell_Identifier = "cell2"
            if arr_ListingProduct.count == 0 {
                cell_Identifier = "nodata"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_Identifier, for:indexPath as IndexPath) as! KatikaTableviewCell

            if arr_ListingProduct.count != 0 {
                
                let obj : KatikaViewObject = arr_ListingProduct[indexPath.row] as!KatikaViewObject
                cell.lbl_ProductTitle.text = obj.str_shop_name as String?
                cell.lbl_ProductPrize.text = ""
                cell.lbl_ProductTitleHeader.text = ""
                cell.lbl_ProductSubTitleHeader.text = ""
                cell.lbl_ShopAddress.text = obj.str_shop_location as String?
                cell.lbl_ShopDistance.text = obj.str_distance as String?
                cell.lbl_ShopCategory.text = obj.str_shopcategory as String?
           
                if obj.str_TotalReview != "0" {
                    cell.lbl_ProductRaviews.text =  ("\(obj.str_TotalReview as String! ?? "") Reviews")
                }else{
                    cell.lbl_ProductRaviews.text =  ("\(obj.str_TotalReview as String! ?? "") Review")
                }
                
                if obj.str_AvgReview.length != 0 {
                    cell.vw_Rate_UserRate.rating =  Double(obj.str_AvgReview as String)!
                }else{
                    cell.vw_Rate_UserRate.rating =  0
                }
                
            
                //Image set
                cell.img_ProductImage.sd_setImage(with: URL(string: obj.str_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                
            }else{
                cell.lbl_NoData.text = "No business available"

            }
            
            return cell
        }else{
            
            var cell_Identifier = "cell"
            
            if arr_CateogrySearch.count == 0 {
                if indexPath.section == 0 {
                    cell_Identifier = "categorylisting"
                }else  if indexPath.section == 1 && arr_Main.count == 0 && tf_Search.text != ""{
                    cell_Identifier = "nodata"
                }
            }else{
                let obj : KatikaDirectorySearch = arr_CateogrySearch[indexPath.row] as! KatikaDirectorySearch
                if obj.str_CategoryType == "Cat" {
                    cell_Identifier = "searchcategory"
                }else{
                    cell_Identifier = "searchcategorywithproduct"
                }
            }
  
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_Identifier, for:indexPath as IndexPath) as! KatikaTableviewCell
            
            //If search result 0 than only show defualt value in list
             if arr_CateogrySearch.count == 0 {
                if indexPath.section == 0 {
                    //Condition for More category title in last cell in section
                    
                    if arr_Cateogry.count-1 == indexPath.row{
                        cell.lbl_Title_Category.text = "More Cateogries"
                        cell.img_Category_Category.image = UIImage(named:"icon_More")
                         cell.lbl_Title_Category.textColor = UIColor.black

                    }else{
                        
                        let obj : KatikaViewObject = arr_Cateogry[indexPath.row] as! KatikaViewObject
                        
                        cell.lbl_Title_Category.text = obj.str_Category_Title as String
                        cell.lbl_Title_Category.textColor = UIColor.black
                        
                        //Image set
                        cell.img_Category_Category.sd_setImage(with: URL(string: obj.str_Category_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                        
                    }
                }else if indexPath.section == 1 {
                    if arr_Main.count == 0 && tf_Search.text != "" {
                        cell.lbl_NoData.text = "No product available"
                    }else{
   
                        
                        //RLOAD COLLECTION VIEW
                        if arr_Main.count != 0 {
                            cell.objShopCollectionView.tag = 100
                            cell.objShopCollectionView.reloadData()
                            
                        }
                        
//                        let obj : KatikaViewObject = arr_Main[indexPath.row] as!KatikaViewObject
//
//                        cell.lbl_ShopTitle.text = obj.str_shop_name as String?
//                        cell.lbl_ShopLocation.text = ""
//                        cell.lbl_ShopDistance.text = obj.str_Distance as String?
//
//                        if obj.str_TotalReview != "0" {
//                            cell.lbl_ShopReview.text = ("\(obj.str_TotalReview as String! ?? "") Reviews")
//                        }else{
//                            cell.lbl_ShopReview.text = ("\(obj.str_TotalReview as String! ?? "") Review")
//                        }
//
//
//                        if obj.str_AvgReview.length != 0 {
//                            cell.vw_Rate_UserRate.rating =  Double(obj.str_AvgReview as String)!
//                        }else{
//                            cell.vw_Rate_UserRate.rating =  0
//                        }
//
//
//                        //Image set
//                        cell.img_Shopimage.sd_setImage(with: URL(string: obj.str_ShopImage as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                        
                        
                    }
                }
             }else{
                let obj : KatikaDirectorySearch = arr_CateogrySearch[indexPath.row] as! KatikaDirectorySearch
                
                cell.lbl_Title_Category.text = obj.str_CateogryName as String?
                cell.lbl_Title_Category.textColor = UIColor.black
                
                if obj.str_CategoryType == "Cat" {
                    cell_Identifier = "searchcategory"
                }else{
                    
                    //Image set
                    cell.img_Category_Category.sd_setImage(with: URL(string: obj.str_CategoryImage as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbl_Main {
            //If listing defualt than Condtion true
            if arr_CateogrySearch.count == 0 {
                if indexPath.section == 1 {
                    let obj : KatikaViewObject = arr_Main[indexPath.row] as! KatikaViewObject
                    
                    //SET ANALYTICS
                    let name = "\("directory_sub")\(obj.str_shop_name as String)"
                    Analytics.logEvent(name, parameters: nil)
                    
                    //Move to shop detail view
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let view = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
                    view.str_ProductIDGet = obj.str_shop_id
                    self.navigationController?.pushViewController(view, animated: false)

                }else if indexPath.section == 0{
                    if arr_Cateogry.count-1 == indexPath.row {
                        self.performSegue(withIdentifier: "categorydetail", sender: self)
                    }else{
                        let obj : KatikaViewObject = arr_Cateogry[indexPath.row] as! KatikaViewObject
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let view = storyboard.instantiateViewController(withIdentifier: "CategoryListingDictionaryViewController") as! CategoryListingDictionaryViewController
                        view.str_KeyName = obj.str_Category_ID as String
                        view.str_KeyNameTitle = obj.str_Category_Title as String
                        view.delegate = self
                        self.navigationController?.pushViewController(view, animated: true)

                    }
                }
            }else{
                let obj : KatikaDirectorySearch = arr_CateogrySearch[indexPath.row] as! KatikaDirectorySearch
                
                tf_Search.text = obj.str_CateogryName as String
                //SET ANALYTICS
                let name = "\("directory_")\(obj.str_CateogryName as String)"
                Analytics.logEvent(name, parameters: nil)
                
                
                if obj.str_CategoryType == "Cat" {
                   self.Get_Product()
                   self.returSearch()
                }else{
                    //SET ANALYTICS
                    let name = "\("directory_sub")\(obj.str_CateogryName as String)"
                    Analytics.logEvent(name, parameters: nil)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let view = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
                    view.str_ProductIDGet = obj.str_CategoryID
                    self.navigationController?.pushViewController(view, animated: false)
                }
            }
        }else if tableView == tbl_Search {
            if indexPath.row == 0 {
                tf_Search2.text = "Current Location"
                tf_Search2.textColor = UIColor(red: 72/255, green: 180/255, blue: 240/255, alpha: 1)
                
                float_Latitude = Float((currentLocation?.coordinate.latitude)!)
                float_Longitude  = Float((currentLocation?.coordinate.longitude)!)
            }else{
                let obj = arr_SearchLocation[indexPath.row-1] as? KatikaSearchLocationObject
                tf_Search2.text = obj?.str_LocationName as String?
                tf_Search2.textColor = UIColor.black
                
                self.Get_LocationPlace(str_PlaceId:obj?.str_PlaceID as! String as NSString)
            }
            tf_Search.becomeFirstResponder()

        }else if indexPath.section == 0 && indexPath.row == arr_Cateogry.count {
            self.performSegue(withIdentifier: "categorydetail", sender: self)
        }else  if tbl_SearchListing == tableView {
            let obj : KatikaViewObject = arr_ListingProduct[indexPath.row] as!KatikaViewObject
            //SET ANALYTICS
            let name = "\("directory_")\(obj.str_shop_name as String)"
            Analytics.logEvent(name, parameters: nil)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
            view.str_ProductIDGet = obj.str_shop_id
            self.navigationController?.pushViewController(view, animated: false)
        }
    }
}



//MARK: - Map View -

extension KatikaDirectoryViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if Constant.KatikaDirectoryClustoringShow == true{
            let color = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
            if let annotation = annotation as? ClusterAnnotation {
                let identifier = "Cluster"
                var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                if view == nil {
                    view = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, type: .color(color, radius: 25))
                } else {
                    view?.annotation = annotation
                }
                return view
            } else {

                if annotation is MKUserLocation
                {
                    return nil
                }
                var annotationView = vw_MapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
                if annotationView == nil{
                    annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
                    annotationView?.canShowCallout = false

                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.calloutTapped))
                    annotationView?.addGestureRecognizer(tapGesture)

                }else{
                    annotationView?.annotation = annotation
                }
                annotationView?.image = UIImage(named: "map_Pin")
                return annotationView
            }
        }else{
            if annotation is MKUserLocation
            {
                return nil
            }
            var annotationView = vw_MapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
            if annotationView == nil{
                annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
                annotationView?.canShowCallout = false
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.calloutTapped))
                annotationView?.addGestureRecognizer(tapGesture)
                
            }else{
                annotationView?.annotation = annotation
            }
            annotationView?.image = UIImage(named: "map_Pin")
            return annotationView
        }
    }
    class AnnotationView: MKAnnotationView
    {
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let hitView = super.hitTest(point, with: event)
            if (hitView != nil)
            {
                self.superview?.bringSubviewToFront(self)
            }
            return hitView
        }
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let rect = self.bounds;
            var isInside: Bool = rect.contains(point);
            if(!isInside)
            {
                for view in self.subviews
                {
                    isInside = view.frame.contains(point);
                    if isInside
                    {
                        break;
                    }
                }
            }
            return isInside;
        }
    }
    
    
    @objc func calloutTapped(_ sender: Any) {
        let newLocation: CGPoint = (sender as AnyObject).location(in: self.view)
        print(newLocation)
//        vw_PinClick.isHidden = false
        
        var float_Setbox_X : Int = 0
        var float_Setbox_Y : Int = 0
        
        //Box size
        let float_Box_Width : Int = 200
        let float_Box_Height : Int = 100
        
        let float_Y = newLocation.y - 50
        let float_X = newLocation.x
        
        //Manage bottom or Upper
        //First prioritry for upper side
        if Int(float_Y) - Int(float_Box_Height) - 50 >=  0{
            float_Setbox_Y = Int(float_Y) - Int(float_Box_Height)
            float_Setbox_Y = float_Setbox_Y + 30
        }else{
            float_Setbox_Y = Int(float_Y) + 70
        }
        
        //Manage Left or right side
        if Int(float_X) >= Int(float_Box_Width/2) && Int(Constant.windowWidth) - Int(float_X) >= Int(float_Box_Width/2){
            float_Setbox_X = Int(float_X) - Int(float_Box_Width/2)
        }else if Int(float_X) < Int(float_Box_Width/2){
            float_Setbox_X = 5
        }else if Int(Constant.windowWidth) - Int(float_X) < Int(float_Box_Width/2){
            float_Setbox_X = Int(Constant.windowWidth) - Int(float_Box_Width) - 5
        }
        
        let rect = CGRect(x: CGFloat(float_Setbox_X), y: CGFloat(float_Setbox_Y ), width: CGFloat(float_Box_Width), height: CGFloat(float_Box_Height))

        vw_PinClick.frame = rect
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        vw_PinClick.isHidden = true
        if Constant.KatikaDirectoryClustoringShow == true{
            manager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
        }
        
    }
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        vw_PinClick.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        
        if let cluster = annotation as? ClusterAnnotation {
            mapView.removeAnnotations(mapView.annotations)
            
            let arr_Location : NSMutableArray = []
             for annotation in cluster.annotations {
                arr_Location.add(annotation.coordinate)
            }
            coordinateRegionForCoordinates(coords: arr_Location, coordCount: arr_Location.count)

        }else{
            //Manage box for open after map pin
            self.mapPinClick(tag: Int((annotation.title as? String)!)!)
        }
        
        print(view.frame)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
}





extension KatikaDirectoryViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        print(response)
        if strRequest == "googleLocation" {
            
            arr_SearchLocation = []
            if response["status"] as? String == "OK"{
                let arr_result = response["predictions"] as! NSArray
                
                for i in 0..<arr_result.count{
                    let dict_Sub_Address = arr_result[i] as! NSDictionary
                    
                    //Demo data
                    let obj = KatikaSearchLocationObject ()
                    obj.str_LocationName = dict_Sub_Address["description"] as! String as NSString
                    obj.str_PlaceID = dict_Sub_Address["place_id"] as! String as NSString
                    arr_SearchLocation.add(obj)
                }
            }
            self.reloadData()
            
        }else if strRequest == "googlePlaceAPI"{
            if response["status"] as? String == "OK"{
                let dict_result = response["result"] as! NSDictionary
                let dict_geometry = dict_result["geometry"] as! NSDictionary
                let dict_location = dict_geometry["location"] as! NSDictionary
               
                float_Latitude = Float(dict_location.getStringForID(key:"lat") as! String)!
                float_Longitude = Float(dict_location.getStringForID(key:"lng") as! String)!
            }
            
        }else if strRequest == "get_category" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            arr_Cateogry = []
            
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                var obj2 = KatikaViewObject()
                obj2.str_Category_ID = ("\(dict_Data["business_category_id"] as! Int)" as NSString)
                obj2.str_Category_Title = dict_Data["s_title"] as! String as NSString
                obj2.str_Category_Image = dict_Data["s_image"] as! String as NSString
                if arr_Cateogry.count != 5{
                    arr_Cateogry.add(obj2)
                }
            }
            arr_Cateogry.add("")
            
            self.reloadData()
        }else  if strRequest == "recent_view_business_list" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            arr_Main  = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                let arr_Image = dict_Data["business_background"] as! NSArray
                
                //Receintly viewed Product
                let obj = KatikaViewObject ()
                obj.str_shop_id = ("\(dict_Data["business_id"] as! Int)" as NSString)
                obj.str_shop_name = dict_Data["business_name"] as! String as NSString
                obj.str_ShopImage = dict_Data["business_logo"] as! String as NSString
                obj.str_Lat = dict_Data["business_lat"] as! String as NSString
                obj.str_Long = dict_Data["business_long"] as! String as NSString
                obj.str_Shop_BG = ""
                obj.str_Distance = dict_Data["distance"] as! String as NSString
                obj.str_TotalReview = dict_Data["TotalReview"] as! String as NSString
                obj.str_AvgReview = dict_Data["AvgReview"] as! String as NSString
                obj.str_shopsubcategory = dict_Data.getStringForID(key: "sub_category_name") ?? ""

                if arr_Image.count != 0{
                    let dict_Data2 = arr_Image[0] as! NSDictionary
                    obj.str_ShopImage = dict_Data2["image"] as! String as NSString
                }
//                obj.arrImage = arr_Image_Store
                arr_Main.add(obj)
            }
            self.reloadData()
        }else if strRequest == "search_directory_business"{
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            arr_CateogrySearch  = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                //Category Search result
                let obj = KatikaDirectorySearch ()
                obj.str_CategoryID = ("\(dict_Data["ID"] as! Int)" as NSString)
                obj.str_CateogryName = dict_Data["Title"] as! String as NSString
                obj.str_CategoryType = dict_Data["Type"] as! String as NSString
                obj.str_CategoryImage = dict_Data["Image"] as! String as NSString
             
                if Constant.SearchlistingresultKatikaDirectory == true{
                    arr_CateogrySearch.add(obj)
                }
            }
            self.reloadData()
            //arr_CateogrySearch
        }else if strRequest == "get_business"{
            self.completedServiceCalling()

            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            let arr_StoreTemp : NSMutableArray = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                let arr_Image = dict_Data["Images"] as? NSArray ?? []
                
                let obj = KatikaViewObject ()
                obj.str_shop_id = ("\(dict_Data["business_id"] as! Int)" as NSString)
                obj.str_shop_name = dict_Data["business_name"] as! String as NSString
                obj.str_shop_lat = dict_Data["business_lat"] as! String as NSString
                obj.str_shop_long = dict_Data["business_long"] as! String as NSString
                obj.str_shop_location = dict_Data["business_location"] as! String as NSString

                obj.str_shopcategory = dict_Data["subcategory"] as! String as NSString

                obj.str_TotalReview = ("\(dict_Data["total_business_review"] as! Int)" as NSString)
                obj.str_AvgReview = dict_Data["avg_business_review"] as? NSString ?? "0"
                obj.str_distance = dict_Data["distance"] as! String as NSString
                print("================")
                print(obj.str_shop_name)
                print(obj.str_AvgReview)
                print("================")

                if arr_Image.count != 0{
                    let dict_Image = arr_Image[0] as! NSDictionary
                    obj.str_Image = dict_Image["image"] as! String as NSString
                }
                arr_StoreTemp.add(obj)
            }
            
            //Refresh code
            if bool_ViewWill == true {
                arr_ListingProduct = []
                int_CountLoad = arr_StoreTemp.count
            }else{
                int_CountLoad = int_CountLoad + arr_StoreTemp.count
            }
            
            for i in (0...arr_StoreTemp.count-1){
                arr_ListingProduct.add(arr_StoreTemp[i])
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
            self.reloadData()
            
            if self.btn_Search.isSelected == true {
                self.manageMapView()
            }
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        //SET THE TABLE FRAME
        tbl_SearchListing.frame = rectDetail
        //Reload map view
        if strRequest == "get_business"{
            if bool_ViewWill == true {
                arr_ListingProduct = []
                self.reloadData()
            }
            
            if self.btn_Search.isSelected == true {
                self.manageMapView()
            }
        }
        
        self.completedServiceCalling()
    }
    
}







//MARK: - Collection View -
extension KatikaDirectoryViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returen number of cell with content available in array
        if collectionView.tag == 100 {
            if arr_Main.count == 0{
                return 1
            }
            return arr_Main.count
        }
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Returen number of cell with content available in array
        return CGSize(width: CGFloat(manageFont(font: 130)), height: CGFloat(manageFont(font: 150)))

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var str_Identifier : String = "NewHomeViewCollectioncell"
        if collectionView.tag == 100 {
            if arr_Main.count == 0{
                str_Identifier = "nodata"
            }
        }
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: str_Identifier, for: indexPath) as! NewHomeViewCollectioncell
        if collectionView.tag == 100 {
            
            let obj : KatikaViewObject = arr_Main[indexPath.row] as!KatikaViewObject
            
            //SET TILE FONT
            cell.lbl_Title_OtherTab.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
//            cell.lbl_SubTitle_OtherTab.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
            
//            //GET REVIEW
//            var strReview : String = ""
//            if obj.str_TotalReview != "0" {
//                strReview = ("\(obj.str_TotalReview as String! ?? "") Reviews")
//            }else{
//                strReview = ("\(obj.str_TotalReview as String! ?? "") Review")
//            }
            
            //Set text in label
            cell.lbl_Title_OtherTab.text = obj.str_shop_name as String
            cell.lbl_SubTitle_OtherTab.text = obj.str_shopsubcategory

//            cell.lbl_SubTitle_OtherTab.text = "\(obj.str_Distance as String) , \(strReview)"
            
            //Image set
            cell.img_Image_OtherTab.sd_setImage(with: URL(string: obj.str_ShopImage as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
            
            
            //Layer set
            cell.vw_Back_OtherTab.layer.cornerRadius = 5.0
            cell.vw_Back_OtherTab.layer.masksToBounds = true
            
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let obj : KatikaViewObject = arr_Main[indexPath.row] as! KatikaViewObject
        
        //SET ANALYTICS
        let name = "\("directory_sub")\(obj.str_shop_name as String)"
        Analytics.logEvent(name, parameters: nil)
        
        //Move to shop detail view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
        view.str_ProductIDGet = obj.str_shop_id
        self.navigationController?.pushViewController(view, animated: false)
        
    }
}



// MARK: - Side Bar Controller -
extension KatikaDirectoryMainViewController : SlideMenuControllerDelegate {
    
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


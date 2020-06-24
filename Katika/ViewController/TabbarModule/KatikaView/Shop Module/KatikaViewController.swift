//
//  KatikaViewController.swift
//  Katika
//
//  Created by Katika on 18/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import MapKit
import Cosmos
import Firebase

class KatikaViewController: UIViewController,DismissCategoryViewDelegate,FFPullToLoadMoreViewDelegate {

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
    @IBOutlet var img_HeaderIcon : UIView!
    @IBOutlet var img_HeaderImage : UIImageView!

    //Label Declaration
    @IBOutlet var lbl_SearchTitle_1 : UILabel!
    @IBOutlet var lbl_SearchTitle_2 : UILabel!
    @IBOutlet var lbl_ClickPinTitle : UILabel!
    @IBOutlet var lbl_ClickPinAddress : UILabel!
    @IBOutlet var lbl_ClickPinShopCategory : UILabel!
    
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
    
    //Bool Decalratin
    var bool_Search_Active : Bool = false
    var bool_SearchMore: Bool = false
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    
    //Cluster Object
    var manager = ClusterManager()
    
    //Float Decalartion
    var float_Latitude : String = String((currentLocation?.coordinate.latitude)!)
    var float_Longitude : String = String((currentLocation?.coordinate.longitude)!)
    
    //Refresh Controller
    var refresh: UIRefreshControl?
    
    //Int Declaration
    var int_CountLoad: Int = 0
    
    //FOOTER LADER DECLARATION
    var objMainLoadMore: FFPullToLoadMoreView?
    var rectDetail = CGRect()

//    "latitude" : String(format:"%.5f", (currentLocation?.coordinate.latitude)!),
//    "longitude" : String(format:"%.5f", (currentLocation?.coordinate.longitude)!),
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commanMethod()
        
//
        // ADD COURSE AS FOOTER VIEW
        let CourseFootView = FFPullToLoadMoreView(frame: CGRect(x: 0, y: 0, width: tbl_SearchListing.bounds.size.width, height: 60))
        CourseFootView.delegate = self
        tbl_SearchListing.tableFooterView = CourseFootView
        tbl_SearchListing.tableFooterView?.backgroundColor = UIColor.clear
        objMainLoadMore = CourseFootView
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.manageNavigation()

        if katikaViewSelection != "1"{
            self.setViewwillAppearCode()
        }
       
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.Post_SearchShopListing(count:int_CountLoad)

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
    
//    // MARK: - Scrollview Manage -
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == tbl_Main {
//            view.endEditing(true)
//        }
//        else if scrollView == tbl_SearchListing{
//            view.endEditing(true)
//            if tbl_SearchListing.contentSize.height <= tbl_SearchListing.contentOffset.y + tbl_SearchListing.frame.size.height && tbl_SearchListing.contentOffset.y >= 0 {
//                if bool_Load == false && arr_ListingProduct.count != 0 {
//                    self.Post_SearchShopListing(count: int_CountLoad + Constant.int_LoadMax)
//                }
//            }
//        }
//    }
//
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
        objMainLoadMore?.ffLoadMoreScrollDidScroll(scrollView)
        
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        objMainLoadMore?.ffLoadMoreScrollDidEndDragging(scrollView)
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
            tbl_SearchListing.frame = CGRect(x: rectDetail.origin.x, y: rectDetail.origin.y, width: rectDetail.size.width, height: rectDetail.size.height-60)
            
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
        objMainLoadMore?.ffLoadMoreViewDataSourceDidFinishedLoading(tbl_Main)
        //        objMainLoadMore?.removeFromSuperview()
        //        tbl_Main.tableFooterView?.removeFromSuperview()
        tbl_SearchListing.frame = rectDetail
    }
    
    
    
    
    // MARK: - TextField Manage -
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //Start to checking
        btn_Search.setTitle("Search", for: .normal)
        btn_CancelSearch.setTitle("Cancel", for: .normal)

        if tf_Search == textField {
            self.reloadData()
            self.hideView()
            tbl_Main.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                //Constant Manage
                self.con_VwSearch.constant = 125;
                self.con_SearchX.constant = 10;
                self.con_SearchRight.constant = 10;
                self.con_SearchX2.constant = 10;
                self.con_SearchRight2.constant = 10;
                self.con_SearchY.constant = 20
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
                    self.con_VwSearch.constant = 120;
                    self.view.layoutIfNeeded()
                    
                    //Only hide when search not activate
                    if self.bool_Search_Active == false {
                        self.btn_CancelSearch.isHidden = false
                        self.btn_Search.isHidden = false
                    }
                }, completion: { (finished) in
                    
                })
                
            })
        }else if tf_Search2 == textField{
            self.hideView()
            tbl_Search.isHidden = false
            if tf_Search2.text == "Current Location"{
                tf_Search2.textColor = UIColor.black
                tf_Search2.text = ""
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if tf_Search == textField {
            
        }else if tf_Search2 == textField {
            tbl_Search.isHidden = true
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
            self.Post_SearchDirectory()
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
        
        
        vw_Tab1 = self
        
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
    func setViewwillAppearCode(){
        //Service Calling
        if btn_CancelSearch.titleLabel?.text == "Cancel"{
            self.Get_SearchCategory()
            self.Get_Product_FirstTime()
        }else{
            if bool_Load == false{
                int_CountLoad = Constant.int_LoadMax
                bool_SearchMore = true
                bool_ViewWill = true
                
                arr_ListingProduct = []
                
                self.reloadData()
                
//                self.Post_SearchShopListing(count:int_CountLoad)
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
            }else{
                tbl_Main.isHidden = false
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
                self.btn_CancelSearch.isHidden = true
                self.btn_Search.isHidden = true
                
                self.btn_Search.setTitle("Search", for: .normal)
                self.btn_CancelSearch.setTitle("Cancel", for: .normal)
            }else{
                
                self.con_VwSearch.constant = 50;
                self.con_SearchX.constant = 80;
                self.con_SearchRight.constant = 80;
                self.con_SearchX2.constant = 80;
                self.con_SearchRight2.constant = 80;
                self.con_SearchY.constant = -40
                
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
                    if Constant.KatikaDirectoryMapShow == true{
                        self.btn_Search.setTitle("Map", for: .normal)
                    }else{
                        self.btn_Search.setTitle("", for: .normal)
                    }
                }else{
                    self.btn_Search.setTitle("List", for: .normal)
                }
                
                self.btn_CancelSearch.setTitle("Filter", for: .normal)
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
        tbl_Search.isHidden = true
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
        
        if arr_ListingProduct.count != 0 {
            let locations : NSMutableArray = []
            
            for i in (0...arr_ListingProduct.count - 1){
                var dict_Data : NSDictionary = NSDictionary()
                
                let obj : KatikaViewObject = arr_ListingProduct[i] as!KatikaViewObject
                
                if obj.str_shop_name.length != 0 && obj.str_shop_lat.length != 0 && obj.str_shop_long.length != 0{
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
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: (arr["latitude"] as! NSString).doubleValue, longitude: (arr["longitude"] as! NSString).doubleValue)
                annotation.title = String(i)
                
                let color = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
                
                annotation.type = .image(UIImage(named: "pin")?.filled(with: color))
                
                arr_Location.add(annotation.coordinate)
                
                return annotation
            }
            manager.add(annotations)
            
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
        toggleLeft()
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
        
        if btn_CancelSearch.titleLabel?.text == "Cancel"{

            
            if bool_Search_Active == false {
                btn_CancelSearch.isHidden = true
                btn_Search.isHidden = true
                
                //Only hide when search not activate
                if self.bool_Search_Active == true {
                    self.Get_Product()
                }
                self.returSearch()
                
                self.btn_Search.setTitle("Search", for: .normal)
                self.btn_CancelSearch.setTitle("Cancel", for: .normal)
                
                UIView.animate(withDuration: 0.3, animations: {
                    //Constant Manage
                    self.con_VwSearch.constant = 85;
                    self.img_HeaderImage.image = UIImage(named:"icon_Search")
                    
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                })
            }else{
                
                //Show result view
                if self.btn_Search.isSelected == false {
                    if Constant.KatikaDirectoryMapShow == true{
                        self.btn_Search.setTitle("Map", for: .normal)
                    }else{
                        self.btn_Search.setTitle("", for: .normal)
                    }
                }else{
                    self.btn_Search.setTitle("List", for: .normal)
                }
                self.btn_CancelSearch.setTitle("Filter", for: .normal)
                
                UIView.animate(withDuration: 0.3, animations: {
                    //Constant Manage
                    self.con_VwSearch.constant = 50;
                    self.con_SearchX.constant = 80;
                    self.con_SearchRight.constant = 80;
                    self.con_SearchX2.constant = 80;
                    self.con_SearchRight2.constant = 80;
                    self.con_SearchY.constant = -40
                    self.img_HeaderImage.image = UIImage(named:"icon_backBlack")
                    
                    self.vw_SearchBar2.isHidden = true
                    self.img_HeaderIcon.isHidden = true
                    self.tf_Search.isHidden = true
                    self.btn_SearchReStart.isHidden = false
                    self.lbl_SearchTitle_1.isHidden = false
                    self.lbl_SearchTitle_2.isHidden = false
                    self.lbl_SearchTitle_1.text = self.tf_Search.text
                    self.lbl_SearchTitle_2.text = self.tf_Search2.text
                    
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                })
            }
            self.view.endEditing(true)
        }else{
            self.performSegue(withIdentifier: "shopfilter", sender: self)
        }
    }
    @IBAction func btn_MyLocationClick(_ sender : Any){
        
        if btn_Search.titleLabel?.text == "Search" && btn_CancelSearch.titleLabel?.text != "Filter"{
            
            self.Get_Product()
            self.returSearch()
        }else{
            if Constant.KatikaDirectoryMapShow == true{
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
                    tbl_SearchListing.isHidden = false
                    
                    self.btn_Search.setTitle("Map", for: .normal)
                }
            }
        }
    }
    
    @IBAction func btn_SearchReStart(_ sender : Any){
        tf_Search.becomeFirstResponder()
        btn_SearchReStart.isHidden = true
    }
    
    @IBAction func btn_ClickPinShop(_sender : Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
        view.str_ShopIDGet = String(btn_ClickPinShop.tag) as NSString
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
  
        bool_Search_Active = true
        if btn_Search.isSelected == false {
            if Constant.KatikaDirectoryMapShow == true{
                self.btn_Search.setTitle("Map", for: .normal)
            }else{
                self.btn_Search.setTitle("", for: .normal)
            }
        }else{
            self.btn_Search.setTitle("List", for: .normal)
        }
        self.btn_CancelSearch.setTitle("Filter", for: .normal)
        
        self.reloadData();
        
        //Show both Top Bar Button
        self.btn_CancelSearch.isHidden = false
        self.btn_Search.isHidden = false
    }
    func Get_Product_FirstTime(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)recent_view_shop_list"
        
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
        webHelper.strMethodName = "recent_view_shop_list"
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
        let strURL = "\(Constant.BaseURL)get_shop_category"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "categoryid" : "0",
            "skip" : "0",
            "total" : "11",
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
        let strURL = "\(Constant.BaseURL)search_directory"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "searchkey" : tf_Search.text ?? "",
            "latitude" : float_Latitude,
            "longitude" : float_Longitude,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "search_directory"
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
        if Float(float_Latitude) == Float((currentLocation?.coordinate.latitude)!) && Float(float_Longitude)  == Float((currentLocation?.coordinate.longitude)!){
            tf_Search2.text = "Current Location"
            tf_Search2.textColor = UIColor(red: 72/255, green: 180/255, blue: 240/255, alpha: 1)
        }
        
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)search_shop"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "latitude" : float_Latitude,
            "longitude" : float_Longitude,
            "category" : tf_Search.text ?? "",
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "search_shop"
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
        }else if segue.identifier == "categorydetail" {
            let  categoryView  = segue.destination as! CategoryListingViewController
            categoryView.delegate = self
        }
        
        //
    }
    
}

//MARK: - Search Object -

class KatikaViewObject: NSObject {
    //Product Listing View
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
    var str_Review : NSString = ""
    var str_ProductType : NSString = ""
    var str_Fav : NSString = ""
    var str_Checkin_date : NSString = ""
    
    var str_shop_id : NSString = ""
    var str_shop_name : NSString = ""
    var str_shop_lat : NSString = ""
    var str_shop_long : NSString = ""
    var str_shop_location : NSString = ""
    var str_TotalReview : NSString = ""
    var str_AvgReview : NSString = ""
    var str_shopcategory : NSString = ""
    var str_distance : NSString = ""
    var str_ShopImage : NSString = ""
    var str_Lat : NSString = ""
    var str_Long : NSString = ""
    var str_Shop_BG : NSString = ""
    var str_Distance : NSString = ""
    var str_shopsubcategory : String = ""

    
    
    //Catgory Cell
    var str_Category_Title : NSString!
    var str_Category_Image : NSString!
    var str_Category_ID : NSString!
}
class KatikaSearchLocationObject: NSObject {
    
    var str_LocationName : NSString!
    var str_PlaceID : NSString!
}
class KatikaSearchPlaceName: NSObject {
    
    var str_LocationName : NSString!
    var str_PlaceID : NSString!
}
class KatikaDirectorySearch: NSObject {
    
    var str_CateogryName : NSString!
    var str_CategoryID : NSString!
    var str_CategoryImage : NSString!
    var str_CategoryType : NSString!
}

// MARK: - Tableview Files -
extension KatikaViewController : UITableViewDelegate,UITableViewDataSource {
 
    

    
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
                        return CGFloat((Constant.windowHeight * 160)/Constant.screenHeightDeveloper)
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
                    return arr_Main.count
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
                    
                    cell.lbl_Title_Section.text = "WHAT NEW SHOPS ARE AROUND YOU"
                    
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
                cell.lbl_NoData.text = "No product available"
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

//            if bool_Search_Active == true {
//                cell_Identifier = "cell"
//                if arr_Main_Result.count == 0 {
//                    cell_Identifier = "nodata"
//                }
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_Identifier, for:indexPath as IndexPath) as! KatikaTableviewCell
            
            //If search result 0 than only show defualt value in list
             if arr_CateogrySearch.count == 0 {
                if indexPath.section == 0 {
                    //Condition for More category title in last cell in section
                    
//                    if arr_Cateogry.count-1 == indexPath.row{
//                        cell.lbl_Title_Category.text = "More Cateogries"
//                        cell.img_Category_Category.image = UIImage(named:"icon_More")
//
//                    }else{
                    
                        let obj : KatikaViewObject = arr_Cateogry[indexPath.row] as! KatikaViewObject
                        cell.lbl_Title_Category.text = obj.str_Category_Title as String
                        
                        //Image set
                        cell.img_Category_Category.sd_setImage(with: URL(string: obj.str_Category_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                        
//                    }
                }else if indexPath.section == 1 {
                    if arr_Main.count == 0 && tf_Search.text != "" {
                        cell.lbl_NoData.text = "No product available"
                    }else{
   
                        let obj : KatikaViewObject = arr_Main[indexPath.row] as!KatikaViewObject
                        
                        cell.lbl_ShopTitle.text = obj.str_shop_name as String?
                        cell.lbl_ShopLocation.text = ""
                        cell.lbl_ShopDistance.text = obj.str_Distance as String?
                        
                        if obj.str_TotalReview != "0" {
                            cell.lbl_ShopReview.text = ("\(obj.str_TotalReview as String! ?? "") Reviews")
                        }else{
                            cell.lbl_ShopReview.text = ("\(obj.str_TotalReview as String! ?? "") Review")
                        }
                        
                        if obj.str_AvgReview.length != 0 {
                            cell.vw_Rate_UserRate.rating =  Double(obj.str_AvgReview as String)!
                        }else{
                            cell.vw_Rate_UserRate.rating =  0
                        }
                        
                        //Image set
                        cell.img_Shopimage.sd_setImage(with: URL(string: obj.str_ShopImage as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
                        
                        
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
                    let name = "\("product_sub_")\(obj.str_shop_name as String)"
                    Analytics.logEvent(name, parameters: nil)
                    
                    //Move to shop detail view
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let view = storyboard.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
                    view.str_ShopIDGet = obj.str_shop_id
                    self.navigationController?.pushViewController(view, animated: false)

                }else if indexPath.section == 0{
                        let obj : KatikaViewObject = arr_Cateogry[indexPath.row] as! KatikaViewObject
                        tf_Search.text = obj.str_Category_Title as String
                    
                    //SET ANALYTICS
                    let name = "\("product_")\(obj.str_Category_Title as String)"
                    Analytics.logEvent(name, parameters: nil)
                    
                        self.Get_Product()
                        self.returSearch()
                }
            }else{
                let obj : KatikaDirectorySearch = arr_CateogrySearch[indexPath.row] as! KatikaDirectorySearch
                
                tf_Search.text = obj.str_CateogryName as String
                
                //SET ANALYTICS
                let name = "\("product_")\(obj.str_CateogryName as String)"
                Analytics.logEvent(name, parameters: nil)

                if obj.str_CategoryType == "Cat" {
                   self.Get_Product()
                   self.returSearch()
                }else{
                    

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let view = storyboard.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
                    view.str_ShopIDGet = obj.str_CategoryID
                    self.navigationController?.pushViewController(view, animated: false)
                }
            }
        }else if tableView == tbl_Search {
            if indexPath.row == 0 {
                tf_Search2.text = "Current Location"
                tf_Search2.textColor = UIColor(red: 72/255, green: 180/255, blue: 240/255, alpha: 1)
                
                float_Latitude = String((currentLocation?.coordinate.latitude)!)
                float_Longitude  = String((currentLocation?.coordinate.longitude)!)
            }else{
                let obj = arr_SearchLocation[indexPath.row-1] as? KatikaSearchLocationObject
                tf_Search2.text = obj?.str_LocationName as String?
                tf_Search2.textColor = UIColor.black
                
                self.Get_LocationPlace(str_PlaceId:obj?.str_PlaceID as! String as NSString)
            }
            tf_Search.becomeFirstResponder()

        }
        else  if tbl_SearchListing == tableView {
            let obj : KatikaViewObject = arr_ListingProduct[indexPath.row] as!KatikaViewObject
            
            //SET ANALYTICS
            let name = "\("product_sub_")\(obj.str_shop_name as String)"
            Analytics.logEvent(name, parameters: nil)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
            view.str_ShopIDGet = obj.str_shop_id
            self.navigationController?.pushViewController(view, animated: false)
        }
    }
}

//MARK: - Tableview View Cell -
class KatikaTableviewCell : UITableViewCell{
    //Main Listing product
    @IBOutlet weak var lbl_ProductTitle: UILabel!
    @IBOutlet weak var lbl_ProductRaviews: UILabel!
    @IBOutlet weak var lbl_ProductType: UILabel!
    @IBOutlet weak var lbl_ProductPrize: UILabel!
    @IBOutlet weak var lbl_ProductDistance: UILabel!
    @IBOutlet weak var lbl_ProductTitleHeader: UILabel!
    @IBOutlet weak var lbl_ProductSubTitleHeader: UILabel!
    @IBOutlet weak var img_ProductImage: UIImageView!
    @IBOutlet weak var objShopCollectionView: UICollectionView!

    
    //Category Listing Cell
    @IBOutlet weak var lbl_Title_Category : UILabel!
    @IBOutlet weak var img_Category_Category : UIImageView!
    
    //Section cell
    @IBOutlet weak var lbl_Title_Section : UILabel!
    
    //No data cell
    @IBOutlet weak var lbl_NoData : UILabel!

    //Search Location
    @IBOutlet weak var lbl_LocationName : UILabel!
    
    //View product details
    @IBOutlet weak var lbl_ShopTitle: UILabel!
    @IBOutlet weak var lbl_ShopLocation: UILabel!
    @IBOutlet weak var lbl_ShopDistance: UILabel!
    @IBOutlet weak var lbl_ShopReview: UILabel!
    @IBOutlet weak var lbl_ShopAddress: UILabel!
    @IBOutlet weak var lbl_ShopCategory: UILabel!
    
    @IBOutlet var vw_Rate_UserRate: CosmosView!
    
    @IBOutlet weak var img_Shopimage: UIImageView!
}


//MARK: - Map View -

extension KatikaViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let color = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        if let annotation = annotation as? ClusterAnnotation {
            let identifier = "Cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if view == nil {
                    view = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, type: .color(color, radius: 25))
//                }
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
        manager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
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
//            vw_MapView.setRegion(coordinateRegionForCoordinates(coords: arr_Location, coordCount: arr_Location.count), animated: true)
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

extension UIImage {
    
    func filled(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

class BorderedClusterAnnotationView: ClusterAnnotationView {
    var borderColor: UIColor?
    
    convenience init(annotation: MKAnnotation?, reuseIdentifier: String?, type: ClusterAnnotationType, borderColor: UIColor) {
        self.init(annotation: annotation, reuseIdentifier: reuseIdentifier, type: type)
        self.borderColor = borderColor
    }
    
    override func configure() {
        super.configure()
        
        switch type {
        case .image:
            layer.borderWidth = 0
        case .color:
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = 2
        }
    }
}



extension KatikaViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
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
               
                float_Latitude = dict_location.getStringForID(key:"lat") as! String
                float_Longitude = dict_location.getStringForID(key:"lng") as! String

            }
            
        }else if strRequest == "get_category" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            arr_Cateogry = []
            
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                var obj2 = KatikaViewObject()
                obj2.str_Category_ID = ("\(dict_Data["shop_category_id"] as! Int)" as NSString)
                obj2.str_Category_Title = dict_Data["s_title"] as! String as NSString
                obj2.str_Category_Image = dict_Data["s_image"] as! String as NSString
                arr_Cateogry.add(obj2)
            }
            
            self.reloadData()
        }else  if strRequest == "recent_view_shop_list" {
            
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            print(arr_result)
            arr_Main  = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                //Receintly viewed Product
                let obj = KatikaViewObject ()
                obj.str_shop_id = ("\(dict_Data["shop_id"] as! Int)" as NSString)
                obj.str_shop_name = dict_Data["shop_name"] as! String as NSString
                obj.str_ShopImage = dict_Data["shop_logo"] as! String as NSString
                obj.str_Lat = dict_Data["shop_lat"] as! String as NSString
                obj.str_Long = dict_Data["shop_long"] as! String as NSString
                obj.str_Shop_BG = dict_Data["shop_background"] as! String as NSString
                obj.str_Distance = dict_Data["distance"] as! String as NSString
                obj.str_TotalReview = dict_Data["TotalReview"] as! String as NSString
                obj.str_AvgReview = dict_Data["AvgReview"] as! String as NSString
                
//                obj.arrImage = arr_Image_Store
                arr_Main.add(obj)
            }
            self.reloadData()
        }else if strRequest == "search_directory"{
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
        }else if strRequest == "search_shop"{
            self.completedServiceCalling()

            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            var arr_StoreTemp : NSMutableArray = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                let obj = KatikaViewObject ()
                obj.str_shop_id = ("\(dict_Data["shop_id"] as! Int)" as NSString)
                obj.str_shop_name = dict_Data["shop_name"] as! String as NSString
                obj.str_Image = dict_Data["Image"] as! String as NSString
                obj.str_shop_lat = dict_Data["shop_lat"] as! String as NSString
                obj.str_shop_long = dict_Data["shop_long"] as! String as NSString
                obj.str_shop_location = dict_Data["shop_location"] as! String as NSString
                obj.str_TotalReview = dict_Data["TotalReview"] as! String as NSString
                obj.str_AvgReview = dict_Data["AvgReview"] as! String as NSString
                obj.str_shopcategory = dict_Data["shopcategory"] as! String as NSString
                obj.str_distance = dict_Data["distance"] as! String as NSString
                
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
        
        //SET TABLE FRAME
        tbl_SearchListing.frame = rectDetail

        //Reload map view
        if strRequest == "search_shop"{
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





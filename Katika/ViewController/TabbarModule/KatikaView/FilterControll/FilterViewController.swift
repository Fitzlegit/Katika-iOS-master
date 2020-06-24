//
//  FilterViewController.swift
//  Katika
//
//  Created by Katika_07 on 04/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit



class FilterViewController: UIViewController {

    //Other Declaration
    var tbl_reload_Number : NSIndexPath!
    var arr_FilterSortBy : NSMutableArray = []
    var arr_Tableview : NSMutableArray = []
    
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    var obj_Generale = FilterShopObject ()
    var str_ValueType : String = "product"
    
    var str_Type : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tbl_reload_Number = nil
        self.commanMethod()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil, userInfo: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "businessview"), object: nil, userInfo: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Other Files -
    func commanMethod(){
        self.Get_FilterSetting()
      
    }
    func indexPaths(forSection section: Int, withNumberOfRows numberOfRows: Int) -> [Any] {
        var indexPaths = [Any]()
        for i in 0..<numberOfRows {
            let indexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        dismiss(animated: true) { _ in }
    }
    @IBAction func btn_Search (_ sender : Any){
        self.Get_ChangeSetting()
    }
    //MARK: -- Tableview Method --
    @IBAction func btn_Section(_ sender: Any) {
        
        //Get animation with table view reload data
        tbl_Main.beginUpdates()
        if ((tbl_reload_Number) != nil) {
            if (tbl_reload_Number.section == (sender as AnyObject).tag) {
                
                //Delete Cell
                
                let arr_DeleteIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows: arr_FilterSortBy.count)
                tbl_Main.deleteRows(at: arr_DeleteIndex as! [IndexPath], with: .automatic)
                
                tbl_reload_Number = nil;
            }else{
                //Delete Cell
                
                let arr_DeleteIndex = self.indexPaths(forSection: tbl_reload_Number.section, withNumberOfRows:arr_FilterSortBy.count)
                tbl_Main.deleteRows(at: arr_DeleteIndex as! [IndexPath], with: .automatic)
                
                
                tbl_reload_Number = IndexPath(row: 0, section: (sender as AnyObject).tag) as NSIndexPath!
                let arr_AddIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows:arr_FilterSortBy.count)
                tbl_Main.insertRows(at: arr_AddIndex as! [IndexPath], with: .automatic)
                
            }
        }else{
            tbl_reload_Number = IndexPath(row: 0, section: (sender as AnyObject).tag) as NSIndexPath!
            
            let arr_AddIndex = self.indexPaths(forSection: ((sender as AnyObject).tag), withNumberOfRows: arr_FilterSortBy.count)
            tbl_Main.insertRows(at: arr_AddIndex as! [IndexPath], with: .automatic)
        }
        
        tbl_Main.endUpdates()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.tbl_Main.reloadData()
            
        })
        
    }
    @objc func adjustLabelForSlider( slider: Any) {
        let value: Float = (slider as AnyObject).value
        obj_Generale.str_DistanceDefualt = String(format: "%.2f",value) as NSString
        self.tbl_Main.reloadData()

    }

    // MARK: - Get/Post Method -
    func Get_FilterSetting(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)filtersetting"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "filtersetting"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }
    func Get_ChangeSetting(){
        if arr_Tableview.count != 0 {
            let objFilter : FilterShopObject = arr_Tableview[2] as! FilterShopObject
            
            //Sort Selection
            let obj2 = arr_Tableview[0] as! FilterShopObject
            
            //Declaration URL
            let strURL = "\(Constant.BaseURL)updatefiltersetting"
            
            //Pass data in dictionary
            var jsonData : NSDictionary =  NSDictionary()
            jsonData = [
                "user_id" : objUser?.str_Userid as! String,
                "Distance" : obj_Generale.str_DistanceDefualt,
                "SortBy" : obj2.str_SortByValue as String,
                "minprice" : objFilter.str_MinPrice,
                "maxprice" : objFilter.str_MaxPrice,
            ]
            
            //Create object for webservicehelper and start to call method
            let webHelper = WebServiceHelper()
            webHelper.strMethodName = "updatefiltersetting"
            webHelper.methodType = "post"
            webHelper.strURL = strURL
            webHelper.dictType = jsonData
            webHelper.dictHeader = NSDictionary()
            webHelper.delegateWeb = self
            webHelper.serviceWithAlert = false
            webHelper.startDownload()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "filtershipstoselection"{
            
            let obj : FilterShopObject = arr_Tableview[5] as! FilterShopObject
            
            let view : FilterShipToSelectionViewController = segue.destination as! FilterShipToSelectionViewController
            view.str_Selected = obj.str_FilterSeletectedTitle as String
        }else if segue.identifier == "filtercategoryselection"{
            let obj : FilterShopObject = arr_Tableview[1] as! FilterShopObject
            
            let view : FilterCategorySelectionViewController = segue.destination as! FilterCategorySelectionViewController
            view.arr_Category = obj.arr_Category
            view.str_ValueType = str_ValueType
            view.str_Type = str_Type
        
        }else if segue.identifier == "filterlocationselection"{
            let obj : FilterShopObject = arr_Tableview[4] as! FilterShopObject
            
            let view : FilterShopLocationSelectionViewController = segue.destination as! FilterShopLocationSelectionViewController
            view.objLocation = obj
            
        }
        
        
    }
}

class FilterShopObject: NSObject {
    //Filter
    var str_FilterTitle : NSString = ""
    var str_FilterSeletectedTitle : NSString = ""
    var str_FilterSeletectedLat : NSString = ""
    var str_FilterSeletectedLong : NSString = ""
    var arr_Category : NSMutableArray = []
    
    //Sort by
    var str_SortByID : NSString = ""
    var str_SortByTitle : NSString = ""
    var str_SortByValue : NSString = ""
    var str_SortBySelected : NSString = ""
    
    //Distance
    var str_DistanceMin : NSString = ""
    var str_DistanceMax : NSString = ""
    var str_DistanceDefualt : NSString = ""
    
    //Price
    var str_MinPrice : NSString = ""
    var str_MaxPrice : NSString = ""
    
}


//MARK: - Tableview View Cell -
class FilterTableviewCell : UITableViewCell{
    //Section
    @IBOutlet weak var lbl_SectionTitle: UILabel!
    @IBOutlet weak var lbl_SectionSelected: UILabel!
    @IBOutlet weak var btn_Section: UIButton!
    @IBOutlet weak var img_Shopimage: UIImageView!
    
    //Selected Cell
    @IBOutlet weak var img_Seleted: UIImageView!
    @IBOutlet weak var lbl_SubTitle: UILabel!
    
    //Slider Menu
    @IBOutlet weak var lbl_SlidervVlueSet: UILabel!
    @IBOutlet weak var lbl_SliderMinValue: UILabel!
    @IBOutlet weak var lbl_SliderMaxValue: UILabel!
    @IBOutlet weak var slider_Setvalue: UISlider!
    @IBOutlet weak var slider_Price: RangeSeekSlider!
    
    //Generale
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Selected: UILabel!
}

// MARK: - Tableview Files -
extension FilterViewController : UITableViewDelegate,UITableViewDataSource {
    // MARK: - Table View -
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return arr_Tableview.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Section 0 == Sort By
        if (section == 0){
            if ((tbl_reload_Number) != nil) {
                if (tbl_reload_Number.section == section) {
                    return arr_FilterSortBy.count;
                }
            }
            return 0
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 0){ //Price selection
            return  UITableView.automaticDimension
        }else if (indexPath.section == 2){ //Price selection
            if str_ValueType == "shop" {
                return  0
            }
            return  100
        }else if (indexPath.section == 3){ //Distance Manage
            return  90
        }else if (indexPath.section == 4){ //Distance Manage
            if str_ValueType == "shop" {
                return  0
            }
        }
        
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 108
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        //Sort By
        if (section == 0){
            return  90
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "section")as! FilterTableviewCell
        
        //Create object for ProductObject
        let obj : FilterShopObject = arr_Tableview[section] as! FilterShopObject
        
        //Assign value
        cell.lbl_SectionTitle.text = obj.str_FilterTitle as String
        cell.lbl_SectionSelected.text = obj.str_FilterSeletectedTitle as String
        
        //Button Event
        cell.btn_Section.tag = section;
        cell.btn_Section.addTarget(self, action:#selector(btn_Section(_:)), for: .touchUpInside)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Identifier cell with based on section
       var cellIdentifier : String = "cell"
        
        if (indexPath.section == 0){
            cellIdentifier = "cellselected"
        }else if (indexPath.section == 2){ //Price Section
            cellIdentifier = "price"
        }else if (indexPath.section == 3){ //Distance by
            cellIdentifier = "slider"
        }
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! FilterTableviewCell
        
        if(indexPath.section == 0) {
            
            //Create object for ProductObject
            let obj : FilterShopObject = arr_FilterSortBy[indexPath.row] as! FilterShopObject
            
            cell.lbl_SubTitle.text = obj.str_SortByTitle as String
            
            if obj.str_SortBySelected == "1" {
                cell.img_Seleted.image = UIImage(named: "img_SelectedArrow")
            }else{
                cell.img_Seleted.image = UIImage(named: "img_UnSelectedArrow")
            }
        }else if(indexPath.section == 2) {
            
            let objPrice = arr_Tableview[indexPath.section] as! FilterShopObject
            
            cell.slider_Price.delegate = self
            
            //Price
            cell.slider_Price.minValue = 1
            cell.slider_Price.maxValue = 1000
            
            cell.slider_Price.selectedMinValue = CGFloat(Double(objPrice.str_MinPrice as String)!)
            cell.slider_Price.selectedMaxValue = CGFloat(Double(objPrice.str_MaxPrice as String)!)
            
        }else if(indexPath.section == 3) {
            
            cell.lbl_SlidervVlueSet.text = "Distance : \(obj_Generale.str_DistanceDefualt) mile"
            cell.lbl_SliderMinValue.text = "\(obj_Generale.str_DistanceMin) mile"
            cell.lbl_SliderMaxValue.text = "\(obj_Generale.str_DistanceMax) mile"
            
            cell.slider_Setvalue.minimumValue = Float(obj_Generale.str_DistanceMin as String)!
            cell.slider_Setvalue.maximumValue = Float(obj_Generale.str_DistanceMax as String)!
            
            cell.slider_Setvalue.value = Float(obj_Generale.str_DistanceDefualt as String)!
            cell.slider_Setvalue.addTarget(self, action: #selector(self.adjustLabelForSlider), for: .valueChanged)

        }else{
            //Price
            let obj : FilterShopObject = arr_Tableview[indexPath.section] as! FilterShopObject
            cell.lbl_Title.text = obj.str_FilterTitle as String
            cell.lbl_Selected.text = obj.str_FilterSeletectedTitle as String
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //Create object for ProductObject
            let obj : FilterShopObject = arr_Tableview[indexPath.section] as! FilterShopObject
            
            //Create object for ProductObject
            let obj2 : FilterShopObject = arr_FilterSortBy[indexPath.row] as! FilterShopObject

            //Set value in header
            obj.str_FilterSeletectedTitle = obj2.str_SortByTitle
            obj.str_SortByValue = obj2.str_SortByValue
            
            arr_Tableview[indexPath.section] = obj
            
            for i in (0..<arr_FilterSortBy.count){
                //Create object for ProductObject
                let obj3 : FilterShopObject = arr_FilterSortBy[i] as! FilterShopObject
                
                if indexPath.row == i {
                    obj3.str_SortBySelected = "1"
                }else{
                    obj3.str_SortBySelected = "0"
                }
                arr_FilterSortBy[i] = obj3
            }
            
            let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
            btn.tag = indexPath.section
            self.btn_Section(btn)
            
        }else if indexPath.section == 1{
            
            self.performSegue(withIdentifier: "filtercategoryselection", sender: self)
        }else if indexPath.section == 4{
            
            self.performSegue(withIdentifier: "filterlocationselection", sender: self)
        }else if indexPath.section == 5{
            
            self.performSegue(withIdentifier: "filtershipstoselection", sender: self)
        }
    }
}



extension FilterViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "filtersetting" {
            
            //Remove tableview data
            arr_Tableview = []
            arr_FilterSortBy = []
            
            //Manage Sub category Data
            let dict_result = response["Result"] as! NSDictionary
            let arr_Distance = dict_result["Distance"] as! NSArray
            let arr_SortBy = dict_result["SortBy"] as! NSArray
            let arr_Price = dict_result["Price"] as! NSArray
            var arr_Category = dict_result["Category"] as! NSArray
            if str_ValueType == "product" {
                arr_Category = dict_result["Category_product"] as! NSArray
            }else if str_Type != ""{
                arr_Category = dict_result["Category_business"] as! NSArray
            }
            let arr_Country = dict_result["Country"] as! NSArray
            let arr_Location = dict_result["Location"] as! NSArray
            
            //1.....Sort by
            for i in (0..<arr_SortBy.count) {
                let dict_Data = arr_SortBy[i] as! NSDictionary
                
                let obj = FilterShopObject ()
                obj.str_SortByID =  ("\(dict_Data["s_id"] as! Int)" as NSString)
                obj.str_SortByTitle = dict_Data["s_title"] as! String as NSString
                obj.str_SortByValue = dict_Data["s_value"] as! String as NSString
                obj.str_SortBySelected = dict_Data["s_set"] as! String as NSString
                arr_FilterSortBy.add(obj)
                
                //                if arr_Tableview.count == 1 {
                if obj.str_SortBySelected == "1" {
                    let obj2 = FilterShopObject ()
                    obj2.str_FilterTitle = "Sort by"
                    obj2.str_FilterSeletectedTitle = obj.str_SortByTitle
                    obj2.str_SortByValue = obj.str_SortByValue
                    arr_Tableview.add(obj2)
                }
                //                }
            }
            
            //2.....Category
            if str_Type != "" {
                let dict_CategorySub = arr_Category[0] as! NSDictionary
                let arr_CategorySub = dict_CategorySub["Category_business"] as! NSArray
                let objCat = FilterShopObject ()
                
                if arr_CategorySub.count == 0 {
                    objCat.str_FilterTitle = "Category"
                    objCat.str_FilterSeletectedTitle = "All Categories"
                }
                objCat.arr_Category = []
                
                for i in (0..<arr_CategorySub.count) {
                    let dict_Data = arr_CategorySub[i] as! NSDictionary
                    
                    let obj2 = FilterCategorySelectionObject ()
                    obj2.str_ID = ("\(dict_Data["business_category_id"] as! Int)" as NSString)
                    obj2.str_Title = dict_Data["s_title"] as! String as NSString
                    objCat.arr_Category.add(obj2)
                    
                    if arr_CategorySub.count - 1 ==  i{
                        objCat.str_FilterTitle = "Category"
                        objCat.str_FilterSeletectedTitle = dict_Data["s_title"] as! String as NSString
                    }
                }
                arr_Tableview.add(objCat)
            }else if str_ValueType == "shop" {
                let dict_CategorySub = arr_Category[0] as! NSDictionary
                let arr_CategorySub = dict_CategorySub["Category"] as! NSArray
                let objCat = FilterShopObject ()
                
                if arr_CategorySub.count == 0 {
                    objCat.str_FilterTitle = "Category"
                    objCat.str_FilterSeletectedTitle = "All Categories"
                }
                objCat.arr_Category = []
                
                for i in (0..<arr_CategorySub.count) {
                    let dict_Data = arr_CategorySub[i] as! NSDictionary
                    
                    let obj2 = FilterCategorySelectionObject ()
                    obj2.str_ID = ("\(dict_Data["shop_category_id"] as! Int)" as NSString)
                    obj2.str_Title = dict_Data["s_title"] as! String as NSString
                    objCat.arr_Category.add(obj2)
                    
                    if arr_CategorySub.count - 1 ==  i{
                        objCat.str_FilterTitle = "Category"
                        objCat.str_FilterSeletectedTitle = dict_Data["s_title"] as! String as NSString
                    }
                }
                arr_Tableview.add(objCat)
            }else{
                let dict_CategorySub = arr_Category[0] as! NSDictionary
                let arr_CategorySub = dict_CategorySub["Category_product"] as! NSArray
                let objCat = FilterShopObject ()
                
                if arr_CategorySub.count == 0 {
                    objCat.str_FilterTitle = "Category"
                    objCat.str_FilterSeletectedTitle = "All Categories"
                }
                objCat.arr_Category = []
                
                for i in (0..<arr_CategorySub.count) {
                    let dict_Data = arr_CategorySub[i] as! NSDictionary
                    
                    let obj2 = FilterCategorySelectionObject ()
                    obj2.str_ID = ("\(dict_Data["category_id"] as! Int)" as NSString)
                    obj2.str_Title = dict_Data["c_title"] as! String as NSString
                    objCat.arr_Category.add(obj2)
                    
                    if arr_CategorySub.count - 1 ==  i{
                        objCat.str_FilterTitle = "Category"
                        objCat.str_FilterSeletectedTitle = dict_Data["c_title"] as! String as NSString
                    }
                }
                arr_Tableview.add(objCat)
            }
            
           
            
            
            //3.....Price
            let dict_DataPrice = arr_Price[0] as! NSDictionary
            let dict_DataPrice2 = arr_Price[1] as! NSDictionary
            let objPrice = FilterShopObject ()
            objPrice.str_MinPrice = ("\(dict_DataPrice["set_Minprice"] as! Double)" as NSString)
            objPrice.str_MaxPrice = ("\(dict_DataPrice2["Value_Maxprice"] as! Double)" as NSString)
          
            arr_Tableview.add(objPrice)
            
            
            //4.....Distance
            for i in (0..<arr_Distance.count) {
                let dict_Data = arr_Distance[i] as! NSDictionary

                var str_Title : NSString = dict_Data["s_title"] as! String as NSString
                if str_Title == "min distance" {
                     obj_Generale.str_DistanceMin = dict_Data["s_value"] as! String as NSString
                }else if str_Title == "max distance" {
                    obj_Generale.str_DistanceMax = dict_Data["s_value"] as! String as NSString
                }else if str_Title == "default distance" {
                    obj_Generale.str_DistanceDefualt = dict_Data["s_value"] as! String as NSString
                }
            }
            arr_Tableview.add("")
            
            //5.....Shop Location
            let dict_Location = arr_Location[0] as! NSDictionary
            let objLocation = FilterShopObject ()
            if str_Type != "" {
                objLocation.str_FilterTitle = "Business Location"
            }else if str_ValueType == "shop" {
                objLocation.str_FilterTitle = "Shop Location"
            }else{
                objLocation.str_FilterTitle = "Product Location"
            }
            
            objLocation.str_FilterSeletectedTitle = dict_Location["set_value"] as! String as NSString
            if objLocation.str_FilterSeletectedTitle == "" {
                objLocation.str_FilterSeletectedTitle = "Anywhere"
            }
            objLocation.str_FilterSeletectedLat = dict_Location["set_latitude"] as! String as NSString
            objLocation.str_FilterSeletectedLong = dict_Location["set_longitude"] as! String as NSString
            arr_Tableview.add(objLocation)
            
            //6.....Ship Location
            let dict_Country = arr_Country[0] as! NSDictionary
            
            let objShipLocation = FilterShopObject ()
            objShipLocation.str_FilterTitle = "Ship To"
            objShipLocation.str_FilterSeletectedTitle = dict_Country["country_name"] as! String as NSString
            if objShipLocation.str_FilterSeletectedTitle == "" {
                objShipLocation.str_FilterSeletectedTitle = "All"
            }
            arr_Tableview.add(objShipLocation)
            
            
            self.tbl_Main.reloadData()
        }else  if strRequest == "updatefiltersetting" {
            dismiss(animated: true) { _ in }
        }
        
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
}


extension FilterViewController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMinValue minValue: CGFloat) -> String? {
//        let obj : FilterShopObject = arr_Tableview[2] as! FilterShopObject
//        obj.str_MinPrice = String(Float(minValue)) as NSString
//        arr_Tableview[2] = obj
        
        
        let index: Int = Int(roundf(Float(minValue)))
        return  "$\(index)"
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue maxValue: CGFloat) -> String? {
        
        let index: Int = Int(roundf(Float(maxValue)))
        if index == 1000 {
          return "$\(index)+"
        }
        return "$\(index)"
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
        let obj : FilterShopObject = arr_Tableview[2] as! FilterShopObject
        obj.str_MinPrice = String(Float(minValue)) as NSString
        obj.str_MaxPrice = String(Float(maxValue)) as NSString
        arr_Tableview[2] = obj
    }
    
    
}




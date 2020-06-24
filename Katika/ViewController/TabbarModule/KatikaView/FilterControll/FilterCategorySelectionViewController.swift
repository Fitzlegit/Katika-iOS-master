//
//  FilterCategorySelectionViewController.swift
//  Katika
//
//  Created by Katika_07 on 17/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class FilterCategorySelectionViewController: UIViewController {

    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    var arr_Category : NSMutableArray = []
    var arr_SubCategory : NSMutableArray = []
    
    var str_ValueType : String = "product"
    
    var str_Type : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commanMethod()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: - Other Method -
    func commanMethod(){
        
        if arr_Category.count == 0 {
            if str_Type != "" {
                self.Get_SearchCategoryBusiness(category_ID : "0")
            }else if str_ValueType == "product" {
                self.Get_SearchCategory()
            }else{
                self.Get_SearchCategory2()
            }
        }else{
            if str_Type != "" && str_Type != "business"{
            }else if str_ValueType == "product" {
                let obj : FilterCategorySelectionObject = arr_Category[arr_Category.count-1] as! FilterCategorySelectionObject
                self.Get_SearchSubCategory(category_ID : obj.str_ID as String)
            }else if str_ValueType == "shop"{
                let obj : FilterCategorySelectionObject = arr_Category[arr_Category.count-1] as! FilterCategorySelectionObject
                self.Get_SearchCategoryBusiness(category_ID : obj.str_ID as String)
            }
        }
    }

    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
//        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true) { _ in }
    }
    @IBAction func btn_Done (_ sender : Any){
        dismiss(animated: true) { _ in }
      
    }
    
    // MARK: - Get/Post Method -
    func Get_SearchCategory(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_category"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "categoryid" : "0",
            "skip" : "0",
            "total" : "10",
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
    func Get_SearchSubCategory(category_ID : String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_category"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "categoryid" : category_ID,
            "skip" : "0",
            "total" : "10",
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
    
    func Post_Data(){
        
        //Declaration URL
        var strURL = "\(Constant.BaseURL)updatefilter_category_product"
        
        if str_ValueType == "shop" {
            strURL = "\(Constant.BaseURL)updatefilter_category"
        }
        
        if str_Type != "" {
            strURL = "\(Constant.BaseURL)updatefilter_category_business"
        }
        
        var str_Data : String = ""

        for i in (0..<arr_Category.count) {
            
            //Demo data
            let obj = arr_Category[i] as! FilterCategorySelectionObject
            
            if str_Data == "" {
                str_Data = obj.str_ID as String
            }else{
                str_Data = "\(str_Data),\(obj.str_ID)"
            }
        }
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String ,
            "categoryid" : str_Data,
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
    func Get_SearchCategory2(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_shop_category"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "categoryid" : "0",
            "skip" : "0",
            "total" : "1000",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_category2"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }

    func Get_SearchCategoryBusiness(category_ID : String){
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_directory_category_new"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "categoryid" : category_ID,
            "skip" : "0",
            "total" : "1000",
            "type" : "1",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_directory_category"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
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

//MARK: - Tableview View Cell -
class FilterCategorySelectionTableviewCell : UITableViewCell{
    
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var tf_Location: UITextField!
    
    @IBOutlet weak var img_Selected: UIImageView!
}
//MARK: - Search Object -

class FilterCategorySelectionObject: NSObject {
    //Product Listing View
    var str_ID : NSString = ""
    var str_Title : NSString = ""
    
}



// MARK: - Tableview Files -
extension FilterCategorySelectionViewController : UITableViewDelegate,UITableViewDataSource {
    // MARK: - Table View -
    // MARK: - Table View -
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return arr_Category.count + 1
        }else if section == 1{
            return arr_SubCategory.count
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIdentifier : String = "cell"
        if indexPath.section == 1 {
            cellIdentifier = "cell1"
        }
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! FilterCategorySelectionTableviewCell
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.lbl_Title.text = "All Cateogry"
            }else {
                let obj : FilterCategorySelectionObject = arr_Category[indexPath.row - 1] as! FilterCategorySelectionObject
                
                cell.lbl_Title.text = obj.str_Title as String
            }
            
            if arr_Category.count == indexPath.row {
                cell.img_Selected.image = UIImage.init(named: "img_SelectedArrow")
            }else{
                cell.img_Selected.image = UIImage.init(named: "")
            }
            
        }else if indexPath.section == 1{
            let obj : FilterCategorySelectionObject = arr_SubCategory[indexPath.row] as! FilterCategorySelectionObject
            
            cell.lbl_Title.text = obj.str_Title as String
        }
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if str_ValueType == "product" {
            if indexPath.section == 0
            {
                if indexPath.row == 0 {
                    arr_Category = []
                    arr_SubCategory = []
                    
                    tbl_Main.reloadData()
                    
                    self.Get_SearchCategory()
                }else{
                    let obj : FilterCategorySelectionObject = arr_Category[indexPath.row-1] as! FilterCategorySelectionObject
                    
                    for i in (0..<arr_Category.count - indexPath.row ) {
                        arr_Category.removeLastObject()
                    }
                    tbl_Main.reloadData()
                    
                    self.Get_SearchSubCategory(category_ID : obj.str_ID as String)
                    
                }
            }else if indexPath.section == 1 {
                
                let obj : FilterCategorySelectionObject = arr_SubCategory[indexPath.row] as! FilterCategorySelectionObject
                
                let obj2 = FilterCategorySelectionObject ()
                obj2.str_ID = obj.str_ID as String as NSString
                obj2.str_Title = obj.str_Title as String as NSString
                arr_Category.add(obj2)
                
                arr_SubCategory = []
                tbl_Main.reloadData()
                
                print("value \(obj2.str_ID)")
                
                self.Get_SearchSubCategory(category_ID : obj.str_ID as String)
            }
            self.Post_Data()
        }else{
            if indexPath.section == 0
            {
                if indexPath.row == 0 {
                    arr_Category = []
                    arr_SubCategory = []
                    
                    tbl_Main.reloadData()
                    
                    self.Post_Data()
                    if str_Type == ""{
                        self.Get_SearchCategory2()
                    }else{
                        self.Get_SearchCategoryBusiness(category_ID : "0")
                    }
                }else{
                    let obj : FilterCategorySelectionObject = arr_Category[indexPath.row-1] as! FilterCategorySelectionObject
                    
                    for i in (0..<arr_Category.count - indexPath.row ) {
                        arr_Category.removeLastObject()
                    }
                    tbl_Main.reloadData()
                    
                    self.Get_SearchCategoryBusiness(category_ID : obj.str_ID as String)
                }
            }else{
//                if arr_Category.count == 0 {
                    let obj : FilterCategorySelectionObject = arr_SubCategory[indexPath.row] as! FilterCategorySelectionObject
                    
                    let obj2 = FilterCategorySelectionObject ()
                    obj2.str_ID = obj.str_ID as String as NSString
                    obj2.str_Title = obj.str_Title as String as NSString
                    arr_Category.add(obj2)
                    
                    arr_SubCategory = []
                    tbl_Main.reloadData()
                    
                    print("value \(obj2.str_ID)")
                
                self.Get_SearchCategoryBusiness(category_ID : obj.str_ID as String)

                    self.Post_Data()
//                }
            }
            
        }
    }
}


extension FilterCategorySelectionViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "get_category" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            arr_SubCategory = []
            
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                //Demo data
                var obj = FilterCategorySelectionObject ()
                obj.str_ID = ("\(dict_Data["category_id"] as! Int)" as NSString)
                obj.str_Title = dict_Data["c_title"] as! String as NSString
                
                if obj.str_Title != "All"{
                    arr_SubCategory.add(obj)
                }
            }
            
            tbl_Main.reloadData()
        }else  if strRequest == "get_category2" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            arr_SubCategory = []
            
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                var obj2 = FilterCategorySelectionObject()
                obj2.str_ID = ("\(dict_Data["shop_category_id"] as! Int)" as NSString)
                obj2.str_Title = dict_Data["s_title"] as! String as NSString
                if obj2.str_Title != "All"{
                    arr_SubCategory.add(obj2)
                }
            }
            
            tbl_Main.reloadData()
        }else  if strRequest == "get_directory_category" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            arr_SubCategory = []
            
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                var obj2 = FilterCategorySelectionObject()
                obj2.str_ID = ("\(dict_Data["business_category_id"] as! Int)" as NSString)
                obj2.str_Title = dict_Data["s_title"] as! String as NSString
//                obj2.str_Category_Image = dict_Data["s_image"] as! String as NSString
                if obj2.str_Title != "All"{
                    arr_SubCategory.add(obj2)
                }
            }
            
            tbl_Main.reloadData()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        // self.completedServiceCalling()
    }
    
}



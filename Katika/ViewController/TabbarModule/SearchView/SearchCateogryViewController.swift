//
//  SearchCateogryViewController.swift
//  Katika
//
//  Created by Katika on 15/06/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class SearchCateogryViewController: UIViewController {

    //view declaration
    @IBOutlet var vw_SearchBar : UIView!
    
    //Other declaration
    @IBOutlet var tf_Search : UITextField!
    @IBOutlet var con_HeightHeader : NSLayoutConstraint!
    
    //Button Event
    @IBOutlet var btn_CancelSearch : UIButton!
    
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    //Array Declaration
    var arr_Main : NSMutableArray = []
    var arr_Main_Store : NSMutableArray = []
    
    //Label declaration
    @IBOutlet var lbl_Categoryname : UILabel!
    @IBOutlet var lbl_SubCategoryname : UILabel!
    
    var category_Type : NSString = ""
    var category_Path : NSString = ""
    var category_ID : NSString = ""
    var category_PathID : NSString = ""
    
    //Bool Declaration
    var bool_Load: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commanMethod()
        self.Get_SearchCategory()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Scrollview Manage -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tbl_Main {
            view.endEditing(true)
        }
    }
    // MARK: - TextField Manage -
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if tf_Search == textField {
            if tf_Search.text != ""{
                self.performSegue(withIdentifier: "categoryfilterresult", sender: -1)
            }
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
        //Layer declaration
        vw_SearchBar.layer.cornerRadius = 5
        vw_SearchBar.layer.borderColor = UIColor.darkGray.cgColor
        vw_SearchBar.layer.borderWidth = 0.5
        vw_SearchBar.layer.masksToBounds = true
        
        
        //Assign value from another object
        if category_Type.length != 0{
            lbl_Categoryname.text = (category_Type ) as String
            con_HeightHeader.constant = 60
        }else{
            con_HeightHeader.constant = 0
        }
        
        //Text change method in textfield
        tf_Search.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        //Change placeholder text
        tf_Search.attributedPlaceholder = NSAttributedString(string: "Search with keywords",
                                                             attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))
    }
    
    //MARK: - Button Event -
    @IBAction func btn_CancelSearch(_ sender : Any){
        btn_CancelSearch.isHidden = true
        tf_Search.text = ""
        self.view.endEditing(true)
    }
    @IBAction func btn_Back(_ sender : Any){
        _ = self.navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Get/Post Method -
    func Get_SearchCategory(){
        bool_Load = true
        
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "categoryfilterresult"{
            
            var bookSearch : Bool = false
            var value : Int = sender as! Int
            if value == -1{
                value = 0
                bookSearch = true
            }
            let obj : SearchCategoryViewObject = arr_Main[value] as! SearchCategoryViewObject
   
            let str_Varible : NSString = ("\(category_Path as String) > \(obj.str_Title as String)" as NSString) as String as String as NSString
            let str_VaribleID : NSString = ("\(category_PathID as String).\(obj.str_ID as String)" as NSString) as String as String as NSString
            
            let view : CategoryFilterResultViewController = segue.destination as! CategoryFilterResultViewController
            view.category_List = str_Varible
            view.category_List_Path = str_VaribleID
            if bookSearch == true{
                view.category_SearchValue = tf_Search.text as! NSString
            }
        }
    }
}

//MARK: - Search Object -

class SearchCategoryViewObject: NSObject {
    var str_Title : NSString = ""
    var str_ID : NSString = ""
    var str_image : NSString = ""
    var str_sub_category_available : NSString = ""
    
}


// MARK: - Tableview Files -
extension SearchCateogryViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr_Main.count == 0 && !bool_Load{
            return 1
        }
        return arr_Main.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell_Identifier = "cell"
        if arr_Main.count == 0{
            cell_Identifier = "nodata"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_Identifier, for:indexPath as IndexPath) as! SearchCategoryTableviewCell
        
        if arr_Main.count != 0{
            let obj : SearchCategoryViewObject = arr_Main[indexPath.row] as! SearchCategoryViewObject
            
            cell.lbl_Title.text = obj.str_Title as String
            
            if obj.str_Title != "All"{
                //Image set
                cell.img_Icon.sd_setImage(with: URL(string: obj.str_image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
            }else{
                //Image set
                cell.img_Icon.image = UIImage(named:"icon_EveryThink")
            }
        }else{
            cell.lbl_Title.text = "No category available"
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arr_Main.count != 0{
            let obj : SearchCategoryViewObject = arr_Main[indexPath.row] as! SearchCategoryViewObject

            if category_Type.length != 0 && obj.str_sub_category_available == "Y"{
                print("\(category_Path as String) > \(obj.str_Title as String)" as NSString)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "SearchCateogryViewController") as! SearchCateogryViewController
                view.category_Path = "\(category_Path as String) > \(obj.str_Title as String)" as NSString
                view.category_PathID = "\(category_PathID as String).\(obj.str_ID as String)" as NSString
                view.category_ID =  String(obj.str_ID) as NSString
                self.navigationController?.pushViewController(view, animated: true)
            }else{
                
                self.performSegue(withIdentifier: "categoryfilterresult", sender:indexPath.row)
            }
        }
    }
}

//MARK: - Tableview View Cell -
class SearchCategoryTableviewCell : UITableViewCell{
    //Main Listing
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var img_Icon: UIImageView!
    
}


extension SearchCateogryViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        bool_Load = false
        
        let response = data as! NSDictionary
        if strRequest == "get_category" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            arr_Main = []
            arr_Main_Store = []
            
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                //Demo data
                let obj = SearchCategoryViewObject ()
                obj.str_ID = ("\(dict_Data["category_id"] as! Int)" as NSString)
                obj.str_Title = dict_Data["c_title"] as! String as NSString
                obj.str_image = dict_Data["c_image"] as! String as NSString
                obj.str_sub_category_available = dict_Data["sub_category_available"] as! String as NSString
                arr_Main.add(obj)
            }
            arr_Main_Store = NSMutableArray(array: arr_Main);
            
            tbl_Main.reloadData()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        bool_Load = false
        tbl_Main.reloadData()

    }
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

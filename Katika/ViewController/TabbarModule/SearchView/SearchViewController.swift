//
//  SearchViewController.swift
//  Katika
//
//  Created by Katika on 18/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import Firebase
class SearchViewController: UIViewController,UITextFieldDelegate{

    //view declaration
    @IBOutlet var vw_SearchBar : UIView!
    
    //Other declaration
    @IBOutlet var tf_Search : UITextField!
    
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    //Array Declaration
    var arr_Main : NSMutableArray = []
    var arr_Main_Store : NSMutableArray = []
    
    //Button Event
    @IBOutlet var btn_CancelSearch : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.manageNavigation()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.commanMethod()
        self.Get_SearchCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                self.performSegue(withIdentifier: "categoryfilterresultdirect", sender: 0)
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

        tbl_Main.reloadData()
    }
    
    
    //MARK: - Other Files -
    func commanMethod(){
        //Layer declaration
        vw_SearchBar.layer.cornerRadius = 5
        vw_SearchBar.layer.borderColor = UIColor.darkGray.cgColor
        vw_SearchBar.layer.borderWidth = 0.5
        vw_SearchBar.layer.masksToBounds = true
           
        //Text change method in textfield
        tf_Search.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        //Change placeholder color change
        tf_Search.attributedPlaceholder = NSAttributedString(string: "Search with keywords",
                                                               attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))

    }
    func manageNavigation(){
        
        let titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 150, height: 28))
        titleView.contentMode = .scaleAspectFit
        titleView.image = UIImage(named: "katikaTextNavigation")
        
        self.navigationItem.titleView = titleView
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
        //SET ANALYTICS
        Analytics.logEvent("tab_home", parameters: nil)
        vw_BaseView?.callmethod(_int_Value: 2)
    }
    @IBAction func btn_Tab_Fav(_ sender: Any) {
        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }else{
            //SET ANALYTICS
            Analytics.logEvent("tab_favorite", parameters: nil)
            vw_BaseView?.callmethod(_int_Value: 1)
        }
    }
    @IBAction func btn_Tab_Katika(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_directory", parameters: nil)
        vw_BaseView?.callmethod(_int_Value: 0)
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
    @IBAction func btn_CancelSearch(_ sender : Any){
        btn_CancelSearch.isHidden = true
        tf_Search.text = ""
        self.view.endEditing(true)
        
        arr_Main = NSMutableArray(array: arr_Main_Store)
        tbl_Main.reloadData()
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        self.view.endEditing(true)
        if segue.identifier == "categoryfilter"{
            
            let obj : SearchViewObject = arr_Main[sender as! Int] as! SearchViewObject
            
            let str_Varible : NSString = obj.str_Title
            let str_ID : NSString = String(obj.str_ID) as NSString
            
            let view : SearchCateogryViewController = segue.destination as! SearchCateogryViewController
            view.category_Type = str_Varible
            view.category_Path = str_Varible
            view.category_ID = str_ID
            view.category_PathID = str_ID
            
        }else if segue.identifier == "categoryfilterresultdirect"{
            
            let obj : SearchViewObject = arr_Main[sender as! Int] as! SearchViewObject
            if obj.str_Title != "All"{
                let str_Varible : NSString = obj.str_Title
                let str_ID : NSString = String(obj.str_ID) as NSString
                
                let view : CategoryFilterResultViewController = segue.destination as! CategoryFilterResultViewController
                view.category_List = str_Varible
                view.category_List_Path = str_ID
            }else{
                let view : CategoryFilterResultViewController = segue.destination as! CategoryFilterResultViewController
                view.category_List = "All"
                view.category_List_Path = ""
                view.category_SearchValue = tf_Search.text as! NSString
            }
        }
    }
 

}

//MARK: - Search Object -

class SearchViewObject: NSObject {
    var str_Title : NSString = ""
    var str_ID : NSString = ""
    var str_image : NSString = ""
    var str_sub_category_available : NSString = ""
}


// MARK: - Tableview Files -
extension SearchViewController : UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr_Main.count == 0 && tf_Search.text != ""{
            return 1
        }
        return arr_Main.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell_Identifier = "cell"
        if arr_Main.count == 0{
            cell_Identifier = "nodata"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_Identifier, for:indexPath as IndexPath) as! SearchTableviewCell
        
        if arr_Main.count != 0{
            let obj : SearchViewObject = arr_Main[indexPath.row] as! SearchViewObject
            
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
            
            let obj : SearchViewObject = arr_Main[indexPath.row] as! SearchViewObject

            if obj.str_Title != "All"{
                if obj.str_sub_category_available == "Y" {
                    tf_Search.text = ""
                    self.performSegue(withIdentifier: "categoryfilter", sender: indexPath.row)
                }else{
                    self.performSegue(withIdentifier: "categoryfilterresultdirect", sender: indexPath.row)
                }
            }else{
                self.performSegue(withIdentifier: "categoryfilterresultdirect", sender: indexPath.row)
            }
        }
    }
}

//MARK: - Tableview View Cell -
class SearchTableviewCell : UITableViewCell{
    //Main Listing
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var img_Icon: UIImageView!
    
}



extension SearchViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "get_category" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            arr_Main = []
            arr_Main_Store = []
            
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                //Demo data
                var obj = SearchViewObject ()
                obj.str_ID = ("\(dict_Data["category_id"] as! Int)" as NSString)
                obj.str_Title = dict_Data["c_title"] as! String as NSString
                obj.str_image = dict_Data["c_image"] as! String as NSString
                obj.str_sub_category_available = dict_Data["sub_category_available"] as! String as NSString
                
                arr_Main.add(obj)
            }
            //All Object
            
            var obj = SearchViewObject ()
            obj.str_ID = ""
            obj.str_Title = "All"
            obj.str_image = ""
            obj.str_sub_category_available = "N"
            arr_Main.insert(obj, at: 0)
            
             arr_Main_Store = NSMutableArray(array: arr_Main);
            
            tbl_Main.reloadData()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
       // self.completedServiceCalling()
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

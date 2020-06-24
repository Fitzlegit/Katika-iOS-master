//
//  AdminChatViewController.swift
//  Katika
//
//  Created by Katika_07 on 25/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class AdminChatViewController: UIViewController {

    
    @IBOutlet var tbl_Main : UITableView!
    
    //Array Declaration
    var arr_Main : NSMutableArray = []
    
    //Refresh Controller
    var refresh_Data: UIRefreshControl?
    
    //Bool Declaration
    var bool_Load: Bool = false
    var bool_ViewWill: Bool = false
    var bool_SearchMore: Bool = true
    
    //Max Min Limit
    var int_CountLoad: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //First time sevice call for featured product
        int_CountLoad = Constant.int_LoadMax
        bool_ViewWill = true
        self.Get_List(count:int_CountLoad)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Scrollview Delegate -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == tbl_Main{
            if tbl_Main.contentSize.height <= tbl_Main.contentOffset.y + tbl_Main.frame.size.height && tbl_Main.contentOffset.y >= 0 {
                if bool_Load == false && arr_Main.count != 0 {
                    self.Get_List(count: int_CountLoad + Constant.int_LoadMax)
                }
            }
        }
    }
    
    // MARK: - refersh controller -
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        if bool_Load == false {
            int_CountLoad = Constant.int_LoadMax
            bool_ViewWill = true
            bool_SearchMore = true
            
            self.Get_List(count:int_CountLoad)
        }else{
            refresh_Data?.endRefreshing()
        }
    }

    
    //MARK: - Other Files -
    func commanMethod(){
        //Refresh Controller
        refresh_Data = UIRefreshControl()
        refresh_Data?.tintColor = UIColor.red
        refresh_Data?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tbl_Main.addSubview(refresh_Data!)
    }
    func completedServiceCalling(){
        //Comman fuction action
        refresh_Data?.endRefreshing()
        bool_Load = false
    }

    func Get_List(count : Int){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)notifications_list"
        
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "skip" : "\(count - Constant.int_LoadMax)",
            "total" : "\(count)",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "notifications_list"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        
        
        //If first time call than only show loader otherwise not showing loader
        (arr_Main.count == 0) ? (webHelper.indicatorShowOrHide = true) : (webHelper.indicatorShowOrHide = false)
        
        //Not limit for end data than only service call
        if bool_SearchMore == true{
            webHelper.startDownload()
        }
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

//MARK: - Home Object -
class AdminChatObject: NSObject {
    var str_ID : NSString = ""
    var str_Title : NSString = ""
    var str_Date : NSString = ""
}

// MARK: - Tableview Files -
extension AdminChatViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arr_Main.count == 0{
            return CGFloat(tbl_Main.frame.size.height)
        }
        return UITableView.automaticDimension
 
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr_Main.count == 0{
            return 1
        }
        return arr_Main.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var str_Identifer : String = "cell"
        if arr_Main.count == 0{
            str_Identifer = "nodata"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: str_Identifer, for:indexPath as IndexPath) as! InboxTableviewCell
        
        if arr_Main.count == 0{
            cell.lbl_Title.text = "There are no notifications at this time"
        }else{
            let obj : AdminChatObject = arr_Main[indexPath.row] as! AdminChatObject
            
            //Value Set
            cell.lbl_Title.text = (obj.str_Title ) as String
            cell.lbl_Date.text = localDateToStrignDate(date :obj.str_Date as String)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - Tableview View Cell -
class InboxTableviewCell : UITableViewCell{
    //Cell for tabbar
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
}


extension AdminChatViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        self.completedServiceCalling()
        
        let response = data as! NSDictionary
        if strRequest == "notifications_list" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            var arr_ResultSub : NSMutableArray = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                //Other Tab Demo data
                let obj = AdminChatObject ()
                obj.str_ID = ("\(dict_Data["noti_id"] as! Int)" as NSString)
                obj.str_Title = dict_Data["message"] as! String as NSString
                obj.str_Date = dict_Data["created_date"] as! String as NSString
                
                arr_ResultSub.add(obj)
            }
            
            //Refresh code
            if bool_ViewWill == true {
                arr_Main = []
                int_CountLoad = arr_ResultSub.count
            }else{
                int_CountLoad = int_CountLoad + arr_ResultSub.count
            }
            
            for i in (0...arr_ResultSub.count-1){
                arr_Main.add(arr_ResultSub[i])
            }
            
            //Load more data or not
            if Constant.int_LoadMax > arr_ResultSub.count {
                //Bool Load more
                bool_SearchMore = false
            }
            else {
                //Bool Load more
                bool_SearchMore = true
            }
            
            
            tbl_Main.reloadData()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
        self.completedServiceCalling()
        tbl_Main.reloadData()
    }
    
}




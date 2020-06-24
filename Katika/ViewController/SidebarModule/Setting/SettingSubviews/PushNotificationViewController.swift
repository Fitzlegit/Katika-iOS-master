//
//  PushNotificationViewController.swift
//  Katika
//
//  Created by KatikaRaju on 5/25/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class PushNotificationViewController: UIViewController {

    //Object Detalaration
    var obj_SettingDetail = SettingObject ()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //TableView Footer
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        self.Post_Setting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Event -
    @IBAction func closeClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true
        )
    }
    @IBAction func btn_ChangeDealChange(mySwitch: UISwitch) {
        if mySwitch.isOn {
            
            obj_SettingDetail.str_ispush_deal_on = "1"
            self.Post_UpdateSetting(type : "deal",stage : "1")
        } else {
            
            obj_SettingDetail.str_ispush_deal_on = "0"
            self.Post_UpdateSetting(type : "deal",stage : "0")
        }
        
        tableView.reloadData()
    }
    @IBAction func btn_PackagesChange(mySwitch: UISwitch) {
        if mySwitch.isOn {
            
            obj_SettingDetail.str_ispush_packages_on = "1"
            self.Post_UpdateSetting(type : "packages",stage : "1")
        } else {
            
            obj_SettingDetail.str_ispush_packages_on = "0"
            self.Post_UpdateSetting(type : "packages",stage : "0")
        }
        
        tableView.reloadData()
    }
    @IBAction func btn_MessageChange(mySwitch: UISwitch) {
        if mySwitch.isOn {
            
            obj_SettingDetail.str_ispush_messages_on = "1"
            self.Post_UpdateSetting(type : "messages",stage : "1")
        } else {
            
            obj_SettingDetail.str_ispush_messages_on = "0"
            self.Post_UpdateSetting(type : "messages",stage : "0")
        }
        
        tableView.reloadData()
    }
    @IBAction func btn_ShopChange(mySwitch: UISwitch) {
        if mySwitch.isOn {
            
            obj_SettingDetail.str_ispush_shops_on = "1"
            self.Post_UpdateSetting(type : "shops",stage : "1")
        } else {
            
            obj_SettingDetail.str_ispush_shops_on = "0"
            self.Post_UpdateSetting(type : "shops",stage : "0")
        }
        
        tableView.reloadData()
    }
    
    func Post_Setting(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_user_setting"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_user_setting"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
    func Post_UpdateSetting(type : String,stage : String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)notification_onoff"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
            "status" : stage,
            "key" : type,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "notification_onoff"
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
    //MARK: - Tableview Methods -
extension PushNotificationViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if obj_SettingDetail.str_isemail_on != "" {
            return 4
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSetting", for: indexPath) as! SettingTableviewCell
        cell.selectionStyle = .none
        cell.imgViewArrow.isHidden = true

        
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = "Receive notification for deals"
            if obj_SettingDetail.str_ispush_deal_on == "1"{
                cell.btnSwitch.isOn = true
            }else{
                cell.btnSwitch.isOn = false
            }
            cell.btnSwitch.addTarget(self, action: #selector(btn_ChangeDealChange), for: UIControl.Event.valueChanged)
            
            break
        case 1:
            cell.lblTitle.text = "Receive notification for packages"
            if obj_SettingDetail.str_ispush_packages_on == "1"{
                cell.btnSwitch.isOn = true
            }else{
                cell.btnSwitch.isOn = false
            }
            cell.btnSwitch.addTarget(self, action: #selector(btn_PackagesChange), for: UIControl.Event.valueChanged)
            
            break
        case 2:
            cell.lblTitle.text = "Receive notifications for messages"
            if obj_SettingDetail.str_ispush_messages_on == "1"{
                cell.btnSwitch.isOn = true
            }else{
                cell.btnSwitch.isOn = false
            }
            cell.btnSwitch.addTarget(self, action: #selector(btn_MessageChange), for: UIControl.Event.valueChanged)
            break
        case 3:
            cell.lblTitle.text = "Receive notifications from shops"
            if obj_SettingDetail.str_ispush_shops_on == "1"{
                cell.btnSwitch.isOn = true
            }else{
                cell.btnSwitch.isOn = false
            }
            cell.btnSwitch.addTarget(self, action: #selector(btn_ShopChange), for: UIControl.Event.valueChanged)
            break
        default:
            break
        }
        //        indexPath.row == 2 || indexPath.row == 3 ? (cell.imgViewArrow.isHidden = true):(cell.imgViewArrow.isHidden = false)
        
        
        return cell;
        
    }
}



extension PushNotificationViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "get_user_setting" {
            
            //Setting detail
            let dict_SettingData = response["setting"] as! NSDictionary
            
            let obj = SettingObject ()
            obj.str_ispush_deal_on = ("\(dict_SettingData["ispush_deal_on"] as! Int)" as NSString)
            obj.str_ispush_packages_on = ("\(dict_SettingData["ispush_packages_on"] as! Int)" as NSString)
            obj.str_ispush_messages_on = ("\(dict_SettingData["ispush_messages_on"] as! Int)" as NSString)
            obj.str_ispush_shops_on = ("\(dict_SettingData["ispush_shops_on"] as! Int)" as NSString)
            obj.str_isemail_on = ("\(dict_SettingData["isemail_on"] as! Int)" as NSString)
            
            obj.str_termscondition = dict_SettingData["termscondition"] as! NSString
            obj.str_aboutapp = dict_SettingData["aboutapp"] as! NSString
            
            obj_SettingDetail = obj
            
            tableView.reloadData()
        }else if strRequest == "notification_onoff" {
            
            
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
        
    }
}


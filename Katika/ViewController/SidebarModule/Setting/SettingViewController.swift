//
//  SettingViewController.swift
//  Katika
//
//  Created by KatikaRaju on 5/25/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit


class SettingViewController: UIViewController {
    //Other Declaration
    @IBOutlet weak var tableViewSetting: UITableView!
    
    //Object Detalaration
    var obj_SettingDetail = SettingObject ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)

        //TableView Footer
        tableViewSetting.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        self.Post_Setting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
  
        self.navigationController?.popViewController(animated:false)
//         self.navigationController?.popViewController(animated: false)
    }
    @objc func btn_ChangeEmail(mySwitch: UISwitch) {
        if mySwitch.isOn {
            
            obj_SettingDetail.str_isemail_on = "1"
            self.Post_UpdateSetting(type : "email",stage : "1")
        } else {
            
            obj_SettingDetail.str_isemail_on = "0"
            self.Post_UpdateSetting(type : "email",stage : "0")
        }
        
        tableViewSetting.reloadData()
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

//MARK: - Setting Object -

class SettingObject: NSObject {
    
    //Product listing Other
    var int_Title_Sort : Int = 0
    
    //Shipping Address
    var str_ispush_deal_on : NSString = ""
    var str_ispush_packages_on : NSString = ""
    var str_ispush_messages_on : NSString = ""
    var str_ispush_shops_on : NSString = ""
    var str_isemail_on : NSString = ""
    var str_termscondition : NSString = ""
    var str_aboutapp : NSString = ""
    
}


    //MARK: - TableviewCell -
class SettingTableviewCell : UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgViewArrow:UIImageView!
    
    @IBOutlet weak var btnSwitch:UISwitch!
}
    //MARK: - Tableview methods -
extension SettingViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if obj_SettingDetail.str_isemail_on != "" {
            return 5
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3{
            return 0
        }
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSetting", for: indexPath) as! SettingTableviewCell
        cell.selectionStyle = .none
        
        if indexPath.row == 2 || indexPath.row == 3 {
            cell.imgViewArrow.isHidden = true
            cell.btnSwitch.isHidden = false
        } else {
            cell.imgViewArrow.isHidden = false
            cell.btnSwitch.isHidden = true
        }
    
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = "Terms & Conditions"
            break
        case 1:
            cell.lblTitle.text = "Push Notifications"
            break
        case 2:
            cell.lblTitle.text = "E-mail Notifications"
            if obj_SettingDetail.str_isemail_on == "1"{
                cell.btnSwitch.isOn = true
            }else{
                cell.btnSwitch.isOn = false
            }
            cell.btnSwitch.addTarget(self, action: #selector(btn_ChangeEmail), for: UIControl.Event.valueChanged)
            break
        case 3:
            cell.lblTitle.text = "Touch ID"
            break
        case 4:
            cell.lblTitle.text = "About This App"
            break
        default:
            break
        }
        
//        indexPath.row == 2 || indexPath.row == 3 ? (cell.imgViewArrow.isHidden = true):(cell.imgViewArrow.isHidden = false)
        
       
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self .performSegue(withIdentifier: "TermsAndCondition", sender: self);
            break
        case 1:
            self .performSegue(withIdentifier: "PushNotificationDetails", sender: self);
            
            break
        case 2:
            //            cell.lblTitle.text = "E-mail Notifications"
            break
        case 3:
            //            cell.lblTitle.text = "Touch ID"
            break
        case 4:
            self .performSegue(withIdentifier: "AboutKatikaDetails", sender: self);
            break
        default:
            break
        }
        
    }
}




extension SettingViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "get_user_setting" {
            
            //Product detail
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
            
            tableViewSetting.reloadData()
        }else if strRequest == "notification_onoff" {
            
            
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
      
        
    }
    
}



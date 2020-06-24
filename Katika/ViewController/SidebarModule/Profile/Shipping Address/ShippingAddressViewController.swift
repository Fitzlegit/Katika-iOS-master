//
//  ShippingAddressViewController.swift
//  Katika
//
//  Created by Katika on 22/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit


class ShippingAddressViewController: UIViewController {

    //Other Declaration
    @IBOutlet weak var tbl_Main: UITableView!
    
    var bool_ComefromCheckout : Bool = false
    var bool_LoadData : Bool = false
    
    @IBOutlet weak var con_EditButtonHeight: NSLayoutConstraint!
    
    var arr_Main : [ShippingAddressObject] = []

    var int_SelectedAddress : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        self.CommanMethod()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.Post_ShippingList()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Other Files -
    func CommanMethod(){

        if bool_ComefromCheckout == false {
        }
    }
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Edit(_ sender : Any){
        let obj : ShippingAddressObject = arr_Main[int_SelectedAddress] 
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ShippingAddOrEditViewController") as! ShippingAddOrEditViewController
        view.obj_Get = obj
        view.isEditData = true
        self.navigationController?.pushViewController(view, animated: true)
    }
    @IBAction func btn_Delete(_ sender : Any){
        //Logout alert for user
        let alert = UIAlertController(title: Constant.appName, message: "Are you sure want to delete this shipping address?", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { (action) in
            
            let obj : ShippingAddressObject = self.arr_Main[self.int_SelectedAddress] 
            self.Post_DeleteShippingAddress(id:obj.str_Id as String)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }

    // MARK: - Get/Post Method -
    func Post_ShippingList(){
        self.bool_LoadData = true
        con_EditButtonHeight.constant = 0
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)shipping_address_list"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as String? ?? "",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "shipping_address_list"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }
    
    func Post_EditShippingAddress(obj : ShippingAddressObject){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)update_shipping_address"

        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "id" : obj.str_Id as NSString,
            "user_id" : objUser?.str_Userid as String? ?? "",
            "name" : obj.str_Title as NSString,
            "phone" : obj.str_PhoneNumber as NSString,
            "city" : obj.str_City as NSString,
            "state" : obj.str_State as NSString,
            "zip" : obj.str_Zip as NSString,
            "address1" : obj.str_Address as NSString,
            "address2" : obj.str_Address2 as NSString,
            "isprimary_address" : "1",
        ]

        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "update_shipping_address"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.startDownload()
    }
    
    func Post_DeleteShippingAddress(id : String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)remove_shipping_address"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as String? ?? "",
            "id" : id,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "remove_shipping_address"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
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

class ShippingAddressViewControllerCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_Address2: UILabel!
    
    @IBOutlet weak var con_TopImageHeight: NSLayoutConstraint!
    @IBOutlet weak var con_BottomImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var img_SelectedAddress: UIImageView!
    
}

class ShippingAddressObject : NSObject {
    var str_Id : NSString = ""
    var str_Title : NSString = ""
    var str_PhoneNumber : NSString = ""
    var str_Country : NSString = ""
    var str_Address : NSString = ""
    var str_Address2 : NSString = ""
    var str_Zip : NSString = ""
    var str_City : NSString = ""
    var str_State : NSString = ""
    var str_SeletecedAddress : NSString = ""
}


// MARK: - Tableview Files -

extension ShippingAddressViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arr_Main.count == 0 && self.bool_LoadData == false{
            return 50
        }
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 108
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr_Main.count == 0 && self.bool_LoadData == false{
            return 1
        }
        
        return arr_Main.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var str_CellIdentifier = "cell"
        if bool_ComefromCheckout == true {
            str_CellIdentifier = "cellselected"
        }
        
        if arr_Main.count == 0{
            str_CellIdentifier = "nodata"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: str_CellIdentifier, for:indexPath as IndexPath) as! ShippingAddressViewControllerCell
       
        if arr_Main.count != 0{
        
            //Bottom image always be hide
            cell.con_TopImageHeight.constant = 0.5
            cell.con_BottomImageHeight.constant = 0.5
            
            //Last colum to unhide bottom line
            if indexPath.row == 0{
                cell.con_TopImageHeight.constant = 1.0
            }else if indexPath.row == (arr_Main.count - 1) {
                cell.con_BottomImageHeight.constant = 1.0
            }
            
            //Assign Data value
            let obj : ShippingAddressObject = arr_Main[indexPath.row]
            cell.lblTitle.text = "Name : \(obj.str_Title as String)"
            cell.lbl_Address.text = "Address : \(obj.str_Address as String)"
            cell.lbl_Address2.text = "\(obj.str_Address2 as String)"
            
            if bool_ComefromCheckout == true {
                if obj.str_SeletecedAddress == "1"{
                    cell.img_SelectedAddress.image = UIImage(named: "img_SelectedArrow")
                }else{
                    cell.img_SelectedAddress.image = UIImage(named: "img_UnSelectedArrow")
                }
            }
            
        }else{
            cell.lblTitle.text = "No data found"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arr_Main.count != 0{
            if bool_ComefromCheckout == true {
                int_SelectedAddress = indexPath.row
//                con_EditButtonHeight.constant = 50
                
                let obj : ShippingAddressObject = arr_Main[indexPath.row] 
                self.Post_EditShippingAddress(obj: obj)
                
                tbl_Main.reloadData()
            }else{
                let obj : ShippingAddressObject = arr_Main[indexPath.row] 

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "ShippingAddOrEditViewController") as! ShippingAddOrEditViewController
                view.obj_Get = obj
                view.isEditData = true
                self.navigationController?.pushViewController(view, animated: false)
                
            }
        }
    }
    
}



extension ShippingAddressViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        self.bool_LoadData = false
        
        let response = data as! NSDictionary
        if strRequest == "shipping_address_list" {
            
            //Manage Sub category Data
            let arr_result = response["result"] as! NSArray
            
            arr_Main = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                print(dict_Data)
                let obj = ShippingAddressObject()
                obj.str_Id = ("\(dict_Data["id"] as! Int)" as NSString)
                obj.str_Title = dict_Data["name"] as! String as NSString
                obj.str_PhoneNumber = dict_Data["phone"] as! String as NSString
                obj.str_Address = dict_Data["address1"] as! String as NSString
                obj.str_Address2 = dict_Data["address2"] as! String as NSString
                obj.str_Zip = dict_Data["zip"] as! String as NSString
                obj.str_City = dict_Data["city"] as! String as NSString
                obj.str_State = dict_Data["state"] as! String as NSString
                obj.str_Country = dict_Data["country"] as! String as NSString

                obj.str_SeletecedAddress = ("\(dict_Data["isprimary_address"] as! Int)" as NSString)
                
                if bool_ComefromCheckout == true {
                    if obj.str_SeletecedAddress == "1" {
                        con_EditButtonHeight.constant = 50
                    }
                }
                
                arr_Main.append(obj)
            }
            
            tbl_Main.reloadData()
        }else if strRequest == "update_shipping_address"{
            self.Post_ShippingList()
        }else if strRequest == "remove_shipping_address"{
            
            self.Post_ShippingList()
        }
        
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        self.bool_LoadData = false
        
        if strRequest == "shipping_address_list" {
            arr_Main = []
        }
        
        tbl_Main.reloadData()
    }
    
}




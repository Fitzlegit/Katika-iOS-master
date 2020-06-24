//
//  FilterShopLocationSelectionViewController.swift
//  Katika
//
//  Created by Katika_07 on 17/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages

class FilterShopLocationSelectionViewController: UIViewController , UITextFieldDelegate {

    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    @IBOutlet weak var tf_ZipCode: UITextField!
    
    var objLocation = FilterShopObject ()
    
    var str_Lat : NSString = ""
    var str_Long : NSString = ""
    var str_LocationName : NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - TextField Manage -
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if tf_ZipCode.text != "" {
            self.Get_SearchCategory()
        }
        view.endEditing(true)
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.phase == .began {
            view.endEditing(true)
        }
    }
    func textFieldDidChange(textField: UITextField){
        
    }
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        dismiss(animated: true) { _ in }
    }
    @IBAction func btn_Done (_ sender : Any){
        dismiss(animated: true) { _ in }
    }
    
    
    // MARK: - Get/Post Method -
    func Get_SearchCategory(){
        
        //Declaration URL
        let strURL = "http://maps.googleapis.com/maps/api/geocode/json?address=\(tf_ZipCode.text!)&sensor=true"
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "google"
        webHelper.methodType = "get"
        webHelper.strURL = strURL
        webHelper.dictType = NSDictionary()
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }
    
    func Post_ChangeLoaction(locationName:String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)updatefilter_location"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String ,
            "location" : locationName,
            "latitude" : str_Lat,
            "longitude" : str_Long,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "updatefilter_location"
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
class FilterShopLocationSelectionTableviewCell : UITableViewCell{
    
    //Label Declartion
    @IBOutlet weak var lbl_Title: UILabel!
    
    //Textfield Detlaration
    @IBOutlet weak var tf_Location: UITextField!
    
    //Image Decalration
    @IBOutlet weak var img_SelectedCell: UIImageView!
}

// MARK: - Tableview Files -
extension FilterShopLocationSelectionViewController : UITableViewDelegate,UITableViewDataSource {
    // MARK: - Table View -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 50
        }else if indexPath.row == 1 {
            return 70
        }
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIdentifier : String = "cell"
        if indexPath.row == 1 {
            cellIdentifier = "location"
        }
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! FilterShopLocationSelectionTableviewCell
        
        if indexPath.row == 0 {
            if objLocation.str_FilterSeletectedTitle == "Anywhere" {
                cell.img_SelectedCell.isHidden = false
            }else{
                cell.img_SelectedCell.isHidden = true
            }
            cell.lbl_Title.text = "Anywhere"
        }else if indexPath.row == 1 {
            cell.tf_Location.delegate = self
            
            tf_ZipCode = cell.tf_Location
        }
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            str_Lat = ""
            str_Long = ""
            objLocation.str_FilterSeletectedTitle = "Anywhere"
            
            self.Post_ChangeLoaction(locationName : "")
            tbl_Main.reloadData()
        }
    }
}



extension FilterShopLocationSelectionViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "google" {
            
            if response["status"] as? String == "OK"{
                //Get Main array
                let arr_result = response["results"] as! NSArray
                
                let dict_result = arr_result[0] as! NSDictionary
                
                let arr_addressComponent = dict_result["address_components"] as! NSArray
                
                for i in 0..<arr_addressComponent.count{
                    let dict_Sub_Address = arr_addressComponent[i] as! NSDictionary
                    
                    let arr_Sub_Address_Type = (dict_Sub_Address["types"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    print(arr_Sub_Address_Type)
                    
                    if arr_Sub_Address_Type.contains("locality") {
                        str_LocationName = dict_Sub_Address["short_name"] as! String as NSString
                    //    lbl_CurrentLocation.text = ("Current Location : \(dict_Sub_Address["short_name"] as! String)")
                        break
                    }else  if arr_Sub_Address_Type.contains("administrative_area_level_2") {
                        str_LocationName = dict_Sub_Address["short_name"] as! String as NSString
                    //    lbl_CurrentLocation.text = ("Current Location : \(dict_Sub_Address["short_name"] as! String)")
                        break
                    }else  if arr_Sub_Address_Type.contains("administrative_area_level_1") {
                        str_LocationName = dict_Sub_Address["short_name"] as! String as NSString
                     //   lbl_CurrentLocation.text = ("Current Location : \(dict_Sub_Address["short_name"] as! String)")
                        break
                    }
                }
                
                //Get Lat str_Long
                let dict_geometry = dict_result["geometry"] as! NSDictionary
                let dict_Location = dict_geometry["location"] as! NSDictionary
                
                if dict_Location.count != 0 {
                    str_Lat = ("\(dict_Location["lat"] as! Float)" as NSString)
                    str_Long = ("\(dict_Location["lng"] as! Float)" as NSString)
                }
                
                self.Post_ChangeLoaction(locationName : str_LocationName as String)
                
                //Save in sever
                //self.Post_ChangeLoaction()
            }else{
                tf_ZipCode.text = ""
                messageBar.MessageShow(title: "Please enter valid zipcode or city name.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }
        }else if strRequest == "updatefilter_location" {
           
            
            dismiss(animated: true) { _ in }
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        // self.completedServiceCalling()
    }
    
}






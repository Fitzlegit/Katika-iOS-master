//
//  CurrentLocationViewController.swift
//  Katika
//
//  Created by Katika_07 on 05/07/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages


class CurrentLocationViewController: UIViewController {

    //Declaration Images
    @IBOutlet weak var tf_ZipCode: UITextField!
    
    @IBOutlet weak var lbl_CurrentLocation: UILabel!
    
    var str_Lat : NSString = ""
    var str_Long : NSString = ""
    var str_LocationName : NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.commanMethod()
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

    
    //MARK: - Other Files -
    func commanMethod(){
        lbl_CurrentLocation.text = ("Current Location : \(objUser?.str_Address as! String)")
        
    }
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Get/Post Method -
    func Get_SearchCategory(){
        
        //Declaration URL
        let strURL = "https://maps.googleapis.com/maps/api/geocode/json?address=\(tf_ZipCode.text!)&sensor=true&key=AIzaSyDoUrlHgb3VyzhuoDIljfmgP3EuU5p0ZlQ"

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
    
    func Post_ChangeLoaction(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)update_location"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid as! String ,
            "latitude" : str_Lat,
            "longitude" : str_Long, 
            "address" : str_LocationName,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "update_location"
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




extension CurrentLocationViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "google" {
            
            if response["status"] as? String == "OK"{
                //Get Main array
                let arr_result = response["results"] as! NSArray
                
                let dict_result = arr_result[0] as! NSDictionary
                
                let arr_addressComponent = dict_result["address_components"] as! NSArray
                
                var bool_Match : Bool = false
                for i in 0..<arr_addressComponent.count{
                    let dict_Sub_Address = arr_addressComponent[i] as! NSDictionary

                    let arr_Sub_Address_Type = (dict_Sub_Address["types"]! as! NSArray).mutableCopy() as! NSMutableArray

                    print(arr_Sub_Address_Type)

                    if arr_Sub_Address_Type.contains("locality") {
                        str_LocationName = dict_Sub_Address["short_name"] as! String as NSString
                        lbl_CurrentLocation.text = ("Current Location : \(dict_Sub_Address["short_name"] as! String)")
                        bool_Match = true
                        break
                    }else  if arr_Sub_Address_Type.contains("administrative_area_level_2") {
                        str_LocationName = dict_Sub_Address["short_name"] as! String as NSString
                        lbl_CurrentLocation.text = ("Current Location : \(dict_Sub_Address["short_name"] as! String)")
                        bool_Match = true
                        break
                    }else  if arr_Sub_Address_Type.contains("administrative_area_level_1") {
                        str_LocationName = dict_Sub_Address["short_name"] as! String as NSString
                        lbl_CurrentLocation.text = ("Current Location : \(dict_Sub_Address["short_name"] as! String)")
                        bool_Match = true
                        break
                    }
                }
                
                if bool_Match == true {
                    //Get Lat str_Long
                    let dict_geometry = dict_result["geometry"] as! NSDictionary
                    let dict_Location = dict_geometry["location"] as! NSDictionary
                    
                    if dict_Location.count != 0 {
                        str_Lat = dict_Location.getStringForID(key:"lat")  as! NSString
                        str_Long = dict_Location.getStringForID(key:"lng")  as! NSString
                    }
                    
                    //Save in sever
                    self.Post_ChangeLoaction()
                }else{
                     messageBar.MessageShow(title: "Please enter valid zipcode or city name.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                }
                
            }else{
                tf_ZipCode.text = ""
                messageBar.MessageShow(title: "Please enter valid zipcode or city name.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }
        }else if strRequest == "update_location" {
//            let myString = lbl_CurrentLocation.text
//            let myNSString = myString as NSString

            objUser?.str_Address = str_LocationName
            objUser?.str_Lat = str_Lat
            objUser?.str_Long = str_Long
            saveCustomObject(objUser!, key: "userobject");
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        // self.completedServiceCalling()
    }
    
}


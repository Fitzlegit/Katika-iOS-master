//
//  PromoCodeViewController.swift
//  Katika
//
//  Created by Katika_07 on 22/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages

class PromoCodeViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var tf_Promocode: UITextField!
    
    var str_GrandTotal: NSString! = ""
    
    //Object Detalaration
    let obj_Promocode = PromocodeObject ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tf_Promocode.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITextField Delegates -
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        view.endEditing(true)
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        if tf_Promocode == textField {
            let text = textField.text
            
            if string == "" {
                return true
            }else if (text?.characters.count)! > 15 || string == " " {
                return false
            }
        }
        return true
    }
    func validateCouponApplyOrNot(){
        
        let str_valueConvert : String = str_GrandTotal as! String
        //First check purchase total more than requied coupon min value
        let int_Total : Int = Int(obj_Promocode.str_min_purchase_value as String)!
        let int_Total2 : Int = Int(str_valueConvert)!
        
        //First check condition for total value more than mimimum discount value
        if int_Total > int_Total2{
            
            messageBar.MessageShow(title: "You have not eligible for this promo code .", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else{
            
            //If 0 than coupon for persentce dicount
            if obj_Promocode.str_promo_percentage as String != "0"{
                //Persentace discount
                let str_Percentacecvalue = obj_Promocode.str_promo_percentage as String
                
                var double_Caculation : Double = (Double(str_Percentacecvalue)! * Double(str_valueConvert )! ) / 100
                
                if double_Caculation > Double(obj_Promocode.str_max_discount as String)! {
                    obj_Promocode.str_mycalulation_discount = obj_Promocode.str_max_discount as String as NSString
                }else{
                    obj_Promocode.str_mycalulation_discount = String(double_Caculation) as NSString
                }
                
            }else{
                //Direct discount
                obj_Promocode.str_mycalulation_discount = obj_Promocode.str_promo_discount as String as NSString
            }
            
            //Apply Coupon or not validation
            obj_PromocodeDiscountPrice = obj_Promocode
            var _ = self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    //MARK: - Touch Began -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.phase == .began {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        var _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Apply(_ sender : Any){
        self.Get_ReviewLikeStatuse()
    }

    
    // MARK: - Get/Post Method -
    func Get_ReviewLikeStatuse(){
        self.view.endEditing(true)
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)check_promocode"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "promocode" : tf_Promocode.text,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "check_promocode"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
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

//MARK: - Promocode Object -
class PromocodeObject: NSObject {
    
    var str_promo_id : NSString = ""
    var str_promocode : NSString = ""
    var str_promo_description : NSString = ""
    var str_promo_percentage : NSString = ""
    var str_promo_discount : NSString = ""
    var str_min_purchase_value : NSString = ""
    var str_max_discount : NSString = ""
    var str_max_usage : NSString = ""
    var str_expired_date : NSString = ""
    var str_created_date : NSString = ""
    var str_mycalulation_discount : NSString = ""
    
}


extension PromoCodeViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "check_promocode" {
            
            //Product detail
            let arr_result = response["Result"] as! NSArray
            
            let dict_Data = arr_result[0] as! NSDictionary
            
            obj_Promocode.str_promo_id = ("\(dict_Data["promo_id"] as! Int)" as NSString)
            obj_Promocode.str_min_purchase_value = ("\(dict_Data["min_purchase_value"] as! Int)" as NSString)
            obj_Promocode.str_max_discount = ("\(dict_Data["max_discount"] as! Int)" as NSString)
            obj_Promocode.str_max_usage = ("\(dict_Data["max_usage"] as! Int)" as NSString)
            
            
            obj_Promocode.str_promocode = dict_Data["promocode"] as! NSString
            obj_Promocode.str_promo_description = dict_Data["promo_description"] as! NSString
            obj_Promocode.str_promo_percentage = dict_Data["promo_percentage"] as! NSString
            obj_Promocode.str_promo_discount = dict_Data["promo_discount"] as! NSString
            obj_Promocode.str_expired_date = dict_Data["expired_date"] as! NSString
            obj_Promocode.str_created_date = dict_Data["created_date"] as! NSString
            
            self.validateCouponApplyOrNot()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
    }
    
}



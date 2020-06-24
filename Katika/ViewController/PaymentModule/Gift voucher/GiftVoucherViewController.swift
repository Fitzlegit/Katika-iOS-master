//
//  GiftVoucherViewController.swift
//  Katika
//
//  Created by Katika_07 on 22/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class GiftVoucherViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var tf_GiftVoucher: UITextField!
    
    //Object Detalaration
    let obj_GiftVoucher = GiftVoucherObject ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf_GiftVoucher.delegate = self
        
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
        if tf_GiftVoucher == textField {
            let text = textField.text
            
            if string == "" {
                return true
            }else if (text?.characters.count)! > 15 || string == " " {
                return false
            }
        }
        return true
    }
//    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
//        if tf_GiftVoucher == textField {
//            let text = textField.text
//            if (text?.characters.count)! > 15 {
//                return false
//            }
//        }
//        return true
//    }
   
    
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
        self.Get_GiftVoucher()
    }
    
    // MARK: - Get/Post Method -
    func Get_GiftVoucher(){
        self.view.endEditing(true)
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)check_voucher"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "vouchercode" : tf_GiftVoucher.text,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "check_voucher"
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
class GiftVoucherObject: NSObject {
    
    var str_voucher_id : NSString = ""
    var str_voucher_code : NSString = ""
    var str_voucher_active : NSString = ""
    var str_voucher_amount : NSString = ""
    
}

extension GiftVoucherViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "check_voucher" {
            
            //Product detail
            let arr_result = response["Result"] as! NSArray
            
            let dict_Data = arr_result[0] as! NSDictionary
            
            obj_GiftVoucher.str_voucher_id = ("\(dict_Data["voucher_id"] as! Int)" as NSString)
            obj_GiftVoucher.str_voucher_active = ("\(dict_Data["voucher_active"] as! Int)" as NSString)
            
            obj_GiftVoucher.str_voucher_code = dict_Data["voucher_code"] as! NSString
            obj_GiftVoucher.str_voucher_amount = dict_Data["voucher_amount"] as! NSString
            
            obj_GiftVoucherDiscountPrice = obj_GiftVoucher
            
            var _ = self.navigationController?.popViewController(animated: true)

        }
        
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
    }
    
}

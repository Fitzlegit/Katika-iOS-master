//
//  ChangeCurrencyViewController.swift
//  Katika
//
//  Created by icoderz_04 on 09/10/18.
//  Copyright © 2018 icoderz123. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0


class ChangeCurrencyViewController: UIViewController {

    //Declaration TEXT
    @IBOutlet var txtCurrency : UITextField!
    @IBOutlet weak var btnBack: UIBarButtonItem!

    //Declaration BUTTON
    @IBOutlet var btnSubmit: UIButton!

    var arrCurrencyData = NSMutableArray()
    var str_IsLogin : NSString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        //SET NAVIGATION BAR
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //GET CURRNECY DATA
        self.Get_Cuurrency()
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        //create a new button
        let button = UIButton.init(type: .custom)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //SET BACK BUTTON
        if str_IsLogin == "1"{
        }
        else{
            //set title for button
            button.setImage(UIImage(named: "icon_NavigationRightArrow"), for: .normal)
            button.addTarget(self, action: #selector(btnBackClicked(_:)), for: UIControl.Event.touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            let barButton = UIBarButtonItem(customView: button)
            
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItem = barButton
            
        }
    
        //SET SELECTED CURRENCY
        txtCurrency.text = (objUser?.str_Currency as! String)

        //Layer Set
        btnSubmit.layer.cornerRadius = 5.0
        btnSubmit.layer.masksToBounds = true
        
    }
    // MARK: -  ACTION BUTTON
     @objc func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil, userInfo: nil)
    }
   
    
    // MARK: - Get/Post Method -

    func Get_Cuurrency(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_user_setting"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "currency"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }
    
    
    
    

    @IBAction func btnSelectCurrencyClicked(_ sender: Any) {
        
        //SET CURRENCY
        var arr_Data: [Any] = []
        for i in (0..<arrCurrencyData.count) {
            var dicData = NSDictionary()
            dicData = arrCurrencyData[i] as! NSDictionary
            arr_Data.append(dicData.object(forKey: "cur_code")!)
        }
        
        //SET PICKER VIEW
        let picker = ActionSheetStringPicker(title: "CURRENCY", rows: arr_Data, initialSelection:selectedIndex(arr: arr_Data as NSArray, value: txtCurrency.text! as String as NSString), doneBlock: { (picker, indexes, values) in
            if arr_Data.count != 0{
                self.txtCurrency.text = values as! String?
//                self.selectDefulatValueForColorSelection(color: self.lbl_Color.text!)
            }

        }, cancel: {ActionSheetStringPicker in return}, origin: sender)

        picker?.hideCancel = false
        // picker?.hideWithCancelAction()
        picker?.setDoneButton(UIBarButtonItem(title: "DONE", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black

        picker?.show()
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)select_currency"

        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid as! String,
            "currency" : txtCurrency.text!
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "currency_submit"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.startDownload()
    }
}


extension ChangeCurrencyViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {

        let response = data as! NSDictionary
        
        if strRequest == "currency" {

            //if response["status"] as? String == "OK"{
                //Get Main array
                let arr = response["currency"] as! NSArray
            arrCurrencyData = arr.mutableCopy() as! NSMutableArray

            print(arrCurrencyData)
           // }else{
//                messageBar.MessageShow(title: "Please enter valid zipcode or city name.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
   //         }
        }
        else if strRequest == "currency_submit"{
            
            //Save Data
            objUser?.str_Currency = txtCurrency.text as! NSString
            saveCustomObject(objUser!, key: "userobject");
            
            if str_IsLogin == "1"{

            //MOVE TO INVITE FRIEND SCREEN
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
            view.str_IsLogin = "1"
            self.navigationController?.pushViewController(view, animated: true)
            
                //Call API
//                manageTabBarandSideBar()
            }else{
                //BACK SCREEN
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func appDataDidFail(_ error: Error, request strRequest: String) {
        // self.completedServiceCalling()
    }

}


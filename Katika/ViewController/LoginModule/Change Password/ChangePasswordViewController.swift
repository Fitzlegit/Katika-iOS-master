//
//  ChangePasswordViewController.swift
//  Katika
//
//  Created by Katika_07 on 20/07/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages

class ChangePasswordViewController: UIViewController {

    //Declaration Textfield
    @IBOutlet var tf_OldPassword: UITextField!
    @IBOutlet var tf_NewPassword: UITextField!
    @IBOutlet var tf_confirmPassword: UITextField!
    //Declaration Button
    
    @IBOutlet var btn_ChangePassword: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    //MARK: - Touch Began -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.phase == .began {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: - Button Clicks -
    @IBAction func btn_Back(_ sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_ChangePassword(_ sender:Any){
        
        if (tf_OldPassword.text?.isEmpty)! && Constant.developerTest == false {
            
            messageBar.MessageShow(title: "Please enter old password", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else if (tf_OldPassword.text!.characters.count < 6) && Constant.developerTest == false {
            
            messageBar.MessageShow(title: "Old password must be of minimum 6 characters", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else if (tf_NewPassword.text?.isEmpty)! && Constant.developerTest == false {
            
            messageBar.MessageShow(title: "Please enter new password", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else if (tf_NewPassword.text!.characters.count < 6) && Constant.developerTest == false {
            
            messageBar.MessageShow(title: "New password must be of minimum 6 characters", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        } else if (tf_confirmPassword.text?.isEmpty)! && Constant.developerTest == false {
            
            messageBar.MessageShow(title: "Please enter confirm password", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else if (tf_confirmPassword.text!.characters.count < 6) && Constant.developerTest == false {
            
            messageBar.MessageShow(title: "Please enter confirm password atleast 6 characters", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else if tf_NewPassword.text! !=  tf_confirmPassword.text! {
            messageBar.MessageShow(title: "New password does not match with confirm password", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        } else {
            self.view.endEditing(true)
            
            self.Post_ChangePassword()
        }
    }
    
    // MARK: - Get/Post Method -
    func Post_ChangePassword(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)change_password"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "password_current" : tf_OldPassword.text ?? "",
            "password" : tf_NewPassword.text ?? "",
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "change_password"
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

extension ChangePasswordViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "change_password" {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        print(error)
    }
    
}


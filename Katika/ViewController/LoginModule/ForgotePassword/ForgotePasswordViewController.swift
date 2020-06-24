//
//  ForgotePasswordViewController.swift
//  Katika
//
//  Created by Katika on 26/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages

class ForgotePasswordViewController: UIViewController {

    //Other Declaration
    @IBOutlet weak var vw_Button: UIView!
    @IBOutlet weak var vw_SubView: UIView!
    @IBOutlet weak var vw_TextField: UIView!
    
    //Declaration TextFiled
    @IBOutlet weak var tf_Email: UITextField!
    
    //Declaration Variable
    var isValidEmail : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()
        
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
    
    // MARK: - Other Files -
    func commanMethod(){
        //Layer Set
        vw_TextField.layer.cornerRadius = 5.0
        vw_TextField.layer.borderWidth = 1.0
        vw_TextField.layer.borderColor = UIColor.init(colorLiteralRed: 231/256, green: 231/256, blue: 231/256, alpha: 1.0).cgColor
        vw_TextField.layer.masksToBounds = true
        
        vw_Button.layer.cornerRadius = 5.0
        vw_Button.layer.borderWidth = 1.0
        vw_Button.layer.borderColor = UIColor.init(colorLiteralRed: 246/256, green: 223/256, blue: 222/256, alpha: 1.0).cgColor
        vw_Button.layer.masksToBounds = true
        
        vw_SubView.layer.cornerRadius = 5.0
        vw_SubView.layer.masksToBounds = true
    }
    
    //MARK: - Button Event -
    @IBAction func btn_Back(_ sender:Any){
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_Cancel(_ sender:Any){
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_Reset(_ sender:Any){
        if((tf_Email.text?.isEmpty)! && Constant.developerTest == false){
            //Alert show for Header
            messageBar.MessageShow(title: "Please enter email address", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else if(isValidEmail ==  validateEmail(enteredEmail: tf_Email.text!) && Constant.developerTest == false){
            if isValidEmail == true {
                
            }else{
                //Alert show for Header
                messageBar.MessageShow(title: "Please enter valid email address", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }
        }else{
            self.view.endEditing(true)
            
            self.Post_ForgotePassword()
        }
    }
    
    
    // MARK: - Get/Post Method -
    func Post_ForgotePassword(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)forgot_password"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "email" : tf_Email.text ?? "",
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "forgot_password"
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


extension ForgotePasswordViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "forgot_password" {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        print(error)
    }
    
}



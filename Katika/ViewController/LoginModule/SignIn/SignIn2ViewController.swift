//
//  SignIn2ViewController.swift
//  Katika
//
//  Created by Katika on 26/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages

class SignIn2ViewController: UIViewController {

    //Constant set
    @IBOutlet var con_EmailTop : NSLayoutConstraint!
    
    //Declaration TextFiled
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    
    //Declaration Button
    @IBOutlet var btn_Login: UIButton!

    //Declaration Variable
    var keyboardToolbar = UIToolbar()
    var currentIndexForTextfield : NSInteger = 1
    var isValidEmail : Bool = false
    var strGusetUser : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Custome class keyboard handler method
    @objc func myKeyboardWillHideHandler(_ notification: NSNotification) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {

            //Set constant with screen size
            self.view .layoutIfNeeded()
        }, completion: nil)
    }
    @objc func myKeyboardWillShow(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
        
        self.view .layoutIfNeeded()
        if (currentIndexForTextfield == 1) {
            
            //Scrollview animation when keyboard open
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
                
                self.view .layoutIfNeeded()
            }, completion: nil)
            
        }else if (currentIndexForTextfield == 2) {
            
            //Scrollview animation when keyboard open
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
                
                self.view .layoutIfNeeded()
            }, completion: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.phase == .began {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    //MARK: - UITextField Delegates -
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentIndexForTextfield = textField.tag;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        return true;
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    
    
    // MARK: - Other Files -
    func commanMethod(){
        
        //Set constant with screen size
        con_EmailTop.constant = CGFloat(Int((Constant.windowHeight * 20)/Constant.screenHeightDeveloper))
        
        //Navigation Hidden
        self.navigationController? .setNavigationBarHidden(false, animated: true)
        
        //Notificaitno event with keyboard show and hide
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(myKeyboardWillHideHandler),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(myKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        //Set Keyboardtoollbar in keyboard
        keyboardToolbar = UIToolbar()
        keyboardToolbar.frame = CGRect(x: 0, y: 0, width: Constant.windowWidth, height: 44)
        setupInputAccessoryViews()
        tf_Email.inputAccessoryView  = keyboardToolbar
        tf_Password.inputAccessoryView  = keyboardToolbar
        
    }
    //MARK: -- InputAccessoryViews and keyboard handle methods --
    func setupInputAccessoryViews() {
        let preButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.init(rawValue: 101)!, target: nil, action: #selector(goToPrevField))
        let flexSpace2: UIBarButtonItem  = UIBarButtonItem(title: "  ", style: UIBarButtonItem.Style.done, target: self, action: nil)
        let nextButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.init(rawValue: 102)!, target: nil, action: #selector(goToNextField))
        
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        let flexSpace  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        var items = [UIBarButtonItem]()
        items.append(preButton)
        items.append(flexSpace2)
        items.append(nextButton)
        items.append(flexSpace)
        items.append(done)
        keyboardToolbar.items = items
        keyboardToolbar.sizeToFit()
    }
    //Previews Button click on keyboard
    @objc func goToPrevField(){
        if (currentIndexForTextfield == 2) {
            tf_Email .becomeFirstResponder()
        }else {
            self.view.endEditing(true)
        }
    }
    //Next Button click on keyboard
    @objc func goToNextField(){
        if (currentIndexForTextfield == 1) {
            tf_Password .becomeFirstResponder()
        }else {
            self.view.endEditing(true)
        }
    }
    //Done Button
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Login(_ sender: Any) {
        if((tf_Email.text?.isEmpty)! && Constant.developerTest == false){
            //Alert show for Header
            messageBar.MessageShow(title: "Please enter email address", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else if(isValidEmail ==  validateEmail(enteredEmail: tf_Email.text!) && Constant.developerTest == false){
            if isValidEmail == true {
                
            }else{
                //Alert show for Header
                messageBar.MessageShow(title: "Please enter valid email address", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }
        }else if((tf_Password.text?.isEmpty)! && Constant.developerTest == false){
            messageBar.MessageShow(title: "Please enter password", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else if (tf_Password.text!.characters.count < 6) && Constant.developerTest == false {
            messageBar.MessageShow(title: "Password must be of minimum 6 characters", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else{
            self.view.endEditing(true)
            
            self.Post_Login()
        }
    }
    @IBAction func btn_ForgotePassword(_ sender: Any) {
    }
    

    // MARK: - Get/Post Method -
    func Post_Login(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)login"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "email" : tf_Email.text ?? "",
            "password" : tf_Password.text ?? "",
            "devicetoken" :  UserDefaults.standard.value(forKey: "DeviceToken") == nil ? "123" : UserDefaults.standard.value(forKey: "DeviceToken")! as! String,
            "devicetype" : "I",
            "latitude" : String(format:"%.5f", (currentLocation?.coordinate.latitude)!),
            "longitude" : String(format:"%.5f", (currentLocation?.coordinate.longitude)!),
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "login"
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


extension SignIn2ViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "login" {
            
            UserDefaults.standard.set("", forKey: "HomeTutorial")
            
            let dict_result = response["user_details"] as! NSDictionary
            let dict_RewardPoint = dict_result["reward"] as! NSDictionary
            
            //Store data in object
            let obj = UserDataObject(str_FirstName: dict_result["firstname"] as! String as NSString,
                                     str_LastName: dict_result["lastname"]  as! String as NSString,
                                     str_Userid: String(dict_result["userid"] as! Int) as NSString,
                                     str_Profile_Image: dict_result["profile_image"] as! String as NSString,
                                     str_Email: dict_result["email"] as! String as NSString,
                                     str_Zipcode: dict_result["zipcode"] as! String as NSString,
                                     str_Lat: dict_result["user_lat"] as! String as NSString,
                                     str_Long: dict_result["user_long"] as! String as NSString,
                                     str_Address: dict_result["address"] as! String as NSString,
                                     str_RegistrationDate:dict_result["registration_date"] as! String as NSString,
                                     str_CardCount:String(dict_result["total_cart_item"] as! Int) as NSString,
                                     str_CheckoutTocken:dict_result["customerid"] as! String as NSString,
                                     str_RewardPoint:String(dict_result["reward_points"] as! String) as NSString,
                                     str_Quickbox: dict_result["quickblox_id"] as! String as NSString,
                                     str_RewardBronze: String(dict_RewardPoint["Bronze"] as! Int) as NSString,
                                     str_RewardGolf: String(dict_RewardPoint["Gold"] as! Int) as NSString,
                                     str_RewardSilver: String(dict_RewardPoint["Silver"] as! Int) as NSString,
                                     str_RewardDiamond: String(dict_RewardPoint["Diamond"] as! Int) as NSString,
                                     str_Currency: dict_result["select_currency"] as! String as NSString,
                                     str_LoginType: "user",
                                     str_User_Role: String(dict_result["user_role"] as! Int) as NSString)
            saveCustomObject(obj, key: "userobject");
            
            //Save Object In global variable
            objUser = obj
            
            //Call Quick Box logIn
            loginWithQuickBox(str_Username :  dict_result["email"] as! String)
            
            if strGusetUser == "1"{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                //Call API
                manageTabBarandSideBar()
            }
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        print(error)
    }
    
}



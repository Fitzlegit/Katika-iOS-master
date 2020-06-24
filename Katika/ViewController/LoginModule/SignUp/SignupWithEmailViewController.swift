//
//  SignupWithEmailViewController.swift
//  Katika
//
//  Created by KatikaRaju on 5/26/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages

class SignupWithEmailViewController: UIViewController,DismissViewDelegate,UINavigationControllerDelegate {
    //IBOutlets
    //Declaration Textfield
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastGame: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtZipCode: UITextField!
    
    //Declaration Button
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    
    //Declaration Label
    @IBOutlet var lblAgreement: UILabel!
    
    //IMage 
    @IBOutlet var img_Profile: UIImage!
    
    //Declaration Variable
    var currentIndexForTextfield : NSInteger = 0
    var keyboardToolbar = UIToolbar()
    var isImage :Bool = false
    let picker = UIImagePickerController()
    var str_Type : String = ""
    var strGusetUser : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
          self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         commanMethod()
    }
    override func viewDidLayoutSubviews() {
        if isImage {
            btnProfile.layer.cornerRadius = btnProfile.frame.width/2
            btnProfile.layer.masksToBounds = true
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - UITextField Delegates -
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         currentIndexForTextfield = textField.tag;
        return true
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        view.endEditing(true)
        return true;
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if txtZipCode == textField {
            let text = textField.text
            if (text?.characters.count)! > 10 {
                return false
            }
        }
        return true

    }
  
    
    //MARK: - Touch Began -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.phase == .began {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    
    //MARK: - Other Files -
    func commanMethod() {
        
        btnProfile.layoutIfNeeded()

        // Imagepicker Setup 
         picker.delegate = self
        //Set Keyboardtoollbar in keyboard
        keyboardToolbar = UIToolbar()
        keyboardToolbar.frame = CGRect(x: 0, y: 0, width: Constant.windowWidth, height: 44)
 
         setupInputAccessoryViews()
        
        txtFirstName.inputAccessoryView  = keyboardToolbar
        txtLastGame.inputAccessoryView  = keyboardToolbar
        txtEmail.inputAccessoryView  = keyboardToolbar
        txtPassword.inputAccessoryView  = keyboardToolbar
        txtZipCode.inputAccessoryView  = keyboardToolbar
        
    }
    func photoOption(info: NSInteger) {
        if info == 1 {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                
                picker.sourceType = .camera
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }
        } else {
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
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
    @objc func goToPrevField() {
        if currentIndexForTextfield==1 {
            view.endEditing(true)
        }
        else {
            currentIndexForTextfield = currentIndexForTextfield-1;
        let prevTextField = self.view .viewWithTag(currentIndexForTextfield) as! UITextField
            prevTextField .becomeFirstResponder()
        }

    }
    //Next Button click on keyboard
    @objc func goToNextField(){
        if currentIndexForTextfield==5 {
            view.endEditing(true)
        }
        else {
            currentIndexForTextfield = currentIndexForTextfield+1;
            let nextTextField = self.view .viewWithTag(currentIndexForTextfield) as! UITextField
            nextTextField .becomeFirstResponder()
        }

    }
    //Done Button
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    
    //MARK: - Button Clicks -
    @IBAction func btn_Back(_ sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signUpClick(_ sender: Any) {
        
        if (txtFirstName.text?.isEmpty)! && Constant.developerTest == false {
            messageBar.MessageShow(title: "Please enter first name", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        } else if (txtLastGame.text?.isEmpty)! && Constant.developerTest == false {
            messageBar.MessageShow(title: "Please enter last name", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        } else if (txtEmail.text?.isEmpty)! && Constant.developerTest == false {
            messageBar.MessageShow(title: "Please enter email address", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        } else if !validateEmail(enteredEmail: txtEmail.text!) && Constant.developerTest == false {
            
            messageBar.MessageShow(title: "Please enter valid email address", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        } else if (txtPassword.text?.isEmpty)! && Constant.developerTest == false {
            messageBar.MessageShow(title: "Please enter password", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else if (txtPassword.text!.characters.count < 6) && Constant.developerTest == false {
            messageBar.MessageShow(title: "Password must be of minimum 6 characters", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        } else if (txtZipCode.text?.isEmpty)! && Constant.developerTest == false {
            messageBar.MessageShow(title: "Please enter zipcode", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }
//        else if (txtZipCode.text!.characters.count < 5) && Constant.developerTest == false {
//            messageBar.MessageShow(title: "Please enter zipcode altest 5 characters", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
//        }
        else {
            self.view.endEditing(true)
            
            self.Get_SearchCategory()
        }
    }
    @IBAction func profileChangeClick(_ sender: Any) {
        self .performSegue(withIdentifier: "segueSelectAvtar", sender: nil)
    }
    @IBAction func btn_TermOfUser(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "UrlLoadViewController") as! UrlLoadViewController
        view.str_URL = "http://13.59.254.172/katika/app_info/terms-ios.html"
        view.title_View = "Terms Of Use"
        self.navigationController?.pushViewController(view, animated: true)
    }
    @IBAction func btn_Privacy(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "UrlLoadViewController") as! UrlLoadViewController
        view.str_URL = "http://13.59.254.172/katika/app_info/privacy.html"
        view.title_View = "Privacy Policy"
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    // MARK: - Get/Post Method -
    func Post_Registration(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)registration"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "email" : txtEmail.text ?? "",
            "password" : txtPassword.text ?? "",
            "firstname" : txtFirstName.text ?? "",
            "lastname" : txtLastGame.text ?? "",
            "zipcode" : txtZipCode.text ?? "",
            "latitude" : String(format:"%.5f", (currentLocation?.coordinate.latitude)!),
            "longitude" : String(format:"%.5f", (currentLocation?.coordinate.longitude)!),
            "address" : currentCityName,
            "devicetoken" :  UserDefaults.standard.value(forKey: "DeviceToken") == nil ? "123" : UserDefaults.standard.value(forKey: "DeviceToken")! as! String,
            "devicetype" : "I",
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "registration"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.imageUpload = (isImage == true) ? (img_Profile) : (UIImage())
        webHelper.imageUploadName = "profile_image"
        webHelper.startDownloadWithImage()
    }
    func Get_RegistrationQuickBoxUser(str_QuickBoxID : String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)update_quickbloxid"
        
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid as! String,
            "quickbloxid" : str_QuickBoxID,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "update_quickbloxid"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    func loginWithQuickBoxwithRegistration(){
        
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            SVProgressHUD.show(withStatus: "Connecting to Chat".localized, maskType: SVProgressHUDMaskType.clear)
        
            let str_Value : String = "\(objUser?.str_Email as! String)"
            QBRequest.logIn(withUserLogin: objUser?.str_Email as! String, password: "katika123", successBlock: {(_ response: QBResponse, _ user: QBUUser!) -> Void in
                // Registion user because of first Time
                self.Get_RegistrationQuickBoxUser(str_QuickBoxID : String(user.id))
                
                //Save quickbox object
                objUser?.str_Quickbox = String(user.id) as NSString
                saveCustomObject(objUser!, key: "userobject");

                
                //Login with QBChat room
                let user1 = QBUUser()
                user1.id = UInt(user.id)
                user1.password = "katika123"
                
                QBChat.instance().connect(with: user1, completion: {(_ error: Error?) -> Void in
                    print("Error: \(String(describing: error))")
                    
                    if error == nil{
                        if QBChat.instance().isConnected {
                            print("QuickBox : login succssfully")
                            SVProgressHUD.dismiss()
                        }
                        else {
                            print("QuickBox : login fail")
                            SVProgressHUD.dismiss()
                        }
                        
                    }
                })
            }, errorBlock: {(_ response: QBResponse) -> Void in
                print("QuickBox : login fail")
                SVProgressHUD.dismiss()
            })
        }
        
    }
    
    // MARK: - Get/Post Method -
    func Get_SearchCategory(){
        
        //Declaration URL
        let strURL = "https://maps.googleapis.com/maps/api/geocode/json?address=\(txtZipCode.text!)&sensor=true&key=AIzaSyDoUrlHgb3VyzhuoDIljfmgP3EuU5p0ZlQ"

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
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueSelectAvtar" {
            let  popUpView  = segue.destination as! SelectAvtarPopupViewController
            popUpView.delegate = self
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}



extension SignupWithEmailViewController : UIImagePickerControllerDelegate{
    //MARK: - Imagepicker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        let chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage //2
        isImage = true
        btnProfile .setImage(chosenImage, for: .normal)
        img_Profile = chosenImage
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension SignupWithEmailViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "registration" {

//            let dict_result = response["user_details"] as! NSDictionary
//            let dict_RewardPoint = dict_result["reward"] as! NSDictionary
//
//            //Store data in object
//            let obj = UserDataObject(str_FirstName: dict_result["firstname"] as! String as NSString,
//                                     str_LastName: dict_result["lastname"]  as! String as NSString,
//                                     str_Userid: String(dict_result["userid"] as! Int) as NSString,
//                                     str_Profile_Image: dict_result["profile_image"] as! String as NSString,
//                                     str_Email: dict_result["email"] as! String as NSString,
//                                     str_Zipcode: dict_result["zipcode"] as! String as NSString,
//                                     str_Lat: dict_result["user_lat"] as! String as NSString,
//                                     str_Long: dict_result["user_long"] as! String as NSString,
//                                     str_Address: dict_result["address"] as! String as NSString,
//                                     str_RegistrationDate: dict_result["registration_date"] as! String as NSString,
//                                    str_CardCount:String(dict_result["total_cart_item"] as! Int) as NSString,
//                                    str_CheckoutTocken:"",
//                                    str_RewardPoint: dict_result["reward_points"] as! String as NSString,
//                                    str_Quickbox: "",
//                                    str_RewardBronze: String(dict_RewardPoint["Bronze"] as! Int) as NSString,
//                                    str_RewardGolf: String(dict_RewardPoint["Gold"] as! Int) as NSString,
//                                    str_RewardSilver: String(dict_RewardPoint["Silver"] as! Int) as NSString,
//                                    str_RewardDiamond: String(dict_RewardPoint["Diamond"] as! Int) as NSString,
//                                    str_Currency: dict_result["select_currency"] as! String as NSString,
//                                    str_LoginType: "user",
//                                    str_User_Role: String(dict_result["user_role"] as! Int) as NSString)
//
//            saveCustomObject(obj, key: "userobject");

            //Save Object In global variable
//            objUser = obj
            
            UserDefaults.standard.set(nil, forKey: "HomeTutorial")

            //Registration quickBox user
            RegistrationWithQuickBox(str_UserName : txtEmail.text ?? "" , str_Login : txtEmail.text ?? "")

            if strGusetUser == "1"{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                //Call API
                self.navigationController?.popViewController(animated: true)
//                manageTabBarandSideBar()
            }

            
//            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.loginWithQuickBoxwithRegistration), userInfo: nil, repeats: false)
            
        }
        else if strRequest == "update_quickbloxid" {
            
            if strGusetUser == "1"{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "ChangeCurrencyViewController") as! ChangeCurrencyViewController
                view.str_IsLogin = "1"
                self.navigationController?.pushViewController(view, animated: true)
            }
        }
        else if strRequest == "google" {
            
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
                        currentCityName = dict_Sub_Address["short_name"] as! String as NSString
                        bool_Match = true
                        break
                    }else  if arr_Sub_Address_Type.contains("administrative_area_level_2") {
                        currentCityName = dict_Sub_Address["short_name"] as! String as NSString
                        bool_Match = true
                        break
                    }else  if arr_Sub_Address_Type.contains("administrative_area_level_1") {
                        currentCityName = dict_Sub_Address["short_name"] as! String as NSString
                        bool_Match = true
                        break
                    }
                }
            }
            self.Post_Registration()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        print(error)
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

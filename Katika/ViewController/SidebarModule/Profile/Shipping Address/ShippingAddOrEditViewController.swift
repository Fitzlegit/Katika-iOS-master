//
//  ShippingAddOrEditViewController.swift
//  Katika
//
//  Created by Katika on 22/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages
import IQKeyboardManagerSwift
import ActionSheetPicker_3_0


class ShippingAddOrEditViewController: UIViewController {

    //Other Declaration
    @IBOutlet var tbl_Main : UITableView!
    
    @IBOutlet weak var lblSelectCountry: UILabel!
    @IBOutlet weak var imgDown: UIImageView!
    //Constant set
    @IBOutlet var con_TopHeader : NSLayoutConstraint!
    
    //Declaration TextFiled
    @IBOutlet weak var tf_FirstNameLastName: UITextField!
    @IBOutlet weak var tf_PhoneNumber: UITextField!
    @IBOutlet weak var tf_AddressShippingAddress1: UITextField!
    @IBOutlet weak var tf_AddressShippingAddress2: UITextField!
    @IBOutlet weak var tf_Zip: UITextField!
    @IBOutlet weak var tf_City: UITextField!
    @IBOutlet weak var tf_State: UITextField!
    
    @IBOutlet var swift_PrimaryAddress : UISwitch!
    
    @IBOutlet var btn_Delete : UIBarButtonItem!
    
    @IBOutlet weak var btnSelectCountry: UIButton!
    //Declaration Variable
    var keyboardToolbar = UIToolbar()
    var currentIndexForTextfield : NSInteger = 1
    var isValidEmail : Bool = false
    var isEditData : Bool = false
    var isSelctCountry : Bool = false

    var obj_Get = ShippingAddressObject()
    var arrContryList : NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let templateImage = imgDown.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imgDown.image = templateImage
        imgDown.tintColor = UIColor.blue
        
        //GET COUNTRY LIST
        self.Get_ContryListing()
        
        //SET DATA
        self.commanMethod()
        self.setTextField()

        //Text editing manager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldShowTextFieldPlaceholder = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20.0
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Text editing manager
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Scrollview Delegate -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tbl_Main == scrollView {
//            self.view.endEditing(true)
        }
    }
    
    
    
    // MARK: - Get/Post Method -
    func Get_ContryListing(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_country"
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_country"
        webHelper.methodType = "get"
        webHelper.strURL = strURL
        webHelper.dictType = NSDictionary()
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.phase == .began {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    
    //MARK: - OTher Files -
    func setTextField()  {
        //SET TEXT
        if isSelctCountry {
            tf_FirstNameLastName.isEnabled = true
            tf_PhoneNumber.isEnabled = true
            tf_AddressShippingAddress1.isEnabled = true
            tf_AddressShippingAddress2.isEnabled = true
            tf_Zip.isEnabled = true
            tf_City.isEnabled = true
            tf_State.isEnabled = true
        }
        else{
            tf_FirstNameLastName.isEnabled = false
            tf_PhoneNumber.isEnabled = false
            tf_AddressShippingAddress1.isEnabled = false
            tf_AddressShippingAddress2.isEnabled = false
            tf_Zip.isEnabled = false
            tf_City.isEnabled = false
            tf_State.isEnabled = false
        }
    }
    func commanMethod(){
     
        //Textfiled placehodler color set
        tf_FirstNameLastName.attributedPlaceholder = NSAttributedString(string: "First and Last name",
                                                            attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))
        tf_PhoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone number",
                                                                  attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))

        tf_AddressShippingAddress1.attributedPlaceholder = NSAttributedString(string: "Address 1",
                                                                              attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))

        tf_AddressShippingAddress2.attributedPlaceholder = NSAttributedString(string: "Address 2",
                                                                              attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))

        tf_Zip.attributedPlaceholder = NSAttributedString(string: "Postal code",
                                                          attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))

        tf_City.attributedPlaceholder = NSAttributedString(string: "City",
                                                           attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))

        
        if lblSelectCountry.text! as String == "South Africa" || lblSelectCountry.text! as String == "Canada" {
            tf_State.attributedPlaceholder = NSAttributedString(string: "Province",
                                                                attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))


        }else if lblSelectCountry.text! as String == "UK"{
            
            tf_State.attributedPlaceholder = NSAttributedString(string: "County",
                                                                attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))
        }
        else{
            tf_State.attributedPlaceholder = NSAttributedString(string: "State",
                                                                attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.lightGray]))

        }
        
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
        tf_FirstNameLastName.inputAccessoryView  = keyboardToolbar
        tf_PhoneNumber.inputAccessoryView  = keyboardToolbar
        tf_AddressShippingAddress1.inputAccessoryView  = keyboardToolbar
        tf_AddressShippingAddress2.inputAccessoryView  = keyboardToolbar
        tf_City.inputAccessoryView  = keyboardToolbar
        tf_State.inputAccessoryView  = keyboardToolbar
        tf_Zip.inputAccessoryView  = keyboardToolbar

        
        //if get edit than fill detail
        if self.isEditData == true{
            
            tf_FirstNameLastName.text = obj_Get.str_Title as String
            tf_PhoneNumber.text = obj_Get.str_PhoneNumber as String
            tf_AddressShippingAddress1.text = obj_Get.str_Address as String
            tf_AddressShippingAddress2.text = obj_Get.str_Address2 as String
            tf_Zip.text = obj_Get.str_Zip as String
            tf_City.text = obj_Get.str_City as String
            tf_State.text = obj_Get.str_State as String
            
            if obj_Get.str_Country as String? == ""{
                isSelctCountry = false
            }
            else{
                isSelctCountry = true
                lblSelectCountry.text = obj_Get.str_Country as String?
//                btnSelectCountry.setTitle(obj_Get.str_Country as String?, for: .normal)
            }
            self.setTextField()
            lblSelectCountry.text = obj_Get.str_Country as String?
//            btnSelectCountry.setTitle(obj_Get.str_Country as String?, for: .normal)

            if obj_Get.str_SeletecedAddress == "1" {
                swift_PrimaryAddress.isOn = true
            }else{
                swift_PrimaryAddress.isOn = false
            }
            
        }else{
            btn_Delete.isEnabled = false
            btn_Delete.tintColor = UIColor.clear

        }
    }

    //MARK: -- Custome class keyboard handler method --
    @objc func myKeyboardWillHideHandler(_ notification: NSNotification) {
        tbl_Main.setContentOffset(CGPoint.zero, animated: true)
//        view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
//            self.con_TopHeader.constant = 0
//            self.view .layoutIfNeeded()
//        }, completion: nil)
    }
    @objc func myKeyboardWillShow(_ notification: NSNotification) {
//        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
//
//        tbl_Main.setContentOffset(CGPoint.zero, animated: true)
//
//        self.view .layoutIfNeeded()
//        if (currentIndexForTextfield > 0) {
//            print(Constant.screenHeightDeveloper)
//            print(keyboardHeight)
//            print((self.currentIndexForTextfield * 50))
//
//            //Scrollview animation when keyboard open
//            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
//                self.con_TopHeader.constant =  CGFloat(Constant.screenHeightDeveloper) - keyboardHeight - 95 - CGFloat((self.currentIndexForTextfield * 49))
//                self.view .layoutIfNeeded()
//            }, completion: nil)
//
//        }
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
            tf_FirstNameLastName .becomeFirstResponder()
        }else if (currentIndexForTextfield == 3) {
            tf_PhoneNumber .becomeFirstResponder()
        }else if (currentIndexForTextfield == 4) {
            tf_AddressShippingAddress1 .becomeFirstResponder()
        }else if (currentIndexForTextfield == 5) {
            tf_AddressShippingAddress2 .becomeFirstResponder()
        }else if (currentIndexForTextfield == 6) {
            tf_City .becomeFirstResponder()
        }else if (currentIndexForTextfield == 7) {
            tf_State .becomeFirstResponder()

        }else {
            self.view.endEditing(true)
        }
    }
    //Next Button click on keyboard
    @objc func goToNextField(){
        if (currentIndexForTextfield == 1) {
            tf_PhoneNumber .becomeFirstResponder()
        }else if (currentIndexForTextfield == 2) {
            tf_AddressShippingAddress1 .becomeFirstResponder()
        }else if (currentIndexForTextfield == 3) {
            tf_AddressShippingAddress2 .becomeFirstResponder()
        }else if (currentIndexForTextfield == 4) {
            tf_City .becomeFirstResponder()
        }else if (currentIndexForTextfield == 5) {
            tf_State .becomeFirstResponder()
        }else if (currentIndexForTextfield == 6) {
            tf_Zip .becomeFirstResponder()
        }else {
            self.view.endEditing(true)
        }
    }
    //Done Button
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }

    
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Delete(_ sender : Any){
        self.Post_DeleteShippingAddress(id:obj_Get.str_Id as String)
    }
    @IBAction func btnSelectCountryClicked(_ sender: Any) {
        
        
        //SET CURRENCY
        var arr_Data: [Any] = []
        for i in (0..<arrContryList.count) {
            var dicData = NSDictionary()
            dicData = arrContryList[i] as! NSDictionary
            arr_Data.append(dicData.object(forKey: "country_name")!)
        }
        
        //SET PICKER VIEW
        let picker = ActionSheetStringPicker(title: "COUNTRY", rows: arr_Data, initialSelection:selectedIndex(arr: arr_Data as NSArray, value: lblSelectCountry.text! as String as NSString), doneBlock: { (picker, indexes, values) in
            if arr_Data.count != 0{
                
                //SET VALUE
                self.isSelctCountry = true
                self.lblSelectCountry.text = values as? String

//                self.btnSelectCountry.setTitle(values as! String?, for: .normal)
                self.setTextField()
                self.commanMethod()
            }
            
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
        picker?.hideCancel = false
        // picker?.hideWithCancelAction()
        picker?.setDoneButton(UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
    }
    @IBAction func btn_Save(_ sender : Any){
        if !isSelctCountry{
            //Alert show for Header
            messageBar.MessageShow(title: "Please select country first", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }
        else if((tf_FirstNameLastName.text?.isEmpty)! && Constant.developerTest == false){
            //Alert show for Header
            messageBar.MessageShow(title: "Please enter first and last name", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else if((tf_PhoneNumber.text?.isEmpty)! && Constant.developerTest == false){
            //Alert show for Header
            messageBar.MessageShow(title: "Please enter phone number", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else if (tf_PhoneNumber.text!.characters.count < 10) && Constant.developerTest == false {
            
            messageBar.MessageShow(title: "Please enter valid phone number", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else if((tf_AddressShippingAddress1.text?.isEmpty)! && Constant.developerTest == false){
            //Alert show for Header
            messageBar.MessageShow(title: "Please enter address 1", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }

        else if((tf_Zip.text?.isEmpty)! && Constant.developerTest == false){
            //Alert show for Header
            messageBar.MessageShow(title: "Please enter zip", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else if (tf_Zip.text!.characters.count < 1) && Constant.developerTest == false {
            
            messageBar.MessageShow(title: "Please enter zipcode minimum 1 characters", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else if((tf_City.text?.isEmpty)! && Constant.developerTest == false){
            //Alert show for Header
            messageBar.MessageShow(title: "Please enter city", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else if((tf_State.text?.isEmpty)! && Constant.developerTest == false){
            //Alert show for Header
            messageBar.MessageShow(title: "Please enter state", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else{
            self.view.endEditing(true)
            
            
            //Edit or add shipping condition
            if self.isEditData == true{
                self.Post_EditShippingAddress()
            }else{
                self.Post_AddShippingAddress()
            }
        }
    }
    
    
    // MARK: - Tableview -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath as IndexPath) as! ShippingAddressViewControllerCell
      
        return cell
    }
    
    
    // MARK: - Get/Post Method -
    func Post_AddShippingAddress(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)add_shipping_address"
        
        //Pass data in dictionary
        let jsonData: NSMutableDictionary = NSMutableDictionary()
        
        jsonData["user_id"] = objUser?.str_Userid as String? ?? ""
        jsonData["name"] = tf_FirstNameLastName.text ?? ""
        jsonData["phone"] = tf_PhoneNumber.text ?? ""
        jsonData["city"] = tf_City.text ?? ""
        jsonData["country"] = lblSelectCountry.text! as String
        jsonData["state"] = tf_State.text ?? ""
        jsonData["zip"] = tf_Zip.text ?? ""
        jsonData["address1"] = tf_AddressShippingAddress1.text ?? ""
        jsonData["address2"] = tf_AddressShippingAddress2.text ?? ""
        jsonData["isprimary_address"] = (swift_PrimaryAddress.isOn) ? "1" : "0"
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "add_shipping_address"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.startDownload()
    }
    
    func Post_EditShippingAddress(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)update_shipping_address"
        
        //Pass data in dictionary
        let jsonData: NSMutableDictionary = NSMutableDictionary()
        
        jsonData["id"] = obj_Get.str_Id
        jsonData["user_id"] = objUser?.str_Userid as String? ?? ""
        jsonData["name"] = tf_FirstNameLastName.text ?? ""
        jsonData["phone"] = tf_PhoneNumber.text ?? ""
        jsonData["city"] = tf_City.text ?? ""
        jsonData["country"] = lblSelectCountry.text! as String
        jsonData["state"] = tf_State.text ?? ""
        jsonData["zip"] = tf_Zip.text ?? ""
        jsonData["address1"] = tf_AddressShippingAddress1.text ?? ""
        jsonData["address2"] = tf_AddressShippingAddress2.text ?? ""
        jsonData["isprimary_address"] = (swift_PrimaryAddress.isOn) ? "1" : "0"
        

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


extension ShippingAddOrEditViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        
        let response = data as! NSDictionary
        if strRequest == "add_shipping_address" || strRequest == "update_shipping_address"{
            
            //            messageBar.MessageShow(title: "Shipping address saved successfully", alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
            self.navigationController?.popViewController(animated: true)
        }else if strRequest == "remove_shipping_address"{
            self.navigationController?.popViewController(animated: true)
        }
        else if strRequest == "get_country"{
            
            //GET COUNTRY LIST
            let arr = response["Result"] as! NSArray
            arrContryList = arr.mutableCopy() as! NSMutableArray
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

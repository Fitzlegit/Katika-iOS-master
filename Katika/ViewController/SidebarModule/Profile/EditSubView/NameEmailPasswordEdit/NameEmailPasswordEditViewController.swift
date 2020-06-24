//
//  NameEmailPasswordEditViewController.swift
//  Katika
//
//  Created by Katika on 19/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages

class NameEmailPasswordEditViewController: UIViewController {

    //View Declaration
    @IBOutlet var vw_Preview : UIView!
    @IBOutlet var vw_Edit : UIView!
    
    //Declaration TextFiled
    @IBOutlet weak var tf_Name: UITextField!
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    
    //Declaration Lael
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_Password: UILabel!
    
    //Declaration Variable
    var keyboardToolbar = UIToolbar()
    var currentIndexForTextfield : NSInteger = 1
    var isValidEmail : Bool = false
    
    //Button Declaration
    @IBOutlet var btn_Save : UIButton!
    @IBOutlet var btn_Edit: UIBarButtonItem!
    @IBOutlet var btn_ChangePassword: UIButton!
    
    //Constant
    @IBOutlet var con_ImageHeight : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.commanMethod()
        self.setupInputAccessoryViews()
        
        if objUser?.str_LoginType as! String != "user" {
           con_ImageHeight.constant = 67
           btn_ChangePassword.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK: - Custome class keyboard handler method -
    @objc func myKeyboardWillHideHandler(_ notification: NSNotification) {
        
    }
    @objc func myKeyboardWillShow(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.phase == .began {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }

    
    //MARK: - Other Files -
    func commanMethod(){
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
        tf_Name.inputAccessoryView  = keyboardToolbar
        tf_Email.inputAccessoryView  = keyboardToolbar
        tf_Password.inputAccessoryView  = keyboardToolbar
        
        //Set data for user
        lbl_Name.text = "\(objUser?.str_FirstName as! String) \(objUser?.str_LastName as! String)"
        lbl_Email.text = objUser?.str_Email as! String as String
        lbl_Password.text = "*******"
        
        tf_Name.text = "\(objUser?.str_FirstName as! String) \(objUser?.str_LastName as! String)"
        tf_Email.text = objUser?.str_Email as! String
        tf_Password.text = "123123"
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
            tf_Name .becomeFirstResponder()
        }else if (currentIndexForTextfield == 3) {
            tf_Email .becomeFirstResponder()
        }else {
            self.view.endEditing(true)
        }
    }
    //Next Button click on keyboard
    @objc func goToNextField(){
        if (currentIndexForTextfield == 1) {
            tf_Email .becomeFirstResponder()
        }else if (currentIndexForTextfield == 2) {
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
    @IBAction func btn_Back(_ sender : Any){
        if vw_Edit.isHidden == false{
            vw_Preview.isHidden = false
            vw_Edit.isHidden = true
            btn_Save.isHidden = true
            btn_Edit.title = "Edit"
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func btn_Edit(_ sender : Any){
        vw_Preview.isHidden = true
        vw_Edit.isHidden = false
        btn_Save.isHidden = false
        btn_Edit.title = ""
    }
    @IBAction func btn_Save (_ sender : Any){
        if((tf_Name.text?.isEmpty)! && Constant.developerTest == false){
            //Alert show for Header
            messageBar.MessageShow(title: "Please enter name", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else if((tf_Email.text?.isEmpty)! && Constant.developerTest == false){
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
        }else{
            self.view.endEditing(true)
            
            //View Hidden
            vw_Preview.isHidden = false
            vw_Edit.isHidden = true
            btn_Save.isHidden = true
            btn_Edit.title = "Edit"
            
            messageBar.MessageShow(title: "Profile saved successfully", alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
        }
        
    }
    @IBAction func btn_ChangePassword (_ sender : Any){
        if objUser?.str_LoginType as! String == "user" {
            self .performSegue(withIdentifier: "changepassword", sender: self)
        }
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

//
//  SignInViewController.swift
//  Katika
//
//  Created by Katika on 17/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages

class SignInViewController: UIViewController,UITextFieldDelegate {

    
    //Constant set
    @IBOutlet var con_TopView : NSLayoutConstraint!
    @IBOutlet var con_EmailTop : NSLayoutConstraint!
    @IBOutlet var con_EmailLeft : NSLayoutConstraint!
    @IBOutlet var con_EmailRight : NSLayoutConstraint!
    @IBOutlet var con_ForgoteRight : NSLayoutConstraint!
    @IBOutlet var con_NewUserLeft : NSLayoutConstraint!
    @IBOutlet var con_BottomView_Bottom : NSLayoutConstraint!
    
    //Declaration TextFiled
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    
    //Declaration Button
    @IBOutlet var btn_SignIn: UIButton!
    @IBOutlet var btn_SignUp: UIButton!
    
    //Declaration Label
    @IBOutlet var lbl_ForgotePassword: UILabel!
    @IBOutlet var lbl_NewUser: UILabel!
    
    //Declaration Variable
    var keyboardToolbar = UIToolbar()
    var currentIndexForTextfield : NSInteger = 1
    var isValidEmail : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //Calling methods
        self.commanMethod()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Custome class keyboard handler method
    @objc func myKeyboardWillHideHandler(_ notification: NSNotification) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
            self.con_TopView.constant = 0
            self.view .layoutIfNeeded()
        }, completion: nil)
    }
    @objc func myKeyboardWillShow(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        self.view .layoutIfNeeded()
        if (currentIndexForTextfield == 1) {
            
            //Scrollview animation when keyboard open
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
                self.con_TopView.constant =  CGFloat(Int((Constant.windowHeight * 325)/Constant.screenHeightDeveloper)) - keyboardHeight
                self.view .layoutIfNeeded()
            }, completion: nil)
            
        }else if (currentIndexForTextfield == 2) {
            
            //Scrollview animation when keyboard open
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
                self.con_TopView.constant = CGFloat(Int((Constant.windowHeight * 254)/Constant.screenHeightDeveloper)) - keyboardHeight
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
        //Navigation Hidden
        self.navigationController? .setNavigationBarHidden(false, animated: true)
        
        //Set constant with screen size
        con_EmailTop.constant = CGFloat(Int((Constant.windowHeight * 20)/Constant.screenHeightDeveloper))
        con_EmailLeft.constant = CGFloat(Int((Constant.windowWidth * 50)/Constant.screenWidthDeveloper))
        con_EmailRight.constant = CGFloat(Int((Constant.windowWidth * 50)/Constant.screenWidthDeveloper))
        con_NewUserLeft.constant = CGFloat(Int((Constant.windowWidth * 50)/Constant.screenWidthDeveloper))
        con_ForgoteRight.constant = CGFloat(Int((Constant.windowWidth * 50)/Constant.screenWidthDeveloper))
        con_BottomView_Bottom.constant = CGFloat(Int((Constant.windowHeight * 20)/Constant.screenWidthDeveloper))
        
        //Font manage
//        manageFont(
        
        //Textfiled placehodler color set
        tf_Email.attributedPlaceholder = NSAttributedString(string: "E - Mail address",
                                                               attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.init(colorLiteralRed: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1.0)]))
        tf_Password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.init(colorLiteralRed: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1.0)]))
        
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
    @IBAction func btn_SignIn(_ sender: Any) {
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
        }else{
            self.view.endEditing(true)
            
            
            //Alert show for Header
            messageBar.MessageShow(title: "Login successfully", alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
            
            //Call API
            manageTabBarandSideBar()
        }
    }
    @IBAction func btn_SignUp(_ sender: Any) {
    }
    @IBAction func btn_ForgotePassword(_ sender: Any) {
    }
    @IBAction func btn_NewUser(_ sender: Any) {
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

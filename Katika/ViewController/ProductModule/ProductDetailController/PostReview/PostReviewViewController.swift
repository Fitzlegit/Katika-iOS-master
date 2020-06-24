//
//  PostReviewViewController.swift
//  Katika
//
//  Created by Katika_07 on 02/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import Cosmos
import SwiftMessages

class PostReviewViewController: UIViewController {

    //Other Declaration
    @IBOutlet var rate_ShopRate: CosmosView!
    
    @IBOutlet var lbl_ProductName: UILabel!
    
    @IBOutlet var tv_Description: UITextView!
    
    var objGet = ProductObject ()
    
    //Constant set
    @IBOutlet var con_DetailText : NSLayoutConstraint!
    
    @IBOutlet var btn_Post: UIButton!
    
    //Other Declaration
    @IBOutlet var vw_Rate: CosmosView!
    
    //Declaration Variable
    var keyboardToolbar = UIToolbar()

    var str_Type : String = ""
    var str_Value : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vw_Rate.rating = 0
        
        self.commanMethod()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Textview Proprety -
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black
        if textView.text == "Example: This is probably my favourite Caribbean place in the city? If you’re looking for authentic delicious food that you don’t have to spend a lot of money on, then you will want to visit here. The service was fantastic and the braised oxtails I had were delicious!" {
            textView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            btn_Post.isSelected = true
            textView.text = "Example: This is probably my favourite Caribbean place in the city? If you’re looking for authentic delicious food that you don’t have to spend a lot of money on, then you will want to visit here. The service was fantastic and the braised oxtails I had were delicious!"
            textView.textColor = UIColor.lightGray
        }else{
            btn_Post.isSelected = false
        }
    }
    //MARK: -- InputAccessoryViews and keyboard handle methods --
    func setupInputAccessoryViews() {
        let flexSpace  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(flexSpace)
        items.append(done)
        keyboardToolbar.items = items
        keyboardToolbar.sizeToFit()
    }
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    //Custome class keyboard handler method
    @objc func myKeyboardWillHideHandler(_ notification: NSNotification) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
//            Set constant with screen size
            self.con_DetailText.constant = 20
            self.view .layoutIfNeeded()
        }, completion: nil)
    }
    @objc func myKeyboardWillShow(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
            //            Set constant with screen size
            self.con_DetailText.constant = keyboardHeight
            self.view .layoutIfNeeded()
        }, completion: nil)
    }
    
    
    //MARK: - Other Files -
    func commanMethod(){
        lbl_ProductName.text = objGet.str_ProductTitle as String
        
        //Editing review or not
        if objGet.str_ReviewUserTitle != ""{
            btn_Post.isSelected = false
            
            tv_Description.text = objGet.str_ReviewUserTitle as String!
            vw_Rate.rating = Double(objGet.str_ReviewUserRate as String)!
        }
        
        if str_Type != ""{
            vw_Rate.rating = Double(str_Value)!
        }
        
        
        //Notificaiton event with keyboard show and hide
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
        
        //Set app done button in keyboard
        self.setupInputAccessoryViews()
        
        //Set Keyboardtoollbar in keyboard
        keyboardToolbar = UIToolbar()
        keyboardToolbar.frame = CGRect(x: 0, y: 0, width: Constant.windowWidth, height: 44)
        setupInputAccessoryViews()
        tv_Description.inputAccessoryView  = keyboardToolbar
    }

    // MARK: - Get/Post Method -
    func Post_Review(){
        
        //Declaration URL
        var strURL = "\(Constant.BaseURL)add_shop_review"
        if str_Type != ""{
            strURL = "\(Constant.BaseURL)add_business_review"
        }
        
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "shop_id" : objGet.str_ProductShopID as String,
            "product_id" : objGet.str_ProductId as String,
            "rate" : String(vw_Rate.rating),
            "description" : tv_Description.text,
            "order_id" : "",
        ]
        if str_Type != ""{
            jsonData = [
                "user_id" : objUser?.str_Userid as! String,
                "business_id" : objGet.str_ProductShopID as String,
                "rate" : String(vw_Rate.rating),
                "description" : tv_Description.text,
            ]
        }
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "add_shop_review"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        
        //Editing review or not
        if objGet.str_ReviewUserTitle == ""{
            webHelper.indicatorShowOrHide = false
            webHelper.startDownload()
            
            //Service calling 2 time
            webHelper.indicatorShowOrHide = true
            webHelper.startDownload()
        }else{
            webHelper.indicatorShowOrHide = true
            webHelper.startDownload()
        }
       
    }
    
    
    //MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_Post(_ sender: Any) {
        if btn_Post.isSelected == false {
            if tv_Description.text == "Example: This is probably my favourite Caribbean place in the city? If you’re looking for authentic delicious food that you don’t have to spend a lot of money on, then you will want to visit here. The service was fantastic and the braised oxtails I had were delicious!" && Constant.developerTest == false{
                
                messageBar.MessageShow(title: "Please enter comment", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }
            else if (tv_Description.text?.isEmpty)! && Constant.developerTest == false {
                
                messageBar.MessageShow(title: "Please enter comment", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }else if (tv_Description.text!.characters.count < 30) && Constant.developerTest == false {
                messageBar.MessageShow(title: "Please enter minimum 30 characters.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }else{
                self.Post_Review()
            }
            
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "selectphotos"{
            
            let view : ReviewAndSelectedPhotoViewController = segue.destination as! ReviewAndSelectedPhotoViewController
            view.objGet = objGet
            view.str_Type = str_Type
            
        }
    }
}


extension PostReviewViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        
        let response = data as! NSDictionary
        if strRequest == "add_shop_review" {
            objGet.str_ReviewTitle = tv_Description.text as! NSString
            objGet.str_ReviewStart = String(vw_Rate.rating) as NSString
            objGet.str_ReviewID = response.getStringForID(key:"ReviewID") as! NSString
//            ("\(response["ReviewID"] as! Int)" as NSString)
            
            self.performSegue(withIdentifier: "selectphotos", sender: self)
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
    
}



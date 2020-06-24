//
//  ContactUsViewController.swift
//  Katika
//
//  Created by Katika on 15/06/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages
import ActionSheetPicker_3_0

class ContactUsViewController: UIViewController,UITextViewDelegate {

    //Other Declaration
    @IBOutlet weak var tbl_Main: UITableView!
    
    //Declaration Variable
    var keyboardToolbar = UIToolbar()
    
    var tf_Message: UITextView!
    
    //Label Declaration
    @IBOutlet var lbl_TitleSelected : UILabel!
    
    //Button Declaration
    @IBOutlet var btn_TitleSelected : UIButton!
    
    
    //Array Declaration
    var arr_Main : NSMutableArray = []
    
    var int_SeletedCell : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()
        
        self.navigationController?.isNavigationBarHidden = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Textview Proprety -
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black
        if textView.text == "Please enter your message here" {
            textView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter your message here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    //MARK: - Other Files -
    func commanMethod(){
        //Demo data
        var obj = ConstactViewObject ()
        obj.str_Title = "I want to contact Katika for:"
        arr_Main.add(obj)
        
        obj = ConstactViewObject ()
        obj.str_Title = "I'm interested in putting my products on Katika"
        arr_Main.add(obj)
        
        obj = ConstactViewObject ()
        obj.str_Title = "I have a general inquiry"
        arr_Main.add(obj)
        
        obj = ConstactViewObject ()
        obj.str_Title = "I am from the media or press"
        arr_Main.add(obj)
        
        //Defult Text setup
        lbl_TitleSelected.text = "Select"
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
    //Done Button
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated:false)
        //         self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_Send(_ sender: Any) {
        if  (tf_Message != nil) {
            if(tf_Message.text == "" || tf_Message.text == "Please enter your message here"){
                //Alert show for Header
                messageBar.MessageShow(title: "Please enter first your message", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }else if(lbl_TitleSelected.text == "Select"){
                //Alert show for Header
                messageBar.MessageShow(title: "Please select type of message", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }else{
                self.view.endEditing(true)
                
//                tf_Message.text = ""
                self.textViewDidEndEditing(tf_Message)
                
                self.Post_ContactUs()
                
//                //Alert show for Header
//                messageBar.MessageShow(title: "Message send successfully", alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
                
            }
        }
    }
    @IBAction func btn_TitleSelected(_ sender: Any) {

        let arr_Data : [Any] = ["I'm interested in putting my products on Katika","I have a general inquiry","I am from the media or press"]
        
        let picker = ActionSheetStringPicker(title: "Select Type", rows: arr_Data, initialSelection:selectedIndex(arr: arr_Data as NSArray, value: lbl_TitleSelected.text! as String as NSString), doneBlock: { (picker, indexes, values) in
            self.lbl_TitleSelected.text = values as! String?
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
        picker?.hideCancel = false
        picker?.setDoneButton(UIBarButtonItem(title: "Select", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
    }
    
    
    // MARK: - Get/Post Method -
    func Post_ContactUs(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)contact_katika"
        
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "subject" : lbl_TitleSelected.text as! String,
            "message" : tf_Message.text,
        ]
        //
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "contact_katika"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.indicatorShowOrHide = true
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




//MARK: - Search Object -

class ConstactViewObject: NSObject {
    
    //Catgory Cell
    var str_Title : NSString!
}



// MARK: - Tableview Files -
extension ContactUsViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 25
        }else if indexPath.section == 1{
            return 135
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
    {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         if section == 1 {
            return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //return arr_Main.count
        }else if section == 1{
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var str_Cell : String = "cell"
        if indexPath.section == 1 {
            str_Cell = "reviewtext"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier:str_Cell, for:indexPath as IndexPath) as! ConstausUsTableviewCell
        
        if indexPath.section == 0 {
            //Condition for More category title in last cell in section
            let obj : ConstactViewObject = arr_Main[indexPath.row] as! ConstactViewObject
            
            cell.lbl_Title.text = obj.str_Title as String
            
            
            if int_SeletedCell == indexPath.row {
                cell.btn_BG.isHidden = false
                cell.lbl_Title.font = UIFont(name:  Constant.kFontSemiBold, size: 17)
            }else{
                cell.btn_BG.isHidden = true
                cell.lbl_Title.font = UIFont(name:  Constant.kFontLight, size: 17)
            }
        }else if indexPath.section == 1 {
            cell.tv_Main.delegate = self
            
            //Set Keyboardtoollbar in keyboard
            keyboardToolbar = UIToolbar()
            keyboardToolbar.frame = CGRect(x: 0, y: 0, width: Constant.windowWidth, height: 44)
            setupInputAccessoryViews()
            cell.tv_Main.inputAccessoryView  = keyboardToolbar
            
            tf_Message = cell.tv_Main
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        int_SeletedCell = indexPath.row
        
        tbl_Main.reloadData()
    }
}

//MARK: - Tableview View Cell -
class ConstausUsTableviewCell : UITableViewCell{
    //Main Listing product
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet var btn_BG: Designable!
    
    @IBOutlet weak var tv_Main : UITextView!
}


extension ContactUsViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "contact_katika" {
            self.navigationController?.popViewController(animated:false)
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
    
}



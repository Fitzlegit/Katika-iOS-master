//
//  MessageToShopOwnerViewController.swift
//  Katika
//
//  Created by Katika_07 on 25/09/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages

class MessageToShopOwnerViewController: UIViewController {

    @IBOutlet var viewPopup: UIView!
    
    @IBOutlet var tv_Main: UITextView!
    
    //Declaration Variable
    var currentIndexForTextfield : NSInteger = 0
    var keyboardToolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        commanMethod()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Other Files -
    func commanMethod() {
        
        //Set Keyboardtoollbar in keyboard
        keyboardToolbar = UIToolbar()
        keyboardToolbar.frame = CGRect(x: 0, y: 0, width: Constant.windowWidth, height: 44)
        
        setupInputAccessoryViews()
        
        tv_Main.inputAccessoryView  = keyboardToolbar
    }
    
    //MARK: -- InputAccessoryViews and keyboard handle methods --
    func setupInputAccessoryViews() {
        
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        let flexSpace  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        var items = [UIBarButtonItem]()
        items.append(done)
        keyboardToolbar.items = items
        keyboardToolbar.sizeToFit()
    }
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    //MARK: Button Event -
    @IBAction func viewDismissClick(_ sender: Any) {
        self .dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_Send(_ sender: Any) {
        if tv_Main.text == "" || tv_Main.text == "Type message here" {
            messageBar.MessageShow(title: "Please enter message", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        } else {
            self.view.endEditing(true)
             messageBar.MessageShow(title: "Message successfully sent.", alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
            
            self .dismiss(animated: true, completion: nil)
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


//MARK: - Pageview controller Delegate -
extension MessageToShopOwnerViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Type message here"
        {
            textView.textColor = UIColor.darkText
            textView.text = ""
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // remove the placeholder text when they start typing
        // first, see if the field is empty
        // if it's not empty, then the text should be black and not italic
        // BUT, we also need to remove the placeholder text if that's the only text
        // if it is empty, then the text should be the placeholder
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 // have text, so don't show the placeholder
        {
            // check if the only text is the placeholder and remove it if needed
            if textView.text == "Type message here"
            {
                textView.textColor = UIColor.darkText
                textView.text = ""
            }
            return true
        }
        else  // no text, so show the placeholder
        {
            textView.text = "Type message here"
            textView.textColor = UIColor.lightGray
            self.view.endEditing(true)
            return false
        }
    }


    
    
}

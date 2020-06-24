//
//  BusinessDetailMoreViewController.swift
//  Katika
//
//  Created by Apple on 17/05/18.
//  Copyright © 2018 Katika123. All rights reserved.
//cer

import UIKit
import MessageUI
import SwiftMessages

class BusinessDetailMoreViewController: UIViewController,MFMailComposeViewControllerDelegate {

    //Product Data
    var obj_Get = ProductObject ()

    //Label Declaration
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tbl_Main: UITableView!
    @IBOutlet var lbl_ExploreTheMenu: UILabel!
    @IBOutlet var lbl_Hours: UILabel!
    @IBOutlet var lbl_time: UILabel!
    @IBOutlet var lbl_PhoneNumber: UILabel!
    @IBOutlet var lbl_Website: UILabel!
    @IBOutlet var lbl_EmailAddress: UILabel!
    @IBOutlet var lblCompanuDecription: UILabel!


    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewSubDetails: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmial: UILabel!
    @IBOutlet weak var lblBusiness: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    var isSelectType : String = ""
    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnClaim: UIButton!

    
    
    
    //DECLARATION TIME LABEL
    @IBOutlet var lblMon: UILabel!
    @IBOutlet var LblTus: UILabel!
    @IBOutlet var lblWen: UILabel!
    @IBOutlet var lblThur: UILabel!
    @IBOutlet var lblFir: UILabel!
    @IBOutlet var lblSat: UILabel!
    @IBOutlet var lblSun: UILabel!
    @IBOutlet var lblMonTime: UILabel!
    @IBOutlet var LblTusTime: UILabel!
    @IBOutlet var lblWenTime: UILabel!
    @IBOutlet var lblThuTimer: UILabel!
    @IBOutlet var lblFirTime: UILabel!
    @IBOutlet var lblSatTime: UILabel!
    @IBOutlet var lblSunTime: UILabel!
    @IBOutlet var lblFB: UILabel!
    @IBOutlet var lblTwitter: UILabel!
    @IBOutlet var lblInsta: UILabel!
    @IBOutlet weak var imgFB: UIImageView!
    @IBOutlet weak var imgTwitter: UIImageView!
    @IBOutlet weak var imgInsta: UIImageView!
    @IBOutlet weak var imgFBNext: UIImageView!
    @IBOutlet weak var imgTwitterNext: UIImageView!
    @IBOutlet weak var imgInstaNext: UIImageView!
    @IBOutlet weak var imgWebNext: UIImageView!

    //Button Declaration
    @IBOutlet var btn_ExploreTheMenu: UIButton!
    @IBOutlet var btn_PhoneNumber: UIButton!
    @IBOutlet var btn_WebSite: UIButton!
    @IBOutlet var btn_EmailAddress: UIButton!
   

    @IBOutlet var con_ExploreMenu: NSLayoutConstraint!
    
    @IBOutlet weak var lblWebSite: UILabel!
    @IBOutlet weak var con_weburl: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        viewDetails.isHidden = true
        viewSubDetails.layer.masksToBounds = true
        viewSubDetails.layer.cornerRadius = 5.0
        
        //SET BUTTON
        btnBusiness.layer.masksToBounds = true
        btnBusiness.layer.cornerRadius = btnBusiness.frame.size.height / 2
        btnBusiness.layer.borderColor = UIColor.red.cgColor
        btnBusiness.layer.borderWidth = 1.0
        
        
        btnClaim.layer.masksToBounds = true
        btnClaim.layer.cornerRadius = btnClaim.frame.size.height / 2
        btnClaim.layer.borderColor = UIColor.red.cgColor
        btnClaim.layer.borderWidth = 1.0

        //SET FONT
        lblName.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))
        lblEmial.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))
        lblBusiness.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))
        btnCancel.titleLabel?.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        btnSubmit.titleLabel?.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        lblTitle.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))
        lblTitle2.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 12)/Constant.screenWidthDeveloper))
        lblCompanuDecription.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 12)/Constant.screenWidthDeveloper))

        //SET DETAILS
        lblName.text = "\(objUser?.str_FirstName as! String) \(objUser?.str_LastName as! String)"
        lblEmial.text = objUser?.str_Email as! String
        lblBusiness.text = obj_Get.str_Business_name as String
        lblTitle2.text = "(A katika Team member will contact you.)"

//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MessageView controller -
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Comman Method -
    func commanMethod(){
        lbl_ExploreTheMenu.text = obj_Get.str_Explore_menu as String
        var arr = Array(obj_Get.str_Open_hr_json as String)
        lbl_PhoneNumber.text = obj_Get.str_Phone_number as String
        lbl_Website.text = obj_Get.str_Website as String
        lblCompanuDecription.text = obj_Get.str_Business_description as String
        lbl_EmailAddress.text = obj_Get.str_Business_email as String
        
        self.navigationItem.title = obj_Get.str_Business_title as String
        
        //SET HEADER
        let vw_Table = tbl_Main.tableHeaderView
        vw_Table?.frame = CGRect(x: 0, y: 0, width: tbl_Main.frame.size.width, height: (vw_Table?.frame.size.height)!)
        tbl_Main.tableHeaderView = vw_Table
        tbl_Main.reloadData()
        

        
        //SET WEBURL
        lblWebSite.textColor = UIColor.black
        imgWebNext.isHidden = false
        con_weburl.constant = 5
        if obj_Get.str_Website == ""{
            lblWebSite.textColor = UIColor.lightGray
            imgWebNext.isHidden = true
            con_weburl.constant = 15
        }
        
        //SET SOCIL BUTTON
        lblFB.textColor = UIColor.black
        lblTwitter.textColor = UIColor.black
        lblInsta.textColor = UIColor.black
        imgFBNext.isHidden = false
        imgTwitterNext.isHidden = false
        imgInstaNext.isHidden = false
        imgFB.image = UIImage(named: "icon_Facebook_Shop")
        imgColor(imgColor: imgTwitter, colorHex: "00000")
        imgColor(imgColor: imgInsta, colorHex: "00000")
        
        if obj_Get.str_FB == "" || obj_Get.str_FB == " "{
            lblFB.textColor = UIColor.lightGray
            imgFBNext.isHidden = true
            imgFB.image = UIImage(named: "icon_Facebook_light")
        }
        if obj_Get.str_Twitter == "" ||  obj_Get.str_Twitter == " "{
            lblTwitter.textColor = UIColor.lightGray
            imgTwitterNext.isHidden = true
            imgColor(imgColor: imgTwitter, colorHex: "9A9A9A")
        }
        if obj_Get.str_Insta == "" || obj_Get.str_Insta == " "{
            lblInsta.textColor = UIColor.lightGray
            imgInstaNext.isHidden = true
            imgColor(imgColor: imgInsta, colorHex: "9A9A9A")
        }
        
       var arr2 = convertString(toDictionary: obj_Get.str_Open_hr_json as String)
        
        var arr_Mutable : NSArray = arr2 as! NSArray
        var str_Time : String = ""
        for i in 0..<arr_Mutable.count{
            let dic = arr_Mutable[i] as! NSDictionary
            print(dic)
            let strDay = dic["day"] as! String
            let isOpen = dic["start_time"] as! String
            
            //GET SATRT TIME
            var strStartTime = dic["start_time"] as! String
            if isOpen != "Closed"{
                //GET FIRST TO CHARACTER IN STRING
                let Start = strStartTime.prefix(2)
                let StartTime:Int? = Int(Start)
                if StartTime! < 10{
                    //REMOVE FIRST CHARACTER IN STRING
                    strStartTime.remove(at: strStartTime.startIndex)
                }
            }
            
            //GET END TIME
            var strEndTime = dic["end_time"] as! String
            if isOpen != "Closed"{
                //GET FIRST TO CHARACTER IN STRING
                let End = strEndTime.prefix(2)
                let EndTime:Int? = Int(End)
                if EndTime! < 10{
                    //REMOVE FIRST CHARACTER IN STRING
                    strEndTime.remove(at: strEndTime.startIndex)
                }
            }
            
            
            //SET TIME IN LOWERCASE
            var strTime :String = ""
            if isOpen == "Closed"{
                strTime = isOpen
            }
            else{
                strTime = strStartTime + " - " + strEndTime
            }
            
            if strDay == "Mon" {
                //SET TIME
                lblMonTime.text = strTime.lowercased()
                
                if isOpen == "Closed"{
                    //SET TILE FONT
                    lblMon.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblMonTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
                else{
                    //SET TILE FONT
                    lblMon.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblMonTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
            }
            else if strDay == "Tue" {
                //SET TIME
                LblTusTime.text = strTime.lowercased()
                if isOpen == "Closed"{
                    //SET TILE FONT
                    LblTus.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    LblTusTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
                else{
                    //SET TILE FONT
                    LblTus.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    LblTusTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
            }
            else if strDay == "Wed" {
                //SET TIME
                lblWenTime.text = strTime.lowercased()
                if isOpen == "Closed"{
                    //SET TILE FONT
                    lblWen.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblWenTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
                else{
                    //SET TILE FONT
                    lblWen.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblWenTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
            }
            else if strDay == "Thu" {
                //SET TIME
                lblThuTimer.text = strTime.lowercased()
                if isOpen == "Closed"{
                    //SET TILE FONT
                    lblThur.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblThuTimer.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
                else{
                    //SET TILE FONT
                    lblThur.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblThuTimer.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
            }
            else if strDay == "Fri" {
                //SET TIME
                lblFirTime.text = strTime.lowercased()
                if isOpen == "Closed"{
                    //SET TILE FONT
                    lblFir.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblFirTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
                else{
                    //SET TILE FONT
                    lblFir.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblFirTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
            }
            else if strDay == "Sat" {
                //SET TIME
                lblSatTime.text = strTime.lowercased()
                if isOpen == "Closed"{
                    //SET TILE FONT
                    lblSat.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblSatTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
                else{
                    //SET TILE FONT
                    lblSat.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblSatTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
            }
            else if strDay == "Sun" {
                //SET TIME
                lblSunTime.text = strTime.lowercased()
                if isOpen == "Closed"{
                    //SET TILE FONT
                    lblSun.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblSunTime.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
                else{
                    //SET TILE FONT
                    lblSun.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                    lblSunTime.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
                }
            }
//            if str_Time == ""{
//                str_Time = "\(dic["day"] as! String)" + "\t\t" + "\(dic["start_time"] as! String) - \(dic["end_time"] as! String)"
//            }else{
//                str_Time = str_Time + "\n" + "\(dic["day"] as! String) " + "\t\t" + "\(dic["start_time"] as! String) - \(dic["end_time"] as! String)"
//            }
        }
        //lbl_Hours.text = str_Time
        
        //Explore menu hide show
        if obj_Get.str_ExporeMenuShow == "0"{
            con_ExploreMenu.constant = 0
        }
    }
    
    func convertString(toDictionary str: String?) -> [Any]? {
        var jsonError: Error?
        let objectData: Data? = str?.data(using: .utf8)
        var json: [Any]? = nil
        if let aData = objectData {
            json = try! JSONSerialization.jsonObject(with: aData, options: .mutableContainers) as? [Any]
        }
        return json
    }
    func shareMail(receiverMain : String,Body : String){
        if MFMailComposeViewController.canSendMail() {
            let emailDialog = MFMailComposeViewController()
            emailDialog.mailComposeDelegate = self
            let htmlMsg: String = "<html><body><p>\(Body)</p></body></html>"
            emailDialog.setToRecipients([receiverMain])
            
            emailDialog.setSubject("email subject")
            emailDialog.setMessageBody(htmlMsg, isHTML: true)
            present(emailDialog, animated: true, completion: { _ in })
        }else{
            messageBar.MessageShow(title: NSLocalizedString("Mail account not comfortable in your device.", comment: "") as NSString, alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
        }
    }
    
    func Post_Close(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)post_close_business"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "business_id" : obj_Get.str_Business_id,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "post_close_business"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
    func Post_Clima(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)post_claim_business"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "business_id" : obj_Get.str_Business_id,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "post_claim_business"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
    //MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_ExploreTheMenu(_ sender: Any) {
        if let url = URL(string: obj_Get.str_Explore_menu as String) {
            if UIApplication.shared.canOpenURL(url) {
                openURLToWeb(url : url)
            }
        }
    }
    @IBAction func btn_PhoneNumber(_ sender: Any) {
        if let url = URL(string: "tel://\(obj_Get.str_Phone_number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func btn_WebSite(_ sender: Any) {
        if obj_Get.str_Website as String != ""{
            let url = URL(string:obj_Get.str_Website as String)!
            openURLToWeb(url : url)
        }
    }
    @IBAction func btn_FB(_ sender: Any) {
        if obj_Get.str_FB as String != ""{
            let url = URL(string:obj_Get.str_FB as String)!
            openURLToWeb(url : url)
        }
    }
    @IBAction func btn_Teitter(_ sender: Any) {
        if obj_Get.str_Twitter as String != ""{
            let url = URL(string:obj_Get.str_Twitter as String)!
            openURLToWeb(url : url)
        }else{
            messageBar.MessageShow(title: "Invalid input URL", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }
    }
    @IBAction func btn_Insta(_ sender: Any) {
        if obj_Get.str_Insta as String != ""{
            let url = URL(string:obj_Get.str_Insta as String)!
            openURLToWeb(url : url)
        }
    }
    
    @IBAction func btn_EmailAddress(_ sender: Any) {
        let str_Value : String = "Business Name : \(obj_Get.str_Business_title)"
        self.shareMail(receiverMain:obj_Get.str_Business_email as String,Body : str_Value)
    }
    @IBAction func btn_CloseBusiness(_ sender: Any) {
        if objUser?.str_User_Role != "2"{
            isSelectType = "1"
            viewDetails.isHidden = false
            
            //SET DETALS
            lblTitle.text = "You have knowledge that this business is no longer in operation."
        }
    }
    @IBAction func btn_ClaimBusiness(_ sender: Any) {
        
        if objUser?.str_User_Role != "2"{
            isSelectType = "2"
            viewDetails.isHidden = false
            
            //SET DETALS
            lblTitle.text = "I am claiming ownership of this business and can prove that I own it."
            
        }
    }
    
    
    @IBAction func btn_CancelClicked(_ sender: Any) {
        viewDetails.isHidden = true
    }
    @IBAction func btn_SubmitClicked(_ sender: Any) {
        
        if isSelectType == "1"{
            self.Post_Close()
        }
        else if isSelectType == "2" {
            self.Post_Clima()
        }
       
    }
}



extension BusinessDetailMoreViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "post_close_business" || strRequest == "post_claim_business" {
            
            viewDetails.isHidden = true
            //Alert show for Header
            messageBar.MessageShow(title: response["msg"] as! String as NSString, alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
                        
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
    
}


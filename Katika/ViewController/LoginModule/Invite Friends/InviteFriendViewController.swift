//
//  InviteFriendViewController.swift
//  Katika
//
//  Created by icoderz_04 on 15/10/18.
//  Copyright © 2018 icoderz123. All rights reserved.
//

import UIKit
import Contacts
import AddressBookUI
import AddressBook

class InviteFriendViewController: UIViewController {

    //Declaration VALUE
    @IBOutlet weak var tblView: UITableView!
    var contacts = [CNContact]()
    var arr_Main = NSMutableArray()
    var arrSendFriend = NSMutableArray()
    var arrResendFriend = NSMutableArray()

    @IBOutlet weak var lblNoData: UILabel!
    
    var str_IsLogin : NSString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoData.isHidden = true
        lblNoData.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 12)/Constant.screenWidthDeveloper))

        //SET NAVIGAYION BAR
        self.navigationController?.isNavigationBarHidden = false

        //GET CONTACTS EMIL
        self.fetchContacts()
        
        //SET TABLE VIEW
        tblView.dataSource = self
        tblView.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        //create a new button
        let button = UIButton.init(type: .custom)
        self.navigationItem.setHidesBackButton(true, animated: false)

        //SET BACK BUTTON
        if str_IsLogin == "1"{
            //set title for button
            button.setTitle("Skip", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.addTarget(self, action: #selector(btnSkipClicked(_:)), for: UIControl.Event.touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            let barButton = UIBarButtonItem(customView: button)
            
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItem = barButton
        }
        else{
            //set title for button
            button.setImage(UIImage(named: "icon_NavigationRightArrow"), for: .normal)
//            button.setTitle("Skip..", for: .normal)

            button.addTarget(self, action: #selector(btnBackClicked(_:)), for: UIControl.Event.touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            let barButton = UIBarButtonItem(customView: button)

            //assign button to navigationbar
            self.navigationItem.rightBarButtonItem = barButton
            
        }
        

    }

    
    // MARK: - ACTION BUTTON
    @objc func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @objc func btnSkipClicked(_ sender: Any) {
        //Call API
        manageTabBarandSideBar()
    }
    
    //MARK: -GET COUNTACT LIST
    func fetchContacts()
    {
        arr_Main = []
        
        let toFetch = [CNContactGivenNameKey,CNContactMiddleNameKey, CNContactImageDataKey, CNContactFamilyNameKey, CNContactImageDataAvailableKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey]
        let request = CNContactFetchRequest(keysToFetch: toFetch as [CNKeyDescriptor])
        
        do{
            try contactStore.enumerateContacts(with: request) {
                contact, stop in
                print(contact.givenName)
                print(contact.familyName)
                print(contact.identifier)
                
                var str_Email : String = ""
                for ContctNumVar: CNLabeledValue in contact.emailAddresses
                {
                    str_Email = ContctNumVar.value as String
                    break
                }
                
                
                if str_Email != ""{
                        
                    let dict : NSMutableDictionary = [:]
                    dict.setValue("\(contact.givenName) \(contact.familyName)", forKey: "name")
                    dict.setValue(str_Email, forKey: "email")
                    self.arr_Main.add(dict)
                }
            }
        } catch let err{
            print(err)
            // self.errorStatus()
        }
        
        
        var sort = NSSortDescriptor(key: "name", ascending: true)
        let arr = self.arr_Main.sortedArray(using: [sort])
        self.arr_Main = NSMutableArray(array: arr)
        
        //CALL API
        self.GetFirendList()
    }
    
    //MARK: - API CALLING
    func GetFirendList() {
        //Declaration URL
        let strURL = "\(Constant.BaseURL)invite_user"
        let string = notPrettyString(from : arr_Main)
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "emails" : string,
            "type":"email",
            "action":"list",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_inviteFriend"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.startDownload()
    }
    
    
    

    
   
}


// MARK: - Tableview Files -
extension InviteFriendViewController : UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if section==0 {
            return arrResendFriend.count
        }
        else if section==1 {
            return arrSendFriend.count
        }
        else{
            return 0
        }
    }
    
    //HEADER SECTION
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.lightGray

//        let lblName = UILabel()
        let lblName = UILabel(frame: CGRect(x: 0, y: 0, width: Constant.windowWidth, height: 30))
        lblName.textAlignment = NSTextAlignment.center

        if section == 0 {
            lblName.text = "Resend"
        }
        else if section == 1{
            lblName.text = "Send"
            
        }
        lblName.addSubview(vw)
        return vw
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    //    //FOOTER SECTION
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let vw = UIView()
    //        vw.backgroundColor = UIColor.purple
    //        return vw
    //
    //    }
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 40.0
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let simpleTableIdentifier = "InviteFriendCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) as? InviteFriendCell
        var arr = Bundle.main.loadNibNamed("InviteFriendCell", owner: self, options: nil)
        cell = arr?[0] as? InviteFriendCell
        cell?.selectionStyle = .none
        
        if indexPath.section == 0 {
            //RESENSENDER VIEW
            
            //SET VIEW
            cell?.viewResend.isHidden = false
            cell?.viewSend.isHidden = true
            
            //SET DETAILS
            var dicData = NSDictionary()
            dicData = arrResendFriend[indexPath.row] as! NSDictionary
            let strName = dicData.object(forKey: "name") as! String
            let srEmail = dicData.object(forKey: "email") as! String

            cell?.lblResendName.text = strName
            cell?.lblResendEmail.text = srEmail
           
            
            //SET BUTTON CLICKED
            cell?.btnResendClicked.tag = indexPath.row
            cell?.btnResendClicked.addTarget(self, action: #selector(btnResendClicked ), for: .touchUpInside)
        }
        else if indexPath.section == 1{
            //RESENSENDER VIEW
            
            //SET VIEW
            cell?.viewResend.isHidden = true
            cell?.viewSend.isHidden = false
            
            //SET DETAILS
            var dicData = NSDictionary()
            dicData = arrSendFriend[indexPath.row] as! NSDictionary
            print(dicData)
            let strName = dicData.object(forKey: "name") as! String
            let srEmail = dicData.object(forKey: "email") as! String
            
            cell?.lblSendName.text = strName
            cell?.lblSendEmail.text = srEmail
            
            //SET BUTTON CLICKED
            cell?.btnSendClicked.tag = indexPath.row
            cell?.btnSendClicked.addTarget(self, action: #selector(btnSendClicked ), for: .touchUpInside)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(Int((Constant.windowHeight * 70)/Constant.screenHeightDeveloper))
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    //MARK: -TABLE BUTTON CLICKED
    @IBAction func btnSendClicked (_ sender : Any){
        
        //GET DATA
        var dicData = NSDictionary()
        dicData = arrSendFriend[(sender as AnyObject).tag] as! NSDictionary
        let arrData = NSMutableArray()
        arrData.add(dicData)
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)invite_user"
        let string = notPrettyString(from : arrData)
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "emails" : string,
            "type":"email",
            "action":"add",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "send_inviteFriend"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.startDownload()
    }
    
    @IBAction func btnResendClicked (_ sender : Any){
//        //GET DATA
//        var dicData = NSDictionary()
//        dicData = arrResendFriend[(sender as AnyObject).tag] as! NSDictionary
//        let arrData = NSMutableArray()
//        arrData.add(dicData)
//        
//        //Declaration URL
//        let strURL = "\(Constant.BaseURL)invite_user"
//        let string = notPrettyString(from : arrData)
//        
//        //Pass data in dictionary
//        var jsonData : NSDictionary =  NSDictionary()
//        jsonData = [
//            "user_id" : objUser?.str_Userid as! String,
//            "emails" : string,
//            "type":"email",
//            "action":"add",
//        ]
//        
//        //Create object for webservicehelper and start to call method
//        let webHelper = WebServiceHelper()
//        webHelper.strMethodName = "send_inviteFriend"
//        webHelper.methodType = "post"
//        webHelper.strURL = strURL
//        webHelper.dictType = jsonData
//        webHelper.dictHeader = NSDictionary()
//        webHelper.delegateWeb = self
//        webHelper.serviceWithAlert = true
//        webHelper.startDownload()
    }
    
    
}



extension InviteFriendViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        print(response)
        
        if strRequest == "get_inviteFriend" {
            
            //if response["status"] as? String == "OK"{
            //Get Main array
            let arr = response["emails"] as! NSArray
            let arrCurrencyData = arr.mutableCopy() as! NSMutableArray
            arrResendFriend = NSMutableArray()
            arrSendFriend = NSMutableArray()
            
            for i in 0..<arrCurrencyData.count {
                var dicData = NSDictionary()
                dicData = arrCurrencyData[i] as! NSDictionary
                let strInvited = dicData.object(forKey: "invited") as! NSNumber
                
                if strInvited == 1{
                    arrResendFriend.add(dicData)
                }
                else{
                    arrSendFriend.add(dicData)
                }
            }
          
            if arrResendFriend.count == 0  &&  arrSendFriend.count == 0{
                lblNoData.isHidden = false
            }

            //REOAD TABLE
            tblView.reloadData()
            
            // }else{
            //                messageBar.MessageShow(title: "Please enter valid zipcode or city name.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            //         }
        }
        else if strRequest == "send_inviteFriend"{
            //CALL API
            self.GetFirendList()
        }
    }
    
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        // self.completedServiceCalling()
        if arrResendFriend.count == 0  &&  arrSendFriend.count == 0{
            lblNoData.isHidden = false
        }
    }
    
}


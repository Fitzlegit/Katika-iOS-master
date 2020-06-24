//
//  PurchaseGiftViewController.swift
//  Katika
//
//  Created by Katika_07 on 23/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftMessages

import BraintreeDropIn
import Braintree
import PassKit

class PurchaseGiftViewController: UIViewController,PKPaymentAuthorizationViewControllerDelegate{
    //Object Declaration
    let obj_CardDetail = CardObject()

    
    @IBOutlet weak var txtAddCard: UITextField!
    @IBOutlet weak var btn_SelectedDoller1: UIButton!
    @IBOutlet weak var btn_SelectedDoller2: UIButton!
    @IBOutlet weak var btn_SelectedDoller3: UIButton!
    @IBOutlet weak var btn_SelectedDoller4: UIButton!
    @IBOutlet weak var btn_SelectedDoller5: UIButton!
    
    @IBOutlet weak var lbl_SelectedDoller1: UILabel!
    @IBOutlet weak var lbl_SelectedDoller2: UILabel!
    @IBOutlet weak var lbl_SelectedDoller3: UILabel!
    @IBOutlet weak var lbl_SelectedDoller4: UILabel!
    @IBOutlet weak var lbl_SelectedDoller5: UILabel!
    @IBOutlet weak var lbl_SelectedAmount: UILabel!
    
    @IBOutlet weak var vw_SelectedAmount: UIView!
    
    @IBOutlet weak var tf_EmailAddress: UITextField!
    
    //Payent object Declaration
    var clientToken : String = ""
    var int_selectedAmount : Int = 0
    var str_Key : String = ""
    
    //Declaration Variable
    var isValidEmail : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.Post_cardListing()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    func desibleSelectedButton(){
        vw_SelectedAmount.isHidden = false
        
        btn_SelectedDoller1.isSelected = true
        btn_SelectedDoller2.isSelected = true
        btn_SelectedDoller3.isSelected = true
        btn_SelectedDoller4.isSelected = true
        btn_SelectedDoller5.isSelected = true
        
        lbl_SelectedDoller1.textColor = UIColor.black
        lbl_SelectedDoller2.textColor = UIColor.black
        lbl_SelectedDoller3.textColor = UIColor.black
        lbl_SelectedDoller4.textColor = UIColor.black
        lbl_SelectedDoller5.textColor = UIColor.black
        
        btn_SelectedDoller1.backgroundColor = UIColor.white
        btn_SelectedDoller2.backgroundColor = UIColor.white
        btn_SelectedDoller3.backgroundColor = UIColor.white
        btn_SelectedDoller4.backgroundColor = UIColor.white
        btn_SelectedDoller5.backgroundColor = UIColor.white
    }
    

    //MARK: - Payment Gateway -
    func payWithPresentview(clientTokenOrTokenizationKey: String) {
        // If you haven't already, create and retain a `Braintree` instance with the client token.
        // Typically, you only need to do this once per session.
        
        let paymentRequest: BTPaymentRequest = BTPaymentRequest()
        paymentRequest.summaryTitle = "Kaika"
        paymentRequest.summaryDescription = ""
        paymentRequest.displayAmount = "$" + String(int_selectedAmount)
        paymentRequest.currencyCode = "$"
        paymentRequest.callToActionText = "Pay Now"
        paymentRequest.shouldHideCallToAction = false
        
        
        let client = BTAPIClient(authorization: clientTokenOrTokenizationKey)
        let dropInViewController = BTDropInViewController(apiClient: client!)
        dropInViewController.paymentRequest = paymentRequest
        dropInViewController.delegate = self
        
        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.navigationCancelButton))
        
        let navigationController = UINavigationController(rootViewController: dropInViewController)
        self.present(navigationController, animated: true, completion: nil)
        
        
    }
    func payWithDropInShow(clientTokenOrTokenizationKey: String) {
        str_Key = clientTokenOrTokenizationKey
        
        let request =  BTDropInRequest()
        request.applePayDisabled = false
        
        let canMakePayments = PKPaymentAuthorizationViewController.canMakePayments() && PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.amex, .visa, .masterCard])
        request.applePayDisabled = !canMakePayments
        
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            controller.dismiss(animated: true, completion: nil)
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                //                let selectedPaymentOptionType = result.paymentOptionType
                //                let selectedPaymentMethod = result.paymentMethod
                //                let selectedPaymentMethodIcon = result.paymentIcon
                //                let selectedPaymentMethodDescription = result.paymentDescription
                
                if BTUIKPaymentOptionType.applePay == result.paymentOptionType{
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.tappedApplePay), userInfo: nil, repeats: false)
                }else{
                    self.payWithPresentview(clientTokenOrTokenizationKey:clientTokenOrTokenizationKey)
                }
            }
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    @objc func navigationCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: -- Apple Pay --
    @objc func tappedApplePay() {
        let paymentRequest = self.paymentRequest()
        if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            as PKPaymentAuthorizationViewController?
        {
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        } else {
            print("Error: Payment request is invalid.")
        }
    }
    
    func paymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "merchant.com.brainTreeDropDown.test";
        paymentRequest.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.visa, PKPaymentNetwork.masterCard];
        paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS;
        paymentRequest.countryCode = "US"; // e.g. US
        paymentRequest.currencyCode = "USD"; // e.g. USD
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Gitf Voucher", amount: NSDecimalNumber(string: String(int_selectedAmount)))
        ]
        
        return paymentRequest
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Swift.Void)
    {
        
        //        // Example: Tokenize the Apple Pay payment
        var client = BTAPIClient(authorization: str_Key)
        let applePayClient = BTApplePayClient(apiClient: client!)
        applePayClient.tokenizeApplePay(payment) {
            (tokenizedApplePayPayment, error) in
            guard let tokenizedApplePayPayment = tokenizedApplePayPayment else {
                // Tokenization failed. Check `error` for the cause of the failure.
                
                // Indicate failure via completion callback.
                completion(PKPaymentAuthorizationStatus.failure)
                
                return
            }
            
            // Send the nonce to your server for processing.
            print("nonce = \(tokenizedApplePayPayment.nonce)")
            self.Post_PaymentDetail(id:tokenizedApplePayPayment.nonce as NSString)
            
            // Then indicate success or failure via the completion callback, e.g.
            completion(PKPaymentAuthorizationStatus.success)
        }
    }
    
    // Be sure to implement paymentAuthorizationViewControllerDidFinish.
    // You are responsible for dismissing the view controller in this method.
    @available(iOS 8.0, *)
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("get data")
        dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationViewController){
        print("get data")
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Swift.Void)
    {
        print("get data")
    }
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingAddress address: ABRecord, completion: @escaping (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Swift.Void)
    {
        print("get data")
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, completion: @escaping (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Swift.Void)
    {
        print("get data")
    }
    
    
    // MARK: - Other Method -

    func setCardDetails()  {
        if obj_CardDetail.str_Card_id != ""{
            txtAddCard.text = "***\(obj_CardDetail.str_Card_elast4) \(obj_CardDetail.str_Card_brand) Exp:\(obj_CardDetail.str_Card_exp_month):\(obj_CardDetail.str_Card_exp_year)"
        }
    }
    
    func makeOrderDetailArray() -> NSMutableArray{
        var dict_Sub : NSDictionary =  NSDictionary()
        
        let arr_ProductTemp : NSMutableArray = []
        for count in (0..<1){
            dict_Sub =  NSDictionary()
            
            dict_Sub = [
                "amount" : String(int_selectedAmount),
                "email" : tf_EmailAddress.text ?? "",
            ]
            
            arr_ProductTemp.add(dict_Sub)
        }
        return arr_ProductTemp
    }
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated:false)
        //         self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_SelectedDoller1(_ sender: Any) {
        self.desibleSelectedButton()
        
        btn_SelectedDoller1.isSelected = false
        lbl_SelectedDoller1.textColor = UIColor.white
        btn_SelectedDoller1.backgroundColor = UIColor.red
        lbl_SelectedAmount.text = "Selected Amount : \(lbl_SelectedDoller1.text as! NSString as String)"
        int_selectedAmount = 25
    }
    @IBAction func btn_SelectedDoller2(_ sender: Any) {
        self.desibleSelectedButton()
        btn_SelectedDoller2.isSelected = false
        lbl_SelectedDoller2.textColor = UIColor.white
        btn_SelectedDoller2.backgroundColor = UIColor.red
        lbl_SelectedAmount.text = "Selected Amount : \(lbl_SelectedDoller2.text as! NSString as String)"
        int_selectedAmount = 50
    }
    @IBAction func btn_SelectedDoller3(_ sender: Any) {
        self.desibleSelectedButton()
        btn_SelectedDoller3.isSelected = false
        lbl_SelectedDoller3.textColor = UIColor.white
        btn_SelectedDoller3.backgroundColor = UIColor.red
        lbl_SelectedAmount.text = "Selected Amount : \(lbl_SelectedDoller3.text as! NSString as String)"
        int_selectedAmount = 100
    }
    @IBAction func btn_SelectedDoller4(_ sender: Any) {
        self.desibleSelectedButton()
        btn_SelectedDoller4.isSelected = false
        lbl_SelectedDoller4.textColor = UIColor.white
        btn_SelectedDoller4.backgroundColor = UIColor.red
        lbl_SelectedAmount.text = "Selected Amount : \(lbl_SelectedDoller4.text as! NSString as String)"
        int_selectedAmount = 125
    }
    @IBAction func btn_SelectedDoller5(_ sender: Any) {
//        self.desibleSelectedButton()
//        btn_SelectedDoller5.isSelected = false
//        lbl_SelectedDoller5.textColor = UIColor.white
        
        let arr_Data : [Any] = ["$250","$500","$1000"]
        let arr_DataValue : [Any] = [250,500,1000]
        
        let picker = ActionSheetStringPicker(title: "Select Type", rows: arr_Data, initialSelection:selectedIndex(arr: arr_Data as NSArray, value: lbl_SelectedAmount.text! as String as NSString), doneBlock: { (picker, indexes, values) in
            
            self.lbl_SelectedAmount.text = "Selected Amount : \(values as! NSString as String)"
            if indexes == 0{
                self.int_selectedAmount = 250
            }else if indexes == 1{
                self.int_selectedAmount = 500
            }else if indexes == 2{
                self.int_selectedAmount = 1000
            }
            
            self.desibleSelectedButton()
            self.btn_SelectedDoller5.isSelected = false
            self.lbl_SelectedDoller5.textColor = UIColor.white
            self.btn_SelectedDoller5.backgroundColor = UIColor.red

            
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
//        picker?.hideCancel = true
        picker?.setDoneButton(UIBarButtonItem(title: "SELECT", style: .plain, target: nil, action: nil))
        picker?.setCancelButton(UIBarButtonItem(title: "CANCEL", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
        
    }
    @IBAction func btn_Pay(_ sender:Any){
//        if obj_CardDetail.str_Card_id == ""{
//            messageBar.MessageShow(title: "Please add card.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
//        }
//        else
            if((tf_EmailAddress.text?.isEmpty)! && Constant.developerTest == false){
            //Alert show for Header
            messageBar.MessageShow(title: "Please enter email address", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            
        }else if(isValidEmail ==  validateEmail(enteredEmail: tf_EmailAddress.text!) && Constant.developerTest == false){
            if isValidEmail == true {
                
            }else{
                //Alert show for Header
                messageBar.MessageShow(title: "Please enter valid email address", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }
        }else{
            self.view.endEditing(true)
//            self.Get_Token()
                
            //CALL PAYMENT API
            Post_PaymentDetail(id: "")
            //self.Post_ForgotePassword()
        }
    }
    
    @IBAction func btnAddCardDetailsclicked(_ sender: Any) {
        //MOVE TO INVITE FRIEND SCREEN
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "CardListViewController") as! CardListViewController
        self.navigationController?.pushViewController(view, animated: true)
        
    }
    
    func Get_Token(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)GenratePaymentToken"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "CustomerID" : (objUser?.str_CheckoutTocken as! String),
        ]
        
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "getTokenGenerate"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
        
    }
    
    func Post_PaymentDetail(id : NSString){
        //Declaration URL
        let strURL = "\(Constant.BaseURL)purchase_gift_voucher"
        
        
        let arr_Data = makeOrderDetailArray()
        let str_VoucherDetail = notPrettyString(from : arr_Data)
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "buyer_id" : objUser?.str_Userid as! String,
//            "customerid" : (objUser?.str_CheckoutTocken as! String),
            "gift_voucher_detail" : str_VoucherDetail,
//            "noncefromtheclient" : id,
            "grand_total" : String(int_selectedAmount),
        ]
        
        
        print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "purchase_gift_voucher"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
    
    
    // MARK: - Get/Post Method -
    func Post_cardListing(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)getCard"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : (objUser?.str_Userid as! String),
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "getCard"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
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


extension PurchaseGiftViewController : BTDropInViewControllerDelegate {
    // MARK: - BTDropInViewControllerDelegate -
    func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethod: BTPaymentMethodNonce) {
        self.Post_PaymentDetail(id:paymentMethod.nonce as NSString)
        dismiss(animated: true, completion: nil)
        
    }
    
    func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
        dismiss(animated: true, completion: nil)
    }
}


extension PurchaseGiftViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        
        let response = data as! NSDictionary
        print(response)
        if strRequest == "getCard" {
            let arr_card = response["result"] as! NSArray

            obj_CardDetail.str_Card_id = ""
            for i in 0..<arr_card.count{
                let dict_List = arr_card[i] as! NSDictionary
                if dict_List.getStringForID(key: "default_card") == "True"{
                    obj_CardDetail.str_Card_id = dict_List.getStringForID(key: "id") as! NSString
                    obj_CardDetail.str_Card_brand = dict_List.getStringForID(key: "brand") as! NSString
                    obj_CardDetail.str_Card_elast4 = dict_List.getStringForID(key: "last4") as! NSString
                    obj_CardDetail.str_Card_country = dict_List.getStringForID(key: "country") as! NSString
                    obj_CardDetail.str_Card_exp_year = dict_List.getStringForID(key: "exp_year") as! NSString
                    obj_CardDetail.str_Card_exp_month = dict_List.getStringForID(key: "exp_month") as! NSString
                }
            }
            
            //SET DETAILS
            self.setCardDetails()
        }
        else if strRequest == "getTokenGenerate" {
            
            //Get Access Tokent
            clientToken = (response["Totken"] as! NSString) as String
            self.payWithDropInShow(clientTokenOrTokenizationKey:clientToken)
            
        }else if strRequest == "purchase_gift_voucher"{
            //User userdefualt
//            objUser?.str_CheckoutTocken = response["CustomerID"] as! NSString
//            saveCustomObject(objUser!, key: "userobject");
            let msg = response ["msg"] as? String ?? ""
            messageBar.MessageShow(title: msg as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)

            
            tf_EmailAddress.text = ""
            self.desibleSelectedButton()
            vw_SelectedAmount.isHidden = true
        }
        
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
    
}




//MARK: - Card Object -

class CardObject: NSObject {
    //Card detail
    var str_Card_id : NSString = ""
    var str_Card_brand : NSString = ""
    var str_Card_country : NSString = ""
    var str_Card_exp_month : NSString = ""
    var str_Card_exp_year : NSString = ""
    var str_Card_elast4 : NSString = ""

}

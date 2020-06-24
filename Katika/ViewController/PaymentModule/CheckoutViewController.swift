//
//  CheckoutViewController.swift
//  Katika
//
//  Created by Katika on 08/06/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
//import Braintree
import PassKit
import SwiftMessages

import BraintreeDropIn
import Braintree
import PassKit

var obj_PromocodeDiscountPrice = PromocodeObject ()
var obj_GiftVoucherDiscountPrice = GiftVoucherObject ()

class CheckoutViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {

    //Label Declaration
    @IBOutlet var lbl_PaymentTitle : UILabel!
    @IBOutlet var lbl_ShoppingTitle : UILabel!
    @IBOutlet var lbl_ShippingTitle : UILabel!
    @IBOutlet var lbl_Total_Payment : UILabel!
    
    //Button Declaration
    @IBOutlet var btn_PayMethod : UIButton!
    @IBOutlet var btn_USPSType : UIButton!
    
    
    //Tableview Declaration
    @IBOutlet var tbl_Main : UITableView!
    
    //Array Declaration
    var arr_Product : NSMutableArray = []
    
    //Bool Declaration
    var bool_Load : Bool = false
    var bool_LoadtoViewDidload : Bool = false
    
    //View Declaration
    var vw_HeaderView: UIView?
    
    //Object Declaration
    let obj_CheckOutDetail = CheckoutObject ()

    //Payent object Declaration
    var clientToken : String = ""
    
    //Other Declaration
    var bool_userRewardPoint : Bool = false
    var str_Key : String = ""
    
    
    //DECLARATION MORE INFORMATION
    @IBOutlet weak var viewMoreInfo: UIView!
    @IBOutlet weak var viewMoreInfoClose: UIView!
    @IBOutlet weak var viewInfo: UIView!
    
    @IBOutlet weak var lblMoreInfo2: UILabel!
    @IBOutlet weak var lblMoreInfo1: UILabel!
    @IBOutlet weak var lblMoreInfo3: UILabel!
    @IBOutlet weak var lblMoreInfo4: UILabel!
    @IBOutlet weak var lblMoreInfo5: UILabel!
    @IBOutlet weak var lblMoreInfo6: UILabel!
    @IBOutlet weak var lblMoreInfo7: UILabel!
   
    //Constant Declaration
    @IBOutlet var con_BottomViewHeight : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commanMethod()
        bool_LoadtoViewDidload = true
        
        //Set empty promocode object when view comming
        obj_PromocodeDiscountPrice = PromocodeObject ()
        obj_GiftVoucherDiscountPrice = GiftVoucherObject ()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //SET NAVIGATION BAR
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)

        if bool_LoadtoViewDidload == true {
            bool_LoadtoViewDidload = false
            arr_Product = []
            tbl_Main.reloadData()
        }
        self.Post_cardListing()
        
         self.manageNavigation()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        
        //SET MORE INFO VIEW
        viewMoreInfo.isHidden = true
        viewMoreInfoClose.layer.cornerRadius = viewMoreInfoClose.frame.size.height / 2
        viewInfo.layer.cornerRadius = 5
    }
    
    //MARK: - Payment Gateway -
    func payWithPresentview(clientTokenOrTokenizationKey: String) {
        // If you haven't already, create and retain a `Braintree` instance with the client token.
        // Typically, you only need to do this once per session.
        
        let paymentRequest: BTPaymentRequest = BTPaymentRequest()
        paymentRequest.summaryTitle = "Kaika"
        paymentRequest.summaryDescription = paymentDescription() as String!
        paymentRequest.displayAmount = "$" + (totalGet(type : "grand") as String!)
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
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                let selectedPaymentOptionType = result.paymentOptionType
                let selectedPaymentMethod = result.paymentMethod
                let selectedPaymentMethodIcon = result.paymentIcon
                let selectedPaymentMethodDescription = result.paymentDescription
                
                if BTUIKPaymentOptionType.applePay == result.paymentOptionType{
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.tappedApplePay), userInfo: nil, repeats: false)
                }else if BTUIKPaymentOptionType.payPal == result.paymentOptionType{
                    print(selectedPaymentMethod)
                    print(selectedPaymentOptionType)
                    print(result.paymentMethod!.nonce)
                    var str_Noune = result.paymentMethod!.nonce
                    self.Post_PaymentDetail(id:str_Noune as NSString)
                }else{
                    var str_Noune = result.paymentMethod!.nonce
                    self.Post_PaymentDetail(id:str_Noune as NSString)
//                    self.payWithPresentview(clientTokenOrTokenizationKey:clientTokenOrTokenizationKey)
                }
            }
            controller.dismiss(animated: true, completion: nil)
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
        paymentRequest.paymentSummaryItems = paymentDescriptionWithArray() as! [PKPaymentSummaryItem]
        
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
    
    
    //MARK: - Other Files -
    func commanMethod(){
        //Layer set
        btn_PayMethod.layer.borderWidth = 1.0
        btn_PayMethod.layer.borderColor = UIColor.black.cgColor
        btn_PayMethod.layer.cornerRadius = 5.0
        btn_PayMethod.layer.masksToBounds = true
        
        vw_HeaderView = tbl_Main.tableHeaderView
        tbl_Main.tableHeaderView = nil
        con_BottomViewHeight.constant = 0
        
        //Demo data
//        let obj = CheckoutObject ()
//        obj.int_Title_Sort = 0
//        arr_Product.add(obj)
//        arr_Product.add(obj)
//        arr_Product.add(obj)
        
    }
    func completedServiceCalling(){
        //Comman fuction action
        bool_Load = false
    }
    func manageView(){
        
        //TableView manage
        if arr_Product.count != 0 {
            tbl_Main.tableHeaderView = vw_HeaderView
            con_BottomViewHeight.constant = 85
            
            //Title Set
            lbl_ShippingTitle.text = obj_CheckOutDetail.primary_Address_Title as String;
        }else{
            tbl_Main.tableHeaderView = nil
            con_BottomViewHeight.constant = 0
        }
    }
    func manageOrderTotal(){

    }

    func selectDefulatValueForColorSelection(objGet : CheckoutObject){
        let arr_Color: NSMutableArray = objGet.arr_ColorSelect
        for i in (0..<arr_Color.count) {
            let obj : ProductObject = arr_Color[i] as! ProductObject
            
            if (obj.str_ColorName as String) as String == objGet.product_Color as String {
                let arr_ColorSub: NSMutableArray = obj.arr_ColorSize
                if arr_ColorSub.count != 0 {
                    
                    //First match data available than value continue other wise set default value
                    var bool_Key : Bool = false
                    var bool_Value : Bool = false
                    for j in (0..<arr_ColorSub.count) {
                        let obj2 : ProductObject = arr_ColorSub[j] as! ProductObject
                        
                        if objGet.product_Size as String  == obj2.str_ColorKey as String {
                            bool_Key = true
                            
                            if Int(objGet.product_Quantity as String)! <= Int((obj2.str_ColorValue as String) as String)! {
                                bool_Value = true
                            }
                            break
                        }
                    }
                    
                    
                    let obj2 : ProductObject = arr_ColorSub[0] as! ProductObject
                    if bool_Key == false{
                        objGet.product_Size = obj2.str_ColorKey as String as NSString
                    }
                    
                    if bool_Value == false{
                        if obj2.str_ColorValue == "0"{
                            objGet.product_Quantity = "0"
                        }else{
                            objGet.product_Quantity = "1"
                        }
                    }
                }
                break
            }
        }
    }
    func makePurchaseArray() -> NSMutableArray{
        var dict_Sub : NSDictionary =  NSDictionary()
        
        let arr_ProductTemp : NSMutableArray = []
        for count in (0..<arr_Product.count){
            let obj = arr_Product[count] as! CheckoutObject
            
            let prizeShipping = Double(obj.product_Shipping_Charge_Product as String)! * Double(obj.product_Quantity as String)!
            let prizeShipping2 = prizeShipping + Double(obj.product_Shipping_Charge as String)!
            
            let prizeValue = Double(obj.product_Product_Prize as String)! * Double(obj.product_Quantity as String)!
            
            let totalAmount = prizeValue + prizeShipping2
            
            dict_Sub =  NSDictionary()
            
            dict_Sub = [
                "productid" : obj.product_Productid as String,
                "quantity" : obj.product_Quantity as String,
//                "color" : obj.product_Color as String,
//                "size" : obj.product_Size as String,
                "cart_id" : obj.product_Cartid,
                "shipping_charge" :String(prizeShipping2),
                "price_per_product" :String(prizeValue),
                "total_product_amount" :String(totalAmount),
            ]

            arr_ProductTemp.add(dict_Sub)
        }
        return arr_ProductTemp
    }
    func totalGet (type : NSString) -> NSString{
        var double_ShippingCharge : Double = 0
        var double_SubTotal : Double = 0
        
        for i in (0..<arr_Product.count){
            let obj : CheckoutObject = arr_Product[i] as! CheckoutObject
            
            //Shipping Charge calulateion
            let prizeShipping = Double(obj.product_Shipping_Charge_Product as String)! * Double(obj.product_Quantity as String)!
            let prizeShipping2 = prizeShipping + Double(obj.product_Shipping_Charge as String)!
            double_ShippingCharge = double_ShippingCharge + prizeShipping2
            
            ///Prize Calculate For product
            var prizeValue = Double(obj.product_Product_Prize as String)! * Double(obj.product_Quantity as String)!
            
            if obj.arr_Random_BookStock.count != 0{
                for i in 0..<obj.arr_Random_1.count{
                    let str = (obj.arr_Random_1[i] as! String).capitalized
                    
                    
                    let dict_Temp : NSDictionary = obj.product_Array_Attrib[0] as! NSDictionary
                    let arr_Dict : NSArray = dict_Temp.allKeys as NSArray
                    
                    let str2 = (dict_Temp[arr_Dict[0] as! String] as! String).capitalized
                    
                    if str == str2{
                        var prize : Double = Double(obj.arr_Random_BookPrize[i] as! String)!
//                        prize = Double(prize) + Double(obj.product_Product_Prize as String)!
                        
                        prizeValue = prize * Double(obj.product_Quantity as String)!
                        break
                    }
                    
                }
                
            }
            
            double_SubTotal = double_SubTotal + prizeValue
            
        }
        
        //Processing
        var ProcessingFees : Double = Double(obj_CheckOutDetail.processing_percentage as String)!
        let ProcessingFees2 : Double = Double(obj_CheckOutDetail.processing_cent as String)!
        ProcessingFees = Double(ProcessingFees) * Double(double_SubTotal)
        ProcessingFees = ProcessingFees + ProcessingFees2
        
        var double_TotalValue : Double = double_SubTotal + double_ShippingCharge + ProcessingFees
        if type == "shipping" {
            return String(double_ShippingCharge) as NSString
        }else if type == "product" {
            return String(double_SubTotal) as NSString
        }else if type == "grand" {
            //If coupon cod apply than direct effect to total price
            if obj_PromocodeDiscountPrice.str_promo_id as String != "" {
                double_TotalValue = double_TotalValue - Double(obj_PromocodeDiscountPrice.str_mycalulation_discount as String)!
            }
            
            //If Reward Point than direct effect to total price
            if Float(objUser?.str_RewardPoint as! String)! >= Constant.int_Minimumvalue_Use_RewardPoint && bool_userRewardPoint == true{
                var int_DiscountPrice = Float(objUser?.str_RewardPoint as! String)!/Constant.int_ReasionofRewardPointAndDollar
                double_TotalValue = double_TotalValue - Double(int_DiscountPrice)
            }
            
            if obj_GiftVoucherDiscountPrice.str_voucher_amount as String != "" {
                double_TotalValue = double_TotalValue - Double(obj_GiftVoucherDiscountPrice.str_voucher_amount as String)!
            }
            
            if double_TotalValue < 0 {
                double_TotalValue = 0
            }
            
            return String(double_TotalValue) as NSString
        }else if type == "grandwithoutCoupon" {
            
            return String(Int(double_TotalValue)) as NSString
            
        }else if type == "rewardPoint" {
            if totalGet(type : "pointuse") == ""{
                //If coupon cod apply than direct effect to total price
                if obj_PromocodeDiscountPrice.str_promo_id as String != "" {
                    double_TotalValue = double_TotalValue - Double(obj_PromocodeDiscountPrice.str_mycalulation_discount as String)!
                }
                
                //If Reward Point than direct effect to total price
                if Float(objUser?.str_RewardPoint as! String)! >= Constant.int_Minimumvalue_Use_RewardPoint && bool_userRewardPoint == true{
                    var int_DiscountPrice = Float(objUser?.str_RewardPoint as! String)!/Constant.int_ReasionofRewardPointAndDollar
                    double_TotalValue = double_TotalValue - Double(int_DiscountPrice)
                }
                
                if obj_GiftVoucherDiscountPrice.str_voucher_amount as String != "" {
                    double_TotalValue = double_TotalValue - Double(obj_GiftVoucherDiscountPrice.str_voucher_amount as String)!
                }
                
                if double_TotalValue < 0 {
                    double_TotalValue = -double_TotalValue
                }else{
                    double_TotalValue = 0
                }
                
                return String(double_TotalValue) as NSString
            }else{
                return ""
            }
        }else if type == "pointuse"{
            //If Reward Point than direct effect to total price
            if Float(objUser?.str_RewardPoint as! String)! >= Constant.int_Minimumvalue_Use_RewardPoint && bool_userRewardPoint == true{
                
                //If coupon cod apply than direct effect to total price
                if obj_PromocodeDiscountPrice.str_promo_id as String != "" {
                    double_TotalValue = double_TotalValue - Double(obj_PromocodeDiscountPrice.str_mycalulation_discount as String)!
                }
                var double_TotalValueStored : Double = double_TotalValue
                
                //First check if total value not going 0 when use reward point than return all reward point use
                //1....If Reward Point than direct effect to total price
                if Float(objUser?.str_RewardPoint as! String)! >= Constant.int_Minimumvalue_Use_RewardPoint{
                    var int_DiscountPrice = Float(objUser?.str_RewardPoint as! String)!/Constant.int_ReasionofRewardPointAndDollar
                    double_TotalValue = double_TotalValue - Double(int_DiscountPrice)
                }
                
                if double_TotalValue > -1 {
                    
                    return objUser?.str_RewardPoint as! String as NSString
                }else{
                
                //2....Remaiing total * int_Minimumvalue_Use_RewardPoint
                    
                    var doubleRemaining = double_TotalValueStored * 10
                    return String(doubleRemaining) as NSString
                }
            }
            return ""
        }else if type == "processingfees"{
            return String(ProcessingFees) as NSString
        }
        
        return ""
    }
    func paymentDescription () -> NSString{
        var str_Description : NSString = ""
        for count in (0..<arr_Product.count){
            let obj = arr_Product[count] as! CheckoutObject
           
            let prizeShipping = Double(obj.product_Shipping_Charge_Product as String)! * Double(obj.product_Quantity as String)!
            let prizeShipping2 = prizeShipping + Double(obj.product_Shipping_Charge as String)!
            
            var prizeValue = Double(obj.product_Product_Prize as String)! * Double(obj.product_Quantity as String)!
            
            if obj.arr_Random_BookStock.count != 0{
                for i in 0..<obj.arr_Random_1.count{
                    let str = (obj.arr_Random_1[i] as! String).capitalized
                    
                    
                    let dict_Temp : NSDictionary = obj.product_Array_Attrib[0] as! NSDictionary
                    let arr_Dict : NSArray = dict_Temp.allKeys as NSArray
                    
                    let str2 = (dict_Temp[arr_Dict[0] as! String] as! String).capitalized
                    
                    if str == str2{
                        var prize : Double = Double(obj.arr_Random_BookPrize[i] as! String)!
//                        prize = Double(prize) + Double(obj.product_Product_Prize as String)!
                        
                        prizeValue = prize * Double(obj.product_Quantity as String)!
                        break
                    }
                    
                }
            }
            
            
            let totalAmount = prizeValue + prizeShipping2
            
            str_Description = ("\(str_Description)\(obj.product_Product_Title)" as NSString)
            str_Description = ("\n\(str_Description)\nProduct Total : $\(String(totalAmount))\n\n" as NSString)
            
        }
        return str_Description
    }
    func paymentDescriptionWithArray () -> Array<Any>{
        var array_Data : NSMutableArray = []
        var str_Description : NSString = ""
        
        for count in (0..<arr_Product.count){
            let obj = arr_Product[count] as! CheckoutObject
            
            let prizeShipping = Double(obj.product_Shipping_Charge_Product as String)! * Double(obj.product_Quantity as String)!
            let prizeShipping2 = prizeShipping + Double(obj.product_Shipping_Charge as String)!
            
            let prizeValue = Double(obj.product_Product_Prize as String)! * Double(obj.product_Quantity as String)!
            
            let totalAmount = prizeValue + prizeShipping2
            
//            str_Description = ("\(str_Description)\(obj.product_Product_Title)" as NSString)
//            str_Description = ("\n\(str_Description)\nProduct Total : \(String(totalAmount))\n\n" as NSString)
            
            array_Data.add(PKPaymentSummaryItem(label: obj.product_Product_Title as String, amount: NSDecimalNumber(string: String(totalAmount))))
            
        }
        
        return (array_Data as NSArray) as! Array<Any>
    }
    
    func removeAppyPromocode(){
        obj_PromocodeDiscountPrice = PromocodeObject ()
        tbl_Main.reloadData()
    }
    func couponDataGet (type : NSString) -> NSString{
        
       if obj_PromocodeDiscountPrice.str_promo_id as String != "" {
            if type == "id" {
                return obj_PromocodeDiscountPrice.str_promo_id as String as NSString
            }else if type == "code" {
                return obj_PromocodeDiscountPrice.str_promocode as String as NSString
            }else if type == "amount" {
                return obj_PromocodeDiscountPrice.str_mycalulation_discount as String as NSString
            }
        }
        
        return ""
    }
    func GiftDataDataGet (type : NSString) -> NSString{
        
        if obj_GiftVoucherDiscountPrice.str_voucher_id as String != "" {
            if type == "id" {
                return obj_GiftVoucherDiscountPrice.str_voucher_id as String as NSString
            }else if type == "code" {
                return obj_GiftVoucherDiscountPrice.str_voucher_code as String as NSString
            }else if type == "amount" {
                return obj_GiftVoucherDiscountPrice.str_voucher_amount as String as NSString
            }
        }
        
        return ""
    }
    func manageNavigation(){
        
        let titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 150, height: 28))
        titleView.contentMode = .scaleAspectFit
        titleView.image = UIImage(named: "katikaTextNavigation")
        
        self.navigationItem.titleView = titleView
        
    }
    
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_Pay (_ sender : Any){
        if lbl_ShippingTitle.text == "" {
            //Alert show for Header
            messageBar.MessageShow(title: "Please select shipping address.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else{
//            var str_Value : String = totalGet(type : "grand") as! String
//            if str_Value != "0.0"{
//                self.Get_Token()
//            }else{
            if obj_CheckOutDetail.str_Card_id == ""{
                messageBar.MessageShow(title: "Please add card.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }else{
                self.Post_PaymentDetail(id:"")
            }
//            }
        }
    }
    @IBAction func btn_PayMethod(_ sender : Any){
        
    }
    @IBAction func btn_USPSType(_ sender : Any){
    
    }
    
    @IBAction func btnMoreImfoCloseClicked(_ sender: Any) {
        //SET MORE INFO VIEW
        viewMoreInfo.isHidden = true
        
    }
    
    @IBAction func btnItem2MoreClicked (_ sender : Any){
        let obj : CheckoutObject = arr_Product[(sender as AnyObject).tag] as! CheckoutObject
        
        //SET MORE INFO VIEW
        viewMoreInfo.isHidden = false
        
        //SET TILE FONT
        lblMoreInfo1.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 16)/Constant.screenWidthDeveloper))
        lblMoreInfo2.font = UIFont(name: Constant.kFontSemiBold, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))
        lblMoreInfo3.font = UIFont(name: Constant.kFontSemiBold, size: CGFloat((Constant.windowWidth * 16)/Constant.screenWidthDeveloper))
        lblMoreInfo4.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 16)/Constant.screenWidthDeveloper))
        lblMoreInfo5.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 16)/Constant.screenWidthDeveloper))
        lblMoreInfo6.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 16)/Constant.screenWidthDeveloper))
        lblMoreInfo7.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))

        //SET DETAISL
        lblMoreInfo1.text = obj.product_Product_Title as String
        lblMoreInfo2.text = obj.product_Product_Categoryname as String
//        lblMoreInfo3.text = ("Color:\(obj.product_Color as String)")
        lblMoreInfo4.text = obj.product_ReturnOrNot as String
        lblMoreInfo5.text = "Quantity : \(obj.product_Quantity as String)"
        
        //Shipping Charge calulateion
        let prizeShipping = Double(obj.product_Shipping_Charge_Product as String)! * Double(obj.product_Quantity as String)!
        let prizeShipping2 = prizeShipping + Double(obj.product_Shipping_Charge as String)!
        let str_prizeShipping2 = String(format: "%.2f", arguments: [prizeShipping2])
        lblMoreInfo6.text = ("Shipping Standard Shipping (\(obj.product_Product_PrizeSymbol)\(str_prizeShipping2))")
        lblMoreInfo7.text = obj.product_Shipping_EstimateDelivary as String

        
        //SET COLOR
        var StrValue = String()
        for i in 0..<obj.product_Array_Attrib.count{
            let dict_Temp : NSDictionary = obj.product_Array_Attrib[i] as! NSDictionary
            let arr_Dict : NSArray = dict_Temp.allKeys as NSArray
            switch i {
            case 0:
                StrValue = (arr_Dict[0] as! String).capitalized
                StrValue = "\(StrValue) \(":") \(dict_Temp[arr_Dict[0] as! String] as! String)"
                break
            case 1:
                StrValue = "\(StrValue)\n\((arr_Dict[0] as! String).capitalized)"
                StrValue = "\(StrValue) \(":") \(dict_Temp[arr_Dict[0] as! String] as! String)"
                break
            case 2:
                StrValue = "\(StrValue)\n\((arr_Dict[0] as! String).capitalized)"
                StrValue = "\(StrValue) \(":") \(dict_Temp[arr_Dict[0] as! String] as! String)"
                break
            default:
                break
            }
        }
        
        lblMoreInfo3.text = StrValue

    }
    @IBAction func btn_AddProduct_Product(_ sender : Any){
        
        let obj : CheckoutObject = arr_Product[(sender as AnyObject).tag] as! CheckoutObject
        
        var int_Sun : Int = Int(obj.product_Stock_Remain as String)!
        print(int_Sun)
        print( Int(obj.product_Quantity as String)! + 1)
        if int_Sun >= Int(obj.product_Quantity as String)! + 1 {
            let int_Count = Int(obj.product_Quantity as String)! + 1
            obj.product_Quantity = String(int_Count) as NSString

            arr_Product[(sender as AnyObject).tag] = obj
            
            var indexPath = IndexPath(item: (sender as AnyObject).tag, section: 0)
            tbl_Main.reloadRows(at: [indexPath], with: .none)
            indexPath = IndexPath(item: 0, section: 1)
            tbl_Main.reloadRows(at: [indexPath], with: .none)
            
            Post_UpdateCart(obj : obj)
        }else{
            //Alert show for Header
            messageBar.MessageShow(title: "Maximum limit reached", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }
    }
    @IBAction func btn_SubstractProduct_Product(_ sender : Any){
      
        let obj : CheckoutObject = arr_Product[(sender as AnyObject).tag] as! CheckoutObject
        let int_Count = Int(obj.product_Quantity as String)! - 1
        
        if int_Count != 0 {
            obj.product_Quantity = String(int_Count) as NSString
            arr_Product[(sender as AnyObject).tag] = obj
            
            var indexPath = IndexPath(item: (sender as AnyObject).tag, section: 0)
            tbl_Main.reloadRows(at: [indexPath], with: .none)
            indexPath = IndexPath(item: 0, section: 1)
            tbl_Main.reloadRows(at: [indexPath], with: .none)

            Post_UpdateCart(obj : obj)
        }else{
            
        }
    }
    @IBAction func btn_RemoveProduct(_ sender : Any){
        let obj = arr_Product[(sender as AnyObject).tag] as! CheckoutObject
        
        self.Post_RemoveCart(cartId : obj.product_Cartid as String)
    }
    @IBAction func btn_ColorChange(_ sender : Any){
        let objSave : CheckoutObject = arr_Product[(sender as AnyObject).tag] as! CheckoutObject

        //Color set
        var arr_Data2: [Any] = []
        let arr_Color: NSMutableArray = objSave.arr_ColorSelect
        for i in (0..<arr_Color.count) {
            let obj : ProductObject = arr_Color[i] as! ProductObject
            arr_Data2.append(obj.str_ColorName)
        }
        
        let picker = ActionSheetStringPicker(title: "COLOR", rows: arr_Data2, initialSelection:selectedIndex(arr: arr_Data2 as NSArray, value: objSave.product_Color as String as NSString), doneBlock: { (picker, indexes, values) in
            objSave.product_Color = values as! String? as! NSString
            
            self.selectDefulatValueForColorSelection(objGet: objSave)
            
            self.arr_Product[(sender as AnyObject).tag] = objSave
            
            //Reload Table
            let indexPath = IndexPath(item: (sender as AnyObject).tag, section: 0)
            self.tbl_Main.reloadRows(at: [indexPath], with: .none)


            //Update Product
            self.Post_UpdateCart(obj : objSave)
            
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
        picker?.hideCancel = true
        // picker?.hideWithCancelAction()
        picker?.setDoneButton(UIBarButtonItem(title: "DONE", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
        
    }
    
    @IBAction func btn_SizeChange(_ sender : Any){
        let objSave : CheckoutObject = arr_Product[(sender as AnyObject).tag] as! CheckoutObject
        
        //Color set
        var arr_Data2: [Any] = []
        let arr_Color: NSMutableArray = objSave.arr_ColorSelect
        for i in (0..<arr_Color.count) {
            let obj : ProductObject = arr_Color[i] as! ProductObject
            
            if obj.str_ColorName as String == objSave.product_Color as String {
                let arr_ColorSub: NSMutableArray = obj.arr_ColorSize
                for j in (0..<arr_ColorSub.count) {
                    let obj2 : ProductObject = arr_ColorSub[j] as! ProductObject
                    arr_Data2.append(obj2.str_ColorKey)
                }
            }
        }
        
        let picker = ActionSheetStringPicker(title: "SIZE", rows: arr_Data2, initialSelection:selectedIndex(arr: arr_Data2 as NSArray, value: objSave.product_Size as String as NSString), doneBlock: { (picker, indexes, values) in
            
            objSave.product_Size = values as! String? as! NSString

            self.selectDefulatValueForColorSelection(objGet: objSave)
            
            self.arr_Product[(sender as AnyObject).tag] = objSave
            
            //Reload Table
            let indexPath = IndexPath(item: (sender as AnyObject).tag, section: 0)
            self.tbl_Main.reloadRows(at: [indexPath], with: .none)
            
            //Update Product
            self.Post_UpdateCart(obj : objSave)
            
        }, cancel: {ActionSheetStringPicker in return}, origin: sender)
        
        picker?.hideCancel = true
        picker?.setDoneButton(UIBarButtonItem(title: "DONE", style: .plain, target: nil, action: nil))
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
        
    }
    
    @IBAction func btn_ProductDetail(_ sender : Any){
        let objSave : CheckoutObject = arr_Product[(sender as AnyObject).tag] as! CheckoutObject
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        view.str_ProductIDGet = objSave.product_Productid
        self.navigationController?.pushViewController(view, animated: false)
    }
    
    @IBAction func btn_ShippingAddressSelect(_ sender : Any){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ShippingAddressViewController") as! ShippingAddressViewController
        view.bool_ComefromCheckout = false
        self.navigationController?.pushViewController(view, animated: false)
    }
    
    @IBAction func btn_UserInstePoint (_ sender : Any){
        //User reward Point
        let alert = UIAlertController(title: Constant.appName, message: "Are you sure want to use your reward points?\n\nReward point rules\n1. 1$ = 10 Reward Point.\n2. Mininum 250 point required to use.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Use Reward Point", style: UIAlertAction.Style.default, handler: { (action) in
            
            self.bool_userRewardPoint = true
            self.tbl_Main.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: - Get/Post Method -
    func Post_cardListing(){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)cart_listing"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "cart_listing"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
    func Post_RemoveCart(cartId : String){
        //Declaration URL
        let strURL = "\(Constant.BaseURL)remove_cart"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "cartid" : cartId,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "remove_cart"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
    func Post_UpdateCart(obj : CheckoutObject){
        bool_Load = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)update_cart"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "cartid" :obj.product_Cartid as String,
            "product_id" : obj.product_Productid as String,
            "quantity" : obj.product_Quantity as String,
            "color" : obj.product_Color as String,
            "size" : obj.product_Size as String,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "update_cart"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
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
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
    }
    
    
    func Post_PaymentDetail(id : NSString){
        //Declaration URL
//        let strURL = "\(Constant.BaseURL)PurchasePayment_new"
        let strURL = "\(Constant.BaseURL)purchasePaymentStripe"

        let arr_Data = makePurchaseArray()
        let string = notPrettyString(from : arr_Data)

        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "buyer_id" : (objUser?.str_Userid as! String),
            "customerid" : (objUser?.str_CheckoutTocken as! String),
            "noncefromtheclient" : id,
            "shipping_address_id" :obj_CheckOutDetail.primary_Address_Id as String,
            "Shipping_charge_total" : totalGet(type : "shipping"),
            "Product_price_total" : totalGet(type : "product"),
            "Grand_total" : totalGet(type : "grand"),
            "Product_incart" : string as! String,
            "promo_id" : couponDataGet(type : "id"),
            "promo_code" : couponDataGet(type : "code"),
            "promo_amount" : couponDataGet(type : "amount"),
            "gift_voucher_id" : GiftDataDataGet(type : "id"),
            "gift_voucher_code" : GiftDataDataGet(type : "code"),
            "gift_voucher_amount" : GiftDataDataGet(type : "amount"),
            "reward_points_read" : totalGet(type : "pointuse"),
            "gift_voucher_reward" : totalGet(type : "rewardPoint"),
            "proccessing_fees" : totalGet(type : "processingfees"),
        ]
        
//        print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "PurchasePayment"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "promocode"{

            let view : PromoCodeViewController = segue.destination as! PromoCodeViewController
            view.str_GrandTotal = totalGet(type : "grandwithoutCoupon")
        }
        
        //
    }
    

}


//MARK: - Checkout Object -

class CheckoutObject: NSObject {
    
    //Product listing Other
    var int_Title_Sort : Int = 0
    
    //Shipping Address
    var primary_Address_Title : NSString = ""
    var primary_Address_Id : NSString = ""
    
    //Processing
    var processing_percentage : NSString = ""
    var processing_cent : NSString = ""
    
    //Product Detail
    var product_Cartid : NSString = ""
    var product_Productid : NSString = ""
    var product_Quantity : NSString = ""
    var product_Size : NSString = ""
    var product_Color : NSString = ""
    var product_Attrib : NSString = ""
    var product_Array_Attrib : NSArray = []
    var product_Datetime : NSString = ""
    var product_Shipping_Charge : NSString = ""
    var product_Shipping_Charge_Product : NSString = ""
    var product_Shipping_EstimateDelivary : NSString = ""
    var product_Stock_Remain : NSString = ""
    var product_Is_stock_available : NSString = ""
    var product_ProductCategoryID : NSString = ""
   
    var product_Product_Title : NSString = ""
    var product_Product_Info : NSString = ""
    var product_Shipping_Return : NSString = ""
    var product_ReturnOrNot : NSString = ""
    var product_ProductVideo : NSString = ""
    var product_Product_Description : NSString = ""
    var product_Product_Prize : NSString = ""
    var product_Product_DiscountPrice : NSString = ""
    var product_Product_ShopId : NSString = ""
    var product_Product_Site : NSString = ""
    var product_Product_ShopName : NSString = ""
    var product_Product_PrizeSymbol : NSString = ""
    var product_Product_Image : NSString = ""
    var product_Product_Categoryname : NSString = ""
    
    
    //Color
    var arr_ColorSelect : NSMutableArray = []
    var str_ColorName : NSString = ""
    var str_ColorKey : NSString = ""
    var str_ColorValue : NSString = ""
    var arr_ColorSize : NSMutableArray = []
    
    
    //Random Selection Option
    var str_Random_Title : NSString = ""
    var str_Random_Description : NSString = ""
    var arr_Random_1 : NSMutableArray = []
    var arr_Random_2 : NSMutableArray = []
    var arr_Random_3 : NSMutableArray = []
    var arr_Random_Key : NSArray = []
    var arr_Random_BookPrize : NSMutableArray = []
    var arr_Random_BookStock : NSMutableArray = []
    
    //Card detail
    var str_Card_id : NSString = ""
    var str_Card_brand : NSString = ""
    var str_Card_country : NSString = ""
    var str_Card_exp_month : NSString = ""
    var str_Card_exp_year : NSString = ""
    var str_Card_elast4 : NSString = ""
}
// MARK: - Tableview Files -
extension CheckoutViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if arr_Product.count == 0{
            if bool_Load == true {
                return 0
            }
            return 1
        }
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if arr_Product.count == 0 {
            return 0
        }
        
        if section == 0 {
            return 0
        } else if section == 1 {
            return 40
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arr_Product.count == 0{
            if bool_Load == true{
                return 0
            }else{
                return 50
            }
        }
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr_Product.count == 0 {
            if bool_Load == true{
                return 0
            }
            return 1
        }
        
        if tableView == tbl_Main {
            if section == 0 {
                return arr_Product.count
            } else if section == 1 {
                return 1
            }else if section == 2 {
                return 3
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "section")as! CheckoutviewCell
        
           cell.backgroundColor = UIColor.init(colorLiteralRed: 242/256, green: 242/256, blue: 242/256, alpha: 1.0)
        
            switch section {
            case 0:
                cell.backgroundColor = UIColor.white
                cell.lbl_Title.text = "Estimated Delivery: 3/17/17 - 3/23/17"
                break
            case 1:
                cell.lbl_Title.text = "ORDER SUMMARY"
                break
            default:
                cell.lbl_Title.text = ""
                break
            }
            return cell;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var str_CellIdentifier : NSString = "cell"
        
        if indexPath.section == 0 {
            //Total summery data
            str_CellIdentifier = "items2"
        }
        else if indexPath.section == 1 {
            //Total summery data
            str_CellIdentifier = "total"
        }
        else if indexPath.section == 2 {
            //Coupon and gift cell
            str_CellIdentifier = "couponcodeandgift"
        }
        
        if arr_Product.count == 0{
            str_CellIdentifier = "nodata"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: str_CellIdentifier as String, for:indexPath as IndexPath) as! CheckoutviewCell
        
        if arr_Product.count != 0{
            if indexPath.section == 0 {
                //Product Cell
                //18
                
                let obj = arr_Product[indexPath.row] as! CheckoutObject
                
                //Value Set
                cell.img_ProductImage_Product.sd_setImage(with: URL(string: obj.product_Product_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
               
                cell.lbl_Title.text = obj.product_Product_Title as String
                cell.lbl_Name_Product.text = obj.product_Product_Categoryname as String
                cell.lbl_Color_Product.text = ("Color:\(obj.product_Color as String)")
                cell.lbl_Size_Product.text = (" |   Size:\(obj.product_Size as String)")
                cell.lbl_ReturnOrNot_Product.text = obj.product_ReturnOrNot as String
                cell.lbl_NumberofProduct_Product.text = obj.product_Quantity as String
                cell.lbl_ShippingDayToDelavary.text = obj.product_Shipping_EstimateDelivary as String

                if cell.vw_Selection1 != nil{
                   cell.vw_Selection1.isHidden = true
                }
                if cell.vw_Selection2 != nil{
                    cell.vw_Selection2.isHidden = true
                    if obj.product_Array_Attrib.count == 1{
                        cell.vw_Selection2.removeFromSuperview()
                    }
                }
                if cell.vw_Selection3 != nil{
                    cell.vw_Selection3.isHidden = true
                    if obj.product_Array_Attrib.count == 2{
                        cell.vw_Selection3.removeFromSuperview()
                    }
                }
                
                //manage global value
                for i in 0..<obj.product_Array_Attrib.count{
                    let dict_Temp : NSDictionary = obj.product_Array_Attrib[i] as! NSDictionary
                    let arr_Dict : NSArray = dict_Temp.allKeys as NSArray
                    switch i {
                    case 0:
                        cell.lbl_SelectionTitle1.text = (arr_Dict[0] as! String).capitalized
                        cell.lbl_SelectionAns1.text = dict_Temp[arr_Dict[0] as! String] as! String
                        cell.vw_Selection1.isHidden = false
                        break
                    case 1:
                        cell.lbl_SelectionTitle2.text = (arr_Dict[0] as! String).capitalized
                        cell.lbl_SelectionAns2.text = dict_Temp[arr_Dict[0] as! String] as! String
                        cell.vw_Selection2.isHidden = false
                        break
                    case 2:
                        cell.lbl_SelectionTitle3.text = (arr_Dict[0] as! String).capitalized
                        cell.lbl_SelectionAns3.text = dict_Temp[arr_Dict[0] as! String] as! String
                        cell.vw_Selection3.isHidden = false
                        break
                    default:
                        break
                    }
                }
                
                
                //Shipping Charge calulateion
                let prizeShipping = Double(obj.product_Shipping_Charge_Product as String)! * Double(obj.product_Quantity as String)!
                let prizeShipping2 = prizeShipping + Double(obj.product_Shipping_Charge as String)!
                let str_prizeShipping2 = String(format: "%.2f", arguments: [prizeShipping2])
                cell.lbl_ShippingCharge.text = ("Shipping Standard Shipping (\(obj.product_Product_PrizeSymbol)\(str_prizeShipping2))")
                
                
                ///Prize Calculate For product
                var prizeValue = Double(obj.product_Product_Prize as String)! * Double(obj.product_Quantity as String)!
                if obj.arr_Random_BookStock.count != 0{
                    prizeValue = 0
                    for i in 0..<obj.arr_Random_1.count{
                        let str = (obj.arr_Random_1[i] as! String).capitalized
                        
                        
                        let dict_Temp : NSDictionary = obj.product_Array_Attrib[0] as! NSDictionary
                        let arr_Dict : NSArray = dict_Temp.allKeys as NSArray
                        
                        let str2 = (dict_Temp[arr_Dict[0] as! String] as! String).capitalized
                        
                        if str == str2{
                            var prize : Double = Double(obj.arr_Random_BookPrize[i] as! String)!
//                            prize = Double(prize) + Double(obj.product_Product_Prize as String)!
                            
                            prizeValue = prize * Double(obj.product_Quantity as String)!
                            break
                        }
                    }
                }
                
                let str_prizeValue = String(format: "%.2f", arguments: [prizeValue])
                cell.lbl_Prize_Product.text = ("\(obj.product_Product_PrizeSymbol)\(str_prizeValue)")
                //product_Product_Prize
 
                cell.btn_AddProduct_Product.tag = indexPath.row
                cell.btn_SubstractProduct_Product.tag = indexPath.row
                cell.btn_RemoveProduct.tag = indexPath.row
                cell.btn_ColorChange.tag = indexPath.row
                cell.btn_SizeChange.tag = indexPath.row
               // cell.btnItem1MoreClicked.tag = indexPath.row
                cell.btnItem2MoreClicked.tag = indexPath.row
                cell.btnItem2MoreClicked.addTarget(self, action: #selector(btnItem2MoreClicked ), for: .touchUpInside)
                cell.btn_AddProduct_Product.addTarget(self, action: #selector(btn_AddProduct_Product), for: .touchUpInside)
                cell.btn_SubstractProduct_Product.addTarget(self, action: #selector(btn_SubstractProduct_Product), for: .touchUpInside)
                cell.btn_RemoveProduct.addTarget(self, action: #selector(btn_RemoveProduct), for: .touchUpInside)
                cell.btn_ColorChange.addTarget(self, action: #selector(btn_ColorChange), for: .touchUpInside)
                cell.btn_SizeChange.addTarget(self, action: #selector(btn_SizeChange), for: .touchUpInside)
                cell.btn_ProductDetail.addTarget(self, action: #selector(btn_ProductDetail), for: .touchUpInside)
                
                //Manage category
                if obj.product_ProductCategoryID == "4"{
                    cell.lbl_Size_Product.isHidden = true
                    cell.btn_SizeChange.isHidden = true
                }else{
                    cell.lbl_Size_Product.isHidden = false
                    cell.btn_SizeChange.isHidden = false
                }
                
                //Set font size and font name in title
                cell.lbl_SelectionTitle1.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 10)/Constant.screenWidthDeveloper))
                cell.lbl_SelectionTitle2.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 10)/Constant.screenWidthDeveloper))
                cell.lbl_SelectionTitle3.font = UIFont(name: Constant.kFontLight, size: CGFloat((Constant.windowWidth * 10)/Constant.screenWidthDeveloper))
                cell.lbl_SelectionAns1.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 10)/Constant.screenWidthDeveloper))
                cell.lbl_SelectionAns2.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 10)/Constant.screenWidthDeveloper))
                cell.lbl_SelectionAns3.font = UIFont(name: Constant.kFontRegular, size: CGFloat((Constant.windowWidth * 10)/Constant.screenWidthDeveloper))
          
            }else if indexPath.section == 1 {
                //Total summery data
                
                var double_ShippingCharge : Double = 0.00
                var double_SubTotal : Double = 0.00
                var string_Symbol : String = ""
                
                for i in (0..<arr_Product.count){
                    let obj : CheckoutObject = arr_Product[i] as! CheckoutObject
                    
                    //Shipping Charge calulateion
                    let prizeShipping = Double(obj.product_Shipping_Charge_Product as String)! * Double(obj.product_Quantity as String)!
                    let prizeShipping2 = prizeShipping + Double(obj.product_Shipping_Charge as String)!
                    double_ShippingCharge = double_ShippingCharge + prizeShipping2
                    
                    ///Prize Calculate For product
                    var prizeValue = Double(obj.product_Product_Prize as String)! * Double(obj.product_Quantity as String)!
                    
                    if obj.arr_Random_BookStock.count != 0{
                        for i in 0..<obj.arr_Random_1.count{
                            let str = (obj.arr_Random_1[i] as! String).capitalized
                            
                            
                            let dict_Temp : NSDictionary = obj.product_Array_Attrib[0] as! NSDictionary
                            let arr_Dict : NSArray = dict_Temp.allKeys as NSArray
                            
                            let str2 = (dict_Temp[arr_Dict[0] as! String] as! String).capitalized
                            
                            if str == str2{
                                var prize : Double = Double(obj.arr_Random_BookPrize[i] as! String)!
//                                prize = Double(prize) + Double(obj.product_Product_Prize as String)!
                                
                                prizeValue = prize * Double(obj.product_Quantity as String)!
                                break
                            }
                        }
                    }
                    
                    
                    
                    
                    double_SubTotal = double_SubTotal + prizeValue
                    
                    string_Symbol = obj.product_Product_PrizeSymbol as String
                }
                
                let str_SubTotal = String(format: "%.2f", arguments: [double_SubTotal])
                let str_ShippingCharge = String(format: "%.2f", arguments: [double_ShippingCharge])
                
                cell.lbl_OrderSubtotal_Value.text = ("\(string_Symbol)\(str_SubTotal)")
                cell.lbl_OrderShipping_Value.text = ("\(string_Symbol)\(str_ShippingCharge)")
                
                //Processing
                var ProcessingFees : Double = Double(obj_CheckOutDetail.processing_percentage as String)!
                let ProcessingFees2 : Double = Double(obj_CheckOutDetail.processing_cent as String)!
                ProcessingFees = Double(ProcessingFees) * Double(str_SubTotal)!
//                ProcessingFees = ProcessingFees + ProcessingFees2
                
                let str_Processing = String(format: "%.2f", arguments: [ProcessingFees])
                cell.lbl_OrderProcessing.text =  ("\(string_Symbol)\(str_Processing)")
                
                var double_TotalValue : Double = double_SubTotal + double_ShippingCharge + ProcessingFees
                
                let str_TotalValue = String(format: "%.2f", arguments: [double_TotalValue])
                cell.lbl_Total_Value.text = ("\(string_Symbol)\(str_TotalValue)")
                
                //If coupon cod apply than direct effect to total price
                if obj_PromocodeDiscountPrice.str_promo_id as String != "" {
                    double_TotalValue = double_TotalValue - Double(obj_PromocodeDiscountPrice.str_mycalulation_discount as String)!
                }
                
                if Float(objUser?.str_RewardPoint as! String)! >= Constant.int_Minimumvalue_Use_RewardPoint && bool_userRewardPoint == true{
                    var int_DiscountPrice = Float(objUser?.str_RewardPoint as! String)!/Constant.int_ReasionofRewardPointAndDollar
                    double_TotalValue = double_TotalValue - Double(int_DiscountPrice)
                }
                
                //If gift coupon apply than remove it
                if obj_GiftVoucherDiscountPrice.str_voucher_id as String != ""  {
                    double_TotalValue = double_TotalValue - Double(obj_GiftVoucherDiscountPrice.str_voucher_amount as String)!
                }
                
                //Manage - value
                if double_TotalValue < 0 {
                    double_TotalValue = 0
                }
                
                let text = String(format: "%.2f", arguments: [double_TotalValue])
                lbl_Total_Payment.text = ("Total: \(string_Symbol)\(text)")
                
                //Reward point listing And codition for reward point user or not
                if Int(objUser?.str_RewardPoint as! String) == 0{
                    cell.btn_InsitePoint.setTitle("Sorry! You do no have any points yet.",for:.normal)
                }else{
                    cell.btn_InsitePoint.setTitle("Insider Point Value: \(objUser?.str_RewardPoint as! String)",for:.normal)
                }
                if bool_userRewardPoint == true{
                    cell.btn_UserInstePoint.isHidden = true
                }else{
                    cell.btn_UserInstePoint.isHidden = false
                }
                cell.btn_UserInstePoint.addTarget(self, action: #selector(btn_UserInstePoint), for: .touchUpInside)
                
                
                
            }else if indexPath.section == 2 {
                // For Coupon Code Gift
                switch indexPath.row {
                    
                case 0:
                    cell.lbl_Title.text = "Add card"
                    if obj_CheckOutDetail.str_Card_id != ""{
                        cell.lbl_Title.text = "***\(obj_CheckOutDetail.str_Card_elast4) \(obj_CheckOutDetail.str_Card_brand) Exp:\(obj_CheckOutDetail.str_Card_exp_month):\(obj_CheckOutDetail.str_Card_exp_year)"
                    }
                    
                    break
                case 1:
                    cell.lbl_Title.text = "Apply Promo Code"
                    if obj_PromocodeDiscountPrice.str_promo_id != "" {
                        cell.lbl_Title.text = "Promo Code Applyed : \(obj_PromocodeDiscountPrice.str_promocode as String)"
                    }
                    break
                case 2:
                    cell.lbl_Title.text = "Redeem a Gift Card"
                    if obj_GiftVoucherDiscountPrice.str_voucher_id != "" {
                        cell.lbl_Title.text = "Gift Card : \(obj_GiftVoucherDiscountPrice.str_voucher_code as String)"
                    }
               
                default:
                    cell.lbl_Title.text = ""
                    break
                }
            }
        }else{
            cell.lbl_Title.text = "Your cart is empty"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            // For Coupon Code Gift
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "cart", sender: indexPath.row)
                break
            case 1:
                self.performSegue(withIdentifier: "promocode", sender: indexPath.row)
                break
            case 2:
                self.performSegue(withIdentifier: "giftvoucher", sender: indexPath.row)
                break
            default:
                
                break
            }
        }
    }
}

//MARK: - Tableview View Cell -
class CheckoutviewCell : UITableViewCell{
    //Section Data
    @IBOutlet weak var lbl_Title: UILabel!
    
    //Total Summery cell
    @IBOutlet weak var lbl_OrderSubtotal: UILabel!
    @IBOutlet weak var lbl_OrderShipping: UILabel!
    @IBOutlet weak var lbl_Total: UILabel!
    @IBOutlet weak var lbl_OrderSubtotal_Value: UILabel!
    @IBOutlet weak var lbl_OrderProcessing: UILabel!
    @IBOutlet weak var lbl_OrderShipping_Value: UILabel!
    @IBOutlet weak var lbl_Total_Value: UILabel!
    
    @IBOutlet weak var btn_InsitePoint: UIButton!
    @IBOutlet weak var btn_UserInstePoint: UIButton!
    
    //Product Cell
    @IBOutlet weak var lbl_Category_Product: UILabel!
    @IBOutlet weak var lbl_Name_Product: UILabel!
    @IBOutlet weak var lbl_Color_Product: UILabel!
    @IBOutlet weak var lbl_Size_Product: UILabel!
    @IBOutlet weak var lbl_ReturnOrNot_Product: UILabel!
    @IBOutlet weak var lbl_Quality_Product: UILabel!
    @IBOutlet weak var lbl_Prize_Product: UILabel!
    @IBOutlet weak var lbl_NumberofProduct_Product: UILabel!
    @IBOutlet weak var lbl_ShippingCharge: UILabel!
    @IBOutlet weak var lbl_ShippingDayToDelavary: UILabel!
    
    @IBOutlet weak var btn_AddProduct_Product: UIButton!
    @IBOutlet weak var btn_SubstractProduct_Product: UIButton!
    @IBOutlet weak var btn_RemoveProduct: UIButton!
    @IBOutlet weak var btn_ColorChange: UIButton!
    @IBOutlet weak var btn_SizeChange: UIButton!
    @IBOutlet weak var btn_ProductDetail: UIButton!
    
    @IBOutlet weak var img_ProductImage_Product:UIImageView!
    
    //Product Section Module
    @IBOutlet var lbl_SelectionTitle1 : UILabel!
    @IBOutlet var lbl_SelectionTitle2 : UILabel!
    @IBOutlet var lbl_SelectionTitle3 : UILabel!
    @IBOutlet var lbl_SelectionTitle4 : UILabel!
    @IBOutlet var lbl_SelectionAns1 : UILabel!
    @IBOutlet var lbl_SelectionAns2 : UILabel!
    @IBOutlet var lbl_SelectionAns3 : UILabel!
    @IBOutlet var btn_Selection1 : UIButton!
    @IBOutlet var btn_Selection2 : UIButton!
    @IBOutlet var btn_Selection3 : UIButton!
    @IBOutlet var img_Selection1 : UIImageView!
    @IBOutlet var img_Selection2 : UIImageView!
    @IBOutlet var img_Selection3 : UIImageView!
    @IBOutlet var vw_Selection1 : UIView!
    @IBOutlet var vw_Selection2 : UIView!
    @IBOutlet var vw_Selection3 : UIView!
    
    @IBOutlet weak var btnItem2MoreClicked: UIButton!
    @IBOutlet weak var btnItem1MoreClicked: UIButton!
   
    //Cart lising
    @IBOutlet var lbl_CardBrand : UILabel!
    @IBOutlet var lbl_CardNumber : UILabel!
}


extension CheckoutViewController : BTDropInViewControllerDelegate {
    // MARK: - BTDropInViewControllerDelegate -
    func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethod: BTPaymentMethodNonce) {
        self.Post_PaymentDetail(id:paymentMethod.nonce as NSString)
        dismiss(animated: true, completion: nil)
        
    }
    
    func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
        dismiss(animated: true, completion: nil)
    }
}



extension CheckoutViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        self.completedServiceCalling()
        
        let response = data as! NSDictionary
        if strRequest == "cart_listing" {
            
            //Product detail
            let arr_result = response["result"] as! NSArray
            let arr_card = response["cardlist"] as! NSArray
            
            arr_Product = []
            for i in (0..<arr_result.count) {
                
                let dict_ProductDetail = arr_result[i] as! NSDictionary
                
                let obj = CheckoutObject ()
                obj.product_Cartid = ("\(dict_ProductDetail["cartid"] as! Int)" as NSString)
                obj.product_Productid = ("\(dict_ProductDetail["product_id"] as! Int)" as NSString)
                obj.product_Quantity = ("\(dict_ProductDetail["quantity"] as! Int)" as NSString)
                obj.product_Size = dict_ProductDetail["size"] as! NSString
                obj.product_Color = dict_ProductDetail["color"] as! NSString
                obj.product_Attrib = dict_ProductDetail["attrib"] as! NSString
                obj.product_Array_Attrib = notPrettyArray(from: (dict_ProductDetail["attrib"] as! NSString) as String)!
                
                obj.product_Datetime = dict_ProductDetail["datetime"] as! NSString
                
                let arr_ProductDetail2 = dict_ProductDetail["product_detail"] as! NSArray
                if arr_ProductDetail2.count != 0 {
                    
                    let dict_ProductDetail3 = arr_ProductDetail2[0] as! NSDictionary
                    let arr_Color = dict_ProductDetail3["ProductAttrib"] as! NSArray
                    let arr_Book = dict_ProductDetail3["GetBookAttribute"] as! NSArray
                    
                    obj.product_Product_Title = dict_ProductDetail3["p_title"] as! NSString
                    obj.product_Product_Info = dict_ProductDetail3["product_info"] as! NSString
                    obj.product_Shipping_Return = dict_ProductDetail3["shipping_policy"] as! NSString
                    obj.product_ReturnOrNot = dict_ProductDetail3["is_returnable"] as! NSString
                    if obj.product_ReturnOrNot == "0"{
                        obj.product_ReturnOrNot = "Not returnable"
                    }else{
                        obj.product_ReturnOrNot = "Returnable"
                    }
                    obj.product_ProductVideo = dict_ProductDetail3["product_video"] as! NSString
                    obj.product_Product_Description = dict_ProductDetail3["p_descriiption"] as! NSString
                    obj.product_Product_Prize = ("\(dict_ProductDetail3["price"] as! Double)" as NSString)
//                    obj.product_Product_Prize = "20.02"
                    obj.product_Product_DiscountPrice = ("\(dict_ProductDetail3["discount_price"] as! Double)" as NSString)
                    obj.product_Product_ShopId = ("\(dict_ProductDetail3["shop_id"] as! Int)" as NSString)
                    obj.product_Product_ShopName = dict_ProductDetail3["shop_name"] as! NSString
                    obj.product_Product_PrizeSymbol = dict_ProductDetail3["price_symbole"] as! NSString
                    obj.product_Product_Categoryname = dict_ProductDetail3["categoryname"] as! NSString
                    obj.product_Shipping_Charge =  ("\(dict_ProductDetail3["shipping_charge"] as! Double)" as NSString)
                    obj.product_Shipping_Charge_Product = ("\(dict_ProductDetail3["shipping_charge_per_unit"] as! Double)" as NSString)
                    obj.product_Shipping_EstimateDelivary = dict_ProductDetail3["estimate_delivary"] as! NSString
                    obj.product_Stock_Remain = ("\(dict_ProductDetail3["stock_remain"] as! Int)" as NSString)
                    obj.product_Is_stock_available = dict_ProductDetail3["is_stock_available"] as! NSString
                    obj.product_ProductCategoryID = ("\(dict_ProductDetail3["ProductCategoryID"] as! Int)" as NSString)
                    
                    //Product Image
                    let arr_Images = dict_ProductDetail3["product_images"] as! NSArray
                    if arr_Images.count != 0 {
                        let dict_Image = arr_Images[0] as! NSDictionary
                        obj.product_Product_Image = dict_Image["image"] as! NSString
                    }
                   
                    //Color Manage
                    let arr_TempColor : NSMutableArray = []
                    for i in (0..<arr_Color.count) {
                        let dict_ImageData = arr_Color[i] as! NSDictionary
                        
                        //Other Tab Demo data
                        let objImage = ProductObject ()
                        objImage.str_ColorName = dict_ImageData["color"] as! NSString
                        
                        let arr_Size = dict_ImageData["size"] as! NSArray
                        let arr_TempColorSize : NSMutableArray = []
                        for j in (0..<arr_Size.count) {
                            let dict_DataSize = arr_Size[j] as! NSDictionary
                            let keys = dict_DataSize.allKeys
                            
                            //Other Tab Demo data
                            let objImage2 = ProductObject ()
                            objImage2.str_ColorKey = keys[0] as! NSString
                            objImage2.str_ColorValue = ("\(dict_DataSize[keys[0]] as! Int)" as NSString)
                            arr_TempColorSize.add(objImage2)
                            //arr_TempColorSize
                        }
                        objImage.arr_ColorSize = arr_TempColorSize
                        
                        arr_TempColor.add(objImage)
                    }
                    
                    obj.arr_Random_1 = []
                    obj.arr_Random_2 = []
                    obj.arr_Random_3 = []
                    obj.arr_Random_BookPrize = []
                    obj.arr_Random_BookStock = []
                    
                    if arr_Book.count != 0{
                        var arr_Key : NSArray = ["Cover"]
                        obj.arr_Random_Key = arr_Key
                        
                        //                for i in (0..<arr_Book.count) {
                        let dict_ImageData = arr_Book[0] as! NSDictionary
                        let arr_Key2 : NSArray = dict_ImageData.allKeys as NSArray
                        
                        for i in (0..<arr_Key2.count) {
                            obj.arr_Random_1.add(arr_Key2[i] as! String)
                            obj.arr_Random_BookPrize.add(dict_ImageData[arr_Key2[i] as! String] as! String)
                            obj.arr_Random_BookStock.add("")
                        }
                        //                }
                    }
                    
                    
                    obj.arr_ColorSelect = arr_TempColor
                }
                arr_Product.add(obj)
                
            }
            
            obj_CheckOutDetail.str_Card_id = ""
            for i in 0..<arr_card.count{
                let dict_List = arr_card[i] as! NSDictionary
                if dict_List.getStringForID(key: "default_card") == "True"{
                    obj_CheckOutDetail.str_Card_id = dict_List.getStringForID(key: "id") as! NSString
                    obj_CheckOutDetail.str_Card_brand = dict_List.getStringForID(key: "brand") as! NSString
                    obj_CheckOutDetail.str_Card_elast4 = dict_List.getStringForID(key: "last4") as! NSString
                    obj_CheckOutDetail.str_Card_country = dict_List.getStringForID(key: "country") as! NSString
                    obj_CheckOutDetail.str_Card_exp_year = dict_List.getStringForID(key: "exp_year") as! NSString
                    obj_CheckOutDetail.str_Card_exp_month = dict_List.getStringForID(key: "exp_month") as! NSString
                }
            }
            //Shipping Detail
            let arr_ShippingAddress = response["primary_address"] as! NSArray
            if arr_ShippingAddress.count != 0 {
    
                let dict_ShippingDetail = arr_ShippingAddress[0] as! NSDictionary
                obj_CheckOutDetail.primary_Address_Title = dict_ShippingDetail["name"] as! NSString
                obj_CheckOutDetail.primary_Address_Id = ("\(dict_ShippingDetail["id"] as! Int)" as NSString)
            }
            
            
            //Shipping Detail
            let arr_Processing = response["settings"] as! NSArray
            for i in 0..<arr_Processing.count {
                let dict_ShippingDetail = arr_Processing[i] as! NSDictionary
                if i == 0{
                    obj_CheckOutDetail.processing_percentage = dict_ShippingDetail["data_value"] as! NSString
                }else if i == 1{
                    obj_CheckOutDetail.processing_cent = dict_ShippingDetail["data_value"] as! NSString
                }
            }
            
            
            self.manageView()
            tbl_Main.reloadData()
        }else if strRequest == "remove_cart" {
            arr_Product = []
            self.Post_cardListing()
            
            //Remove Cart Listing
            var int_Count : Int = Int((objUser?.str_CardCount as! NSString) as String)! - 1
            objUser?.str_CardCount = String(int_Count) as NSString
            saveCustomObject(objUser!, key: "userobject");

            
        }else if strRequest == "update_cart" {
            removeAppyPromocode()
        }else if strRequest == "getTokenGenerate" {
            
            //Get Access Tokent
            clientToken = (response["Totken"] as! NSString) as String
            self.payWithDropInShow(clientTokenOrTokenizationKey:clientToken)
            
        }else if strRequest == "PurchasePayment"{
            arr_Product = []
            self.manageView()
            tbl_Main.reloadData()
//            self.Post_cardListing()
            
            //User userdefualt
            objUser?.str_CheckoutTocken = response["CustomerID"] as! NSString
            objUser?.str_CardCount = "0"
            objUser?.str_RewardPoint = response["totalreward"] as! NSString
            saveCustomObject(objUser!, key: "userobject");
        }
        
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        if strRequest != "update_cart" {
            self.completedServiceCalling()
            self.manageView()
            tbl_Main.reloadData()
        }
        
    }
    
}




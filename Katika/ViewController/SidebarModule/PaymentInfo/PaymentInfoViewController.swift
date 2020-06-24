//
//  PaymentInfoViewController.swift
//  Katika
//
//  Created by Katika on 16/06/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
//import BraintreeDropIn
import Braintree
import PassKit
import SwiftMessages

//var braintree: Braintree?

class PaymentInfoViewController: UIViewController{
    
    var clientToken : String = ""
    var clientId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Other Files -
    func commanMethod(){
        self.navigationController?.isNavigationBarHidden = false
    }
    func payWithDialogView(clientTokenOrTokenizationKey: String) {
          //If you use this method than you can import "pod 'BraintreeDropIn'" frameworok nad remove Braintree framework
//
//        let request =  BTDropInRequest()
//        request.threeDSecureVerification = true
//        request.amount = "1.00"
//
//        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
//        { (controller, result, error) in
//            if (error != nil) {
//                print("ERROR")
//            } else if (result?.isCancelled == true) {
//                print("CANCELLED")
//            } else if let result = result {
//                //Declare property for paymentMethod
//                let out = result.paymentMethod!
////                print(out.nonce)
////                print(result.paymentDescription)
//
//                //Post nouce to server
//                self.Post_PaymentDetail(id:out.nonce as NSString)
//
//                // Use the BTDropInResult properties to update your UI
//                // result.paymentOptionType
//                // result.paymentMethod
//                // result.paymentIcon
//                // result.paymentDescription
//            }
//            controller.dismiss(animated: true, completion: nil)
//        }
//       // dropIn?.title = "hello testing"
//        self.present(dropIn!, animated: true, completion: nil)

    }
    
    func payWithPresentview(clientTokenOrTokenizationKey: String) {
        // If you haven't already, create and retain a `Braintree` instance with the client token.
        // Typically, you only need to do this once per session.
        
//        braintree = Braintree(clientToken: clientTokenOrTokenizationKey)
//        
//        // Create a BTDropInViewController
//        let dropInViewController = braintree!.dropInViewController(with: self)
//        dropInViewController.summaryTitle = "Payment Time"
//        dropInViewController.summaryDescription = "test payment"
//        dropInViewController.displayAmount = "10.10"
//        dropInViewController.callToActionText = "Pay Now"
//        dropInViewController.shouldHideCallToAction = false
//
//        
//        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.navigationCancelButton))
//
//        
//        let navigationController = UINavigationController(rootViewController: dropInViewController)
//        self.present(navigationController, animated: true, completion: nil)
    }
    func navigationCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_PayNow(_ sender : Any){

        self.Get_Token()
    }
    
    
    // MARK: - Get/Post Method -
    func Get_Token(){
        
        //Declaration URL
         let strURL = "\(Constant.BaseURL)GenratePaymentToken"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        if clientId == ""{
            jsonData = [
                "CustomerID" : "",
            ]
        }else{
            jsonData = [
                "CustomerID" : clientId,
            ]
        }
    
        print("URL :\n============\(strURL)\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "getTokenGenerate"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
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


//extension PaymentInfoViewController : BTDropInViewControllerDelegate {
//    // MARK: - BTDropInViewControllerDelegate -
//    func drop(_ viewController: BTDropInViewController!, didSucceedWith paymentMethod: BTPaymentMethod!) {
//        self.Post_PaymentDetail(id:paymentMethod.nonce as NSString)
//        dismiss(animated: true, completion: nil)
//        
//    }
//    
//    func drop(inViewControllerDidCancel viewController: BTDropInViewController!) {
//        dismiss(animated: true, completion: nil)
//    }
//
//}

extension PaymentInfoViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "getTokenGenerate" {
            
            //Get Access Tokent
            clientToken = (response["Result"] as! NSString) as String
            //            self.payWithDialogView(clientTokenOrTokenizationKey:clientToken)
            self.payWithPresentview(clientTokenOrTokenizationKey:clientToken)
        }else if strRequest == "CreateCustomer"{
            
            //This is first time user purchase product so store clientid
            let dict_result = response["Result"] as! NSDictionary
            clientId = (dict_result["CustomerID"] as! NSString) as String
            
            //Present popup
            messageBar.MessageShow(title:response["Message"] as! String as NSString , alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
        }else if strRequest == "PaymentByCustomerID"{
            
            //Present popup
            messageBar.MessageShow(title:response["Message"] as! String as NSString , alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        print(error)
    }

}

//
//  CardListViewController.swift
//  LyftDoc
//
//  Created by Mac on 18/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Stripe
import SwiftMessages
import EmptyDataSet_Swift

class CardListViewController: UIViewController, STPAddCardViewControllerDelegate ,EmptyDataSetSource, EmptyDataSetDelegate{

    @IBOutlet var tblCardList: UITableView!
    
    
    var arrSaveCard: NSMutableArray = []
    
    var strSelectedCard    : String = ""
    var strTokenID  : String = ""
    
    var selectedObj = CardDetailsObject()
    var deletedObj = CardDetailsObject()

    @IBOutlet var txtViewStripe: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       API_patientAllCard()
        tblCardList.tableFooterView = UIView()

        tblCardList.emptyDataSetSource = self
        tblCardList.emptyDataSetDelegate = self
        
        self.SetFontAndColor()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    //MARK: - Custom Methods -
    func SetFontAndColor()
    {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddNewCard(_ sender: Any) {
        handleAddPaymentMethodButtonTapped()
    }
    
    
    func handleAddPaymentMethodButtonTapped() {
        // Setup add card view controller
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        let nvc: UINavigationController = UINavigationController(rootViewController: addCardViewController)
        self.navigationController?.present(nvc, animated: true, completion: nil)
        
        // Present add card view controller
//        let navigationController = UINavigationController(rootViewController: addCardViewController)
//        //        navigationController.navigationBar.barTintColor = UIColor.white
//        navigationController.navigationBar.tintColor = UIColor.white
//        navigationController.navigationBar.barTintColor = UIColor.white
//        UIBarButtonItem.appearance().tintColor = UIColor.white
//        navigationController.navigationController?.navigationBar.tintColor = .white
        
//        present(navigationController, animated: true)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        
        tblCardList.reloadData()
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        print(token)
        
        if !token.tokenId.isEmpty {
            strSelectedCard = ""
            strTokenID = token.tokenId
            
            API_addpatientAllCard()
        }
        
        dismiss(animated: true)
    }
    
    // MARK: - No Result found related methods
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        var text: String?
        var font: UIFont?
        var textColor: UIColor?
        
        textColor = UIColor.darkGray
        
        text = "Tap + add new card"
        
        return NSAttributedString.init(string: text!, attributes: nil)
    }
    


    func API_patientAllCard(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)getCard"
        
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "getAllCard"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData as NSDictionary
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
    
    func API_addpatientAllCard(){
        //Declaration URL
        let strURL = "\(Constant.BaseURL)addCard"

        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid,
            "token" : strTokenID,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "addCard"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData as NSDictionary
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }

    func API_setADefaultCard(){

        //Declaration URL
        let strURL = "\(Constant.BaseURL)setDefaultCard"
        
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid,
            "card_id" : selectedObj.strCardID,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "setADefaultCard"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData as NSDictionary
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }

    func API_DeleteCard(strCardID : String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)deleteCard"
        
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid,
            "card_id" : strCardID,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "deleteCard"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData as NSDictionary
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }

}

// MARK: - WebserviceDelegate -

extension CardListViewController: WebServiceHelperDelegate
{
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
    
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        let response = data as! NSDictionary
        
        if strRequest == "getAllCard"
        {
            
            let responseDict = response["result"] as! Array<Dictionary<String, Any>>
            //                    let aryDoctors = dictResult["data"] as! NSArray
            
//            objUser?.strCardCount = String(responseDict.count)
//            saveCustomObject(objUser!, key: GlobalConstant.UserObjectKey)

                arrSaveCard = []
                for dict in responseDict {
                    
                        let obj = CardDetailsObject()
                        obj.strCardID = dict["id"] as? String ?? ""
                        obj.strBrand = dict["brand"] as? String ?? ""
                        obj.strCountry = dict["country"] as? String ?? ""
                        obj.strExp_Month = dict["exp_month"] as? String ?? ""
                        obj.strExp_Year = dict["exp_year"] as? String ?? ""
                        obj.strCardNo = dict["last4"] as? String ?? ""
                        obj.isSelected = false
                    
                        if (dict["default_card"] as? String)?.lowercased() == "true"
                        {
                            obj.isSelected = true
                        }
                    
                        arrSaveCard.add(obj)
                    }
            tblCardList.reloadData()

            }
            else if strRequest == "addCard"
            {
                let status = response ["status"] as? String ?? ""
                let msg = response ["message"] as? String ?? ""

                API_patientAllCard()

            }
            else if strRequest == "setADefaultCard"{
                let msg = response ["message"] as? String ?? ""
                let status = response ["status"] as? String ?? ""

                messageBar.MessageShow(title: msg as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }
        else if strRequest == "deleteCard"
        {
            let status = response ["status"] as? String ?? ""
            let msg = response ["message"] as? String ?? ""
            
                
                arrSaveCard.remove(deletedObj)
                API_patientAllCard()

        }

        }
}


class CardDetailsObject {
    
    var strCardID: String = ""
    var strBrand: String = ""
    var strCountry: String = ""
    var strExp_Month: String = ""
    var strExp_Year: String = ""
    var strCardNo: String = ""
    var isSelected: Bool = false
}

class cellCardList: UITableViewCell{
    
    @IBOutlet weak var lblCardTitle: UILabel!
    @IBOutlet weak var imgSelected: UIImageView!
    
}

extension CardListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSaveCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cellCardReuse", for:indexPath) as! cellCardList
        
        let objCard = arrSaveCard[indexPath.row] as! CardDetailsObject
        
//        let attrs1 = [NSAttributedStringKey.font : UIFont.semiBold(ofSize: 18*GlobalConstant.kFont_Ratio)]
//        let attrs2 = [NSAttributedStringKey.font : UIFont.regular(ofSize: 15*GlobalConstant.kFont_Ratio)]
        
//        let attrs1 = [NSAttributedStringKey.font : UIFont(name: Constant.kFontRegular, size: 18)]
//        let attrs2 = [NSAttributedStringKey.font : UIFont(name: Constant.kFontRegular, size: 14)]
        
        let attributes = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: Constant.kFontSemiBold, size: 18)!] as [String : Any]
        let attributes2 = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: Constant.kFontSemiBold, size: 14)!] as [String : Any]
        
        let attributedString1 = NSMutableAttributedString(string: objCard.strBrand, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        let attributedString2 = NSMutableAttributedString(string: " Ending with ", attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes2))
        let attributedString3 = NSMutableAttributedString(string: objCard.strCardNo, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        
        cell.lblCardTitle.attributedText = attributedString1
        
        cell.imgSelected.isHidden = true
        if objCard.isSelected == true
        {
            cell.imgSelected.isHidden = false
        }
        
        //        cell.lblCardTitle.text = "Amax Ending in 25654"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedObj = arrSaveCard[indexPath.row] as! CardDetailsObject
        for objCard in arrSaveCard{
            (objCard as! CardDetailsObject).isSelected = false
        }
        selectedObj.isSelected = true
        tblCardList.reloadData()
        
        API_setADefaultCard()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)

            let alert = UIAlertController(title: Constant.appName, message: "Are you sure you want to Delete?", preferredStyle: .alert)
            let firstAction = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in

                self.deletedObj = self.arrSaveCard[indexPath.row] as! CardDetailsObject
                self.API_DeleteCard(strCardID: self.deletedObj.strCardID)
            })
            let secondAction = UIAlertAction(title: "No", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                print("You pressed button two")
            })
            alert.addAction(firstAction)
            alert.addAction(secondAction)
            present(alert, animated: true) {() -> Void in }

        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

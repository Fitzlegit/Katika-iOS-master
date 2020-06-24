//
//  BusinessCheckIViewController.swift
//  Katika
//
//  Created by Apple on 23/11/18.
//  Copyright © 2018 icoderz123. All rights reserved.
//

import UIKit

class BusinessCheckIViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    var arrCheckIn = NSMutableArray()
    @IBOutlet weak var lblNoData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoData.isHidden = true
        lblNoData.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 12)/Constant.screenWidthDeveloper))

        // Do any additional setup after loading the view.
        GetCheckInList()
    }

    override func viewWillAppear(_ animated: Bool) {
        //SET NAVIGATION BAR
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: false)
        let button = UIButton.init(type: .custom)
        
        //set title for button
        button.setImage(UIImage(named: "icon_NavigationRightArrow"), for: .normal)
        //            button.setTitle("Skip..", for: .normal)
        
        button.addTarget(self, action: #selector(btnBackClicked(_:)), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let barButton = UIBarButtonItem(customView: button)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: - ACTION BUTTON
    @objc func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    
    //MARK: - API CALLING
    func GetCheckInList() {
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_business_checkin"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid as! String,
            "skip" : "0",
            "total":"100",
            "longitude":"",
            "latitude" :"",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_business_checkin"
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
extension BusinessCheckIViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrCheckIn.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let simpleTableIdentifier = "CheckInCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) as? CheckInCell
        var arr = Bundle.main.loadNibNamed("CheckInCell", owner: self, options: nil)
        cell = arr?[0] as? CheckInCell
        cell?.selectionStyle = .none
        
        
        let obj : KatikaViewObject = arrCheckIn[indexPath.row] as!KatikaViewObject
        cell?.lblName.text = obj.str_shop_name as String?
        cell?.lblDetails.text = obj.str_shop_location as String?
        cell?.lblCategory.text = obj.str_shopcategory as String?
        if obj.str_Checkin_date != "" {
            cell?.lblCheckInTime.text = "\("Check-In :") \(obj.str_Checkin_date as String)"
            
        }
        if obj.str_TotalReview != "0" {
            cell?.lblReview.text =  ("\(obj.str_TotalReview as String! ?? "") Reviews")
        }else{
            cell?.lblReview.text =  ("\(obj.str_TotalReview as String! ?? "") Review")
        }
        
        if obj.str_AvgReview.length != 0 {
            cell?.viewReview.rating =  Double(obj.str_AvgReview as String)!
        }else{
            cell?.viewReview.rating =  0
        }
        
        
        //Image set
        let url = URL(string:obj.str_ShopImage as String)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            cell?.imgBusiness.image = image
        }
//        cell?.imgBusiness.sd_setImage(with: URL(string: obj.str_ShopImage as String), placeholderImage: UIImage(named: "icon_Demo_Person"))
        
        
        
        
       
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(Int((Constant.windowHeight * 110)/Constant.screenHeightDeveloper))
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj : KatikaViewObject = arrCheckIn[indexPath.row] as!KatikaViewObject

        //Open filter view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
        view.str_ProductIDGet = obj.str_shop_id
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}



extension BusinessCheckIViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        //Manage Sub category Data
        let arr_result = response["Result"] as! NSArray
        
        if strRequest == "get_business_checkin" {
            
            //GET DATA
            arrCheckIn = []
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                let arr_Image = dict_Data["Images"] as! NSArray
                
                //Receintly viewed Product
                let obj = KatikaViewObject ()
                obj.str_shop_id = ("\(dict_Data["business_id"] as! Int)" as NSString)
                obj.str_shop_name = dict_Data["business_name"] as! String as NSString
                obj.str_shopcategory = dict_Data["category"] as! String as NSString
                obj.str_shop_location = dict_Data["business_location"] as! String as NSString
                obj.str_TotalReview = ("\(dict_Data["total_business_review"] as! Int)" as NSString)
                obj.str_AvgReview = dict_Data["avg_business_review"] as? NSString ?? "0"
                obj.str_Checkin_date = dict_Data["is_check_date"] as! NSString

                if arr_Image.count != 0{
                    let dict_Data2 = arr_Image[0] as! NSDictionary
                    obj.str_ShopImage = dict_Data2["image"] as! String as NSString
                }
                
            
                arrCheckIn.add(obj)
            }
            
            if arrCheckIn.count == 0 {
                lblNoData.isHidden = false
            }
           //RELOAD TABLE
            self.tblView.reloadData()
        }
        

     
    }
    
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        // self.completedServiceCalling()
        if arrCheckIn.count == 0 {
            lblNoData.isHidden = false
        }
    }
    
}

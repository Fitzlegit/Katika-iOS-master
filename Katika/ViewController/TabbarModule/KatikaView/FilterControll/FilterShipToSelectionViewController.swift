//
//  FilterShipToSelectionViewController.swift
//  Katika
//
//  Created by Katika_07 on 17/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class FilterShipToSelectionViewController: UIViewController {

    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    var str_Selected : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMathod()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Other Method -
    func commanMathod() {
        
    }
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        dismiss(animated: true) { _ in }
    }
    @IBAction func btn_Done (_ sender : Any){
        dismiss(animated: true) { _ in }
    }
    
    func Get_SelectCountry(country_ID : String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)updatefilter_country"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "country" : country_ID,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "updatefilter_country"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
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


//MARK: - Tableview View Cell -
class FilterShipToSelectedTableviewCell : UITableViewCell{
    
    //Generale
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_Selected: UIImageView!
}

// MARK: - Tableview Files -
extension FilterShipToSelectionViewController : UITableViewDelegate,UITableViewDataSource {
    // MARK: - Table View -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrContryList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 108
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIdentifier : String = "cell"
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! FilterShipToSelectedTableviewCell
        
        let obj : ContryListingObject = arrContryList[indexPath.row] as! ContryListingObject
        
        cell.lbl_Title.text = obj.str_Name as String
        
        print(str_Selected)
        if str_Selected == obj.str_Name as String {
            cell.img_Selected.image = UIImage.init(named: "img_SelectedArrow")
        }else{
            cell.img_Selected.image = UIImage.init(named: "")
        }
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj : ContryListingObject = arrContryList[indexPath.row] as! ContryListingObject
        str_Selected = obj.str_Name as String
        
        self.Get_SelectCountry(country_ID:(obj.str_ID as? String)!)
        
        tbl_Main.reloadData()
    }
}



extension FilterShipToSelectionViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "updatefilter_country" {
            dismiss(animated: true) { _ in }
        }
        
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
}




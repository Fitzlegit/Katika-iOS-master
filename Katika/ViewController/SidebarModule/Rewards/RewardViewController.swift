//
//  RewardViewController.swift
//  Katika
//
//  Created by Katika on 09/06/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import KDCircularProgress

class RewardViewController: UIViewController {

    //Other Declaration
    @IBOutlet weak var tbl_Main: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()
        
        //CALL API
        Post_RewardPoint()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - BrainTree - 
   
    
    
    // MARK: - Other Files -
    func commanMethod(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true,animated:false)
    }
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.navigationController?.popViewController(animated: false)
    }
   
    // MARK: - Get/Post Method -
    func Post_RewardPoint(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)rewardPoints"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "   " : (objUser?.str_Userid as! String),
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "RewardPoint"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    

}



//MARK: - Checkout Object -

class RewardObject: NSObject {
    
    //Product listing Other
    var int_Title_Sort : Int = 0
}
// MARK: - Tableview Files -
extension RewardViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return CGFloat((Constant.windowHeight * 400)/Constant.screenHeightDeveloper)
        }
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var str_CellIdentifier : NSString = "cell"
        
        if indexPath.row == 0 {
            //Total summery data
            str_CellIdentifier = "section"
        }else if indexPath.row == 1 {
            //Reward graph
            str_CellIdentifier = "rewardcircle"
        }else if indexPath.row == 2 {
            //Just exmple for reward system
            str_CellIdentifier = "footer"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: str_CellIdentifier as String, for:indexPath as IndexPath) as! RewardviewCell
        
        if indexPath.row == 0 {
            //Header title and subtitle cell
            cell.lbl_Title.text = "Katika Rewards Tracker"
            cell.lbl_Detail.text = "Welcome to Katika Rewards, a platform that allows you to earn points to apply towards great items on the platform. Everyone starts in the bronze tier and can move into higer ranked tiers by supporting the Katika community through making purchases."
        }else if indexPath.row == 1{
            //Set progress in progress bar
            //Angle set between 0(Min) to 280(Max)
//            cell.progressBar_Main.angle = 100
            cell.lbl_RewardPoint.text = manageRewardModule(type : "point")
            cell.lbl_RewardStage.text = manageRewardModule(type : "stage")
            cell.lbl_RewardNextStage.text = manageRewardModule(type : "nextstage")
            cell.progressBar_Main.angle = Double(manageRewardModule(type : "circle"))!
            
            
        }else if indexPath.row == 2{
            //Footer Cell with lbl_Detail
            cell.lbl_Title.text = "Earning points is easy! For example, you can earn points for placing an order and writing reviews."
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
//MARK: - Tableview View Cell -
class RewardviewCell : UITableViewCell{
    //Section Data
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Detail: UILabel!
    @IBOutlet var lbl_RewardPoint : UILabel!
    @IBOutlet var lbl_RewardStage : UILabel!
    @IBOutlet var lbl_RewardNextStage : UILabel!
    
    //Progress Cell
    @IBOutlet var progressBar_Main: KDCircularProgress!
    
}



extension RewardViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        print(response)
        if strRequest == "RewardPoint" {
           
            objUser?.str_RewardPoint = ("\(response["reward_points"] as! String)" as NSString)
            saveCustomObject(objUser!, key: "userobject");

            //SET DATA
            commanMethod()
            tbl_Main.reloadData()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {

    }
    
}


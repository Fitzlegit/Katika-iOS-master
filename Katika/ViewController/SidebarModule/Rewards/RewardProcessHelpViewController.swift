//
//  RewardProcessHelpViewController.swift
//  Katika
//
//  Created by Katika_07 on 31/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class RewardProcessHelpViewController: UIViewController {

    @IBOutlet var web_Main: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true,animated:false)
        
         self.Post_Setting()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }

    func Post_Setting(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_user_setting"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_user_setting"
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

extension RewardProcessHelpViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        indicatorShow()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicatorHide()
        
    }
}


extension RewardProcessHelpViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "get_user_setting" {
            
            let dict_SettingData = response["setting"] as! NSDictionary
            
            //            txtView.text = (dict_SettingData["aboutapp"] as! NSString) as String!
            
            web_Main.loadRequest(URLRequest(url: NSURL(string : dict_SettingData["reward_point"] as! String) as! URL))
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
    
}


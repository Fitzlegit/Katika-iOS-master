//
//  UrlLoadViewController.swift
//  Katika
//
//  Created by KatikaRaju on 5/25/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class UrlLoadViewController: UIViewController {

    @IBOutlet var txtView: UITextView!
    
    @IBOutlet var web_Main: UIWebView!
    
    var str_URL : String = ""
    var title_View : String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        self.navigationItem.title = title_View
        web_Main.loadRequest(URLRequest(url: NSURL(string :str_URL) as! URL))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     // MARK: - Button Event -
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

extension UrlLoadViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        indicatorShow()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicatorHide()
        
    }
}


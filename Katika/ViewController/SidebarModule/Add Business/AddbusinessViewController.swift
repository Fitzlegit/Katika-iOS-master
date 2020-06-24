//
//  AddbusinessViewController.swift
//  Katika
//
//  Created by Apple on 15/11/18.
//  Copyright © 2018 icoderz123. All rights reserved.
//

import UIKit

class AddbusinessViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var objWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //SET WEBVIEW URL
        let url = URL (string: "https://form.jotform.me/83183484260458")
        objWebView.delegate = self
        let requestObj = URLRequest(url: url!)
        objWebView.loadRequest(requestObj)
        
        
        //INDICATORE START
        indicatorShow()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        
        //INDICATORE STOP
        indicatorHide()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        //INDICATORE STOP
        indicatorHide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //SET NAVIGATION BAR
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //SET RIGHT NAVIGATION BUTTON
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
   
    
}

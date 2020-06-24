//
//  KatikaDirectoryMainViewController.swift
//  Katika
//
//  Created by Apple on 22/03/18.
//  Copyright © 2018 Katika123. All rights reserved.
//

import UIKit
import Firebase
var vw_Tab1: KatikaViewController?
var vw_Tab2: KatikaDirectoryViewController?

class KatikaDirectoryMainViewController: UIViewController {

    
    @IBOutlet var vw_ShowSelection: UIView!
    
    var indexpath_Header : NSIndexPath = NSIndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
       //MOCVE TO DETAILS PAGE
        katikaViewSelection = ""
        vw_ShowSelection.isHidden = true
        KatikaDirectoryMainPageViewController?.scrollToPreviewsViewController(indexCall:1)
        if vw_Tab2 != nil{
            vw_Tab2?.viewWillAppear(true)
        }
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        vw_ShowSelection.isHidden = true
        if katikaViewSelection == "1"{
            vw_ShowSelection.isHidden = false
        }
        
        self.view.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button Event -
    @IBAction func btn_KatikaView(_ sender: Any) {
        katikaViewSelection = ""
        vw_ShowSelection.isHidden = true
        
        KatikaDirectoryMainPageViewController?.scrollToPreviewsViewController(indexCall:0)
        vw_Tab1?.viewWillAppear(true)
        
//        self.setViewwillAppearCode()
    }
    @IBAction func btn_DirectoryView(_ sender: Any) {
        katikaViewSelection = ""
        vw_ShowSelection.isHidden = true
        
        KatikaDirectoryMainPageViewController?.scrollToPreviewsViewController(indexCall:1)
        if vw_Tab2 != nil{
            vw_Tab2?.viewWillAppear(true)
        }
//        self.setViewwillAppearCode()
    }

    // MARK: - TabBar Button -
    @IBAction func btn_Tab_Home(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_home", parameters: nil)
        vw_BaseView?.callmethod(_int_Value: 0)
    }
    @IBAction func btn_Tab_Fav(_ sender: Any) {
        
        
        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }
        else{
            //SET ANALYTICS
            Analytics.logEvent("tab_favorite", parameters: nil)
            vw_BaseView?.callmethod(_int_Value: 1)
        }
    
    }
    @IBAction func btn_Tab_Katika(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_directory", parameters: nil)
        katikaViewSelection = "1"
        vw_BaseView?.callmethod(_int_Value: 2)
    }
    @IBAction func btn_Tab_Search(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_search", parameters: nil)
        vw_BaseView?.callmethod(_int_Value: 3)
    }
    @IBAction func btn_Tab_Inbox(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_inbox", parameters: nil)
        vw_BaseView?.callmethod(_int_Value: 4)
    }
    
    //MARK: - Page view controller -
    var KatikaDirectoryMainPageViewController: KatikaDirectoryMainPageViewController? {
        didSet {
            KatikaDirectoryMainPageViewController?.profileDelegate = self
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let KatikaDirectoryMainPageViewController = segue.destination as? KatikaDirectoryMainPageViewController {
            self.KatikaDirectoryMainPageViewController = KatikaDirectoryMainPageViewController
        }
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

//MARK: - Pageview controller Delegate -
extension KatikaDirectoryMainViewController : KatikaDirectoryMainPageViewControllerDelegate {
    func KatikaDirectoryMainPageViewController(_ KatikaDirectoryMainPageViewController: KatikaDirectoryMainPageViewController,
                                   didUpdatePageCount count: Int) {
        
    }
    func KatikaDirectoryMainPageViewController(_ KatikaDirectoryMainPageViewController: KatikaDirectoryMainPageViewController,
                                   didUpdatePageIndex index: Int) {
        
        indexpath_Header = NSIndexPath(row: index, section: 0)
       
        
        KatikaDirectoryMainPageViewController.scrollToViewController(index: index)
        
        //        cv_Main_TabBar.reloadData()
    }
}





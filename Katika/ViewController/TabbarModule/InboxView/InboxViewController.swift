//
//  InboxViewController.swift
//  Katika
//
//  Created by Katika on 18/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import Firebase

class InboxViewController: UIViewController , UIScrollViewDelegate{

    //Declaration CollectionView
    @IBOutlet var cv_Main_TabBar : UICollectionView!
    
    @IBOutlet weak var containerView: UIView!
    
    var indexpath_Header : NSIndexPath = NSIndexPath(row: 0, section: 0)
    
    //Array Declaration
    var arr_Category : NSMutableArray = ["User Chat","Notifications"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    var ChatPageViewController: ChatPageViewController? {
        didSet {
            ChatPageViewController?.tutorialDelegate = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ChatPageViewController = segue.destination as? ChatPageViewController {
            self.ChatPageViewController = ChatPageViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.manageNavigation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Other Files -
    func manageNavigation(){
        
        let titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 150, height: 28))
        titleView.contentMode = .scaleAspectFit
        titleView.image = UIImage(named: "katikaTextNavigation")
        
        self.navigationItem.titleView = titleView
    }

    // MARK: - Button Event -
    @IBAction func Sidebar_Left(_ sender: Any) {
        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }else{
            toggleLeft()
        }
        
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
        }else{
            //SET ANALYTICS
            Analytics.logEvent("tab_favorite", parameters: nil)
            vw_BaseView?.callmethod(_int_Value: 1)
        }
    }
    @IBAction func btn_Tab_Katika(_ sender: Any) {
        //SET ANALYTICS
        Analytics.logEvent("tab_directory", parameters: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}




extension InboxViewController: ChatPageViewControllerDelegate {

    func ChatPageViewController(_ ChatPageViewController: ChatPageViewController, didUpdatePageCount count: Int) {

    }
    func ChatPageViewController(_ ChatPageViewController: ChatPageViewController,
                                    didUpdatePageIndex index: Int) {
        indexpath_Header = NSIndexPath(row: index, section: 0)
        
        ChatPageViewController.scrollToViewController(index: index)
        cv_Main_TabBar.reloadData()
    }
    
}


//MARK: - Collection View -
extension InboxViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returen number of cell with content available in array
        if cv_Main_TabBar == collectionView {
            return arr_Category.count
        }
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.size.width/2, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var str_Identifier : String = "cell"
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: str_Identifier, for: indexPath) as! InboxViewCollectioncell
        
        if cv_Main_TabBar == collectionView {
            //Set text in label
            cell.lblTitle.text = arr_Category[indexPath.row] as? String
            
            //Seleted Image always false only selected state they show
            cell.img_Seleted.isHidden = true
            if indexpath_Header.row == indexPath.row {
                 cell.img_Seleted.isHidden = false
            }
            
            //Set font size and font name in title
            cell.lblTitle.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if cv_Main_TabBar == collectionView {
            if indexpath_Header.row != indexPath.row{
                ChatPageViewController?.scrollToPreviewsViewController(indexCall:indexPath.row)
            }
            
            indexpath_Header = indexPath as NSIndexPath
            cv_Main_TabBar.reloadData()
        }
    }
}


//MARK: - Collection View Cell -
class InboxViewCollectioncell : UICollectionViewCell{
    //Cell for tabbar
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img_Seleted: UIImageView!
}




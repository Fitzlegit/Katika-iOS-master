//
//  LeftMenuViewController.swift
//  HealthyBlackMen
//
//  Created by      on 5/4/17.
//  Copyright © 2017   . All rights reserved.
//

import UIKit
//import SlideMenuControllerSwift
import SwiftMessages
import SDWebImage
import Firebase

enum LeftMenu: Int {
    case home = 0
    case setting
    case logout
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
}

class LeftMenuViewController : UIViewController, LeftMenuProtocol , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    //Declaration
    @IBOutlet weak var tableView: UITableView!
    
    //Declaration Images
    @IBOutlet weak var img_ProfileSub: UIImageView!
    @IBOutlet weak var img_Profile: UIImageView!
    
    //Manage array for ExskuderMenu controller
    var menus = ["Home","Setting", "Logout","lefttab","righttab"]
    
    //Label Declaration
    @IBOutlet var lbl_Name : UILabel!
    @IBOutlet var lbl_HashTag : UILabel!
    
    //Alloc init viewcontroller
    var HomeViewController: UIViewController!
    var FavoriteViewController: UIViewController!
    var KatikaViewController: UIViewController!
    var SearchViewController: UIViewController!
    var InboxViewController: UIViewController!
    
    //Declare Sidebar controller
    var leftMenuSize = SlideMenuOptions.leftViewWidth
    var size : SlideMenuController = SlideMenuController()
    
    //View Manage
    @IBOutlet var vw_Profile : UIView!
    
    //Constant ste
    @IBOutlet var con_vw_Top : NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_BaseView = self
    
        //Declaration number of view added in left view contoller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //1. Left View controller
        let HomeViewController = storyboard.instantiateViewController(withIdentifier: "NewHomeViewController") as! NewHomeViewController
        self.HomeViewController = UINavigationController(rootViewController: HomeViewController)
        
        //2. Setting View controller
        let FavoriteViewController = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        self.FavoriteViewController = UINavigationController(rootViewController: FavoriteViewController)
        
        //3. Home View controller
        let KatikaViewController = storyboard.instantiateViewController(withIdentifier: "KatikaDirectoryMainViewController") as! KatikaDirectoryMainViewController
        self.KatikaViewController = UINavigationController(rootViewController: KatikaViewController)

        
        
        //4. Left View controller
        let SearchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.SearchViewController = UINavigationController(rootViewController: SearchViewController)
        
        //4. Left View controller
        let InboxViewController = storyboard.instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
        self.InboxViewController = UINavigationController(rootViewController: InboxViewController)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        self.commanMethod()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - ImagePicker Delegate -
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage
        
        img_Profile.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    
    // MARK: - Other Files -
    //Method for change view with other screen calling
    func commanMethod(){
        //Layer Set
        img_ProfileSub.layer.cornerRadius = CGFloat(Int((Constant.windowHeight * 95.5)/Constant.screenHeightDeveloper))/2
        img_ProfileSub.layer.borderColor = UIColor.init(colorLiteralRed: 92/256.0, green: 92/256.0, blue: 92/256.0, alpha: 1.0).cgColor
        
        img_Profile.layer.cornerRadius = CGFloat(Int((Constant.windowHeight * 90)/Constant.screenHeightDeveloper))/2
        img_Profile.layer.masksToBounds = true
        
        //Conastant set
        con_vw_Top.constant = CGFloat(Int((Constant.windowHeight * 33)/Constant.screenHeightDeveloper))
        
        let str_Name = objUser?.str_FirstName as! String
        if str_Name != "" {
            lbl_Name.text = "\(objUser?.str_FirstName as! String) \(objUser?.str_LastName as! String)"
            lbl_HashTag.text = "@ \(objUser?.str_FirstName as! String)-\(objUser?.str_LastName as! String)"
        }
        
        print(objUser?.str_Profile_Image)
        //Set image
        img_Profile.sd_setImage(with: URL(string: objUser?.str_Profile_Image as! String), placeholderImage: UIImage(named: Constant.placeHolder_User))
    }
    func callmethod(_int_Value : Int) {
        switch _int_Value {
        case 0:
            self.slideMenuController()?.changeMainViewController(self.HomeViewController, close: true)
            break
            
        case 1:
            self.slideMenuController()?.changeMainViewController(self.FavoriteViewController, close: true)
            break
            
        case 2:
            katikaViewSelection = "1"
            self.slideMenuController()?.changeMainViewController(self.KatikaViewController, close: true)
            break
            
        case 3:
            self.slideMenuController()?.changeMainViewController(self.SearchViewController, close: true)
            break
            
        case 4:
            self.slideMenuController()?.changeMainViewController(self.InboxViewController, close: true)
            break
            
            
        default:
            break
        }
    }
    
    //For didselect method for present view controller
    func changeViewController(_ menu: LeftMenu) {
//        switch menu {
//        case .home:
//            self.slideMenuController()?.changeMainViewController(self.LeftTabBarViewController, close: true)
//        case .setting:
//            self.slideMenuController()?.changeMainViewController(self.settingViewcontroller, close: true)
//        case .logout:
//            if AccessToken.current != nil {
//                AccessToken.current = nil
//            }
//        
//            //Logout alert for user
//            let alert = UIAlertController(title: "HealthyBlackMen", message: "Are you sure want to logout?", preferredStyle: UIAlertControllerStyle.actionSheet)
//            alert.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.default, handler: { (action) in
//                
//                //Store data nill value when user logout
//                let defaults = UserDefaults.standard
//                defaults.removeObject(forKey: "userobject")
//                defaults.synchronize()
//                
//                //Alert show for Header
//                messageBar.MessageShow(title: "Logout successfully", alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
//
//                //Navigate to home view
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let nav: UINavigationController! = (appDelegate.window?.rootViewController as! UINavigationController)
//                nav.popToRootViewController(animated: true)
//                
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            }
        }
    
    // MARK: - Button Event -
    @IBAction func btn_Close(_ sender: Any){
        closeLeft()
    }
    @IBAction func btnLoginClicked(_ sender: Any) {
        if objUser?.str_User_Role == "2"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            view.strGusetUser = "1"
            let Root : UINavigationController = UINavigationController(rootViewController: view)
            self.navigationController?.present(Root, animated: true
                , completion: nil)
        }
    }
}


// MARK: - Tableview Files -
extension LeftMenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Hide Payment info cell
        if indexPath.row == 8 {
            return 0
        }
        
        return CGFloat(Int((Constant.windowHeight * 60)/Constant.screenHeightDeveloper))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            //SET ANALYTICS
            Analytics.logEvent("menu_profile", parameters: nil)
            
            //Profile screen open
            self.performSegue(withIdentifier: "profile", sender: self)
            break
        case 1:
            //SET ANALYTICS
            Analytics.logEvent("menu_purchases", parameters: nil)
            
            //Purchase screen open
            self.performSegue(withIdentifier: "purchase", sender: self)
            break
        case 2:
            //SET ANALYTICS
            Analytics.logEvent("menu_rewards", parameters: nil)
            
            //Review screen open
            self.performSegue(withIdentifier: "rewards", sender: self)
            break
        case 3:
                //SET ANALYTICS
                Analytics.logEvent("menu_check-in", parameters: nil)
    
                //Setting view
                self.performSegue(withIdentifier: "checkin", sender: self)
            break
        case 4:
            //SET ANALYTICS
            Analytics.logEvent("menu_addbusiness", parameters: nil)
            
            //Setting view
            self.performSegue(withIdentifier: "business", sender: self)
            break
        case 5:
            //SET ANALYTICS
            Analytics.logEvent("menu_currency", parameters: nil)
            
            //Contact us view
            self.performSegue(withIdentifier: "changeCurrency", sender: self)
            break
        case 6:
            //SET ANALYTICS
            Analytics.logEvent("menu_invite_friend", parameters: nil)
            
            //Contact us view
            self.performSegue(withIdentifier: "invite_friend", sender: self)
            break
            
        case 7:
            //SET ANALYTICS
            Analytics.logEvent("menu_gift", parameters: nil)
            
            //Gift Purchase
            self.performSegue(withIdentifier: "addgift", sender: self)
            break
       
        case 8:
            //SET ANALYTICS
            Analytics.logEvent("menu_paymentinfo", parameters: nil)
            
            //Payment info open
            self.performSegue(withIdentifier: "paymentinfo", sender: self)
            break
        
        case 9:
            //SET ANALYTICS
            Analytics.logEvent("menu_setting", parameters: nil)
            
            //Setting view
            self.performSegue(withIdentifier: "setting", sender: self)
            break
        case 10:
            //SET ANALYTICS
            Analytics.logEvent("menu_contactus", parameters: nil)
            
            //Contact us view
            self.performSegue(withIdentifier: "contactus", sender: self)
            break
        case 11:
            //Logout alert for user
            let alert = UIAlertController(title: Constant.appName, message: "Are you sure you want to log out ?", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.default, handler: { (action) in
                
                
                //SET ANALYTICS
                Analytics.logEvent("menu_logout", parameters: nil)
                
                //Store data nill value when user logout
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "userobject")
                defaults.synchronize()
                GIDSignIn.sharedInstance().signOut()
                
                //Alert show for Header
                messageBar.MessageShow(title: "Logout successfully", alertType: MessageView.Layout.CardView, alertTheme: .success, TopBottom: true)
                
                //Navigate to home view
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let nav: UINavigationController! = (appDelegate.window?.rootViewController as! UINavigationController)
                nav.popToRootViewController(animated: true)
                
                //remove quick box
                //                var request = QBRequest.logOut(successBlock: {(_ response: QBResponse) -> Void in
                //                    print("QuickBox : Logout successfully")
                //                }, errorBlock: {(_ response: QBResponse) -> Void in
                //                    print("QuickBox : Logout fail")
                //                })
                self.logoutAction()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        default:
            break
            
        }
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
    
    func logoutAction() {
        
        //Logout into QBchat view
        if !QBChat.instance().isConnected {
            
            SVProgressHUD.showError(withStatus: "Error")
            return
        }
        
        //Logout servicemanager
        
        QMServicesManager.instance().logout(completion: {() -> Void in
            
          //  SVProgressHUD.showSuccess(withStatus: NSLocalizedString("SA_STR_COMPLETED", comment: ""))
        })
        
        if signUpHere == ""{
            ServicesManager.instance().logoutUserWithCompletion { [weak self] (boolValue) -> () in
                
                guard let strongSelf = self else { return }
                if boolValue {
                    NotificationCenter.default.removeObserver(strongSelf)
                    
                    ServicesManager.instance().lastActivityDate = nil;
                    
                  //  let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                }
            }
        }else{
            signUpHere = ""
        }
        
        
        QBRequest.logOut(successBlock: { (response) in
            print("Successful logout",response)
            
            QBChat.instance().disconnect(completionBlock: {(_ error: Error?) -> Void in
                if (error == nil) {
                    print("Chat disconnected")
                }
                else {
                    print("Still connected",error?.localizedDescription)
                }
            })
        }) { (error) in
            print("Error in log out",error)
        }
        
        
//        //Unsubcribed Push notification
//        let deviceUdid: String? = UIDevice.current.identifierForVendor?.uuidString
//        QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceUdid!, successBlock: {(_ response: QBResponse) -> Void in
//            // Unsubscribed successfully
//        }, errorBlock: {(_ error: QBError) -> Void in
//            // Handle error
//        })
    }
}

extension LeftMenuViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell", for:indexPath as IndexPath) as! LeftMenuCell

        //Declare text in icon in tableview cell
        if(indexPath.row == 0){
            cell.lblTitle.text = "Profile"
            cell.imgLogo.image = UIImage(named: "icon_Profile")
        }else if(indexPath.row == 1){
            cell.lblTitle.text = "Purchases & Reviews"
             cell.imgLogo.image = UIImage(named: "icon_Purchases")
        } else if(indexPath.row == 2){
            cell.lblTitle.text = "Katika Rewards"
             cell.imgLogo.image = UIImage(named: "icon_Rewards")
        }
        else if(indexPath.row == 3){
            cell.lblTitle.text = "My Check-Ins"
            cell.imgLogo.image = UIImage(named: "icon_check-in")
        }
        else if(indexPath.row == 4){
            cell.lblTitle.text = "Add a Business"
            cell.imgLogo.image = UIImage(named: "icon_addbusiness")
        }
        else if(indexPath.row == 5){
            cell.lblTitle.text = "Change Currency"
            cell.imgLogo.image = UIImage(named: "icon_currency")
        }
        else if(indexPath.row == 6){
            cell.lblTitle.text = "Invite Friends"
            cell.imgLogo.image = UIImage(named: "icon_Invite")
            //            cell.imgLogo.tintColor = UIColor.lightGray
        }
        else if(indexPath.row == 7){
            cell.lblTitle.text = "Gift Card"
            cell.imgLogo.image = UIImage(named: "icon_GiftCard")
        }
        else if(indexPath.row == 8){
            cell.lblTitle.text = "Payments Information"
            cell.imgLogo.image = UIImage(named: "icon_Payements")
        }
        else if(indexPath.row == 9){
            cell.lblTitle.text = "Settings"
            cell.imgLogo.image = UIImage(named: "icon_Setting")
        }
        else if(indexPath.row == 10){
            cell.lblTitle.text = "Contact Us"
            cell.imgLogo.image = UIImage(named: "icon_ConatactUs")
        }
        else if(indexPath.row == 11){
            cell.lblTitle.text = "Log Out"
            cell.imgLogo.image = UIImage(named: "icon_Logout")
        }
        return cell
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

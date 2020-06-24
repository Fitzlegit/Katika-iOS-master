//
//  WelcomeViewController.swift
//  Katika
//
//  Created by Katika on 26/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftMessages

class WelcomeViewController: UIViewController {
   
        //Declaration Comman
    @IBOutlet var cv_Main : UICollectionView!
    @IBOutlet var pg_Main : UIPageControl!
    
    //Declaration Button
    @IBOutlet var btn_Login : UIButton!
    @IBOutlet var btn_SignUp: UIButton!
    @IBOutlet var btn_Facebook: UIButton!
    @IBOutlet var btn_Google: UIButton!
    @IBOutlet weak var btnGustUser: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    //Label Declaration
    @IBOutlet var lbl_Title: UILabel!
    @IBOutlet var lbl_Description: UILabel!
    
    var str_Type : String = ""
    var strGusetUser : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()

        if strGusetUser == ""{
            //Alredy login or not
            alredyLoginOrNot()
        }
        

        //Google
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = "689507630899-4he5kjt122o3tq3jp5ne41eokbaceb5h.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //SET BUTTON
        if strGusetUser == ""{
            btnClose.isHidden = true
            btnGustUser.isHidden = false
        }else{
            btnClose.isHidden = false
            btnGustUser.isHidden = true
        }
        self.navigationController? .setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Scrollview Delegate -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.tag)
        if cv_Main == scrollView{
            let visibleRect = CGRect(origin: cv_Main.contentOffset, size: cv_Main.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let indexPath = cv_Main.indexPathForItem(at: visiblePoint)
            
            pg_Main.currentPage = (indexPath?.row)!
            self.manageTutorial(int_value : (indexPath?.row)!)
            
        }
    }
    
    
    // MARK: - Other Files -
    func commanMethod(){
       
        //Layer Set
        btn_Facebook.layer.cornerRadius = 5.0
        btn_Facebook.layer.masksToBounds = true
        
        btn_Google.layer.cornerRadius = 5.0
        btn_Google.layer.masksToBounds = true
        
        btn_SignUp.layer.cornerRadius = 5.0
        btn_SignUp.layer.masksToBounds = true
        
        //Tutorial Page
        self.manageTutorial(int_value : 0)
    }
    func alredyLoginOrNot(){
        if ((loadCustomObject(withKey: "userobject")) != nil){
            var objUserTemp : UserDataObject = loadCustomObject(withKey: "userobject")!
            if objUserTemp.str_FirstName.length != 0 {
                //Save Object In global variable
                objUser = objUserTemp
                
                //Call API
                manageTabBarandSideBar()
                
                //Call Quick Box logIn
                loginWithQuickBox(str_Username : objUser?.str_Email as! String)
            }
            else if objUserTemp.str_User_Role == "2"{
                //Save Object In global variable
                objUser = objUserTemp
                
                //Call API
                manageTabBarandSideBar()
            }
        }
    }
    func manageServiceManager(){
        
        guard let currentUser = ServicesManager.instance().currentUser() else {
            return
        }
        
        currentUser.password = "katika123"
        
        SVProgressHUD.show(withStatus: "SA_STR_LOGGING_IN_AS".localized + currentUser.login!, maskType: SVProgressHUDMaskType.clear)
        
        // Logging to Quickblox REST API and chat.
        ServicesManager.instance().logIn(with: currentUser, completion: {
            [weak self] (success,  errorMessage) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            guard success else {
                SVProgressHUD.showError(withStatus: errorMessage)
                return
            }
            
            strongSelf.performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
        })
    }
    func manageTutorial(int_value : Int){
        switch int_value {
        case 0:
            lbl_Title.text = "Welcome to Katika"
            lbl_Description.text = "Find quality products and services \nin your local community or abroad."
            break
        case 1:
            lbl_Title.text = "Items Just For You"
            lbl_Description.text = "Independent fashion designers\nfrom around the world are\ncreating amazing designs."
            break
        case 2:
            lbl_Title.text = "Professional Services"
            lbl_Description.text = "Find doctors, lawyers, realtors,\nand countless other services\nin the Katika Directory."
            break
        case 3:
            lbl_Title.text = "Hungry? Search Katika"
            lbl_Description.text = "We'll help you fill your\ntummy with something yummy!\nSearch our directory for places near you."
            break
        case 4:
            lbl_Title.text = "Support Local Business"
            lbl_Description.text = "Our goal is to make it easier for\nyou to find desired local services."
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signin"{
            let destinationVC = segue.destination as! SignIn2ViewController
            destinationVC.strGusetUser = strGusetUser
        }
        else if segue.identifier == "signup"{
            let destinationVC = segue.destination as! SignupWithEmailViewController
            destinationVC.strGusetUser = strGusetUser
        }
    }
    
    //MARK: - Button Event -
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_SignUp(_ sender:Any){
        
        self.performSegue(withIdentifier: "signup", sender: self)
    }
    @IBAction func btn_Login(_ sender:Any){
        self.performSegue(withIdentifier: "signin", sender: self)
    }
    @IBAction func btn_Facebook(_ sender:Any){
        let login = FBSDKLoginManager()
        login.logOut()
        //ESSENTIAL LINE OF CODE
        login.loginBehavior = FBSDKLoginBehavior.browser
        
        login.logIn(withReadPermissions: ["public_profile","email", "user_friends"], handler: { (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                } else {
                    
                    if (FBSDKAccessToken.current() != nil) {
                        indicatorShow()
                        
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,first_name,last_name,id,picture.type(large), age_range"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil){
                                print(result ?? 0)
                                let dict_Data : NSDictionary = result as! NSDictionary
                                let dictPicture : NSDictionary = dict_Data["picture"] as! NSDictionary
                                let dictPictureSub : NSDictionary = dictPicture["data"] as! NSDictionary
                                
                                let dict_Dave : Dictionary = ["email" : ((dict_Data["email"] as? String) != nil) ? (dict_Data["email"] as? String) : "",
                                                                "firstname" : ((dict_Data["first_name"] as? String) != nil) ? (dict_Data["first_name"] as? String) : "",
                                                                "lastname" : ((dict_Data["last_name"] as? String) != nil) ? (dict_Data["last_name"] as? String) : "",
                                                                "id" : ((dict_Data["id"] as? String) != nil) ? (dict_Data["id"] as? String) : "",
                                                                "image" : ((dictPictureSub["url"] as? String) != nil) ? (dictPictureSub["url"] as? String) : "",
                                                                "zip" : ((dict_Data["zip"] as? String) != nil) ? (dict_Data["zip"] as? String) : ""]
                                
                                self.Post_FBGmail(flag: "FB", NSDictionary: dict_Dave as NSDictionary)
                                
                            }else{
                                  messageBar.MessageShow(title: (error?.localizedDescription)! as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
                                 indicatorHide()
                            }
                            
                        })
                    }
                }
            }else{
                messageBar.MessageShow(title: (error?.localizedDescription)! as NSString, alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
            }
        })
    
    }
    @IBAction func btnGustClicked(_ sender: Any) {
        
      Post_Guest()
    }
    @IBAction func btn_Google(_ sender:Any){
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    // MARK: - Get/Post Method -
    // MARK: - Get/Post Method -
    func Post_Guest(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)guest_register"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "email" :  "",
            "password" : "",
            "firstname" : "",
            "lastname" :  "",
            "zipcode" :  "",
            "latitude" : String(format:"%.5f", (currentLocation?.coordinate.latitude)!),
            "longitude" : String(format:"%.5f", (currentLocation?.coordinate.longitude)!),
            "address" : "",
            "devicetoken" :  UserDefaults.standard.value(forKey: "DeviceToken") == nil ? "123" : UserDefaults.standard.value(forKey: "DeviceToken")! as! String,
            "devicetype" : "I",
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "guest_register"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.startDownload()
    }
    
    
    func Post_FBGmail(flag : String , NSDictionary : NSDictionary){
        
        if NSDictionary["email"] as! String == "" {
            messageBar.MessageShow(title:"We not getting your email address with login. Please try login with use of another id.", alertType: MessageView.Layout.CardView, alertTheme: .error, TopBottom: true)
        }else{
        
            //Declaration URL
            let strURL = "\(Constant.BaseURL)fb_gmail_login"
            
            //Pass data in dictionary
            var jsonData : NSDictionary =  [:]
            jsonData = [
                "email" : NSDictionary["email"] as! String,
                "firstname" : NSDictionary["firstname"] as! String,
                "lastname" : NSDictionary["lastname"] as! String,
                "zipcode" : NSDictionary["zip"] as! String,
                "socialid" : NSDictionary["id"] as! String,
                "registration_by" : flag,
                "profile_image" : NSDictionary["image"] as! String,
                "latitude" : String(format:"%.5f", (currentLocation?.coordinate.latitude)!),
                "longitude" : String(format:"%.5f", (currentLocation?.coordinate.longitude)!),
                "address" : currentCityName,
                "devicetoken" :  UserDefaults.standard.value(forKey: "DeviceToken") == nil ? "123" : UserDefaults.standard.value(forKey: "DeviceToken")! as! String,
                "devicetype" : "I",
            ]
            print(strURL)

            print(jsonData)
            //Create object for webservicehelper and start to call method
            let webHelper = WebServiceHelper()
            webHelper.strMethodName = "fb_gmail_login"
            webHelper.methodType = "post"
            webHelper.strURL = strURL
            webHelper.dictType = jsonData
            webHelper.dictHeader = NSDictionary
            webHelper.delegateWeb = self
            webHelper.serviceWithAlert = true
            webHelper.indicatorShowOrHide = true
            webHelper.startDownload()
        }
    }
    func Get_RegistrationQuickBoxUser(str_QuickBoxID : String){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)update_quickbloxid"
        
        //Pass data in dictionary
        var jsonData : NSMutableDictionary =  NSMutableDictionary()
        jsonData = [
            "userid" : objUser?.str_Userid as! String,
            "quickbloxid" : str_QuickBoxID,
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "update_quickbloxid"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
    }
    
    @objc func loginWithQuickBoxwithRegistration(){
                
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            SVProgressHUD.show(withStatus: "Loading..".localized, maskType: SVProgressHUDMaskType.clear)
            
            QBRequest.logIn(withUserLogin: objUser?.str_Email as! String, password: "katika123", successBlock: {(_ response: QBResponse, _ user: QBUUser!) -> Void in
                // Registion user because of first Time
                self.Get_RegistrationQuickBoxUser(str_QuickBoxID : String(user.id))
                
                
                //Login with QBChat room
                let user1 = QBUUser()
                user1.id = UInt(user.id)
                user1.password = "katika123"
                
                QBChat.instance().connect(with: user1, completion: {(_ error: Error?) -> Void in
                    
                    if error == nil{
                        if QBChat.instance().isConnected {
                            print("QuickBox : login succssfully")
                            SVProgressHUD.dismiss()
                        }
                        else {
                            print("QuickBox : login fail")
                            SVProgressHUD.dismiss()
                        }
                        
                    }
                })
            }, errorBlock: {(_ response: QBResponse) -> Void in
                print("QuickBox : login fail")
                SVProgressHUD.dismiss()
                indicatorHide()
            })
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


//MARK: - Collection View -
extension WelcomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pg_Main.numberOfPages = 5
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WelcomeViewCollectionCell
        
        cell.img_Intro.image = UIImage.init(named: "img_Intro\(indexPath.row+1)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
}


//MARK: - Collection View Cell -
class WelcomeViewCollectionCell : UICollectionViewCell{
    
    @IBOutlet weak var img_Intro : UIImageView!
    
}


extension WelcomeViewController : GIDSignInUIDelegate,GIDSignInDelegate{
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let dimension = round(100 * UIScreen.main.scale);
            let pic = user.profile.imageURL(withDimension: UInt(dimension))
           // let path : String! = "\(pic!.path)"
            let path : NSString = pic!.absoluteString as NSString

            
            let dict_Dave : Dictionary = ["email" : user.profile.email ,
                                          "firstname" : user.profile.name,
                                          "lastname" : "" ,
                                          "id" : user.userID ,
                                          "image" : path,
                                          "zip" : "" ] as [String : Any]
            
            self.Post_FBGmail(flag: "Gmail", NSDictionary: dict_Dave as NSDictionary)
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: Error!) {
        // myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WelcomeViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        let response = data as! NSDictionary
        print(response)
        
//        let currency = self.storyboard?.instantiateViewController(withIdentifier: "ChangeCurrencyViewController") as! ChangeCurrencyViewController
//        currency.ShowBackButton = "1"
//        self.navigationController?.pushViewController(currency, animated: true)
//
        if strRequest == "guest_register" {
            let dict_result = response["user_details"] as! NSDictionary
            let dict_RewardPoint = dict_result["reward"] as! NSDictionary
            
            //Store data in object
            let obj = UserDataObject(str_FirstName: dict_result["firstname"] as! String as NSString,
                                     str_LastName: dict_result["lastname"]  as! String as NSString,
                                     str_Userid: String(dict_result["userid"] as! Int) as NSString,
                                     str_Profile_Image: dict_result["profile_image"] as! String as NSString,
                                     str_Email: dict_result["email"] as! String as NSString,
                                     str_Zipcode: dict_result["zipcode"] as! String as NSString,
                                     str_Lat: dict_result["user_lat"] as! String as NSString,
                                     str_Long: dict_result["user_long"] as! String as NSString,
                                     str_Address: dict_result["address"] as! String as NSString,
                                     str_RegistrationDate: dict_result["registration_date"] as! String as NSString,
                                     str_CardCount:String(dict_result["total_cart_item"] as! Int) as NSString,
                                     str_CheckoutTocken:"",
                                     str_RewardPoint: dict_result["reward_points"] as! String as NSString,
                                     str_Quickbox: "",
                                     str_RewardBronze: String(dict_RewardPoint["Bronze"] as! Int) as NSString,
                                     str_RewardGolf: String(dict_RewardPoint["Gold"] as! Int) as NSString,
                                     str_RewardSilver: String(dict_RewardPoint["Silver"] as! Int) as NSString,
                                     str_RewardDiamond: String(dict_RewardPoint["Diamond"] as! Int) as NSString,
                                     str_Currency: dict_result["select_currency"] as! String as NSString,
                                     str_LoginType: "user",
                                     str_User_Role: String(dict_result["user_role"] as! Int) as NSString)
            
            saveCustomObject(obj, key: "userobject");
            
            //Save Object In global variable
            objUser = obj
            
            UserDefaults.standard.set("", forKey: "HomeTutorial")
            
            //Call Quick Box logIn
            str_Type = "0"
            
            //Call API
            manageTabBarandSideBar()

        }
        else    if strRequest == "fb_gmail_login" {

            let dict_result = response["user_details"] as! NSDictionary
            let dict_RewardPoint = dict_result["reward"] as! NSDictionary

            //Store data in object
     
            
            let obj = UserDataObject(str_FirstName: dict_result["firstname"] as! String as NSString,
                                     str_LastName: dict_result["lastname"]  as! String as NSString,
                                     str_Userid: String(dict_result["userid"] as! Int) as NSString,
                                     str_Profile_Image: dict_result["profile_image"] as! String as NSString,
                                     str_Email: dict_result["email"] as! String as NSString,
                                     str_Zipcode: dict_result["zipcode"] as! String as NSString,
                                     str_Lat: dict_result["user_lat"] as! String as NSString,
                                     str_Long: dict_result["user_long"] as! String as NSString,
                                     str_Address: dict_result["address"] as! String as NSString,
                                     str_RegistrationDate:dict_result["registration_date"] as! String as NSString,
                                     str_CardCount:String(dict_result["total_cart_item"] as! Int) as NSString,
                                     str_CheckoutTocken:dict_result["customerid"] as! String as NSString,
                                     str_RewardPoint:String(dict_result["reward_points"] as! String) as NSString,
                                     str_Quickbox: dict_result["quickblox_id"] as! String as NSString,
                                     str_RewardBronze: String(dict_RewardPoint["Bronze"] as! Int) as NSString,
                                     str_RewardGolf: String(dict_RewardPoint["Gold"] as! Int) as NSString,
                                     str_RewardSilver: String(dict_RewardPoint["Silver"] as! Int) as NSString,
                                     str_RewardDiamond: String(dict_RewardPoint["Diamond"] as! Int) as NSString,
                                     str_Currency: dict_result["select_currency"] as! String as NSString,
                                     str_LoginType: "social",
                                     str_User_Role: String(dict_result["user_role"] as! Int) as NSString)
            saveCustomObject(obj, key: "userobject");

            //Save Object In global variable
            objUser = obj

            if response["msg"] as! String == "Login successfully." {
                UserDefaults.standard.set("", forKey: "HomeTutorial")

                //Call Quick Box logIn
                str_Type = "0"
                loginWithQuickBox(str_Username : dict_result["email"] as! String)

                if strGusetUser == "1"{
                    self.dismiss(animated: true, completion: nil)

                }
                else{
                    //Call API
                    manageTabBarandSideBar()
                }

                
            }else{
                UserDefaults.standard.set(nil, forKey: "HomeTutorial")

                //Registration quickBox user
                RegistrationWithQuickBox(str_UserName : dict_result["email"] as! String , str_Login : dict_result["email"] as! String)

                str_Type = "1"
                Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.loginWithQuickBoxwithRegistration), userInfo: nil, repeats: false)
            }
        }else if strRequest == "update_quickbloxid" {

            if str_Type == "1"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "ChangeCurrencyViewController") as! ChangeCurrencyViewController
                view.str_IsLogin = "1"
                self.navigationController?.pushViewController(view, animated: true)
            }else{
                //Call API
                manageTabBarandSideBar()
            }
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
    
}

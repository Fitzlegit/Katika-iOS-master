 //
//  AppDelegate.swift
//  Katika
//
//  Created by Katika on 17/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SafariServices
import SystemConfiguration
import CoreLocation
import Alamofire
import EventKit
import Firebase
 import Stripe
 

//Pod File
import SwiftMessages
import ActionSheetPicker_3_0
import FacebookLogin
import FBSDKCoreKit
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
 import Contacts
 import ContactsUI
 
import BraintreeDropIn
import Braintree
import PassKit
 
//Global Declaration
var vw_BaseView: LeftMenuViewController?
var act_indicator = ActivityIndicatorViewController()
var messageBar = MessageBarController()
var AppDelegateHere = AppDelegate()
var currentLocation : CLLocation?
var currentCityName : NSString = ""
var objUser : UserDataObject?
var arrContryList : NSMutableArray = []
var deviceTokenStored : Data?
var katikaViewSelection : NSString = ""
var signUpHere : NSString = ""
var contactStore = CNContactStore()
 
 //Float Decalartion
 var float_Latitude : Float = 0.0
 var float_Longitude : Float = 0.0
 
@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager : CLLocationManager?
    var dict_Push : NSDictionary = [:]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.backgroundColor
      
        STPPaymentConfiguration.shared().publishableKey = "pk_live_xanVi2Wl6LCXwTTBsHasmSiX"
        //pk_live_xanVi2Wl6LCXwTTBsHasmSiX"  //pk_test_n3BLz84NXfRVh3l9qurcQ8zR

        //Text editing manager
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20.0
        
        BTAppSwitch.setReturnURLScheme("com.app.katika.payments")
        
        //Navigation set
        navigationSet()
        
        //Get location
        location()
        
        //Service Calling
        Get_ContryListing()
        
        //Font Name
//        prFloat(UIFont.familyNames)
//        print(UIFont.fontNames(forFamilyName: "Avenir"))
        
        //Facebook Compusary method
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        //QuickBox
        QuickBoxSetUp()

        //Google Anality
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return true
        }
        gai.tracker(withTrackingId: Constant.apiKeyGoogleAnality)
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
        gai.dispatchInterval = 0

        //Febric
        Fabric.with([Crashlytics.self])

        // app was launched from push notification, handling it
        let remoteNotification: NSDictionary! = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
        if (remoteNotification != nil) {
            ServicesManager.instance().notificationService.pushDialogID = remoteNotification["SA_STR_PUSH_NOTIFICATION_DIALOG_ID".localized] as? String
            
            let when = DispatchTime.now() + 1 
            DispatchQueue.main.asyncAfter(deadline: when) {
                //do stuff here
                self.openNotification(launchOptions!)
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //Get device token
        DispatchQueue.main.async {
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        if Constant.appLive == true{
            FirebaseApp.configure()
        }
        
        Thread.sleep(forTimeInterval: 3.0)

        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        QBChat.instance().disconnect(completionBlock: {(_ error: Error?) -> Void in
        })
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if (objUser != nil){
            if objUser?.str_Quickbox as! String != ""{
                //Current user login here
                let user1 = QBUUser()
                user1.id = UInt(objUser?.str_Quickbox as! String)!
                user1.password = "katika123";
                
                QBChat.instance().connect(with: user1, completion: {(_ error: Error?) -> Void in
                })
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        QBChat.instance().disconnect(completionBlock: {(_ error: Error?) -> Void in
        })
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if url.scheme == "fb1247385478707308" {
        if url.scheme == "fb180325239405006" {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }else if url.scheme == "com.googleusercontent.apps.689507630899-4he5kjt122o3tq3jp5ne41eokbaceb5h"{
            var options: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                                UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
            return GIDSignIn.sharedInstance().handle(url,
                                                        sourceApplication: sourceApplication,
                                                        annotation: annotation)
        }else  {
            return BTAppSwitch.handleOpen(url, sourceApplication: sourceApplication)
        }
    }
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
//        if url.scheme?.localizedCaseInsensitiveCompare("com.app.katika.payments") == .orderedSame {
//            return BTAppSwitch.handleOpen(url, options: options)
//        }
//        return true
//    }

    
    // MARK: - Navigation Manager -
    func navigationSet() {
        UINavigationBar.appearance().setBackgroundImage(image(with: UIColor.init(colorLiteralRed: 248/256, green: 248/256, blue: 248/256, alpha: 1.0)), for: .default)
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.black, NSAttributedString.Key.font.rawValue: UIFont(name:  Constant.kFontSemiBold, size: 17.0)!])
        UINavigationBar.appearance().shadowImage = UIImage(named: "img_Shadow")
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    // MARK: - Location Manager -
    func location(){
//        currentLocation = CLLocation(latitude: 0, longitude: 0)
//
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        self.locationManager?.requestAlwaysAuthorization()
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager?.startUpdatingLocation()

        currentLocation = CLLocation(latitude: 0, longitude: 0)
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.startUpdatingLocation()
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation != nil {
            currentLocation = locations.last
            
            //Float Decalartion
            float_Latitude  = Float((currentLocation?.coordinate.latitude)!)
            float_Longitude = Float((currentLocation?.coordinate.longitude)!)
            
            
            
            locationManager?.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            print("locations = \(locationValue)")
            locationManager?.stopUpdatingLocation()
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(currentLocation!, completionHandler: {(placemarks, error)->Void in
                var placemark:CLPlacemark!
                
                if error == nil && (placemarks?.count)! > 0 {
                    placemark = (placemarks?[0])! as CLPlacemark
                    
                    var addressString : String = ""
                    
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality! + ", "
                        currentCityName = placemark.locality! as NSString
                        print(placemark.postalCode)
                    }
                }
            })
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    // MARK: - Push Notification -
    func notification(_ application: UIApplication) {
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
    }
    func openNotification(_ launchOptions: [AnyHashable: Any]) {
        UserDefaults.standard.set("0", forKey: "notificationCount")
        UIApplication.shared.applicationIconBadgeNumber = 0
        let dict = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] ?? [AnyHashable: Any]()

        if (Constant.developerTest == true) {
            //Notification formate generate
            let alert = UIAlertController(title: Constant.appName, message: "\(dict)", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            Constant.appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }else{
            dict_Push = dict as NSDictionary
            let dict_Data = dict["aps"] as! NSDictionary
            
            if dict_Data["Type"] as! String == "PRODUCTADD"{
                vw_OpenWhenNotificationCome(type : dict_Data["Type"] as! String, key : dict_Data["ID"] as! String as NSString)
            }else if dict_Data["Type"] as! String == "FAV_ITEM3"{
                self.vw_OpenWhenNotificationCome(type : dict_Data["Type"] as! String, key : "")
            }else if dict_Data["Type"] as! String == "SHOPDETAIL"{
                self.vw_OpenWhenNotificationCome(type : dict_Data["Type"] as! String, key : "")
            }
            
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        var dict : NSDictionary = userInfo as NSDictionary
        
        if (Constant.developerTest == true) {
            //Notification formate generate
            let alert = UIAlertController(title: Constant.appName, message: "\(dict)", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            Constant.appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }else{
            dict_Push = dict 
            
            let dict_Data = dict["aps"] as! NSDictionary

            //Notification formate generate
            let alert = UIAlertController(title: Constant.appName, message: dict_Data["alert"] as? String, preferredStyle: UIAlertController.Style.alert)
            
            //Condition for open button visible or not for perticular notification
            if dict_Data["Type"] as! String == "PRODUCTADD" || dict_Data["Type"] as! String == "FAV_ITEM3" || dict_Data["Type"] as! String == "SHOPDETAIL"{
                
                let firstAction = UIAlertAction(title: "Open", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
                    if dict_Data["Type"] as! String == "PRODUCTADD"{
                        self.vw_OpenWhenNotificationCome(type : dict_Data["Type"] as! String, key : dict_Data["ID"] as! String as NSString)
                    }else if dict_Data["Type"] as! String == "FAV_ITEM3"{
                        self.vw_OpenWhenNotificationCome(type : dict_Data["Type"] as! String, key : "")
                    }else if dict_Data["Type"] as! String == "SHOPDETAIL"{
                        self.vw_OpenWhenNotificationCome(type : dict_Data["Type"] as! String, key : "")
                    }
                })
                alert.addAction(firstAction)
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            Constant.appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    func vw_OpenWhenNotificationCome(type : String, key : NSString) {
    
        if type == "PRODUCTADD"{
            
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            profileViewController.str_ProductIDGet = key
            rootViewController.pushViewController(profileViewController, animated: false)
            
        }else if type == "FAV_ITEM3"{
            vw_BaseView?.callmethod(_int_Value: 1)
        }else if type == "SHOPDETAIL"{
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
            profileViewController.str_ShopIDGet = key
            rootViewController.pushViewController(profileViewController, animated: false)
        }
    }
    
    
    // MARK: - Make Image with Color -
    func image(with color: UIColor) -> UIImage {
        let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(1.0), height: CGFloat(1.0))
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    // MARK: - Device Tocken -
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(token, forKey: "DeviceToken")
        
        deviceTokenStored = deviceToken
        
        //Register notification for quickbox
        let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
        let subscription: QBMSubscription! = QBMSubscription()
        
        subscription.notificationChannel = QBMNotificationChannel.APNS
        subscription.deviceUDID = deviceIdentifier
        subscription.deviceToken = deviceToken
        QBRequest.createSubscription(subscription, successBlock: { (response: QBResponse!, objects: [QBMSubscription]?) -> Void in
            //
            
        }) { (response: QBResponse!) -> Void in
            //
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UserDefaults.standard.set("", forKey: "DeviceToken")
        print("Print ::Failed to get token, error: \(error)")
    }
    
    
    
  
    // MARK: - Get/Post Method -
    func Get_ContryListing(){
        
        //Declaration URL
        let strURL = "http://13.59.254.172/katika/api/v1/get_country"
        print(strURL)
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_country"
        webHelper.methodType = "get"
        webHelper.strURL = strURL
        webHelper.dictType = NSDictionary()
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
        webHelper.indicatorShowOrHide = false
        webHelper.startDownload()
    }
}

 // MARK: - Quick Box -
 
 extension AppDelegate : NotificationServiceDelegate {
    
    func QuickBoxSetUp(){
        // Set QuickBlox credentials (You must create application in admin.quickblox.com).
        QBSettings.setApplicationID(Constant.kQBApplicationID)
        QBSettings.setAuthKey(Constant.kQBAuthKey)
        QBSettings.setAuthSecret(Constant.kQBAuthSecret)
        QBSettings.setAccountKey(Constant.kQBAccountKey)
        
        // enabling carbons for chat
        QBSettings.setCarbonsEnabled(true)
        
        // Enables Quickblox REST API calls debug console output.
        QBSettings.setLogLevel(QBLogLevel.nothing)
        
        // Enables detailed XMPP logging in console output.
        QBSettings.enableXMPPLogging()
        ServicesManager.enableLogging(false)
        
        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            QBSettings.setApplicationID(92)
            
            return true
        }
    }
    
    // MARK: -- Quick Box NotificationServiceDelegate protocol --
    func notificationServiceDidStartLoadingDialogFromServer() {
    }
    
    func notificationServiceDidFinishLoadingDialogFromServer() {
    }
    
    func notificationServiceDidSucceedFetchingDialog(chatDialog: QBChatDialog!) {
        let navigatonController: UINavigationController! = self.window?.rootViewController as! UINavigationController
        
        let chatController: ChatViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatController.dialog = chatDialog
        
        let dialogWithIDWasEntered = ServicesManager.instance().currentDialogID
        if !dialogWithIDWasEntered.isEmpty {
            // some chat already opened, return to dialogs view controller first
            navigatonController.popViewController(animated: false);
        }
        
        navigatonController.pushViewController(chatController, animated: true)
    }
    
    func notificationServiceDidFailFetchingDialog() {
    }
    
    func NotificationManagerSetting(){
        if (ServicesManager.instance().notificationService.pushDialogID != nil) {
            ServicesManager.instance().notificationService.handlePushNotificationWithDelegate(delegate: self)
        }
    }
 }

 
//MARK: - Global Function (Access to Hall app) -
//MARK: -- Get height respect to font lenth --
func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}
 
func notPrettyString(from object: Any) -> String? {
    if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
        let objectString = String(data: objectData, encoding: .utf8)
        return objectString
    }
    return nil
 }
 func notPrettyArray(from: String) -> NSArray?{
    let str = "{\"name\":\(from)}"
    let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
//        if let names = json["names"] as? [String] {
//            print(names)
//        }
        return json["name"] as! NSArray
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
    return []
 }

//MARK: -- Manage Font --
func manageFont(font: Double) -> Double
{
    return (font * Constant.windowHeight) / Constant.screenHeightDeveloper
    // println("Hello \(name).... All your base belong to us!")
}


//MARK: -- OpenURL --
 func openURLToWeb(url : URL){
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    } else {
        UIApplication.shared.openURL(url)
    }
 }
 
//MARK: -- Share To All --
 func shareFunction(textData : String,image : UIImage,viewPresent: UIViewController){
    // text to share
    let text = "This is some text that I want to share."
    
    // set up activity view controller
    let textToShare = [textData,image] as [Any]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = viewPresent.view // so that iPads won't crash

    // present the view controller
    viewPresent.present(activityViewController, animated: true, completion: nil)
 }

 
 
//MARK: -- Inicator --
func indicatorShow(){
    let size = CGSize(width: 30, height: 30)
    
    act_indicator.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue:5)!)
}
func indicatorHide(){
    act_indicator.stopAnimating()
}

//MARK: -- Selected Index --
func selectedIndex(arr : NSArray, value : NSString) -> Int{
    for (index, element) in arr.enumerated() {
        if value as String == arr[index] as! String {
            return index
        }
    }
    return 0
}

//MARK: -- Email Validation --
func validateEmail(enteredEmail:String) -> Bool {
    
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)
}

//MARK: -- Set up Tabbar and sidebar controller --
func manageTabBarandSideBar(){
    //Store data in object
    
    //Declare alloc init for storyboard/Mange Tab bar
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let mainViewController = storyboard.instantiateViewController(withIdentifier: "KatikaDirectoryMainViewController") as! KatikaDirectoryMainViewController
    let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
    
    let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
    
    //Declare Slidemenucontroller with connect sidebar and menubar
    let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
    slideMenuController.automaticallyAdjustsScrollViewInsets = true
    slideMenuController.delegate = mainViewController
    let calculationValue = (Constant.windowWidth * 82) / 100
    slideMenuController.changeLeftViewWidth(CGFloat(calculationValue))
    
    //Manage Slidemenu
    SlideMenuOptions.hideStatusBar = false
    SlideMenuOptions.contentViewOpacity = 0.0
    SlideMenuOptions.contentViewScale = 0.5
    
    //Call navigation with push view controller
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    _ =  mainStoryboard.instantiateViewController(withIdentifier: "NewHomeViewController") as! NewHomeViewController
    
    let appDelegate2 = UIApplication.shared.delegate as! AppDelegate
    let nav2: UINavigationController! = (appDelegate2.window?.rootViewController as! UINavigationController)
    nav2?.pushViewController(slideMenuController, animated: false)
}

//MARK: -- User Object --
func saveCustomObject(_ object: UserDataObject, key: String) {
    let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
    let defaults = UserDefaults.standard
    defaults.set(encodedObject, forKey: key)
    defaults.synchronize()
}

func loadCustomObject(withKey key: String) -> UserDataObject? {
    let defaults = UserDefaults.standard
    let encodedObject: Data? = defaults.object(forKey: key) as! Data?
    if encodedObject != nil {
        let object: UserDataObject? = NSKeyedUnarchiver.unarchiveObject(with: encodedObject!) as! UserDataObject?
        return object!
    }
    return nil
}

 //MARK: -- Data Formate Convertion --
 func localDateToStrignDate(date : String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    //First convert date in server formate
    let dateHere = dateFormatter.date(from: date)
    
    //Required formate convert
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter.string(from: dateHere!)
 }
 func localDateToStrignDate2(date : String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    //First convert date in server formate
    let dateHere = dateFormatter.date(from: date)
    
    //Required formate convert
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.string(from: dateHere!)
 }

 
 // MARK: -- Quickbox Login --
 func loginWithQuickBox(str_Username : String){
    
    let when = DispatchTime.now() + 1.0
    DispatchQueue.main.asyncAfter(deadline: when) {
        
        SVProgressHUD.show(withStatus: "Loading..".localized, maskType: SVProgressHUDMaskType.clear)
        QBRequest.logIn(withUserLogin: str_Username, password: "katika123", successBlock: {(_ response: QBResponse, _ user: QBUUser!) -> Void in
            // Login succeeded
            
            //Login with QBChat room
            let user1 = QBUUser()
            user1.id = UInt(user.id)
            user1.password = "katika123"
            
            QBChat.instance().connect(with: user1, completion: {(_ error: Error?) -> Void in
                print("Error: \(String(describing: error))")
                
                
                if error == nil{
                    if QBChat.instance().isConnected {
                        print("QuickBox : login succssfully")
                        manageServiceManager()
                        indicatorHide()
                        SVProgressHUD.dismiss()
                    }
                    else {
                        print("QuickBox : login fail")
                        indicatorHide()
                        SVProgressHUD.dismiss()
                    }
                }
            })
        }, errorBlock: {(_ response: QBResponse) -> Void in
            print("QuickBox : login fail")
            indicatorHide()
            SVProgressHUD.dismiss()
        })
    }
    
   
 }
 
 
 
 // MARK: -- Quickbox Registration --
 func RegistrationWithQuickBox(str_UserName : String , str_Login : String){
//    indicatorShow()
    
    let user = QBUUser()
    
    //Crediancial for registration
    user.fullName = str_UserName
    user.login = str_Login
    user.password = "katika123"
    
    var request = QBRequest.signUp(user, successBlock: {(_ response: QBResponse, _ newUser: QBUUser) -> Void in
        print("QuickBox : registration successfully")
    } as? (QBResponse, QBUUser?) -> Void, errorBlock: {(_ response: QBResponse) -> Void in

    })

 }
 
  // MARK: -- Quickbox Create Group between two user --
 func createGroupWithQuickBox(str_ID : Int , view : UIViewController){
    indicatorShow()
    
    let chatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.private)
    chatDialog.name = "Chat"

    var castAsNSNumber = NSNumber(value: Int(str_ID))

    chatDialog.occupantIDs = [(castAsNSNumber)]

    QBRequest.createDialog(chatDialog, successBlock: { (response: QBResponse?, createdDialog : QBChatDialog!) -> Void in

         print(createdDialog.id!)
        ServicesManager.instance().chatService.loadDialog(withID:createdDialog.id!)
        ServicesManager.instance().chatService.loadDialog(withID: createdDialog.id!, completion: { (loadedDialog: QBChatDialog?) -> Void in
            indicatorHide()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewGet = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            viewGet.dialog = createdDialog
            view.navigationController?.pushViewController(viewGet, animated: false)
            
        })

        print("create dialog success")

    }) { (responce : QBResponse!) -> Void in
        indicatorHide()
        print("create dialog fail")
    }
 }
 
  // MARK: -- Service manage (After completed login in quickbox) --
 func manageServiceManager(){
    
    guard let currentUser = ServicesManager.instance().currentUser() else {
        return
    }
    
    currentUser.password = "katika123"
    
    // Logging to Quickblox REST API and chat.
    ServicesManager.instance().logIn(with: currentUser, completion: {
        (success,  errorMessage) -> Void in
        
        guard success else {
            SVProgressHUD.showError(withStatus: errorMessage)
            return
        }
        
        //Notification Setting
        Constant.appDelegate?.NotificationManagerSetting()
        
        //Register notification for quickbox
        let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
        let subscription: QBMSubscription! = QBMSubscription()
        
        subscription.notificationChannel = QBMNotificationChannel.APNS
        subscription.deviceUDID = deviceIdentifier
        subscription.deviceToken = deviceTokenStored
        QBRequest.createSubscription(subscription, successBlock: { (response: QBResponse!, objects: [QBMSubscription]?) -> Void in
            
        }) { (response: QBResponse!) -> Void in

        }
        
//        SVProgressHUD.showSuccess(withStatus: "QuickBox Connected")
        
    })
 }
 
 // MARK: -- Reward Point Manage --
 func manageRewardModule(type : String) -> String{
    
    if type == "point" {
        return objUser?.str_RewardPoint as! String
    }
    else if type == "stage" {
        if Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardBronze as! String)! {
            return "Bronze"
        }else if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardSilver as! String)! {
            return "Silver"
        }else if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardGolf as! String)! {
            return "Gold"
        }else if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardDiamond as! String)! {
            return "Diamond"
        }else{
            return "Diamond"
        }
    }
    else if type == "nextstage" {
        if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardGolf as! String)! {
            return "\(objUser?.str_RewardSilver as! String) points until Silver"
        }else if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardBronze as! String)! {
            return "\(objUser?.str_RewardGolf as! String) points until Gold"
        }else if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardSilver as! String)! {
            return "\(objUser?.str_RewardDiamond as! String) points until Diamond"
        }else if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardDiamond as! String)! {
            return "\(objUser?.str_RewardDiamond as! String) Last stage Diamond"
        }else{
            return ""
        }
    }
    else if type == "circle" {
        //Angle set between 0(Min) to 280(Max)
        var valueMul : Float = 280 * Float(objUser?.str_RewardPoint as! String)!
        
        if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardBronze as! String)! {
                        
            var valueBronze : Float = Float(objUser?.str_RewardBronze as! String)!
            var valueDiv : Float = valueMul / valueBronze
            
            return String(valueDiv)
        }else if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardGolf as! String)! {

            var valueDiv : Float = valueMul / Float(objUser?.str_RewardGolf as! String)!
            
            return String(valueDiv)
        }else if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardSilver as! String)! {
            
            var valueDiv : Float = valueMul / Float(objUser?.str_RewardSilver as! String)!
            
            return String(valueDiv)
        }else if  Float(objUser?.str_RewardPoint as! String)! < Float(objUser?.str_RewardDiamond as! String)! {
            
            var valueDiv : Float = valueMul / Float(objUser?.str_RewardDiamond as! String)!
            
            return String(valueDiv)
        }else{
            return String(280)
        }
    }
    
    return ""
    
 }
 
 // MARK: -- Reward Point Manage --
 func networkOnOrOff() -> Bool{
    
    if NetworkReachabilityManager()!.isReachable {
        return true
    }
    return false
 }
 
 
 
 //MARK: - Country Object -
 class ContryListingObject: NSObject {
    
    var str_ID : NSString = ""
    var str_Name : NSString = ""
 }
 
 
 //MARK: - Webservice Helper -
 extension AppDelegate : WebServiceHelperDelegate{
    
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let arr_List : NSMutableArray = []
        let response = data as! NSDictionary
        if strRequest == "get_country" {
            
            let arr_result = response["Result"] as! NSArray
            
            //Demo data
            let obj = ContryListingObject ()
            obj.str_ID = "0"
            obj.str_Name = "All"
            arr_List.add(obj)
            
            for i in 0..<arr_result.count{
                let dict_Sub_Address = arr_result[i] as! NSDictionary
                
                //Real Data
                let obj = ContryListingObject ()
                obj.str_ID = ("\(dict_Sub_Address["country_id"] as! Int)" as NSString)
                obj.str_Name = dict_Sub_Address["country_name"] as! String as NSString
                arr_List.add(obj)
            }
            arrContryList = arr_List
            
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        // self.completedServiceCalling()
    }
 }


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

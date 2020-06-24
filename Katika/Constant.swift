//
//  Constant.swift
//  Katika
//
//  Created by Katika on 17/05/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

// Avenir for the app font: with its alternatives (i.e. thin, medium, heavy)
///*pod 'BraintreeDropIn'

import UIKit


class Constant: NSObject {
    static let developerTest : Bool = false
    static let appLive : Bool = true
    
    //Implementation View height
    static let screenHeightDeveloper : Double = 667
    static let screenWidthDeveloper : Double = 375
    
    //Base URL

    
    //DEVELOPMENT BASE URL
//    static let BaseURL = "https://shopkatika.com/development/api/v2/"

    //LIVE BASE URL
    static let BaseURL = "https://shopkatika.com/katika/api/v2/"

    //Name And Appdelegate Object
    static let appName: String = "Katika"
    static let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    
    //System width height
    static let windowWidth: Double = Double(UIScreen.main.bounds.size.width)
    static let windowHeight: Double = Double(UIScreen.main.bounds.size.height)
    
    //Fontƒ√
    static let kFontLight = "Avenir-Light"
    static let kFontRegular = "Avenir-Book"
    static let kFontSemiBold = "Avenir-Medium"
    static let kFontBold = "Avenir-Heavy"    
    
    //Google Api forKey
    static let apiKeyGoogle = "AIzaSyDQy9sCLvDj2anzl8152anNw-nXC3rBpik" //AIzaSyDuRbLYlvSvQWK_Kwp7pe93yOQ7KbM-Hkc
    
    //Google AnalityKey
    static let apiKeyGoogleAnality = "UA-105722820-1"
    
    //Device Token
    static let DeviceToken = UserDefaults.standard.object(forKey: "DeviceToken")
    
    //Place holder
    static let placeHolder_User = "icon_Demo_Person"
    static let placeHolder_Comman = "Img_SignInView"
    
    //Loading data pagination
    static let int_LoadMax = 10
    
    static let int_Minimumvalue_Use_RewardPoint : Float = 250
    static let int_ReasionofRewardPointAndDollar : Float = 10
    
    //Quick Box Setup
    static let kQBAuthKey = "Hwbq4MHumkR99Qj" //MbyaeEc-BP3Jfj7
    static let kQBAuthSecret = "NwKOVeA9L75SDmC" //kyQzt-4r-OJAt-w
    static let kQBAccountKey = "vWVR7UHdygNsnwbV3NcK" //z98SEjY2jLkDM5DzhEZa
    static let kQBApplicationID:UInt = 64028 //61395
    
    //Search listing hide or not
    static let SearchlistingresultKatikaDirectory : Bool = false
    static let KatikaDirectoryMapShow : Bool = false
    static let KatikaDirectoryClustoringShow : Bool = false
    
    // Using a property
    var firstName: String!
    func printSomething(name: String)
    {
        // println("Hello \(name).... All your base belong to us!")
    }
}



// MARK: - SET COLOR
//SET IMAGE COLOR
func imgColor (imgColor : UIImageView , colorHex: String){
    let templateImage = imgColor.image?.withRenderingMode(UIImage.UIImage.RenderingMode.alwaysTemplate)
    imgColor.image = templateImage
    imgColor.tintColor = hexStringToUIColor(hex: colorHex)
}
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    let aCString = cString.cString(using: String.Encoding.utf8)
    let length = strlen(aCString)// returns a UInt
    if (length != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
//MARK: - Manage function for value save -
extension NSDictionary {

    func getStringForID(key: String) -> String? {
        
        var strKeyValue : String = ""
        if (self[key] as? String) != nil {
            strKeyValue = self[key] as? String ?? ""
        } else if (self[key] as? Int) != nil {
            strKeyValue = String(self[key] as? Int ?? 0)
        } else if (self[key] as? Float) != nil {
            strKeyValue = String(self[key] as? Float ?? 0.0)
        } else if (self[key] as? Double) != nil {
            strKeyValue = String(self[key] as? Double ?? 0)
        } else if (self[key] as? Bool) != nil {
            let bool_Get = self[key] as? Bool ?? false
            if bool_Get == true{
                strKeyValue = "1"
            }else{
                strKeyValue = "0"
            }
        }
        return strKeyValue
    }
    
    func getArrayVarification(key: String) -> NSArray {
        
        var strKeyValue : NSArray = []
        if self[key] != nil {
            if (self[key] as? NSArray) != nil {
                strKeyValue = self[key] as? NSArray ?? []
            }
        }
        return strKeyValue
    }
}


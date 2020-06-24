//
//  UserDataObject.swift
//  HealthyBlackMen
//
//  Created by Katika on 16/05/17.
//  Copyright © 2017 Katika. All rights reserved.
//

import UIKit

class UserDataObject: NSObject,NSCoding  {
    //NSCoding
    
    var str_FirstName : NSString = ""
    var str_LastName : NSString = ""
    var str_Userid : NSString = ""
    var str_Profile_Image : NSString = ""
    var str_Email : NSString = ""
    var str_Zipcode : NSString = ""
    var str_Lat : NSString = ""
    var str_Long : NSString = ""
    var str_Address : NSString = ""
    var str_RegistrationDate : NSString = ""
    var str_CardCount : NSString = ""
    var str_CheckoutTocken : NSString = ""
    var str_Quickbox : NSString = ""
    var str_LoginType : NSString = ""
    var str_User_Role : NSString = ""

    var str_RewardPoint : NSString = ""
    var str_RewardBronze : NSString = ""
    var str_RewardGolf : NSString = ""
    var str_RewardSilver : NSString = ""
    var str_RewardDiamond : NSString = ""
    var str_Currency : NSString = ""

    init(str_FirstName: NSString,str_LastName : NSString,str_Userid : NSString,str_Profile_Image : NSString,str_Email : NSString,str_Zipcode : NSString,str_Lat : NSString,str_Long : NSString,str_Address : NSString,str_RegistrationDate : NSString,str_CardCount : NSString, str_CheckoutTocken : NSString, str_RewardPoint : NSString,str_Quickbox : NSString,str_RewardBronze : NSString,str_RewardGolf : NSString,str_RewardSilver : NSString,str_RewardDiamond : NSString,str_Currency : NSString,str_LoginType : NSString, str_User_Role : NSString) {
        self.str_FirstName = str_FirstName as NSString
        self.str_LastName = str_LastName as NSString
        self.str_Userid = str_Userid as NSString
        self.str_Profile_Image = str_Profile_Image as NSString
        self.str_Email = str_Email as NSString
        self.str_Zipcode = str_Zipcode as NSString
        self.str_Lat = str_Lat as NSString
        self.str_Long = str_Long as NSString
        self.str_Address = str_Address as NSString
        self.str_RegistrationDate = str_RegistrationDate as NSString
        self.str_CardCount = str_CardCount as NSString
        self.str_CheckoutTocken = str_CheckoutTocken as NSString
        self.str_RewardPoint = str_RewardPoint as NSString
        self.str_Quickbox = str_Quickbox as NSString
        self.str_RewardBronze = str_RewardBronze as NSString
        self.str_RewardGolf = str_RewardGolf as NSString
        self.str_RewardSilver = str_RewardSilver as NSString
        self.str_RewardDiamond = str_RewardDiamond as NSString
        self.str_Currency = str_Currency as NSString
        self.str_LoginType = str_LoginType as NSString
        self.str_User_Role = str_User_Role as NSString

    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let str_FirstName = aDecoder.decodeObject(forKey: "str_FirstName") as! String
        let str_LastName = aDecoder.decodeObject(forKey: "str_LastName") as! String
        let str_Userid = aDecoder.decodeObject(forKey: "str_Userid") as! String
        let str_Profile_Image = aDecoder.decodeObject(forKey: "str_Profile_Image") as! String
        let str_Email = aDecoder.decodeObject(forKey: "str_Email") as! String
        let str_Zipcode = aDecoder.decodeObject(forKey: "str_Zipcode") as! String
        let str_Lat = aDecoder.decodeObject(forKey: "str_Lat") as! String
        let str_Long = aDecoder.decodeObject(forKey: "str_Long") as! String
        let str_Address = aDecoder.decodeObject(forKey: "str_Address") as! String
        let str_RegistrationDate = aDecoder.decodeObject(forKey: "str_RegistrationDate") as! String
        let str_CardCount = aDecoder.decodeObject(forKey: "str_CardCount") as! String
        let str_CheckoutTocken = aDecoder.decodeObject(forKey: "str_CheckoutTocken") as! String
        let str_RewardPoint = aDecoder.decodeObject(forKey: "str_RewardPoint") as! String
        let str_Quickbox = aDecoder.decodeObject(forKey: "str_Quickbox") as! String
        let str_RewardBronze = aDecoder.decodeObject(forKey: "str_RewardBronze") as! String
        let str_RewardGolf = aDecoder.decodeObject(forKey: "str_RewardGolf") as! String
        let str_RewardSilver = aDecoder.decodeObject(forKey: "str_RewardSilver") as! String
        let str_RewardDiamond = aDecoder.decodeObject(forKey: "str_RewardDiamond") as! String
        let str_Currency = aDecoder.decodeObject(forKey: "str_Currency") as! String
        let str_LoginType = aDecoder.decodeObject(forKey: "str_LoginType") as! String
        let str_User_Role = aDecoder.decodeObject(forKey: "str_User_Role") as! String

        self.init(str_FirstName: str_FirstName as NSString,
                   str_LastName: str_LastName as NSString,
                   str_Userid: str_Userid as NSString,
                   str_Profile_Image: str_Profile_Image as NSString,
                   str_Email: str_Email as NSString,
                   str_Zipcode: str_Zipcode as NSString,
                   str_Lat: str_Lat as NSString,
                   str_Long: str_Long as NSString,
                   str_Address: str_Address as NSString,
                   str_RegistrationDate: str_RegistrationDate as NSString,
                   str_CardCount: str_CardCount as NSString,
                   str_CheckoutTocken: str_CheckoutTocken as NSString,
                   str_RewardPoint: str_RewardPoint as NSString,
                   str_Quickbox: str_Quickbox as NSString,
                   str_RewardBronze: str_RewardBronze as NSString,
                   str_RewardGolf: str_RewardGolf as NSString,
                   str_RewardSilver: str_RewardSilver as NSString,
                   str_RewardDiamond: str_RewardDiamond as NSString,
                   str_Currency: str_Currency as NSString,
                   str_LoginType: str_LoginType as NSString,
                   str_User_Role: str_User_Role as NSString)
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(str_FirstName, forKey: "str_FirstName")
        aCoder.encode(str_LastName, forKey: "str_LastName")
        aCoder.encode(str_Userid, forKey: "str_Userid")
        aCoder.encode(str_Profile_Image, forKey: "str_Profile_Image")
        aCoder.encode(str_Email, forKey: "str_Email")
        aCoder.encode(str_Zipcode, forKey: "str_Zipcode")
        aCoder.encode(str_Lat, forKey: "str_Lat")
        aCoder.encode(str_Long, forKey: "str_Long")
        aCoder.encode(str_Address, forKey: "str_Address")
        aCoder.encode(str_RegistrationDate, forKey: "str_RegistrationDate")
        aCoder.encode(str_CardCount, forKey: "str_CardCount")
        aCoder.encode(str_CheckoutTocken, forKey: "str_CheckoutTocken")
        aCoder.encode(str_RewardPoint, forKey: "str_RewardPoint")
        aCoder.encode(str_Quickbox, forKey: "str_Quickbox")
        aCoder.encode(str_RewardBronze, forKey: "str_RewardBronze")
        aCoder.encode(str_RewardGolf, forKey: "str_RewardGolf")
        aCoder.encode(str_RewardSilver, forKey: "str_RewardSilver")
        aCoder.encode(str_RewardDiamond, forKey: "str_RewardDiamond")
        aCoder.encode(str_Currency, forKey: "str_Currency")
        aCoder.encode(str_LoginType, forKey: "str_LoginType")
        aCoder.encode(str_User_Role, forKey: "str_User_Role")
    }
    
}






//
//  GotoSettingPageViewController.swift
//  Katika
//
//  Created by Katika_07 on 02/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class GotoSettingPageViewController: UIViewController {

    //photo,video,microPhone
    var str_TypeofValidation : NSString = "photo"
    
    @IBOutlet var lbl_Title : UILabel!
    @IBOutlet var lbl_SubTitle : UILabel!
    
    @IBOutlet var img_Icon : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if str_TypeofValidation == "photo" {
            
            lbl_Title.text = "Please Allow Photos Access"
            lbl_SubTitle.text = "We need your permission to access your photo library. This will enable you to upload photos you're previously taken to Katika."
            img_Icon.image = UIImage(named:"icon_Katika")
            
        }else if str_TypeofValidation == "video" {
            
            lbl_Title.text = "Please Allow Video Access"
            lbl_SubTitle.text = "We need your permission to access your video recording. This will enable you to upload video you're previously record to Katika."
            img_Icon.image = UIImage(named:"icon_Katika")
            
        }else if str_TypeofValidation == "microPhone" {
            
            lbl_Title.text = "Please Allow Microphone Access"
            lbl_SubTitle.text = "We need your permission to access your MicroPhone access."
            img_Icon.image = UIImage(named:"icon_Katika")
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
        dismiss(animated: true) { _ in }
    }
    @IBAction func btn_GoingToSetting(_ sender: Any) {
        if UIApplication.openSettingsURLString != nil {
            var appSettings = URL(string: UIApplication.openSettingsURLString)
            UIApplication.shared.openURL(appSettings!)
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

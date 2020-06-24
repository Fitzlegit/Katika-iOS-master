//
//  ProfileViewController.swift
//  Katika
//
//  Created by Katika on 19/05/17.
//  Copyright © 2017 Katika123. All rights reserved.

import UIKit
import SwiftMessages

class ProfileTableviewCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var img_MoveArrow: UIImageView!
}


class ProfileViewController: UIViewController , DismissViewDelegate , UINavigationControllerDelegate {

    //Other Declaration
    let picker = UIImagePickerController()
    var isImage :Bool = false
    
    //Declaration table view
    @IBOutlet weak var tableView: UITableView!
    
    //Declaration Images
    @IBOutlet weak var img_Profile: UIImageView!
    
    //Constant ste
    @IBOutlet var con_vw_Top : NSLayoutConstraint!
    
    //View Manage
    @IBOutlet var vw_Profile : UIView!
    
    //Label Declaration
    @IBOutlet var lbl_Name : UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.commanMethod()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Other Files -
    func commanMethod(){
        //Layer Set
        img_Profile.layer.cornerRadius = CGFloat(Int((Constant.windowHeight * 90)/Constant.screenHeightDeveloper))/2
        img_Profile.layer.masksToBounds = true
        
        //Conastant set
        con_vw_Top.constant = CGFloat(Int((Constant.windowHeight * 15)/Constant.screenHeightDeveloper))
        
        //TableView Footer
        tableView.tableFooterView = UIView()
        
        //Set user name
        lbl_Name.text = "\(objUser?.str_FirstName as! String) \(objUser?.str_LastName as! String)"
        
        //If image set than only Load service image
        if isImage == false {
            //Set image
            img_Profile.sd_setImage(with: URL(string: objUser?.str_Profile_Image as! String), placeholderImage: UIImage(named: Constant.placeHolder_User))
        }
        
        //Picker Delegates
        picker.delegate = self
        
        tableView.reloadData()
    }
    func photoOption(info: NSInteger) {
        if info == 1 {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                
                picker.sourceType = .camera
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }
        } else {
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func btn_ProfileChange(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "SelectAvtarPopupViewController") as! SelectAvtarPopupViewController
        view.delegate = self
        
        view.modalPresentationStyle = .custom
        view.modalTransitionStyle = .crossDissolve
        present(view, animated: true) { _ in }
    }
    @IBAction func btn_EditUserName(_ sender: Any) {
        let alert = UIAlertController(title: "Edit Username", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        let action = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let textField2 = alert.textFields![1] as UITextField
            
            if textField.text != "" && textField2.text != ""{
                self.Post_EditUserName(str_FirstName : textField.text!,str_LastName : textField2.text!)
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "First name"
            textField.text = objUser?.str_FirstName as! String
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Last name"
            textField.text = objUser?.str_LastName as! String
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Get/Post Method -
    func Post_ChangeProfilePic(){
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)upload_profile_pic"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "upload_profile_pic"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
        webHelper.imageUpload = img_Profile.image
        webHelper.imageUploadName = "image"
        webHelper.startDownloadWithImage()
    }
    func Post_EditUserName(str_FirstName : String,str_LastName : String){
        
        //Save Data
        objUser?.str_FirstName = str_FirstName as NSString
        objUser?.str_LastName = str_LastName as NSString
        saveCustomObject(objUser!, key: "userobject");
        lbl_Name.text = "\(objUser?.str_FirstName as! String) \(objUser?.str_LastName as! String)"

        //Declaration URL
        let strURL = "\(Constant.BaseURL)edit_user_name"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "firstname" : str_FirstName,
            "lastname" : str_LastName,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "edit_user_name"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
        webHelper.startDownload()
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

extension ProfileViewController : UIImagePickerControllerDelegate {
    //MARK: - Imagepicker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        let chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage
        self.img_Profile.image = chosenImage
        isImage = true
        dismiss(animated:true, completion: nil)
        
        //Call save image in server 
        self.Post_ChangeProfilePic()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Tableview Files -
extension ProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(Int((Constant.windowHeight * 60)/Constant.screenHeightDeveloper))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "editnameemailpassword", sender: self)
            break
        case 1:
            self.performSegue(withIdentifier: "shippingaddress", sender: self)
            break
        case 2:
            self.performSegue(withIdentifier: "changelocation", sender: self)
            break
            
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension ProfileViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath as IndexPath) as! ProfileTableviewCell
        
        //Always open arrow as a defualt
        cell.img_MoveArrow.isHidden = false
        
        //Declare text in icon in tableview cell
        if(indexPath.row == 0){
            cell.lblTitle.text = "Name, Email, Password"
            cell.imgLogo.image = UIImage(named: "icon_NameEmailPassword")
        }else if(indexPath.row == 1){
            cell.lblTitle.text = "Shipping Address"
            cell.imgLogo.image = UIImage(named: "icon_Shipping")
        }else if(indexPath.row == 2){
            cell.lblTitle.text = "Current Location: \(objUser?.str_Address as! String)"
            cell.imgLogo.image = UIImage(named: "icon_Location")
        } else if(indexPath.row == 3){
            cell.lblTitle.text = "Joined: \(localDateToStrignDate(date : objUser?.str_RegistrationDate as! String))"
            cell.imgLogo.image = UIImage(named: "icon_Joined")
            
            //Joined field no required move arrow
            cell.img_MoveArrow.isHidden = true
        }
        return cell
    }
    
}



extension ProfileViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "upload_profile_pic" {
            
            //not button not selected image
            isImage = true
            
            //Set image in user object
            objUser?.str_Profile_Image = response["ProfileImage"] as! String as NSString
            saveCustomObject(objUser!, key: "userobject");
        }else if strRequest == "edit_user_name"{
           
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        // self.completedServiceCalling()
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

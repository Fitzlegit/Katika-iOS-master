//
//  PermissionAlertViewController.swift
//  Katika
//
//  Created by Katika_07 on 02/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import Photos
import DKImagePickerController
import MobileCoreServices
import AVFoundation

// MARK: - Protocol -
@objc protocol PermissionAlertViewControllerDelegate{
    func appSuccessResponse(_ data: Any, request strRequest: String)
    func appFailResponse()
}

class PermissionAlertViewController: UIViewController {
   
    var delegateWeb:PermissionAlertViewControllerDelegate?
    
    var objGet = ProductObject ()
    var objAssest: [DKAsset]?
    
    var url_Store: NSURL = NSURL(string: "")!
    
    var str_Type : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Other Files -
    func openGallery(){
        let pickerController = DKImagePickerController()
        pickerController.sourceType = .photo
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            self.objAssest = assets
            
            if assets.count != 0 {
//                self.delegateWeb?.appSuccessResponse(assets,request: "gallery")
                self.performSegue(withIdentifier: "productcomment", sender: "gallery")
            }else{
//                self.delegateWeb?.appFailResponse()
            }
        }
        
        self.present(pickerController, animated: false) {}
    }
    func takePicture(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    func takeVideo(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            picker.mediaTypes = [(kUTTypeMovie as? String)!]
            self.present(picker, animated: true, completion: nil)
        }
    }
    func permissionForGallery(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "GotoSettingPageViewController") as! GotoSettingPageViewController
        view.str_TypeofValidation = "photo"
        self.present(view, animated: true, completion: nil)
    }
    func permissionForVideo(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "GotoSettingPageViewController") as! GotoSettingPageViewController
        view.str_TypeofValidation = "video"
        self.present(view, animated: true, completion: nil)
    }
    func permissionForMicroPhone(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "GotoSettingPageViewController") as! GotoSettingPageViewController
        view.str_TypeofValidation = "microPhone"
        self.present(view, animated: true, completion: nil)
    }
    
    
    //MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_TakePhoto(_ sender: Any) {
        //Get authanitication for photo gallery
        if AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            self.takePicture()
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)), completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    // User granted
                    self.takePicture()
                    
                } else {
                    self.permissionForVideo()
                }
            })
        }
    }
    @IBAction func btn_TakeVideo(_ sender: Any) {
        //Get authanitication for video
        if AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) ==  AVAuthorizationStatus.authorized {

            //Microphone Accepted or not
            if AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.audio))) ==  AVAuthorizationStatus.authorized {
                self.takeVideo()
            } else {
                AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.audio)), completionHandler: { (granted: Bool) -> Void in
                    if granted == true {
                        // User granted
                        self.takeVideo()
                    } else {
                        self.permissionForMicroPhone()
                    }
                })
            }
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)), completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    
                    //Microphone Accepted or not
                    if AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.audio))) ==  AVAuthorizationStatus.authorized {
                        self.takeVideo()
                    } else {
                        AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.audio)), completionHandler: { (granted: Bool) -> Void in
                            if granted == true {
                                // User granted
                                self.takeVideo()
                            } else {
                                self.permissionForMicroPhone()
                            }
                        })
                    }
                }else{
                    self.permissionForVideo()
                }
            })
        }
    }
    @IBAction func btn_SelectFromLibraty(_ sender: Any) {
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
     
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            self.openGallery()
            
        }else if (status == PHAuthorizationStatus.denied) {
            
            self.permissionForGallery()
       }else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.openGallery()
                }
            })
        }
        else if (status == PHAuthorizationStatus.restricted) {
            self.openGallery()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "productcomment"{
            
            if sender as! String == "gallery" {
                let view : ProductCommentViewController = segue.destination as! ProductCommentViewController
                
                //Set comment array in object array
                let arr_GetComment : NSMutableArray = []
                for _ in (0..<Int((self.objAssest?.count)!)) {
                    arr_GetComment.add("")
                }
                objGet.arr_ReviewComment = arr_GetComment
                
                let arr_ImageData : NSMutableArray = []
                for _ in (0..<Int((self.objAssest?.count)!)) {
                    arr_ImageData.add("")
                }
                objGet.arr_MutlipleimagesAndVideo = arr_ImageData

                //Set array for image type
                let arr_ImageType : NSMutableArray = []
                for _ in (0..<Int((self.objAssest?.count)!)) {
                    arr_ImageType.add("")
                }
                objGet.arr_MutlipleimagesAndVideoType = arr_ImageType
                
                
                view.objGet = objGet
                view.objAssest = self.objAssest
                view.str_Type = str_Type
                
            }else if sender as! String == "video" {
                let view : ProductCommentViewController = segue.destination as! ProductCommentViewController
                
                objGet.str_ReviewUploadType = "video"
                objGet.str_ReviewUploadURL = url_Store
                
                view.objGet = objGet
                view.objAssest = self.objAssest
                view.str_Type = str_Type
                
            }else if sender as! String == "photo" {
                let view : ProductCommentViewController = segue.destination as! ProductCommentViewController
                
                objGet.str_ReviewUploadType = "photo"
                objGet.str_ReviewUploadURL = url_Store
                
                view.objGet = objGet
                view.objAssest = self.objAssest
                view.str_Type = str_Type
                
            }
        }
    }
}


extension PermissionAlertViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    //MARK: - Imagepicker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)


        let mediaType:AnyObject? = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as AnyObject
        
        if let type:AnyObject = mediaType {
            if type is String {
                let stringType = type as! String
                if stringType == kUTTypeMovie as String {
                    let urlOfVideo = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? NSURL
                    if let url = urlOfVideo {
                        
                        do {
                            let videoData = try Data(contentsOf: urlOfVideo! as URL)
                            
                            //Set array for image data store
                            let arr_ImageData : NSMutableArray = []
                            arr_ImageData.add(videoData)
                            objGet.arr_MutlipleimagesAndVideo = arr_ImageData
                            
                            //Set array for comment
                            let arr_GetComment : NSMutableArray = []
                            arr_GetComment.add("")
                            objGet.arr_ReviewComment = arr_GetComment
                            
                            //Set array for image type
                            let arr_ImageType : NSMutableArray = []
                            arr_ImageType.add("video")
                            objGet.arr_MutlipleimagesAndVideoType = arr_ImageType
                            objGet.url_VideoURL = urlOfVideo as! URL
                            
                            self.performSegue(withIdentifier: "productcomment", sender: "video")

                        } catch let error {
                            print("error occured \(error)")
                        }
                        
                    }
                }else{
                    var image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage ?? UIImage()
                    let imgData = image.jpegData(compressionQuality: 0.75)
                    
                    let arr_ImageData : NSMutableArray = []
                    arr_ImageData.add(imgData)
                    objGet.arr_MutlipleimagesAndVideo = arr_ImageData
                    
                    //Set array for comment
                    let arr_GetComment : NSMutableArray = []
                    arr_GetComment.add("")
                    objGet.arr_ReviewComment = arr_GetComment
                    
                    //Set array for image type
                    let arr_ImageType : NSMutableArray = []
                    arr_ImageType.add("photo")
                    objGet.arr_MutlipleimagesAndVideoType = arr_ImageType
                    
                    self.performSegue(withIdentifier: "productcomment", sender: "photo")
                }
            }
        }
        // 3
        dismiss(animated:true, completion: nil) //5
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

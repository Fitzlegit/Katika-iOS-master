//
//  ProductCommentViewController.swift
//  Katika
//
//  Created by Katika_07 on 04/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import SwiftMessages
import FTImageViewer
import Photos
import AVKit
import DKImagePickerController
import CoreGraphics
 import AVFoundation

class ProductCommentViewController: UIViewController {

    @IBOutlet var tv_Description: UITextView!
    
    @IBOutlet var img_Preview: UIImageView!
    
    //Button Delclaration
    @IBOutlet var btn_Post: UIBarButtonItem!
    
    var objGet = ProductObject ()
    var bool_Edit :Bool = false
    
    var objGetCount : Int = 0
    var objAssest: [DKAsset]?
    
    //Constant set
    @IBOutlet var con_DetailText : NSLayoutConstraint!
    
    
    //Declaration Variable
    var keyboardToolbar = UIToolbar()
    
    var str_Type : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Textview Proprety -
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black
        if textView.text == "You're almost done, add a caption with your photo!" {
            textView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "You're almost done, add a caption with your photo!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    //MARK: -- InputAccessoryViews and keyboard handle methods --
    func setupInputAccessoryViews() {
        let flexSpace  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(flexSpace)
        items.append(done)
        keyboardToolbar.items = items
        keyboardToolbar.sizeToFit()
    }
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    //Custome class keyboard handler method
    @objc func myKeyboardWillHideHandler(_ notification: NSNotification) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
            //            Set constant with screen size
            self.con_DetailText.constant = 20
            self.view .layoutIfNeeded()
        }, completion: nil)
    }
    @objc func myKeyboardWillShow(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent], animations: {
            //            Set constant with screen size
            self.con_DetailText.constant = keyboardHeight
            self.view .layoutIfNeeded()
        }, completion: nil)
    }
    
    
    //MARK: - Other Files -
    func commanMethod(){
        
        //Notificaiton event with keyboard show and hide
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(myKeyboardWillHideHandler),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(myKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        //Set app done button in keyboard
        self.setupInputAccessoryViews()
        
        //Set Keyboardtoollbar in keyboard
        keyboardToolbar = UIToolbar()
        keyboardToolbar.frame = CGRect(x: 0, y: 0, width: Constant.windowWidth, height: 44)
        setupInputAccessoryViews()
        tv_Description.inputAccessoryView  = keyboardToolbar
    
        //Set Button title for next or post
        if objAssest != nil {
            if objAssest?.count ==  objGetCount + 1{
                btn_Post.title = "POST"
            }else{
                btn_Post.title = "NEXT"
            }
            
            //Set image and store data value in object
            let asset = self.objAssest![objGetCount]
            if asset.isVideo {
                self.objGet.arr_MutlipleimagesAndVideoType[self.objGetCount] = "video"
                
                asset.fetchAVAssetWithCompleteBlock { (avAsset, info) in
                    self.storeDataVideo(avAsset!)
                }
                
            } else {
                self.objGet.arr_MutlipleimagesAndVideoType[self.objGetCount] = "photo"
                
                asset.fetchImageWithSize(img_Preview.frame.size, completeBlock: { image, info in
                    self.img_Preview.image = image
                    
                    let imgData = image!.jpegData(compressionQuality: 0.75)
                    print(imgData)
                    self.objGet.arr_MutlipleimagesAndVideo[self.objGetCount] = imgData
                })
            }
        }else if objGet.str_ReviewUploadType as String == "photo"{
            btn_Post.title = "POST"
            
            self.img_Preview.image = UIImage(data:(objGet.arr_MutlipleimagesAndVideo[0] as? Data)!,scale:1.0)
        }else if objGet.str_ReviewUploadType as String == "video"{
             btn_Post.title = "POST"
            
            self.img_Preview.image = self.getThumbnailImage(forUrl : (objGet.url_VideoURL as NSURL) as URL)
        }
        
        //Gallery
        if objAssest != nil {
           
        }
    }
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    func playVideo(_ asset: AVAsset) {
        let avPlayerItem = AVPlayerItem(asset: asset)
        
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        let player = AVPlayerViewController()
        player.player = avPlayer
        
        avPlayer.play()
        
        self.present(player, animated: true, completion: nil)
    }
    func storeDataVideo(_ asset: AVAsset) {
        let avPlayerItem = AVPlayerItem(asset: asset)
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        let videoURL = self.urlOfCurrentlyPlayingInPlayer(player: avPlayer)!
        
        do {
            let videoData = try Data(contentsOf: videoURL as URL)
            self.objGet.arr_MutlipleimagesAndVideo[self.objGetCount] = videoData
        } catch let error {
            print("error occured \(error)")
        }

    }
    func urlOfCurrentlyPlayingInPlayer(player : AVPlayer) -> URL? {
        return ((player.currentItem?.asset) as? AVURLAsset)?.url
    }
    
    
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    
    //MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_Post(_ sender: Any) {
        self.view.endEditing(true)
        
        //Gallery
        if objAssest != nil {
            //Store comment in object array
            objGet.arr_ReviewComment[objGetCount] = tv_Description.text
            
            if objAssest?.count !=  objGetCount + 1{
                
                //Move to same view with next image
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "ProductCommentViewController") as! ProductCommentViewController
                view.objGet = objGet
                view.objAssest = objAssest
                view.objGetCount = objGetCount + 1
                view.str_Type = str_Type
                self.navigationController?.pushViewController(view, animated: false)
                
            }else{
                self.Post_Review()
            }
        }else if objGet.str_ReviewUploadType as String == "photo"{
            objGet.arr_ReviewComment[objGetCount] = tv_Description.text
            self.Post_Review()
        }else if objGet.str_ReviewUploadType as String == "video"{
            objGet.arr_ReviewComment[objGetCount] = tv_Description.text
            self.Post_Review()
        }
       
    }
    @IBAction func btn_Preview(_ sender: Any){

        var bool_Show : Bool = true
        if objAssest != nil {
            //Set image and store data value in object
            let asset = self.objAssest![objGetCount]
            if asset.isVideo {
                bool_Show = false

                let asset = self.objAssest![objGetCount]
                asset.fetchAVAssetWithCompleteBlock { (avAsset, info) in
                    DispatchQueue.main.async(execute: { () in
                        self.playVideo(avAsset!)
                    })
                }
            }
        }else if objGet.str_ReviewUploadType as String == "video"{
            bool_Show = false
            
            let avAssetGet = AVAsset(url: objGet.url_VideoURL) //>selected video
            DispatchQueue.main.async(execute: { () in
                self.playVideo(avAssetGet)
            })
        }
        
        
        if bool_Show == true {
            //Create arr for Slide image post to FTImageviewer
            var imageArray : [FTImageResource] = []
            let img_Set = FTImageResource(image: img_Preview.image, imageURLString: "")
            imageArray.append(img_Set)
            
            //Create arr for frame with all images position
            var views = [UIView]()
            views.append(img_Preview)
            
            //Call method present imageviewer
            FTImageViewer.showImages(imageArray, atIndex: 0, fromSenderArray: views)
        }
    }
    
    
    // MARK: - Get/Post Method -
    func Post_Review(){
        
        //Declaration URL
        var strURL = "\(Constant.BaseURL)add_shop_review_reference"
        if str_Type != ""{
            strURL = "\(Constant.BaseURL)add_business_review_reference"
        }
        
        //make array for image comment
        let arr_Comment : NSMutableArray = []
        for i in (0..<Int(objGet.arr_ReviewComment.count)){
            let str_Comment : String = objGet.arr_ReviewComment[i] as! String
            let dict_Store : NSDictionary = [
                "comment" : str_Comment,
                ]
            arr_Comment.add(dict_Store)
        }
        let string = notPrettyString(from : arr_Comment)
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : objUser?.str_Userid as! String,
            "review_id" : objGet.str_ReviewID as String,
            "shop_id" : objGet.str_ProductId as String,
            "comment" : string,
        ]
        if str_Type != ""{
            jsonData = [
                "user_id" : objUser?.str_Userid as! String,
                "review_id" : objGet.str_ReviewID as String,
                "shop_id" : objGet.str_Business_id as String,
                "comment" : string,
            ]
        }
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "add_shop_review_reference"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = true
        webHelper.arr_MutlipleimagesAndVideo = objGet.arr_MutlipleimagesAndVideo
        webHelper.arr_MutlipleimagesAndVideoType = objGet.arr_MutlipleimagesAndVideoType
        webHelper.imageUploadName = "uploadfiles"
        webHelper.startUploadingMultipleImagesAndVideo()
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}


extension ProductCommentViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "add_shop_review_reference" {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is ProductDetailViewController || aViewController is BusinessDetailViewController{
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
//            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
    
}



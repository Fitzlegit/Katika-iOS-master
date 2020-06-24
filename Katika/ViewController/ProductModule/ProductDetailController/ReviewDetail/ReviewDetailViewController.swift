//
//  ReviewDetailViewController.swift
//  Katika
//
//  Created by Katika_07 on 12/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import Cosmos
import FTImageViewer
import AVFoundation
import AVKit

class ReviewDetailViewController: UIViewController {

    //Declaration Label
    @IBOutlet var lbl_UserName : UILabel!
    @IBOutlet var lbl_UploadedPhotoCount : UILabel!
    @IBOutlet var lbl_PostedReviewDate : UILabel!
    
    //Declaration Image
    @IBOutlet var img_UserProfile : UIImageView!
    
    //Other Declaration
    @IBOutlet var vw_RateByUser: CosmosView!
    
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    //Declaration Button
    @IBOutlet var btn_UserFul : UIButton!
    @IBOutlet var btn_UserFunny : UIButton!
    @IBOutlet var btn_UserCool : UIButton!
    
    var getObject = ReviewObjet()
    
    var str_Type : String = ""
    
    var arr_Main : NSMutableArray = []
    
    //Declaration CollectionView
    @IBOutlet var cv_Main : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()

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
    func commanMethod(){
        lbl_UserName.text = getObject.str_ReviewUserName as String
        lbl_UploadedPhotoCount.text = String(getObject.arr_UserUpload_Image.count)
        lbl_PostedReviewDate.text = localDateToStrignDate2(date : getObject.str_ReviewDate as String)
        
        //Mange Relating
        vw_RateByUser.rating = Double(getObject.str_ReviewStar as String)!
        
        //Image set
        img_UserProfile.sd_setImage(with: URL(string: getObject.str_ReviewUserImage as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        
        arr_Main = getObject.arr_UserUpload_Image
        print(arr_Main)
    
        var int_Count : Int = arr_Main.count
        print(arr_Main.count)
        if arr_Main.count % 2 != 0{
            int_Count = int_Count + 1
        }
        int_Count = int_Count/2
        
        var value : CGFloat = (CGFloat(Constant.windowWidth)*CGFloat(int_Count))
        value = value/2
        
        //Manage Table View Footer view height
        let vw : UIView = tbl_Main.tableFooterView!
        vw.frame = CGRect(x: 0, y: 0, width: CGFloat(Constant.windowWidth), height:  value+50)
        tbl_Main.tableFooterView = vw;
        print(CGFloat(Constant.windowWidth)*CGFloat(int_Count))
        
        //Review Posted Or note
        if getObject.str_ReviewUseful == "1"{
            btn_UserFul.isSelected = true
            
        }else{
            btn_UserFul.isSelected = false
        }
        btn_UserFul.setTitle("Useful \(getObject.str_ReviewUsefulCount)", for: .normal)
        
        if getObject.str_ReviewFunny == "1"{
            btn_UserFunny.isSelected = true
        }else{
            btn_UserFunny.isSelected = false
        }
        btn_UserFunny.setTitle("Funny \(getObject.str_ReviewFunnyCount)", for: .normal)
        
        if getObject.str_ReviewCool == "1"{
            btn_UserCool.isSelected = true
        }else{
            btn_UserCool.isSelected = false
        }
        btn_UserCool.setTitle("Cool \(getObject.str_ReviewCoolCount)", for: .normal)
        

   
    }
   
    
    func playVideo(_ url: URL) {
        //        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        
        let avPlayer = AVPlayer(url: (url as? URL)!)
        let player = AVPlayerViewController()
        player.player = avPlayer
        
        avPlayer.play()
        
        self.present(player, animated: true, completion: nil)
    }
    
    //MARK: - Button Event -
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_UserProfile(_ sender: Any) {
        
    }
    @IBAction func btn_UserFul(_ sender: Any) {
        Get_ReviewLikeStatuse(type : "useful")
        
        if btn_UserFul.isSelected == true{
            btn_UserFul.isSelected = false
            
            let str_Value = Int(getObject.str_ReviewUsefulCount as String)! - 1
            getObject.str_ReviewUsefulCount = String(str_Value) as NSString
        }else{
            btn_UserFul.isSelected = true
            
            let str_Value = Int(getObject.str_ReviewUsefulCount as String)! + 1
            getObject.str_ReviewUsefulCount = String(str_Value) as NSString
        }
        btn_UserFul.setTitle("Useful \(getObject.str_ReviewUsefulCount)", for: .normal)
        
       // self.Get_ReviewLikeStatuse(type:"useful")
        
    }
    @IBAction func btn_UserFunny(_ sender: Any) {
        if btn_UserFunny.isSelected == true{
            btn_UserFunny.isSelected = false
            
            let str_Value = Int(getObject.str_ReviewFunnyCount as String)! - 1
            getObject.str_ReviewFunnyCount = String(str_Value) as NSString
        }else{
            btn_UserFunny.isSelected = true
            
            let str_Value = Int(getObject.str_ReviewFunnyCount as String)! + 1
            getObject.str_ReviewFunnyCount = String(str_Value) as NSString
        }
        btn_UserFunny.setTitle("Funny \(getObject.str_ReviewFunnyCount)", for: .normal)
        
        self.Get_ReviewLikeStatuse(type:"funny")
    }
    @IBAction func btn_UserCool(_ sender: Any) {
        if btn_UserCool.isSelected == true{
            btn_UserCool.isSelected = false
            
            let str_Value = Int(getObject.str_ReviewCoolCount as String)! - 1
            getObject.str_ReviewCoolCount = String(str_Value) as NSString
        }else{
            btn_UserCool.isSelected = true
            
            let str_Value = Int(getObject.str_ReviewCoolCount as String)! + 1
            getObject.str_ReviewCoolCount = String(str_Value) as NSString
        }
        btn_UserCool.setTitle("Cool \(getObject.str_ReviewCoolCount)", for: .normal)
        
        self.Get_ReviewLikeStatuse(type:"cool")
    }
    
    
    // MARK: - Get/Post Method -
    func Get_ReviewLikeStatuse(type : NSString){
        
        //Declaration URL
        var strURL = "\(Constant.BaseURL)add_shop_review_reaction"
        if str_Type != ""{
            strURL = "\(Constant.BaseURL)add_business_review_reaction"
        }
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "user_id" : (objUser?.str_Userid as! String),
            "review_id" : getObject.str_Reviewrid as String,
            "action_type" : type,
        ]
        
        //print("URL :\n\(strURL)\n============\n\(jsonData)")
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "add_shop_review_reaction"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
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

//MARK: - Tableview View Cell -
class ReviewDetailTableviewCell : UITableViewCell{
    //Header view in cell
    @IBOutlet weak var lbl_Title: UILabel!
}


// MARK: - Tableview Files -
extension ReviewDetailViewController : UITableViewDelegate,UITableViewDataSource {
    // MARK: - Table View -
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Identifier cell with based on section
        let cellIdentifier : String = "cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! ReviewDetailTableviewCell
        
        cell.lbl_Title.text = getObject.str_ReviewDescription  as String
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



//MARK: - Collection View -
extension ReviewDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arr_Main.count;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var str_Identifier : String = "cell"
        let obj = arr_Main[indexPath.row] as? ReviewObjet
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: str_Identifier, for: indexPath) as! ReviewAndSelectedCollectioncell
       
        //Image set If video here than show video thumb
        if obj?.str_UserUpload_ReviewUserType == "I" {
            cell.img_Product.sd_setImage(with: URL(string: obj?.str_UserUpload_ReviewUserImage as! String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        }else{
            cell.img_Product.sd_setImage(with: URL(string: obj?.str_UserUpload_Thumb_Image as! String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReviewAndSelectedCollectioncell
     
    
        let obj = arr_Main[indexPath.row] as? ReviewObjet
        
        if obj?.str_UserUpload_ReviewUserType == "I" {
            //Create arr for Slide image post to FTImageviewer
            var imageArray : [String] = []
            imageArray.append(obj?.str_UserUpload_ReviewUserImage as! String)
            
            //Create arr for frame with all images position
            var views = [UIView]()
            views.append(cell.img_Product)
            
            //Call method present imageviewer
            FTImageViewer.showImages(imageArray, atIndex:0, fromSenderArray: views)
        }else{
            let str_Data : String = obj!.str_UserUpload_ReviewUserImage as String
            self.playVideo(URL(string: str_Data)!)
        }
    }
}


extension ReviewDetailViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "add_shop_review_reaction" {
            
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
    }
    
}








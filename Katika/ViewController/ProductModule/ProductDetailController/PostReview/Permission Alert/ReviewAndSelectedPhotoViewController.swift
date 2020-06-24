//
//  ReviewAndSelectedPhotoViewController.swift
//  Katika
//
//  Created by Katika_07 on 03/08/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
import FTImageViewer
import AVFoundation
import AVKit

class ReviewAndSelectedPhotoViewController: UIViewController {

    //Declaration CollectionView
    @IBOutlet var cv_Main : UICollectionView!
    
    @IBOutlet var lbl_ReviewTitle : UILabel!
    
    var objGet = ProductObject ()
    
    var str_Type : String = ""
    
    var arr_Main : NSMutableArray = []
    
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
        lbl_ReviewTitle.text = objGet.str_ReviewTitle as String
        
        //Editing review or not
        if objGet.str_ReviewUserTitle != ""{
            arr_Main = objGet.arr_ReviewUserComment
        }
        
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
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btn_Skip(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is ProductDetailViewController || aViewController is BusinessDetailViewController{
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    @IBAction func btn_SelectPhoto(_ sender : Any){

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "PermissionAlertViewController") as! PermissionAlertViewController
        view.delegateWeb = self
        view.objGet = objGet
        view.str_Type = str_Type
        self.navigationController?.pushViewController(view, animated: false)

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


extension ReviewAndSelectedPhotoViewController : PermissionAlertViewControllerDelegate{
    //MARK: - Webservice Helper -
    func appSuccessResponse(_ data: Any, request strRequest: String) {
        
      
    }
    
    func appFailResponse() {
        
    }
    
}


//MARK: - Collection View Cell -
class ReviewAndSelectedCollectioncell : UICollectionViewCell{
    //Cell for tabbar
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img_Seleted: UIImageView!
    
    //cell for header view
    @IBOutlet weak var lbl_Title_Header : UILabel!
    @IBOutlet weak var lbl_SubTitle_Header : UILabel!
    @IBOutlet weak var lbl_PrizeFinal_Header : UILabel!
    @IBOutlet weak var lbl_PrizeMainPrice_Header : UILabel!
    @IBOutlet weak var img_Image_Header : UIImageView!
    
    //cell for in cell product
    @IBOutlet weak var img_Product : UIImageView!
    
    //Other Tab
    @IBOutlet weak var lbl_Title_OtherTab : UILabel!
    @IBOutlet weak var lbl_SubTitle_OtherTab : UILabel!
    @IBOutlet weak var lbl_Prize_OtherTab : UILabel!
    @IBOutlet weak var img_Image_OtherTab : UIImageView!
    @IBOutlet weak var vw_Back_OtherTab : UIView!
    
}
//MARK: - Collection View -
extension ReviewAndSelectedPhotoViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return arr_Main.count;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var str_Identifier : String = "cell"
        let obj = arr_Main[indexPath.row] as? ProductObject
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: str_Identifier, for: indexPath) as! ReviewAndSelectedCollectioncell
       
        //Image set If video here than show video thumb
        if obj?.str_ReviewUserType == "I" {
            cell.img_Product.sd_setImage(with: URL(string: obj?.str_ReviewUserImage as! String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        }else{
            cell.img_Product.sd_setImage(with: URL(string: obj?.str_Thumb_Image as! String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReviewAndSelectedCollectioncell
        
        let obj = arr_Main[indexPath.row] as? ProductObject
        
        if obj?.str_ReviewUserType == "I" {
            //Create arr for Slide image post to FTImageviewer
            var imageArray : [String] = []
            imageArray.append(obj?.str_ReviewUserImage as! String)
            
            //Create arr for frame with all images position
            var views = [UIView]()
            views.append(cell.img_Product)

            //Call method present imageviewer
            FTImageViewer.showImages(imageArray, atIndex:0, fromSenderArray: views)
        }else{
            self.playVideo(URL(string: obj?.str_ReviewUserImage as! String)!)
        }
    }
}






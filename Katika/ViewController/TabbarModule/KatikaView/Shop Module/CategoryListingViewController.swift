//
//  CategoryListingViewController.swift
//  Katika
//
//  Created by Katika on 13/06/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

protocol DismissCategoryViewDelegate: class {
    func SelectionOption(info: String)
}

class CategoryListingViewController: UIViewController {

    //Array Declaration
    var arr_Popular : NSMutableArray = []
    var arr_AllCategory : NSMutableArray = []
    
    //Delegate
    weak var delegate : DismissCategoryViewDelegate? = nil
    
    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commanMethod()
        self.Get_SearchCategory()
        
        // Do any additional setup after loading the view.
         self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Other Files -
    func commanMethod(){
     
    }
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Get/Post Method -
    func Get_SearchCategory(){
        tbl_Main.isHidden = true
        
        //Declaration URL
        let strURL = "\(Constant.BaseURL)get_shop_category"
        
        //Pass data in dictionary
        var jsonData : NSDictionary =  NSDictionary()
        jsonData = [
            "categoryid" : "0",
            "skip" : "0",
            "total" : "10000",
        ]
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "get_category"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = jsonData
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.serviceWithAlert = false
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


//MARK: - Search Object -

class CategoryViewObject: NSObject {
    
    //Catgory Cell
    var str_Category_ID : NSString!
    var str_Category_Title : NSString!
    var str_Category_Image : NSString!
}



// MARK: - Tableview Files -
extension CategoryListingViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 45
        }else if indexPath.section == 1 {
            return 45
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 45
        }else if section == 1{
            return 45
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arr_Popular.count
        }else  if section == 1 {
            return arr_AllCategory.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "section")as! CategoryListingTableviewCell
            
            cell.lbl_Title_Section.text = "Popular Categories"
            return cell;
        }else if section == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "section")as! CategoryListingTableviewCell
            
            cell.lbl_Title_Section.text = "All Categories"
            return cell;
        }else {
            return nil;
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell_Identifier = "center"
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell_Identifier = "top"
            }else if indexPath.row == arr_Popular.count - 1 {
                cell_Identifier = "bottom"
            }else{
                cell_Identifier = "center"
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell_Identifier = "alltop"
            }else if indexPath.row == arr_AllCategory.count - 1 {
                cell_Identifier = "allbottom"
            }else{
                cell_Identifier = "allcenter"
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_Identifier, for:indexPath as IndexPath) as! CategoryListingTableviewCell
        
        if indexPath.section == 0 {
            //Condition for More category title in last cell in section
            let obj : CategoryViewObject = arr_Popular[indexPath.row] as! CategoryViewObject
            
            cell.lbl_CategoryTitle.text = obj.str_Category_Title as String
            
            //Image set
            cell.img_CategoryImage.sd_setImage(with: URL(string: obj.str_Category_Image as String), placeholderImage: UIImage(named: Constant.placeHolder_Comman))
            
        }else if indexPath.section == 1 {
            let obj : CategoryViewObject = arr_AllCategory[indexPath.row] as! CategoryViewObject
            
            cell.lbl_CategoryTitle.text = obj.str_Category_Title as String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let obj : CategoryViewObject = arr_Popular[indexPath.row] as! CategoryViewObject
            
            self.delegate?.SelectionOption(info: obj.str_Category_Title as String)
        }else if indexPath.section == 1 {
            let obj : CategoryViewObject = arr_AllCategory[indexPath.row] as! CategoryViewObject
            
            self.delegate?.SelectionOption(info: obj.str_Category_Title as String)

        }
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Tableview View Cell -
class CategoryListingTableviewCell : UITableViewCell{
    //Main Listing product
    @IBOutlet weak var lbl_CategoryTitle: UILabel!
    @IBOutlet weak var img_CategoryImage: UIImageView!
    
    //Section cell
    @IBOutlet weak var lbl_Title_Section : UILabel!
}


extension CategoryListingViewController : WebServiceHelperDelegate{
    //MARK: - Webservice Helper -
    func appDataDidSuccess(_ data: Any, request strRequest: String) {
        
        let response = data as! NSDictionary
        if strRequest == "get_category" {
            
            //Manage Sub category Data
            let arr_result = response["Result"] as! NSArray
            
            arr_Popular = []
            arr_AllCategory = []
            
            for i in (0..<arr_result.count) {
                let dict_Data = arr_result[i] as! NSDictionary
                
                var obj2 = CategoryViewObject()
                obj2.str_Category_ID = ("\(dict_Data["shop_category_id"] as! Int)" as NSString)
                obj2.str_Category_Title = dict_Data["s_title"] as! String as NSString
                obj2.str_Category_Image = dict_Data["s_image"] as! String as NSString
                
                if arr_Popular.count <= 10 {
                    arr_Popular.add(obj2)
                }else{
                    arr_AllCategory.add(obj2)
                }
            }
            
            tbl_Main.isHidden = false
            tbl_Main.reloadData()
        }
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        
       // self.completedServiceCalling()
    }
    
}


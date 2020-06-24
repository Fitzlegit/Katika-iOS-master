//
//  SizeGuideViewController.swift
//  Katika
//
//  Created by Katika on 01/06/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit

class SizeGuideViewController: UIViewController {

    //Declaration Tableview
    @IBOutlet var tbl_Main : UITableView!
    
    @IBOutlet var btn_CM : UIButton!
    @IBOutlet var btn_IN : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.commanMethod()
        // Do any additional setup after loading the view.
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

    //MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_CM(_ sender : Any){
        btn_CM.isSelected = true
        btn_IN.isSelected = false
        
        btn_CM.backgroundColor = UIColor.black
        btn_IN.backgroundColor = UIColor.white
    }
    @IBAction func btn_IN(_ sender : Any){
        btn_CM.isSelected = false
        btn_IN.isSelected = true
        
        btn_CM.backgroundColor = UIColor.white
        btn_IN.backgroundColor = UIColor.black
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



// MARK: - Tableview Files -
extension SizeGuideViewController : UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return CGFloat((Constant.windowHeight * 53)/Constant.screenHeightDeveloper)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var str_CellIdentifier : NSString = "cell"
        if indexPath.row == 0 {
            str_CellIdentifier = "header"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: str_CellIdentifier as String, for:indexPath as IndexPath) as! SizeGuide
        
        switch indexPath.row {
        case 1:
            cell.lbl_Title.text = "XXXS"
            cell.lbl_SubTitle.text = "76-81"
            break
        case 2:
            cell.lbl_Title.text = "XXS"
            cell.lbl_SubTitle.text = "81-86"
            break
        case 3:
            cell.lbl_Title.text = "XS"
            cell.lbl_SubTitle.text = "86-91"
            break
        case 4:
            cell.lbl_Title.text = "S"
            cell.lbl_SubTitle.text = "91-96"
            break
        case 5:
            cell.lbl_Title.text = "M"
            cell.lbl_SubTitle.text = "96-102"
            break
        case 6:
            cell.lbl_Title.text = "L"
            cell.lbl_SubTitle.text = "102-107"
            break
        case 7:
            cell.lbl_Title.text = "XL"
            cell.lbl_SubTitle.text = "107-112"
            break
        
        default:
            break
        }
        
        if  indexPath.row != 0 {
            if indexPath.row % 2 == 0{
                cell.vw_Background.backgroundColor = UIColor.init(colorLiteralRed: 234/264, green: 234/264, blue: 234/264, alpha: 1.0)
            }else{
                cell.vw_Background.backgroundColor = UIColor.white
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: - Tableview View Cell -
class SizeGuide : UITableViewCell{
 
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var lbl_SubTitle : UILabel!
    
    @IBOutlet weak var vw_Background : UIView!
}


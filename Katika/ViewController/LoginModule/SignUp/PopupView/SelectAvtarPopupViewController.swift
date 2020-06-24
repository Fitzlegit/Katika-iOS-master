//
//  SelectAvtarPopupViewController.swift
//  Katika
//
//  Created by KatikaRaju on 5/26/17.
//  Copyright © 2017 Katika123. All rights reserved.
//

import UIKit
    //MARK: - Delegate Method Declaration -
protocol DismissViewDelegate: class {
    func photoOption(info: NSInteger)
}

class SelectAvtarPopupViewController: UIViewController {
    @IBOutlet var btnTakePhoto: UIButton!
    @IBOutlet var viewPopup: UIView!

    weak var delegate :DismissViewDelegate? = nil
    
    @IBOutlet var btnChoosePhoto: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        commanMethod()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Common method
    func commanMethod() {
       
        viewPopup.layer.cornerRadius = 5.0
        btnTakePhoto.layer.cornerRadius = 5.0
        btnTakePhoto.layer.borderWidth = 0.5
        btnTakePhoto.layer.borderColor = UIColor.init(colorLiteralRed: 213/255.0, green: 48/255.0, blue: 53/255.0, alpha: 1.0).cgColor
        
        btnChoosePhoto.layer.cornerRadius = 5.0
        btnChoosePhoto.layer.borderWidth = 0.5
         btnChoosePhoto.layer.borderColor = UIColor.init(colorLiteralRed: 213/255.0, green: 48/255.0, blue: 53/255.0, alpha: 1.0).cgColor
        btnChoosePhoto .setTitleColor(UIColor.red, for: .normal)
        btnTakePhoto .setTitleColor(UIColor.red, for: .normal)
        self.view.layoutIfNeeded()
    }
    //MARK: - Button Clicks -
    @IBAction func viewDismissClick(_ sender: Any) {
        self .dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhotoClick(_ sender: Any) {
        
        self .dismiss(animated: true) {
            self.delegate?.photoOption(info: 1)
        }
    }
    @IBAction func closeClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func choosePhotoClick(_ sender: Any) {
        
        self.dismiss(animated: true) { 
            self.delegate?.photoOption(info: 2)
        }
//        self .dismiss(animated: true, completion:)
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

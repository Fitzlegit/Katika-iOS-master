//
//  TutorialViewController.swift
//  Katika
//
//  Created by Apple on 05/07/18.
//  Copyright © 2018 Katika123. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    let str_Type : String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Event -
    @IBAction func btn_Back(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
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

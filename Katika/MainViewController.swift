//
//  MainViewController.swift
//  Katika
//
//  Created by Apple on 03/05/19.
//  Copyright © 2019 icoderz123. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.removeObserver("MoveHpmeScreen")
        NotificationCenter.default.addObserver(self, selector: #selector(self.Move), name: NSNotification.Name(rawValue: "MoveHpmeScreen"), object: nil)
    }
    
    
    func Move() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        self.navigationController?.pushViewController(view, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

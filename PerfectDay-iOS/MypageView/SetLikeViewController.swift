//
//  SetLikeViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/24.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class SetLikeViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
            // Do any additional setup after loading the view.
    }
    
    func setUI(){
            self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func gotoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

//
//  HomeViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/05.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

var locationString = ""

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUI(){
        // Navigation Bar
        
    }
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SettingViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBOutlet var tvMain: UITableView!
    
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnDropOut: UIButton!
    @IBOutlet var btnClause: UIButton! // 인터넷으로 연결
    @IBOutlet var btnVersion: UIButton!
    
    @IBOutlet var swTemp: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    

    func setUI(){
        tvMain.alwaysBounceVertical = false
        // self.navigationItem.setHidesBackButton(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
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

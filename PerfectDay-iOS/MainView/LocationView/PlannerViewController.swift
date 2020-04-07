//
//  PlannerViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/09.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class PlannerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func setNavigationBar(){
        self.navigationItem.title = "플래너"
        let backItem = UIBarButtonItem()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
        let allClear = UIBarButtonItem()
        allClear.title = "모두 초기화"
        let btnEdit = UIBarButtonItem()
        btnEdit.title = "완료"
        self.navigationItem.setRightBarButtonItems([btnEdit,allClear], animated: true)
    }
    @IBAction func goToCourseConfirm(_ sender: UIButton) {
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "courseView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
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

//
//  DibsNavigationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/14.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class DibsNavigationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // NavigationBar 아래 선 지우는 코드
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        // 같은 기능 코드 -> 선이 지워지는 원리가 뭐지??
        // 1.
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        // 2.
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.clipsToBounds = true
        
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

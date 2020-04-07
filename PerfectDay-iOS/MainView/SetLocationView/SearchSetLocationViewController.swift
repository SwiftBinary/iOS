//
//  SearchSetLocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/06.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SearchSetLocationViewController: UIViewController {

    @IBOutlet var lblGuide: UILabel!
    @IBOutlet var tfKeyword: UITextField!
    @IBOutlet var btnCurrentLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setUI()
        // Do any additional setup after loading the view.
    }
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        lblGuide.text = "찾고 싶은 위치 또는 장소를 입력하세요." // 두 줄로 표시?
        setField(tfKeyword, "ex) 건대입구 또는 홍대입구")
        setSNSButton(btnCurrentLocation, "FocusIcon")
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

//
//  MyPageViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class MyPageViewController: UIViewController {
    
    @IBOutlet var svServiceCenter: UIStackView!
    var arrayServiceBtn : Array<MaterialVerticalButton> = []
    
    
    let grayColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) //e6e6e6
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setServiceCenter()
    }
    
    func setServiceCenter(){
        let btnCompany = MaterialVerticalButton(icon: UIImage(named: "IntroBtn")!, title: "소개페이지", foregroundColor: .white,useOriginalImg: true, bgColor: .white,cornerRadius: 10.0)
        let btnInsta = MaterialVerticalButton(icon: UIImage(named: "InstaBtn")!, title: "회사 SNS", foregroundColor: .white,useOriginalImg: true, bgColor: .white,cornerRadius: 10.0)
        let btnNaver = MaterialVerticalButton(icon: UIImage(named: "NaverBtn")!, title: "회사블로그", foregroundColor: .white,useOriginalImg: true, bgColor: .white,cornerRadius: 10.0)
        let btnKakao = MaterialVerticalButton(icon: UIImage(named: "KakaoBtn")!, title: "1:1 문의", foregroundColor: .white,useOriginalImg: true, bgColor: .white,cornerRadius: 10.0)
        let btnSuggest = MaterialVerticalButton(icon: UIImage(named: "InstaBtn")!, title: "장소 제안", foregroundColor: .white,useOriginalImg: true, bgColor: .white,cornerRadius: 10.0)
        arrayServiceBtn = [btnCompany,btnInsta,btnNaver,btnKakao,btnSuggest]
        for btn in arrayServiceBtn {
            svServiceCenter.addArrangedSubview(btn)
            btn.label.textColor = .black
            btn.label.font = .systemFont(ofSize: 13)
            btn.rippleLayerColor = grayColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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

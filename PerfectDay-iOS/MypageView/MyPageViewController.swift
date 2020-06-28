//
//  MyPageViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import MaterialDesignWidgets

class MyPageViewController: UIViewController {
    
    @IBOutlet var lblUserNickName: UILabel!
    @IBOutlet var lblUserEmail: UILabel!
    
    
    @IBOutlet var svServiceCenter: UIStackView!
    var arrayServiceBtn : Array<MaterialVerticalButton> = []
    
    let grayColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) //e6e6e6
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileUI()
        setServiceCenter()
    }
    
    func setProfileUI() {
        let userDTO = UserDTO(jsonData: JSON(UserDefaults.standard.value(forKey: "userJSONData")!))
        lblUserNickName.text  = userDTO.userName
        lblUserEmail.text = userDTO.userEmail
        lblUserEmail.font = UIFont.systemFont(ofSize: 15)
    }
    
    func setServiceCenter(){
        let btnCompany = MaterialVerticalButton(icon: UIImage(named: "IntroBtn")!, text: "소개페이지", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnInsta = MaterialVerticalButton(icon: UIImage(named: "InstaBtn")!, text: "회사 SNS", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnNaver = MaterialVerticalButton(icon: UIImage(named: "NaverBtn")!, text: "회사블로그", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnKakao = MaterialVerticalButton(icon: UIImage(named: "KakaoBtn")!, text: "1:1 문의", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnSuggest = MaterialVerticalButton(icon: UIImage(named: "InstaBtn")!, text: "장소 제안", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        arrayServiceBtn = [btnCompany,btnInsta,btnNaver,btnKakao,btnSuggest]
        for btn in arrayServiceBtn {
            svServiceCenter.addArrangedSubview(btn)
            btn.label.textColor = .black
            btn.label.font = .systemFont(ofSize: 13)
            btn.rippleLayerColor = grayColor        }
    }
    @IBAction func logout(_ sender: UIButton) {
        let alertController = UIAlertController(title: "정말 로그아웃 하시겠습니까?", message: "", preferredStyle: UIAlertController.Style.alert)
        let acceptAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default , handler: { _ in
            UserDefaults.standard.removeObject(forKey: userDataKey)
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel , handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion:{})
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

//
//  SetUserInfoViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/24.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift
import SwiftyJSON

class SetUserInfoViewController: UIViewController {
    
    
    @IBOutlet var tfNewNickName: UITextField!
    @IBOutlet var tfCurrentPw: UITextField!
    @IBOutlet var tfNewPw: UITextField!
    @IBOutlet var tfNewPwCheck: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setUI()
        // Do any additional setup after loading the view.
    }
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        setField(tfNewNickName, "한글, 영문, 숫자 10자 이내")
        setField(tfCurrentPw, "현재 사용중인 비밀번호 입력")
        setField(tfNewPw, "영문,숫자,특수문자 8 - 10자")
        setField(tfNewPwCheck, "영문,숫자,특수문자 8 - 10자")
    }
    
    @IBAction func gotoBack(_ sender: UIButton) {
//        print(userJSON)
        let url = OperationIP + "/user/updateUserInfo.do"
        let parameter = JSON([
            "userSn": userDTO.userSn,
            "userType": userDTO.userType,
            "userRealName": userDTO.userRealName,
            "userName": userDTO.userName,
            "userEmail": userDTO.userEmail,
            "userPw": tfNewPw.text!,//.sha256(),
            "userGender": userDTO.userGender,
            "birthDt": userDTO.birthDt,
            "userAvgBudget": userDTO.userAvgBudget,
            "loginType": userDTO.loginType,
            "eatPref": userDTO.eatPref,
            "drinkPref": userDTO.drinkPref,
            "playPref": userDTO.playPref,
            "watchPref": userDTO.watchPref,
            "walkPref": userDTO.walkPref,
            "setting": userDTO.setting,
        ])
        print(parameter)
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString]).responseJSON { response in
            debugPrint(response)
//            if response.value != nil {
//                let responseJSON = JSON(response.value!)
//                // result값 - 1:성공, 2:실패
//            }
        }
    }
    //        self.navigationController?.popViewController(animated: true)
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

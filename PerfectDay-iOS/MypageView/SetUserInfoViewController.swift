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
    
    
    @IBOutlet var tfCurrentPw: UITextField!
    @IBOutlet var tfNewPw: UITextField!
    @IBOutlet var tfNewPwCheck: UITextField!
    
    let userData = getUserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func gotoBack(_ sender: UIButton) {
        let userJSON = JSON(userData)
//        print(userJSON)
        let url = OperationIP + "/user/updateUserInfo.do"
        let parameter = JSON([
            "userSn": userJSON["userSn"].stringValue,
            "userType": userJSON["userType"].stringValue,
            "userRealName": userJSON["userRealName"].stringValue,
            "userName": userJSON["userName"].stringValue+"3",
            "userEmail": userJSON["userEmail"].stringValue,
            "userPw": tfNewPw.text!.sha256(),
            "userGender": userJSON["userGender"].stringValue,
            "birthDt": userJSON["birthDt"].stringValue,
            "userAvgBudget": userJSON["userAvgBudget"].stringValue,
            "loginType": userJSON["loginType"].stringValue,
            "eatPref": userJSON["eatPref"].stringValue,
            "drinkPref": userJSON["drinkPref"].stringValue,
            "playPref": userJSON["playPref"].stringValue,
            "watchPref": userJSON["watchPref"].stringValue,
            "walkPref": userJSON["walkPref"].stringValue,
            "setting": userJSON["setting"].stringValue,
        ])
        print(parameter)
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString]).responseJSON { response in
            debugPrint(response)
//            if response.value != nil {
//                let reponseJSON = JSON(response.value!)
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

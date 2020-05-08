//
//  ShowInfoViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/05.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ShowInfoViewController: UIViewController {
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var tvInfo: UITextView!
    
    var userName: String = ""
    var userEmail: String = ""
    var userBirth: String = ""
    var userGender: String = ""
    var findEmail = true
    var resultString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        //tvInfo.text = resultString
    }
    
    func setUI(){
        self.navigationItem.setHidesBackButton(true, animated: false)
        btnBack.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
        btnBack.layer.cornerRadius = 5
//        print(userName)
//        print(userEmail)
//        print(userBirth)
//        print(userGender)
        findEmail ? findUserEmail(name: userName, birth: userBirth, gender: userGender) : findUserPw(name: userName, email: userEmail, birth: userBirth, gender: userGender)
    }
    
    func findUserEmail(name: String, birth: String, gender: String){
        let url = developIP + "/user/findUserEmail.do"
        let jsonHeader = JSON([
            "userSn":"_",
            "deviceOS":"IOS"
        ])
        let jsonParameter = JSON([
            "userRealName": name,
            "userGender": gender,
            "birthDt": birth,
        ])
        let convertedParameterString = jsonParameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        print("###Debug###")
        print(convertedParameterString)
        print(String(jsonParameter.rawString()!))
        let httpHeaders: HTTPHeaders = ["json":convertedHeaderString]
        //        , encoder: JSONParameterEncoder.default
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
//            debugPrint(response)
//            print("##")
            self.tvInfo.text = String(JSON(response.value!).rawString()!)
        }
    }
    
    func findUserPw(name: String, email: String, birth: String, gender: String){
        let url = OperationIP + "/user/resetUserPassword.do"
        let jsonHeader = JSON([
            "userSn":"_",
            "deviceOS":"IOS"
        ])
        let jsonParameter = JSON([
            "userEmail": email,
            "userRealName": name,
            "userGender": gender,
            "birthDt": birth,
        ])
        let convertedParameterString = jsonParameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        print(convertedParameterString)
        print(String(jsonParameter.rawString()!))
        let httpHeaders: HTTPHeaders = ["json":convertedHeaderString]
        //        , encoder: JSONParameterEncoder.default
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
//            debugPrint(response)
//            print("##")
            self.tvInfo.text = String(JSON(response.value!).rawString()!)
        }
    }
    
    @IBAction func btnBackFunc(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        
        let navigationVCList = self.navigationController!.viewControllers
        navigationController?.popToViewController(navigationVCList[navigationVCList.count-3], animated: true)
    }
}

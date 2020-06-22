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
    @IBOutlet var lblUserInfo: UILabel!
    
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
        let url = OperationIP + "/user/findUserEmail.do"
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
            let responseJSON = JSON(response.value!)
            debugPrint(response)
            if response.response?.statusCode == 200{
                if responseJSON["userEmail"].stringValue == "null"{
                    self.lblUserInfo.text = "해당 정보로 가입된 내역이 없습니다.\n다시 한 번 확인해 주세요."
                    self.lblUserInfo.numberOfLines = 2
                } else {
                    let crytoEmail = self.RegexEmail(responseJSON["userEmail"].stringValue)
                    let attributedcrytoEmail: NSMutableAttributedString = NSMutableAttributedString(string: "회원님의 아이디(ID)는\n" + crytoEmail + "입니다.")
                    attributedcrytoEmail.setColor(color: #colorLiteral(red: 0.9882352941, green: 0.368627451, blue: 0.5725490196, alpha: 1), forText: crytoEmail)
                    self.lblUserInfo.attributedText = attributedcrytoEmail
                }
            } else {
                self.lblUserInfo.text = "해당 정보로 가입된 내역이 없습니다.\n다시 한 번 확인해 주세요."
                self.lblUserInfo.numberOfLines = 2
            }
        }
    }
    
    func RegexEmail(_ userEmail: String) -> String{
        let emailID = String(userEmail.split(separator: "@")[0])
        let emailDomain = String(userEmail.split(separator: "@").last!)
        let cryptoEmail = String(emailID.substring(to: emailID.index(emailID.startIndex, offsetBy: emailID.count-3)))+"***"
        let str = cryptoEmail + "@" + emailDomain
        return str
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
            let responseJSON = JSON(response.value!)
            if response.response?.statusCode == 200{
                if responseJSON["result"].intValue == 0{
                    self.lblUserInfo.text = "해당 정보로 가입된 내역이 없습니다.\n다시 한 번 확인해 주세요."
                    self.lblUserInfo.numberOfLines = 2
                } else {
                    let attributedResetPw: NSMutableAttributedString = NSMutableAttributedString(string: "회원님의 비밀번호가 0000으로 변경되었습니다.\n비밀번호를 즉시 변경하시길 바랍니다")
                    attributedResetPw.setColor(color: #colorLiteral(red: 0.9882352941, green: 0.368627451, blue: 0.5725490196, alpha: 1), forText: "0000")
                    self.lblUserInfo.attributedText = attributedResetPw
                    self.lblUserInfo.numberOfLines = 2
                }
            } else {
                self.lblUserInfo.text = "해당 정보로 가입된 내역이 없습니다.\n다시 한 번 확인해 주세요."
                self.lblUserInfo.numberOfLines = 2
            }
        }
    }
    
    @IBAction func btnBackFunc(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        
        let navigationVCList = self.navigationController!.viewControllers
        navigationController?.popToViewController(navigationVCList[navigationVCList.count-3], animated: true)
    }
}

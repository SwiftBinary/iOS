//
//  LoginViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/04.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CryptoSwift

class LoginViewController: UIViewController {

    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnLoginNaver: UIButton!
    @IBOutlet var btnLoginFacebook: UIButton!
    @IBOutlet var btnLoginKakao: UIButton!
    
    @IBOutlet var btnFind: UIButton!
    @IBOutlet var btnJoin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setUI()
    }
    
    func setUI(){
        // Navigation Bar
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        // TextField
        setField(tfEmail, "이메일")
        setField(tfPassword, "비밀번호")
        // Login Button
        btnLogin.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
        btnLogin.layer.cornerRadius = 5
        // SNS Login
        setSNSButton(btnLoginKakao, "LoginKakao")
        setSNSButton(btnLoginFacebook, "LoginFacebook")
        setSNSButton(btnLoginNaver, "LoginNaver")
    }
    
//    @IBAction func gotoMain(_ sender: UIButton) {
//        // 로그인 시 적용
//        // self.presentingViewController?.dismiss(animated: true, completion: nil)
//
//        // 임시로 적용
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let goToVC = storyboard.instantiateViewController(withIdentifier: "mainView")
//        goToVC.modalPresentationStyle = .fullScreen
//        self.present(goToVC, animated: true, completion: nil)
//    }

    // 서버정보(IP, Domain) 모델화 필요 enum 사용해서 코드 수정할 것
    @IBAction func goToLogin(_ sender: UIButton) {
        let userId = tfEmail.text!
        let userPw = tfPassword.text! == "0000" ? "0000".sha256() : tfPassword.text!
        if checkId(userId: userId, userPw: userPw) {
            let developIP = "http://203.252.130.194:8080"
            let url = developIP + "/user/loginUser.do"
            let jsonHeader = JSON(["userSn":"_","deviceOS":"IOS"])
            let parameter = JSON([
                "userEmail":userId,
                "userPw":userPw,
                "loginType":"001",
            ])
            
            let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            let httpHeaders: HTTPHeaders = ["json":convertedHeaderString]
            
            AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
                debugPrint(response)
                if response.value != nil {
                    let reponseJSON = JSON(response.value!)
                    // result값 - 1:성공, 2:실패
                    let loginResult = Int(reponseJSON["result"].stringValue)
                    switch loginResult {
                    case 1:
                        self.loginSuccess()
                    case 2:
                        self.loginFail()
                    case -1:
                        self.networkFail()
                    default: break
                    }
                }
            }
        } else {
            alertControllerDefault(title: "아이디 및 비밀번호를\n입력해주세요.", message: "")
        }
    }
    func checkId(userId: String, userPw: String) -> Bool {
        if userId.isEmpty || userPw.isEmpty {
            return false
        }
        return true
    }
    func loginSuccess(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let goToVC = storyboard.instantiateViewController(withIdentifier: "mainView")
        goToVC.modalPresentationStyle = .fullScreen
        self.present(goToVC, animated: true, completion: nil)
        
        // 로그인 시 적용
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    func loginFail(){
        alertControllerDefault(title: "잘못된 입력", message: "가입되지 않은 아이디거나, 잘못된 비밀번호입니다. 다시 입력해주세요")
    }
    func networkFail(){
        alertControllerDefault(title: "로그인에 실패하였습니다.", message: "로그인 서버에 접속할 수 없습니다. 인터넷 연결을 확인해 주세요")
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func tempLogin(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let goToVC = storyboard.instantiateViewController(withIdentifier: "mainView")
        goToVC.modalPresentationStyle = .fullScreen
        self.present(goToVC, animated: true, completion: nil)
    }

}

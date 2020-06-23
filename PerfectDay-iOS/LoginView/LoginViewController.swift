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
import NaverThirdPartyLogin
//import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnLoginNaver: UIButton!
    @IBOutlet var btnLoginFacebook: UIButton!
    @IBOutlet var btnLoginKakao: UIButton!
    
    @IBOutlet var btnFind: UIButton!
    @IBOutlet var btnJoin: UIButton!
    
    @IBOutlet var svSNSLogin: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBOutlet var lblDataString: UITextView!
    let uds = UserDefaults.standard
    @IBAction func saveData(_ sender: UIButton) {
        //        UserDefaults.standard.set("Test String", forKey: "string")
        //        uds.setValue("T_e_s_t S_t_r_i_n_g", forKey: "string2")
        print(uds.dictionaryRepresentation())
    }
    @IBAction func printData(_ sender: Any) {
        //        let data1 = UserDefaults.standard.string(forKey: "string")
        let data2 = uds.dictionary(forKey: userDataKey)
        print("#")
        
        if data2 == nil {
            lblDataString.text = "nil"
        } else {
            //            print(data2!)
            lblDataString.text = JSON(arrayLiteral: data2!).rawString()
        }
        print("#")
        print(uds.dictionaryRepresentation())
    }
    @IBAction func removeData(_ sender: Any) {
        uds.removeObject(forKey: userDataKey)
        print("\n\n#\nRemove Data forKey: " + userDataKey)
        
        print(uds.dictionaryRepresentation())
    }
    
    func setUI(){
        hideKeyboard()
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
        
        btnLoginFacebook.addTarget(self, action: #selector(alertLogin(_:)), for: .touchUpInside)
        btnLoginKakao.addTarget(self, action: #selector(alertLogin(_:)), for: .touchUpInside)
    }
    @objc func alertLogin(_ sender: UIButton) {
        alertControllerDefault(title: "알림", message: "아직 이용할 수 없는 서비스 입니다.\n이용에 불편을 드려 죄송합니다.")
    }
    
    //###########################
    //        이메일 로그인
    //###########################
    // 서버정보(IP, Domain) 모델화 필요 enum 사용해서 코드 수정할 것
    @IBAction func goToLogin(_ sender: UIButton) {
        let userId = tfEmail.text!
        let userPw = tfPassword.text! == "0000" ? "0000".sha256() : tfPassword.text!.sha256()
        if checkId(userId: userId, userPw: userPw) {
            let url = OperationIP + "/user/loginUser.do"
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
                        self.loginSuccess(reponseJSON)
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
    func loginSuccess(_ uData:JSON){
        print(uData)
        uds.setValue(uData.dictionaryObject, forKey: userDataKey)
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
    @IBAction func tempLogin(_ sender: UIButton) {
        let userId = "hogafol284@windmails.net"
        let userPw = "0000".sha256()
        if checkId(userId: userId, userPw: userPw) {
            let url = OperationIP + "/user/loginUser.do"
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
                    print(reponseJSON)
                    let loginResult = Int(reponseJSON["result"].stringValue)
                    switch loginResult {
                    case 1:
                        self.loginSuccess(reponseJSON)
                    case 2:
                        self.loginFail()
                    case -1:
                        self.networkFail()
                    default: break
                    }
                }
                if response.response?.statusCode != 200 {
                    self.networkFail()
                }
            }
        } else {
            alertControllerDefault(title: "아이디 및 비밀번호를\n입력해주세요.", message: "")
        }
    }
    @IBAction func tempLogin3(_ sender: UIButton) {
        let userId = "testemail0@test.com"
        let userPw = "0000".sha256()
        if checkId(userId: userId, userPw: userPw) {
            let url = OperationIP + "/user/loginUser.do"
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
                    //                           self.uds.setValue(reponseJSON.dictionaryObject, forKey: userDataKey)
                    switch loginResult {
                    case 1:
                        self.loginSuccess(reponseJSON)
                    case 2:
                        self.loginFail()
                    case -1:
                        self.networkFail()
                    default: break
                    }
                }
                if response.response?.statusCode != 200 {
                    self.networkFail()
                }
            }
        } else {
            alertControllerDefault(title: "아이디 및 비밀번호를\n입력해주세요.", message: "")
        }
        
    }
    
    //###########################
    //        네이버 로그인
    //###########################
    let loginNaverInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    @IBAction func goToNaverLogin(_ sender: UIButton) {
        loginNaverInstance?.delegate = self
        loginNaverInstance?.requestThirdPartyLogin()
    }
    @IBAction func logoutTest(_ sender: UIButton) {
        loginNaverInstance?.requestDeleteToken()
    }
    private func getNaverInfo() {
        guard let isValidAccessToken = loginNaverInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            return
        }
        
        guard let tokenType = loginNaverInstance?.tokenType else { return }
        guard let accessToken = loginNaverInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let name = object["name"] as? String else { return }
            guard let nickname = object["nickname"] as? String else { return }
            guard let email = object["email"] as? String else { return }
            guard let id = object["id"] as? String else { return }
            guard let gender = object["gender"] as? String else { return }
            guard let age = object["age"] as? String else { return }
            guard let birthday = object["birthday"] as? String else { return }
            
            print("\(name), \(email), \(nickname), \(id), \(gender), \(age), \(birthday)")
        }
    }
    
    //###########################
    //        페이스북 로그인
    //###########################
    func goToFacebookLogin(){
        
//        let btnFacebook = FBLoginButton()
//        svSNSLogin.addArrangedSubview(btnFacebook)
        //        if let token = AccessToken.current, !token.isExpired {
        //            print("[Success] : Success Facebook Login")
        //        }
        //        btnFacebook.permissions = ["public_profile", "email"]
    }
}

extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        //     let naverSignInVC = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
        //     naverSignInVC.parentOrientation = UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue)!
        //     present(naverSignInVC, animated: false, completion: nil)
    }
    
    // 로그인에 성공했을 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : Success Naver Login")
        getNaverInfo()
    }
    
    // 접근 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    // 로그아웃 할 경우 호출(토큰 삭제)
    func oauth20ConnectionDidFinishDeleteToken() {
        loginNaverInstance?.requestDeleteToken()
    }
    
    // 모든 Error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
}



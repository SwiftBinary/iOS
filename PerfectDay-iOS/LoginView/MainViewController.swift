//
//  ViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/03.
//  Copyright © 2020 문종식. All rights reserved.
//

// 메소드는 10줄 -> 30줄
// 클래스는 200줄 -> 400
// 안으로 작성하기 (코드 수행에 도움이 됨!)

import UIKit
import Alamofire

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let loginCheck = isLogin()
//        if  loginCheck { // Login 됨
//            print("Debug")
//            gotoMain()
//        } else { // Login 안 됨
//            gotoLogin()
//            //gotoMain()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 로그인 정보가 없으면
        gotoLogin()
        // 로그인 정보가 있으면
        
    }
    
    func isLogin() -> Bool{
        // http://203.252.161.219:8080/
        let url = "http://203.252.161.219:8080/cmmn/isLogin.do"
        var returnValue = false
        // true - -1, false - 1
        AF.request(url, method: .get).responseString { response in
            //debugPrint(response)
            if response.value! == "-1" {
                returnValue = true
            } else {
                returnValue = false
            }
        }
        return returnValue
    }
    
    func gotoLogin(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let goToVC = storyboard.instantiateViewController(withIdentifier: "loginView")
        goToVC.modalPresentationStyle = .fullScreen
        self.present(goToVC, animated: true, completion: nil)
    }
    
    func gotoMain(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let goToVC = storyboard.instantiateViewController(withIdentifier: "mainView")
        goToVC.modalPresentationStyle = .fullScreen
        self.present(goToVC, animated: true, completion: nil)
    }
}

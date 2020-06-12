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
import SwiftyJSON

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        sleep(1)
    }
    func setData(){
        UserDefaults.standard.removeObject(forKey: locationSnKey)
        UserDefaults.standard.removeObject(forKey: locationDataKey)
        print(UserDefaults.standard.value(forKey: locationSnKey))
        print(UserDefaults.standard.value(forKey: locationDataKey))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let getData = UserDefaults.standard.dictionary(forKey: userDataKey)
        if getData == nil{
            gotoLogin()
        } else {
            gotoMain()
        }
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

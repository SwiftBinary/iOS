//
//  ViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/03.
//  Copyright © 2020 문종식. All rights reserved.
//

// 메소드는 10줄 -> 30줄
// 클래스는 200줄 -> 400줄
// 안으로 작성하기 (코드 수행에 도움이 됨!)

import UIKit
import SwiftyJSON
import Alamofire

class MainViewController: UIViewController {
    var listOneDayPickInfo = ""
    var listHotStoreInfo = ""
    
    var userData: Dictionary<String, Any> = Dictionary<String, Any>()
    
    @IBOutlet var indicLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    func setData(){
        UserDefaults.standard.removeObject(forKey: locationSnKey)
        UserDefaults.standard.removeObject(forKey: locationDataKey)
        UserDefaults.standard.removeObject(forKey: hotStoreKey)
        UserDefaults.standard.removeObject(forKey: oneDayPickKey)
        //        print(UserDefaults.standard.dictionaryRepresentation())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let getData = UserDefaults.standard.dictionary(forKey: userDataKey)
        if getData == nil{
            gotoLogin()
        } else {
            indicLoading.center = view.center
            indicLoading.startAnimating()
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
        getHotPlaceInfo()
    }
    
    func getHotPlaceInfo(){
        let url = OperationIP + "/store/selectHotStoreInfoList.do"
        AF.request(url,method: .post).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.listHotStoreInfo = JSON(response.value!).rawString()!
//                print(self.listHotStoreInfo)
                
                UserDefaults.standard.set(response.value!, forKey: "hotStore")
                self.getOneDayPickInfo()
            }
        }
    }
    
    func getOneDayPickInfo(){
        userData = getUserData()
        let url = OperationIP + "/store/selectOneDayPickInfoList.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        AF.request(url,method: .post,headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
//                self.listOneDayPickInfo = JSON(response.value!).rawString()!
//                print(self.listOneDayPickInfo)
                
                UserDefaults.standard.set(response.value!, forKey: "oneDayPick")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let goToVC = storyboard.instantiateViewController(withIdentifier: "mainView")
                goToVC.modalPresentationStyle = .fullScreen
                self.indicLoading.stopAnimating()
                self.present(goToVC, animated: true, completion: nil)
            }
        }
    }
}

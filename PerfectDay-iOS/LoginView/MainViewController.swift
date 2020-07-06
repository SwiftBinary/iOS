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
import MapKit

class MainViewController: UIViewController,CLLocationManagerDelegate {
    var listOneDayPickInfo = ""
    var listHotStoreInfo = ""
    
    var userData: Dictionary<String, Any> = Dictionary<String, Any>()
    
    @IBOutlet var indicLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        locationAuthorization()
        
    }
    override func viewWillAppear(_ animated: Bool) {
//        locationAuthorization()
    }
    override func viewDidAppear(_ animated: Bool) {
        //        locationAuthorization()
    }
    
    
    func setData(){
        UserDefaults.standard.removeObject(forKey: locationSnKey)
        UserDefaults.standard.removeObject(forKey: locationDataKey)
        UserDefaults.standard.removeObject(forKey: hotStoreKey)
        UserDefaults.standard.removeObject(forKey: oneDayPickKey)
        //        print(UserDefaults.standard.dictionaryRepresentation())
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
    
    func locationAuthorization(){
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        //        mapView.delegate = self
        // desiredAccuracy -> 정확도, kCLLocationAccuracyBest: 최고 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 정보 사용자 승인 요청
        locationManager.requestWhenInUseAuthorization()
        let coords = locationManager.location?.coordinate
        // 위치 업데이트 시작
        //        locationManager.startUpdatingLocation()
                    locationCheck()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //위치가 업데이트될때마다
        if let coor = manager.location?.coordinate{
            print("latitude" + String(coor.latitude) + "/ longitude" + String(coor.longitude))
        }
    }
    
    func locationCheck(){
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alter = UIAlertController(title: "위치권한 설정이 '안함'으로 되어있습니다.", message: "앱 설정 화면으로 가시겠습니까? \n '아니오'를 선택하시면 앱이 종료됩니다.", preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default){
                (action: UIAlertAction) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                } else {
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
            }
            let logNoAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.destructive){
                (action: UIAlertAction) in
                exit(0)
            }
            alter.addAction(logNoAction)
            alter.addAction(logOkAction)
            self.present(alter, animated: true, completion: nil)
        } else {
            let getData = UserDefaults.standard.dictionary(forKey: userDataKey)
            if getData == nil{
                gotoLogin()
            } else {
                indicLoading.center = view.center
                indicLoading.startAnimating()
                gotoMain()
            }
        }
    }
}

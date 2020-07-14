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
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    var listOneDayPickInfo = ""
    var listHotStoreInfo = ""
    
    @IBOutlet var indicLoading: UIActivityIndicatorView!
    let locationManager = CLLocationManager()
    let permissionStatus = CLLocationManager.authorizationStatus().rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isNot(_:))))
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        switch CLLocationManager.authorizationStatus().rawValue {
        case 4:
            gotoNext()
        case 0:
            locationAuthorization()
        case 2:
            goSettingLocationPermission()
        default:
            break
        }
    }
    func locationAuthorization(){
        locationManager.delegate = self
        // desiredAccuracy -> 정확도, kCLLocationAccuracyBest: 최고 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 정보 사용자 승인 요청
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트 시작
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coords = manager.location?.coordinate
        setLocationDTO(lng: Double(coords!.longitude), lat: Double(coords!.latitude))
        locationManager.stopUpdatingLocation()
        gotoNext()
    }
    func setLocationDTO(lng: Double, lat:Double){
        let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?"
        let paramCoords = "coords=" + String(lng) + "," + String(lat)
        let paramOrders = "&orders=admcode"
        let paramOutput = "&output=json"
        
        let httpHeaders: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID":naverClientIDKey,
            "X-NCP-APIGW-API-KEY":naverClientSecretKey,
        ]
        let requestURL = url + paramCoords + paramOrders + paramOutput
        AF.request(requestURL,method: .get, headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                if !JSON(response.value!)["results"].arrayValue.isEmpty {
                    let region = JSON(response.value!)["results"].arrayValue[0]["region"]
                    var strAddress = ""
                    for i in 2...4 {
                        if region["area"+String(i)]["name"].string != nil {
                            strAddress += region["area"+String(i)]["name"].stringValue + " "
                        }
                    }
                    locationDTO.setLocation(strAddress, lat: lat, lng: lng)
                }
            }
        }
    }
    
    func gotoNext() {
        let getJSONData = UserDefaults.standard.value(forKey: userDataKey)
        if getJSONData == nil{
            gotoLogin()
            UserDefaults.standard.set(0, forKey: plannerNumKey)
            let arrStoreSnList : Array<String> = []
            UserDefaults.standard.set(arrStoreSnList, forKey: "StoreSnList")
            let arrRecentlyStore : Array<String> = []
            UserDefaults.standard.set(arrRecentlyStore, forKey: recentlyStoreKey)
        } else {
            userDTO = UserDTO(jsonData: JSON.init(parseJSON: (getJSONData as! String)))
            indicLoading.center = view.center
            indicLoading.startAnimating()
            gotoMain()
        }
    }
    
    func setData(){
        UserDefaults.standard.removeObject(forKey: locationSnKey)
        UserDefaults.standard.removeObject(forKey: locationDataKey)
        UserDefaults.standard.removeObject(forKey: hotStoreKey)
        UserDefaults.standard.removeObject(forKey: oneDayPickKey)
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
            if response.value != nil {
                self.listHotStoreInfo = JSON(response.value!).rawString()!
                UserDefaults.standard.set(response.value!, forKey: "hotStore")
                self.getOneDayPickInfo()
            }
        }
    }
    
    func getOneDayPickInfo(){
        let url = OperationIP + "/store/selectOneDayPickInfoList.do"
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        AF.request(url,method: .post,headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                UserDefaults.standard.set(response.value!, forKey: "oneDayPick")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let goToVC = storyboard.instantiateViewController(withIdentifier: "mainView")
                goToVC.modalPresentationStyle = .fullScreen
                self.indicLoading.stopAnimating()
                self.present(goToVC, animated: true, completion: nil)
            }
        }
    }
    
    func goSettingLocationPermission(){
        let alter = UIAlertController(title: "위치권한을 '앱을 사용하는 동안'으로 설정해주세요.", message: "앱 설정 화면으로 가시겠습니까? \n '아니오'를 선택하시면 앱이 종료됩니다.", preferredStyle: UIAlertController.Style.alert)
        let logOkAction = UIAlertAction(title: "네", style: .default){
            (action: UIAlertAction) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
        }
        let logNoAction = UIAlertAction(title: "아니오", style: .cancel){
            (action: UIAlertAction) in
            exit(0)
        }
        alter.addAction(logNoAction)
        alter.addAction(logOkAction)
        self.present(alter, animated: true, completion: nil)
    }
    
    @objc func isNot(_ sender: UITapGestureRecognizer){
        if CLLocationManager.authorizationStatus().rawValue == 2{
            goSettingLocationPermission()
        } else {
            locationAuthorization()
        }
    }
}

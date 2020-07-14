//
//  SetLocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/07.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MapKit
import NMapsMap
import Alamofire
import SwiftyJSON

class SetLocationViewController: UIViewController,NMFMapViewCameraDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var lblCenterLocation: UILabel!
    @IBOutlet var mapNaverView: NMFMapView!
    
    @IBOutlet var setLocation: UIButton!
    
    @IBOutlet var guideView: UIView!
    @IBOutlet var disableGuideBtn: UIButton!
    @IBOutlet var colseGuideBtn: UIButton!
    
    var locationManager = CLLocationManager()
    let spanValue = 0.01
    var address:String = ""
    let marker = NMFMarker()
    var currentLatLng = NMGLatLng()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        locationManager.delegate = self
        //        mapView.delegate = self
        // desiredAccuracy -> 정확도, kCLLocationAccuracyBest: 최고 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 정보 사용자 승인 요청
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트 시작
        locationManager.startUpdatingLocation()
        // 사용자의 현재위치 표시
        let coords = locationManager.location?.coordinate
//        print(coords)
        
        mapNaverView.positionMode = .direction
        marker.position = mapNaverView.cameraPosition.target
        marker.mapView = mapNaverView
        marker.iconImage = NMFOverlayImage(name: "markerPin")
        mapNaverView.maxZoomLevel = 20
        mapNaverView.minZoomLevel = 10
        mapNaverView.zoomLevel = 15
        mapNaverView.addCameraDelegate(delegate: self)
        let centerLatLng = NMGLatLng(lat: Double(coords!.latitude), lng: Double(coords!.longitude))
//        print(centerLatLng)
        mapNaverView.moveCamera(NMFCameraUpdate(scrollTo: centerLatLng))
        mapNaverView.positionMode = .disabled
        
        lblCenterLocation.layer.borderWidth = 1
        lblCenterLocation.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        lblCenterLocation.layer.cornerRadius = lblCenterLocation.frame.height/2
        lblCenterLocation.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lblCenterLocation.layer.shadowColor = UIColor.lightGray.cgColor
        lblCenterLocation.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        lblCenterLocation.layer.shadowRadius = 2.0
        lblCenterLocation.layer.shadowOpacity = 0.9
        
        setSNSButton(setLocation, "")
        setLocation.layer.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
        setLocation.setTitleColor(.white, for: .normal)
        setLocation.setTitleColor(.lightGray, for: .highlighted)
        
        let viewHide = UserDefaults.standard.value(forKey: setMapGuideKey) as! Bool
        guideView.isHidden = viewHide
    }
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool){
        currentLatLng = NMGLatLng(lat: mapView.cameraPosition.target.lat, lng: mapView.cameraPosition.target.lng)
        marker.position = currentLatLng
        marker.mapView = mapView
        getAddress(lat: mapView.cameraPosition.target.lat, lng: mapView.cameraPosition.target.lng)
    }
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int){
        currentLatLng = NMGLatLng(lat: mapView.cameraPosition.target.lat, lng: mapView.cameraPosition.target.lng)
        marker.position = currentLatLng
        marker.mapView = mapView
    }
    
    func getAddress(lat: Double, lng:Double) {
        let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?"
        let paramCoords = "coords=" + String(lng) + "," + String(lat)
        let paramOrders = "&orders=admcode"
        let paramOutput = "&output=json"
        
        let httpHeaders: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID":naverClientIDKey,
            "X-NCP-APIGW-API-KEY":naverClientSecretKey,
        ]
        let requestURL = url + paramCoords + paramOrders + paramOutput
        //        print(requestURL)
        
        AF.request(requestURL,method: .get, headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                if !JSON(response.value!)["results"].arrayValue.isEmpty {
                    let region = JSON(response.value!)["results"].arrayValue[0]["region"]
                    var lblAddress = ""
                    for i in 2...4 {
                        if region["area"+String(i)]["name"].string != nil {
                            lblAddress += region["area"+String(i)]["name"].stringValue + " "
                        }
                    }
                    self.lblCenterLocation.text = lblAddress
                    locationDTO.setLocation(lblAddress, lat: lat, lng: lng)
                    //                    print(lblAddress)
                }
            }
        }
    }
    
    //    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span :Double) -> CLLocationCoordinate2D{
    //        // 위도/경도 값을 매개변수로 줌 ( latitudeValue, longitudeValue )
    //        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
    //        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
    //        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
    //        mapView.setRegion(pRegion, animated: true)
    //        return pLocation
    //    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let pLocation = locations.last // 위치가 업데이트되면 먼저 마지막 위치 값을 찾아냄
    //        // 마지막 위치의 위/경도 값을 가지고 goLocation을 호출
    //        // delta -> 지도의 크기, 1/Value 배
    //        // _ 반환값이 있는 func을 사용할 때 반환 값 무시
    //        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: spanValue) // 100배
    //        locationManager.stopUpdatingLocation() // 위치 업데이트 stop
    //    }
    
    //    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    //        let center = mapView.centerCoordinate
    //        //        let centerLatitude = center.latitude
    //        //        let centerLongitude = center.longitude
    //        let pLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
    //        CLGeocoder().reverseGeocodeLocation(pLocation, completionHandler: {
    //            (placemarks, error) -> Void in
    //            // Simulator -> Debug -> Location -> Custom Location
    //            let pm = placemarks!.first // placemarks의 첫 부분만 저장
    //            if pm != nil {
    //                let country = pm!.country // 나라 값
    //                var address = country!
    //                self.address = ""
    //                //print(pm!.addressDictionary)
    //                if pm!.locality != nil{ // 지역 값이 존재하면 address에 추가
    //                    address += " "
    //                    address += pm!.locality!
    //                    self.address += pm!.locality!
    //                }
    //                if pm!.name != nil{ // 지역 값이 존재하면 address에 추가
    //                    address += " "
    //                    address += pm!.name!
    //                    self.address += " " + pm!.name!
    //                }
    //                //                if pm!.thoroughfare != nil { // 도로 값이 존재하면 address에 추가
    //                //                    address += " "
    //                //                    address += pm!.thoroughfare!
    //                //                }
    //                self.lblCenterLocation.text = address
    //            }
    //        })
    //    }
    
    @IBAction func setAndBack(_ sender: UIButton) {
        locationDTO.setLocation(lblCenterLocation.text!, lat: currentLatLng.lat, lng: currentLatLng.lng)
        locationDTO.printAll()
        /*
         LocationInfo.locationString.str = address
         let navigationVCList = self.navigationController!.viewControllers
         //print(navigationVCList.count)
         navigationController?.popToViewController(navigationVCList[navigationVCList.count-3], animated: true)
         
         print(delegate as Any)
         if delegate != nil {
         delegate?.didLocationDone(self, currentLocation: address)
         }
         
         let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "locationListView")
         self.navigationController?.pushViewController(goToVC!, animated: true)
         //self.dismiss(animated: true, completion: nil)
         */
    }
    
    @IBAction func colseGuideView(_ sender: UIButton) {
        guideView.isHidden = true
        if sender == disableGuideBtn {
            UserDefaults.standard.set(true, forKey: setMapGuideKey)
        }
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

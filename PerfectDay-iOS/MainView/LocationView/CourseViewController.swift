//
//  CourseViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/09.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Material
import NMapsMap

class CourseViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var scvCourse: UIScrollView!
    @IBOutlet var svCourse: UIStackView!
    @IBOutlet var uvDetailDescriptionPlace: UIView!
    @IBOutlet var btnSaveCourse: UIButton!
    @IBOutlet var lblCourseInfo: UILabel!
    @IBOutlet var naverMapView: NMFMapView!
    var pathMap = NMFPath(points: [])
    var arrayNMGLatLng: Array<NMGLatLng> = []

    var responseJSON:Array<JSON> = []
    //    var response : Array<JSON> = []
    
    var resultStoreSn : Array<String>?
    var storeSnArr : Array<String> = []
    var courseSn:String = ""
    var totalPrice:Int = 0
    var costTm:Int = 0
    var courseNm:String = ""
    
    var lat_min:Double = 0.0
    var lat_max:Double = 0.0
    var lng_min:Double = 0.0
    var lng_max:Double = 0.0
    
    var createCourseFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBar()
        setStoreSnArray()
        setUI()
        // Do any additional setup after loading the view.
        
    }
    func setStoreSnArray(){
        if courseSn == ""{
            resultStoreSn = self.storeSnArr
            let n = resultStoreSn!.count-1
            for i in 0...n {
                if resultStoreSn![n-i] == "" {
                    resultStoreSn?.remove(at: n-i)
                }
            }
            requestStore(0)
        } else {
            btnSaveCourse.isHidden = true
            getCourseInfo(courseSn)
        }
    }
    
    func setNavigationBar(){
        self.navigationItem.title = "완벽한 하루"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(updateCourseNm(_:)))
        //        let backItem = UIBarButtonItem()
        //        backItem.title = ""
        //        self.navigationItem.backBarButtonItem = backItem
    }
    @objc func updateCourseNm(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "코스 제목을 입력해 주세요.", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField{ (textField) in
            textField.textColor = .black
            textField.text = self.courseNm
            textField.isEnabled = true
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(field:)), for:  .editingChanged)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.requestUpdateCourse(alertController.textFields![0].text!)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    @objc func alertTextFieldDidChange(field: UITextField){
        let alertController:UIAlertController = self.presentedViewController as! UIAlertController;
        //        let textField :UITextField = alertController.textFields![0];
        let addAction: UIAlertAction = alertController.actions[1];
        addAction.isEnabled = (field.text != "")
    }
    func requestUpdateCourse(_ courseNm: String){
        let url = OperationIP + "/course/updateCourseInfo.do"
        let parameter = JSON([
            "courseSn": self.courseSn,
            "courseNm": courseNm
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //                    debugPrint(response)
            if response.value != nil {
                self.navigationItem.title = courseNm
            }
        }
    }
    
    func requestStore(_ num : Int){
        let url = OperationIP + "/store/selectStoreInfo.do"
        let parameter = JSON([
            "storeSn": storeSnArr[num]
        ])
        //            let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        //        print(convertedHeaderString)
        //        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.responseJSON.append(JSON(response.value!))
                if num != 0 {
                    self.nextCourse()
                } else {
                    self.lat_min = self.responseJSON[num]["latitude"].doubleValue
                    self.lng_min = self.responseJSON[num]["longitude"].doubleValue
                    print("\(self.lat_min), \(self.lng_min)")
                    print("33")
                }
                self.setCourse(num, self.responseJSON[num])
                if num != self.resultStoreSn!.count-1 {
                    self.requestStore(num+1)
                } else {
                    self.setCourseInfo(self.totalPrice,self.costTm)
                }
            }
        }
    }
    
    func setUI(){
        setDescription()
        svCourse.axis = .vertical
        //        svCourse.removeSubviews()
        scvCourse.bounces = false
        scvCourse.showsVerticalScrollIndicator = false
        btnSaveCourse.layer.cornerRadius = 5
        
        naverMapView.maxZoomLevel = 20
        naverMapView.minZoomLevel = 10
        naverMapView.zoomLevel = 15
        //        for i in 0...resultStoreSn!.count-1 {
        //            if i != 0 {
        //                nextCourse()
        //            }
        //            setCourse(i, responseJSON[i + 1])
        //        }
    }
    
    func setDescription(){
        uvDetailDescriptionPlace.layer.borderWidth = 1
        uvDetailDescriptionPlace.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        uvDetailDescriptionPlace.layer.cornerRadius = 5
        setShadowCard(uvDetailDescriptionPlace, bgColor: .white, crRadius: 5, shColor: #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1), shOffsetW: 3, shOffsetH: 3, shRadius: 2, sdOpacity:0.9)
    }
    
    func setCourseInfo(_ cost:Int,_ time:Int){
        lblCourseInfo.text = "1인 예산 - " + DecimalWon(cost) + " | 소요 시간 - " + RegexTime(time)
        pathMap = NMFPath(points: arrayNMGLatLng)
        pathMap?.outlineWidth = 0
        pathMap?.width = 4
        pathMap?.color = #colorLiteral(red: 0.9545153975, green: 0.4153810143, blue: 0.6185087562, alpha: 1)
        pathMap?.mapView = naverMapView
    }
    
    func nextCourse(){
        //        print("\n\n\n\n\n\n nextCourse \n\n\n\n\n\n")
        let uvItem = UIView()
        uvItem.translatesAutoresizingMaskIntoConstraints = false
        uvItem.backgroundColor = .clear
        
        let uvline = UIView()
        uvline.translatesAutoresizingMaskIntoConstraints = false
        uvline.backgroundColor = .lightGray
        
        uvItem.addSubview(uvline)
        uvItem.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        uvItem.heightAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 0.04).isActive = true
        uvline.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 3).isActive = true
        uvline.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1).isActive = true
        uvline.leftAnchor.constraint(equalTo: uvItem.leftAnchor, constant: 23.5).isActive = true
        uvline.topAnchor.constraint(equalTo: uvItem.topAnchor, constant: 0).isActive = true
        uvline.bottomAnchor.constraint(equalTo: uvItem.bottomAnchor, constant: 0).isActive = true
        
        let pathBtn = UIButton(type: .custom)
        pathBtn.setImage(UIImage(named: "CourseNext"), for: .normal)
        pathBtn.contentHorizontalAlignment = .center
        pathBtn.translatesAutoresizingMaskIntoConstraints = false
        
        uvItem.addSubview(pathBtn)
        pathBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 50).isActive = true
        pathBtn.heightAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 0.04).isActive = true
        pathBtn.leftAnchor.constraint(equalTo: uvItem.leftAnchor, constant: 0).isActive = true
        pathBtn.topAnchor.constraint(equalTo: uvItem.topAnchor, constant: 0).isActive = true
        pathBtn.bottomAnchor.constraint(equalTo: uvItem.bottomAnchor, constant: 0).isActive = true
        
        svCourse.addArrangedSubview(uvItem)
    }
    
    func setCourse(_ num: Int,_ storeData : JSON){
        //        print("\n\n\n\n\n\n setCourse : ",num,"\n\n\n\n\n\n")
        
        costTm += storeData["storeCostTm"].intValue
        totalPrice += storeData["reprMenuPrice"].intValue
        
        let uvItem = UIView()
        uvItem.translatesAutoresizingMaskIntoConstraints = false
        uvItem.backgroundColor = .clear
        
        //차수 뒤 회색 선을 위한 뷰,,,,
        let uvBack = UIView()
        uvBack.translatesAutoresizingMaskIntoConstraints = false
        let uvline = UIView()
        uvline.translatesAutoresizingMaskIntoConstraints = false
        uvline.backgroundColor = .lightGray
        uvBack.addSubview(uvline)
        uvBack.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        uvBack.heightAnchor.constraint(equalTo: uvBack.widthAnchor, multiplier: 0.2).isActive = true
        uvline.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 3).isActive = true
        uvline.heightAnchor.constraint(equalTo: uvBack.heightAnchor, multiplier: 1).isActive = true
        uvline.leftAnchor.constraint(equalTo: uvBack.leftAnchor, constant: 23.5).isActive = true
        uvline.topAnchor.constraint(equalTo: uvBack.topAnchor, constant: 0).isActive = true
        uvline.bottomAnchor.constraint(equalTo: uvBack.bottomAnchor, constant: 0).isActive = true
        
        uvItem.addSubview(uvBack)
        
        
        let sequenceBtn = UIButton(type: .custom)
        sequenceBtn.translatesAutoresizingMaskIntoConstraints = false
        sequenceBtn.setTitle("\(num + 1)", for: .normal)
        sequenceBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        sequenceBtn.setTitleColor(.white, for: .normal)
        sequenceBtn.contentHorizontalAlignment = .center
        sequenceBtn.contentVerticalAlignment = .center
        sequenceBtn.isUserInteractionEnabled = false
        sequenceBtn.layer.cornerRadius = 10.5
        setSequenceColor(storeData["prefSn"].string!,sequenceBtn)
        
        let uvSequence = UIView()
        uvSequence.translatesAutoresizingMaskIntoConstraints = false
        uvSequence.addSubview(sequenceBtn)
        uvSequence.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 50).isActive = true
        uvSequence.addConstraint(NSLayoutConstraint(item: sequenceBtn, attribute: .centerX, relatedBy: .equal, toItem: uvSequence, attribute: .centerX, multiplier: 1, constant: 0))
        uvSequence.addConstraint(NSLayoutConstraint(item: sequenceBtn, attribute: .centerY, relatedBy: .equal, toItem: uvSequence, attribute: .centerY, multiplier: 1, constant: 0))
        sequenceBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 21).isActive = true
        sequenceBtn.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 21).isActive = true
        
        
        let lblStoreType = UILabel()
        setPref(lblStoreType,storeData["prefSn"].string!,storeData["prefData"].string!)
        lblStoreType.fontSize = 13
        lblStoreType.textColor = .systemBlue
        let lblStoreNm = UILabel()
        lblStoreNm.textColor = .darkText
        lblStoreNm.text = storeData["storeNm"].string
        lblStoreNm.font = UIFont.boldSystemFont(ofSize: 19.0)
        //
        let url = URL(string: getImageURL(storeData["storeSn"].stringValue, storeData["storeImageUrlList"].arrayValue.first!.stringValue, tag: "store"))
        let imgStore = UIImageView()
        let data = try? Data(contentsOf: url!)
        if data != nil {
            imgStore.image = UIImage(data: data!)
        } else {
            imgStore.image = UIImage(named: "TempImage")
        }
        //        let imgLand = UIImageView(image: UIImage(named: "TempImage"))
        imgStore.clipsToBounds = true
        imgStore.layer.cornerRadius = 5
        imgStore.contentMode = .scaleAspectFill
        imgStore.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        //        imgStore.widthAnchor.constraint(equalToConstant: view.frame.width * 0.14).isActive = true
        imgStore.widthAnchor.constraint(equalTo: imgStore.heightAnchor, multiplier: 1).isActive = true
        let svInfo = UIStackView(arrangedSubviews: [lblStoreType,lblStoreNm])
        svInfo.translatesAutoresizingMaskIntoConstraints = false
        svInfo.axis = .vertical
        svInfo.distribution = .fillProportionally
        
        let uvInfo = UIView()
        uvInfo.addSubview(svInfo)
        uvInfo.translatesAutoresizingMaskIntoConstraints = false
        //        uvInfo.widthAnchor.constraint(equalToConstant: view.frame.width * 0.6 - 65).isActive = true
        //        uvInfo.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2 - 15).isActive = true
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerX, relatedBy: .equal, toItem: uvInfo, attribute: .centerX, multiplier: 1, constant: 0))
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerY, relatedBy: .equal, toItem: uvInfo, attribute: .centerY, multiplier: 1, constant: 0))
        svInfo.widthAnchor.constraint(equalTo: uvInfo.widthAnchor, multiplier: 1).isActive = true
        svInfo.heightAnchor.constraint(equalTo: uvInfo.heightAnchor, multiplier: 1).isActive = true
        
        let pathBtn = UIButton(type: .custom)
        pathBtn.setImage(UIImage(named: "GoToSeePath"), for: .normal)
        pathBtn.contentHorizontalAlignment = .center
        pathBtn.translatesAutoresizingMaskIntoConstraints = false
        pathBtn.widthAnchor.constraint(equalTo: pathBtn.heightAnchor, multiplier: 1).isActive = true
        pathBtn.layer.cornerRadius = 5
        
        let svMain = UIStackView(arrangedSubviews: [imgStore,uvInfo,pathBtn])
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.axis = .horizontal
        svMain.distribution = .fillProportionally
        svMain.spacing = 10
        //        svMain.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9 - 65).isActive = true
        //        svMain.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2 - 15).isActive = true
        
        let uvMain = UIView()
        uvMain.addSubview(svMain)
        uvMain.backgroundColor = .clear
        uvMain.translatesAutoresizingMaskIntoConstraints = false
        uvMain.layer.borderWidth = 1
        uvMain.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        uvMain.layer.cornerRadius = 5
        //        uvMain.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9 - 50).isActive = true
        //        uvMain.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2).isActive = true
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: uvMain, attribute: .centerX, multiplier: 1, constant: 0))
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: uvMain, attribute: .centerY, multiplier: 1, constant: 0))
        svMain.heightAnchor.constraint(equalTo: uvMain.heightAnchor, multiplier: 1, constant: -15).isActive = true
        svMain.widthAnchor.constraint(equalTo: uvMain.widthAnchor, multiplier: 1, constant:  -15).isActive = true
        setShadowCard(uvMain, bgColor: .white, crRadius: 5, shColor: #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1), shOffsetW: 3, shOffsetH: 3, shRadius: 2, sdOpacity:0.9)
        
        let svItem = UIStackView(arrangedSubviews: [uvSequence,uvMain])
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .horizontal
        svItem.distribution = .fill
        
        uvItem.addSubview(svItem)
        //        uvItem.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        //        uvItem.heightAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 0.2).isActive = true
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        svItem.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1, constant:  0).isActive = true
        svItem.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1, constant:  0).isActive = true
        
        uvItem.addConstraint(NSLayoutConstraint(item: uvBack, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: uvBack, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        uvBack.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1, constant:  0).isActive = true
        uvBack.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1, constant:  0).isActive = true
        
        
        svCourse.addArrangedSubview(uvItem)
        
        
        //setStoreMarker
        let storeLatLng = NMGLatLng(lat: storeData["latitude"].doubleValue, lng: storeData["longitude"].doubleValue)
        arrayNMGLatLng.append(storeLatLng)
//        print(storeLatLng)
        let marker = NMFMarker()
        marker.position = storeLatLng
        marker.mapView = naverMapView
        marker.iconImage = NMFOverlayImage(name: "markerPin")
        //set Map Camera
        if lat_min > storeData["latitude"].doubleValue {
            lat_min = storeData["latitude"].doubleValue
        } else if lat_max < storeData["latitude"].doubleValue {
            lat_max = storeData["latitude"].doubleValue
        }
        if lng_min > storeData["longitude"].doubleValue {
            lng_min = storeData["longitude"].doubleValue
        } else if lng_max < storeData["longitude"].doubleValue {
            lng_max = storeData["longitude"].doubleValue
        }
        
        let centerLatLng = NMGLatLng(lat: (lat_min+lat_max)/2, lng: (lng_min+lng_max)/2)
//        print(centerLatLng)
        naverMapView.moveCamera(NMFCameraUpdate(scrollTo: centerLatLng))
    }
    
    func getCourseInfo(_ courseSn : String) {
        let url = OperationIP + "/course/selectCourseInfo.do"
        let parameter = JSON([
            "courseSn": courseSn,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.responseJSON = JSON(response.value!)["courseDetailList"].arrayValue
                //                print(self.responseJSON)
                for (index,item) in self.responseJSON.enumerated() {
                    if index != 0 {
                        self.nextCourse()
                    } else {
                        self.lat_min = item["storeDTO"]["latitude"].doubleValue
                        self.lng_min = item["storeDTO"]["longitude"].doubleValue
//                        print("\(self.lat_min), \(self.lng_min)")
                    }
                    self.setCourse(index, item["storeDTO"])
                }
                
                self.courseNm = JSON(response.value!)["courseNm"].stringValue
                self.totalPrice = JSON(response.value!)["totalPrice"].intValue
                self.costTm = JSON(response.value!)["costTm"].intValue
                self.setCourseInfo(self.totalPrice,self.costTm)
                self.navigationItem.title = self.courseNm
            }
        }
    }
    
    @IBAction func saveCourse(_ sender: UIButton) {
        let now = Date()
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "KST") // "2018-03-21 18:07:27"
        date.dateFormat = "yy-MM-dd"
        
        let todayString = date.string(from: now) + " 코스"
        let alertController = UIAlertController(title: "코스 제목을 입력해 주세요.", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField{ (textField) in
            textField.placeholder = todayString
            textField.textColor = .black
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.requestSaveCourse(alertController.textFields![0].text!.isEmpty ? todayString : alertController.textFields![0].text!)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
        
    }
    func requestSaveCourse(_ courseNm : String) {
        let url = OperationIP + "/course/insertCourseInfo.do"
        var jsonCourseDetailList:Array<JSON> = []
        for (i,storeSn) in resultStoreSn!.enumerated() {
            jsonCourseDetailList.append(JSON([
                "courseNumber": i,
                "storeSn": storeSn
            ]))
        }
        let parameter = JSON([
            "courseNm": courseNm,
            "courseDetailList": jsonCourseDetailList
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                let navigationVCList = self.navigationController!.viewControllers
                //print(navigationVCList.count)
                self.navigationController?.popToViewController(navigationVCList[navigationVCList.count-2], animated: true)
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

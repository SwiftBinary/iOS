//
//  HomeViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/05.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MaterialDesignWidgets

var locationString = ""

class HomeViewController: UIViewController {
    
    @IBOutlet var uvLandmark: UIView!
    @IBOutlet var uvFuncButton: UIView!
    @IBOutlet var uvThemeLocation: UIView!
    
    @IBOutlet var svFuncButton: UIStackView!
    @IBOutlet var svThemeLocation: UIStackView!
    
    let listTag = ["홍대맛집","잠실야경","VR데이트","산책데이트", "수제햄버거","미친가격","너무맛있다","건대", "홍대", "강남", "이색", "고궁", "tv방영", "가성비", "고급진", "국밥", "방탈출", "야식", "비오는날", "100일데이트코스", "커플100%되는곳", "킬링타임코스", "호불호없는"]
    let userData = getUserData()
    var listOneDayPickInfo = JSON()
    var listHotStoreInfo = JSON()
    
    var scvHotPlace = UIScrollView()
    var scvOneDayPick = UIScrollView()
    var areaSdDetailCode = ""
    
    @IBOutlet var svTempLandmark: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLandmarkMap()
        setFuncButtonView()
        getHotPlaceInfo()
        //        setThemeLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUI(){
        // Navigation Bar
        self.tabBarController?.tabBar.backgroundColor = .white
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
    }
    
    //###########################
    //           랜드마크
    //###########################
    func setLandmarkMap(){
        setShadowCard(uvLandmark, bgColor: .white, crRadius: 15, shColor: .lightGray, shOffsetW: 0.0, shOffsetH: 2.0, shRadius: 2.0, sdOpacity: 0.9)
        uvLandmark.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        var count = 0
        for i in 0...4{
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            for f in 1...5{
//                print(i*5+f)
                let landmarkKey = String(format: "%02d", i*5+f)
                let btnLandmark = UIButton(type: .system)
                btnLandmark.setTitle(landmarkInfoDictionary[landmarkKey], for: .normal)
                btnLandmark.contentHorizontalAlignment = .center
                btnLandmark.accessibilityIdentifier = landmarkKey
                btnLandmark.addTarget(self, action: #selector(getLandmarkList(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(btnLandmark)
                count += 1
            }
            svTempLandmark.addArrangedSubview(stackView)
        }
        
        // 해시태그
        let scvTag = UIScrollView()
        scvTag.translatesAutoresizingMaskIntoConstraints = false
        let svTag = UIStackView()
        for hashTag in listTag {
            let btnHashTag = UIButton(type: .system)
            btnHashTag.setTitle(setHashTagString(hashTag))
            btnHashTag.layer.cornerRadius = 15
            btnHashTag.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            btnHashTag.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
            svTag.addArrangedSubview(btnHashTag)
        }
        svTag.translatesAutoresizingMaskIntoConstraints = false
        svTag.spacing = 10
        scvTag.addSubview(svTag)
        scvTag.addConstraint(NSLayoutConstraint(item: svTag, attribute: .centerY, relatedBy: .equal, toItem: scvTag, attribute: .centerY, multiplier: 1, constant: 0))
        scvTag.showsHorizontalScrollIndicator = false
        svTag.topAnchor.constraint(equalTo: scvTag.topAnchor, constant: 0).isActive = true
        svTag.bottomAnchor.constraint(equalTo: scvTag.bottomAnchor, constant: 0).isActive = true
        svTag.leadingAnchor.constraint(equalTo: scvTag.leadingAnchor, constant: 0).isActive = true
        svTag.trailingAnchor.constraint(equalTo: scvTag.trailingAnchor, constant: 0).isActive = true
        
        uvLandmark.addSubview(scvTag)
        uvLandmark.addConstraint(NSLayoutConstraint(item: scvTag, attribute: .centerX, relatedBy: .equal, toItem: uvLandmark, attribute: .centerX, multiplier: 1, constant: 0))
        scvTag.bottomAnchor.constraint(equalTo: uvLandmark.bottomAnchor, constant: -15).isActive = true
        scvTag.widthAnchor.constraint(equalTo: uvLandmark.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    @objc func getLandmarkList(_ sender:UIButton){
        areaSdDetailCode = sender.accessibilityIdentifier!
//        print(areaSdDetailCode)
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "landmarkListView") as! LandmarkViewController
        goToVC.areaSdDetailCode = self.areaSdDetailCode
        self.navigationController?.pushViewController(goToVC, animated: true)
        
    }
    
    
    //###########################
    //           기능버튼
    //###########################
    func setFuncButtonView(){
        setShadowCard(uvFuncButton, bgColor: #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1), crRadius: 15, shColor: .lightGray, shOffsetW: 0.0, shOffsetH: 2.0, shRadius: 2.0, sdOpacity: 0.9)
        
        let fontSize:CGFloat = 16
        
        let btnOneClickCourse = MaterialVerticalButton(icon: UIImage(named: "CourseRecommandIcon")!, text: "원클릭 코스 추천", font: nil ,foregroundColor: .black, bgColor: .white, useOriginalImg: true,cornerRadius: 15.0)
        btnOneClickCourse.label.font = UIFont.boldSystemFont(ofSize: fontSize)
        btnOneClickCourse.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        btnOneClickCourse.addTarget(self, action: #selector(getOneClickCourseRecommand(_:)), for: .touchUpInside)
        
        let btnFindAroundLocation = MaterialVerticalButton(icon: UIImage(named: "SearchLocationIcon")!, text: "내 주변 장소 찾기", font: nil ,foregroundColor: .black, bgColor: .white, useOriginalImg: true, cornerRadius: 15.0)
        btnFindAroundLocation.label.font = UIFont.boldSystemFont(ofSize: fontSize)
        btnFindAroundLocation.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        svFuncButton.addArrangedSubview(btnOneClickCourse)
        svFuncButton.addArrangedSubview(btnFindAroundLocation)
    }
    
    @objc func getOneClickCourseRecommand(_ sender: UIButton){
        let url = OperationIP + "/oneClick/selectOneClickInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        //        let parameter = JSON([])
        //        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")//.replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                print("~~~~~~~~~~~~~~~~~~~~~~~원클릭코스")
                print(JSON(response.value!))
                print("~~~~~~~~~~~~~~~~~~~~~~~")
            }
        }
    }
    
    //###########################
    //           테마장소
    //###########################
    func getHotPlaceInfo(){
        let url = OperationIP + "/store/selectHotStoreInfoList.do"
        AF.request(url,method: .post).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.listHotStoreInfo = JSON(response.value!)
                print("~~~~~~~~~~~~~~~~~~~~~~~핫플레이스")
                //                print(self.listHotStoreInfo)
                print("~~~~~~~~~~~~~~~~~~~~~~~")
                self.scvHotPlace = self.makeScrollView(Theme: "HotPlace")
                self.getOneDayPickInfo()
            }
        }
    }
    func getOneDayPickInfo(){
        let url = OperationIP + "/store/selectOneDayPickInfoList.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        AF.request(url,method: .post,headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.listOneDayPickInfo = JSON(response.value!)
                print("~~~~~~~~~~~~~~~~~~~~~~~00세의 하루")
                //                print(self.listOneDayPickInfo)
                print("~~~~~~~~~~~~~~~~~~~~~~~")
                self.scvOneDayPick = self.makeScrollView(Theme: "OneDayPick")
                self.setThemeLocation()
            }
        }
    }
    
    func setThemeLocation(){
        setShadowCard(uvThemeLocation, bgColor: .white, crRadius: 15, shColor: .lightGray, shOffsetW: 0.0, shOffsetH: 2.0, shRadius: 2.0, sdOpacity: 0.9)
        uvThemeLocation.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let lblHotPlace = UILabel()
        lblHotPlace.font = UIFont.boldSystemFont(ofSize: 17)
        let attributedHotPlaceString: NSMutableAttributedString = NSMutableAttributedString(string: "금주의 핫 플레이스")
        attributedHotPlaceString.setColor(color: #colorLiteral(red: 0.9882352941, green: 0.368627451, blue: 0.5725490196, alpha: 1), forText: "핫 플레이스")
        lblHotPlace.attributedText = attributedHotPlaceString
        let imgHotPlace = UIButton(type: .custom)
        imgHotPlace.isUserInteractionEnabled = false
        imgHotPlace.setTitle(" ")
        imgHotPlace.setImage(UIImage(named: "HotPlace"), for: .normal)
        imgHotPlace.semanticContentAttribute = .forceRightToLeft
        imgHotPlace.contentHorizontalAlignment = .left
        //        UIImageView(image: UIImage(named: "HotPlace"))
        //        imgHotPlace.heightAnchor.constraint(equalToConstant: 16).isActive = true
        //        imgHotPlace.contentMode = .scaleAspectFit
        
        let svHotPlaceTitle = UIStackView(arrangedSubviews: [lblHotPlace,imgHotPlace])
        svHotPlaceTitle.axis = .horizontal
        
        //        getHotPlaceInfo()
        
        let svHotPlace = UIStackView(arrangedSubviews: [svHotPlaceTitle,scvHotPlace])
        svHotPlace.axis = .vertical
        svHotPlace.spacing = 10
        
        let lblOneDayPick = UILabel()
        lblOneDayPick.font = UIFont.boldSystemFont(ofSize: 17)
        let attributedOneDayPickString: NSMutableAttributedString = NSMutableAttributedString(string: "20세의 오늘")
        attributedOneDayPickString.setColor(color: #colorLiteral(red: 0.9882352941, green: 0.368627451, blue: 0.5725490196, alpha: 1), forText: "오늘")
        lblOneDayPick.attributedText = attributedOneDayPickString
        let imgOneDayPick = UIButton(type: .custom)
        imgOneDayPick.isUserInteractionEnabled = false
        imgOneDayPick.setTitle(" ")
        imgOneDayPick.setImage(UIImage(named: "Oneul"), for: .normal)
        imgOneDayPick.semanticContentAttribute = .forceRightToLeft
        imgOneDayPick.contentHorizontalAlignment = .left
        
        let svOneDayPickTitle = UIStackView(arrangedSubviews: [lblOneDayPick,imgOneDayPick])
        svOneDayPickTitle.axis = .horizontal
        
        //        getOneDayPickInfo()
        
        let svOneDayPick = UIStackView(arrangedSubviews: [svOneDayPickTitle,scvOneDayPick])
        svOneDayPick.axis = .vertical
        svOneDayPick.spacing = 10
        
        let svTheme = UIStackView(arrangedSubviews: [svHotPlace,svOneDayPick])
        svTheme.axis = .vertical
        svTheme.spacing = 15
        
        let uvBottom = UIView()
        uvBottom.backgroundColor = .white
        uvBottom.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        
        svThemeLocation.addArrangedSubview(svTheme)
        svThemeLocation.addArrangedSubview(uvBottom)
    }
    
    func makeScrollView(Theme:String) -> UIScrollView {
        let scvPlace = UIScrollView()
        scvPlace.translatesAutoresizingMaskIntoConstraints = false
        let svPlaceItem = UIStackView()
        switch Theme {
        case "HotPlace":
            addHotPlaceItem(svPlaceItem, listHotStoreInfo)
        case "OneDayPick":
            filterOneDayPickInfo(svPlaceItem, listOneDayPickInfo)
        default:
            print("Error")
        }
        svPlaceItem.translatesAutoresizingMaskIntoConstraints = false
        svPlaceItem.spacing = 15
        scvPlace.addSubview(svPlaceItem)
        scvPlace.addConstraint(NSLayoutConstraint(item: svPlaceItem, attribute: .centerY, relatedBy: .equal, toItem: scvPlace, attribute: .centerY, multiplier: 1, constant: 0))
        scvPlace.showsHorizontalScrollIndicator = false
        svPlaceItem.topAnchor.constraint(equalTo: scvPlace.topAnchor, constant: 0).isActive = true
        svPlaceItem.bottomAnchor.constraint(equalTo: scvPlace.bottomAnchor, constant: 0).isActive = true
        svPlaceItem.leadingAnchor.constraint(equalTo: scvPlace.leadingAnchor, constant: 0).isActive = true
        svPlaceItem.trailingAnchor.constraint(equalTo: scvPlace.trailingAnchor, constant: 0).isActive = true
        
        return scvPlace
    }
    
    func addHotPlaceItem(_ stackView: UIStackView, _ items: JSON){
        for item in items.arrayValue{
            let url = URL(string: getImageURL(item["storeSn"].stringValue, item["storeImageUrlList"].arrayValue.first!.stringValue,tag: "store"))
            let data = try? Data(contentsOf: url!)
            let imgLocation = UIImageView()
            if data != nil {
                imgLocation.image = UIImage(data: data!)
            } else {
                imgLocation.image = UIImage(named: "TempImage")
            }
            imgLocation.widthAnchor.constraint(equalToConstant: 136).isActive = true
            imgLocation.heightAnchor.constraint(equalToConstant: 136).isActive = true
            imgLocation.contentMode = .scaleAspectFill
            imgLocation.clipsToBounds = true
            imgLocation.layer.cornerRadius = 5
            
            let lblLocationName = UILabel()
            lblLocationName.text = item["storeNm"].stringValue
            lblLocationName.font = UIFont.boldSystemFont(ofSize: 16)
            
            let lblLocationAddress = UILabel()
            lblLocationAddress.text = item["areaDetailNm"].stringValue
            lblLocationAddress.fontSize = 13
            
            let svItem = UIStackView(arrangedSubviews: [imgLocation,lblLocationName,lblLocationAddress])
            svItem.axis = .vertical
            svItem.spacing = 7
            svItem.accessibilityIdentifier = item["storeSn"].stringValue
            svItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationInfo(_:))))
            
            stackView.addArrangedSubview(svItem)
        }
    }
    
    func filterOneDayPickInfo(_ svPlaceItem:UIStackView,_ items: JSON){
        for item in items.arrayValue{
            if item["adItem"].boolValue{
                addADOneDayPickItem(svPlaceItem, item)
            } else {
                addOneDayPickItem(svPlaceItem, item)
            }
        }
    }
    
    func addADOneDayPickItem(_ stackView: UIStackView, _ item: JSON){
        let url = URL(string: getImageURL(item["storeSn"].stringValue, item["storeImageUrlList"].arrayValue.first!.stringValue,tag: "store"))
        let data = try? Data(contentsOf: url!)
        let imgLocation = UIImageView()
        if data != nil {
            imgLocation.image = UIImage(data: data!)
        } else {
            imgLocation.image = UIImage(named: "TempImage")
        }
        
        imgLocation.widthAnchor.constraint(equalToConstant: 136).isActive = true
        imgLocation.heightAnchor.constraint(equalToConstant: 136).isActive = true
        imgLocation.contentMode = .scaleAspectFill
        imgLocation.clipsToBounds = true
        imgLocation.layer.cornerRadius = 5
        
        let imgAdLabel = UIImageView(image: UIImage(named: "AdLabelIcon"))
        imgAdLabel.translatesAutoresizingMaskIntoConstraints = false
        imgAdLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imgAdLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imgLocation.addSubview(imgAdLabel)
        imgAdLabel.topAnchor.constraint(equalTo: imgLocation.topAnchor, constant: 4).isActive = true
        imgAdLabel.leadingAnchor.constraint(equalTo: imgLocation.leadingAnchor, constant: 4).isActive = true
        
        let btnADLabel = UIButton(type: .custom)
        btnADLabel.isUserInteractionEnabled = false
        btnADLabel.setTitle(" ")
        btnADLabel.setImage(UIImage(named: "AdIcon"), for: .normal)
        //        lblADLabel.semanticContentAttribute = .
        btnADLabel.contentHorizontalAlignment = .center
        
        let lblLocationName = UILabel()
        lblLocationName.text = item["storeNm"].stringValue
        lblLocationName.font = UIFont.boldSystemFont(ofSize: 16)
        
        let btnADHelp = UIButton(type: .custom)
        btnADHelp.setTitle(" ")
        btnADHelp.setImage(UIImage(named: "HelpIcon"), for: .normal)
        //        lblADLabel.semanticContentAttribute = .
        btnADHelp.contentHorizontalAlignment = .center
        btnADHelp.addTarget(self, action: #selector(touchelp(_:)), for: .touchDown)
        
        let svLocationName = UIStackView(arrangedSubviews: [btnADLabel,lblLocationName,btnADHelp])
        svLocationName.axis = .horizontal
        svLocationName.distribution = .fillProportionally
        svLocationName.spacing = 3
        
        let lblLocationAddress = UILabel()
        lblLocationAddress.text = item["areaDetailNm"].stringValue
        lblLocationAddress.fontSize = 13
        
        let svItem = UIStackView(arrangedSubviews: [imgLocation,svLocationName,lblLocationAddress])
        svItem.axis = .vertical
        svItem.spacing = 7
        svItem.accessibilityIdentifier = item["storeSn"].stringValue
        svItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationInfo(_:))))
        
        stackView.addArrangedSubview(svItem)
    }
    
    @objc func touchelp(_ sender: UIButton){
        
    }
    
    func addOneDayPickItem(_ stackView: UIStackView, _ item: JSON){
        let url = URL(string: getImageURL(item["storeSn"].stringValue, item["storeImageUrlList"].arrayValue.first!.stringValue,tag: "store"))
        let data = try? Data(contentsOf: url!)
        let imgLocation = UIImageView()
        if data != nil {
            imgLocation.image = UIImage(data: data!)
        } else {
            imgLocation.image = UIImage(named: "TempImage")
        }
        imgLocation.widthAnchor.constraint(equalToConstant: 136).isActive = true
        imgLocation.heightAnchor.constraint(equalToConstant: 136).isActive = true
        imgLocation.contentMode = .scaleAspectFill
        imgLocation.clipsToBounds = true
        imgLocation.layer.cornerRadius = 5
        
        let lblLocationRank = UILabel()
        let strRank = String(item["ranking"].intValue) + "위"
        //            lblLocationRank.text = strRank
        lblLocationRank.font = UIFont.boldSystemFont(ofSize: 16)
        let attributedLocationRankString = NSMutableAttributedString(string: strRank)
        attributedLocationRankString.setAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)], range: (strRank as NSString).range(of: "위"))
        lblLocationRank.attributedText = attributedLocationRankString
        lblLocationRank.textColor = .white
        lblLocationRank.textAlignment = .center
        lblLocationRank.layer.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.368627451, blue: 0.5725490196, alpha: 1)
        lblLocationRank.layer.cornerRadius = 5
        lblLocationRank.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        lblLocationRank.translatesAutoresizingMaskIntoConstraints = false
        lblLocationRank.widthAnchor.constraint(equalToConstant: 30).isActive = true
        lblLocationRank.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imgLocation.addSubview(lblLocationRank)
        lblLocationRank.topAnchor.constraint(equalTo: imgLocation.topAnchor, constant: 0).isActive = true
        lblLocationRank.leadingAnchor.constraint(equalTo: imgLocation.leadingAnchor, constant:0).isActive = true
        
        let lblLocationName = UILabel()
        lblLocationName.text = item["storeNm"].stringValue
        lblLocationName.font = UIFont.boldSystemFont(ofSize: 16)
        
        let lblLocationAddress = UILabel()
        lblLocationAddress.text = item["areaDetailNm"].stringValue
        lblLocationAddress.fontSize = 13
        
        let svItem = UIStackView(arrangedSubviews: [imgLocation,lblLocationName,lblLocationAddress])
        svItem.axis = .vertical
        svItem.spacing = 7
        svItem.accessibilityIdentifier = item["storeSn"].stringValue
        svItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationInfo(_:))))
        
        stackView.addArrangedSubview(svItem)
    }
    
    @objc func gotoLocationInfo(_ sender: UITapGestureRecognizer){
        let locationSn = sender.view!.accessibilityIdentifier
//        UserDefaults.standard.setValue(locationSn, forKey: locationSnKey)
        getLocationInfo(locationSn!)
    }
    
    func getLocationInfo(_ locationSn : String) {
        //        let locationSn = UserDefaults.standard.string(forKey: locationSnKey)!
        let url = OperationIP + "/store/selectStoreInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        let parameter = JSON([
            "storeSn": locationSn,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //                  debugPrint(response)
            if response.value != nil {
                let reponseJSON = JSON(response.value!)
                print(reponseJSON)
                //                    self.uds.set(reponseJSON.dictionaryObject, forKey: locationDataKey)
                locationData = reponseJSON
                let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "locationInfoView")
                self.navigationController?.pushViewController(goToVC!, animated: true)
            }
        }
        //            if (UserDefaults.standard.string(forKey: locationSnKey) != nil) {
        //
        //            }
    }
    
    
    
    //      In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.destination {
        //            let landmarkViewController = segue.destination as! LandmarkViewController
        //            landmarkViewController.areaSdDetailCode = self.areaSdDetailCode
        //        }
        //      Get the new view controller using segue.destination.
        //      Pass the selected object to the new view controller.
    }
    
}

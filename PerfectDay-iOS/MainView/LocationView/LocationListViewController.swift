//
//  LocationListViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/05.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MaterialDesignWidgets

class LocationListViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var uvKategorie: UIView!
    @IBOutlet var svKategorie: UIStackView!
    @IBOutlet var svLocation: UIStackView!
    @IBOutlet var scvFilter: UIScrollView!
    @IBOutlet var svFilterBtn: UIStackView!
    @IBOutlet var scrollMain: UIScrollView!
    @IBOutlet var uvLocationList: UIView!
    
    
    @IBOutlet var initFilterBtn: UIButton!
    @IBOutlet var preferFilterBtn: UIButton!
    @IBOutlet var distanceFilterBtn: UIButton!
    @IBOutlet var priceFilterBtn: UIButton!
    @IBOutlet var timeFilterBtn: UIButton!
    
    
    @IBOutlet var uvFilterPopupBack: UIView!
    @IBOutlet var uvFilterView: UIView!
    @IBOutlet var uvFilter: UIView!
    
    let userData = getUserData()
    let testNum = 3
    let lightGray = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    let backColor = #colorLiteral(red: 0.9937904477, green: 0.9502945542, blue: 0.9648948312, alpha: 1)
    
    var landmarkSn:String = ""
    var listStoreData:Array<JSON> = []
    var tempBtn : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setKategorie()
        setFilterBtnList()
        getLandmarkInfo()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setNavigationBar(){
        self.navigationItem.title = "완벽한 하루"
        let backItem = UIBarButtonItem()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
    }
    
    //###########################
    //           카테고리
    //###########################
    func setKategorie(){
        let btnAll = MaterialVerticalButton(icon: UIImage(named: "CategorieAll")!, text: "전체보기", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnEat = MaterialVerticalButton(icon: UIImage(named: "CategorieEat")!, text:  "먹기", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnDrink = MaterialVerticalButton(icon: UIImage(named: "CategorieDrink")!, text:  "마시기", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnPlay = MaterialVerticalButton(icon: UIImage(named: "CategoriePlay")!, text: "놀기", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnWatch = MaterialVerticalButton(icon: UIImage(named: "CategorieWatch")!, text: "보기", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnWalk = MaterialVerticalButton(icon: UIImage(named: "CategorieWalk")!, text: "걷기", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        
        let btnArray = [btnAll,btnEat,btnDrink,btnPlay,btnWatch,btnWalk]
        
        uvKategorie.layer.shadowColor = UIColor.lightGray.cgColor
        uvKategorie.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        uvKategorie.layer.shadowRadius = 2.0
        uvKategorie.layer.shadowOpacity = 0.5
        
        for btn in btnArray {
            btn.label.font = btn.label.font.withSize(13)
            svKategorie.addArrangedSubview(btn)
        }
    }
    
    //###########################
    //           필터
    //###########################
    func setFilterBtnList(){
        for btn in svFilterBtn.arrangedSubviews {
            btn.layer.cornerRadius = svFilterBtn.frame.height/2
            btn.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btn.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            btn.layer.shadowColor = UIColor.lightGray.cgColor
            btn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn.layer.shadowRadius = 2.0
            btn.layer.shadowOpacity = 0.5
        }
        scrollViewDidScroll(scvFilter)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = false
    }
    
    @IBAction func changeForm(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            print("List")
        } else {
            print("Block")
        }
    }
    
    
    //filter PopUp
    @IBAction func FilterPopup(_ sender: UIButton?) {
        
        setFilterView()
        
        if sender == tempBtn {
            
            if self.uvFilterPopupBack.isHidden == false {
                self.uvFilterPopupBack.isHidden = true
            } else {
                self.uvFilterPopupBack.isHidden = false
            }
        } else {
            self.uvFilterPopupBack.isHidden = false
            self.uvFilter.removeSubviews()
            if sender == initFilterBtn {
                self.initFilterBtn.isHidden = true
                //
                //초기화 코드 추가 예정
                //
            }
            else if sender == preferFilterBtn {
                preferFilter()
            }
            else {
                sliderFilters(sender)
            }
        }
        
        tempBtn = sender
    }
    
    func setFilterView(){
        self.uvFilterView.translatesAutoresizingMaskIntoConstraints = false
        //        self.uvFilterView.layer.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        self.uvFilterView.layer.cornerRadius = 15
        //        self.uvFilter.backgroundColor = .cyan
        self.uvFilter.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func preferFilter(){
        let lbPrefer = UIButton(type: .custom)
        lbPrefer.setTitle("선호순", for: .normal)
        lbPrefer.setTitleColor(.darkGray, for: .normal)
        lbPrefer.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbPrefer.semanticContentAttribute = .forceRightToLeft
        lbPrefer.titleLabel?.fontSize = 15
        lbPrefer.isUserInteractionEnabled = false
        let lbCloser = UIButton(type: .custom)
        lbCloser.setTitle("가까운순", for: .normal)
        lbCloser.setTitleColor(.darkGray, for: .normal)
        lbCloser.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbCloser.semanticContentAttribute = .forceRightToLeft
        lbCloser.titleLabel?.fontSize = 15
        lbCloser.isUserInteractionEnabled = false
        let lbHigherPrice = UIButton(type: .custom)
        lbHigherPrice.setTitle("높은 가격순", for: .normal)
        lbHigherPrice.setTitleColor(.darkGray, for: .normal)
        lbHigherPrice.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbHigherPrice.semanticContentAttribute = .forceRightToLeft
        lbHigherPrice.titleLabel?.fontSize = 15
        lbHigherPrice.isUserInteractionEnabled = false
        let lbLowerPrice = UIButton(type: .custom)
        lbLowerPrice.setTitle("낮은 가격순", for: .normal)
        lbLowerPrice.setTitleColor(.darkGray, for: .normal)
        lbLowerPrice.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbLowerPrice.semanticContentAttribute = .forceRightToLeft
        lbLowerPrice.titleLabel?.fontSize = 15
        lbLowerPrice.isUserInteractionEnabled = false
        let lbLongStayTime = UIButton(type: .custom)
        lbLongStayTime.setTitle("머무는 시간 ↑", for: .normal)
        lbLongStayTime.setTitleColor(.darkGray, for: .normal)
        lbLongStayTime.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbLongStayTime.semanticContentAttribute = .forceRightToLeft
        lbLongStayTime.titleLabel?.fontSize = 15
        lbLongStayTime.isUserInteractionEnabled = false
        let lbShortStayTime = UIButton(type: .custom)
        lbShortStayTime.setTitle("머무는 시간 ↓", for: .normal)
        lbShortStayTime.setTitleColor(.darkGray, for: .normal)
        lbShortStayTime.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbShortStayTime.semanticContentAttribute = .forceRightToLeft
        lbShortStayTime.titleLabel?.fontSize = 15
        //        lbShortStayTime.imageRect(forContentRect: CGRect(x: 0, y: 0, width: 35, height: 35))
        lbShortStayTime.isUserInteractionEnabled = false
        lbShortStayTime.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
        let svFilter = UIStackView(arrangedSubviews: [lbPrefer,lbCloser,lbHigherPrice,lbLowerPrice,lbLongStayTime,lbShortStayTime])
        svFilter.translatesAutoresizingMaskIntoConstraints = false
        svFilter.axis = .vertical
        svFilter.distribution = .equalSpacing
        svFilter.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        svFilter.heightAnchor.constraint(equalTo: svFilter.widthAnchor, multiplier: 0.63).isActive = true
        
        uvFilter.addSubview(svFilter)
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerX, relatedBy: .equal, toItem: uvFilter, attribute: .centerX, multiplier: 1, constant: 0))
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerY, relatedBy: .equal, toItem: uvFilter, attribute: .centerY, multiplier: 1, constant: 0))
        uvFilter.widthAnchor.constraint(equalTo: svFilter.widthAnchor, multiplier: 1).isActive = true
        uvFilter.heightAnchor.constraint(equalToConstant: 35 * 6).isActive = true
        
    }
    
    func sliderFilters(_ sender: UIButton?){
        
        let lbTitle = UILabel()
        lbTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        let lbRange = UILabel()
        lbRange.font = UIFont.boldSystemFont(ofSize: 19.0)
        lbRange.textColor = themeColor
        let svLabel = UIStackView(arrangedSubviews: [lbTitle, lbRange])
        svLabel.axis = .vertical
        svLabel.distribution = .fillProportionally
        svLabel.spacing = 15
        svLabel.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        //        svLabel.heightAnchor.constraint(equalTo: svLabel.widthAnchor, multiplier: 0.1).isActive = true
        //
        let slider = UISlider()
        slider.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        slider.minimumTrackTintColor = themeColor
        //
        let minInt = UILabel()
        let quarterInt = UILabel()
        let threequarterInt = UILabel()
        let maxInt = UILabel()
        minInt.fontSize = 13
        quarterInt.fontSize = 13
        threequarterInt.fontSize = 13
        maxInt.fontSize = 13
        quarterInt.textAlignment = .center
        threequarterInt.textAlignment = .center
        maxInt.textAlignment = .right
        let svRange = UIStackView(arrangedSubviews: [minInt,quarterInt,threequarterInt,maxInt])
        svRange.axis = .horizontal
        svRange.distribution = .fillEqually
        
        let btnSetFilter = UIButton(type: .custom)
        
        btnSetFilter.setTitle("완료", for: .normal)
        btnSetFilter.setTitleColor(.white, for: .normal)
        btnSetFilter.backgroundColor = themeColor
        btnSetFilter.contentHorizontalAlignment = .center
        btnSetFilter.translatesAutoresizingMaskIntoConstraints = false
        btnSetFilter.layer.cornerRadius = 5
        btnSetFilter.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        btnSetFilter.heightAnchor.constraint(equalTo: btnSetFilter.widthAnchor, multiplier: 40/295, constant: 1).isActive = true
        
        
        if sender == distanceFilterBtn {
            lbTitle.text = "거리"
            lbRange.text = String(Double(slider.value)/10) + "km"
            slider.minimumValue = 0
            slider.maximumValue = 30
            minInt.text = "0m"
            quarterInt.text = "1km"
            threequarterInt.text = "2km"
            maxInt.text = "3km+"
        }
        else if sender == priceFilterBtn {
            lbTitle.text = "대표메뉴 가격"
            lbRange.text = String(Double(slider.value)/10) + "만원"
            slider.minimumValue = 0
            slider.maximumValue = 70
            minInt.text = "0원"
            quarterInt.text = "2만원"
            threequarterInt.text = "4만원"
            maxInt.text = "7만원+"
        }
        else if sender == timeFilterBtn {
            lbTitle.text = "예상 소요시간"
            lbRange.text = String(Double(slider.value)/6) + "시간"
            slider.minimumValue = 0
            slider.maximumValue = 18
            minInt.text = "0시간"
            quarterInt.text = "1시간"
            threequarterInt.text = "2시간"
            maxInt.text = "3시간+"
        }
        
        let svFilter = UIStackView(arrangedSubviews: [svLabel,slider,svRange,btnSetFilter])
        svFilter.translatesAutoresizingMaskIntoConstraints = false
        svFilter.axis = .vertical
        svFilter.distribution = .equalSpacing
        svFilter.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        svFilter.heightAnchor.constraint(equalTo: svFilter.widthAnchor, multiplier: 170/295).isActive = true
        
        uvFilter.addSubview(svFilter)
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerX, relatedBy: .equal, toItem: uvFilter, attribute: .centerX, multiplier: 1, constant: 0))
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerY, relatedBy: .equal, toItem: uvFilter, attribute: .centerY, multiplier: 1, constant: 0))
        uvFilter.widthAnchor.constraint(equalTo: svFilter.widthAnchor, multiplier: 1).isActive = true
        uvFilter.heightAnchor.constraint(equalTo: svFilter.heightAnchor, multiplier: 1).isActive = true
        
    }
    
    
    
    //###########################
    //         장소 리스트
    //###########################
    func getLandmarkInfo(){
        let url = OperationIP + "/landmark/selectLandmarkInfo.do"
        let parameter = JSON([
            "landmarkSn" : landmarkSn,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString]).responseJSON { response in
            if response.value != nil {
//                print(response.value!)
                let landmarkInfo = JSON(response.value!)
                print("***")
//                print(landmarkInfo)
                self.getStoreList(landmarkInfo)
            }
        }
    }
    func getStoreList(_ landmarkInfo:JSON){
        let url = OperationIP + "/store/selectStoreInfoList.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        let parameter = JSON([
            "distanceLimit": 3,
            "latitude": 37.68915657,
            "limit": 20,
            "longitude": 127.04546691,
            "offset": 0,
            "priceLimit": 70000,
            "searchKeyWord": "고기",
            "sortedBy": "DISTANCE_ASC",
            "tmCostLimit": 180,
            
            //            "latitude": landmarkInfo["latitude"].doubleValue,
            //            "longitude": landmarkInfo["longitude"].doubleValue,
            //            "limit": 20,
            //            "offset": 0,
            //            "priceLimit": 70000,
            //            "searchKeyWord": "",
            //            "sortedBy": "DISTANCE_ASC",
            //            "tmCostLimit": 180,
            //            "distanceLimit": 3,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
//            debugPrint(response)
            if response.value != nil {
                let reponseJSON = JSON(response.value!)
                print("^^^")
                print(reponseJSON)
                self.setLocationList(reponseJSON.arrayValue)
            }
        }
    }
    
    func setLocationList(_ listStore:[JSON]){
        setLocationListBackView()
        setStackView()
        for i in listStore {
            makeItem(i)
        }
    }
    
    func setStackView(){
        svLocation.axis = .vertical
        svLocation.spacing = 10
        //        svLocation.topAnchor.constraint(equalTo: svLocation.topAnchor, constant: 10).isActive = true
    }
    func setLocationListBackView(){
        uvLocationList.translatesAutoresizingMaskIntoConstraints = false
        uvLocationList.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uvLocationList.layer.cornerRadius = 15
        uvLocationList.layer.shadowColor = UIColor.lightGray.cgColor
        uvLocationList.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        uvLocationList.layer.shadowRadius = 2.0
        uvLocationList.layer.shadowOpacity = 0.5
    }
    
    func makeItem(_ item: JSON) {
        let uvLocation = UIView()
        uvLocation.translatesAutoresizingMaskIntoConstraints = false
        uvLocation.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uvLocation.layer.cornerRadius = 5
        uvLocation.layer.borderWidth = 0.5
        uvLocation.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        let fontSize:CGFloat = 12
        
        let lblStoreType = UILabel()
        setPref(lblStoreType,item["prefSn"].string!,item["prefData"].string!)
        lblStoreType.text = "장소유형"
        lblStoreType.fontSize = fontSize
        lblStoreType.textColor = .systemBlue
        let lblStoreNm = UILabel()
        lblStoreNm.text = item["storeNm"].stringValue
        lblStoreNm.font = UIFont.boldSystemFont(ofSize: fontSize+3)
        let svUpperLeft = UIStackView(arrangedSubviews: [lblStoreType,lblStoreNm])
        svUpperLeft.distribution = .fillEqually
        svUpperLeft.axis = .vertical
        svUpperLeft.spacing = 1
        let btnAddPlanner = UIButton()
        btnAddPlanner.setImage(UIImage(named: "AddPlannerBtn"), for: .normal)
        btnAddPlanner.contentHorizontalAlignment = .right
        btnAddPlanner.imageView?.contentMode = .scaleAspectFill
        let svTop = UIStackView(arrangedSubviews: [svUpperLeft,btnAddPlanner])
        svTop.axis = .horizontal
        svTop.distribution = .fillProportionally
        //        svTop.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.56) - 15 ).isActive = true
        //        svTop.heightAnchor.constraint(equalToConstant: (view.frame.width * 0.12) - 7 ).isActive = true
        
        let lblReprMenuPrice = UILabel()
        lblReprMenuPrice.text = "대표메뉴 " + item["reprMenuPrice"].stringValue + "원"
        lblReprMenuPrice.fontSize = fontSize
        let lblAreaDetailNm = UIButton(type: .custom)
        lblAreaDetailNm.setTitle(item["areaDetailNm"].stringValue, for: .normal)
        lblAreaDetailNm.setTitleColor(.darkGray, for: .normal)
        lblAreaDetailNm.setImage(UIImage(named: "AddressIcon"), for: .normal)
        lblAreaDetailNm.titleLabel?.fontSize = fontSize
        lblAreaDetailNm.isUserInteractionEnabled = false
        lblAreaDetailNm.contentHorizontalAlignment = .left
        
        //해시태그 추후 추가 예정
        let svHashTag = UIStackView()
        setHashTagList(svHashTag,item["tagList"].stringValue)
        svHashTag.translatesAutoresizingMaskIntoConstraints = false
        let scvHashTag = UIScrollView()
        scvHashTag.addSubview(svHashTag)
        scvHashTag.translatesAutoresizingMaskIntoConstraints = false
        //        scvHashTag.backgroundColor = .systemPink
        scvHashTag.bounces = false
        scvHashTag.addConstraint(NSLayoutConstraint(item: svHashTag, attribute: .centerY, relatedBy: .equal, toItem: scvHashTag, attribute: .centerY, multiplier: 1, constant: 0))
        scvHashTag.showsHorizontalScrollIndicator = false
        svHashTag.topAnchor.constraint(equalTo: scvHashTag.topAnchor, constant: 0).isActive = true
        svHashTag.bottomAnchor.constraint(equalTo: scvHashTag.bottomAnchor, constant: 0).isActive = true
        svHashTag.leadingAnchor.constraint(equalTo: scvHashTag.leadingAnchor, constant: 0).isActive = true
        svHashTag.trailingAnchor.constraint(equalTo: scvHashTag.trailingAnchor, constant: 0).isActive = true
        
        let iconSize: CGFloat = 15
        
        
        let imgFavor = UIImageView(image: UIImage(named: "EmptyHeart"))
        imgFavor.contentMode = .scaleAspectFit
        imgFavor.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        imgFavor.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        let lblStoreFavorCount = UILabel()
        lblStoreFavorCount.text = String(item["storeFavorCount"].intValue)
        lblStoreFavorCount.textColor = .darkGray
        lblStoreFavorCount.textAlignment = .left
        //        lblStoreFavorCount.baselineAdjustment = .alignCenters
        lblStoreFavorCount.fontSize = fontSize
        //        lblStoreFavorCount.widthAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        lblStoreFavorCount.widthAnchor.constraint(equalTo: lblStoreFavorCount.heightAnchor, multiplier: 3).isActive = true
        
        let imgScore = UIImageView(image: UIImage(named: "GPAIcon"))
        imgScore.contentMode = .scaleAspectFit
        imgScore.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        imgScore.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        let lblStoreScore = UILabel()
        lblStoreScore.text = String(item["storeScore"].intValue)
        lblStoreScore.baselineAdjustment = .alignCenters
        lblStoreScore.textColor = .darkGray
        lblStoreScore.fontSize = fontSize
        lblStoreScore.textAlignment = .left
        lblStoreScore.widthAnchor.constraint(equalTo: lblStoreScore.heightAnchor, multiplier: 3).isActive = true
        
        //        let uvMid = UIView()
        //        uvMid.widthAnchor.constraint(lessThanOrEqualToConstant: view.frame.width).isActive = true
        let lblDistance = UILabel()
        lblDistance.text = String(format: "%.1f",  item["distance"].doubleValue) + "KM"
        lblDistance.textColor = .darkGray
        lblDistance.font = UIFont.boldSystemFont(ofSize: 17.0)
        lblDistance.textAlignment = .right
        lblDistance.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        let svBottomInfo = UIStackView(arrangedSubviews: [imgFavor,lblStoreFavorCount,imgScore,lblStoreScore,lblDistance])
        svBottomInfo.spacing = 2
        svBottomInfo.axis = .horizontal
        svBottomInfo.distribution = .fillProportionally
        let svBottom = UIStackView(arrangedSubviews: [lblReprMenuPrice,lblAreaDetailNm,scvHashTag,svBottomInfo])
        //        svBottom.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.56) - 15 ).isActive = true
        //        svBottom.heightAnchor.constraint(equalToConstant: (view.frame.width * 0.22) - 7 ).isActive = true
        svBottom.axis = .vertical
        svBottom.distribution = .fillEqually
        svBottom.spacing = 3
        
        let url = URL(string: getImageURL(item["storeSn"].stringValue, item["storeImageUrlList"].arrayValue.first!.stringValue, tag: "store"))
        let imgStore = UIImageView()
        let data = try? Data(contentsOf: url!)
        if data != nil {
            imgStore.image = UIImage(data: data!)
        } else {
            imgStore.image = UIImage(named: "TempImage")
        }
        //        storeImage.widthAnchor.constraint(equalToConstant: (view.frame.width) * 0.34 ).isActive = true
        imgStore.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imgStore.heightAnchor.constraint(equalToConstant: 120).isActive = true
        //        imgStore.heightAnchor.constraint(equalTo: storeImage.widthAnchor, multiplier: 1, constant: 0).isActive = true
        imgStore.clipsToBounds = true
        imgStore.layer.cornerRadius = 5
        imgStore.contentMode = .scaleAspectFill
        imgStore.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        let svInfo = UIStackView(arrangedSubviews: [svTop,svBottom])
        svInfo.translatesAutoresizingMaskIntoConstraints = false
        svInfo.axis = .vertical
        svInfo.distribution = .fill
        let uvInfo = UIView()
        uvInfo.addSubview(svInfo)
        uvInfo.translatesAutoresizingMaskIntoConstraints = false
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerX, relatedBy: .equal, toItem: uvInfo, attribute:.centerX, multiplier: 1, constant: 0))
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerY, relatedBy: .equal, toItem: uvInfo, attribute: .centerY, multiplier: 1, constant: 0))
        svInfo.heightAnchor.constraint(equalTo: uvInfo.heightAnchor, multiplier: 0.9).isActive = true
        svInfo.widthAnchor.constraint(equalTo: uvInfo.widthAnchor, multiplier: 0.9).isActive = true
        
        let svItem = UIStackView(arrangedSubviews: [imgStore,uvInfo])
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .horizontal
        svItem.distribution = .fill
        
        uvLocation.addSubview(svItem)
        uvLocation.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvLocation, attribute: .centerX, multiplier: 1, constant: 0))
        uvLocation.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvLocation, attribute: .centerY, multiplier: 1, constant: 0))
        svItem.widthAnchor.constraint(equalTo: uvLocation.widthAnchor, multiplier: 1).isActive = true
        svItem.heightAnchor.constraint(equalTo: uvLocation.heightAnchor, multiplier: 1).isActive = true
        
        self.svLocation.addArrangedSubview(uvLocation)
        
        uvLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationInfo)))
    }
    
    @objc func gotoLocationInfo(){
        //        print("debug")
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "locationInfoView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    
    //HashTag
    func setHashTagList(_ svHashTag : UIStackView, _ listHashTag: String) {
        svHashTag.axis = .horizontal
        svHashTag.spacing = 0
        for i in listHashTag.split(separator: " ") {
            makeHashTag(String(i), svHashTag)
        }
    }
    
    func makeHashTag(_ str: String,_ svHashTag: UIStackView){
        let fontSize:CGFloat = 12
        let HashTagBtn = UIButton(type: .custom)
        HashTagBtn.isUserInteractionEnabled = false
        HashTagBtn.setTitle("#"+str+" ", for: .normal)
        HashTagBtn.setTitleColor(.lightGray, for: .normal)
        //        HashTagBtn.backgroundColor = .lightGray
        HashTagBtn.titleLabel?.fontSize = fontSize
        HashTagBtn.contentHorizontalAlignment = .fill
        //        HashTagBtn.layer.cornerRadius = 10
        //        HashTagBtn.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        svHashTag.addArrangedSubview(HashTagBtn)
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

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
    
    
    let lblRange = UILabel()
    
    @IBOutlet var indicLoading: UIActivityIndicatorView!
    @IBOutlet var indicStoreLoading: UIActivityIndicatorView!
    @IBOutlet var lblGuide: UILabel!
    @IBOutlet var btnPlanner: UIButton!
    
    let testNum = 3
    let lightGray = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    let btnhighlightedColor = #colorLiteral(red: 1, green: 0.737254902, blue: 0.9294117647, alpha: 1)
    let backColor = #colorLiteral(red: 0.9937904477, green: 0.9502945542, blue: 0.9648948312, alpha: 1)
    let btnSetFilter = UIButton(type: .custom)
    
    var landmarkSn:String = ""
    var landmarkInfo:JSON = JSON()
    var listStoreData:Array<JSON> = []
    var tempBtn : UIButton?
    var totalCnt = 0
    var currentCnt = 0
    
    var distanceLimit: Float = 1.5
    var priceLimit: Int = 70000
    var sortedBy = "USER_PREF"
    var tmCostLimit:Int = 180
    var clearList = false
    
    var selectedPref = ["","10000000","01000000","00100000","00010000","00001000","00000100","00000010","00000001"]
    var prefInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setKategorie()
        setFilterBtnList()
        setPlanner()
        getLandmarkInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setNavigationBar(){
        indicLoading.center = view.center
        self.navigationItem.title = "완벽한 하루"
        let backItem = UIBarButtonItem()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
        
        btnSetFilter.setTitle("완료", for: .normal)
        btnSetFilter.setTitleColor(.white, for: .normal)
        btnSetFilter.setTitleColor(btnhighlightedColor, for: .highlighted)
        btnSetFilter.backgroundColor = themeColor
        btnSetFilter.contentHorizontalAlignment = .center
        //        btnSetFilter.translatesAutoresizingMaskIntoConstraints = false
        btnSetFilter.layer.cornerRadius = 5
        //        btnSetFilter.widthAnchor.constraint(equalTo: uvFilterView.widthAnchor, multiplier: 0.9).isActive = true
        //        btnSetFilter.heightAnchor.constraint(equalTo: btnSetFilter.widthAnchor, multiplier: 40/295, constant: 0).isActive = true
        btnSetFilter.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnSetFilter.addTarget(self, action: #selector(getStoreListFilter(_:)), for: .touchUpInside)
        
        uvFilterPopupBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideFilter(_:))))
    }
    @objc func hideFilter(_ sender :UITapGestureRecognizer){
        sender.view?.isHidden = true
        uvFilterView.isHidden = true
    }
    
    //###########################
    //           카테고리
    //###########################
    func setKategorie(){
        let btnAll = MaterialVerticalButton(icon: UIImage(named: "CategorieAll")!, text: "전체보기", font: nil ,foregroundColor: .black, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnEat = MaterialVerticalButton(icon: UIImage(named: "CategorieEat")!, text:  "먹기", font: nil ,foregroundColor: .black, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnDrink = MaterialVerticalButton(icon: UIImage(named: "CategorieDrink")!, text:  "마시기", font: nil ,foregroundColor: .black, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnPlay = MaterialVerticalButton(icon: UIImage(named: "CategoriePlay")!, text: "놀기", font: nil ,foregroundColor: .black, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnWatch = MaterialVerticalButton(icon: UIImage(named: "CategorieWatch")!, text: "보기", font: nil ,foregroundColor: .black, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnWalk = MaterialVerticalButton(icon: UIImage(named: "CategorieWalk")!, text: "걷기", font: nil ,foregroundColor: .black, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        
        let btnArray = [btnAll,btnEat,btnDrink,btnPlay,btnWatch,btnWalk]
        uvKategorie.layer.shadowColor = UIColor.lightGray.cgColor
        uvKategorie.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        uvKategorie.layer.shadowRadius = 2.0
        uvKategorie.layer.shadowOpacity = 0.5
        
        for (i, btn) in btnArray.enumerated(){
            btn.accessibilityIdentifier = String(i)
            btn.addTarget(self, action: #selector(setCategoryList(_:)), for: .touchUpInside)
            btn.label.font = btn.label.font.withSize(13)
            svKategorie.addArrangedSubview(btn)
        }
    }
    @objc func setCategoryList(_ sender: MaterialVerticalButton) {
        let categoryIndex = Int(sender.accessibilityIdentifier!)!
        if categoryIndex != prefInt {
            uvLocationList.isHidden = false
            prefInt = categoryIndex
            clearList = true
            uvLocationList.isHidden = true
            indicLoading.startAnimating()
            getStoreList(landmarkInfo)
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
            btn.layer.borderColor = themeColor.cgColor
        }
        scrollViewDidScroll(scvFilter)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        scrollView.bounces = false
        scrollView.bounces = scrollView.contentOffset.y > 0
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        //        print(currentOffset)
        //        print(maximumOffset)
        
        if currentOffset - maximumOffset > 100.0 {
            
            self.loadMore()
        }
    }
    func loadMore() {
        clearList = false
        if currentCnt < totalCnt {
            indicStoreLoading.startAnimating()
            getStoreList(landmarkInfo) //, offset: currentCnt)
        } else {
            lblGuide.isHidden = false
        }
    }
    
    @IBAction func changeForm(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            print("List")
        } else {
            print("Block")
        }
    }
    
    //filter PopUp
    @IBAction func FilterPopup(_ sender: UIButton!) {
        let borderWidth: CGFloat = 2
        setFilterView()
        
        if sender == tempBtn {
            sender.layer.borderWidth = uvFilterPopupBack.isHidden ? borderWidth : 0
            uvFilterPopupBack.isHidden = uvFilterPopupBack.isHidden ? false : true
            uvFilterView.isHidden = uvFilterPopupBack.isHidden
            //            if self.uvFilterPopupBack.isHidden == false {
            //                self.uvFilterPopupBack.isHidden = true
            //            } else {
            //                self.uvFilterPopupBack.isHidden = false
            //            }
        } else {
            self.uvFilterPopupBack.isHidden = false
            self.uvFilterView.isHidden = uvFilterPopupBack.isHidden
            tempBtn?.layer.borderWidth = 0
            sender.layer.borderWidth = borderWidth
            
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
        //        let lblButton = ["선호순","별점순","좋아요순","가까운 순","높은 가격 순","낮은 가격 순","머무는 시간 ↑","머무는 시간 ↓"]
        //        let valueButton = ["USER_PREF","SCORE_DESC","FAVOR_DESC","DISTANCE_ASC","PRICE_DESC","PRICE_ASC","TIME_DESC","TIME_ASC",]
        let lblButton = ["선호순","가까운 순","높은 가격 순","낮은 가격 순","머무는 시간 ↑","머무는 시간 ↓"]
        let valueButton = ["USER_PREF","DISTANCE_ASC","PRICE_DESC","PRICE_ASC","TIME_DESC","TIME_ASC",]
        
        let svFilter = UIStackView()
        for (index,lbl) in lblButton.enumerated() {
            let btnFilter = UIButton(type: .custom)
            btnFilter.setTitle("  " + lbl, for: .normal)
            btnFilter.setTitleColor(.black, for: .normal)
            btnFilter.setTitleColor(.lightGray, for: .highlighted)
            btnFilter.setImage(UIImage(named: "FilterCheck"), for: .normal)
            btnFilter.semanticContentAttribute = .forceLeftToRight
            btnFilter.contentHorizontalAlignment = .left
            btnFilter.titleLabel?.fontSize = 15
            btnFilter.accessibilityLabel =  lblButton[index]
            btnFilter.accessibilityIdentifier = valueButton[index]
            btnFilter.addTarget(self, action: #selector(setSortingFilter(_:)), for: .touchUpInside)
            svFilter.addArrangedSubview(btnFilter)
        }
        
        svFilter.translatesAutoresizingMaskIntoConstraints = false
        svFilter.axis = .vertical
        svFilter.distribution = .fillEqually
        //        svFilter.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        
        uvFilter.addSubview(svFilter)
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerX, relatedBy: .equal, toItem: uvFilter, attribute: .centerX, multiplier: 1, constant: 0))
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerY, relatedBy: .equal, toItem: uvFilter, attribute: .centerY, multiplier: 1, constant: 0))
        svFilter.widthAnchor.constraint(equalTo: uvFilter.widthAnchor, multiplier: 1).isActive = true
        svFilter.heightAnchor.constraint(equalTo: uvFilter.heightAnchor, multiplier: 1).isActive = true
    }
    
    @objc func setSortingFilter(_ sender:UIButton){
        clearList = true
        sortedBy = sender.accessibilityIdentifier!
        preferFilterBtn.setTitle("   " + sender.accessibilityLabel! + "   ", for: .normal)
        uvLocationList.isHidden = true
        indicLoading.startAnimating()
        //        print(sender.accessibilityIdentifier!)
        getStoreList(landmarkInfo)
        uvFilterPopupBack.isHidden = true
    }
    
    func sliderFilters(_ sender: UIButton?){
        let lblTitle = UILabel()
        lblTitle.textColor = .darkText
        lblTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        //        let lblRange = UILabel()
        lblRange.font = UIFont.boldSystemFont(ofSize: 19.0)
        lblRange.textColor = themeColor
        let svLabel = UIStackView(arrangedSubviews: [lblTitle, lblRange])
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
        let lblMinValue = UILabel()
        let lblQuarterValue = UILabel()
        let lblThreeQuarterValue = UILabel()
        let lblMaxValue = UILabel()
        lblMinValue.fontSize = 13
        lblQuarterValue.fontSize = 13
        lblThreeQuarterValue.fontSize = 13
        lblMaxValue.fontSize = 13
        lblMinValue.textColor = .darkText
        lblQuarterValue.textColor = .darkText
        lblThreeQuarterValue.textColor = .darkText
        lblMaxValue.textColor = .darkText
        lblQuarterValue.textAlignment = .center
        lblThreeQuarterValue.textAlignment = .center
        lblMaxValue.textAlignment = .right
        //        let lblTemp1 = UILabel()
        //        let lblTemp2 = UILabel()
        //        let lblTemp3 = UILabel()
        //        let tempwidth = (view.frame.width - (lblMinValue.frame.width + lblQuarterValue.frame.width + lblThreeQuarterValue.frame.width + lblMaxValue.frame.width))/3
        //        lblTemp1.sizeThatFits(CGSize(width: tempwidth , height: lblMinValue.frame.height))
        //        lblTemp2.sizeThatFits(CGSize(width: tempwidth , height: lblMinValue.frame.height))
        //        lblTemp3.sizeThatFits(CGSize(width: tempwidth , height: lblMinValue.frame.height))
        
        let svRange = UIStackView(arrangedSubviews: [lblMinValue,lblQuarterValue,lblThreeQuarterValue,lblMaxValue])
        svRange.axis = .horizontal
        svRange.distribution = .fillEqually
        
        if sender == distanceFilterBtn {
            lblTitle.text = "거리"
            lblRange.text = "3km+"
            slider.minimumValue = 0
            slider.maximumValue = 30
            slider.addTarget(self, action: #selector(setSliderValue(_:)), for: .valueChanged)
            slider.accessibilityLabel = "distance"
            lblMinValue.text = "0m"
            lblQuarterValue.text = "1km"
            lblThreeQuarterValue.text = "2km"
            lblMaxValue.text = "3km+"
            //            let lblValue = (Int(slider.value) % 10 == 0 ? String(Int(slider.value/10)) : String(slider.value/10))
            //            let lblUnit = (slider.value == slider.maximumValue ? "km+" : "km")
            //            lblRange.text = lblValue + lblUnit
            btnSetFilter.accessibilityIdentifier = "거리 전체"
        }
        else if sender == priceFilterBtn {
            lblTitle.text = "대표메뉴 가격"
            lblRange.text = "7만원+"
            slider.minimumValue = 0
            slider.maximumValue = 70
            slider.addTarget(self, action: #selector(setSliderValue(_:)), for: .valueChanged)
            slider.accessibilityLabel = "price"
            lblMinValue.text = "0원"
            lblQuarterValue.text = "2만원"
            lblThreeQuarterValue.text = "4만원"
            lblMaxValue.text = "7만원+"
            //            let lblValue = (Int(slider.value) % 10 == 0 ? String(Int(slider.value/10)) : String(slider.value/10))
            //            let lblUnit = (slider.value == slider.maximumValue ? "만원+" : "만원")
            //            lblRange.text = lblValue + lblUnit
            btnSetFilter.accessibilityIdentifier = "가격 전체"
        }
        else if sender == timeFilterBtn {
            lblTitle.text = "예상 소요시간"
            lblRange.text = "3시간+"
            slider.minimumValue = 0
            slider.maximumValue = 18
            slider.addTarget(self, action: #selector(setSliderValue(_:)), for: .valueChanged)
            slider.accessibilityLabel = "time"
            lblMinValue.text = "0시간"
            lblQuarterValue.text = "1시간"
            lblThreeQuarterValue.text = "2시간"
            lblMaxValue.text = "3시간+"
            //            let lblValue = slider.value == 0 ? "0시간" : RegexTime(Int(slider.value * 10))
            //            let lblUnit = (slider.value == slider.maximumValue ? "+" : "")
            //            lblRange.text = lblValue + lblUnit
            btnSetFilter.accessibilityIdentifier = "시간 전체"
        }
        slider.setValue(slider.maximumValue, animated: false)
        
        let svFilter = UIStackView(arrangedSubviews: [svLabel,slider,svRange,btnSetFilter])
        svFilter.translatesAutoresizingMaskIntoConstraints = false
        svFilter.axis = .vertical
        svFilter.distribution = .equalSpacing
        //        svFilter.widthAnchor.constraint(equalTo: uvFilter.widthAnchor, multiplier: 0.9).isActive = true
        //        svFilter.heightAnchor.constraint(equalTo: svFilter.widthAnchor, multiplier: 170/295).isActive = true
        
        uvFilter.addSubview(svFilter)
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerX, relatedBy: .equal, toItem: uvFilter, attribute: .centerX, multiplier: 1, constant: 0))
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerY, relatedBy: .equal, toItem: uvFilter, attribute: .centerY, multiplier: 1, constant: 0))
        uvFilter.widthAnchor.constraint(equalTo: svFilter.widthAnchor, multiplier: 1).isActive = true
        uvFilter.heightAnchor.constraint(equalTo: svFilter.heightAnchor, multiplier: 1).isActive = true
    }
    @objc func setSliderValue(_ sender: UISlider){
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        var lblValue = ""
        var lblUnit = ""
        btnSetFilter.accessibilityLabel = sender.accessibilityLabel!
        
        switch sender.accessibilityLabel! {
        case "distance":
            lblValue = (Int(sender.value) % 10 == 0 ? String(Int(sender.value/10)) : String(sender.value/10))
            lblUnit = (sender.value == sender.maximumValue ? "km+" : "km")
            distanceLimit = sender.value / 10
        case "price":
            lblValue = (Int(sender.value) % 10 == 0 ? String(Int(sender.value/10)) : String(sender.value/10))
            lblUnit = (sender.value == sender.maximumValue ? "만원+" : "만원")
            priceLimit = Int(sender.value * 1000)
        case "time":
            lblValue = sender.value == 0 ? "0시간" : RegexTime(Int(sender.value * 10))
            lblUnit = (sender.value == sender.maximumValue ? "+" : "")
            tmCostLimit = Int(sender.value * 10)
        default:
            break
        }
        //        (((sender.superview as! UIStackView).arrangedSubviews.first as! UIStackView).arrangedSubviews.last as! UILabel).text = lblValue + lblUnit
        lblRange.text = lblValue + lblUnit
    }
    @objc func getStoreListFilter(_ sender:UIButton){
        clearList = true
        //        print(landmarkInfo)
        setFilterLabel(sender)
        indicLoading.startAnimating()
        uvLocationList.isHidden = true
        uvFilterPopupBack.isHidden = true
        getStoreList(landmarkInfo)
    }
    func setFilterLabel(_ btn: UIButton){
        let accessibilityIdentifier = btn.accessibilityIdentifier!
        var lblString = lblRange.text?.last == "+" ? accessibilityIdentifier : (lblRange.text! + " 이내")
        lblString = "   " + lblString + "   "
        
        switch accessibilityIdentifier {
        case "거리 전체":
            distanceFilterBtn.setTitle(lblString, for: .normal)
        case "가격 전체":
            priceFilterBtn.setTitle(lblString, for: .normal)
        case "시간 전체":
            timeFilterBtn.setTitle(lblString, for: .normal)
        default:
            break
        }
    }
    
    //###########################
    //         플래너 버튼
    //###########################
    func setPlanner(){
        let imageSize:CGFloat = 15
        let lblLoationIndex = UILabel()
        lblLoationIndex.translatesAutoresizingMaskIntoConstraints = false
        let plannerNum = UserDefaults.standard.value(forKey: plannerNumKey) as! Int
        lblLoationIndex.text = String(plannerNum)
        lblLoationIndex.textColor = .white
        lblLoationIndex.textAlignment = .center
        //        lblLoationIndex.fontSize = 10
        lblLoationIndex.font = UIFont.boldSystemFont(ofSize: 10)
        lblLoationIndex.backgroundColor = .systemBlue
        lblLoationIndex.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        lblLoationIndex.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        lblLoationIndex.layer.masksToBounds = true
        lblLoationIndex.layer.cornerRadius = imageSize * (1/3)
        if plannerNum > 0 {
            btnPlanner.addSubview(lblLoationIndex)
            lblLoationIndex.centerXAnchor.constraint(equalTo: btnPlanner.leadingAnchor, constant: imageSize*0.5).isActive = true
            lblLoationIndex.centerYAnchor.constraint(equalTo: btnPlanner.topAnchor, constant:  imageSize*0.5).isActive = true
        }
    }
    @IBAction func gotoPlanner(_ sender: UIButton) {
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "plannerView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
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
                self.landmarkInfo = JSON(response.value!)
                //                print("***")
                //                print(landmarkInfo)
                self.setStackView()
                self.getStoreList(self.landmarkInfo)
            }
        }
    }
    func getStoreList(_ landmarkInfo:JSON){//},distanceLimit:Float = 1.5,priceLimit:Int = 70000,sortedBy:String = "USER_PREF",tmCostLimit:Int = 180,offset:Int = 0){
        
        if self.clearList {
            self.svLocation.removeSubviews()
            self.currentCnt = 0
        }
        
        let url = OperationIP + "/store/selectStoreInfoList.do"
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        var parameter = JSON([])
        if prefInt == 0 {
            parameter = JSON([
                "latitude": landmarkInfo["latitude"].doubleValue,
                "longitude": landmarkInfo["longitude"].doubleValue,
                "distanceLimit": self.distanceLimit,
                "limit": 20,
                "offset": self.currentCnt,
                "priceLimit": self.priceLimit,
                "searchKeyWord": "",
                "sortedBy": self.sortedBy,
                "tmCostLimit": self.tmCostLimit
            ])
        } else if prefInt <= 8 {
            parameter = JSON([
                "latitude": landmarkInfo["latitude"].doubleValue,
                "longitude": landmarkInfo["longitude"].doubleValue,
                "distanceLimit": self.distanceLimit,
                "limit": 20,
                "offset": self.currentCnt,
                "priceLimit": self.priceLimit,
                "searchKeyWord": "",
                "sortedBy": self.sortedBy,
                "tmCostLimit": self.tmCostLimit,
                "selectedPrefs": selectedPref[prefInt]
            ])
        }
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        //        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            print("##########")
            debugPrint(response.response?.statusCode)
            if response.response?.statusCode == 200{
                if response.value != nil {
                    let responseJSON = JSON(response.value!)
                    //                print("^^^")
                    //                print(responseJSON)
                    //                    print(responseJSON)
                    self.currentCnt += responseJSON.arrayValue.count
                    //                self.setLocationList(responseJSON.arrayValue)
                    if responseJSON == [] {
                        print("//작업")
                    } else {
                        self.setLocationList(responseJSON.arrayValue)
                    }
                }
            }
        }
    }
    
    func setLocationList(_ listStore:[JSON]){
        setLocationListBackView()
        //        print(listStore)
        totalCnt = listStore.first!["totalCnt"].intValue
        for i in listStore {
            makeItem(i)
        }
        indicLoading.stopAnimating()
        uvLocationList.isHidden = false
        indicStoreLoading.stopAnimating()
        
        self.scrollMain.delegate = self
        //        scrollMain.showsVerticalScrollIndicator = true
    }
    //    func scroll
    
    func setStackView(){
        svLocation.axis = .vertical
        svLocation.spacing = 10
        svLocation.removeSubviews()
        let uvTop = UIView()
        uvTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        svLocation.addArrangedSubview(uvTop)
        uvTop.isHidden = true
        
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
        //        lblStoreType.text = "장소유형"
        lblStoreType.fontSize = fontSize
        lblStoreType.textColor = .systemBlue
        let lblStoreNm = UILabel()
        lblStoreNm.textColor = .darkText
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
        btnAddPlanner.accessibilityValue = item["storeSn"].string!
        btnAddPlanner.accessibilityIdentifier =  item.rawString()
        btnAddPlanner.addTarget(self, action: #selector(sendLocToPlanner(_:)), for: .touchUpInside)
        let svTop = UIStackView(arrangedSubviews: [svUpperLeft,btnAddPlanner])
        svTop.axis = .horizontal
        svTop.distribution = .fillProportionally
        //        svTop.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.56) - 15 ).isActive = true
        //        svTop.heightAnchor.constraint(equalToConstant: (view.frame.width * 0.12) - 7 ).isActive = true
        
        let lblReprMenuPrice = UILabel()
        if item["reprMenuPrice"].intValue == 0 {
            lblReprMenuPrice.text = "대표메뉴 무료"
        } else {
            lblReprMenuPrice.text = "대표메뉴 " + DecimalWon(item["reprMenuPrice"].intValue)
        }
        
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
        
        let imgStore = UIImageView(image: UIImage(named: "TempImage"))
        if !item["storeImageUrlList"].arrayValue.isEmpty {
            let url = URL(string: getImageURL(item["storeSn"].stringValue, item["storeImageUrlList"].arrayValue.first!.stringValue, tag: "store"))
            let data = try? Data(contentsOf: url!)
            if data != nil {
                imgStore.image = UIImage(data: data!)
            }
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
        uvLocation.accessibilityIdentifier = item["storeSn"].stringValue
        uvLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationInfo(_:))))
    }
    
    @objc func gotoLocationInfo(_ sender: UITapGestureRecognizer){
        let locationSn = sender.view!.accessibilityIdentifier
        getLocationInfo(locationSn!)
    }
    func getLocationInfo(_ locationSn : String) {
        let url = OperationIP + "/store/selectStoreInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        let parameter = JSON([
            "storeSn": locationSn,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                let responseJSON = JSON(response.value!)
                //                print(responseJSON)
                locationData = responseJSON
                let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "locationInfoView")
                self.navigationController?.pushViewController(goToVC!, animated: true)
            }
        }
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
        let HashTagBtn = UIButton(type: .system)
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
    
    @objc func sendLocToPlanner(_ sender: UIButton) {
        let str = sender.accessibilityIdentifier!
        let storeSn = sender.accessibilityValue!
        let num =  UserDefaults.standard.value(forKey: plannerNumKey) as! Int
        var flag = true
        if num != 0 {
            var storeSnList = UserDefaults.standard.value(forKey: "StoreSnList") as! Array<String>
            for i in 0...num - 1 {
                if storeSn == storeSnList[i] {
                    flag = false
                }
            }
            if flag {
                UserDefaults.standard.set(num+1, forKey: plannerNumKey)
                UserDefaults.standard.set(str, forKey: "PlannerKey" + String(num))
                storeSnList.append(storeSn)
                UserDefaults.standard.set(storeSnList, forKey: "StoreSnList")
            }
        }
        else {
            UserDefaults.standard.set(num+1, forKey: plannerNumKey)
            UserDefaults.standard.set(str, forKey: "PlannerKey" + String(num))
            var storeSnList : Array<String> = []
            storeSnList.append(storeSn)
            UserDefaults.standard.set(storeSnList, forKey: "StoreSnList")
        }
        setPlanner()
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

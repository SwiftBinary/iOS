//
//  SearchLocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/11.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
import Material

// UIPickerViewDelegate, UIPickerViewDataSource,
class SearchLocationViewController: UIViewController,UIGestureRecognizerDelegate, IndicatorInfoProvider, LocationDelegate {
    
    var optionList = ["높은 가격순","낮은 가격순","긴 소요시간순","짧은 소요시간순","높은 평점순","가까운 거리순"]
    var checkPv = true // true didSelectRow 호출됨, false didSelectRow 호출 안 됨
    var pickerView = UIPickerView()
    var typeValue = String()
    
    let userData = getUserData()
    
    let scrollMain = UIScrollView()
    let uvMain = UIView()
    let svMain = UIStackView()
    let btnScrollUp = UIButton(type: .custom)
    let lblLocationDistance = UILabel()
    let lblLocationCount = UILabel()
    var label = ""
    var searchData = JSON()
//    let indicLoading = UIActivityIndicatorView(style: .whiteLarge)
    
    func didLocationDone(_ controller: SetLocationViewController, currentLocation: String) {
        ((view.subviews[0] as! UIStackView).arrangedSubviews[1] as! UILabel).text = currentLocation
    }
    
    var itemInfo: IndicatorInfo = "View"
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTopUI()
        setScrollUI()
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if LocationInfo.locationString.str == "" {
            label = "위치 정보 없음"
        } else {
            label = " " + LocationInfo.locationString.str
        }
        // 뷰의 서브뷰[0] -> 세로 스택[0] -> 가로 스택[0] -> 위치 표시 라벨
        ((view.subviews.first as! UIStackView).arrangedSubviews[1] as! UILabel).text = label
        view.endEditing(true)
        // 뷰의 서브뷰[0] -> 세로 스택[1] -> 가로 스택[0] -> 장소 개수 라벨
        //(((view.subviews[0] as! UIStackView).arrangedSubviews[1] as! UIStackView).arrangedSubviews[0] as! UILabel).text = {"곳"}
    }
    func setTopUI(){
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        // UI 구조
        // 세로 스택뷰[ 가로 스택 뷰1{선택한 위치 라벨, 위치 설정 버튼} , 가로 스택 뷰2{결과 장소 수 라벨, 필터 버튼, 정렬조건 버튼} ]
        let svHorizontal = UIStackView()
        let btnSetLocation = UIButton(type: .custom)
        let lblLocation = UILabel()
//        let lblLocationDistance = UILabel()
//        let lblLocationCount = UILabel()
        let lblEnd = UILabel()
        let btnFilter = UIButton(type: .custom)
        
        //Label Setting
        lblLocation.textColor = .darkText
        lblLocation.text = " 위치 정보 없음"
        lblLocation.textAlignment = .left
        lblLocationDistance.textColor = .darkText
        lblLocationDistance.text = "3.0km 이내 "
        lblLocationDistance.textAlignment = .right
        lblLocationCount.text = "n"
        lblLocationCount.textColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.568627451, alpha: 1)
        lblEnd.textColor = .darkText
        lblEnd.text = "곳"
        
        //Button Setting
        btnSetLocation.setTitle("", for: .normal)
        btnSetLocation.setImage(UIImage(named: "setLocationBtn"), for: .normal)
        btnSetLocation.addTarget(self, action: #selector(gotoSetLocation), for: .touchUpInside)
        btnSetLocation.imageView?.contentMode = .scaleAspectFit
        
        btnFilter.setTitle("", for: .normal)
        btnFilter.setImage(UIImage(named: "FilterBtn"), for: .normal)
        btnFilter.addTarget(self, action: #selector(filterLocation), for: .touchUpInside)
        
        //Stack Setting
        svHorizontal.addArrangedSubview(btnSetLocation)
        svHorizontal.addArrangedSubview(lblLocation)
        svHorizontal.addArrangedSubview(lblLocationDistance)
        svHorizontal.addArrangedSubview(lblLocationCount)
        svHorizontal.addArrangedSubview(lblEnd)
        svHorizontal.addArrangedSubview(btnFilter)
        
        btnSetLocation.widthAnchor.constraint(equalTo: svHorizontal.heightAnchor, multiplier: 1).isActive = true
        btnFilter.widthAnchor.constraint(equalTo: svHorizontal.heightAnchor, multiplier: 1).isActive = true
        
        svHorizontal.translatesAutoresizingMaskIntoConstraints = false
        
        svHorizontal.distribution = .fill
        view.addSubview(svHorizontal)
        view.addConstraint(NSLayoutConstraint(item: svHorizontal, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        svHorizontal.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        svHorizontal.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        
    }
    
    // 위치 설정 이벤트
    @objc func gotoSetLocation(sender: UIButton){
        let goToVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "searchSetLocationView")
        let navigationController = UINavigationController(rootViewController: goToVC)
        self.present(navigationController, animated: true, completion: nil)
    }
    @objc func filterLocation(sender: UIButton){
        
//        let goToVC = UIStoryboard.init(name: "Search", bundle: Bundle.main).instantiateViewController(withIdentifier: "locationFilterView")
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let rvc = storyboard.instantiateViewController(withIdentifier: "locationFilterView") as? FilterLocationViewController else {
            //아니면 종료
            return
        }
        
        let searchView = self.parent?.parent as! SearchViewController
        rvc.priceValue = searchView.priceValue
        rvc.timeValue = searchView.timeValue
        rvc.distanceValue = searchView.distanceValue
        rvc.selectedIndex = rvc.listFilterValue.firstIndex(of: searchView.selectedValue)!
        self.present(rvc, animated: true, completion: nil)
//        self.present(goToVC, animated: true, completion: nil)
    }
    
    func setScrollUI(){
        scrollMain.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollMain)
        view.addConstraint(NSLayoutConstraint(item: scrollMain, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.widthAnchor.constraint(equalTo: scrollMain.widthAnchor, multiplier: 1).isActive = true
        scrollMain.topAnchor.constraint(equalTo: view.subviews[0].bottomAnchor, constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: scrollMain.bottomAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollMain.trailingAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: scrollMain.leadingAnchor, constant: 0).isActive = true
        
        
        uvMain.translatesAutoresizingMaskIntoConstraints = false
        uvMain.layer.cornerRadius = 15
        uvMain.backgroundColor = .white
        uvMain.isHidden = true
        
        scrollMain.addSubview(uvMain)
        scrollMain.addConstraint(NSLayoutConstraint(item: uvMain, attribute: .centerX, relatedBy: .equal, toItem: scrollMain, attribute: .centerX, multiplier: 1, constant: 0))
        uvMain.widthAnchor.constraint(equalTo: scrollMain.widthAnchor, multiplier: 1).isActive = true
        uvMain.topAnchor.constraint(equalTo: scrollMain.topAnchor, constant: 0).isActive = true
        uvMain.bottomAnchor.constraint(equalTo: scrollMain.bottomAnchor, constant: 0).isActive = true
        
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.distribution = .fill
        svMain.axis = .vertical
        svMain.spacing = 15
        
        uvMain.addSubview(svMain)
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: uvMain, attribute: .centerX, multiplier: 1, constant: 0))
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: uvMain, attribute: .centerY, multiplier: 1, constant: 0))
        svMain.widthAnchor.constraint(equalTo: uvMain.widthAnchor, multiplier: 0.9).isActive = true
        svMain.heightAnchor.constraint(equalTo: uvMain.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setLocatoinData(){
        svMain.removeSubviews()
        let dataNum = searchData.arrayValue.count
        if dataNum > 0  {
            uvMain.isHidden = false
            let topView = UIView()
            topView.backgroundColor = .none
            topView.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
            let bottomView = UIView()
            
                bottomView.backgroundColor = .none
                bottomView.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
            
            
            svMain.addArrangedSubview(topView)
            for index in 0..<(dataNum/2) {
                addLocationItem(data: searchData.arrayValue[index*2], data2: searchData.arrayValue[(index*2)+1],isLast:true)
            }
            (dataNum%2 == 1) ? addLocationItem(data: searchData.arrayValue.last!, data2: JSON(),isLast:false) : nil
            svMain.addArrangedSubview(bottomView)
        } else {
            uvMain.isHidden = true
        }
        lblLocationCount.text = String(dataNum)
        
        let searchView = self.parent?.parent as! SearchViewController
        searchView.indicLoading.stopAnimating()
    }
    
    func addLocationItem(data: JSON, data2: JSON,isLast:Bool){
        let svTwoItem = UIStackView()
        svTwoItem.axis = .horizontal
        svTwoItem.spacing = 15
        svTwoItem.addArrangedSubview(makeItem(data))
        isLast ? svTwoItem.addArrangedSubview(makeItem(data2)) : svTwoItem.addArrangedSubview(makeTempItem())
        svTwoItem.distribution = .fillEqually
        
        svMain.addArrangedSubview(svTwoItem)
    }
    
    func makeItem(_ jsonData: JSON) -> UIView {
        //let btnItem = UIButton(type: .custom)
        // 가져온 장소의 고유번호를 uvLocation의 Tag로 사용할 것
        let uvLocation = UIView()
        uvLocation.translatesAutoresizingMaskIntoConstraints = false
        uvLocation.layer.cornerRadius = 5
        uvLocation.layer.borderWidth = 0.5
        uvLocation.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        uvLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationInfo(_:))))
        uvLocation.accessibilityIdentifier = jsonData["storeSn"].stringValue
        
        // 나중에 얘기는 클래스 단위로 따로 설계할 필요가 있음
        let url = URL(string: getImageURL(jsonData["storeSn"].stringValue, jsonData["storeImageUrlList"].arrayValue.first!.stringValue, tag: "store"))
        let imgItem = UIImageView()
        let data = try? Data(contentsOf: url!)
        if data != nil {
            imgItem.image = UIImage(data: data!)
        } else {
            imgItem.image = UIImage(named: "TempImage")
        }
        //        imgItem.widthAnchor.constraint(equalToConstant: 160).isActive = true
        imgItem.heightAnchor.constraint(equalToConstant: 130).isActive = true
        imgItem.contentMode = .scaleAspectFill
        imgItem.clipsToBounds = true
        imgItem.layer.cornerRadius = 5
        imgItem.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let lblvar = UILabel()
        setPref(lblvar,jsonData["prefSn"].stringValue,jsonData["prefData"].stringValue)
        lblvar.fontSize = 11
        lblvar.textColor = .systemBlue
        let lblName = UILabel()
        lblName.textColor = .darkText
        lblName.text = jsonData["storeNm"].stringValue
        lblName.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        let lblPrice = UILabel()
        if jsonData["reprMenuPrice"].intValue == 0 {
            lblPrice.text = "대표메뉴 무료"
        } else {
            lblPrice.text = "대표메뉴 " + DecimalWon(jsonData["reprMenuPrice"].intValue)
        }
        lblPrice.fontSize = 11
        lblPrice.textColor = .darkGray
        let lblLocation = UIButton(type: .custom)
        let locArr = jsonData["storeAddr"].stringValue.components(separatedBy: " ")
        lblLocation.setTitle(locArr[1] + " " + locArr[2], for: .normal)
        lblLocation.titleLabel?.numberOfLines = 1
        lblLocation.setTitleColor(.darkGray, for: .normal)
        lblLocation.setImage(UIImage(named: "AddressIcon"), for: .normal)
        lblLocation.titleLabel?.fontSize = 11
        lblLocation.isUserInteractionEnabled = false
        lblLocation.contentHorizontalAlignment = .left
        let svLabel = UIStackView(arrangedSubviews: [lblPrice, lblLocation])
        svLabel.axis = .vertical
        
        let imgDids = UIImageView(image: UIImage(named: "EmptyHeart"))
        let imgGPA = UIImageView(image: UIImage(named: "GPAIcon"))
        let svIcon = UIStackView(arrangedSubviews: [imgDids,imgGPA])
        svIcon.axis = .vertical
        svIcon.distribution = .fillEqually
        
        let lblDidsCount = UILabel()
        lblDidsCount.text = String(jsonData["storeFavorCount"].intValue)
        lblDidsCount.textColor = .darkGray
        lblDidsCount.fontSize = 13
        lblDidsCount.textAlignment = .right
        let lblGPA = UILabel()
        lblGPA.text = String(Double(jsonData["storeScore"].intValue))
        lblGPA.textColor = .darkGray
        lblGPA.fontSize = 13
        lblGPA.textAlignment = .right
        let svCount = UIStackView(arrangedSubviews: [lblDidsCount,lblGPA])
        svCount.axis = .vertical
        svCount.distribution = .fillEqually
        
        let svSubInfo = UIStackView(arrangedSubviews: [svLabel,svIcon,svCount])
        svSubInfo.axis = .horizontal
        svSubInfo.distribution = .fillProportionally
        svSubInfo.spacing = 5
        
        let svItemInfo = UIStackView(arrangedSubviews: [lblvar,lblName,svSubInfo])
        svItemInfo.translatesAutoresizingMaskIntoConstraints = false
        svItemInfo.axis = .vertical
        let uvItemInfo = UIView()
        uvItemInfo.addSubview(svItemInfo)
        uvItemInfo.addConstraint(NSLayoutConstraint(item: svItemInfo, attribute: .centerX, relatedBy: .equal, toItem: uvItemInfo, attribute: .centerX, multiplier: 1, constant: 0))
        uvItemInfo.addConstraint(NSLayoutConstraint(item: svItemInfo, attribute: .centerY, relatedBy: .equal, toItem: uvItemInfo, attribute: .centerY, multiplier: 1, constant: 0))
        svItemInfo.widthAnchor.constraint(equalTo: uvItemInfo.widthAnchor, multiplier: 0.9).isActive = true
        svItemInfo.heightAnchor.constraint(equalTo: uvItemInfo.heightAnchor, multiplier: 0.9).isActive = true
        
        let svItem = UIStackView(arrangedSubviews: [imgItem,uvItemInfo])
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .vertical
        svItem.distribution = .fill
        
        uvLocation.addSubview(svItem)
        uvLocation.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvLocation, attribute: .centerX, multiplier: 1, constant: 0))
        uvLocation.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvLocation, attribute: .centerY, multiplier: 1, constant: 0))
        svItem.widthAnchor.constraint(equalTo: uvLocation.widthAnchor, multiplier: 1).isActive = true
        svItem.heightAnchor.constraint(equalTo: uvLocation.heightAnchor, multiplier: 1).isActive = true
        
        return uvLocation
    }
    func makeTempItem() -> UIView {
            let uvLocation = UIView()
            uvLocation.translatesAutoresizingMaskIntoConstraints = false
            
    //        uvLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tempFunc)))
            
            let imgItem = UIImageView()
    //        imgItem.heightAnchor.constraint(equalToConstant: view.frame.width * 0.345).isActive = true
    //        imgItem.widthAnchor.constraint(equalToConstant: view.frame.width * 0.425).isActive = true
            imgItem.contentMode = .scaleAspectFill
            imgItem.clipsToBounds = true
            imgItem.layer.cornerRadius = 5
            imgItem.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            let lblvar = UILabel()
            lblvar.text = " "
            lblvar.fontSize = 11
            lblvar.textColor = .systemBlue
            let lblName = UILabel()
            lblName.text = " "
            lblName.font = UIFont.boldSystemFont(ofSize: 17.0)
            let lblPrice = UILabel()
            lblPrice.text = " "
            lblPrice.fontSize = 11
            lblPrice.textColor = .darkGray
            let lblLocation = UIButton(type: .custom)
            lblLocation.setTitle(" ", for: .normal)
            lblLocation.titleLabel?.numberOfLines = 1
            lblLocation.setTitleColor(.darkGray, for: .normal)
            lblLocation.titleLabel?.fontSize = 11
            lblLocation.isUserInteractionEnabled = false
            lblLocation.contentHorizontalAlignment = .left
            let svLabel = UIStackView(arrangedSubviews: [lblPrice, lblLocation])
            svLabel.axis = .vertical
            svLabel.distribution = .fillEqually
            
            let svSubInfo = UIStackView(arrangedSubviews: [svLabel])
            svSubInfo.axis = .horizontal
            svSubInfo.distribution = .fillProportionally
            
            let svItemInfo = UIStackView(arrangedSubviews: [lblvar,lblName,svSubInfo])
            svItemInfo.translatesAutoresizingMaskIntoConstraints = false
            svItemInfo.axis = .vertical
            svItemInfo.distribution = .fillProportionally
            let uvItemInfo = UIView()
            uvItemInfo.addSubview(svItemInfo)
    //        uvItemInfo.widthAnchor.constraint(equalToConstant: view.frame.width * 0.425).isActive = true
    //        uvItemInfo.heightAnchor.constraint(equalToConstant: view.frame.width * 0.185).isActive = true
            uvItemInfo.addConstraint(NSLayoutConstraint(item: svItemInfo, attribute: .centerX, relatedBy: .equal, toItem: uvItemInfo, attribute: .centerX, multiplier: 1, constant: 0))
            uvItemInfo.addConstraint(NSLayoutConstraint(item: svItemInfo, attribute: .centerY, relatedBy: .equal, toItem: uvItemInfo, attribute: .centerY, multiplier: 1, constant: 0))
            svItemInfo.widthAnchor.constraint(equalTo: uvItemInfo.widthAnchor, multiplier: 0.9).isActive = true
            svItemInfo.heightAnchor.constraint(equalTo: uvItemInfo.heightAnchor, multiplier: 0.9).isActive = true
            
            let svItem = UIStackView(arrangedSubviews: [imgItem,uvItemInfo])
            svItem.translatesAutoresizingMaskIntoConstraints = false
            svItem.axis = .vertical
            svItem.distribution = .fill
            uvLocation.addSubview(svItem)
    //        uvLocation.widthAnchor.constraint(equalToConstant: view.frame.width * 0.425).isActive = true
    //        uvLocation.heightAnchor.constraint(equalToConstant: view.frame.width * 0.530).isActive = true
            uvLocation.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvLocation, attribute: .centerX, multiplier: 1, constant: 0))
            uvLocation.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvLocation, attribute: .centerY, multiplier: 1, constant: 0))
            svItem.widthAnchor.constraint(equalTo: uvLocation.widthAnchor, multiplier: 1).isActive = true
            svItem.heightAnchor.constraint(equalTo: uvLocation.heightAnchor, multiplier: 1).isActive = true
            
            return uvLocation
        }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    
    @objc func panAction(_ sender : UIPanGestureRecognizer){
        btnScrollUp.isHidden = (scrollMain.contentOffset.y <= 0)
    }
    
    @objc func upToTop(_ sender: Any) {
        scrollMain.scrollToTop()
        btnScrollUp.isHidden = true
    }
    
    func setUI(){
        btnScrollUp.isHidden = true
        btnScrollUp.setTitle("", for: .normal)
        btnScrollUp.translatesAutoresizingMaskIntoConstraints = false
        btnScrollUp.addTarget(self, action: #selector(upToTop(_:)), for: .touchUpInside)
        btnScrollUp.setImage(UIImage(named: "arrow_up"), for: .normal)
        view.addSubview(btnScrollUp)
        
        view.addConstraint(NSLayoutConstraint(item: btnScrollUp, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        btnScrollUp.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnScrollUp.widthAnchor.constraint(equalToConstant: 40).isActive = true
        btnScrollUp.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        
        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        panGestureRecongnizer.delegate = self
        scrollMain.addGestureRecognizer(panGestureRecongnizer)
    }
    
    @objc func gotoLocationInfo(_ sender: UITapGestureRecognizer){
        let locationSn = sender.view!.accessibilityIdentifier
        getLocationInfo(locationSn!)
    }
    func getLocationInfo(_ locationSn : String) {
        let url = OperationIP + "/store/selectStoreInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        let parameter = JSON([
            "storeSn": locationSn,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                let reponseJSON = JSON(response.value!)
                print(reponseJSON)
                locationData = reponseJSON
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let goToVC = storyboard.instantiateViewController(withIdentifier: "locationInfoView")
                self.navigationController?.pushViewController(goToVC, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationViewController = segue.destination as! SetLocationViewController
        locationViewController.delegate = self
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

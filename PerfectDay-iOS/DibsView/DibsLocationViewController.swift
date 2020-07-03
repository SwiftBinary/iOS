//
//  DibsLocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Material
import XLPagerTabStrip

class DibsLocationViewController: UIViewController, IndicatorInfoProvider {
    
    let btnCreateCourse = UIButton(type: .custom)
    let scrollMain = UIScrollView()
    let testNum = 10
    let lightGray = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    let btnStartCreateCourse = UIButton(type: .custom)
    let svMain = UIStackView()
    let svEmptyGuide = UIStackView()
    let userData = getUserData()
    
    var createONOFF = false
    var itemInfo: IndicatorInfo = "View"
    var sequence : Int = 0
    var temp = 0
    var responseJSON:JSON = []
    var selectedStoresn : Array<String> = ["","","","",""]
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setEmptyGuideUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        requestPost()
    }
    
    func setNavigationBar(){
        let backItem = UIBarButtonItem()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
    }
    
    func requestPost(){
        svMain.removeSubviews()
        let url = OperationIP + "/pick/selectPickInfoList.do"
        let parameter = JSON([
            "bReverse": true
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.responseJSON = JSON(response.value!)
                //                print("##")
                //                print(self.responseJSON)
                //                print("##")
                self.svEmptyGuide.isHidden = !self.responseJSON.arrayValue.isEmpty
                self.btnStartCreateCourse.isHidden = self.responseJSON.arrayValue.isEmpty
                self.btnCreateCourse.isHidden = self.responseJSON.arrayValue.isEmpty
                if !self.responseJSON.arrayValue.isEmpty { self.setUI(self.responseJSON) }
            }
        }
    }
    
    func setEmptyGuideUI() {
        let imageView = UIImageView(image: UIImage(named: "EmptyDataGuide"))
        imageView.contentMode = .scaleAspectFit
        let lblFirst: UILabel = {
            let label = UILabel()
            label.text = "찜 목록이 비었습니다."
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let lblSecond: UILabel = {
            let label = UILabel()
            label.text = "장소를 찜해주세요."
            label.textAlignment = .center
            label.fontSize = 15
            label.textColor = .darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        svEmptyGuide.addArrangedSubview(imageView)
        svEmptyGuide.addArrangedSubview(lblFirst)
        svEmptyGuide.addArrangedSubview(lblSecond)
        svEmptyGuide.axis = .vertical
        svEmptyGuide.isHidden = true
        view.addSubview(svEmptyGuide)
        svEmptyGuide.translatesAutoresizingMaskIntoConstraints = false
        svEmptyGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        svEmptyGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setLocationStack(_ responseData: JSON){
        scrollMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.distribution = .fill
        svMain.axis = .vertical
        svMain.spacing = 15
        
        view.addSubview(scrollMain)
        view.addConstraint(NSLayoutConstraint(item: scrollMain, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.widthAnchor.constraint(equalTo: scrollMain.widthAnchor, multiplier: 1).isActive = true
        view.topAnchor.constraint(equalTo: scrollMain.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: scrollMain.bottomAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollMain.trailingAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: scrollMain.leadingAnchor, constant: 0).isActive = true
        
        
        scrollMain.addSubview(svMain)
        scrollMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: scrollMain, attribute: .centerX, multiplier: 1, constant: 0))
        svMain.widthAnchor.constraint(equalTo: scrollMain.widthAnchor, multiplier: 0.9).isActive = true
        svMain.topAnchor.constraint(equalTo: scrollMain.topAnchor, constant: 0).isActive = true
        svMain.bottomAnchor.constraint(equalTo: scrollMain.bottomAnchor, constant: 0).isActive = true
        
        let topView = UIView()
        topView.backgroundColor = .none
        topView.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        let bottomView = UIView()
        bottomView.backgroundColor = .none
        bottomView.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        
        svMain.addArrangedSubview(topView)
        let arrayData = responseData.arrayValue
        var arrNum = responseData.arrayValue.capacity - 1
        print(responseData.arrayValue.capacity)
        if arrNum >= 0 {
            for i in 0...responseData.arrayValue.capacity - 1 {
                if (responseData.arrayValue.capacity - 1) % 2 == 1{
                    if arrNum % 2 == 1{
                        addLocationItem(i, i+1, arrayData[arrNum], arrayData[arrNum - 1], svMain)
                    }
                }
                else {
                    if arrNum >= 1 && arrNum % 2 == 1 {
                        addLocationItem( i-1, i, arrayData[arrNum + 1], arrayData[arrNum], svMain)
                    }
                    if arrNum == 0 {
                        addLocationItem(i, 0, arrayData[arrNum], [], svMain)
                    }
                }
                arrNum -= 1
            }
        }
        svMain.addArrangedSubview(bottomView)
    }
    func addLocationItem(_ index1 : Int,_ index2 : Int,_ data1: JSON,_ data2: JSON,_ mainStack: UIStackView){
        let svTwoItem = UIStackView()
        svTwoItem.axis = .horizontal
        svTwoItem.spacing = 15
        
        svTwoItem.addArrangedSubview(makeItem(data1, index1))
        if data2 == [] { svTwoItem.addArrangedSubview(makeTempItem()) }
        else { svTwoItem.addArrangedSubview(makeItem(data2, index2)) }
        
        svTwoItem.backgroundColor = .systemPink
        svTwoItem.distribution = .fillEqually
        mainStack.addArrangedSubview(svTwoItem)
    }
    
    func makeItem(_ DibsLocData: JSON, _ index : Int) -> UIView {
        //let btnItem = UIButton(type: .custom)
        // 가져온 장소의 고유번호를 uvLocation의 Tag로 사용할 것
        let uvLocation = UIView()
        uvLocation.translatesAutoresizingMaskIntoConstraints = false
        uvLocation.layer.cornerRadius = 5
        uvLocation.layer.borderWidth = 0.5
        uvLocation.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        uvLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToStoreInfo(_:))))
        uvLocation.accessibilityIdentifier = DibsLocData["storeSn"].stringValue
        
        // 나중에 얘기는 클래스 단위로 따로 설계할 필요가 있음
        let url = URL(string: getImageURL(DibsLocData["storeSn"].stringValue, DibsLocData["storeDTO"]["storeImageUrlList"].arrayValue.first!.stringValue, tag: "store"))
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
        setPref(lblvar,DibsLocData["storeDTO"]["prefSn"].string!,DibsLocData["storeDTO"]["prefData"].string!)
        lblvar.fontSize = 11
        lblvar.textColor = .systemBlue
        let lblName = UILabel()
        lblName.textColor = .darkText
        lblName.text = DibsLocData["storeDTO"]["storeNm"].stringValue
        lblName.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        
        let lblPrice = UILabel()
        if DibsLocData["storeDTO"]["reprMenuPrice"].intValue == 0 {
            lblPrice.text = "대표메뉴 무료"
        } else {
            lblPrice.text = "대표메뉴 " + DecimalWon(DibsLocData["storeDTO"]["reprMenuPrice"].intValue)
        }
        lblPrice.fontSize = 11
        lblPrice.textColor = .darkGray
        
        let lblLocation = UIButton(type: .custom)
        let locArr = DibsLocData["storeDTO"]["storeAddr"].string!.components(separatedBy: " ")
        lblLocation.setTitle(locArr[1] + " " + locArr[2], for: .normal)
        lblLocation.titleLabel?.numberOfLines = 1
        lblLocation.setTitleColor(.darkGray, for: .normal)
        lblLocation.setImage(UIImage(named: "AddressIcon"), for: .normal)
        lblLocation.titleLabel?.fontSize = 11
        lblLocation.isUserInteractionEnabled = false
        lblLocation.contentHorizontalAlignment = .left
        let svLabel = UIStackView(arrangedSubviews: [lblPrice, lblLocation])
        svLabel.axis = .vertical
        svLabel.distribution = .fillEqually
        
        let imgDids = UIImageView(image: UIImage(named: "EmptyHeart"))
        let imgGPA = UIImageView(image: UIImage(named: "GPAIcon"))
        let svIcon = UIStackView(arrangedSubviews: [imgDids,imgGPA])
        svIcon.axis = .vertical
        svIcon.distribution = .fillEqually
        
        let lblDidsCount = UILabel()
        lblDidsCount.text = String(DibsLocData["storeDTO"]["storeFavorCount"].intValue)
        lblDidsCount.textColor = .darkGray
        lblDidsCount.fontSize = 13
        lblDidsCount.textAlignment = .right
        let lblGPA = UILabel()
        lblGPA.text = String(Double(DibsLocData["storeDTO"]["storeScore"].intValue))
        lblGPA.textColor = .darkGray
        lblGPA.fontSize = 13
        lblGPA.textAlignment = .right
        let svCount = UIStackView(arrangedSubviews: [lblDidsCount,lblGPA])
        svCount.axis = .vertical
        svCount.distribution = .fillEqually
        
        let svSubInfo = UIStackView(arrangedSubviews: [svLabel,svIcon,svCount])
        svSubInfo.axis = .horizontal
        svSubInfo.distribution = .fillProportionally
        svSubInfo.spacing = 3
        
        let svItemInfo = UIStackView(arrangedSubviews: [lblvar,lblName,svSubInfo])
        svItemInfo.translatesAutoresizingMaskIntoConstraints = false
        svItemInfo.axis = .vertical
        svItemInfo.distribution = .fill
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
        
        let btnRemove = IconButton(image: Icon.cm.close)
        let btnRemoveSize:CGFloat = 20
        btnRemove.translatesAutoresizingMaskIntoConstraints = false
        btnRemove.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btnRemove.tintColor = .darkGray
        btnRemove.widthAnchor.constraint(equalToConstant: btnRemoveSize).isActive = true
        btnRemove.heightAnchor.constraint(equalToConstant: btnRemoveSize).isActive = true
        btnRemove.layer.borderColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        btnRemove.layer.cornerRadius = btnRemoveSize * 0.5
        btnRemove.layer.borderWidth = 1
        uvLocation.addSubview(btnRemove)
        btnRemove.topAnchor.constraint(equalTo: uvLocation.topAnchor, constant: 5).isActive = true
        btnRemove.trailingAnchor.constraint(equalTo: uvLocation.trailingAnchor, constant: -5).isActive = true
        btnRemove.accessibilityIdentifier = DibsLocData["storeSn"].string
        btnRemove.tag = -(index+1) * 10
        btnRemove.addTarget(self, action: #selector(removeDidLocation(_:)), for: .touchUpInside)
        
        let btnCheck = IconButton(image: nil)
        let btnCheckSize:CGFloat = 25
        btnCheck.translatesAutoresizingMaskIntoConstraints = false
        btnCheck.backgroundColor = .white
        btnCheck.tintColor = .darkGray
        btnCheck.widthAnchor.constraint(equalToConstant: btnCheckSize).isActive = true
        btnCheck.heightAnchor.constraint(equalToConstant: btnCheckSize).isActive = true
        btnCheck.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        btnCheck.layer.cornerRadius = btnCheckSize * 0.5
        btnCheck.layer.borderWidth = 0.5
        uvLocation.addSubview(btnCheck)
        btnCheck.topAnchor.constraint(equalTo: uvLocation.topAnchor, constant: 5).isActive = true
        btnCheck.leadingAnchor.constraint(equalTo: uvLocation.leadingAnchor, constant: 5).isActive = true
        btnCheck.accessibilityIdentifier = DibsLocData["storeSn"].string
        btnCheck.isHidden = true
        btnCheck.tag = (index+1) * 10
        btnCheck.addTarget(self, action: #selector(checkPick(_:)), for: .touchUpInside)
        
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
    
    // ##################################################
    // ##################### 찜 삭제 ######################
    // ##################################################
    func deletePick(_ strStoreSn: String){
        let url = OperationIP + "/pick/deletePickInfo.do"
        let parameter = JSON([
            "storeSn": strStoreSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                let requestJSON = JSON(response.value!)
                //                print("##")
                //                print("## " + requestJSON["result"].stringValue + " ##")
                //                print("##")
                if requestJSON["result"].stringValue == "1"{
                    self.svMain.removeSubviews()
                    self.requestPost()
                }
            }
        }
    }
    
    @objc func removeDidLocation(_ sender: IconButton) {
        deletePick(sender.accessibilityIdentifier!)
    }
    
    @objc func goToStoreInfo(_ sender: UITapGestureRecognizer){
        let storeSn = sender.view?.accessibilityIdentifier
        //        UserDefaults.standard.setValue(storeSn, forKey: locationSnKey)
        getLocationInfo(storeSn!)
    }
    func getLocationInfo(_ locationSn : String) {
        //        let locationSn = UserDefaults.standard.string(forKey: locationSnKey)!
        let url = OperationIP + "/store/selectStoreInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        let parameter = JSON([
            "storeSn": locationSn,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //                  debugPrint(response)
            if response.value != nil {
                let responseJSON = JSON(response.value!)
                print(responseJSON)
                //                    self.uds.set(responseJSON.dictionaryObject, forKey: locationDataKey)
                locationData = responseJSON
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let goToVC = storyboard.instantiateViewController(withIdentifier: "locationInfoView")
                self.navigationController?.pushViewController(goToVC, animated: true)
            }
        }
        //            if (UserDefaults.standard.string(forKey: locationSnKey) != nil) {
        //
        //            }
    }
    
    // MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setUI(_ json: JSON){

        setLocationStack(json)
        
        btnStartCreateCourse.setImage(UIImage(named: "StartCreateCourse"), for: .normal)
        btnStartCreateCourse.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnStartCreateCourse)
        btnStartCreateCourse.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        btnStartCreateCourse.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        btnStartCreateCourse.addTarget(self, action: #selector(startCreateCourse(_:)), for: .touchUpInside)
        
        btnCreateCourse.setTitle("확인하기", for: .normal)
        btnCreateCourse.setTitleColor(.white, for: .normal)
        btnCreateCourse.backgroundColor = .lightGray
        btnCreateCourse.contentHorizontalAlignment = .center
        btnCreateCourse.translatesAutoresizingMaskIntoConstraints = false
        btnCreateCourse.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btnCreateCourse.layer.cornerRadius = 5
        btnCreateCourse.tag = 1
        
        view.addSubview(btnCreateCourse)
        view.backgroundColor = .white
        
        view.addConstraint(NSLayoutConstraint(item: btnCreateCourse, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        btnCreateCourse.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        btnCreateCourse.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnCreateCourse.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        btnCreateCourse.isHidden = true
        btnCreateCourse.addTarget(self, action: #selector(createCourse(_:)), for: .touchUpInside)
        
        let dibView = self.parent?.parent as! DibsNavigationViewController
        dibView.indicLoading.stopAnimating()
    }
    
    // ##################################################
    // ################## 체크박스 이벤트 ###################
    // ##################################################
    func EndCreateCourse(){
        for i in 1...self.responseJSON.arrayValue.capacity {
            self.svMain.viewWithTag(i*10)?.isHidden = true
            self.svMain.viewWithTag(i*10+1)?.isHidden = true
            self.svMain.viewWithTag(-i*10)?.isHidden = false
        }
        self.btnCreateCourse.isHidden = true
        self.btnStartCreateCourse.isHidden = false
    }
    @objc func startCreateCourse(_ sender: UIButton) {
        sender.isHidden = true
        let searchView = self.parent?.parent as! DibsNavigationViewController
        searchView.bbtnCancelCreateCourse.isEnabled = true
        searchView.bbtnCancelCreateCourse.title = "취소"
        
        btnCreateCourse.isHidden = false
        for i in 1...responseJSON.arrayValue.capacity {
            self.svMain.viewWithTag(i*10)?.isHidden = false
            self.svMain.viewWithTag(-i*10)?.isHidden = true
            self.svMain.viewWithTag(i*10+1)?.isHidden = false
        }
        
    }
    @objc func checkPick(_ sender: UIButton) {
        if sender.tag % 10 == 0 {
            let storesn = String(sender.accessibilityIdentifier!)
            selectedStoresn[sequence] = "\(storesn)"
            sender.tag += 1
            sequence += 1
            sender.accessibilityValue = String(sequence)
            setSequence(sender,_num: sequence)
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.2955724597, blue: 0.5731969476, alpha: 1)
            sender.layer.borderColor = #colorLiteral(red: 1, green: 0.2955724597, blue: 0.5731969476, alpha: 1)
        }
        else if sender.tag % 10 == 1 {
            sender.tag -= 1
            resetSequence(Int(sender.accessibilityValue!)!)
            resetStoreSn(Int(sender.accessibilityValue!)!)
            sequence -= 1
            sender.accessibilityValue = ""
            selectedStoresn[sequence] = ""
            sender.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            sender.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            deleteSequence(sender,_num: sequence)
        }
        if temp == 0 && sequence >= 5 && responseJSON.arrayValue.capacity >= 5 {
            deactivateCheck()
            temp = 1
        }
        else if temp == 1 && sequence < 5 {
            activateCheck()
            temp = 0
        }
        if sequence == 0 {
            btnCreateCourse.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            btnCreateCourse.tag = 1
        }
        else {
            btnCreateCourse.backgroundColor = #colorLiteral(red: 1, green: 0.2955724597, blue: 0.5731969476, alpha: 1)
            btnCreateCourse.tag = 2
        }
    }
    func setSequence(_ checkbtn: UIButton, _num: Int){
        checkbtn.setTitle(String(_num))
        checkbtn.setTitleColor(.white, for: .normal)
    }
    func deleteSequence(_ checkbtn: UIButton, _num: Int){
        checkbtn.setTitle(nil)
    }
    //체크박스 비활성화
    func deactivateCheck(){
        for i in 1...responseJSON.arrayValue.capacity {
            let btn = self.svMain.viewWithTag(i*10) as! UIButton?
            if btn != nil && btn!.tag % 10 == 0 {
                btn!.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                btn!.tag += 2
            }
        }
    }
    // 체크박스 활성화
    func activateCheck(){
        for i in 1...responseJSON.arrayValue.capacity {
            let btn = self.svMain.viewWithTag(i*10 + 2) as! UIButton?
            if btn != nil && btn!.tag % 10 == 2 {
                btn!.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                btn!.tag -= 2
            }
        }
    }
    // 차수 수정
    func resetSequence(_ num: Int){
        for i in 1...responseJSON.arrayValue.capacity {
            let btn = self.svMain.viewWithTag(i*10 + 1) as! UIButton?
            if btn != nil {
                print(i)
                let value = btn!.accessibilityValue
                if Int(value!)! >= num {
                    setSequence(btn!,_num: Int(value!)! - 1)
                    btn!.accessibilityValue = String(Int(value!)! - 1)
                }
            }
        }
    }
    //산텍된 storeSn 배열 차수에 맞게 수정
    func resetStoreSn(_ num: Int){
        if num != sequence{
            for i in num...sequence - 1{
                selectedStoresn[i - 1] = selectedStoresn[i]
            }
            selectedStoresn[sequence - 1] = ""
        }
        else{
            selectedStoresn[num - 1] = ""
        }
        print(selectedStoresn)
    }
    
    // 코스 산출 페이지
    @objc func gotoCouresView(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let goToVC = storyboard.instantiateViewController(withIdentifier: "courseView")
        //        self.present(goToVC, animated: true, completion: nil)
        //rvc 가 옵셔널 타입이므로 guard 구문을 통해서 옵셔널 바인딩 처리
        guard let rvc = storyboard.instantiateViewController(withIdentifier: "courseView") as? CourseViewController else {
            //아니면 종료
            return
        }
        rvc.storeSnArr.append(contentsOf: self.selectedStoresn)
        print("rcv = ", self.selectedStoresn)
        self.navigationController?.pushViewController(rvc, animated: true)
        //화면전환
        //        self.present(goToVC, animated: true)
    }
    @objc func createCourse(_ sender: UIButton) {
        if sender.tag == 2 {
            sender.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoCouresView)))
        }
    }
    
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

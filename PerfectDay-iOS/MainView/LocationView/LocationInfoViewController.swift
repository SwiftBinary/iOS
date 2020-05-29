//
//  LocationInfoViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/05/28.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MapKit
import XLPagerTabStrip
import ImageSlideshow

class LocationInfoViewController: UIViewController,ImageSlideshowDelegate,IndicatorInfoProvider,MKMapViewDelegate {
    var itemInfo: IndicatorInfo = "View"
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scvLocationInfo = UIScrollView()
    let svLocationInfo = UIStackView()
    let strHashTag = ["건대", "홍대", "강남", "이색", "고궁", "tv방영", "가성비", "고급진", "국밥", "방탈출", "야식", "비오는날", "100일데이트코스", "커플100%되는곳", "킬링타임코스", "호불호없는"]
    let sizeTitle:CGFloat = 20
    let sizeContent:CGFloat = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageUI()
        setTopInfoUI()
        setMapUI()
        setBottomInfoUI()
        setScrollUI()
    }
    
    func setImageUI() {
        let issBanner = ImageSlideshow()
        let localSource = [BundleImageSource(imageString: "testBanner0"), BundleImageSource(imageString: "testBanner1"), BundleImageSource(imageString: "testBanner2"), BundleImageSource(imageString: "testBanner3"),BundleImageSource(imageString: "TempImage")]
        issBanner.slideshowInterval = 5.0
        issBanner.contentScaleMode = UIViewContentMode.scaleAspectFill
        issBanner.activityIndicator = DefaultActivityIndicator()
        issBanner.delegate = self
        issBanner.setImageInputs(localSource)
        svLocationInfo.addArrangedSubview(issBanner)
        issBanner.translatesAutoresizingMaskIntoConstraints = false
        issBanner.heightAnchor.constraint(equalTo: issBanner.widthAnchor, multiplier: 2/3).isActive = true
    }
    
    func setTopInfoUI(){
        let lblMainMenuName = UILabel()
        lblMainMenuName.text = "대표메뉴명"
        lblMainMenuName.font = UIFont.boldSystemFont(ofSize: 20)
        let lblMainMenuPrice = UILabel()
        lblMainMenuPrice.text = "₩ 5,000원"
        lblMainMenuPrice.font = UIFont.systemFont(ofSize: 15)
        
        let svMainMenu = UIStackView(arrangedSubviews: [lblMainMenuName,lblMainMenuPrice])
        svMainMenu.axis = .horizontal
        
        let lblLocationDetail = UILabel()
        lblLocationDetail.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        lblLocationDetail.textColor = .darkGray
        lblLocationDetail.fontSize = 15
        lblLocationDetail.numberOfLines = 2
        lblLocationDetail.lineBreakMode = .byCharWrapping
        
        let scvTag = UIScrollView()
        scvTag.translatesAutoresizingMaskIntoConstraints = false
        let svTag = UIStackView()
        for hashTag in strHashTag {
            let btnHashTag = UIButton(type: .system)
            btnHashTag.setTitle(setHashTagString(hashTag))
            btnHashTag.layer.cornerRadius = 15
            btnHashTag.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            btnHashTag.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
            svTag.addArrangedSubview(btnHashTag)
        }
        svTag.translatesAutoresizingMaskIntoConstraints = false
        svTag.spacing = 5
        scvTag.addSubview(svTag)
        scvTag.addConstraint(NSLayoutConstraint(item: svTag, attribute: .centerY, relatedBy: .equal, toItem: scvTag, attribute: .centerY, multiplier: 1, constant: 0))
        scvTag.showsHorizontalScrollIndicator = false
        svTag.topAnchor.constraint(equalTo: scvTag.topAnchor, constant: 0).isActive = true
        svTag.bottomAnchor.constraint(equalTo: scvTag.bottomAnchor, constant: 0).isActive = true
        svTag.leadingAnchor.constraint(equalTo: scvTag.leadingAnchor, constant: 0).isActive = true
        svTag.trailingAnchor.constraint(equalTo: scvTag.trailingAnchor, constant: 0).isActive = true
        
        let uvLine1 = UIView()
        uvLine1.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
        uvLine1.backgroundColor = .lightGray
        
        let lblMenu = UILabel()
        lblMenu.text = "메뉴"
        lblMenu.font = UIFont.boldSystemFont(ofSize: 20)
        
        let svMenuList = UIStackView()
        for i in 1...3 {
            let lblMenuName = UILabel()
            lblMenuName.text = "메뉴명 " + String(i)
            lblMenuName.fontSize = 15
            let lblMenuPrice = UILabel()
            lblMenuPrice.text = "₩ " + String(i*2) + ",000원"
            lblMenuPrice.textAlignment = .right
            lblMenuPrice.fontSize = 15
            let svMenu = UIStackView(arrangedSubviews: [lblMenuName,lblMenuPrice])
            svMenuList.axis = .horizontal
            svMenuList.addArrangedSubview(svMenu)
        }
        svMenuList.axis = .vertical
        svMenuList.spacing = 3
        
        let btnMoreMenu = UIButton(type: .custom)
        btnMoreMenu.setTitle("더보기", for: .normal)
        btnMoreMenu.setTitleColor(#colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1), for: .normal)
        btnMoreMenu.titleLabel?.font = UIFont.boldSystemFont(ofSize: sizeContent)
        btnMoreMenu.contentHorizontalAlignment = .right
        svMenuList.addArrangedSubview(btnMoreMenu)
        
        let uvLine2 = UIView()
        uvLine2.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
        uvLine2.backgroundColor = .lightGray
        
        let lblMapTitle = UILabel()
        lblMapTitle.text = "지도정보"
        lblMapTitle.font = UIFont.boldSystemFont(ofSize: sizeTitle)
        
        let svInfo = UIStackView(arrangedSubviews: [svMainMenu,lblLocationDetail,scvTag,uvLine1,lblMenu,svMenuList,uvLine2,lblMapTitle])
        svInfo.axis = .vertical
        
        let uvBack = UIView()
        uvBack.backgroundColor = .white
        
        svInfo.axis = .vertical
        svInfo.translatesAutoresizingMaskIntoConstraints = false
        svInfo.spacing = 10
        uvBack.addSubview(svInfo)
        uvBack.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerX, relatedBy: .equal, toItem: uvBack, attribute: .centerX, multiplier: 1, constant: 0))
        svInfo.widthAnchor.constraint(equalTo: uvBack.widthAnchor, multiplier: 0.9).isActive = true
        svInfo.heightAnchor.constraint(equalTo: uvBack.heightAnchor, multiplier: 1).isActive = true
        
        svLocationInfo.addArrangedSubview(uvBack)
    }
    
    func setMapUI() {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        svLocationInfo.addArrangedSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 2/3).isActive = true
        
        //        let lblAddress = UILabel()
        //        lblAddress.text = "강남구 봉은사로 120"
        //        lblAddress.fontSize = 15
        //
        //        let uvAddress = UIView()
        //        uvAddress.translatesAutoresizingMaskIntoConstraints = false
        //        uvAddress.backgroundColor = .white
        //        uvAddress.layer.cornerRadius = 15
        //        uvAddress.layer.shadowColor = UIColor.lightGray.cgColor
        //        uvAddress.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        //        uvAddress.layer.shadowRadius = 2.0
        //        uvAddress.layer.shadowOpacity = 0.9
        //        uvAddress.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //
        //        mapView.addSubview(uvAddress)
        //        uvAddress.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -15).isActive = true
        //        uvAddress.addConstraint(NSLayoutConstraint(item: mapView, attribute: .centerX, relatedBy: .equal, toItem: lblAddress, attribute: .centerX, multiplier: 1, constant: 0))
        //
        //        uvAddress.addSubview(lblAddress)
        //        lblAddress.addConstraint(NSLayoutConstraint(item: uvAddress, attribute: .centerX, relatedBy: .equal, toItem: lblAddress, attribute: .centerX, multiplier: 1, constant: 0))
        //        lblAddress.addConstraint(NSLayoutConstraint(item: uvAddress, attribute: .centerY, relatedBy: .equal, toItem: lblAddress, attribute: .centerY multiplier: 1, constant: 0))
    }
    
    func setBottomInfoUI(){
        let btnFindPath = UIButton(type: .custom)
        btnFindPath.setTitle("길찾기", for: .normal)
        btnFindPath.titleLabel?.font = UIFont.systemFont(ofSize: sizeContent)
        btnFindPath.setTitleColor(.black, for: .normal)
        btnFindPath.setImage(UIImage(named: "FindPathBtn"), for: .normal)
        btnFindPath.translatesAutoresizingMaskIntoConstraints = false
        btnFindPath.imageEdgeInsets.left = -10
        btnFindPath.heightAnchor.constraint(equalToConstant: 35).isActive = true
        setShadowCard(btnFindPath, bgColor: .white, crRadius: 10, shColor: .lightGray, shOffsetW: 0.0, shOffsetH: 2.0, shRadius: 2.0, sdOpacity: 0.9)
        
        let btnCallLocation = UIButton(type: .custom)
        btnCallLocation.setTitle("전화/예약문의", for: .normal)
        btnCallLocation.titleLabel?.font = UIFont.systemFont(ofSize: sizeContent)
        btnCallLocation.setTitleColor(.black, for: .normal)
        btnCallLocation.setImage(UIImage(named: "CallLocationBtn"), for: .normal)
        btnCallLocation.translatesAutoresizingMaskIntoConstraints = false
        btnCallLocation.imageEdgeInsets.left = -10
        btnCallLocation.heightAnchor.constraint(equalToConstant: 35).isActive = true
        setShadowCard(btnCallLocation, bgColor: .white, crRadius: 10, shColor: .lightGray, shOffsetW: 0.0, shOffsetH: 2.0, shRadius: 2.0, sdOpacity: 0.9)
        
        let svFuncBtn = UIStackView(arrangedSubviews: [btnFindPath,btnCallLocation])
        svFuncBtn.axis = .horizontal
        svFuncBtn.distribution = .fillEqually
        svFuncBtn.spacing = 10
        
        let lblOfficeHours = UILabel()
        lblOfficeHours.text = "영업시간"
        lblOfficeHours.font = UIFont.boldSystemFont(ofSize: sizeTitle)
        
        let svOfficeHours = UIStackView()
        let listHours = ["주말 : 오전 10:00 ~ 오후 2:00" , "평일 : 오전 10:00 ~ 오후 11:00"]
        for str in listHours {
            let lblHours = UILabel()
            lblHours.text = str
            lblHours.font = UIFont.systemFont(ofSize: sizeContent)
            svOfficeHours.addArrangedSubview(lblHours)
        }
        svOfficeHours.spacing = 3
        svOfficeHours.axis = .vertical
        
        let uvEnd = UIView()
        uvEnd.backgroundColor = .white
        uvEnd.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let svInfo = UIStackView(arrangedSubviews: [svFuncBtn,lblOfficeHours,svOfficeHours,uvEnd])
        let uvBack = UIView()
        uvBack.backgroundColor = .white
        svInfo.axis = .vertical
        svInfo.translatesAutoresizingMaskIntoConstraints = false
        svInfo.spacing = 10
        uvBack.addSubview(svInfo)
        uvBack.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerX, relatedBy: .equal, toItem: uvBack, attribute: .centerX, multiplier: 1, constant: 0))
        svInfo.widthAnchor.constraint(equalTo: uvBack.widthAnchor, multiplier: 0.9).isActive = true
        svInfo.heightAnchor.constraint(equalTo: uvBack.heightAnchor, multiplier: 1).isActive = true
        
        svLocationInfo.addArrangedSubview(uvBack)
    }
    
    func setScrollUI() {
        scvLocationInfo.translatesAutoresizingMaskIntoConstraints = false
        svLocationInfo.translatesAutoresizingMaskIntoConstraints = false
        svLocationInfo.distribution = .fill
        svLocationInfo.axis = .vertical
        svLocationInfo.spacing = 10
        
        scvLocationInfo.backgroundColor = .white
        svLocationInfo.backgroundColor = .white
        view.addSubview(scvLocationInfo)
        view.addConstraint(NSLayoutConstraint(item: scvLocationInfo, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.widthAnchor.constraint(equalTo: scvLocationInfo.widthAnchor, multiplier: 1).isActive = true
        view.topAnchor.constraint(equalTo: scvLocationInfo.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: scvLocationInfo.bottomAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: scvLocationInfo.trailingAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: scvLocationInfo.leadingAnchor, constant: 0).isActive = true
        
        scvLocationInfo.addSubview(svLocationInfo)
        scvLocationInfo.addConstraint(NSLayoutConstraint(item: svLocationInfo, attribute: .centerX, relatedBy: .equal, toItem: scvLocationInfo, attribute: .centerX, multiplier: 1, constant: 0))
        svLocationInfo.widthAnchor.constraint(equalTo: scvLocationInfo.widthAnchor, multiplier: 1).isActive = true
        svLocationInfo.topAnchor.constraint(equalTo: scvLocationInfo.topAnchor, constant: 0).isActive = true
        svLocationInfo.bottomAnchor.constraint(equalTo: scvLocationInfo.bottomAnchor, constant: 0).isActive = true
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

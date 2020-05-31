//
//  HomeViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/05.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

var locationString = ""

class HomeViewController: UIViewController {
    
    @IBOutlet var uvLandmark: UIView!
    @IBOutlet var uvFuncButton: UIView!
    @IBOutlet var uvThemeLocation: UIView!
    
    @IBOutlet var svFuncButton: UIStackView!
    @IBOutlet var svThemeLocation: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLandmarkMap()
        setFuncButtonView()
        setThemeLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUI(){
        // Navigation Bar
        self.tabBarController?.tabBar.backgroundColor = .white
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
    }
    
    
    func setLandmarkMap(){
        setShadowCard(uvLandmark, bgColor: .white, crRadius: 15, shColor: .lightGray, shOffsetW: 0.0, shOffsetH: 2.0, shRadius: 2.0, sdOpacity: 0.9)
        uvLandmark.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func setFuncButtonView(){
        setShadowCard(uvFuncButton, bgColor: #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1), crRadius: 15, shColor: .lightGray, shOffsetW: 0.0, shOffsetH: 2.0, shRadius: 2.0, sdOpacity: 0.9)
        
        let fontSize:CGFloat = 16
        
        let btnOneClickCourse = MaterialVerticalButton(icon: UIImage(named: "KategorieWalk")!, title: "원클릭 데이트 코스 추천", foregroundColor: .black, useOriginalImg: true, bgColor: .white, cornerRadius: 15.0)
        btnOneClickCourse.label.font = UIFont.boldSystemFont(ofSize: fontSize)
        btnOneClickCourse.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        let btnFindAroundLocation = MaterialVerticalButton(icon: UIImage(named: "KategorieWalk")!, title: "내 주변 데이트 장소 찾기", foregroundColor: .black, useOriginalImg: true, bgColor: .white,cornerRadius: 15.0)
        btnFindAroundLocation.label.font = UIFont.boldSystemFont(ofSize: fontSize)
        btnFindAroundLocation.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        
        svFuncButton.addArrangedSubview(btnOneClickCourse)
        svFuncButton.addArrangedSubview(btnFindAroundLocation)
    }
    
    func setThemeLocation(){
        setShadowCard(uvThemeLocation, bgColor: .white, crRadius: 15, shColor: .lightGray, shOffsetW: 0.0, shOffsetH: 2.0, shRadius: 2.0, sdOpacity: 0.9)
        uvThemeLocation.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let LocationData = [0,1,2,3,4,5]
        
        let lblHotPlace = UILabel()
        lblHotPlace.text = "금주의 핫 플레이스"
        lblHotPlace.font = UIFont.boldSystemFont(ofSize: 17)
        
        let scvHotPlace = makeScrollView(Theme: "HotPlace", items: LocationData)
        
        let svHotPlace = UIStackView(arrangedSubviews: [lblHotPlace,scvHotPlace])
        svHotPlace.axis = .vertical
        svHotPlace.spacing = 10
        
        
        let lblTodayPlace = UILabel()
        lblTodayPlace.text = "20세의 오늘"
        lblTodayPlace.font = UIFont.boldSystemFont(ofSize: 17)
        
        let scvTodayPlace = makeScrollView(Theme: "TodayPlace", items: LocationData)
        
        let svTodayPlace = UIStackView(arrangedSubviews: [lblTodayPlace,scvTodayPlace])
        svTodayPlace.axis = .vertical
        svTodayPlace.spacing = 10
        
        let svTheme = UIStackView(arrangedSubviews: [svHotPlace,svTodayPlace])
        svTheme.axis = .vertical
        svTheme.spacing = 15
        
        let uvBottom = UIView()
        uvBottom.backgroundColor = .white
        uvBottom.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        
        svThemeLocation.addArrangedSubview(svTheme)
        svThemeLocation.addArrangedSubview(uvBottom)
    }
    
    func makeScrollView(Theme:String, items:[Int]) -> UIScrollView {
        let scvPlace = UIScrollView()
        scvPlace.translatesAutoresizingMaskIntoConstraints = false
        let svPlaceItem = UIStackView()
        switch Theme {
        case "HotPlace":
            addHotPlaceItem(svPlaceItem, items)
        case "TodayPlace":
            addTodayPlaceItem(svPlaceItem, items)
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
    
    func addHotPlaceItem(_ stackView: UIStackView, _ items: [Int]){
        for item in items{
            
            let imgLocation = UIImageView(image: UIImage(named: "TempImage"))
            imgLocation.widthAnchor.constraint(equalToConstant: 136).isActive = true
            imgLocation.heightAnchor.constraint(equalToConstant: 136).isActive = true
            imgLocation.contentMode = .scaleAspectFill
            imgLocation.clipsToBounds = true
            imgLocation.layer.cornerRadius = 5
            
            let lblLocationName = UILabel()
            lblLocationName.text = "장소명" + String(item)
            lblLocationName.font = UIFont.boldSystemFont(ofSize: 16)
            
            let lblLocationAddress = UILabel()
            lblLocationAddress.text = "장소위치" + String(item*2)
            lblLocationAddress.fontSize = 13
            
            let svItem = UIStackView(arrangedSubviews: [imgLocation,lblLocationName,lblLocationAddress])
            svItem.axis = .vertical
            svItem.spacing = 7
            
            stackView.addArrangedSubview(svItem)
        }
    }
    
    func addTodayPlaceItem(_ stackView: UIStackView, _ items: [Int]){
        for item in items{
            let imgLocation = UIImageView(image: UIImage(named: "TempImage"))
            imgLocation.widthAnchor.constraint(equalToConstant: 136).isActive = true
            imgLocation.heightAnchor.constraint(equalToConstant: 136).isActive = true
            imgLocation.contentMode = .scaleAspectFill
            imgLocation.clipsToBounds = true
            imgLocation.layer.cornerRadius = 5
            
            let lblLocationName = UILabel()
            lblLocationName.text = "장소명" + String(item)
            lblLocationName.font = UIFont.boldSystemFont(ofSize: 16)
            
            let lblLocationAddress = UILabel()
            lblLocationAddress.text = "장소위치" + String(item*2)
            lblLocationAddress.fontSize = 13
            
            let svItem = UIStackView(arrangedSubviews: [imgLocation,lblLocationName,lblLocationAddress])
            svItem.axis = .vertical
            svItem.spacing = 7
            
            stackView.addArrangedSubview(svItem)
        }
    }
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

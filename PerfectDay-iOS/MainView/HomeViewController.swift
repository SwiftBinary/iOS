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
    
    let listTag = ["홍대맛집","잠실야경","VR데이트","산책데이트", "수제햄버거","미친가격","너무맛있다","건대", "홍대", "강남", "이색", "고궁", "tv방영", "가성비", "고급진", "국밥", "방탈출", "야식", "비오는날", "100일데이트코스", "커플100%되는곳", "킬링타임코스", "호불호없는"]
    
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
    
    func setFuncButtonView(){
        setShadowCard(uvFuncButton, bgColor: #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1), crRadius: 15, shColor: .lightGray, shOffsetW: 0.0, shOffsetH: 2.0, shRadius: 2.0, sdOpacity: 0.9)
        
        let fontSize:CGFloat = 16
        
        let btnOneClickCourse = MaterialVerticalButton(icon: UIImage(named: "CourseRecommandIcon")!, text: "원클릭 데이트 코스 추천", font: nil ,foregroundColor: .black, bgColor: .white, useOriginalImg: true,cornerRadius: 15.0)
        btnOneClickCourse.label.font = UIFont.boldSystemFont(ofSize: fontSize)
        btnOneClickCourse.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        let btnFindAroundLocation = MaterialVerticalButton(icon: UIImage(named: "SearchLocationIcon")!, text: "내 주변 데이트 장소 찾기", font: nil ,foregroundColor: .black, bgColor: .white, useOriginalImg: true, cornerRadius: 15.0)
        btnFindAroundLocation.label.font = UIFont.boldSystemFont(ofSize: fontSize)
        btnFindAroundLocation.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        
        svFuncButton.addArrangedSubview(btnOneClickCourse)
        svFuncButton.addArrangedSubview(btnFindAroundLocation)
    }
    
    func setThemeLocation(){
        setShadowCard(uvThemeLocation, bgColor: .white, crRadius: 15, shColor: .lightGray, shOffsetW: 0.0, shOffsetH: 2.0, shRadius: 2.0, sdOpacity: 0.9)
        uvThemeLocation.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let LocationData = [0,1,2,3,4]
        
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
        
        let scvHotPlace = makeScrollView(Theme: "HotPlace", items: LocationData)
        
        let svHotPlace = UIStackView(arrangedSubviews: [svHotPlaceTitle,scvHotPlace])
        svHotPlace.axis = .vertical
        svHotPlace.spacing = 10
        
        let lblTodayPlace = UILabel()
        lblTodayPlace.font = UIFont.boldSystemFont(ofSize: 17)
        let attributedTodayPlaceString: NSMutableAttributedString = NSMutableAttributedString(string: "20세의 오늘")
        attributedTodayPlaceString.setColor(color: #colorLiteral(red: 0.9882352941, green: 0.368627451, blue: 0.5725490196, alpha: 1), forText: "오늘")
        lblTodayPlace.attributedText = attributedTodayPlaceString
        let imgTodayPlace = UIButton(type: .custom)
        imgTodayPlace.isUserInteractionEnabled = false
        imgTodayPlace.setTitle(" ")
        imgTodayPlace.setImage(UIImage(named: "Oneul"), for: .normal)
        imgTodayPlace.semanticContentAttribute = .forceRightToLeft
        imgTodayPlace.contentHorizontalAlignment = .left
        
        let svTodayPlaceTitle = UIStackView(arrangedSubviews: [lblTodayPlace,imgTodayPlace])
        svTodayPlaceTitle.axis = .horizontal
        
        let scvTodayPlace = makeScrollView(Theme: "TodayPlace", items: LocationData)
        
        let svTodayPlace = UIStackView(arrangedSubviews: [svTodayPlaceTitle,scvTodayPlace])
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
            addADTodayPlaceItem(svPlaceItem)
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
    
    func addADTodayPlaceItem(_ stackView: UIStackView){
        
        let imgLocation = UIImageView(image: UIImage(named: "TempImage"))
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
        lblLocationName.text = "AD장소명"
        lblLocationName.font = UIFont.boldSystemFont(ofSize: 16)
        
        let btnADHelp = UIButton(type: .custom)
        btnADHelp.setTitle(" ")
        btnADHelp.setImage(UIImage(named: "HelpIcon"), for: .normal)
        //        lblADLabel.semanticContentAttribute = .
        btnADHelp.contentHorizontalAlignment = .center
        
        let svLocationName = UIStackView(arrangedSubviews: [btnADLabel,lblLocationName,btnADHelp])
        svLocationName.axis = .horizontal
        svLocationName.distribution = .fillProportionally
        svLocationName.spacing = -5
        
        let lblLocationAddress = UILabel()
        lblLocationAddress.text = "AD 장소위치"
        lblLocationAddress.fontSize = 13
        
        let svItem = UIStackView(arrangedSubviews: [imgLocation,svLocationName,lblLocationAddress])
        svItem.axis = .vertical
        svItem.spacing = 7
        
        stackView.addArrangedSubview(svItem)
    }
    
    func addTodayPlaceItem(_ stackView: UIStackView, _ items: [Int]){
        for item in items{
            let imgLocation = UIImageView(image: UIImage(named: "TempImage"))
            imgLocation.widthAnchor.constraint(equalToConstant: 136).isActive = true
            imgLocation.heightAnchor.constraint(equalToConstant: 136).isActive = true
            imgLocation.contentMode = .scaleAspectFill
            imgLocation.clipsToBounds = true
            imgLocation.layer.cornerRadius = 5
            
            let lblLocationRank = UILabel()
            let strRank = String(items.count - item) + "위"
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
            lblLocationName.text = "장소명"
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

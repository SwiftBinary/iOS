//
//  DibsCourseViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/12.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import XLPagerTabStrip
import Material

class DibsCourseViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
    let testNum = 10
    let lightGray = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    
    let scrollMain = UIScrollView()
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCourseStack()
        setUI()
    }
    
    func setCourseStack(){
        scrollMain.translatesAutoresizingMaskIntoConstraints = false
        let svMain = UIStackView()
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
        for _ in 0...testNum {
            svMain.addArrangedSubview(createCourseView())
        }
        svMain.addArrangedSubview(bottomView)
    }
    
    func createCourseView() -> UIView {
        let viewPost = UIView()
        viewPost.backgroundColor = .white
//        viewPost.heightAnchor.constraint(equalToConstant: 150).isActive = true
        viewPost.layer.cornerRadius = 15
        viewPost.layer.borderWidth = 1
        viewPost.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewPost.layer.shadowColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        viewPost.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewPost.layer.shadowRadius = 2.0
        viewPost.layer.shadowOpacity = 0.9
        createCourseInfo(viewPost)
        return viewPost
    }
    
    func createCourseInfo(_ uvPost:UIView){
        let lblTitleCourse = UILabel()
        lblTitleCourse.text = "100일 기념"
        lblTitleCourse.textColor = themeColor
        lblTitleCourse.font = UIFont.boldSystemFont(ofSize: 18.0)
        lblTitleCourse.fontSize = 17
        
        let lblBudget = UILabel()
        lblBudget.text = "1인 예산 - 20,000원 | 소요 시간 - 4시간"
        lblBudget.textColor = .darkGray
        lblBudget.fontSize = 11
        
        let svLocation = UIStackView()
        svLocation.distribution = .fillEqually
        svLocation.axis = .horizontal
        svLocation.spacing = 5
        for i in 1...5 {
            svLocation.addArrangedSubview(inputLoaction(i))
        }
        
        let svCourse = UIStackView(arrangedSubviews: [lblTitleCourse,lblBudget,svLocation])
        svCourse.translatesAutoresizingMaskIntoConstraints = false
        svCourse.axis = .vertical
        svCourse.distribution = .fill
        svCourse.spacing = 10
        
        uvPost.addSubview(svCourse)
        uvPost.addConstraint(NSLayoutConstraint(item: svCourse, attribute: .centerX, relatedBy: .equal, toItem: uvPost, attribute: .centerX, multiplier: 1, constant: 0))
        uvPost.addConstraint(NSLayoutConstraint(item: svCourse, attribute: .centerY, relatedBy: .equal, toItem: uvPost, attribute: .centerY, multiplier: 1, constant: 0))
        svCourse.widthAnchor.constraint(equalTo: uvPost.widthAnchor, multiplier: 0.9).isActive = true
        svCourse.heightAnchor.constraint(equalTo: uvPost.heightAnchor, multiplier: 0.8).isActive = true
        
        let btnDelete = UIButton(type: .system)
        btnDelete.setTitle("삭제", for: .normal)
        btnDelete.translatesAutoresizingMaskIntoConstraints = false
        uvPost.addSubview(btnDelete)
        btnDelete.topAnchor.constraint(equalTo: uvPost.topAnchor, constant: 5).isActive = true
        btnDelete.trailingAnchor.constraint(equalTo: uvPost.trailingAnchor, constant: -10).isActive = true
        //        btnDelete.addTarget(self, action: #selector(), for: .touchUpInside)
    }
    
    func inputLoaction(_ index: Int) -> UIView {
        let uvLocation = UIView()
        
        let imgLocation = UIImageView(image: UIImage(named: "TempImage"))
        imgLocation.heightAnchor.constraint(equalTo: imgLocation.widthAnchor, multiplier: 1).isActive = true
        imgLocation.contentMode = .scaleAspectFill
        imgLocation.clipsToBounds = true
        imgLocation.layer.cornerRadius = 15
        
        let lblLoation = UILabel()
        lblLoation.text = "벚꽃 구경"
        lblLoation.textColor = .darkGray
        lblLoation.textAlignment = .center
        lblLoation.fontSize = 15
        
        let svLoaction = UIStackView(arrangedSubviews: [imgLocation,lblLoation])
        svLoaction.translatesAutoresizingMaskIntoConstraints = false
        svLoaction.distribution = .fill
        svLoaction.spacing = 2
        svLoaction.axis = .vertical
        
        uvLocation.addSubview(svLoaction)
        uvLocation.addConstraint(NSLayoutConstraint(item: svLoaction, attribute: .centerX, relatedBy: .equal, toItem: uvLocation, attribute: .centerX, multiplier: 1, constant: 0))
        uvLocation.addConstraint(NSLayoutConstraint(item: svLoaction, attribute: .centerY, relatedBy: .equal, toItem: uvLocation, attribute: .centerY, multiplier: 1, constant: 0))
        svLoaction.widthAnchor.constraint(equalTo: uvLocation.widthAnchor, multiplier: 1).isActive = true
        svLoaction.heightAnchor.constraint(equalTo: uvLocation.heightAnchor, multiplier: 1).isActive = true
        
        let lblLoationIndex = UILabel()
        lblLoationIndex.translatesAutoresizingMaskIntoConstraints = false
        lblLoationIndex.text = String(index)
        lblLoationIndex.textColor = .white
        lblLoationIndex.textAlignment = .center
        lblLoationIndex.fontSize = 11
        lblLoationIndex.backgroundColor = themeColor
        lblLoationIndex.widthAnchor.constraint(equalToConstant: 15).isActive = true
        lblLoationIndex.heightAnchor.constraint(equalToConstant: 15).isActive = true
        lblLoationIndex.layer.masksToBounds = true
        lblLoationIndex.layer.cornerRadius = 15 * 0.5
        uvLocation.addSubview(lblLoationIndex)
        lblLoationIndex.centerXAnchor.constraint(equalTo: imgLocation.trailingAnchor, constant: -2).isActive = true
        lblLoationIndex.centerYAnchor.constraint(equalTo: imgLocation.topAnchor, constant:  2).isActive = true
        
        return uvLocation
    }
    
    func makeItem(_ num: Int) -> UIView {
        //let btnItem = UIButton(type: .custom)
        // 가져온 장소의 고유번호를 uvLocation의 Tag로 사용할 것
        let uvLocation = UIView()
        uvLocation.translatesAutoresizingMaskIntoConstraints = false
        uvLocation.layer.cornerRadius = 5
        uvLocation.layer.borderWidth = 0.5
        uvLocation.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//        uvLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tempFunc)))
        
        // 나중에 얘기는 클래스 단위로 따로 설계할 필요가 있음
        let imgItem = UIImageView(image: UIImage(named: "TempImage"))
        //        imgItem.widthAnchor.constraint(equalToConstant: 160).isActive = true
        imgItem.heightAnchor.constraint(equalToConstant: 130).isActive = true
        imgItem.contentMode = .scaleAspectFill
        imgItem.clipsToBounds = true
        imgItem.layer.cornerRadius = 5
        imgItem.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let lblvar = UILabel()
        lblvar.text = "만화카페"
        lblvar.fontSize = 11
        lblvar.textColor = .systemBlue
        let lblName = UILabel()
        lblName.text = "놀숲 건대점"
        lblName.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        
        let lblPrice = UILabel()
        lblPrice.text = "대표메뉴 " + String(num) + "원"
        lblPrice.fontSize = 11
        lblPrice.textColor = .darkGray
        let lblLocation = UIButton(type: .custom)
        lblLocation.setTitle("서울 광진구 자양동", for: .normal)
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
        
        let lblDidsCount = UILabel()
        lblDidsCount.text = "9999"
        lblDidsCount.textColor = .darkGray
        lblDidsCount.fontSize = 11
        lblDidsCount.textAlignment = .center
        let lblGPA = UILabel()
        lblGPA.text = "3.5"
        lblGPA.textColor = .darkGray
        lblGPA.fontSize = 11
        lblGPA.textAlignment = .center
        let svCount = UIStackView(arrangedSubviews: [lblDidsCount,lblGPA])
        svCount.axis = .vertical
        
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
        
        let btnRemove = IconButton(image: Icon.cm.close)
        let btnRemoveSize:CGFloat = 20
        btnRemove.translatesAutoresizingMaskIntoConstraints = false
        btnRemove.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btnRemove.tintColor = .darkGray
        btnRemove.widthAnchor.constraint(equalToConstant: btnRemoveSize).isActive = true
        btnRemove.heightAnchor.constraint(equalToConstant: btnRemoveSize).isActive = true
        btnRemove.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnRemove.layer.cornerRadius = btnRemoveSize * 0.5
        btnRemove.layer.borderWidth = 1
        uvLocation.addSubview(btnRemove)
        btnRemove.topAnchor.constraint(equalTo: uvLocation.topAnchor, constant: 5).isActive = true
        btnRemove.trailingAnchor.constraint(equalTo: uvLocation.trailingAnchor, constant: -5).isActive = true
        
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
        
        return uvLocation
    }
    
    // MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setUI(){
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
    }
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

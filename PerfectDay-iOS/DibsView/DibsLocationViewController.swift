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

    var itemInfo: IndicatorInfo = "View"
    
    let testNum = 10
    let lightGray = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    let btnCreateCourse = UIButton(type: .custom)
    let scrollMain = UIScrollView()
    var createONOFF = false
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationStack()
        setUI()
    }
    
    func setLocationStack(){
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
        for i in 0...testNum {
            addLocationItem(svMain,num:i)
        }
        svMain.addArrangedSubview(bottomView)
    }
    func addLocationItem(_ mainStack: UIStackView, num: Int){
        let svTwoItem = UIStackView()
        svTwoItem.axis = .horizontal
        svTwoItem.spacing = 15
        svTwoItem.addArrangedSubview(makeItem(num))
        svTwoItem.addArrangedSubview(makeItem(num+1))
        svTwoItem.distribution = .fillEqually
        
        mainStack.addArrangedSubview(svTwoItem)
    }
    
    func makeItem(_ num: Int) -> UIView {
        //let btnItem = UIButton(type: .custom)
        // 가져온 장소의 고유번호를 uvLocation의 Tag로 사용할 것
        let uvLocation = UIView()
        uvLocation.translatesAutoresizingMaskIntoConstraints = false
        uvLocation.layer.cornerRadius = 5
        uvLocation.layer.borderWidth = 0.5
        uvLocation.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        uvLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tempFunc)))
        
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
        
        return uvLocation
    }
    
    @objc func removeDidLocation(_ sender: IconButton) {
        let uvWhite = UIView()
        uvWhite.backgroundColor = .white
        (sender.superview?.superview as! UIStackView).removeArrangedSubview(sender.superview!)
        (sender.superview?.superview as! UIStackView).insertArrangedSubview(uvWhite, at: 0)
    }
    
    @objc func tempFunc(){
        print("debug")
    }
    
    // MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setUI(){
        // 코스 생성 버튼
        btnCreateCourse.setTitle("확인하기", for: .normal)
        btnCreateCourse.setTitleColor(.white, for: .normal)
        btnCreateCourse.backgroundColor = .lightGray
        btnCreateCourse.contentHorizontalAlignment = .center
        btnCreateCourse.translatesAutoresizingMaskIntoConstraints = false

        btnCreateCourse.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btnCreateCourse.layer.cornerRadius = 5
        
        view.addSubview(btnCreateCourse)
        view.backgroundColor = .white

        view.addConstraint(NSLayoutConstraint(item: btnCreateCourse, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        btnCreateCourse.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        btnCreateCourse.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnCreateCourse.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
    }
    

    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

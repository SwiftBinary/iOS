//
//  DibsLocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DibsLocationViewController: UIViewController, IndicatorInfoProvider {

    let testNum = 50
    
    var itemInfo: IndicatorInfo = "View"
    let btnCreateCourse = UIButton(type: .custom)
    let btnCancelCreate = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancelCreate))
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
    }
    
    func setLocationStack(){
        print(scrollMain.isScrollEnabled)
        scrollMain.translatesAutoresizingMaskIntoConstraints = false
        let svMain = UIStackView()
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.distribution = .fillEqually
        svMain.axis = .vertical
        svMain.spacing = 15
        addLocationItem(svMain,num:0)
        for i in 1...testNum {
            addLocationItem(svMain,num:i)
        }

        
        scrollMain.addSubview(svMain)
        svMain.widthAnchor.constraint(equalTo: scrollMain.widthAnchor, multiplier: 0.9).isActive = true
        
        view.addSubview(scrollMain)
        view.addConstraint(NSLayoutConstraint(item: scrollMain, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        scrollMain.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        scrollMain.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollMain.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        scrollMain.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        scrollMain.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: scrollMain, attribute: .centerX, multiplier: 1, constant: 0))
    }
    func addLocationItem(_ mainStack: UIStackView, num: Int){
        let svTwoItem = UIStackView()
        svTwoItem.axis = .horizontal
        svTwoItem.spacing = 15
        svTwoItem.addArrangedSubview(makeItem(num))
        svTwoItem.addArrangedSubview(makeItem(num+1))
        svTwoItem.distribution = .fillEqually
        
        mainStack.addArrangedSubview(svTwoItem)
        //svTwoItem.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 1).isActive = true
    }
    
    func makeItem(_ num: Int) -> UIStackView {
        //let btnItem = UIButton(type: .custom)
        
        // 나중에 얘기는 클래스 단위로 따로 설계할 필요가 있음
        let svItem = UIStackView()
        svItem.axis = .vertical
        let imgItem = UIImageView(image: UIImage(named: "ReviewBoardIcon"))
        let lblvar = UILabel()
        lblvar.text = "만화카페" + String(num)
        let lblName = UILabel()
        lblName.text = "놀숲 건대점"
        let lblPrice = UILabel()
        lblPrice.text = "대표메뉴 10,000원"
        let lblLocate = UILabel()
        lblLocate.text = "서울시 광진구 화양동"
        // 좋아요 별점 추후 추가(위치 및 표시 기획 결정 안 남)
        svItem.addArrangedSubview(imgItem)
        svItem.addArrangedSubview(lblvar)
        svItem.addArrangedSubview(lblName)
        svItem.addArrangedSubview(lblPrice)
        svItem.addArrangedSubview(lblLocate)
        svItem.backgroundColor = .black
        svItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tempFunc)))
//        svItem.translatesAutoresizingMaskIntoConstraints = false
//        svItem.layer.borderWidth = 0.5
//        svItem.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//        btnItem.addSubview(svItem)
//        btnItem.addTarget(self, action: #selector(tempFunc), for: .touchUpInside)
        
        return svItem
    }
    
    @objc func tempFunc(){
        print("debug")
        scrollMain.scrollToBottom()
    }
    
    // MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        setUI()
    }
    
    func setUI(){
        // 코스 생성 버튼
        btnCreateCourse.setTitle(nil, for: .normal)
        btnCreateCourse.backgroundColor = .none
        btnCreateCourse.setImage(UIImage(named: "CreateCourseBtn") , for: .normal)
        btnCreateCourse.addTarget(self, action: #selector(setCreateCourse), for: .touchUpInside)
        btnCreateCourse.imageView?.contentMode = .scaleAspectFit
        btnCreateCourse.contentHorizontalAlignment = .center
        btnCreateCourse.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(btnCreateCourse)
        view.backgroundColor = .white

        view.addConstraint(NSLayoutConstraint(item: btnCreateCourse, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        btnCreateCourse.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        btnCreateCourse.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
    }
    @objc func setCreateCourse(){
        createONOFF = true
        btnCreateCourse.removeTarget(self, action: #selector(setCreateCourse), for: .touchUpInside)
        btnCreateCourse.setImage(nil, for: .normal)
        btnCreateCourse.setTitle("확인 하기", for: .normal)
        btnCreateCourse.setTitleColor(.white, for: .normal)
        btnCreateCourse.isEnabled = true // false
        btnCreateCourse.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        btnCreateCourse.addTarget(self, action: #selector(createCourse), for: .touchUpInside)
        
        let VC = self.parent?.parent
        VC?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancelCreate))
    }
    
    @objc func createCourse() {
        print("debug")
//        btnCreateCourse.removeTarget(self, action: #selector(createCourse), for: .touchUpInside)
//        btnCreateCourse.addTarget(self, action: #selector(setCreateCourse), for: .touchUpInside)
    }
    @objc func cancelCreate() {
        print("btn debug")
        createONOFF = false
        btnCreateCourse.removeTarget(self, action: #selector(createCourse), for: .touchUpInside)
        btnCreateCourse.setImage(UIImage(named: "CreateCourseBtn") , for: .normal)
        btnCreateCourse.setTitle(nil, for: .normal)
        btnCreateCourse.isEnabled = true
        btnCreateCourse.backgroundColor = .none
        btnCreateCourse.addTarget(self, action: #selector(setCreateCourse), for: .touchUpInside)
        let VC = self.parent?.parent
        VC?.navigationItem.leftBarButtonItem = nil
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

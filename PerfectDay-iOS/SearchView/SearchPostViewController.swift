//
//  SearchPostViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/12.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip
// UIPickerViewDelegate, UIPickerViewDataSource,
class SearchPostViewController: UIViewController, IndicatorInfoProvider {

//    let svHorizontal = UIStackView()
//    let uvBack = UIView()
    
//    var sortingOptionList = ["최신순","조회순","댓글순","공감순"]
//    var periodOptionList = ["1주","1개월","3개월","6개월"]
//    var checkBtn = true // true 검색 기간, false 정렬조건
//    var checkPv = true // true didSelectRow 호출됨, false didSelectRow 호출 안 됨
    //var pickerView = UIPickerView()
//    var typeValue = String()
    
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
        setUI()
//        setScroll(UIScrollView())
    }
    
    func setUI(){
        // UI 구조
        // 세로 스택뷰[ 가로 스택 뷰1{선택한 위치 라벨, 위치 설정 버튼} , 가로 스택 뷰2{결과 장소 수 라벨, 필터 버튼, 정렬조건 버튼} ]
        let svHorizontal = UIStackView()
        let lblCountPost = UILabel()
        let btnFilter = UIButton(type: .system)

        //Label Setting
        lblCountPost.text = "조건에 해당하는 게시물: 000 개"
        lblCountPost.textAlignment = .left

        //Button Setting
        btnFilter.setTitle("", for: .normal)
        btnFilter.setImage(UIImage(named: "FilterBtn"), for: .normal)
        btnFilter.addTarget(self, action: #selector(filterPost), for: .touchUpInside)

        //Stack Setting
        svHorizontal.addArrangedSubview(lblCountPost)
        svHorizontal.addArrangedSubview(btnFilter)
        
        btnFilter.widthAnchor.constraint(equalTo: svHorizontal.heightAnchor, multiplier: 1).isActive = true

        //        svHorizontal2.addArrangedSubview(lblCountLocation)
        //        svHorizontal2.addArrangedSubview(btnFilter)
        //        svHorizontal2.addArrangedSubview(btnSorting)
        //        svHorizontal2.distribution = .fillProportionally
        //        view.addSubview(svVertical)
        //        view.addConstraint(NSLayoutConstraint(item: svVertical, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0) )
        //        svVertical.addArrangedSubview(svHorizontal1)
        //        svVertical.addArrangedSubview(svHorizontal2)
        //        svVertical.translatesAutoresizingMaskIntoConstraints = false

        svHorizontal.translatesAutoresizingMaskIntoConstraints = false

        svHorizontal.distribution = .fill
        view.addSubview(svHorizontal)
        view.backgroundColor = .white
        view.addConstraint(NSLayoutConstraint(item: svHorizontal, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        svHorizontal.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        svHorizontal.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        
        // Add actions
    }
    
    @objc func filterPost(sender: UIButton){
        let goToVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "postFilterView")
        self.present(goToVC, animated: true, completion: nil)
    }

//    func setScroll(_ scrollMain: UIScrollView){
//
//        scrollMain.translatesAutoresizingMaskIntoConstraints = false
//        uvBack.addSubview(scrollMain)
//        uvBack.addConstraint(NSLayoutConstraint(item: scrollMain, attribute: .centerX, relatedBy: .equal, toItem: uvBack, attribute: .centerX, multiplier: 1, constant: 0))
//        scrollMain.widthAnchor.constraint(equalTo: uvBack.widthAnchor, multiplier: 1).isActive = true
//        svHorizontal.bottomAnchor.constraint(equalTo: scrollMain.topAnchor, constant: 0).isActive = true
//        scrollMain.bottomAnchor.constraint(equalTo: uvBack.bottomAnchor, constant: 0).isActive = true
//        scrollMain.leadingAnchor.constraint(equalTo: uvBack.leadingAnchor, constant: 0).isActive = true
//        scrollMain.trailingAnchor.constraint(equalTo: uvBack.trailingAnchor, constant: 0).isActive = true
//
//        let svMain = UIStackView()
//        svMain.translatesAutoresizingMaskIntoConstraints = false
//        svMain.distribution = .fillEqually
//        svMain.backgroundColor = .darkGray
//        svMain.axis = .vertical
//        svMain.spacing = 15
//
//        scrollMain.addSubview(svMain)
//        scrollMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: scrollMain, attribute: .centerX, multiplier: 1, constant: 0))
//        svMain.widthAnchor.constraint(equalTo: scrollMain.widthAnchor, multiplier: 0.9).isActive = true
//        svMain.topAnchor.constraint(equalTo: scrollMain.topAnchor, constant: 10).isActive = true
//
//        for _ in 0...100 {
//            let tempBtn = UIButton(type: .system)
//            tempBtn.setTitle("Button", for: .normal)
//            tempBtn.backgroundColor = .white
//            setSNSButton(tempBtn,"")
//            svMain.addArrangedSubview(tempBtn)
//        }
//    }
    
    //MARK - PickerView
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//     
//    //row를 결정
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if checkBtn { // 검색 기간
//            return periodOptionList.count
//        } else { // 정렬 조건
//            return sortingOptionList.count
//        }
//    }
//
//    // Pickerview에 들어간 content를 결정
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if checkBtn { // 검색 기간
//            return periodOptionList[row]
//        } else { // 정렬 조건
//            return sortingOptionList[row]
//        }
//    }
//
//    // Picker Item이 선택되었을때 해당 Item의 row 함께 호출되는 함수
//    // 문제는 이게 Picker뷰를 호출하고 선택을 안 하면 아예 호출이 안 됨
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        checkPv = true
//        if checkBtn { // 검색 기간
//            typeValue = periodOptionList[row]
//        } else { // 정렬 조건
//            typeValue = sortingOptionList[row]
//        }
//    }
//
//    @objc func periodPost(sender: UIButton){
//        checkBtn = true
//        checkPv = false
//        let alertController = UIAlertController(title: "검색기간", message: "\n\n\n\n", preferredStyle: UIAlertController.Style.alert)
//        let sortingPicker = UIPickerView()
//        alertController.view.addSubview(sortingPicker)
//        sortingPicker.frame = CGRect(x: 10, y: 35, width: 250, height: 100)
//
//        sortingPicker.dataSource = self
//        sortingPicker.delegate = self
//
//        let selectAction = UIAlertAction(title: "선택", style: .default, handler: { _ in
//            if self.checkPv {
//                ((self.view.subviews[0].subviews[0] as! UIStackView).arrangedSubviews[1] as! UIButton).setTitle(self.typeValue, for: .normal)
//            } else {
//                ((self.view.subviews[0].subviews[0] as! UIStackView).arrangedSubviews[1] as! UIButton).setTitle(self.periodOptionList[0], for: .normal)
//            }
//        })
//        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
//
//        alertController.addAction(selectAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
//    @objc func sortingPost(sender: UIButton){
//        checkBtn = false
//        checkPv = false
//        let alertController = UIAlertController(title: "정렬기준", message: "\n\n\n\n", preferredStyle: UIAlertController.Style.alert)
//        let sortingPicker = UIPickerView()
//        alertController.view.addSubview(sortingPicker)
//        sortingPicker.frame = CGRect(x: 10, y: 35, width: 250, height: 100)
//
//        sortingPicker.dataSource = self
//        sortingPicker.delegate = self
//
//        let selectAction = UIAlertAction(title: "선택", style: .default, handler: { _ in
//            if self.checkPv {
//                ((self.view.subviews[0].subviews[0] as! UIStackView).arrangedSubviews[2] as! UIButton).setTitle(self.typeValue, for: .normal)
//            } else {
//                ((self.view.subviews[0].subviews[0] as! UIStackView).arrangedSubviews[2] as! UIButton).setTitle(self.sortingOptionList[0], for: .normal)
//            }
//        })
//        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
//
//        alertController.addAction(selectAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
    
    
    

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

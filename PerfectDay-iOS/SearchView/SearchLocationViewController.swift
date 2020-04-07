//
//  SearchLocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/11.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip
// UIPickerViewDelegate, UIPickerViewDataSource,
class SearchLocationViewController: UIViewController, IndicatorInfoProvider, LocationDelegate {
    
    var optionList = ["높은 가격순","낮은 가격순","긴 소요시간순","짧은 소요시간순","높은 평점순","가까운 거리순"]
    var checkPv = true // true didSelectRow 호출됨, false didSelectRow 호출 안 됨
    var pickerView = UIPickerView()
    var typeValue = String()
    
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
    
    var label = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if LocationInfo.locationString.str == "" {
            label = "위치 정보 없음"
        } else {
            label = " " + LocationInfo.locationString.str
        }
        // 뷰의 서브뷰[0] -> 세로 스택[0] -> 가로 스택[0] -> 위치 표시 라벨
        ((view.subviews[0] as! UIStackView).arrangedSubviews[1] as! UILabel).text = label
        
        // 뷰의 서브뷰[0] -> 세로 스택[1] -> 가로 스택[0] -> 장소 개수 라벨
        //(((view.subviews[0] as! UIStackView).arrangedSubviews[1] as! UIStackView).arrangedSubviews[0] as! UILabel).text = {"곳"}
    }

    func setUI(){
        // UI 구조
        // 세로 스택뷰[ 가로 스택 뷰1{선택한 위치 라벨, 위치 설정 버튼} , 가로 스택 뷰2{결과 장소 수 라벨, 필터 버튼, 정렬조건 버튼} ]
        let svHorizontal = UIStackView()
        let btnSetLocation = UIButton(type: .system)
        let lblLocation = UILabel()
        let lblCountLocation = UILabel()
        let btnFilter = UIButton(type: .system)

        //Label Setting
        lblLocation.text = " 위치 정보 없음"
        lblLocation.textAlignment = .left
        lblCountLocation.text = " 1.5km 이내 n 곳"
        lblCountLocation.textAlignment = .right

        //Button Setting
        btnSetLocation.setTitle("", for: .normal)
        btnSetLocation.setImage(UIImage(named: "FocusLocation"), for: .normal)
        btnSetLocation.addTarget(self, action: #selector(gotoSetLocation), for: .touchUpInside)
        btnFilter.setTitle("", for: .normal)
        btnFilter.setImage(UIImage(named: "FilterBtn"), for: .normal)
        btnFilter.addTarget(self, action: #selector(filterLocation), for: .touchUpInside)

        //Stack Setting
        svHorizontal.addArrangedSubview(btnSetLocation)
        svHorizontal.addArrangedSubview(lblLocation)
        svHorizontal.addArrangedSubview(lblCountLocation)
        svHorizontal.addArrangedSubview(btnFilter)
        
        btnSetLocation.widthAnchor.constraint(equalTo: svHorizontal.heightAnchor, multiplier: 1).isActive = true
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

    // 위치 설정 이벤트
    @objc func gotoSetLocation(sender: UIButton){
        let goToVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "searchSetLocationView")
        let navigationController = UINavigationController(rootViewController: goToVC)
        self.present(navigationController, animated: true, completion: nil)
    }
    @objc func filterLocation(sender: UIButton){
        let goToVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "locationFilterView")
        self.present(goToVC, animated: true, completion: nil)
    }


    //MARK - PickerView
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return optionList.count
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return optionList[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        checkPv = true
//        typeValue = optionList[row]
//    }
//    @objc func sortingLocation(sender: UIButton){
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
//                (((self.view.subviews[0] as! UIStackView).arrangedSubviews[1] as! UIStackView).arrangedSubviews[2] as! UIButton).setTitle(self.typeValue, for: .normal)
//            } else {
//                (((self.view.subviews[0] as! UIStackView).arrangedSubviews[1] as! UIStackView).arrangedSubviews[2] as! UIButton).setTitle(self.optionList[0], for: .normal)
//            }
//        })
//        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
//
//        alertController.addAction(selectAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationViewController = segue.destination as! SetLocationViewController
        locationViewController.delegate = self
    }

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

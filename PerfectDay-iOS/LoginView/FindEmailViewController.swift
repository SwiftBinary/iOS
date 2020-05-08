//
//  FindEmailViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/04/07.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MaterialDesignWidgets

class FindEmailViewController: UIViewController, IndicatorInfoProvider {
    
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    let svMain = UIStackView()

    
    //Name
    let lblName = makeUILabel("이름")
    let tfName = makeUITextField("홍길동")
    
    //Birth
    let lblBirth = makeUILabel("생년월일")
    let tfBirth = makeUITextField("YYYY-MM-DD")
    
    //Gender
    let lblGender = makeUILabel("성별")
    let btnGenderM = MaterialButton(text: "남", textColor: .white, bgColor: #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1), cornerRadius: 15.0)
    let btnGenderF = MaterialButton(text: "여", textColor: #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1), bgColor: .white, cornerRadius: 15.0)
    let svGender = UIStackView()
    var valueGender = Gender.M
    
    var itemInfo: IndicatorInfo = "Email"
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
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }

    func setUI(){
        svMain.axis = .vertical
        svMain.spacing = 5
        
        tfName.addLeftPadding()
        tfBirth.addLeftPadding()
        tfName.addTarget(self, action: #selector(FieldDidChange), for: .editingChanged)
        tfBirth.addTarget(self, action: #selector(selectBirth), for: .editingDidBegin)

        btnGenderM.setCornerBorder(color: themeColor, cornerRadius: 15.0, borderWidth: 1.0)
        btnGenderF.setCornerBorder(color: themeColor, cornerRadius: 15.0, borderWidth: 1.0)
        btnGenderM.addTarget(self, action: #selector(selectMale), for: .touchUpInside)
        btnGenderF.addTarget(self, action: #selector(selectFemale), for: .touchUpInside)
        btnGenderM.rippleLayerColor = themeColor
        btnGenderF.rippleLayerColor = themeColor
        
        
        svGender.axis = .horizontal
        svGender.spacing = 10
        svGender.distribution = .fillEqually
        svGender.addArrangedSubview(btnGenderM)
        svGender.addArrangedSubview(btnGenderF)
        
        svMain.addArrangedSubview(lblName)
        svMain.addArrangedSubview(tfName)
        svMain.addArrangedSubview(makeUILabel(" "))
        
        svMain.addArrangedSubview(lblBirth)
        svMain.addArrangedSubview(tfBirth)
        svMain.addArrangedSubview(makeUILabel(" "))
        
        svMain.addArrangedSubview(lblGender)
        svMain.addArrangedSubview(svGender)
        
        svMain.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(svMain)
        view.backgroundColor = .white
        view.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        svMain.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        svMain.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    @objc func selectBirth() {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko")
        datePicker.timeZone = NSTimeZone.local
        datePicker.frame = CGRect(x: 0, y: 30, width: 270, height: 150)
        let alertController = UIAlertController(title: "생년월일", message: "\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.alert)
        alertController.view.addSubview(datePicker)
        let selectAction = UIAlertAction(title: "선택", style: UIAlertAction.Style.default, handler: { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.tfBirth.text = formatter.string(from: datePicker.date)
            self.FieldDidChange()
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion:{})
    }
    
    @objc func selectMale(){
        if valueGender != Gender.M {
            btnGenderM.setTextStyles(textColor: .white)
            btnGenderM.backgroundColor = themeColor
            btnGenderF.setTextStyles(textColor: themeColor)
            btnGenderF.backgroundColor = .white
            valueGender = Gender.M
        }
//        print(valueGender)
    }
    @objc func selectFemale(){
        if valueGender != Gender.F {
            btnGenderF.setTextStyles(textColor: .white)
            btnGenderF.backgroundColor = themeColor
            btnGenderM.setTextStyles(textColor: themeColor)
            btnGenderM.backgroundColor = .white
            valueGender = Gender.F
        }
//        print(valueGender)
    }
    
    @objc func FieldDidChange() {
        if (tfName.text!.count * tfBirth.text!.count) != 0 { // tfName.text != "" && tfBirth.text != "" {
            (parent?.parent as! FindBackViewController).btnFind.isEnabled = true
            (parent?.parent as! FindBackViewController).btnFind.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
        } else {
            (parent?.parent as! FindBackViewController).btnFind.isEnabled = false
            (parent?.parent as! FindBackViewController).btnFind.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
}

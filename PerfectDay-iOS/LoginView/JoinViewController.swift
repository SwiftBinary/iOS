//
//  JoinViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/04.
//  Copyright © 2020 문종식. All rights reserved.
//

//{
//"userType": "002",
//  "userRealName": "홍길동",
//  "userName": "testName",
//  "userEmail": "ydh@naver.com",
//  "userPw": "1234",
//  "userGender": "002",
//  "birthDt": "19950417",
//  "userAvgBudget": "002",
//  "loginType": "001",
//  "eatPref": "1110110000",
//  "drinkPref": "0110000000",
//  "playPref": "0101000000",
//  "watchPref": "1011110000",
//  "walkPref": "1111000000",
//  "setting": "100"
//}

import UIKit

class JoinViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    
    // Temp Outlet
    @IBOutlet var fieldEmail: UITextField!
    
    // Email
    @IBOutlet var fieldDomain: UITextField!
    @IBOutlet var fieldPw: UITextField!
    @IBOutlet var fieldPwCheck: UITextField!
    @IBOutlet var fieldName: UITextField!
    @IBOutlet var fieldBirth: UITextField!
    // Gender
    @IBOutlet var fieldNickName: UITextField!
    
    @IBOutlet var btnJoin: UIButton!
    
    var acceptList = [true,true,false]
    let domainList = ["직접입력","naver.com","hanmail.net","daum.net","gmail.com"]
    var domain = "직접입력"
    var checkPv = false
    
    var userRealName = ""
    var userName = ""
    var userEmail = ""
    var userPw = ""
    var userGender = ""
    var birthDt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        checkEditTextField()
        setUI()
    }
    
    // ##################################################
    // #################### 회원 가입 ######################
    // ##################################################
    func setScroll(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUI(){
        
        btnJoin.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        btnJoin.layer.cornerRadius = 5
        setField(fieldEmail, "이메일")
        setField(fieldPw, "영문, 숫자 포함 8 - 10자")
        setField(fieldPwCheck, "영문, 숫자 포함 8 - 10자")
        setField(fieldName,"홍길동")
        setField(fieldBirth, "YYYYMMDD ex)19980113")
        setField(fieldNickName, "한글, 영문, 숫자 10자 이내")
    }

    // TextField 값 변화 감지
    func checkEditTextField(){
        fieldName.addTarget(self, action: #selector(JoinViewController.FieldDidChange(_:)), for: UIControl.Event.editingChanged)
        fieldNickName.addTarget(self, action: #selector(JoinViewController.FieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func FieldDidChange(_ textField: UITextField) {
        checkField()
    }
    @objc func NameFieldDidChange(_ textField: UITextField) {
        checkField()
    }
    @objc func PhoneFieldDidChange(_ textField: UITextField) {
        checkField()
    }
    @objc func EmailFieldDidChange(_ textField: UITextField) {
        checkField()
    }
    
    func checkField(){
        if fieldNickName.text != "" && fieldName.text != "" {
            btnJoin.isEnabled = true
        } else {
            btnJoin.isEnabled = false
        }
        changeJoinBtn()
    }
    
    func changeJoinBtn() {
        if btnJoin.isEnabled {
            btnJoin.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
        } else {
            btnJoin.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    //MARK - PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return domainList.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return domainList[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        checkPv = true
        if row != 0{
            domain = domainList[row]
            fieldDomain.placeholder = ""
        } else {
            domain = ""
            fieldDomain.placeholder = domainList[row]
        }
    }
    
    @IBAction func selectDomain(_ sender: UIButton) {
        checkPv = false
        let alertController = UIAlertController(title: "선택", message: "\n\n\n\n", preferredStyle: UIAlertController.Style.alert)
        let sortingPicker = UIPickerView()
        alertController.view.addSubview(sortingPicker)
        sortingPicker.frame = CGRect(x: 10, y: 35, width: 250, height: 100)

        sortingPicker.dataSource = self
        sortingPicker.delegate = self
        
        let selectAction = UIAlertAction(title: "선택", style: .default, handler: { _ in
            if self.checkPv{
                self.fieldDomain.text = self.domain
            } else {
                self.fieldDomain.text = ""
                self.fieldDomain.placeholder = self.domainList[0]
            }
            
            if !self.fieldDomain.text!.isEmpty {
                self.fieldDomain.isEnabled = false
            } else {
                self.fieldDomain.isEnabled = true
            }
        })
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)

    }
    
    
    @IBAction func selectBirth(_ sender: UITextField) {
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
            self.fieldBirth.text = formatter.string(from: datePicker.date)
            //self.checkField()
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion:{})
    }
    
}

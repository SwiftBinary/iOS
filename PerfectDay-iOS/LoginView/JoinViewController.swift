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
import MaterialDesignWidgets
import SwiftyJSON
import Alamofire
import CryptoSwift

class JoinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
//    let developIP = "http://203.252.161.96:8080"
    let operationIP = OperationIP
    
    // View
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var svGender: UIStackView!
    
    // TextField
    @IBOutlet var fieldEmail: UITextField!
    @IBOutlet var fieldDomain: UITextField!
    @IBOutlet var fieldPw: UITextField!
    @IBOutlet var fieldPwCheck: UITextField!
    @IBOutlet var fieldName: UITextField!
    @IBOutlet var fieldBirth: UITextField!
    let btnGenderM = MaterialButton(text: "남", textColor: .white, bgColor: #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1), cornerRadius: 0.0)
    let btnGenderF = MaterialButton(text: "여", textColor: #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1), bgColor: .white, cornerRadius: 0.0)
    @IBOutlet var fieldNickName: UITextField!
    
    // Label Guide
    @IBOutlet var lblEmailGuide: UILabel!
    @IBOutlet var lblPwGuide: UILabel!
    @IBOutlet var lblPwCheckGuide: UILabel!
    @IBOutlet var lblNameGuide: UILabel!
    @IBOutlet var lblNickNameGuide: UILabel!
    
    @IBOutlet var btnNickNameCheck: MaterialButton!
    @IBOutlet var btnJoin: UIButton!
    
    let grayColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1) //e6e6e6
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    var marketingAccept = "0"
    
    let domainList = ["직접입력","naver.com","hanmail.net","daum.net","gmail.com"]
    var domain = "직접입력"
    var checkPv = false
    
    var userRealName = ""
    var userName = ""
    var userEmail = ""
    var userPw = ""
    var userGender = "001" // 나중에 고쳐!
    var userBirth = ""
    
    var possibleEmail = false
    var possiblePw = false
    var possiblePwCheck = false
    var possibleName = false
    var possibleBirth = false
    var possibleNickName = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
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
        setField(fieldDomain, "직접입력")
        setField(fieldPw, "영문, 숫자 포함 8 - 16자")
        setField(fieldPwCheck, "영문, 숫자 포함 8 - 16자")
        setField(fieldName,"홍길동")
        setField(fieldBirth, "YYYYMMDD ex)1998-01-13")
        setField(fieldNickName, "한글, 영문, 숫자 10자 이내")
        fieldBirth.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectBirth(_:))))
        btnNickNameCheck.setCornerBorder(color: themeColor, cornerRadius: 5.0, borderWidth: 1.0)
        btnGenderM.setCornerBorder(color: themeColor, cornerRadius: 15.0, borderWidth: 1.0)
        btnGenderF.setCornerBorder(color: themeColor, cornerRadius: 15.0, borderWidth: 1.0)
        btnGenderM.addTarget(self, action: #selector(selectMale), for: .touchUpInside)
        btnGenderF.addTarget(self, action: #selector(selectFemale), for: .touchUpInside)
        btnGenderM.rippleLayerColor = themeColor
        btnGenderF.rippleLayerColor = themeColor

        let svSelectGender = UIStackView()
        svSelectGender.axis = .horizontal
        svSelectGender.spacing = 10
        svSelectGender.distribution = .fillEqually
        svSelectGender.addArrangedSubview(btnGenderM)
        svSelectGender.addArrangedSubview(btnGenderF)
        svGender.addArrangedSubview(svSelectGender)
    }
    
    // #############################################
    //                Editing Changed
    // #############################################
    @IBAction func guideEmail(_ sender: UITextField) {
        var strEmailGuide = " "
        var strDomainGuide = " "
        let domainPattern = "([0-9a-zA-Z_-]+)(\\.[a-zA-Z]+)"
        if let _ = fieldDomain.text!.range(of: domainPattern, options: [.regularExpression]) {
            strDomainGuide = " "
        } else {
            strDomainGuide = "도메인이 형식을 확인해주세요."
        }
        strEmailGuide = fieldEmail.text!.isEmpty ? "이메일을 입력해주세요. " : ""
        lblEmailGuide.text = strEmailGuide + strDomainGuide
        possibleEmail = (lblEmailGuide.text == " ") ? true : false
        checkField()
        // 이미 존재하는 이메일입니다.
    }
    @IBAction func guidePw(_ sender: UITextField) {
        possiblePw = false
        switch fieldPw.text!.count {
        case 0:
            lblPwGuide.text = "비밀번호를 입력해주세요."
        case 0..<8:
            lblPwGuide.text = "비밀번호는 8자 이상이어야 합니다."
        case 17...:
            lblPwGuide.text = "비밀번호는 16자를 넘을 수 없습니다."
        default:
            lblPwGuide.text = " "
            possiblePw = true
        }
        checkField()
    }
    @IBAction func guidePwCheck(_ sender: UITextField) {
        lblPwCheckGuide.text = (fieldPwCheck.text == fieldPw.text) ? " " : "비밀번호가 일치하지 않습니다."
        possiblePwCheck = (lblPwCheckGuide.text==" ")&&possiblePw ? true : false
        checkField()
    }
    @IBAction func guideName(_ sender: UITextField) {
        lblNameGuide.text = fieldName.text!.isEmpty ? "이름을 입력해주세요." : " "
        possibleName = !fieldName.text!.isEmpty
        checkField()
    }
    @IBAction func guideNickName(_ sender: UITextField) {
        lblNickNameGuide.text = fieldNickName.text!.isEmpty ? "닉네임을 입력해주세요." : " "
        btnNickNameCheck.isEnabled = !fieldNickName.text!.isEmpty
        btnNickNameCheck.backgroundColor = btnNickNameCheck.isEnabled ? .white : grayColor
        checkField()
    }
    
    // 수정하기
    func checkField(){
//        print("#############")
//        print(possibleEmail)
//        print(possiblePw)
//        print(possiblePwCheck)
//        print(possibleName)
//        print(possibleNickName)
//        print(possibleBirth)
//        print("**********")
//        print(possibleEmail&&possiblePw&&possiblePwCheck&&possibleName&&possibleNickName&&possibleBirth)
        if possibleEmail&&possiblePw&&possiblePwCheck&&possibleName&&possibleNickName&&possibleBirth{
            userRealName = fieldName.text!
            userName = fieldNickName.text!
            userEmail = fieldEmail.text! + "@" + fieldDomain.text!
            userPw = fieldPwCheck.text!
            btnJoin.isEnabled = true
            btnJoin.backgroundColor = themeColor
        } else {
            btnJoin.isEnabled = false
            btnJoin.backgroundColor = .lightGray
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
        domain = (row != 0) ? domainList[row] : ""
        //        fieldDomain.placeholder = (row != 0) ? "" : domainList[row]
        //        if row != 0{
        //            domain = domainList[row]
        //            fieldDomain.placeholder = ""
        //        } else {
        //            domain = ""
        //            fieldDomain.placeholder = domainList[row]
        //        }
    }
    
    @objc func selectDomain(_ sender: UIButton) {
        checkPv = false
        let alertController = UIAlertController(title: "선택", message: "\n\n\n\n", preferredStyle: UIAlertController.Style.alert)
        let sortingPicker = UIPickerView()
        alertController.view.addSubview(sortingPicker)
        sortingPicker.frame = CGRect(x: 10, y: 35, width: 250, height: 100)
        
        sortingPicker.dataSource = self
        sortingPicker.delegate = self
        
        let selectAction = UIAlertAction(title: "선택", style: .default, handler: { _ in
            self.fieldDomain.text = self.checkPv ? self.domain : ""
            self.fieldDomain.isEnabled = self.fieldDomain.text!.isEmpty
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
        let alertController = UIAlertController(title: "생년월일", message: "\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
        datePicker.frame = CGRect(x: 0, y: 30, width:alertController.view.frame.width, height: 150)
        alertController.view.addSubview(datePicker)
        let selectAction = UIAlertAction(title: "완료", style: UIAlertAction.Style.default, handler: { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.fieldBirth.text = formatter.string(from: datePicker.date)
            self.userBirth = (formatter.string(from: datePicker.date)).replacingOccurrences(of: "-", with: "")
            self.possibleBirth = true
            self.checkField()
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)

        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
//                alertController.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .centerX, relatedBy: .equal, toItem: alertController.view, attribute: .centerX, multiplier: 1, constant: 0))
        present(alertController, animated: true, completion:{})
    }
    
    @objc func selectMale(){
        if userGender != "001" {
            btnGenderM.setTextStyles(textColor: .white)
            btnGenderM.backgroundColor = themeColor
            btnGenderF.setTextStyles(textColor: themeColor)
            btnGenderF.backgroundColor = .white
            userGender = "001"
        }
    }
    @objc func selectFemale(){
        if userGender != "002" {
            btnGenderF.setTextStyles(textColor: .white)
            btnGenderF.backgroundColor = themeColor
            btnGenderM.setTextStyles(textColor: themeColor)
            btnGenderM.backgroundColor = .white
            userGender = "002"
        }
    }
    
    @IBAction func retrieveNickName(_ sender: UIButton) {
        let userNickName = fieldNickName.text
        let url = operationIP + "/user/retrieveUserName.do"
        let jsonHeader = JSON(["userSn":"_","deviceOS":"IOS"])
        let parameter = JSON([
            "userName":userNickName,
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["json":convertedHeaderString]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                let responseJSON = JSON(response.value!)
                print(responseJSON["result"].intValue)
//                print(type(of: responseJSON["result"]))
                self.possibleNickName = (responseJSON["result"].intValue == 0) ? true : false
                self.lblNickNameGuide.text = self.possibleNickName ? "사용가능한 닉네임입니다." : "이미 존재하는 닉네임입니다."
                self.checkField()
            }
        }
    }
    
    @IBAction func tempJoin(_ sender: UIButton) {
    }
    
    @IBAction func completeJoin(_ sender: UIButton) {
        let retrieveUserEmail  = fieldEmail.text! + "@" + fieldDomain.text!
        let url = operationIP + "/user/retrieveUserEmail.do"
        let jsonHeader = JSON(["userSn":"_","deviceOS":"IOS"])
        let parameter = JSON([
            "userName":retrieveUserEmail,
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["json":convertedHeaderString]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                let responseJSON = JSON(response.value!)
                print(responseJSON["result"].intValue)
                //                print(type(of: responseJSON["result"]))
                let possibleThisEmail = (responseJSON["result"].intValue == 0) ? true : false
                self.lblEmailGuide.text = possibleThisEmail ? " " : "이미 존재하는 이메일입니다."
                self.possibleEmail = possibleThisEmail ? true : false
                self.checkField()
                if possibleThisEmail { self.requestJoin() }
            }
        }
    }
    
    func requestJoin() {
        let url = operationIP + "/user/insertUserInfo.do"
        let jsonHeader = JSON(["userSn":"_","deviceOS":"IOS"])
        let parameter = JSON([
            "userType" : "002",
            "userRealName": userRealName,
            "userName": userName,
            "userEmail": userEmail,
            "userPw": userPw.sha256(),
            "userGender":userGender,
            "birthDt": userBirth,
            "userAvgBudget": "002",
            "loginType": "001",
            "eatPref": "0000000000",
            "drinkPref": "0000000000",
            "playPref": "0000000000",
            "watchPref": "0000000000",
            "walkPref": "0000000000",
            "setting": marketingAccept + "00",
        ])
//        print(parameter)
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["json":convertedHeaderString]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                let responseJSON = JSON(response.value!)
                print(responseJSON["result"].intValue)
                //                print(type(of: responseJSON["result"]))
                let joinSuccess = (responseJSON["result"].intValue == 1) ? true : false
                joinSuccess ? self.successJoin() : self.alertControllerDefault(title: "가입 실패", message: "가입에 실패했습니다.\n잠시 후 다시 시도해주세요.")
            }
        }
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
    }
    
    func successJoin(){
        let alertController = UIAlertController(title: "가입완료", message: "환영합니다!", preferredStyle: UIAlertController.Style.alert)
        let acceptAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default , handler: { _ in
            let navigationVCList = self.navigationController!.viewControllers
            self.navigationController?.popToViewController(navigationVCList[navigationVCList.count-3], animated: true)
        })
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion:{})
    }
}

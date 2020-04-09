//
//  FindViewController_temp.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/04.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MaterialDesignWidgets
import Hero

class FindViewController_temp: UIViewController {

    @IBOutlet var svFirst: UIStackView!
    
    @IBOutlet var emailStack: UIStackView!
    @IBOutlet var segmentControl: UISegmentedControl!

    @IBOutlet var tempView: UIView!
    
    var findEmail = true
    var genderValue = true

    @IBOutlet var fieldName: UITextField!
    @IBOutlet var fieldEmail: UITextField!
    @IBOutlet var fieldBirth: UITextField!
    @IBOutlet var btnFind: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEditTextField()
        hideKeyboard()
        setUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findIdentifier" {
            let showInfoViewController = segue.destination as! ShowInfoViewController
            showInfoViewController.userEmail = fieldEmail.text!
            showInfoViewController.userName = fieldName.text!
            showInfoViewController.userBirth = fieldBirth.text!.replacingOccurrences(of: "-", with: "")
            showInfoViewController.userGender = genderValue ? "001" : "002"
            showInfoViewController.findEmail = findEmail
        }
        // segue.indentifier -> 스토리보드 화살표(노드) segue Indentifier 명
        
    }
    
    
    func setUI(){
        btnFind.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        btnFind.layer.cornerRadius = 5
        setField(fieldEmail, "이메일")
        setField(fieldName,"홍길동")
        setField(fieldBirth, "YYYY-MM-DD")
        //
        let sgLine = MaterialSegmentedControl(selectorStyle: .line, textColor: .black, selectorTextColor: .black, selectorColor: .black, bgColor: .white)
        for i in 0..<2 {
            let button = MaterialButton(text: "Segment \(i)", textColor: .gray, bgColor: .clear, cornerRadius: 0.0)
            button.rippleLayerAlpha = 0.15
//            button.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)?
            sgLine.segments.append(button)
        }
        
        svFirst.insertArrangedSubview(sgLine, at: 0)
    }

    // TextField 값 변화 감지
    func checkEditTextField(){
        fieldName.addTarget(self, action: #selector(JoinViewController.FieldDidChange(_:)), for: UIControl.Event.editingChanged)
        fieldEmail.addTarget(self, action: #selector(JoinViewController.FieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func FieldDidChange(_ textField: UITextField) {
        checkField()
    }
    
    func checkField(){
        if fieldName.text != "" && fieldBirth.text != "" {
            if emailStack.isHidden { // ID Find
                btnFind.isEnabled = true
            } else { // PW Find
                if fieldEmail.text != "" {
                    btnFind.isEnabled = true
                } else {
                    btnFind.isEnabled = false
                }
            }
        } else {
            btnFind.isEnabled = false
        }
        btnFind.backgroundColor = btnFind.isEnabled ? #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1) : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        changeFindBtn()
    }
    
    func changeFindBtn() {
        btnFind.backgroundColor = btnFind.isEnabled ? #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1) : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//        if btnFind.isEnabled {
//            btnFind.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
//        } else {
//            btnFind.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//        }
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
            self.checkField()
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion:{})
    }
    
    
    @IBAction func idpwChange(_ sender: UISegmentedControl) {
        emailStack.isHidden = sender.selectedSegmentIndex == 0 ? true : false
        findEmail = sender.selectedSegmentIndex == 0 ? true : false
//        if sender.selectedSegmentIndex == 0 { // ID
//            emailStack.isHidden = true
//            findEmail = true
//        } else if sender.selectedSegmentIndex == 1 { // PW
//            emailStack.isHidden = false
//            findEmail = false
//        }
    }
    
    @IBAction func genderChange(_ sender: UISegmentedControl) {
        genderValue = sender.selectedSegmentIndex == 0 ? true : false
//        if  sender.selectedSegmentIndex == 0 {
//            tempView.hero.modifiers
//        } else if sender.selectedSegmentIndex == 1 {
//            genderValue = false
//        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  FindBackViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/04/07.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class FindBackViewController: UIViewController {

    @IBOutlet var btnFind: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findIdentifier" {
            let showInfoViewController = segue.destination as! ShowInfoViewController
            let childViewType = type(of: children[0].children[0])
            switch childViewType {
            case is FindEmailViewController.Type:
                let childView = children[0].children[0] as! FindEmailViewController
                showInfoViewController.userName = childView.tfName.text!
                showInfoViewController.userBirth = childView.tfBirth.text!.replacingOccurrences(of: "-", with: "")
                showInfoViewController.userGender = (childView.valueGender == Gender.M) ? "001" : "002"
                showInfoViewController.findEmail = true
            case is FindPWViewController.Type:
                let childView = children[0].children[0] as! FindPWViewController
                showInfoViewController.userName = childView.tfName.text!
                showInfoViewController.userEmail = childView.tfEmail.text!
                showInfoViewController.userBirth = childView.tfBirth.text!.replacingOccurrences(of: "-", with: "")
                showInfoViewController.userGender = (childView.valueGender == Gender.M) ? "001" : "002"
                showInfoViewController.findEmail = false
            default:
                break
            }
        }
        //            showInfoViewController.userId = fieldEmail.text!
        //            showInfoViewController.userName = fieldName.text!
        //            showInfoViewController.userBirth = fieldBirth.text!.replacingOccurrences(of: "-", with: "")
        //            showInfoViewController.userGender = genderValue ? "001" : "002"
        //            showInfoViewController.findEmail = findEmail
    }
    // segue.indentifier -> 스토리보드 화살표(노드) segue Indentifier 명
}

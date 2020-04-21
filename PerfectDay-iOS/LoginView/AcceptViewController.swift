//
//  AcceptViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/26.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class AcceptViewController: UIViewController {

    @IBOutlet var btnAllAccept: UIButton!
    @IBOutlet var btnPersonalAccept: UIButton!
    @IBOutlet var btnLocationAccept: UIButton!
    @IBOutlet var btnMarketingAccept: UIButton!
    @IBOutlet var btnAccept: UIButton!
    var acceptAarry: Array<Bool> = [false, false, false, false, false]
    // 전체, 개인 정보 활용, 위치 정보 활용, 마케팅 정보 수신 동의
    var checkImageOn = UIImage(named: "check_circle_on")
    var checkImageOff = UIImage(named: "check_circle_off")

    @IBOutlet var bgAllAccept: UIView!
    @IBOutlet var bgPersonAccept: UIView!
    @IBOutlet var bgLocationAccept: UIView!
    @IBOutlet var bgMarketingAccept: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBorder(bgAllAccept)
        setViewBorder(bgPersonAccept)
        setViewBorder(bgLocationAccept)
        setViewBorder(bgMarketingAccept)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "joinIdentifier" {
            let joinViewController = segue.destination as! JoinViewController
            joinViewController.marketingAccept = acceptAarry[3] ? "1" : "0"
        }
    }
    
    // ##################################################
    // #################### 이용약관 ######################
    // ##################################################
    // 동의하기 버튼 활성화 판단
    func isAllAccept() {
        if acceptAarry[1] && acceptAarry[2] {
            acceptAarry[4] = true
            btnAccept.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
            if acceptAarry[3] {
                acceptAarry[0] = true
                btnAllAccept.setImage(checkImageOn, for: .normal)
            } else {
                acceptAarry[0] = false
                btnAllAccept.setImage(checkImageOff, for: .normal)
            }
            btnAccept.isEnabled = true
        } else {
            acceptAarry[0] = false
            acceptAarry[4] = false
            btnAccept.backgroundColor = .lightGray
            btnAllAccept.setImage(checkImageOff, for: .normal)
            btnAccept.isEnabled = false
        }
        print(acceptAarry)
    }
    // 모두 동의 눌렀을 때
    @IBAction func allAccept(_ sender: UIButton) {
        if !acceptAarry[0] { // Off -> On
            btnAllAccept.setImage(checkImageOn, for: .normal)
            btnPersonalAccept.setImage(checkImageOn, for: .normal)
            btnLocationAccept.setImage(checkImageOn, for: .normal)
            btnMarketingAccept.setImage(checkImageOn, for: .normal)
            for i in 0..<acceptAarry.count-1 {
                acceptAarry[i] = true
            }
        } else{ // On -> Off
            btnAllAccept.setImage(checkImageOff, for: .normal)
            btnPersonalAccept.setImage(checkImageOff, for: .normal)
            btnLocationAccept.setImage(checkImageOff, for: .normal)
            btnMarketingAccept.setImage(checkImageOff, for: .normal)
            for i in 0..<acceptAarry.count-1 {
                acceptAarry[i] = false
            }
        }
        isAllAccept()
    }
    
    // 체크박스 이벤트
    func acceptFunc(_ Btn: UIButton, index: Int) {
        if !acceptAarry[index] { // Off -> On
            Btn.setImage(checkImageOn, for: .normal)
            acceptAarry[index] = true
        } else { // On -> Off
            Btn.setImage(checkImageOff, for: .normal)
            acceptAarry[index] = false
        }
    }
    
    // 개인정보 동의 눌렀을 때
    @IBAction func personalAccept(_ sender: UIButton) {
        acceptFunc(btnPersonalAccept, index: 1)
        isAllAccept()
    }
    // 위치 정보 활용 동의 눌렀을 때
    @IBAction func LocationAccept(_ sender: UIButton) {
        acceptFunc(btnLocationAccept, index: 2)
        isAllAccept()
    }
    // 마케팅 정보 수신 동의 눌렀을 때
    @IBAction func marketingAccept(_ sender: UIButton) {
        acceptFunc(btnMarketingAccept, index: 3)
        isAllAccept()
    }
    
    @IBAction func startJoin(_ sender: UIButton) {
        
    }
    
    @IBAction func showPersonalContent(_ sender: UIButton) {
        let goToVC = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "acceptContentView")
        self.present(goToVC, animated: true, completion: nil)
    }
    @IBAction func showLocationContent(_ sender: UIButton) {
        let goToVC = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "acceptContentView")
        self.present(goToVC, animated: true, completion: nil)
    }
    @IBAction func showMarketingContent(_ sender: UIButton) {
        let goToVC = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "acceptContentView")
        self.present(goToVC, animated: true, completion: nil)
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

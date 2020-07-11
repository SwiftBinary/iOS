//
//  MyPageViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MaterialDesignWidgets

class MyPageViewController: UIViewController {
    
    @IBOutlet var lblUserNickName: UILabel!
    @IBOutlet var lblUserEmail: UILabel!
    @IBOutlet var scvRecentlyStore: UIScrollView!
    @IBOutlet var svRecentlyStore: UIStackView!
    @IBOutlet var lblRecentlyStoreEmpty: UILabel!
    @IBOutlet var svServiceCenter: UIStackView!
    
    var arrayServiceBtn : Array<MaterialVerticalButton> = []
    var userDTO:UserDTO!

    let grayColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) //e6e6e6
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileUI()
//        setServiceCenter()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        let recentlyStoreData = UserDefaults.standard.value(forKey: recentlyStoreKey) as! Array<String>
        setRecentlyStoreList(recentlyStoreData)
        print("##########")
        print(recentlyStoreData)
    }
    
    //##### 프로필 정보 #####
    //
    func setProfileUI() {
//        print(JSON(UserDefaults.standard.value(forKey: "userJSONData")!))
        userDTO = UserDTO(jsonData: JSON(UserDefaults.standard.value(forKey: "userJSONData")!))
        lblUserNickName.text  = userDTO.userName
        lblUserEmail.text = userDTO.userEmail
        lblUserEmail.font = UIFont.systemFont(ofSize: 15)
    }
    @IBAction func logout(_ sender: UIButton) {
        let alertController = UIAlertController(title: "정말 로그아웃 하시겠습니까?", message: "", preferredStyle: UIAlertController.Style.alert)
        let acceptAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default , handler: { _ in
            UserDefaults.standard.removeObject(forKey: userDataKey)
            UserDefaults.standard.set(0, forKey: plannerNumKey)
            let arrStoreSnList : Array<String> = []
            UserDefaults.standard.set(arrStoreSnList, forKey: "StoreSnList")
            let arrRecentlyStore : Array<String> = []
            UserDefaults.standard.set(arrRecentlyStore, forKey: recentlyStoreKey)
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel , handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion:{})
    }
    
    //##### 최근 본 목록 #####
    //
    func setRecentlyStoreList(_ listSn : Array<String>) {
        lblRecentlyStoreEmpty.isHidden = !listSn.isEmpty
        svRecentlyStore.removeSubviews()
        scvRecentlyStore.isHidden = listSn.isEmpty
        for store in listSn {
            let imageView = makeImageView(store)
            svRecentlyStore.addArrangedSubview(imageView)
        }
    }
    func makeImageView(_ store : String) -> UIImageView{
        let imageView = UIImageView(image: UIImage(named: "TempImage"))
        let storeSn = String(store.split(separator: " ")[0])
        let urlImage = String(store.split(separator: " ")[1])
        if urlImage != "." {
            let url = URL(string: urlImage)
            let data = try? Data(contentsOf: url!)
            if data != nil {
                imageView.image = UIImage(data: data!)
            }
        }
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        print(storeSn)
        imageView.accessibilityIdentifier = storeSn
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationInfo(_:))))
        return imageView
    }
    @objc func gotoLocationInfo(_ sender: UITapGestureRecognizer){
        let locationSn = sender.view!.accessibilityIdentifier
        let url = OperationIP + "/store/selectStoreInfo.do"
        let parameter = JSON([
            "storeSn": locationSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                locationData = JSON(response.value!)
                print(locationData)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let goToVC = storyboard.instantiateViewController(withIdentifier: "locationInfoView") as? LocationViewController else {
                    //아니면 종료
                    return
                }
                self.navigationController?.pushViewController(goToVC, animated: true)
            }
        }
    }
    @IBAction func clearRecentlyStore(_ sender: UIButton) {
        let recentlyStoreData:Array<String> = []
        UserDefaults.standard.set(recentlyStoreData,forKey: recentlyStoreKey)
        lblRecentlyStoreEmpty.isHidden = false
        scvRecentlyStore.isHidden = true
        svRecentlyStore.removeSubviews()
    }
    
    //##### 고객센터 #####
    //
    func setServiceCenter(){
        let btnCompany = MaterialVerticalButton(icon: UIImage(named: "IntroBtn")!, text: "소개페이지", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnInsta = MaterialVerticalButton(icon: UIImage(named: "InstaBtn")!, text: "회사 SNS", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnNaver = MaterialVerticalButton(icon: UIImage(named: "NaverBtn")!, text: "회사블로그", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnKakao = MaterialVerticalButton(icon: UIImage(named: "KakaoBtn")!, text: "1:1 문의", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnSuggest = MaterialVerticalButton(icon: UIImage(named: "InstaBtn")!, text: "장소 제안", font: nil ,foregroundColor: .white, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        arrayServiceBtn = [btnCompany,btnInsta,btnNaver,btnKakao,btnSuggest]
        for btn in arrayServiceBtn {
            svServiceCenter.addArrangedSubview(btn)
            btn.label.textColor = .black
            btn.label.font = .systemFont(ofSize: 13)
            btn.rippleLayerColor = grayColor        }
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

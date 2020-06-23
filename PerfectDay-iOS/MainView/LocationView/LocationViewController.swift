//
//  LocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/05/28.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MaterialDesignWidgets
import Alamofire
import SwiftyJSON

class LocationViewController: UIViewController {
    
    @IBOutlet var uvPlannerBack: UIView!
    @IBOutlet var btnAddPlanner: UIButton!
    @IBOutlet var btnPlanner: UIButton!
    
    let uds = UserDefaults.standard
    let userData = getUserData()
    let locationSn = locationData["storeSn"].stringValue
    
    var btnLike = UIBarButtonItem()
    var isDisLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        requestDid(btnLike)
        setPlannerUI()
        // Do any additional setup after loading the view.
    }

    func setNavigationUI(){
        self.tabBarController?.tabBar.isHidden = true
        btnLike = UIBarButtonItem(image: UIImage(named: isDisLocation ? "DibsOnBtn" : "DibsBtn"), style: .plain, target: self, action: #selector(setPickInfo(_:)))
        btnLike.tintColor = isDisLocation ? #colorLiteral(red: 1, green: 0.3921568627, blue: 0.568627451, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        btnLike.style = .plain
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = locationData["storeNm"].stringValue
        self.navigationItem.rightBarButtonItem = btnLike
    }
    func requestDid(_ btnDids: UIBarButtonItem){
        let url = OperationIP + "/pick/selectExistPickInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        let parameter = JSON([
            "storeSn": locationSn,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
//            debugPrint(response)
            if response.value != nil {
                let reponseJSON = JSON(response.value!)
                print(reponseJSON)
                if reponseJSON["result"].stringValue == "0" {
                    self.isDisLocation = false
                } else {
                    self.isDisLocation = true
                }
                self.setNavigationUI()
            }
        }
    }
    @objc func setPickInfo(_ sender: UIBarButtonItem){
        if isDisLocation {
            deletePickInfo()
        } else {
            insertPickInfo()
        }
    }
    func insertPickInfo() {
        let url = OperationIP + "/pick/insertPickInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        let parameter = JSON([
            "storeSn": locationSn,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                let reponseJSON = JSON(response.value!)
                if reponseJSON["result"].stringValue == "1" {
                    self.isDisLocation = true
                }
                self.setDibsBtn()
            }
        }
    }
    func deletePickInfo() {
        let url = OperationIP + "/pick/deletePickInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        let parameter = JSON([
            "storeSn": locationSn,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                let reponseJSON = JSON(response.value!)
                if reponseJSON["result"].stringValue == "1" {
                    self.isDisLocation = false
                }
                self.setDibsBtn()
            }
        }
    }
    func setDibsBtn(){
        btnLike.image = UIImage(named: isDisLocation ? "DibsOnBtn" : "DibsBtn")
        btnLike.tintColor = isDisLocation ? #colorLiteral(red: 1, green: 0.3921568627, blue: 0.568627451, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func setPlannerUI(){
        let imageSize:CGFloat = 15
        let lblLoationIndex = UILabel()
        lblLoationIndex.translatesAutoresizingMaskIntoConstraints = false
        lblLoationIndex.text = "1"
        lblLoationIndex.textColor = .white
        lblLoationIndex.textAlignment = .center
//        lblLoationIndex.fontSize = 10
        lblLoationIndex.font = UIFont.boldSystemFont(ofSize: 10)
        lblLoationIndex.backgroundColor = .systemBlue
        lblLoationIndex.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        lblLoationIndex.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        lblLoationIndex.layer.masksToBounds = true
        lblLoationIndex.layer.cornerRadius = imageSize * (1/3)
        btnPlanner.addSubview(lblLoationIndex)
        lblLoationIndex.centerXAnchor.constraint(equalTo: btnPlanner.leadingAnchor, constant: imageSize*0.5).isActive = true
        lblLoationIndex.centerYAnchor.constraint(equalTo: btnPlanner.topAnchor, constant:  imageSize*0.5).isActive = true

        uvPlannerBack.backgroundColor = .white
        uvPlannerBack.layer.cornerRadius = 15
        uvPlannerBack.layer.shadowColor = UIColor.lightGray.cgColor
        uvPlannerBack.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        uvPlannerBack.layer.shadowRadius = 2.0
        uvPlannerBack.layer.shadowOpacity = 0.9
        uvPlannerBack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        btnAddPlanner.layer.cornerRadius = 5
        btnAddPlanner.layer.borderColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
        btnAddPlanner.layer.borderWidth = 0.5
        btnAddPlanner.backgroundColor = #colorLiteral(red: 1, green: 0.9333333333, blue: 0.8588235294, alpha: 1)
    }
    
    @IBAction func goToPlanner(_ sender: UIButton) {
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "plannerView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
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

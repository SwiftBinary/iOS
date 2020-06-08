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
    
    let userData = getUserData()
    //    let locationData = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        getLocationInfo()
        setNavigationUI()
        setPlannerUI()
        // Do any additional setup after loading the view.
    }
    func getLocationInfo(){
        if (UserDefaults.standard.string(forKey: locationSnKey) != nil) {
            let locationSn = UserDefaults.standard.string(forKey: locationSnKey)!
            let url = OperationIP + "/store/selectStoreInfo.do"
            let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
            let parameter = JSON([
                "storeSn": locationSn,
            ])
            let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
                //                  debugPrint(response)
                if response.value != nil {
                    let reponseJSON = JSON(response.value!)
                    print(reponseJSON)
                }
            }
        }
    }
    
    func setNavigationUI(){
        self.tabBarController?.tabBar.isHidden = true
        let btnLike = UIBarButtonItem(image: UIImage(named: "DibsBtn"), style: .plain, target: self, action: nil)
        self.navigationItem.title = "장소명"
        self.navigationItem.rightBarButtonItem = btnLike
    }
    
    func setPlannerUI(){
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

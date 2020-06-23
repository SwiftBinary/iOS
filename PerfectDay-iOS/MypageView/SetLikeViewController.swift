//
//  SetLikeViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/24.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MaterialDesignWidgets
import Alamofire
import SwiftyJSON

class SetLikeViewController: UIViewController {

    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    
    @IBOutlet var svCategory: UIStackView!
    
    @IBOutlet var svEat: UIStackView!
    
    @IBOutlet var uvEat: UIView!
    @IBOutlet var uvDrink: UIView!
    @IBOutlet var uvPlay: UIView!
    @IBOutlet var uvWatch: UIView!
    @IBOutlet var uvWalk: UIView!
    
    let userData = getUserData()
    
    //Eat
    let btnRice = MaterialVerticalButton()
    let btnMeat = MaterialVerticalButton()
    let btnNoodle = MaterialVerticalButton()
    let btnSeafood = MaterialVerticalButton()
    let btnStreetfood = MaterialVerticalButton()
    let btnFastfood = MaterialVerticalButton()
    
    //Drink
    @IBOutlet var btnCoffee: UIButton!
    @IBOutlet var btnTea: UIButton!
    @IBOutlet var btnDessert: UIButton!
    @IBOutlet var btnBeer: UIButton!
    @IBOutlet var btnSoju: UIButton!
    @IBOutlet var btnMakgeolli: UIButton!
    @IBOutlet var btnCocktail: UIButton!
    
    //Play
    @IBOutlet var btnGame: UIButton!
    @IBOutlet var btnVR: UIButton!
    @IBOutlet var btnIndoorActivity: UIButton!
    @IBOutlet var btnOutdoorActivity: UIButton!
    @IBOutlet var btnReading: UIButton!
    @IBOutlet var btnHealing: UIButton!
    @IBOutlet var btnMaking: UIButton!
    
    //Watch
    @IBOutlet var btnMovie: UIButton!
    @IBOutlet var btnSport: UIButton!
    @IBOutlet var btnExhibition: UIButton!
    @IBOutlet var btnPerformance: UIButton!
    
    //Walk
    @IBOutlet var btnMarket: UIButton!
    @IBOutlet var btnPark: UIButton!
    @IBOutlet var btnThemeStreet: UIButton!
    @IBOutlet var btnLandscape: UIButton!
    
    var openList = [true,false,false,false,false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userData)
        setUI()
        setUIView()
        
        setEatUI()
    }
    
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
    }
    func setUIView(){
        let uvList: Array<UIView> = [uvEat,uvDrink,uvPlay,uvWatch,uvWalk]
        for (index, uv) in uvList.enumerated() {
            uv.backgroundColor = .white
            uv.layer.cornerRadius = 15.0
            uv.layer.shadowColor = UIColor.lightGray.cgColor
            uv.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            uv.layer.shadowRadius = 2.0
            uv.layer.shadowOpacity = 0.9
            uv.tag = index
            uv.subviews[0].subviews[0].tag = index
            uv.subviews[0].subviews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCategory(_:))))
        }
    }
    
    @objc func openCategory(_ sender: UITapGestureRecognizer){
        let viewTag = sender.view!.tag
        let openedViewTag = openList.contains(true) ? openList.firstIndex(of: true) : -1
        
        clipView(viewIndex: viewTag)
        if (openedViewTag != -1) && (viewTag != openedViewTag) {
            clipView(viewIndex: openedViewTag!)
        }
    }
    func clipView(viewIndex: Int) {
        for subIndex in 1..<svCategory.arrangedSubviews[viewIndex].subviews.first!.subviews.endIndex {
            svCategory.arrangedSubviews[viewIndex].subviews.first!.subviews[subIndex].isHidden = openList[viewIndex]
        }
        openList[viewIndex] = !openList[viewIndex]
        (svCategory.arrangedSubviews[viewIndex].subviews.first!.subviews.first!.subviews.last as! UIImageView).image = openList[viewIndex] ? UIImage(named: "upArrow") : UIImage(named: "downArrow")
    }
    @IBAction func gotoBack(_ sender: UIButton) {
        updateUserPrefInfo()
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateUserPrefInfo(){
        let url = OperationIP + "/user/updateUserPrefInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        let parameter = JSON([
            "userAvgBudget": getString(userData["userAvgBudget"]),
            "eatPref": getString(userData["eatPref"]),
            "drinkPref": getString(userData["drinkPref"]),
            "playPref": getString(userData["playPref"]),
            "watchPref": getString(userData["watchPref"]),
            "walkPref": getString(userData["walkPref"]),

        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                let responseJSON = JSON(response.value!)
                print(responseJSON)
            }
        }
    }
    
    func setEatUI(){
        let svSub = UIStackView()
        svSub.axis = .horizontal
        svSub.spacing = 10
        svSub.distribution = .fillEqually

        let btnCompany = MaterialVerticalButton(icon: UIImage(named: "RiceOff")!, text: "밥", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnInsta = MaterialVerticalButton(icon: UIImage(named: "MeatOff")!, text: "고기", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnNaver =  MaterialVerticalButton(icon: UIImage(named: "NoodleOff")!, text: "면", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let btnKakao =  MaterialVerticalButton(icon: UIImage(named: "SeaFoodOff")!, text: "해산물", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        let arrayServiceBtn = [btnCompany,btnInsta,btnNaver,btnKakao]
        for btn in arrayServiceBtn {
            svSub.addArrangedSubview(btn)
            btn.label.textColor = .black
            btn.label.font = .systemFont(ofSize: 13)
            btn.rippleLayerColor = .lightGray
            btn.rippleEnabled = false
        }
        
        svEat.addArrangedSubview(svSub)
        svEat.isHidden = false
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

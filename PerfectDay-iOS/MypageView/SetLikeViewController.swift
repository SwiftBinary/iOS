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
    @IBOutlet var svDrink: UIStackView!
    @IBOutlet var svPlay: UIStackView!
    @IBOutlet var svWatch: UIStackView!
    @IBOutlet var svWalk: UIStackView!
    
    @IBOutlet var uvEat: UIView!
    @IBOutlet var uvDrink: UIView!
    @IBOutlet var uvPlay: UIView!
    @IBOutlet var uvWatch: UIView!
    @IBOutlet var uvWalk: UIView!
    
    let userData = getUserData()
    
    //Eat
    var btnRice = MaterialVerticalButton()
    var btnMeat = MaterialVerticalButton()
    var btnNoodle = MaterialVerticalButton()
    var btnSeafood = MaterialVerticalButton()
    var btnStreetfood = MaterialVerticalButton()
    var btnFastfood = MaterialVerticalButton()
    var arrayBtnEating: Array<MaterialVerticalButton> = []
    
    //Drink
    var btnCoffee = MaterialVerticalButton()
    var btnTea = MaterialVerticalButton()
    var btnDessert = MaterialVerticalButton()
    var btnBeer = MaterialVerticalButton()
    var btnSoju = MaterialVerticalButton()
    var btnMakgeolli = MaterialVerticalButton()
    var btnCocktail = MaterialVerticalButton()
    var arrayBtnDrinking: Array<MaterialVerticalButton> = []
    
    //Play
    var btnGame = MaterialVerticalButton()
    var btnVR = MaterialVerticalButton()
    var btnIndoorActivity = MaterialVerticalButton()
    var btnOutdoorActivity = MaterialVerticalButton()
    var btnHealing = MaterialVerticalButton()
    var btnMaking = MaterialVerticalButton()
    var arrayBtnPlaying: Array<MaterialVerticalButton> = []
    
    //Watch
    var btnMovie = MaterialVerticalButton()
    var btnSport = MaterialVerticalButton()
    var btnExhibition = MaterialVerticalButton()
    var btnPerformance = MaterialVerticalButton()
    var btnReading = MaterialVerticalButton()
    var arrayBtnWatching: Array<MaterialVerticalButton> = []
    
    //Walk
    var btnMarket = MaterialVerticalButton()
    var btnPark = MaterialVerticalButton()
    var btnThemeStreet = MaterialVerticalButton()
    var btnLandscape = MaterialVerticalButton()
    var arrayBtnWalking: Array<MaterialVerticalButton> = []
    
    var arrayBtn: Array<Array<MaterialVerticalButton>> = []
    var openList = [true,false,false,false,false]
    
    var prefValue = [
        "1111110000", // Eat
        "1111111000", // Drink
        "1111100000", // Play
        "1111110000", // Watch
        "1110000000", // Walk
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userData)
        setUI()
        setUIView()
        
        setEatUI()
        setDrinkUI()
        setPlayUI()
        setWatchUI()
        setWalkUI()
        arrayBtn = [arrayBtnEating,arrayBtnDrinking,arrayBtnPlaying,arrayBtnWatching,arrayBtnWalking]
        for array in arrayBtn{
            for btn in array{
                btn.addTarget(self, action: #selector(touchEvent(_:)), for: .touchUpInside)
            }
        }
    }
    @objc func touchEvent(_ sender: MaterialVerticalButton){
        print("touch")
    }
    
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        print(userData)
        prefValue[0] = getString(userData["eatPref"])
        prefValue[1] = getString(userData["drinkPref"])
        prefValue[2] = getString(userData["playPref"])
        prefValue[3] = getString(userData["watchPref"])
        prefValue[4] = getString(userData["walkPref"])
        /*
         "eatPref": 1111110000,
         "drinkPref": 1111111000,
         "playPref": 1111100000,
         "watchPref": 1111110000,
         "walkPref": 1110000000,
         */
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
    
    
    // ###########################
    //         버튼 초기화
    // ###########################
    func setEatUI(){
        btnRice = MaterialVerticalButton(icon: UIImage(named: "RiceOn")!, text: "밥", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnMeat = MaterialVerticalButton(icon: UIImage(named: "MeatOn")!, text: "고기", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnNoodle =  MaterialVerticalButton(icon: UIImage(named: "NoodleOn")!, text: "면", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnSeafood =  MaterialVerticalButton(icon: UIImage(named: "SeaFoodOn")!, text: "해산물", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnStreetfood =  MaterialVerticalButton(icon: UIImage(named: "StreetFoodOn")!, text: "길거리", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnFastfood =  MaterialVerticalButton(icon: UIImage(named: "FastFoodOn")!, text: "피자/버거", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        arrayBtnEating = [btnRice,btnMeat,btnNoodle,btnSeafood,btnStreetfood,btnFastfood]
        setStackView(svEat, arrayBtnEating)
        for view in svEat.subviews {
            view.isHidden = false
        }
    }
    
    func setDrinkUI(){
        btnCoffee = MaterialVerticalButton(icon: UIImage(named: "CoffeeOff")!, text: "커피", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnTea = MaterialVerticalButton(icon: UIImage(named: "TeaOff")!, text: "차/음료", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnDessert =  MaterialVerticalButton(icon: UIImage(named: "DessertOff")!, text: "디저트", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnBeer =  MaterialVerticalButton(icon: UIImage(named: "BeerOff")!, text: "맥주", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnSoju =  MaterialVerticalButton(icon: UIImage(named: "SojuOff")!, text: "소주", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnMakgeolli =  MaterialVerticalButton(icon: UIImage(named: "MakgeolliOff")!, text: "막걸리", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnCocktail =  MaterialVerticalButton(icon: UIImage(named: "CocktailOff")!, text: "칵테일/와인", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        
        arrayBtnDrinking = [btnCoffee,btnTea,btnDessert,btnBeer,btnSoju,btnMakgeolli,btnCocktail]
        setStackView(svDrink, arrayBtnDrinking)
    }
    func setPlayUI(){
        btnGame = MaterialVerticalButton(icon: UIImage(named: "GameOff")!, text: "게임/오락", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnVR = MaterialVerticalButton(icon: UIImage(named: "VROff")!, text: "VR/방탈출", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnIndoorActivity =  MaterialVerticalButton(icon: UIImage(named: "IndoorActivityOff")!, text: "실내 활동", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnOutdoorActivity =  MaterialVerticalButton(icon: UIImage(named: "OutdoorActivityOff")!, text: "실외 활동", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnHealing =  MaterialVerticalButton(icon: UIImage(named: "HealingOff")!, text: "힐링", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnMaking =  MaterialVerticalButton(icon: UIImage(named: "MakingOff")!, text: "만들기", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        
        arrayBtnPlaying = [btnGame,btnVR,btnIndoorActivity,btnOutdoorActivity,btnHealing,btnMaking]
        setStackView(svPlay, arrayBtnPlaying)
    }
    func setWatchUI(){
        btnMovie = MaterialVerticalButton(icon: UIImage(named: "MovieOff")!, text: "영화", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnSport = MaterialVerticalButton(icon: UIImage(named: "SportOff")!, text: "스포츠 경기", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnExhibition =  MaterialVerticalButton(icon: UIImage(named: "ExhibitionOff")!, text: "전시회", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnPerformance =  MaterialVerticalButton(icon: UIImage(named: "PerformanceOff")!, text: "공연", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnReading =  MaterialVerticalButton(icon: UIImage(named: "BookStoreOff")!, text: "책방", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        
        arrayBtnWatching = [btnMovie,btnSport,btnExhibition,btnPerformance,btnReading]
        setStackView(svWatch, arrayBtnWatching)
    }
    func setWalkUI(){
        btnMarket = MaterialVerticalButton(icon: UIImage(named: "MarketOff")!, text: "시장", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnPark = MaterialVerticalButton(icon: UIImage(named: "ParkOff")!, text: "공원", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnThemeStreet =  MaterialVerticalButton(icon: UIImage(named: "ThemeStreetOff")!, text: "테마거리", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
        btnLandscape =  MaterialVerticalButton(icon: UIImage(named: "LandscapeOff")!, text: "야경/풍경", font: nil ,foregroundColor: themeColor, bgColor: .white, useOriginalImg: true,cornerRadius: 10.0)
    
        arrayBtnWalking = [btnMarket,btnPark,btnThemeStreet,btnLandscape]
        setStackView(svWalk, arrayBtnWalking)
    }
    
    func setStackView(_ mainStack: UIStackView,_ arrayBtn: [MaterialVerticalButton]) {
        for floor in 0...(arrayBtn.count-1)/6 {
            let svSub = UIStackView()
            svSub.axis = .horizontal
            svSub.spacing = 10
            svSub.distribution = .fillEqually
            for index in (floor*6)...(floor*6)+5 {
                if index < arrayBtn.endIndex {
                    svSub.addArrangedSubview(arrayBtn[index])
                    arrayBtn[index].label.textColor = .black
                    arrayBtn[index].label.font = .systemFont(ofSize: 7)
                    arrayBtn[index].rippleLayerColor = .lightGray
                    arrayBtn[index].rippleEnabled = true
                    print(arrayBtn[index].accessibilityIdentifier)
//                    arrayBtn[index].accessibilityLabel = arrayBtn[index].imageView.image
                } else {
                    svSub.addArrangedSubview(UIView())
                }
            }
            svSub.isHidden = true
            mainStack.addArrangedSubview(svSub)
        }
        mainStack.isHidden = false
    }
    /*
     // MARK: - Navigation
     0 1 2 3
     4 5 6 7
     8 9
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

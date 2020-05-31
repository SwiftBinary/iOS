//
//  SetLikeViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/24.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class SetLikeViewController: UIViewController {
    
    
    @IBOutlet var svCategory: UIStackView!
    
    @IBOutlet var svEat: UIStackView!
    
    @IBOutlet var uvEat: UIView!
    @IBOutlet var uvDrink: UIView!
    @IBOutlet var uvPlay: UIView!
    @IBOutlet var uvWatch: UIView!
    @IBOutlet var uvWalk: UIView!
    
    //Eat
    @IBOutlet var btnRice: UIButton!
    @IBOutlet var btnMeat: UIButton!
    @IBOutlet var btnNoodle: UIButton!
    @IBOutlet var btnSeafood: UIButton!
    @IBOutlet var btnStreetfood: UIButton!
    @IBOutlet var btnFastfood: UIButton!
    
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
        setUI()
        setUIView()
    }
    
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
//        let btn = MaterialVerticalButton(icon: UIImage(named: "category")!, title: "밥", font: .systemFont(ofSize: 14), foregroundColor: .white, useOriginalImg: true, bgColor: .white, cornerRadius: 0)
//        btn.label.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        (svEat.subviews[1] as! UIStackView).insertArrangedSubview(btn, at: 0)
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
        self.navigationController?.popViewController(animated: true)
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

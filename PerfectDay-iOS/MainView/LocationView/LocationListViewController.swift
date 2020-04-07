//
//  LocationListViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/05.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class LocationListViewController: UIViewController {

    @IBOutlet var svKategorie: UIStackView!
    @IBOutlet var svLocation: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setKategorie()
        setLocationList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setNavigationBar(){
        self.navigationItem.title = "완벽한 하루"
        let backItem = UIBarButtonItem()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
    }
    
    func setKategorie(){
        let btnAll = MaterialVerticalButton(icon: UIImage(named: "KategorieAll")!, title: "전체보기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        let btnEat = MaterialVerticalButton(icon: UIImage(named: "KategorieEat")!, title: "먹기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        let btnDrink = MaterialVerticalButton(icon: UIImage(named: "KategorieDrink")!, title: "마시기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        let btnPlay = MaterialVerticalButton(icon: UIImage(named: "KategoriePlay")!, title: "놀기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        let btnWatch = MaterialVerticalButton(icon: UIImage(named: "KategorieWatch")!, title: "보기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        let btnWalk = MaterialVerticalButton(icon: UIImage(named: "KategorieWalk")!, title: "걷기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        
        let btnArray = [btnAll,btnEat,btnDrink,btnPlay,btnWatch,btnWalk]
        
        for btn in btnArray {
            btn.label.font = btn.label.font.withSize(13)
            svKategorie.addArrangedSubview(btn)
        }
    }
    
    func setLocationList(){
        setStackView()
        for i in 0...15 {
            tempLandmark(i)
        }
    }
    func setStackView(){
        svLocation.axis = .vertical
        svLocation.spacing = 15
    }
    func tempLandmark(_ num: Int) {
        let uvBack = UIView()
        let svMain = UIStackView()
        let svInfo = UIStackView()
        let imgLand = UIImageView(image: UIImage(named: "ReviewBoardIcon"))
        let lblTitle = UILabel()
        let lblContent = UILabel()
        let lblAddress = UILabel()
        uvBack.layer.borderWidth = 0.5
        uvBack.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        uvBack.layer.cornerRadius = 5
        svMain.axis = .horizontal
        svInfo.axis = .vertical
        svInfo.distribution = .fillEqually
        imgLand.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        lblTitle.text = "랜드마크" + String(num)
        lblContent.text = "분위기 좋고 맛있고 갈곳 많고! 없는게 없는 건대 맛의 거리"
        lblAddress.text = "서울 광진구 자양동"
        svInfo.addArrangedSubview(lblTitle)
        svInfo.addArrangedSubview(lblContent)
        svInfo.addArrangedSubview(lblAddress)
        svMain.addArrangedSubview(imgLand)
        svMain.addArrangedSubview(svInfo)
        uvBack.addSubview(svMain)
                    
        self.svLocation.addArrangedSubview(uvBack)
                    
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.widthAnchor.constraint(equalTo: uvBack.widthAnchor, multiplier: 1).isActive = true
        svMain.topAnchor.constraint(equalTo: uvBack.topAnchor, constant: 0).isActive = true
        svMain.bottomAnchor.constraint(equalTo: uvBack.bottomAnchor, constant: 0).isActive = true
        svMain.leadingAnchor.constraint(equalTo: uvBack.leadingAnchor, constant: 0).isActive = true
        svMain.trailingAnchor.constraint(equalTo: uvBack.trailingAnchor, constant: 0).isActive = true
                    
        uvBack.translatesAutoresizingMaskIntoConstraints = false
        uvBack.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: uvBack, attribute: .centerX, multiplier: 1, constant: 0))
        uvBack.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: uvBack, attribute: .centerY, multiplier: 1, constant: 0))
                    
        uvBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationInfo)))
    }
    
    @objc func gotoLocationInfo(){
//        print("debug")
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "locationInfoView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    
    @IBAction func changeForm(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            print("List")
        } else {
            print("Block")
        }
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

//
//  PlannerViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/09.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class PlannerViewController: UIViewController {

    @IBOutlet var scvPlaceList: UIScrollView!
    @IBOutlet var svPlaceList: UIStackView!
    
    @IBOutlet var scvSelected: UIScrollView!
    @IBOutlet var svSelected: UIStackView!
    
    
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    let itemNum = 4
    let prefSn = "10000000"
    let prefData = "1210010000"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    func setNavigationBar(){
        self.navigationItem.title = "플래너"
        let backItem = UIBarButtonItem()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
        let allClear = UIBarButtonItem()
        allClear.title = "모두 초기화"
        let btnEdit = UIBarButtonItem()
        btnEdit.title = "완료"
        self.navigationItem.setRightBarButtonItems([btnEdit,allClear], animated: true)
    }
    
    
    @IBAction func goToCourseConfirm(_ sender: UIButton) {
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "courseView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    
    func setUI(){
        svPlaceList.axis = .horizontal
        svPlaceList.removeSubviews()
        scvPlaceList.showsVerticalScrollIndicator = false
        for i in 0...itemNum {
            setPlaceList(i)
        }
        
        svSelected.axis = .vertical
        svSelected.removeSubviews()
        scvSelected.bounces = false
        scvSelected.showsVerticalScrollIndicator = false
        for i in 0...itemNum {
            selectedLocList(i)
        }
    }
    
    func setPlaceList(_ num: Int){
        let uvItem = UIView()
        uvItem.translatesAutoresizingMaskIntoConstraints = false
        
        let imgLand = UIImageView(image: UIImage(named: "TempImage"))
        imgLand.clipsToBounds = true
        imgLand.layer.cornerRadius = 5
        imgLand.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        imgLand.widthAnchor.constraint(equalToConstant: view.frame.width * 0.15 - 5).isActive = true
        imgLand.heightAnchor.constraint(equalToConstant: view.frame.width * 0.15 - 5).isActive = true
        let lblTitle = UILabel()
        lblTitle.text = "장소명"
        lblTitle.fontSize = 13
        lblTitle.textColor = .darkGray
        lblTitle.textAlignment = .center
        let svItem = UIStackView(arrangedSubviews: [imgLand,lblTitle])
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .vertical
        svItem.distribution = .fill
        

        uvItem.addSubview(svItem)
        uvItem.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2).isActive = true
        uvItem.widthAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 0.75).isActive = true
        svItem.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1, constant:  -5).isActive = true
        svItem.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1, constant:  -5).isActive = true
        svItem.leftAnchor.constraint(equalTo: uvItem.leftAnchor, constant: 0).isActive = true
        svItem.bottomAnchor.constraint(equalTo: uvItem.bottomAnchor, constant: 0).isActive = true
        
        
        let sequenceBtn = UIButton(type: .custom)
        sequenceBtn.translatesAutoresizingMaskIntoConstraints = false
        sequenceBtn.setTitle("\(num + 1)", for: .normal)
        sequenceBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11.0)
        sequenceBtn.setTitleColor(.white, for: .normal)
        sequenceBtn.contentHorizontalAlignment = .center
        sequenceBtn.contentVerticalAlignment = .center
        sequenceBtn.isUserInteractionEnabled = false
        sequenceBtn.layer.cornerRadius = 5
        sequenceBtn.layer.backgroundColor = #colorLiteral(red: 1, green: 0.2955724597, blue: 0.5731969476, alpha: 1)
        sequenceBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 16).isActive = true
        sequenceBtn.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 16).isActive = true
        
        uvItem.addSubview(sequenceBtn)
        sequenceBtn.topAnchor.constraint(equalTo: uvItem.topAnchor, constant: 0).isActive = true
        sequenceBtn.rightAnchor.constraint(equalTo: uvItem.rightAnchor, constant: 0).isActive = true
        
        setSequenceColor(prefSn,sequenceBtn)
        
        svPlaceList.addArrangedSubview(uvItem)
        
    }
    
    
    func selectedLocList(_ num : Int){
        let uvItem = UIView()
        uvItem.translatesAutoresizingMaskIntoConstraints = false
        uvItem.backgroundColor = .clear
        
        //차수 뒤 회색 선을 위한 뷰,,,,
        let uvBack = UIView()
        uvBack.translatesAutoresizingMaskIntoConstraints = false
        let uvline = UIView()
        uvline.translatesAutoresizingMaskIntoConstraints = false
        uvline.backgroundColor = .lightGray
        uvBack.addSubview(uvline)
        uvBack.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        uvBack.heightAnchor.constraint(equalTo: uvBack.widthAnchor, multiplier: 0.27).isActive = true
        uvline.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 2).isActive = true
        uvline.heightAnchor.constraint(equalTo: uvBack.heightAnchor, multiplier: 1).isActive = true
        uvline.leftAnchor.constraint(equalTo: uvBack.leftAnchor, constant: 44).isActive = true
        uvline.topAnchor.constraint(equalTo: uvBack.topAnchor, constant: 0).isActive = true
        uvline.bottomAnchor.constraint(equalTo: uvBack.bottomAnchor, constant: 0).isActive = true
        
        uvItem.addSubview(uvBack)
        
        
        
        let storeType = UILabel()
//        storeType.text = "장소유형"
        setPref(storeType,prefSn,prefData)
        storeType.fontSize = 13
        storeType.textColor = .systemBlue
        let storeNm = UILabel()
        storeNm.text = "장소명" + String(num)
        storeNm.font = UIFont.boldSystemFont(ofSize: 16.0)
        let lblContent = UILabel()
        lblContent.text = "대표메뉴" + String(num * 10000)  + "원"
        lblContent.fontSize = 13
        //        lblContent.heightAnchor.constraint(equalToConstant: lblContent.frame.height ).isActive = true
        lblContent.textColor = .darkGray
        let lblAddress = UILabel()
        lblAddress.text = "서울 광진구 자양동"
        lblAddress.textColor = .darkGray
        lblAddress.fontSize = 13
        let imgAddress = UIImageView(image: UIImage(named: "AddressIcon"))
        imgAddress.contentMode = .scaleAspectFit
        imgAddress.widthAnchor.constraint(equalToConstant: imgAddress.frame.height * 1 ).isActive = true
        let svAddress = UIStackView(arrangedSubviews: [imgAddress,lblAddress])
        svAddress.axis = .horizontal
        svAddress.distribution = .fillProportionally
        svAddress.spacing = 5
        svAddress.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.36) - 17 ).isActive = true
        
        let imgLand = UIImageView(image: UIImage(named: "TempImage"))
        imgLand.clipsToBounds = true
        imgLand.layer.cornerRadius = 5
        imgLand.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        imgLand.widthAnchor.constraint(equalToConstant: view.frame.width * 0.2 - 14).isActive = true
        let svInfo = UIStackView(arrangedSubviews: [storeType,storeNm,lblContent,svAddress])
        svInfo.translatesAutoresizingMaskIntoConstraints = false
        svInfo.axis = .vertical
        svInfo.distribution = .fillProportionally
        imgLand.widthAnchor.constraint(equalTo: imgLand.heightAnchor, multiplier:  1).isActive = true
        let uvInfo = UIView()
        uvInfo.addSubview(svInfo)
        uvInfo.translatesAutoresizingMaskIntoConstraints = false
        uvInfo.widthAnchor.constraint(equalToConstant: view.frame.width * 0.36 - 10).isActive = true
        uvInfo.heightAnchor.constraint(equalToConstant: view.frame.width * 0.27 - 14).isActive = true
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerX, relatedBy: .equal, toItem: uvInfo, attribute: .centerX, multiplier: 1, constant: 0))
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerY, relatedBy: .equal, toItem: uvInfo, attribute: .centerY, multiplier: 1, constant: 0))
        svInfo.widthAnchor.constraint(equalTo: uvInfo.widthAnchor, multiplier: 1).isActive = true
        svInfo.heightAnchor.constraint(equalTo: uvInfo.heightAnchor, multiplier: 1).isActive = true
        let svMain = UIStackView(arrangedSubviews: [imgLand,uvInfo])
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.axis = .horizontal
        svMain.distribution = .fillProportionally
        svMain.spacing = 10
        svMain.widthAnchor.constraint(equalToConstant: view.frame.width * 0.63 - 14).isActive = true
        svMain.heightAnchor.constraint(equalToConstant: view.frame.width * 0.63 - 14).isActive = true
        
        let uvMain = UIView()
        uvMain.addSubview(svMain)
        uvMain.backgroundColor = .clear
        uvMain.translatesAutoresizingMaskIntoConstraints = false
        uvMain.layer.borderWidth = 1
        uvMain.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        uvMain.layer.cornerRadius = 5
        uvMain.widthAnchor.constraint(equalToConstant: view.frame.width * 0.63).isActive = true
        uvMain.heightAnchor.constraint(equalToConstant: view.frame.width * 0.27).isActive = true
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: uvMain, attribute: .centerX, multiplier: 1, constant: 0))
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: uvMain, attribute: .centerY, multiplier: 1, constant: 0))
        svMain.heightAnchor.constraint(equalTo: uvMain.heightAnchor, multiplier: 1, constant: -14).isActive = true
        svMain.widthAnchor.constraint(equalTo: uvMain.widthAnchor, multiplier: 1, constant:  -14).isActive = true
        
        let uvLocation = UIView()
        uvLocation.backgroundColor = .clear
        uvLocation.addSubview(uvMain)
        uvLocation.translatesAutoresizingMaskIntoConstraints = false
        uvLocation.widthAnchor.constraint(equalToConstant: view.frame.width * 0.63).isActive = true
        uvLocation.heightAnchor.constraint(equalToConstant: view.frame.width * 0.27).isActive = true
        uvLocation.addConstraint(NSLayoutConstraint(item: uvMain, attribute: .centerX, relatedBy: .equal, toItem: uvLocation, attribute: .centerX, multiplier: 1, constant: 0))
        uvLocation.addConstraint(NSLayoutConstraint(item: uvMain, attribute: .centerY, relatedBy: .equal, toItem: uvLocation, attribute: .centerY, multiplier: 1, constant: 0))
        uvMain.heightAnchor.constraint(equalTo: uvLocation.heightAnchor, multiplier: 1, constant: -14).isActive = true
        uvMain.widthAnchor.constraint(equalTo: uvLocation.widthAnchor, multiplier: 1, constant:  0).isActive = true
        let changeSeqBtn = UIButton(type: .custom)
        changeSeqBtn.setImage(UIImage(named: "ChangeSequence"), for: .normal)
        changeSeqBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 10).isActive = true
        let svRight = UIStackView(arrangedSubviews: [uvLocation,changeSeqBtn])
        svRight.translatesAutoresizingMaskIntoConstraints = false
        svRight.axis = .horizontal
        svRight.distribution = .fill
        svRight.spacing = 15
        
        
        
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setImage(UIImage(named: "DeletePlannerItem"), for: .normal)
        deleteBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 20).isActive = true
        let sequenceBtn = UIButton(type: .custom)
        sequenceBtn.translatesAutoresizingMaskIntoConstraints = false
        sequenceBtn.setTitle("\(num + 1)", for: .normal)
        sequenceBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        sequenceBtn.setTitleColor(.white, for: .normal)
        sequenceBtn.contentHorizontalAlignment = .center
        sequenceBtn.contentVerticalAlignment = .center
        sequenceBtn.isUserInteractionEnabled = false
        sequenceBtn.layer.cornerRadius = 10.5
        setSequenceColor(prefSn,sequenceBtn)
        
        let uvSequence = UIView()
        uvSequence.translatesAutoresizingMaskIntoConstraints = false
        uvSequence.addSubview(sequenceBtn)
        uvSequence.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 50).isActive = true
        uvSequence.addConstraint(NSLayoutConstraint(item: sequenceBtn, attribute: .centerX, relatedBy: .equal, toItem: uvSequence, attribute: .centerX, multiplier: 1, constant: 0))
        uvSequence.addConstraint(NSLayoutConstraint(item: sequenceBtn, attribute: .centerY, relatedBy: .equal, toItem: uvSequence, attribute: .centerY, multiplier: 1, constant: 0))
        sequenceBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 21).isActive = true
        sequenceBtn.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 21).isActive = true
        let svLeft = UIStackView(arrangedSubviews: [deleteBtn,uvSequence])
        svLeft.translatesAutoresizingMaskIntoConstraints = false
        svLeft.axis = .horizontal
        svLeft.distribution = .fill
        
        
        
        let svItem = UIStackView(arrangedSubviews: [svLeft,svRight])
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .horizontal
        svItem.distribution = .fill

        uvItem.addSubview(svItem)
        uvItem.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        uvItem.heightAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 0.27).isActive = true
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        svItem.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1, constant:  0).isActive = true
        svItem.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1, constant:  0).isActive = true

        uvItem.addConstraint(NSLayoutConstraint(item: uvBack, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: uvBack, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        uvBack.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1, constant:  0).isActive = true
        uvBack.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1, constant:  0).isActive = true
        
        //장소 유형 텍스트 및 차수 배경 색상, 지도 핀 색상을 정하는 함수
        
        
        
        svSelected.addArrangedSubview(uvItem)
        
        
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

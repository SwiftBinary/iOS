//
//  LandmarkViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/05.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class LandmarkViewController: UIViewController {
    
    @IBOutlet var svHashTag: UIStackView!
    @IBOutlet var scLandmark: UIScrollView!
    @IBOutlet var svLandmark: UIStackView!
    
    //    let svLandmark = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        for btn in svHashTag.arrangedSubviews {
            btn.layer.cornerRadius = 15
            btn.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            btn.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
        }
        setStackView()
        for i in 0...15 {
            tempLandmark(i)
        }
        let bottomUI = UIView()
        bottomUI.frame.size.height = 20
        svLandmark.addArrangedSubview(bottomUI)
    }
    
    func setStackView(){
        svLandmark.axis = .vertical
        svLandmark.spacing = 15
        //        scLandmark.backgroundColor = .systemPink
        scLandmark.bounces = false
        scLandmark.showsVerticalScrollIndicator = false
        //UIview 넣고 Hide로 숨기기
    }
    
    func tempLandmark(_ num: Int) {
        let uvItem = UIView()
        uvItem.translatesAutoresizingMaskIntoConstraints = false
        
        let lblTitle = UILabel()
        lblTitle.text = "랜드마크 " + String(num)
        lblTitle.fontSize = 15
        let lblContent = UILabel()
        lblContent.text = "분위기 좋고 맛있고 갈곳 많고! 없는게 없는 건대 맛의 거리"
        lblContent.lineBreakMode = .byWordWrapping
        lblContent.numberOfLines = 2
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
        svAddress.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.54) - 15 ).isActive = true
        
        let midUI = UIView()
        midUI.heightAnchor.constraint(equalToConstant: view.frame.width / 33 ).isActive = true
        let lblTouch = UILabel()
        let touchNum = Int(999)
        lblTouch.text = "클릭수 " + String(touchNum)
        lblTouch.fontSize = 12
        
        let imgLand = UIImageView(image: UIImage(named: "TempImage"))
        imgLand.clipsToBounds = true
        imgLand.layer.cornerRadius = 5
        imgLand.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        let svInfo = UIStackView(arrangedSubviews: [lblTitle,lblContent,svAddress,midUI,lblTouch])
        svInfo.translatesAutoresizingMaskIntoConstraints = false
        svInfo.axis = .vertical
        svInfo.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.54) - 15).isActive = true
        svInfo.heightAnchor.constraint(equalToConstant: (view.frame.width * 0.27) - 15).isActive = true
        svInfo.distribution = .fill
        svInfo.spacing = 3
        
        let uvInfo = UIView()
        uvInfo.addSubview(svInfo)
        uvInfo.translatesAutoresizingMaskIntoConstraints = false
        uvInfo.widthAnchor.constraint(equalToConstant: view.frame.width * 0.54).isActive = true
        uvInfo.heightAnchor.constraint(equalToConstant: view.frame.width * 0.27).isActive = true
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerX, relatedBy: .equal, toItem: uvInfo,
                                                attribute: .centerX, multiplier: 1, constant: 0))
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerY, relatedBy: .equal, toItem: uvInfo,
                                                attribute: .centerY, multiplier: 1, constant: 0))
        
        let svMain = UIStackView(arrangedSubviews: [imgLand,uvInfo])
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.axis = .horizontal
        svMain.distribution = .fillProportionally
        svMain.widthAnchor.constraint(equalToConstant: view.frame.width * 0.81).isActive = true
        svMain.heightAnchor.constraint(equalToConstant: view.frame.width * 0.27).isActive = true
        
        let uvMain = UIView()
        uvMain.addSubview(svMain)
        uvMain.translatesAutoresizingMaskIntoConstraints = false
        uvMain.layer.borderWidth = 0.5
        uvMain.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        uvMain.layer.cornerRadius = 5
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: uvMain, attribute: .centerX, multiplier: 1, constant: 0))
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: uvMain, attribute: .centerY, multiplier: 1, constant: 0))
        svMain.heightAnchor.constraint(equalTo: uvMain.heightAnchor, multiplier: 1).isActive = true
        svMain.widthAnchor.constraint(equalTo: uvMain.widthAnchor, multiplier: 1).isActive = true
        
        let recommandBtn = UIButton(type: .custom)
        recommandBtn.setTitle("주\n변\n추\n천", for: .normal)
        recommandBtn.titleLabel?.numberOfLines = 4
        recommandBtn.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
        recommandBtn.setTitleColor(.darkGray, for: .normal)
        recommandBtn.fontSize = 13
        recommandBtn.layer.borderWidth = 0.5
        recommandBtn.layer.cornerRadius = 5
        recommandBtn.widthAnchor.constraint(equalToConstant: view.frame.width * 0.07).isActive = true
        
        let svItem = UIStackView(arrangedSubviews: [uvMain, recommandBtn])
        //        svItem.addSubview(uvMain)
        //        svItem.addSubview(recommandBtn)
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .horizontal
        svItem.distribution = .fill
        svItem.spacing = 10
        
        uvItem.addSubview(svItem)
        uvItem.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        uvItem.heightAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 0.3).isActive = true
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        svItem.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1).isActive = true
        svItem.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1).isActive = true
        
        uvItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationList)))
        
        svLandmark.addArrangedSubview(uvItem)
    }
    
    @objc func gotoLocationList(){
        //        print("debug")
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "locationListView")
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

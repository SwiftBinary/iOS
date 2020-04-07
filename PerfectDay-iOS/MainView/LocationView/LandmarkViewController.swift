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
    }
    
    func setStackView(){
        svLandmark.axis = .vertical
        svLandmark.spacing = 15
        //UIview 넣고 Hide로 숨기기
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
        
        self.svLandmark.addArrangedSubview(uvBack)
        
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.widthAnchor.constraint(equalTo: uvBack.widthAnchor, multiplier: 1).isActive = true
        svMain.topAnchor.constraint(equalTo: uvBack.topAnchor, constant: 0).isActive = true
        svMain.bottomAnchor.constraint(equalTo: uvBack.bottomAnchor, constant: 0).isActive = true
        svMain.leadingAnchor.constraint(equalTo: uvBack.leadingAnchor, constant: 0).isActive = true
        svMain.trailingAnchor.constraint(equalTo: uvBack.trailingAnchor, constant: 0).isActive = true
        
        uvBack.translatesAutoresizingMaskIntoConstraints = false
        uvBack.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: uvBack, attribute: .centerX, multiplier: 1, constant: 0))
        uvBack.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: uvBack, attribute: .centerY, multiplier: 1, constant: 0))
        
        uvBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationList)))
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

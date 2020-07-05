//
//  SearchSetLocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/06.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import Material

class SearchSetLocationViewController: UIViewController {
    
    @IBOutlet var lblGuide: UILabel!
    @IBOutlet var tfKeyword: UITextField!
    @IBOutlet var sendKeywordBtn: UIButton!
    @IBOutlet var btnCurrentLocation: UIButton!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lineView: UIView!
    
    @IBOutlet var scvList: UIScrollView!
    @IBOutlet var svList: UIStackView!
    
    var responseJSON:JSON = JSON()
    var n : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setUI()
        setLocationList()
        // Do any additional setup after loading the view.
    }
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        lblGuide.text = "찾고 싶은 위치 또는 장소를 입력하세요." // 두 줄로 표시?
        setField(tfKeyword, "ex) 건대입구 또는 홍대입구")
        setSNSButton(btnCurrentLocation, "FocusLocation")
    }
    
    func requestSearchedLoc(){
        let url = OperationIP + "/search/selectLocationInfo.do"
        let parameter = JSON([
            "searchKeyword": tfKeyword.text,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString]).responseJSON { response in
            if response.value != nil {
                self.responseJSON = JSON(response.value!)
                let responseStr : String = self.responseJSON.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
                print("result : \n " + responseStr + " !")
                if responseStr != "[]" {
                    self.svList.removeSubviews()
                    self.setResult()
                } else {
                    self.setLocationList()
                }
            }
        }
    }
    
    
    @IBAction func sendKeyword(_ sender: Any) {
        requestSearchedLoc()
    }
    func setResult(){
        lblTitle.isHidden = true //왜 안먹지?
        svList.axis = .vertical
        svList.distribution = .fill
        svList.spacing = 5
        scvList.bounces = false
        
        let topView = UIView()
        topView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        let bottomView = UIView()
        bottomView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        self.svList.addArrangedSubview(topView)
        for data in responseJSON.arrayValue {
            addline()
            searchResults(data: data)
        }
        addline()
        self.svList.addArrangedSubview(bottomView)
        lblTitle.isHidden = true
        lineView.isHidden = true
    }
    
    func setLocationList(){
        svList.axis = .vertical
        svList.distribution = .fillEqually
        svList.spacing = 10
        scvList.backgroundColor = .white
        svList.removeSubviews()
        setRecentlySearched()
    }
    func setRecentlySearched(){
        lblTitle.isHidden = false
        lineView.isHidden = false
        
        
        for i in 0...15 {
            recentlySearched(i, svList)
        }
    }
    
    func recentlySearched(_ num: Int,_ svSearchedResult: UIStackView ){
        
        let uvResult = UIView()
        uvResult.translatesAutoresizingMaskIntoConstraints = false
        //        uvResult.backgroundColor = .systemPink
        let nameBtn = UIButton(type: .system)
        let searchedtext : String = "건대"
        nameBtn.setTitle(searchedtext, for: .normal)
        nameBtn.setTitleColor(.lightGray, for: .normal)
        nameBtn.titleLabel?.fontSize = 13
//        nameBtn.isUserInteractionEnabled = false
        nameBtn.contentHorizontalAlignment = .left
        nameBtn.accessibilityIdentifier = searchedtext
        nameBtn.addTarget(self, action: #selector(gotoTemp(_:)), for: .touchUpInside)
        
        let removeBtn = IconButton()
        removeBtn.image = Icon.cm.close
        removeBtn.tintColor = .darkGray
        removeBtn.contentHorizontalAlignment = .right
//        removeBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        removeBtn.widthAnchor.constraint(equalToConstant: removeBtn.frame.height * 1 ).isActive = true
        removeBtn.imageView?.contentMode = .scaleAspectFit
//        removeBtn.addTarget(self, action: #selector(<#T##@objc method#>), for: .touchUpInside)
        
        let svResult = UIStackView(arrangedSubviews: [nameBtn, removeBtn])
        svResult.translatesAutoresizingMaskIntoConstraints = false
        svResult.axis = .horizontal
        svResult.distribution = .fill
//        svResult.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        
        uvResult.addSubview(svResult)
        uvResult.addConstraint(NSLayoutConstraint(item: svResult, attribute: .centerX, relatedBy: .equal, toItem: uvResult, attribute: .centerX, multiplier: 1, constant: 0))
        uvResult.addConstraint(NSLayoutConstraint(item: svResult, attribute: .centerY, relatedBy: .equal, toItem: uvResult, attribute: .centerY, multiplier: 1, constant: 0))
        svResult.widthAnchor.constraint(equalTo: uvResult.widthAnchor, multiplier: 0.9).isActive = true
        svResult.heightAnchor.constraint(equalTo: uvResult.heightAnchor, multiplier: 1).isActive = true
        
        svSearchedResult.addArrangedSubview(uvResult)
//        svSearchedResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationResult)))
    }
    @objc func gotoTemp(_ sender:UIButton){
        print(sender.accessibilityIdentifier!)
    }
    
    func searchResults(data: JSON){
        let uvMain = UIView()
//        uvMain.translatesAutoresizingMaskIntoConstraints = false
        
        lblTitle.isHidden = false
        
        let lblResult = UILabel()
        lblResult.text = data["title"].string
        lblResult.font = UIFont.boldSystemFont(ofSize: 19.0)
        lblResult.textAlignment = .left
        let lblBranchAddr = UILabel()
        lblBranchAddr.text = data["address"].string
        lblBranchAddr.font = UIFont.boldSystemFont(ofSize: 15.0)
        lblBranchAddr.textColor = .darkGray
        lblBranchAddr.textAlignment = .left
        let roadBtn = UIButton()
        roadBtn.setTitle("도로명", for: .normal)
        roadBtn.fontSize = 13
        roadBtn.setTitleColor(.darkGray, for: .normal)
        roadBtn.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        roadBtn.layer.borderWidth = 0.2
        roadBtn.layer.cornerRadius = 5
        roadBtn.widthAnchor.constraint(equalTo: roadBtn.heightAnchor, multiplier: 3, constant: 0).isActive = true
        let lblRoadAddr = UILabel()
        let roadStr = data["roadAddress"].string
        if roadStr != "" {
            //            let startIdx = roadStr!.firstIndex(of:"구")!
            //            let endIdx = roadStr!.endIndex
            //            roadStr = String(roadStr![startIdx...endIdx])
            //            print(roadStr!)
            lblRoadAddr.text = roadStr
        }
        else {
            lblRoadAddr.text = "도로명 주소"
        }
        lblRoadAddr.font = UIFont.boldSystemFont(ofSize: 15.0)
        lblRoadAddr.textColor = .lightGray
        lblRoadAddr.textAlignment = .left
        let svRoadAddr = UIStackView(arrangedSubviews: [roadBtn, lblRoadAddr])
        svRoadAddr.translatesAutoresizingMaskIntoConstraints = false
        svRoadAddr.axis = .horizontal
        svRoadAddr.distribution = .fill
        svRoadAddr.spacing = 10
        svRoadAddr.heightAnchor.constraint(equalToConstant: 20).isActive = true
        let svResult = UIStackView(arrangedSubviews: [lblResult,lblBranchAddr,svRoadAddr])
        svResult.translatesAutoresizingMaskIntoConstraints = false
        svResult.axis = .vertical
        svResult.distribution = .fill
        svResult.spacing = 5
//        svResult.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        
        
        uvMain.addSubview(svResult)
        uvMain.backgroundColor = .white
        uvMain.addConstraint(NSLayoutConstraint(item: svResult, attribute: .centerX, relatedBy: .equal, toItem: uvMain, attribute: .centerX, multiplier: 1, constant: 0))
        uvMain.addConstraint(NSLayoutConstraint(item: svResult, attribute: .centerY, relatedBy: .equal, toItem: uvMain, attribute: .centerY, multiplier: 1, constant: 0))
        svResult.widthAnchor.constraint(equalTo: uvMain.widthAnchor, multiplier: 0.9).isActive = true
        svResult.heightAnchor.constraint(equalTo: uvMain.heightAnchor, multiplier: 0.9).isActive = true
        
//        uvMain.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.svList.addArrangedSubview(uvMain)
        
//        svList.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationResult)))
        
    }
    func addline(){
        let uvline = UIView()
        uvline.translatesAutoresizingMaskIntoConstraints = false
        uvline.backgroundColor = .lightGray
        uvline.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 0.5).isActive = true
        svList.addArrangedSubview(uvline)
    }
    
    
    @objc func gotoLocationResult(){
        //        print("debug")
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "locationListView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    
    @objc func tempFunc(){
        print("debug")
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

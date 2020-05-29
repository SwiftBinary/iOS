//
//  SearchSetLocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/06.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SearchSetLocationViewController: UIViewController {
    
    @IBOutlet var lblGuide: UILabel!
    @IBOutlet var tfKeyword: UITextField!
    @IBOutlet var sendKeywordBtn: UIButton!
    @IBOutlet var btnCurrentLocation: UIButton!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lineView: UIView!
    
    @IBOutlet var scvList: UIScrollView!
    @IBOutlet var svList: UIStackView!
    
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
        setSNSButton(btnCurrentLocation, "FocusIcon")
    }
    
    @IBAction func sendKeyword(_ sender: Any) {
        lblTitle.isHidden = true //왜 안먹지?
        svList.axis = .vertical
        svList.spacing = 0.2
        scvList.backgroundColor = .lightGray
        scvList.bounces = false
        svList.removeSubviews()
        let topView = UIView()
        topView.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0, constant: 0).isActive = true
        let bottomView = UIView()
        bottomView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0, constant: 0).isActive = true
        self.svList.addArrangedSubview(topView)
        for i in 0...15 {
            searchResults(i)
        }
        self.svList.addArrangedSubview(bottomView)
        
        lblTitle.isHidden = true
        lineView.isHidden = true
    }
    
    func setLocationList(){
        svList.axis = .vertical
        svList.spacing = 10
        scvList.backgroundColor = .white
        svList.removeSubviews()
        setrecentlySearched()
    }
    
    
    func setrecentlySearched(){
        let uvMain = UIView()
        uvMain.translatesAutoresizingMaskIntoConstraints = false
        
        lblTitle.isHidden = false
        lineView.isHidden = false
        
        let svSearchedResult = UIStackView()
        svSearchedResult.axis = .vertical
        svSearchedResult.spacing = 10
        svSearchedResult.distribution = .fillEqually
        
        for i in 0...15 {
            recentlySearched(i, svSearchedResult)
        }
        
        let svMain = UIStackView(arrangedSubviews: [ svSearchedResult])
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.axis = .vertical
        svMain.distribution = .fill
        svMain.spacing = 10
        
        uvMain.addSubview(svMain)
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: uvMain, attribute: .centerX, multiplier: 1, constant: 0))
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: uvMain, attribute: .centerY, multiplier: 1, constant: 0))
        svMain.widthAnchor.constraint(equalTo: uvMain.widthAnchor, multiplier: 1).isActive = true
        svMain.heightAnchor.constraint(equalTo: uvMain.heightAnchor, multiplier: 1).isActive = true
        
        self.svList.addArrangedSubview(uvMain)
        
    }
    
    func recentlySearched(_ num: Int,_ svSearchedResult: UIStackView ){
        
        let uvResult = UIView()
        uvResult.translatesAutoresizingMaskIntoConstraints = false
        //        uvResult.backgroundColor = .systemPink
        let nameBtn = UIButton(type: .custom)
        let searchedtext : String = "건대"
        nameBtn.setTitle(searchedtext, for: .normal)
        nameBtn.setTitleColor(.lightGray, for: .normal)
        nameBtn.titleLabel?.fontSize = 13
        nameBtn.isUserInteractionEnabled = false
        nameBtn.contentHorizontalAlignment = .left
        let removeBtn = UIButton(type: .custom)
        removeBtn.setImage(UIImage(named: "DeleteBtn"), for: .normal)
        removeBtn.contentHorizontalAlignment = .right
        removeBtn.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        removeBtn.widthAnchor.constraint(equalToConstant: removeBtn.frame.height * 1 ).isActive = true
        let svResult = UIStackView(arrangedSubviews: [nameBtn, removeBtn])
        svResult.translatesAutoresizingMaskIntoConstraints = false
        svResult.axis = .horizontal
        svResult.distribution = .fill
        svResult.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        
        uvResult.addSubview(svResult)
        uvResult.addConstraint(NSLayoutConstraint(item: svResult, attribute: .centerX, relatedBy: .equal, toItem: uvResult, attribute: .centerX, multiplier: 1, constant: 0))
        uvResult.addConstraint(NSLayoutConstraint(item: svResult, attribute: .centerY, relatedBy: .equal, toItem: uvResult, attribute: .centerY, multiplier: 1, constant: 0))
        svResult.widthAnchor.constraint(equalTo: uvResult.widthAnchor, multiplier: 1).isActive = true
        svResult.heightAnchor.constraint(equalTo: uvResult.heightAnchor, multiplier: 1).isActive = true
        
        svSearchedResult.addArrangedSubview(uvResult)
        svSearchedResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationResult)))
    }
    
    
    
    func searchResults(_ num: Int){
        let uvMain = UIView()
        uvMain.translatesAutoresizingMaskIntoConstraints = false
        
        lblTitle.isHidden = false
        
        let lblResult = UILabel()
        lblResult.text = "건대입구역[2호선]"
        lblResult.font = UIFont.boldSystemFont(ofSize: 19.0)
        lblResult.textAlignment = .left
        let lblBranchAddr = UILabel()
        lblBranchAddr.text = "서울 광진구 화양동 7-3 건대입구역[2호선]"
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
        lblRoadAddr.text = "아차산로 229"
        lblRoadAddr.font = UIFont.boldSystemFont(ofSize: 15.0)
        lblRoadAddr.textColor = .lightGray
        lblRoadAddr.textAlignment = .left
        let svRoadAddr = UIStackView(arrangedSubviews: [roadBtn, lblRoadAddr])
        svRoadAddr.translatesAutoresizingMaskIntoConstraints = false
        svRoadAddr.axis = .horizontal
        svRoadAddr.distribution = .fillProportionally
        svRoadAddr.spacing = 10
        svRoadAddr.heightAnchor.constraint(equalTo: svRoadAddr.heightAnchor, multiplier: 0, constant: 20).isActive = true
        let svResult = UIStackView(arrangedSubviews: [lblResult,lblBranchAddr,svRoadAddr])
        svResult.translatesAutoresizingMaskIntoConstraints = false
        svResult.axis = .vertical
        svResult.distribution = .fillEqually
        svResult.spacing = 5
        svResult.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        
        
        uvMain.addSubview(svResult)
        uvMain.backgroundColor = .white
        uvMain.addConstraint(NSLayoutConstraint(item: svResult, attribute: .centerX, relatedBy: .equal, toItem: uvMain, attribute: .centerX, multiplier: 1, constant: 0))
        uvMain.addConstraint(NSLayoutConstraint(item: svResult, attribute: .centerY, relatedBy: .equal, toItem: uvMain, attribute: .centerY, multiplier: 1, constant: 0))
        svResult.widthAnchor.constraint(equalTo: uvMain.widthAnchor, multiplier: 1).isActive = true
        svResult.heightAnchor.constraint(equalTo: uvMain.heightAnchor, multiplier: 0.7).isActive = true
        
        
        self.svList.addArrangedSubview(uvMain)
        svList.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationResult)))
        
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

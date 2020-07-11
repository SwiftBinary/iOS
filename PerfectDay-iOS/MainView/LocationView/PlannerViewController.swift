//
//  PlannerViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/09.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import NMapsMap

class PlannerViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var scvPlaceList: UIScrollView!
    @IBOutlet var svPlaceList: UIStackView!
    @IBOutlet var makeCourseBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    let itemNum = 4
    
    let userData = getUserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedLoc = []
        setNavigationBar()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
        setUI()
        
        self.setTableView(self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
    }
    
    func setNavigationBar(){
        self.navigationItem.title = "플래너"
        let backItem = UIBarButtonItem()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
        
        let btnEdit = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(changeNavBtn(_:)))
        self.navigationItem.setRightBarButtonItems([btnEdit], animated: true)
    }
    @objc func changeNavBtn(_ sender: Any){
        deleteMode()
        let allClear = UIBarButtonItem(title: "모두 초기화", style: .plain, target: self, action: #selector(deleteAllPlannerLoc(_:)))
        let btnDone = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(resetNav(_:)))
        self.navigationItem.setRightBarButtonItems([btnDone,allClear], animated: true)
    }
    @objc func resetNav(_ sender: Any){
        defaultMode()
        let btnEdit = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(changeNavBtn(_:)))
        self.navigationItem.setRightBarButtonItems([btnEdit], animated: true)
    }
    @objc func deleteAllPlannerLoc(_ sender: Any){
        let num = UserDefaults.standard.value(forKey: plannerNumKey) as! Int
        for i in 0...num {
            UserDefaults.standard.removeObject(forKey: "PlannerKey" + String(i))
        }
        UserDefaults.standard.set(0, forKey: plannerNumKey)
        let arr : Array<String> = []
        UserDefaults.standard.set(arr, forKey: "StoreSnList")
        resetUpperUI()
        selectedLoc.removeAll()
        self.tableView.reloadData()
    }
    
    @IBAction func goToCourseConfirm(_ sender: UIButton) {
        if selectedLoc.count > 1 {
            let storeSnList = UserDefaults.standard.value(forKey: "StoreSnList") as! Array<String>
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //        let goToVC = storyboard.instantiateViewController(withIdentifier: "courseView")
            //        self.present(goToVC, animated: true, completion: nil)
            //rvc 가 옵셔널 타입이므로 guard 구문을 통해서 옵셔널 바인딩 처리
            guard let rvc = storyboard.instantiateViewController(withIdentifier: "courseView") as? CourseViewController else {
                //아니면 종료
                return
            }
            rvc.storeSnArr.append(contentsOf: storeSnList)
            self.navigationController?.pushViewController(rvc, animated: true)
        }
    }
    
    func setUI(){
        svPlaceList.axis = .horizontal
        svPlaceList.removeSubviews()
        scvPlaceList.showsVerticalScrollIndicator = false
        setPlaceList()
    }
    func resetUpperUI(){
        svPlaceList.removeSubviews()
        setPlaceList()
    }
    
    func setPlaceList(){
        let num = UserDefaults.standard.value(forKey: plannerNumKey) as! Int
        if num > 0 {
            svPlaceList.removeSubviews()
            for i in 0...num - 1 {
                let getstr : JSON = loadJSON("PlannerKey" + String(i))
                setPlace(i,getstr)
            }
        } else {
            svPlaceList.removeSubviews()
            emptyPlace()
        }
    }
    
    
    func setPlace(_ num: Int, _ data: JSON){
        let uvItem = UIView()
        uvItem.translatesAutoresizingMaskIntoConstraints = false
        
        let imgLand = UIImageView(image: UIImage(named: "TempImage"))
        if !data["storeImageUrlList"].arrayValue.isEmpty {
            let url = URL(string: getImageURL(data["storeSn"].stringValue, data["storeImageUrlList"].arrayValue.first!.stringValue, tag: "store"))
            let urldata = try? Data(contentsOf: url!)
            if urldata != nil {
                imgLand.image = UIImage(data: urldata!)
            }
        }
        
        imgLand.clipsToBounds = true
        imgLand.layer.cornerRadius = 5
        imgLand.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        imgLand.widthAnchor.constraint(equalToConstant: view.frame.width * 0.15 - 5).isActive = true
        imgLand.heightAnchor.constraint(equalToConstant: view.frame.width * 0.15 - 5).isActive = true
        let lblTitle = UILabel()
        lblTitle.text = data["storeNm"].string
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
        sequenceBtn.isHidden = false
        sequenceBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 16).isActive = true
        sequenceBtn.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 16).isActive = true
        sequenceBtn.tag = num + 1
        
        uvItem.addSubview(sequenceBtn)
        sequenceBtn.topAnchor.constraint(equalTo: uvItem.topAnchor, constant: 0).isActive = true
        sequenceBtn.rightAnchor.constraint(equalTo: uvItem.rightAnchor, constant: 0).isActive = true
        
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.setImage(UIImage(named: "deletePlannerLoc"), for: .normal)
        deleteBtn.contentHorizontalAlignment = .center
        deleteBtn.contentVerticalAlignment = .center
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 16).isActive = true
        deleteBtn.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 16).isActive = true
        deleteBtn.tag = -(num + 1)
        deleteBtn.isHidden = true
        deleteBtn.accessibilityValue = String(num)
        deleteBtn.accessibilityIdentifier = data["storeSn"].string!
        deleteBtn.addTarget(self, action: #selector(removePlannerLoc(_:)), for: .touchUpInside)
        
        
        uvItem.addSubview(deleteBtn)
        deleteBtn.topAnchor.constraint(equalTo: uvItem.topAnchor, constant: 0).isActive = true
        deleteBtn.rightAnchor.constraint(equalTo: uvItem.rightAnchor, constant: 0).isActive = true
        
        
        setSequenceColor(data["prefSn"].string!,sequenceBtn)
        uvItem.accessibilityIdentifier = data["storeSn"].string!
        uvItem.accessibilityValue = String(num)
        uvItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addLocation(_:))))
        svPlaceList.addArrangedSubview(uvItem)
    }
    
    func emptyPlace(){
        let uvItem = UIView()
        uvItem.translatesAutoresizingMaskIntoConstraints = false
        
        let imgLand = UIImageView(image: UIImage(named: "PlannerLocationEmpty"))
        imgLand.clipsToBounds = true
        imgLand.layer.cornerRadius = 5
        imgLand.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        let uvImage = UIView()
        uvImage.translatesAutoresizingMaskIntoConstraints = false
        uvImage.addSubview(imgLand)
        
        
        let lblTitle = UILabel()
        lblTitle.text = "가고싶은 장소"
        lblTitle.fontSize = 13
        lblTitle.textColor = .darkGray
        //        lblTitle.textAlignment = .center
        
        let svItem = UIStackView(arrangedSubviews: [uvImage,lblTitle])
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .vertical
        svItem.distribution = .fill
        
        uvItem.addSubview(svItem)
        uvItem.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2).isActive = true
        uvItem.widthAnchor.constraint(equalToConstant: view.frame.width * 0.16).isActive = true
        svItem.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1).isActive = true
        svItem.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1).isActive = true
        svItem.leftAnchor.constraint(equalTo: uvItem.leftAnchor, constant: 0).isActive = true
        svItem.bottomAnchor.constraint(equalTo: uvItem.bottomAnchor, constant: 0).isActive = true
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        imgLand.widthAnchor.constraint(equalToConstant: view.frame.width * 0.15).isActive = true
        imgLand.heightAnchor.constraint(equalToConstant: view.frame.width * 0.15 - 5).isActive = true
        imgLand.leftAnchor.constraint(equalTo: svItem.leftAnchor, constant: 4).isActive = true
        uvImage.heightAnchor.constraint(equalToConstant: view.frame.width * 0.15).isActive = true
        uvImage.widthAnchor.constraint(equalToConstant: view.frame.width * 0.16).isActive = true
        lblTitle.leftAnchor.constraint(equalTo: svItem.leftAnchor, constant: 0).isActive = true
        lblTitle.rightAnchor.constraint(equalTo: svItem.rightAnchor, constant: 6).isActive = true
        
        svPlaceList.addArrangedSubview(uvItem)
    }
    
    // 상단 장소 리스트 편집모드
    func deleteMode(){
        let num = UserDefaults.standard.value(forKey: plannerNumKey) as! Int
        if num != 0 {
            for i in 1...num {
                self.svPlaceList.viewWithTag(i)?.isHidden = true
                self.svPlaceList.viewWithTag(-i)?.isHidden = false
            }
        }
    }
    func defaultMode(){
        let num = UserDefaults.standard.value(forKey: plannerNumKey) as! Int
        if num != 0 {
            for i in 1...num {
                self.svPlaceList.viewWithTag(i)?.isHidden = false
                self.svPlaceList.viewWithTag(-i)?.isHidden = true
            }
        }
    }
    @objc func removePlannerLoc(_ sender: UIButton){
        let num = UserDefaults.standard.value(forKey: plannerNumKey) as! Int
        let index = Int(sender.accessibilityValue!)!
        let storeSn : String = sender.accessibilityIdentifier!
        for i in index...num - 1 {
            if i == num - 1 {
                UserDefaults.standard.removeObject(forKey: "PlannerKey" + String(i))
            } else {
                let nextLoc = UserDefaults.standard.value(forKey: "PlannerKey" + String(i + 1))
                UserDefaults.standard.set(nextLoc, forKey: "PlannerKey" + String(i))
            }
        }
        UserDefaults.standard.set(num-1, forKey: plannerNumKey)
        
        var flag = false
        var n : Int = 0
        if selectedLoc.count != 0 {
            for i in 0...selectedLoc.count-1 {
                if storeSn == selectedLoc[i].storeSn {
                    flag = true
                    print(i, "\n flag \n")
                    print(selectedLoc[i].storeSn!)
                    n = i
                    break
                }
            }
            if flag {
                for i in n...selectedLoc.count-1 {
                    if i == selectedLoc.count-1 {
                        print(selectedLoc[i].storeSn!)
                        selectedLoc.remove(at: i)
                    }
                    else {
                        selectedLoc[i] = selectedLoc[i + 1]
                    }
                }
                print(selectedLoc)
                self.tableView.reloadData()
            }
        }
        if selectedLoc.count < 2 {
            makeCourseBtn.backgroundColor = .lightGray
            viewWillAppear(true)
        }
        setPlaceList()
        deleteMode()
    }
    
    @objc func addLocation(_ sender: UITapGestureRecognizer){
        //선택된 장소 리스트에 넣는 함수
        let index = sender.view!.accessibilityValue!
        let num = UserDefaults.standard.value(forKey: plannerNumKey) as! Int
        let storeSn : String = sender.view!.accessibilityIdentifier!
        var flag = true
        if selectedLoc.count != 0 {
            for i in 0...selectedLoc.count-1 {
                if storeSn == selectedLoc[i].storeSn {
                    flag = false
                }
            }
        }
        if flag {
            makeData(loadJSON("PlannerKey" + index))
            if selectedLoc.count > 1 {
                makeCourseBtn.backgroundColor = themeColor
                viewWillAppear(true)
            }
            self.tableView.reloadData()
        }
    }
    
    private func makeData(_ JsonData: JSON) {
        let data = LocationData.init()
        let imgStr : String = JsonData["storeImageUrlList"][0].string ?? ""
        initLocationData(
            LocationData: data,
            locationImage: imgStr,
            latitude: JsonData["latitude"].double!,
            longitude: JsonData["longitude"].double!,
            prefData: JsonData["prefData"].string!,
            prefSn: JsonData["prefSn"].string!,
            reprMenuPrice: JsonData["reprMenuPrice"].int!,
            storeAddr: JsonData["storeAddr"].string!,
            storeNm: JsonData["storeNm"].string!,
            storeSn: JsonData["storeSn"].string!,
            storeCostTm: JsonData["storeCostTm"].int!
        )
        if selectedLoc.count < 5 {
            selectedLoc.append(data)
        }
    }
    
    func setTableView(_ uiview: UIView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PlannerTableViewCell.self, forCellReuseIdentifier: PlannerTableViewCell.identifier)
        tableView.dataSource = self
        tableView.rowHeight = 100
        uiview.addSubview(tableView)
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
extension PlannerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedLoc.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlannerTableViewCell.identifier, for: indexPath) as! PlannerTableViewCell
        //        cell.uvItem.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        cell.uvItem.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cell.sequenceBtn.setTitle(String(indexPath.row + 1), for: .normal)
        cell.prefData = selectedLoc[indexPath.row].prefData
        cell.prefSn = selectedLoc[indexPath.row].prefSn
        cell.storeSn = selectedLoc[indexPath.row].storeSn
        cell.latitude = selectedLoc[indexPath.row].latitude
        cell.longitude = selectedLoc[indexPath.row].longitude
        cell.storeNm.text = selectedLoc[indexPath.row].storeNm ?? "장소명"
        cell.reprMenuPrice.text = "대표메뉴" + String(selectedLoc[indexPath.row].reprMenuPrice) + "원"
        cell.storeAddr.text = selectedLoc[indexPath.row].storeAddr ?? "위치"
        if selectedLoc[indexPath.row].locationImage != "" {
            let url = URL(string: getImageURL(selectedLoc[indexPath.row].storeSn, selectedLoc[indexPath.row].locationImage, tag: "store"))
            let data = try? Data(contentsOf: url!)
            if data != nil {
                cell.locationImage.image = UIImage(data: data!)
            }
            else {
                cell.locationImage.image = UIImage(named: "TempImage")
            }
        } else {
            cell.locationImage.image = UIImage(named: "TempImage")
        }
        
        setPref(cell.storeType,selectedLoc[indexPath.row].prefSn,selectedLoc[indexPath.row].prefData)
        setSequenceColor(selectedLoc[indexPath.row].prefSn,cell.sequenceBtn)
        return cell
    }
    //delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            // your items include cell variables
            for i in indexPath.row...selectedLoc.count-1 {
                if i == selectedLoc.count-1 {
                    selectedLoc.remove(at: i)
                }
                else {
                    selectedLoc[i] = selectedLoc[i + 1]
                    
                }
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if selectedLoc.count < 2 {
                makeCourseBtn.backgroundColor = .lightGray
                viewWillAppear(true)
            }
            self.tableView.reloadData()
        }
        
    }
    //drag and drop
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = selectedLoc[sourceIndexPath.row]
        selectedLoc.remove(at: sourceIndexPath.row)
        selectedLoc.insert(movedObject, at: destinationIndexPath.row)
        self.tableView.reloadData()
        print(selectedLoc)
    }
    
}

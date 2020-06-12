//
//  DibsCourseViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/12.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import XLPagerTabStrip
import Material

class DibsCourseViewController: UIViewController,UIGestureRecognizerDelegate, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
    let testNum = 10
    let lightGray = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    
    let scrollMain = UIScrollView()
    let svMain = UIStackView()
    let btnScrollUp = UIButton(type: .custom)
    
    let userData = getUserData()
    var responseJSON:JSON = []
    
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        requestCourse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        svMain.removeSubviews()
        requestCourse()
    }
    
    func requestCourse(){
        let url = OperationIP + "/course/selectCourseInfoList.do"
        let jsonHeader = JSON(["userSn":(userData["userSn"] as? String)!])
        let parameter = JSON([
            "bReverse": true
        ])
        
        let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        
        //        print(convertedHeaderString)
        //        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.responseJSON = JSON(response.value!)
                //                print("#########################################################")
                //                print(self.responseJSON)
                //                print("##")
                self.setUI()
            }
        }
    }
    
    func setUI(){
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        
        setCourseStack(responseJSON)
        
        btnScrollUp.isHidden = true
        btnScrollUp.setTitle("", for: .normal)
        btnScrollUp.translatesAutoresizingMaskIntoConstraints = false
        btnScrollUp.addTarget(self, action: #selector(upToTop(_:)), for: .touchUpInside)
        btnScrollUp.setImage(UIImage(named: "arrow_up"), for: .normal)
        view.addSubview(btnScrollUp)
        
        view.addConstraint(NSLayoutConstraint(item: btnScrollUp, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        btnScrollUp.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnScrollUp.widthAnchor.constraint(equalToConstant: 40).isActive = true
        btnScrollUp.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        
        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        panGestureRecongnizer.delegate = self
        scrollMain.addGestureRecognizer(panGestureRecongnizer)
        
    }
    
    func setCourseStack(_ reponseData: JSON){
        scrollMain.translatesAutoresizingMaskIntoConstraints = false
        
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.distribution = .fill
        svMain.axis = .vertical
        svMain.spacing = 15
        
        view.addSubview(scrollMain)
        view.addConstraint(NSLayoutConstraint(item: scrollMain, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.widthAnchor.constraint(equalTo: scrollMain.widthAnchor, multiplier: 1).isActive = true
        view.topAnchor.constraint(equalTo: scrollMain.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: scrollMain.bottomAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollMain.trailingAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: scrollMain.leadingAnchor, constant: 0).isActive = true
        
        scrollMain.addSubview(svMain)
        scrollMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: scrollMain, attribute: .centerX, multiplier: 1, constant: 0))
        svMain.widthAnchor.constraint(equalTo: scrollMain.widthAnchor, multiplier: 0.9).isActive = true
        svMain.topAnchor.constraint(equalTo: scrollMain.topAnchor, constant: 0).isActive = true
        svMain.bottomAnchor.constraint(equalTo: scrollMain.bottomAnchor, constant: 0).isActive = true
        
        let topView = UIView()
        topView.backgroundColor = .none
        topView.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        let bottomView = UIView()
        bottomView.backgroundColor = .none
        bottomView.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        
        svMain.addArrangedSubview(topView)
        
        let arrayData = reponseData.arrayValue
        for data in arrayData.reversed() {
            svMain.addArrangedSubview(createCourseView(data))
        }
        svMain.addArrangedSubview(bottomView)
    }
    
    func createCourseView(_ CourseData: JSON) -> UIView {
        let viewPost = UIView()
        viewPost.backgroundColor = .white
        //        viewPost.heightAnchor.constraint(equalToConstant: 150).isActive = true
        viewPost.layer.cornerRadius = 15
        viewPost.layer.borderWidth = 1
        viewPost.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewPost.layer.shadowColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        viewPost.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewPost.layer.shadowRadius = 2.0
        viewPost.layer.shadowOpacity = 0.9
        createCourseInfo(CourseData, viewPost)
        viewPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToCourseConfirm)))
        return viewPost
    }
    
    func createCourseInfo(_ CourseData: JSON,_ uvPost:UIView){
        uvPost.accessibilityIdentifier = CourseData["courseSn"].string
        let lblTitleCourse = UILabel()
        lblTitleCourse.text = CourseData["courseNm"].string
        lblTitleCourse.textColor = themeColor
        lblTitleCourse.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        let lblBudget = UILabel()
        let bugetStr = "1인 예산 - " + DecimalWon(CourseData["totalPrice"].intValue) + " | 소요 시간 - " + RegexTime(CourseData["costTm"].intValue)
        lblBudget.text = bugetStr
        lblBudget.textColor = .darkGray
        lblBudget.fontSize = 13
        
        let svLocation = UIStackView()
        svLocation.distribution = .fillEqually
        svLocation.axis = .horizontal
        svLocation.spacing = 14
        
        let placeArr = CourseData["courseDetailList"].arrayValue
        
        for i in 0...placeArr.count {
            for data in placeArr {
                if data["courseNumber"].intValue == i {
                    svLocation.addArrangedSubview(inputLoaction(data, data["courseNumber"].intValue))
                }
            }
        }
        
        
        if placeArr.count != 5 {
            for _ in placeArr.count...4 {
                svLocation.addArrangedSubview(tempLocation())
            }
        }
        let svCourse = UIStackView(arrangedSubviews: [lblTitleCourse,lblBudget,svLocation])
        svCourse.translatesAutoresizingMaskIntoConstraints = false
        svCourse.axis = .vertical
        svCourse.distribution = .fill
        svCourse.spacing = 10
        
        uvPost.addSubview(svCourse)
        uvPost.addConstraint(NSLayoutConstraint(item: svCourse, attribute: .centerX, relatedBy: .equal, toItem: uvPost, attribute: .centerX, multiplier: 1, constant: 0))
        uvPost.addConstraint(NSLayoutConstraint(item: svCourse, attribute: .centerY, relatedBy: .equal, toItem: uvPost, attribute: .centerY, multiplier: 1, constant: 0))
        svCourse.widthAnchor.constraint(equalTo: uvPost.widthAnchor, multiplier: 0.9).isActive = true
        svCourse.heightAnchor.constraint(equalTo: uvPost.heightAnchor, multiplier: 0.8).isActive = true
        
        let btnDelete = UIButton(type: .system)
        btnDelete.setTitle("삭제", for: .normal)
        btnDelete.translatesAutoresizingMaskIntoConstraints = false
        uvPost.addSubview(btnDelete)
        btnDelete.topAnchor.constraint(equalTo: uvPost.topAnchor, constant: 5).isActive = true
        btnDelete.trailingAnchor.constraint(equalTo: uvPost.trailingAnchor, constant: -10).isActive = true
        btnDelete.accessibilityIdentifier = CourseData["courseSn"].string
        btnDelete.addTarget(self, action: #selector(removeDidCourse(_:)), for: .touchUpInside)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    
    @objc func panAction(_ sender : UIPanGestureRecognizer){
        btnScrollUp.isHidden = (scrollMain.contentOffset.y <= 0)
    }
    @objc func upToTop(_ sender: Any) {
        scrollMain.scrollToTop()
        btnScrollUp.isHidden = true
    }
    
    func inputLoaction(_ CourseListData: JSON, _ index: Int) -> UIView {
        let uvLocation = UIView()
        
        let url = URL(string: getImageURL(CourseListData["storeSn"].stringValue, CourseListData["storeDTO"]["storeImageUrlList"].arrayValue.first!.stringValue, tag: "store"))
        let imgLocation = UIImageView()
        let data = try? Data(contentsOf: url!)
        if data != nil {
            imgLocation.image = UIImage(data: data!)
        } else {
            imgLocation.image = UIImage(named: "TempImage")
        }
        //        let imgLocation = UIImageView(image: UIImage(named: "TempImage"))
        imgLocation.heightAnchor.constraint(equalTo: imgLocation.widthAnchor, multiplier: 1).isActive = true
        imgLocation.contentMode = .scaleAspectFill
        imgLocation.clipsToBounds = true
        imgLocation.layer.cornerRadius = 15
        
        let lblLoation = UILabel()
        lblLoation.text = CourseListData["storeDTO"]["storeNm"].string
        lblLoation.textColor = .darkGray
        lblLoation.textAlignment = .center
        lblLoation.fontSize = 12
        
        let svLoaction = UIStackView(arrangedSubviews: [imgLocation,lblLoation])
        svLoaction.translatesAutoresizingMaskIntoConstraints = false
        svLoaction.distribution = .fill
        svLoaction.spacing = 4
        svLoaction.axis = .vertical
        
        uvLocation.addSubview(svLoaction)
        uvLocation.addConstraint(NSLayoutConstraint(item: svLoaction, attribute: .centerX, relatedBy: .equal, toItem: uvLocation, attribute: .centerX, multiplier: 1, constant: 0))
        uvLocation.addConstraint(NSLayoutConstraint(item: svLoaction, attribute: .centerY, relatedBy: .equal, toItem: uvLocation, attribute: .centerY, multiplier: 1, constant: 0))
        svLoaction.widthAnchor.constraint(equalTo: uvLocation.widthAnchor, multiplier: 1.05).isActive = true
        svLoaction.heightAnchor.constraint(equalTo: uvLocation.heightAnchor, multiplier: 1).isActive = true
        
        let lblLoationIndex = UILabel()
        lblLoationIndex.translatesAutoresizingMaskIntoConstraints = false
        lblLoationIndex.text = String(index+1)
        lblLoationIndex.textColor = .white
        lblLoationIndex.textAlignment = .center
        lblLoationIndex.fontSize = 11
        lblLoationIndex.backgroundColor = themeColor
        lblLoationIndex.widthAnchor.constraint(equalToConstant: 16).isActive = true
        lblLoationIndex.heightAnchor.constraint(equalToConstant: 16).isActive = true
        lblLoationIndex.layer.masksToBounds = true
        lblLoationIndex.layer.cornerRadius = 8
        uvLocation.addSubview(lblLoationIndex)
        lblLoationIndex.centerXAnchor.constraint(equalTo: imgLocation.trailingAnchor, constant: -2).isActive = true
        lblLoationIndex.centerYAnchor.constraint(equalTo: imgLocation.topAnchor, constant:  2).isActive = true
        
        return uvLocation
    }
    func tempLocation() -> UIView {
        let uvLocation = UIView()
        
        let imgLocation = UIImageView()
        imgLocation.heightAnchor.constraint(equalTo: imgLocation.widthAnchor, multiplier: 1).isActive = true
        imgLocation.contentMode = .scaleAspectFill
        imgLocation.clipsToBounds = true
        imgLocation.layer.cornerRadius = 15
        
        let lblLoation = UILabel()
        lblLoation.text = " "
        lblLoation.textAlignment = .center
        lblLoation.fontSize = 12
        
        let svLoaction = UIStackView(arrangedSubviews: [imgLocation,lblLoation])
        svLoaction.translatesAutoresizingMaskIntoConstraints = false
        svLoaction.distribution = .fill
        svLoaction.spacing = 4
        svLoaction.axis = .vertical
        
        uvLocation.addSubview(svLoaction)
        uvLocation.addConstraint(NSLayoutConstraint(item: svLoaction, attribute: .centerX, relatedBy: .equal, toItem: uvLocation, attribute: .centerX, multiplier: 1, constant: 0))
        uvLocation.addConstraint(NSLayoutConstraint(item: svLoaction, attribute: .centerY, relatedBy: .equal, toItem: uvLocation, attribute: .centerY, multiplier: 1, constant: 0))
        svLoaction.widthAnchor.constraint(equalTo: uvLocation.widthAnchor, multiplier: 1.05).isActive = true
        svLoaction.heightAnchor.constraint(equalTo: uvLocation.heightAnchor, multiplier: 1).isActive = true
        
        let lblLoationIndex = UILabel()
        lblLoationIndex.translatesAutoresizingMaskIntoConstraints = false
        lblLoationIndex.text = " "
        lblLoationIndex.textAlignment = .center
        lblLoationIndex.fontSize = 11
        lblLoationIndex.widthAnchor.constraint(equalToConstant: 16).isActive = true
        lblLoationIndex.heightAnchor.constraint(equalToConstant: 16).isActive = true
        lblLoationIndex.layer.masksToBounds = true
        lblLoationIndex.layer.cornerRadius = 8
        uvLocation.addSubview(lblLoationIndex)
        lblLoationIndex.centerXAnchor.constraint(equalTo: imgLocation.trailingAnchor, constant: -2).isActive = true
        lblLoationIndex.centerYAnchor.constraint(equalTo: imgLocation.topAnchor, constant:  2).isActive = true
        
        return uvLocation
    }
    
    // MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    @objc func goToCourseConfirm(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let goToVC = storyboard.instantiateViewController(withIdentifier: "courseView")
        guard let rvc = storyboard.instantiateViewController(withIdentifier: "courseView") as? CourseViewController else {
            //아니면 종료
            return
        }
        rvc.courseSn = sender.view!.accessibilityIdentifier!
//        rvc.storeSnArr.append(contentsOf: self.selectedStoresn)
//        print("rcv = ", self.selectedStoresn)
        self.navigationController?.pushViewController(rvc, animated: true)
        
    }
    
    // ##################################################
    // #################### 코스 삭제 ######################
    // ##################################################
    func deleteCourse(_ strCourseSn: String){
        let url = OperationIP + "/course/deleteCourseInfo.do"
        let parameter = JSON([
            "courseSn": strCourseSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                let requestJSON = JSON(response.value!)
                print("##")
                print("## " + requestJSON["result"].stringValue + " ##")
                print("##")
                
                for (index,view) in self.svMain.arrangedSubviews.enumerated() {
                    if view.accessibilityIdentifier == strCourseSn{
//                        view.isHidden = true
                        self.svMain.arrangedSubviews[index].removeFromSuperview()
                    }
                }
                
//                self.requestCourse()
            }
        }
    }
    @objc func removeDidCourse(_ sender: IconButton) {
        let alertController = UIAlertController(title: "코스 삭제", message: "코스를 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.deleteCourse(sender.accessibilityIdentifier!)
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}

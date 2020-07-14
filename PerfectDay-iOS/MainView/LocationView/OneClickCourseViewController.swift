//
//  OneClickCourseViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/06/30.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class OneClickCourseViewController: UIViewController {
    
    @IBOutlet var indicLoading: UIActivityIndicatorView!
    @IBOutlet var scvCourse: UIScrollView!
    @IBOutlet var svCourse: UIStackView!
    
    @IBOutlet var uvGrayBack: UIView!
    @IBOutlet var uvAlert: UIView!
    @IBOutlet var lblGPAReview: UILabel!
    
    let themeColor = #colorLiteral(red: 0.9545153975, green: 0.4153810143, blue: 0.6185087562, alpha: 1)
    var responseJSON: Array<JSON> = []
    var courseSn = ""
    var selectedBtn = UIButton()
    
    // 별점 주기 변수
    let slider = UISlider()
    let stackView = UIStackView()
    let strReivew = ["별로예요.",
                     "아쉬워요.",
                     "무난하네요.",
                     "좋아요! 마음에 듭니다.",
                     "마음에 쏙 들어요! 적극추천~"]
    var Score:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNavigationBar()
        getCourseInfo()
    }
    
    func setNavigationBar(){
        self.navigationItem.title = "원클릭 추천 코스"
        let backItem = UIBarButtonItem()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
        
        uvAlert.layer.cornerRadius = 10
        uvGrayBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideGaryView(_:))))
    }
    
    func getCourseInfo() {
        let url = OperationIP + "/oneClick/selectOneClickInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        AF.request(url,method: .post, headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                print("~~~~~~~~~~~~~~~~~~~~~~~원클릭코스")
                                print(JSON(response.value!))
                print("~~~~~~~~~~~~~~~~~~~~~~~")
                self.responseJSON = JSON(response.value!).arrayValue
                self.setCourseInfoListCard(self.responseJSON)
            }
        }
    }
    
    func setCourseInfoListCard(_ CourseInfoList: [JSON]){
        svCourse.removeSubviews()
        for CourseInfo in CourseInfoList {
            let viewPost = UIView()
            viewPost.backgroundColor = .white
            viewPost.layer.cornerRadius = 15
            //            viewPost.layer.borderWidth = 1
            //            viewPost.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            //            viewPost.layer.shadowColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            viewPost.layer.shadowColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            viewPost.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            viewPost.layer.shadowRadius = 1.0
            viewPost.layer.shadowOpacity = 1
            createCourseInfo(CourseInfo, viewPost)
            //        viewPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToCourseConfirm)))
            svCourse.addArrangedSubview(viewPost)
        }
        let bottomView = UIView()
        bottomView.backgroundColor = .none
        bottomView.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        svCourse.addArrangedSubview(bottomView)
        indicLoading.stopAnimating()
    }
    
    func createCourseInfo(_ CourseData: JSON,_ uvPost:UIView){
        let lblTitleCourse = UILabel()
        lblTitleCourse.text = CourseData["courseDTO"]["courseNm"].string
        lblTitleCourse.textColor = themeColor
        lblTitleCourse.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        let lblBudget = UILabel()
        let bugetStr = "1인 예산 - " + DecimalWon(CourseData["courseDTO"]["totalPrice"].intValue) + " | 소요 시간 - " + RegexTime(CourseData["courseDTO"]["costTm"].intValue)
        lblBudget.text = bugetStr
        lblBudget.textColor = .darkGray
        lblBudget.fontSize = 13
        
        let svLocation = UIStackView()
        svLocation.distribution = .fillEqually
        svLocation.axis = .horizontal
        svLocation.spacing = 14
        
        let placeArr = CourseData["courseDTO"]["courseDetailList"].arrayValue
        
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
        
        let btnScore: UIButton = {
            let btn = UIButton(type: .custom)
            btn.setTitle(String(format: "%.1f", CourseData["courseDTO"]["courseScore"].floatValue)+"("+String(CourseData["scoreCnt"].intValue)+"명 평가)", for: .normal)
            btn.setTitleColor(.darkGray, for: .normal)
            btn.setTitleColor(.lightGray, for: .highlighted)
            btn.fontSize = 13
            btn.setImage(UIImage(named: CourseData["myCourseScore"].intValue == 0 ? "GPAIconOff" : "GPAIcon"), for: .normal)
            btn.isUserInteractionEnabled = (CourseData["myCourseScore"].intValue == 0)
            btn.contentHorizontalAlignment = .center
            btn.accessibilityIdentifier = CourseData["courseSn"].stringValue
            btn.addTarget(self, action: #selector(showSendScoreView(_:)), for: .touchUpInside)
            return btn
        }()
        
        let midLine:UIView = {
            let view = UIView()
            view.backgroundColor = .darkGray
            view.widthAnchor.constraint(equalToConstant: 1).isActive = true
            
            return view
        }()
        
        let btnDibCourse:UIButton = {
            let btn = UIButton()
            btn.setTitle("코스 찜하기", for: .normal)
            btn.setTitleColor(.darkGray, for: .normal)
            btn.setTitleColor(.lightGray, for: .highlighted)
            btn.fontSize = 13
            btn.setImage(UIImage(named: CourseData["pickThisCourse"].boolValue ? "FillHeart" : "EmptyHeart"), for: .normal)
            btn.contentHorizontalAlignment = .center
            btn.accessibilityIdentifier = CourseData["courseSn"].stringValue
            btn.addTarget(self, action: #selector(requestDibCourse(_:)), for: .touchUpInside)
            btn.tag = CourseData["pickThisCourse"].boolValue ? 1 : 0
            return btn
        }()
        
        let svFunc = UIStackView(arrangedSubviews: [btnScore,btnDibCourse])
        svFunc.spacing = 1
        svFunc.distribution = .fillEqually
        
        let svCourse = UIStackView(arrangedSubviews: [lblTitleCourse,lblBudget,svLocation,svFunc])
        svCourse.translatesAutoresizingMaskIntoConstraints = false
        svCourse.axis = .vertical
        svCourse.distribution = .fill
        svCourse.spacing = 10
        
        uvPost.addSubview(svCourse)
        uvPost.addConstraint(NSLayoutConstraint(item: svCourse, attribute: .centerX, relatedBy: .equal, toItem: uvPost, attribute: .centerX, multiplier: 1, constant: 0))
        uvPost.addConstraint(NSLayoutConstraint(item: svCourse, attribute: .centerY, relatedBy: .equal, toItem: uvPost, attribute: .centerY, multiplier: 1, constant: 0))
        svCourse.widthAnchor.constraint(equalTo: uvPost.widthAnchor, multiplier: 0.9).isActive = true
        svCourse.heightAnchor.constraint(equalTo: uvPost.heightAnchor, multiplier: 0.8).isActive = true
        uvPost.accessibilityIdentifier = CourseData["courseSn"].stringValue
        uvPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoCourseInfo(_:))))
        
        let btnDelete = UIButton(type: .system)
        btnDelete.setTitle(CourseData["userDTO"]["userName"].stringValue, for: .normal)
        btnDelete.isUserInteractionEnabled = false
        btnDelete.translatesAutoresizingMaskIntoConstraints = false
        uvPost.addSubview(btnDelete)
        btnDelete.topAnchor.constraint(equalTo: uvPost.topAnchor, constant: 5).isActive = true
        btnDelete.trailingAnchor.constraint(equalTo: uvPost.trailingAnchor, constant: -10).isActive = true
    }
    
    func inputLoaction(_ StoreInfo: JSON, _ index: Int) -> UIView {
        let uvLocation = UIView()
        
        let url = URL(string: getImageURL(StoreInfo["storeSn"].stringValue, StoreInfo["storeDTO"]["storeImageUrlList"].arrayValue.first!.stringValue, tag: "store"))
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
        lblLoation.text = StoreInfo["storeDTO"]["storeNm"].string
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
    
    // @object Func
    @objc func requestDibCourse(_ sender : UIButton){
        print(sender.accessibilityIdentifier!)
        //        let courseSn = sender.accessibilityIdentifier!
        (sender.tag == 0) ? requestInsertDibCourse(sender) : requestDeleteDibCourse(sender)
        
    }
    func requestInsertDibCourse(_ btn: UIButton) {
        let url = OperationIP + "/oneClick/insertOneClickCourseInfo.do"
        let courseSn = btn.accessibilityIdentifier!
        let parameter = JSON([
            "courseSn": courseSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                if JSON(response.value!)["result"].stringValue != "0" {
                    btn.tag = 1
                    btn.setImage(UIImage(named: "FillHeart"), for: .normal)
                }
            }
        }
    }
    func requestDeleteDibCourse(_ btn: UIButton) {
        let url = OperationIP + "/oneClick/deleteOneClickCourseInfo.do"
        let courseSn = btn.accessibilityIdentifier!
        let parameter = JSON([
            "courseSn": courseSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                if JSON(response.value!)["result"].stringValue != "0" {
                    btn.tag = 0
                    btn.setImage(UIImage(named: "EmptyHeart"), for: .normal)
                }
            }
        }
    }
    
    @objc func showSendScoreView(_ sender: UIButton){
        selectedBtn = sender
        uvGrayBack.isHidden = false
        uvAlert.isHidden = false
        self.courseSn = sender.accessibilityIdentifier!
    }
    func requestSendScore(_ courseSn: String, _ courseScore: Float){
        let url = OperationIP + "/oneClick/insertCourseReviewInfo.do"
        let parameter = JSON([
            "courseSn": courseSn,
            "myCourseScore": courseScore
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        
        print(convertedParameterString)
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
//            debugPrint(response)
            if response.value != nil {
//                print(response.value!)
                self.selectedBtn.setImage(UIImage(named: JSON(response.value!)["result"].floatValue != 0 ? "GPAIcon" : "GPAIconOff"), for: .normal)
            }
        }
    }
    
    @objc func gotoCourseInfo(_ sender:UITapGestureRecognizer){
//        let courseSn = sender.view?.accessibilityIdentifier!
//        print(courseSn)
    }
    @IBAction func starPointChanged(_ sender: UISlider) {
        let roundValue = round(sender.value)
        for index in 1 ... 5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if index <= Int(roundValue) {
                    starImage.image = UIImage(named: "GPAIcon")
                }else{
                    starImage.image = UIImage(named: "GPAIconOff")
                }
            }
        }
        Score = Int(roundValue)
//        print(Float(Score))
        //        lblGPAReview.accessibilityValue = String(roundValue)
        lblGPAReview.text = strReivew[Int(roundValue) - 1]
    }
    
    @objc func hideGaryView(_ sender: UITapGestureRecognizer){
        uvGrayBack.isHidden = true
        uvAlert.isHidden = true
    }
    @IBAction func cancelReview(_ sender: UIButton) {
        uvGrayBack.isHidden = true
        uvAlert.isHidden = true
    }
    @IBAction func insertCourseReview(_ sender: UIButton) {
        requestSendScore(self.courseSn, Float(Score))
        uvGrayBack.isHidden = true
        uvAlert.isHidden = true
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

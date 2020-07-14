//
//  LandmarkViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/05.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class LandmarkViewController: UIViewController {
    
    @IBOutlet var imgLandMark: UIImageView!
    @IBOutlet var svHashTag: UIStackView!
    @IBOutlet var scLandmark: UIScrollView!
    @IBOutlet var svLandmark: UIStackView!
    @IBOutlet var indicLoading: UIActivityIndicatorView!
    
    var areaSdDetailCode = ""
    var listLandmarkData:Array<JSON> = []
    
    //        let svLandmark = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        indicLoading.center = view.center
        setLandmarkMapImg()
        getHashTag(svHashTag)
        getLandmarkInfo()
    }
    func setLandmarkMapImg() {
        switch areaSdDetailCode {
        case "01" :
            imgLandMark.image = UIImage(named: "Landmark_Gangnam")
            break
        case "02" :
            imgLandMark.image = UIImage(named: "Landmark_Gangdong")
            break
        case "03" :
            imgLandMark.image = UIImage(named: "Landmark_Gangbuk")
            break
        case "04" :
            imgLandMark.image = UIImage(named: "Landmark_Gangseo")
            break
        case "05" :
            imgLandMark.image = UIImage(named: "Landmark_Gwanak")
            break
        case "06" :
            imgLandMark.image = UIImage(named: "Landmark_Gwangjin")
            break
        case "07" :
            imgLandMark.image = UIImage(named: "Landmark_Guro")
            break
        case "08" :
            imgLandMark.image = UIImage(named: "Landmark_Geumcheon")
            break
        case "09" :
            imgLandMark.image = UIImage(named: "Landmark_Nowon")
            break
        case "10" :
            imgLandMark.image = UIImage(named: "Landmark_Dobong")
            break
        case "11" :
            imgLandMark.image = UIImage(named: "Landmark_Dongdaemun")
            break
        case "12" :
            imgLandMark.image = UIImage(named: "Landmark_Dongjak")
            break
        case "13" :
            imgLandMark.image = UIImage(named: "Landmark_Mapo")
            break
        case "14" :
            imgLandMark.image = UIImage(named: "Landmark_Seodaemun")
            break
        case "15" :
            imgLandMark.image = UIImage(named: "Landmark_Seocho")
            break
        case "16" :
            imgLandMark.image = UIImage(named: "Landmark_Seongdong")
            break
        case "17" :
            imgLandMark.image = UIImage(named: "Landmark_Seongbuk")
            break
        case "18" :
            imgLandMark.image = UIImage(named: "Landmark_Songpa")
            break
        case "19" :
            imgLandMark.image = UIImage(named: "Landmark_Yangcheon")
            break
        case "20" :
            imgLandMark.image = UIImage(named: "Landmark_Yeongdeungpo")
            break
        case "21" :
            imgLandMark.image = UIImage(named: "Landmark_Yongsan")
            break
        case "22" :
            imgLandMark.image = UIImage(named: "Landmark_Eunpyeong")
            break
        case "23" :
            imgLandMark.image = UIImage(named: "Landmark_Jongro")
            break
        case "24" :
            imgLandMark.image = UIImage(named: "Landmark_Jung")
            break
        case "25" :
            imgLandMark.image = UIImage(named: "Landmark_Jungnang")
            break
        default :
            imgLandMark.image = UIImage(named: "")
            break
        }
    }
    func getHashTag(_ svTag: UIStackView){
        let url = OperationIP + "/tag/selectHashTagList.do"
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        AF.request(url,method: .post,headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                self.setHashTag(svTag,JSON(response.value!).arrayValue)
            }
        }
    }
    func setHashTag(_ svTag:UIStackView, _ listTag: [JSON]){
        for hashTag in listTag {
            let btnHashTag = UIButton(type: .system)
            btnHashTag.setTitle(setHashTagString(hashTag["tag"].stringValue))
            btnHashTag.layer.cornerRadius = 15
            btnHashTag.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            btnHashTag.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
            btnHashTag.addTarget(self, action: #selector(searchByTag(_:)), for: .touchUpInside)
            svTag.addArrangedSubview(btnHashTag)
        }
    }
    @objc func searchByTag(_ sender: UIButton){
        let strTag = sender.titleLabel!.text!.trimmingCharacters(in: ["#"," "])
        selectedTag = strTag
        self.tabBarController?.selectedViewController = self.tabBarController?.children[1]
    }
    
    func getLandmarkInfo(){
        let url = OperationIP + "/landmark/selectLandmarkInfoList.do"
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn,"deviceOS":"IOS"]
        let parameter = JSON([
            "areaSdCode" : SeoulSn,
            "areaDetailCode" : areaSdDetailCode,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                let responseJSON = JSON(response.value!)
                self.listLandmarkData = responseJSON.arrayValue
                //                print(responseJSON)
                self.setUI()
            }
        }
    }
    
    func setUI(){
        for btn in svHashTag.arrangedSubviews {
            btn.layer.cornerRadius = 15
            btn.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            btn.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
        }
        setStackView()
        for i in listLandmarkData {
            makeLandmarkItem(i)
        }
        let bottomUI = UIView()
        bottomUI.frame.size.height = 20
        svLandmark.addArrangedSubview(bottomUI)
        indicLoading.stopAnimating()
    }
    
    func setStackView(){
        svLandmark.axis = .vertical
        svLandmark.spacing = 15
        //        scLandmark.backgroundColor = .systemPink
        scLandmark.bounces = false
        scLandmark.showsVerticalScrollIndicator = false
        //UIview 넣고 Hide로 숨기기
    }
    
    func makeLandmarkItem(_ item:JSON) {
//        print(item)
        let uvItem = UIView()
        uvItem.translatesAutoresizingMaskIntoConstraints = false
        
        // 나중 - UIFunction에 있는 함수로 바꿈
        let lblTitle = UILabel()
        lblTitle.textColor = .darkText
        lblTitle.text = item["landmarkName"].stringValue
        lblTitle.fontSize = 15
        let lblContent = UILabel()
        lblContent.text = item["landmarkDesc"].stringValue
        lblContent.lineBreakMode = .byWordWrapping
        lblContent.numberOfLines = 2
        lblContent.fontSize = 13
        //        lblContent.heightAnchor.constraint(equalToConstant: lblContent.frame.height ).isActive = true
        lblContent.textColor = .darkGray
        
        let lblAddress = UIButton(type: .custom)
        lblAddress.isUserInteractionEnabled = false
        lblAddress.setImage(UIImage(named: "AddressIcon"), for: .normal)
        lblAddress.setTitle(item["landmarkAddress"].stringValue, for: .normal)
        lblAddress.setTitleColor(.darkGray, for: .normal)
        lblAddress.semanticContentAttribute = .forceLeftToRight
        lblAddress.contentHorizontalAlignment = .left
        lblAddress.fontSize = 13
        
        let uvMid = UIView()
        uvMid.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        //        midUI.heightAnchor.constraint(equalToConstant: view.frame.width / 33 ).isActive = true
        let lblTouch = UILabel()
        lblTouch.textColor = .darkText
        lblTouch.text = "클릭수 " + item["landmarkViewCount"].stringValue
        lblTouch.fontSize = 12
        
        let url = URL(string: getImageURL(item["landmarkSn"].stringValue, item["landmarkImageUrlList"].arrayValue.first!.stringValue,tag: "landmark"))
        let data = try? Data(contentsOf: url!)
        let imgLand = UIImageView()
        if data != nil {
            imgLand.image = UIImage(data: data!)
        } else {
            imgLand.image = UIImage(named: "TempImage")
        }
        imgLand.clipsToBounds = true
        imgLand.layer.cornerRadius = 5
        imgLand.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        imgLand.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgLand.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imgLand.contentMode = .scaleAspectFill
        
        let svInfo = UIStackView(arrangedSubviews: [lblTitle,lblContent,lblAddress,uvMid,lblTouch])
        svInfo.translatesAutoresizingMaskIntoConstraints = false
        svInfo.axis = .vertical
        svInfo.distribution = .fill
        svInfo.spacing = 1
        
        let uvInfo = UIView()
        uvInfo.addSubview(svInfo)
        uvInfo.translatesAutoresizingMaskIntoConstraints = false
        //        uvInfo.widthAnchor.constraint(equalToConstant: view.frame.width * 0.54).isActive = true
        //        uvInfo.heightAnchor.constraint(equalToConstant: view.frame.width * 0.27).isActive = true
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerX, relatedBy: .equal, toItem: uvInfo,
                                                attribute: .centerX, multiplier: 1, constant: 0))
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerY, relatedBy: .equal, toItem: uvInfo,
                                                attribute: .centerY, multiplier: 1, constant: 0))
        //        svInfo.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.54) - 15).isActive = true
        //        svInfo.heightAnchor.constraint(equalToConstant: (view.frame.width * 0.27) - 15).isActive = true
        svInfo.widthAnchor.constraint(equalTo: uvInfo.widthAnchor, multiplier: 0.9).isActive = true
        svInfo.heightAnchor.constraint(equalTo: uvInfo.heightAnchor, multiplier: 0.9).isActive = true
        
        let svMain = UIStackView(arrangedSubviews: [imgLand,uvInfo])
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.axis = .horizontal
        svMain.distribution = .fill
        //        svMain.widthAnchor.constraint(equalToConstant: view.frame.width * 0.81).isActive = true
        //        svMain.heightAnchor.constraint(equalToConstant: view.frame.width * 0.27).isActive = true
        
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
        recommandBtn.translatesAutoresizingMaskIntoConstraints = false
        recommandBtn.setTitle("주\n변\n추\n천", for: .normal)
        recommandBtn.titleLabel?.numberOfLines = 4
        recommandBtn.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
        recommandBtn.setTitleColor(#colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1), for: .normal)
        recommandBtn.fontSize = 13
        recommandBtn.layer.borderWidth = 0.5
        recommandBtn.layer.cornerRadius = 5
        recommandBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        let svItem = UIStackView(arrangedSubviews: [uvMain, recommandBtn])
        //        svItem.addSubview(uvMain)
        //        svItem.addSubview(recommandBtn)
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .horizontal
        svItem.distribution = .fill
        svItem.spacing = 10
        
        
        uvItem.addSubview(svItem)
        //        uvItem.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        //        uvItem.heightAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 0.3).isActive = true
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        svItem.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1).isActive = true
        svItem.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1).isActive = true
        
        uvMain.accessibilityIdentifier = item["landmarkSn"].stringValue
        uvMain.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationList(_:))))
        
        svLandmark.addArrangedSubview(uvItem)
    }
    
    @objc func gotoLocationList(_ sender:UITapGestureRecognizer){
        let landmarkSn = sender.view!.accessibilityIdentifier!
        updateLandmarkInfo(landmarkSn)
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "locationListView") as! LocationListViewController
        goToVC.landmarkSn = landmarkSn
        self.navigationController?.pushViewController(goToVC, animated: true)
    }
    
    func  updateLandmarkInfo(_ landmarkSn: String){
        let url = OperationIP + "/landmark/updateLandmarkInfo.do"
        let parameter = JSON([
            "landmarkSn" : landmarkSn,
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString]).responseJSON { response in
            if response.value != nil {
//                print(response.value!)
            }
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

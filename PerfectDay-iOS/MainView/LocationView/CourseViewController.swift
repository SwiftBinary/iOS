//
//  CourseViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/09.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Material

class CourseViewController: UIViewController {
    
    @IBOutlet var scvCourse: UIScrollView!
    
    @IBOutlet var svCourse: UIStackView!
    @IBOutlet var uvDetailDescriptionPlace: UIView!
    
    let userData = getUserData()
    var responseJSON:Array<JSON> = []
//    var response : Array<JSON> = []
    
    var resultStoreSn : Array<String>?
    var storeSnArr : Array<String> = []
    
    var temp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setStoreSnArray()
        // Do any additional setup after loading the view.

    }
    
    func setStoreSnArray(){
        resultStoreSn = self.storeSnArr
        let n = resultStoreSn!.count-1
        for i in 0...n {
            if resultStoreSn![n-i] == "" {
                resultStoreSn?.remove(at: n-i)
            }
        }
        requestLocations()
    }
    
    func setNavigationBar(){
        self.navigationItem.title = "완벽한 하루"
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
    }
    
    func requestLocations(){
        print(resultStoreSn!)
        requestStore(0)
//        for i in 0...resultStoreSn!.count-1 {
//            requestStore(i)
//        }
    }
    
    func requestStore(_ num : Int){
        let url = OperationIP + "/store/selectStoreInfo.do"
            let parameter = JSON([
                "storeSn": storeSnArr[num]
            ])
//            let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            
            let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
            //        print(convertedHeaderString)
            //        print(convertedParameterString)
            
            AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
                debugPrint(response)
                if response.value != nil {
//                    print("\n\n\n\n\n\n",num,"\n\n\n\n\n\n")
                    self.responseJSON.append(JSON(response.value!))
//                    print("############################################s\n\n\n")
//                    print(self.responseJSON)
//                    print("############################################f\n\n\n")
                    self.temp += 1
                    if num != 0 {
                        self.nextCourse()
                    }
                    self.setCourse(num, self.responseJSON[num])
                    if num != self.resultStoreSn!.count-1 {
                        self.requestStore(num+1)
                    } else {
                        self.setUI()
                    }
//                    if num == self.storeSnArr.count - 1 {
//
//                        self.setUI()
//                    }
                }
        }
    }
    
    func setUI(){
        setDescription()
        svCourse.axis = .vertical
//        svCourse.removeSubviews()
        scvCourse.bounces = false
        scvCourse.showsVerticalScrollIndicator = false
//        for i in 0...resultStoreSn!.count-1 {
//            if i != 0 {
//                nextCourse()
//            }
//            setCourse(i, responseJSON[i + 1])
//        }
    }
    
    func setDescription(){
        uvDetailDescriptionPlace.layer.borderWidth = 1
        uvDetailDescriptionPlace.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        uvDetailDescriptionPlace.layer.cornerRadius = 5
    }
    
    func nextCourse(){
        print("\n\n\n\n\n\n nextCourse \n\n\n\n\n\n")
        let uvItem = UIView()
        uvItem.translatesAutoresizingMaskIntoConstraints = false
        uvItem.backgroundColor = .clear
        
        let uvline = UIView()
        uvline.translatesAutoresizingMaskIntoConstraints = false
        uvline.backgroundColor = .lightGray
        
        uvItem.addSubview(uvline)
        uvItem.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        uvItem.heightAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 0.04).isActive = true
        uvline.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 3).isActive = true
        uvline.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1).isActive = true
        uvline.leftAnchor.constraint(equalTo: uvItem.leftAnchor, constant: 23.5).isActive = true
        uvline.topAnchor.constraint(equalTo: uvItem.topAnchor, constant: 0).isActive = true
        uvline.bottomAnchor.constraint(equalTo: uvItem.bottomAnchor, constant: 0).isActive = true
        
        let pathBtn = UIButton(type: .custom)
        pathBtn.setImage(UIImage(named: "CourseNext"), for: .normal)
        pathBtn.contentHorizontalAlignment = .center
        pathBtn.translatesAutoresizingMaskIntoConstraints = false
        
        uvItem.addSubview(pathBtn)
        pathBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 50).isActive = true
        pathBtn.heightAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 0.04).isActive = true
        pathBtn.leftAnchor.constraint(equalTo: uvItem.leftAnchor, constant: 0).isActive = true
        pathBtn.topAnchor.constraint(equalTo: uvItem.topAnchor, constant: 0).isActive = true
        pathBtn.bottomAnchor.constraint(equalTo: uvItem.bottomAnchor, constant: 0).isActive = true
        
        svCourse.addArrangedSubview(uvItem)
    }
    
    func setCourse(_ num: Int,_ storeData : JSON){
        print("\n\n\n\n\n\n setCourse : ",num,"\n\n\n\n\n\n")
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
        uvBack.heightAnchor.constraint(equalTo: uvBack.widthAnchor, multiplier: 0.2).isActive = true
        uvline.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 3).isActive = true
        uvline.heightAnchor.constraint(equalTo: uvBack.heightAnchor, multiplier: 1).isActive = true
        uvline.leftAnchor.constraint(equalTo: uvBack.leftAnchor, constant: 23.5).isActive = true
        uvline.topAnchor.constraint(equalTo: uvBack.topAnchor, constant: 0).isActive = true
        uvline.bottomAnchor.constraint(equalTo: uvBack.bottomAnchor, constant: 0).isActive = true
        
        uvItem.addSubview(uvBack)
        
        
        let sequenceBtn = UIButton(type: .custom)
        sequenceBtn.translatesAutoresizingMaskIntoConstraints = false
        sequenceBtn.setTitle("\(num + 1)", for: .normal)
        sequenceBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        sequenceBtn.setTitleColor(.white, for: .normal)
        sequenceBtn.contentHorizontalAlignment = .center
        sequenceBtn.contentVerticalAlignment = .center
        sequenceBtn.isUserInteractionEnabled = false
        sequenceBtn.layer.cornerRadius = 10.5
        setSequenceColor(storeData["prefSn"].string!,sequenceBtn)
        
        let uvSequence = UIView()
        uvSequence.translatesAutoresizingMaskIntoConstraints = false
        uvSequence.addSubview(sequenceBtn)
        uvSequence.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 50).isActive = true
        uvSequence.addConstraint(NSLayoutConstraint(item: sequenceBtn, attribute: .centerX, relatedBy: .equal, toItem: uvSequence, attribute: .centerX, multiplier: 1, constant: 0))
        uvSequence.addConstraint(NSLayoutConstraint(item: sequenceBtn, attribute: .centerY, relatedBy: .equal, toItem: uvSequence, attribute: .centerY, multiplier: 1, constant: 0))
        sequenceBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 21).isActive = true
        sequenceBtn.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0, constant: 21).isActive = true
        
        
        let storeType = UILabel()
        setPref(storeType,storeData["prefSn"].string!,storeData["prefData"].string!)
        storeType.fontSize = 13
        storeType.textColor = .systemBlue
        let storeNm = UILabel()
        storeNm.text = storeData["storeNm"].string
        storeNm.font = UIFont.boldSystemFont(ofSize: 19.0)
        //
        let url = URL(string: getImageURL(storeData["storeSn"].stringValue, storeData["storeImageUrlList"].arrayValue.first!.stringValue, tag: "store"))
        let imgStore = UIImageView()
        let data = try? Data(contentsOf: url!)
        if data != nil {
            imgStore.image = UIImage(data: data!)
        } else {
            imgStore.image = UIImage(named: "TempImage")
        }
        //        let imgLand = UIImageView(image: UIImage(named: "TempImage"))
        imgStore.clipsToBounds = true
        imgStore.layer.cornerRadius = 5
        imgStore.contentMode = .scaleAspectFill
        imgStore.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        imgStore.widthAnchor.constraint(equalToConstant: view.frame.width * 0.14).isActive = true
        let svInfo = UIStackView(arrangedSubviews: [storeType,storeNm])
        svInfo.translatesAutoresizingMaskIntoConstraints = false
        svInfo.axis = .vertical
        svInfo.distribution = .fillProportionally
        
        let uvInfo = UIView()
        uvInfo.addSubview(svInfo)
        uvInfo.translatesAutoresizingMaskIntoConstraints = false
        uvInfo.widthAnchor.constraint(equalToConstant: view.frame.width * 0.6 - 65).isActive = true
        uvInfo.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2 - 15).isActive = true
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerX, relatedBy: .equal, toItem: uvInfo, attribute: .centerX, multiplier: 1, constant: 0))
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerY, relatedBy: .equal, toItem: uvInfo, attribute: .centerY, multiplier: 1, constant: 0))
        svInfo.widthAnchor.constraint(equalTo: uvInfo.widthAnchor, multiplier: 1).isActive = true
        svInfo.heightAnchor.constraint(equalTo: uvInfo.heightAnchor, multiplier: 1).isActive = true
        
        let pathBtn = UIButton(type: .custom)
        pathBtn.setImage(UIImage(named: "GoToSeePath"), for: .normal)
        pathBtn.contentHorizontalAlignment = .center
        pathBtn.translatesAutoresizingMaskIntoConstraints = false
        pathBtn.layer.cornerRadius = 5
        
        let svMain = UIStackView(arrangedSubviews: [imgStore,uvInfo,pathBtn])
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.axis = .horizontal
        svMain.distribution = .fillProportionally
        svMain.spacing = 10
        svMain.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9 - 65).isActive = true
        svMain.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2 - 15).isActive = true
        
        let uvMain = UIView()
        uvMain.addSubview(svMain)
        uvMain.backgroundColor = .clear
        uvMain.translatesAutoresizingMaskIntoConstraints = false
        uvMain.layer.borderWidth = 1
        uvMain.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        uvMain.layer.cornerRadius = 5
        uvMain.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9 - 50).isActive = true
        uvMain.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2).isActive = true
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: uvMain, attribute: .centerX, multiplier: 1, constant: 0))
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: uvMain, attribute: .centerY, multiplier: 1, constant: 0))
        svMain.heightAnchor.constraint(equalTo: uvMain.heightAnchor, multiplier: 1, constant: -15).isActive = true
        svMain.widthAnchor.constraint(equalTo: uvMain.widthAnchor, multiplier: 1, constant:  -15).isActive = true
        
        let svItem = UIStackView(arrangedSubviews: [uvSequence,uvMain])
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .horizontal
        svItem.distribution = .fill
        
        uvItem.addSubview(svItem)
        uvItem.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        uvItem.heightAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 0.2).isActive = true
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        svItem.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1, constant:  0).isActive = true
        svItem.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1, constant:  0).isActive = true
        
        uvItem.addConstraint(NSLayoutConstraint(item: uvBack, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: uvBack, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        uvBack.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1, constant:  0).isActive = true
        uvBack.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1, constant:  0).isActive = true
        
        
        svCourse.addArrangedSubview(uvItem)
        
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

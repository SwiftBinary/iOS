//
//  LocationReviewViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/05/28.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MaterialDesignWidgets
import Material
import Alamofire
import SwiftyJSON

class LocationReviewViewController: UIViewController,UIGestureRecognizerDelegate,IndicatorInfoProvider {
    var itemInfo: IndicatorInfo = "View"
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let strHashTag = ["건대", "홍대", "강남", "이색", "고궁", "tv방영", "가성비", "고급진", "국밥", "방탈출", "야식", "비오는날", "100일데이트코스", "커플100%되는곳", "킬링타임코스", "호불호없는"]

    var scvList = UIScrollView()
    var svPostList = UIStackView()
    var btnScrollUp = UIButton(type: .custom)
    
    var responseJSON:JSON = []
    let userData = getUserData()
    var segueTitle: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
//        setPostUI()
//        setScrollUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        svPostList.removeSubviews()
        setScrollUI()
        requestPost()
    }
    
    func setSampleSegments(_ segmentedControl: MaterialSegmentedControl, _ cornerRadius: CGFloat) {
        let strList = ["게시글","생생 리뷰"]
        for str in strList {
            // Button background needs to be clear, it will be set to clear in segmented control anyway.
            let button = MaterialButton(text: str, textColor: .white, bgColor: #colorLiteral(red: 1, green: 0.3921568627, blue: 0.568627451, alpha: 1), cornerRadius: cornerRadius)
            button.titleLabel?.fontSize = 13
            button.rippleLayerColor = .white
            button.rippleLayerAlpha = 0.15
            segmentedControl.segments.append(button)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    func requestPost(){
        let url = OperationIP + "/review/selectStoreReviewInfoList.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        let parameter = JSON([
            "storeSn": locationData["storeSn"].string!,
            "filterInfo": "all",
            "sortInfo": "registerDt",
            "offset": locationData["offset"].intValue,
            "limit": 20
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        print(convertedParameterString)
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                self.responseJSON = JSON(response.value!)
                let responseStr : String = self.responseJSON.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
                print("result : \n " + responseStr)
                if responseStr != "" {
                    self.setPostUI()
                } else {
                    
                }
            }
        }
    }
    
    func setPostUI(){
        setPostList()
        
        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        panGestureRecongnizer.delegate = self
        scvList.addGestureRecognizer(panGestureRecongnizer)
    }
    
    @objc func panAction(_ sender : UIPanGestureRecognizer){
        btnScrollUp.isHidden = (scvList.contentOffset.y <= 0)
    }
    
    func setPostList(){
        
        let topLbl = UILabel()
        topLbl.text = " "
        topLbl.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        topLbl.backgroundColor = .clear
        svPostList.addArrangedSubview(topLbl)
        
        svPostList.addArrangedSubview(makeSNSView())
        svPostList.addArrangedSubview(makeWriteBtn())
        
        for data in responseJSON.arrayValue {
            let uvPost = makeTempUv(data)
            svPostList.addArrangedSubview(uvPost)
        }
        svPostList.translatesAutoresizingMaskIntoConstraints = false
        let endLbl = UILabel()
        endLbl.text = " "
        endLbl.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        endLbl.backgroundColor = .white
        svPostList.addArrangedSubview(endLbl)
    }
    
    func makeSNSView() -> UIView{
        let viewPost = UIView()
        viewPost.backgroundColor = .white
        viewPost.layer.cornerRadius = 15
        viewPost.layer.shadowColor = UIColor.lightGray.cgColor
        viewPost.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewPost.layer.shadowRadius = 2.0
        viewPost.layer.shadowOpacity = 0.9
        
        let lblSNS = UILabel()
        lblSNS.text = "SNS 후기"
        lblSNS.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        let btnList = [Button(image: UIImage(named: "InstaBtn")),
                       Button(image: UIImage(named: "FacebookBtn")),
                       Button(image: UIImage(named: "NaverBtn")),
                       Button(image: UIImage(named: "GoogleBtn")),
                       Button(image: UIImage(named: "DaumBtn"))]
        for btn in btnList {
            btn.pulseOpacity = 0
            btn.layer.shadowColor = UIColor.lightGray.cgColor
            btn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            btn.layer.shadowRadius = 1.0
            btn.layer.shadowOpacity = 0.8
        }
        
        let svSNSIcon = UIStackView(arrangedSubviews: btnList)
        svSNSIcon.spacing = 5
        svSNSIcon.axis = .horizontal
        svSNSIcon.distribution = .fillEqually
//        svSNSIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let svSNS = UIStackView(arrangedSubviews: [lblSNS,svSNSIcon])
        svSNS.spacing = 5
        svSNS.axis = .vertical
        svSNS.distribution = .fill
        svSNS.translatesAutoresizingMaskIntoConstraints = false
        
        viewPost.addSubview(svSNS)
        viewPost.addConstraint(NSLayoutConstraint(item: svSNS, attribute: .centerX, relatedBy: .equal, toItem: viewPost, attribute: .centerX, multiplier: 1, constant: 0))
        viewPost.addConstraint(NSLayoutConstraint(item: svSNS, attribute: .centerY, relatedBy: .equal, toItem: viewPost, attribute: .centerY, multiplier: 1, constant: 0))
        svSNS.widthAnchor.constraint(equalTo: viewPost.widthAnchor, multiplier: 0.9).isActive = true
        svSNS.heightAnchor.constraint(equalTo: viewPost.heightAnchor, multiplier: 2/3).isActive = true
        
        return viewPost
    }
    
    func makeWriteBtn() -> UIView {
        let uvWrite = UIView()
        uvWrite.backgroundColor = .clear
        
        let btnWriteReview = UIButton(type: .custom)
        btnWriteReview.translatesAutoresizingMaskIntoConstraints = false
        btnWriteReview.setTitle("리뷰 작성하기")
        btnWriteReview.setTitleColor(#colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1), for: .normal)
        btnWriteReview.setImage(UIImage(named: "BtnWriteReviewMini"), for: .normal)
        btnWriteReview.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        btnWriteReview.imageEdgeInsets.left = -5
        
        uvWrite.addSubview(btnWriteReview)
        uvWrite.addConstraint(NSLayoutConstraint(item: btnWriteReview, attribute: .centerY, relatedBy: .equal, toItem: uvWrite, attribute: .centerY, multiplier: 1, constant: 0))
        btnWriteReview.heightAnchor.constraint(equalTo: uvWrite.heightAnchor, multiplier: 1).isActive = true
        btnWriteReview.trailingAnchor.constraint(equalTo: uvWrite.trailingAnchor, constant: -20).isActive = true
        btnWriteReview.accessibilityIdentifier = locationData["storeSn"].string
        btnWriteReview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoWriteReview(_:))))
        
        return uvWrite
    }
    
    func makeTempUv(_ postData: JSON) -> UIView {
        let viewPost = UIView()
        viewPost.backgroundColor = .white
        viewPost.layer.cornerRadius = 15
        viewPost.layer.shadowColor = UIColor.lightGray.cgColor
        viewPost.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewPost.layer.shadowRadius = 2.0
        viewPost.layer.shadowOpacity = 0.9
        
        let imgProfile = UIImageView(image: UIImage(named: "tempProfile"))
        let iconSize:CGFloat = 30
        imgProfile.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        imgProfile.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        
        let lblNickName = UILabel()
        lblNickName.textColor = .darkText
        lblNickName.text = postData["userDTO"]["userName"].string
        lblNickName.fontSize = 15
        
        let imgViewCount = UIImageView(image: UIImage(named: "viewIcon"))
          imgViewCount.widthAnchor.constraint(equalTo: imgViewCount.heightAnchor, multiplier: 1).isActive = true
          let lblPostInfo = UILabel()
          let strView:String = String(postData["viewCount"].intValue)
          let strDate:String = String(postData["registerDt"].string!.split(separator: " ")[0])
          if postData["viewCount"].intValue >= 999 {
              lblPostInfo.text = "999+ " + strDate
          }
          else {
              lblPostInfo.text = strView + " " + strDate
          }
        lblPostInfo.fontSize = 11
        lblPostInfo.textColor = .lightGray
        
        let svCountDate = UIStackView(arrangedSubviews: [imgViewCount,lblPostInfo])
        svCountDate.axis = .horizontal
        svCountDate.spacing = 5
        
        let svPostInfo = UIStackView(arrangedSubviews: [lblNickName,svCountDate])
        svPostInfo.axis = .vertical
        svPostInfo.spacing = 5
        
        let svStar = UIStackView()
        let score : Int = postData["reviewScore"].intValue
        let cgSize:CGFloat = 25
        for i in 1...5 {
            let imgStar = UIImageView()
            if i <= score {
                imgStar.image = UIImage(named: "GPAIcon")
            }
            else {
                imgStar.image = UIImage(named: "GPAIconOff")
            }
            imgStar.contentMode = .scaleAspectFill
            //            imgStar.heightAnchor.constraint(equalToConstant: cgSize).isActive = true
            imgStar.widthAnchor.constraint(equalToConstant: cgSize).isActive = true
            svStar.addArrangedSubview(imgStar)
        }
        svStar.spacing = 2
        svStar.alignment = .center
        svStar.distribution = .fillEqually

        let svTopPost = UIStackView(arrangedSubviews: [imgProfile,svPostInfo,svStar])
        svTopPost.axis = .horizontal
        svTopPost.spacing = 5
        
        let lblTitle = UILabel()
        lblTitle.textColor = .darkText
        lblTitle.text = postData["title"].string!
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        let lblContent = UILabel()
        lblContent.isHidden = postData["content"].string == nil
        lblContent.text = postData["content"].string
        lblContent.textColor = .lightGray
        lblContent.fontSize = 15
        lblContent.numberOfLines = 4 //countLabelLines(label: lblContent)
        lblContent.lineBreakMode = .byCharWrapping
        
        let scvTag = UIScrollView()
        scvTag.translatesAutoresizingMaskIntoConstraints = false
        let svTag = UIStackView()
        
        let listHashTag = postData["hashTag"].string?.split(separator: " ")
         if listHashTag == nil {
             scvTag.isHidden = true
         } else {
             for hashTag in listHashTag! {
                 let btn = UIButton(type: .system)
                 btn.setTitle(setHashTagString(String(hashTag)), for: .normal)
                 btn.layer.cornerRadius = 15
                 btn.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
                 btn.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
                 svTag.addArrangedSubview(btn)
             }
         }
        
        svTag.translatesAutoresizingMaskIntoConstraints = false
        svTag.spacing = 5
        scvTag.addSubview(svTag)
        scvTag.addConstraint(NSLayoutConstraint(item: svTag, attribute: .centerY, relatedBy: .equal, toItem: scvTag, attribute: .centerY, multiplier: 1, constant: 0))
        scvTag.showsHorizontalScrollIndicator = false
        svTag.topAnchor.constraint(equalTo: scvTag.topAnchor, constant: 0).isActive = true
        svTag.bottomAnchor.constraint(equalTo: scvTag.bottomAnchor, constant: 0).isActive = true
        svTag.leadingAnchor.constraint(equalTo: scvTag.leadingAnchor, constant: 0).isActive = true
        svTag.trailingAnchor.constraint(equalTo: scvTag.trailingAnchor, constant: 0).isActive = true
        
        let scvImg = UIScrollView()
        scvImg.translatesAutoresizingMaskIntoConstraints = false
        let svImg = UIStackView(arrangedSubviews: [UIImageView(image: UIImage(named: "TempImage")),UIImageView(image: UIImage(named: "TempImage")),UIImageView(image: UIImage(named: "TempImage")),UIImageView(image: UIImage(named: "TempImage")),UIImageView(image: UIImage(named: "TempImage"))])
        
        svImg.translatesAutoresizingMaskIntoConstraints = false
        svImg.spacing = 5
        scvImg.addSubview(svImg)
        for img in svImg.arrangedSubviews {
            (img as! UIImageView).contentMode = .scaleAspectFill
            img.translatesAutoresizingMaskIntoConstraints = false
            img.widthAnchor.constraint(equalToConstant: 100).isActive = true
            img.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        scvImg.addConstraint(NSLayoutConstraint(item: svImg, attribute: .centerY, relatedBy: .equal, toItem: scvImg, attribute: .centerY, multiplier: 1, constant: 0))
        svImg.heightAnchor.constraint(equalTo: scvImg.heightAnchor, multiplier: 1).isActive = true
        svImg.topAnchor.constraint(equalTo: scvImg.topAnchor, constant: 0).isActive = true
        svImg.bottomAnchor.constraint(equalTo: scvImg.bottomAnchor, constant: 0).isActive = true
        svImg.leadingAnchor.constraint(equalTo: scvImg.leadingAnchor, constant: 0).isActive = true
        svImg.trailingAnchor.constraint(equalTo: scvImg.trailingAnchor, constant: 0).isActive = true
        
        let svContent = UIStackView(arrangedSubviews: [svTopPost,lblTitle,lblContent,scvTag,scvImg])
        svContent.axis = .vertical
        svContent.spacing = 10
        svContent.distribution = .fill
        let uvContent = UIView()
        svContent.translatesAutoresizingMaskIntoConstraints = false
        uvContent.addSubview(svContent)
        uvContent.addConstraint(NSLayoutConstraint(item: svContent, attribute: .centerX, relatedBy: .equal, toItem: uvContent, attribute: .centerX, multiplier: 1, constant: 0))
        uvContent.addConstraint(NSLayoutConstraint(item: svContent, attribute: .centerY, relatedBy: .equal, toItem: uvContent, attribute: .centerY, multiplier: 1, constant: 0))
        svContent.widthAnchor.constraint(equalTo: uvContent.widthAnchor, multiplier: 0.9).isActive = true
        svContent.heightAnchor.constraint(equalTo: uvContent.heightAnchor, multiplier: 1).isActive = true
        svContent.topAnchor.constraint(equalTo: uvContent.topAnchor, constant: 0).isActive = true
        svContent.bottomAnchor.constraint(equalTo: uvContent.bottomAnchor, constant: 0).isActive = true
        
        let uvLineTop = UIView()
        uvLineTop.backgroundColor = .none
        uvLineTop.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        let uvLine = UIView()
        uvLine.backgroundColor = .lightGray
        uvLine.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
        
        let uvLineBottom = UIView()
        uvLineBottom.backgroundColor = .none
        uvLineBottom.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        
        //            let btnLike = FlatButton(title: "String(postData["favorCount"].int!)")
        let btnLike = FlatButton(title: String(postData["favorCount"].int!))
        btnLike.setImage(UIImage(named: "LikeOffBtn"), for: .normal)
        btnLike.layer.cornerRadius = 5
        btnLike.titleLabel?.fontSize = 12
        //        btnLike.contentEdgeInsets.left = btnMargin
        //        btnLike.contentEdgeInsets.right = btnMargin
        btnLike.titleColor = .lightGray
        let btnComment = FlatButton(title: String(postData["replyCount"].int!))
        btnComment.isEnabled = false
        btnComment.setImage(UIImage(named: "CommentIcon"), for: .normal)
        btnComment.titleColor = .lightGray
        btnComment.titleLabel?.fontSize = 12
        //        btnComment.contentEdgeInsets.left = btnMargin
        //        btnComment.contentEdgeInsets.right = btnMargin
        let lblTemp = UILabel()
        lblTemp.text = "                          "
        lblTemp.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
        let btnMenu = IconButton()
        btnMenu.image = Icon.cm.moreHorizontal
        btnMenu.tintColor = .darkGray
        let svFunc = UIStackView(arrangedSubviews: [btnLike,btnComment,lblTemp,btnMenu])
        svFunc.axis = .horizontal
        svFunc.distribution = .fillProportionally
        svFunc.spacing = 5
        let uvFunc = UIView()
        svFunc.translatesAutoresizingMaskIntoConstraints = false
        uvFunc.addSubview(svFunc)
        uvFunc.addConstraint(NSLayoutConstraint(item: svFunc, attribute: .centerX, relatedBy: .equal, toItem: uvFunc, attribute: .centerX, multiplier: 1, constant: 0))
        uvFunc.addConstraint(NSLayoutConstraint(item: svFunc, attribute: .centerY, relatedBy: .equal, toItem: uvFunc, attribute: .centerY, multiplier: 1, constant: 0))
        svFunc.widthAnchor.constraint(equalTo: uvFunc.widthAnchor, multiplier: 0.9).isActive = true
        svFunc.heightAnchor.constraint(equalTo: uvFunc.heightAnchor, multiplier: 1).isActive = true
        
        
        let svMain = UIStackView(arrangedSubviews: [uvLineTop,uvContent,uvLine,uvFunc,uvLineBottom])
        svMain.axis = .vertical
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.spacing = 5
        viewPost.addSubview(svMain)
        viewPost.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: viewPost, attribute: .centerX, multiplier: 1, constant: 0))
        viewPost.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: viewPost, attribute: .centerY, multiplier: 1, constant: 0))
        svMain.widthAnchor.constraint(equalTo: viewPost.widthAnchor, multiplier: 1).isActive = true
        svMain.heightAnchor.constraint(equalTo: viewPost.heightAnchor, multiplier: 1).isActive = true
        
        viewPost.accessibilityIdentifier = postData["boardSn"].string
        viewPost.accessibilityValue = String(postData["category"].intValue)
        viewPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoPost(_:))))
        
        return viewPost
    }
    
    @objc func gotoPost(_ sender : UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        guard let rvc = storyboard.instantiateViewController(withIdentifier: "showPostView") as? ShowPostViewController else {
            //아니면 종료
            return
        }
        rvc.boardSn = sender.view!.accessibilityIdentifier!
        rvc.category = sender.view!.accessibilityValue!
        rvc.isLocaitonLink = true
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    @objc func gotoWriteReview(_ sender : UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let rvc = storyboard.instantiateViewController(withIdentifier: "writeReviewView") as? WriteReviewViewController else {
            //아니면 종료
            return
        }
        rvc.storeSn = sender.view!.accessibilityIdentifier!
        rvc.responseJSON = self.responseJSON
        rvc.isUpdatePost = false
        self.navigationController?.pushViewController(rvc, animated: true)

    }
    
    func setScrollUI(){
        scvList.translatesAutoresizingMaskIntoConstraints = false
        svPostList.translatesAutoresizingMaskIntoConstraints = false
        svPostList.distribution = .fill
        svPostList.axis = .vertical
        svPostList.spacing = 15
        
        view.addSubview(scvList)
        view.addConstraint(NSLayoutConstraint(item: scvList, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.widthAnchor.constraint(equalTo: scvList.widthAnchor, multiplier: 1).isActive = true
        view.topAnchor.constraint(equalTo: scvList.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: scvList.bottomAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: scvList.trailingAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: scvList.leadingAnchor, constant: 0).isActive = true
        
        scvList.addSubview(svPostList)
        scvList.addConstraint(NSLayoutConstraint(item: svPostList, attribute: .centerX, relatedBy: .equal, toItem: scvList, attribute: .centerX, multiplier: 1, constant: 0))
        svPostList.widthAnchor.constraint(equalTo: scvList.widthAnchor, multiplier: 1).isActive = true
        svPostList.topAnchor.constraint(equalTo: scvList.topAnchor, constant: 0).isActive = true
        svPostList.bottomAnchor.constraint(equalTo: scvList.bottomAnchor, constant: 0).isActive = true
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

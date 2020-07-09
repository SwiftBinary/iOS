//
//  PostListViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import ImageSlideshow
import Material

class PostListViewController: UIViewController,UIGestureRecognizerDelegate,UISearchBarDelegate {
    let darkGray = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    let btnhighlightedColor = #colorLiteral(red: 1, green: 0.737254902, blue: 0.9294117647, alpha: 1)
    var segueTitle: Int = 0
    var boardSn: String = ""
    let arrayTitle = ["공지사항","코스를 공유해요","인기 게시판","자유 게시판","썸타는 게시판","조언을 구해요","실시간 장소리뷰"]
    let arrayHiddenCreate = [0,2,6]
    
    let btnMargin:CGFloat = -10
    var responseJSON:JSON = []
    var postJSON = JSON()
    var isUpdate = false
    
    let userData = getUserData()
    
    @IBOutlet var btnScrollUp: UIButton!
    @IBOutlet var btnCreatePost: UIButton!
    
    @IBOutlet var issBanner: ImageSlideshow!
    let localSource = [BundleImageSource(imageString: "testBanner0"), BundleImageSource(imageString: "testBanner1"), BundleImageSource(imageString: "testBanner2"), BundleImageSource(imageString: "testBanner3")]
    @IBOutlet var lblBannerIndex: UILabel!
    
    @IBOutlet var scrollPostList: UIScrollView!
    @IBOutlet var svPostList: UIStackView!
    @IBOutlet var indicLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCatagoryInfo()
        //        requestPost(false)
        setBanner()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillAppear(animated)
        svPostList.removeSubviews()
        if segueTitle == 6 {
            requestReview()
        }
        else {
            requestPost(false)
        }
    }
    
    func getCatagoryInfo(){
        indicLoading.center = view.center
        let navigationVCList = self.navigationController!.viewControllers
        segueTitle = (navigationVCList[0] as! BoardListViewController).segueTag
        self.navigationItem.title = arrayTitle[segueTitle]
    }
    
    func setUI() {
        if arrayHiddenCreate.contains(segueTitle) { // 실시간 장소리뷰, 공지사항
            btnCreatePost.isHidden = true
        }
        setData(responseJSON)
        
        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        panGestureRecongnizer.delegate = self
        scrollPostList.addGestureRecognizer(panGestureRecongnizer)
    }
    func setBanner(){
        issBanner.slideshowInterval = 5.0
        issBanner.contentScaleMode = UIViewContentMode.scaleAspectFill
        issBanner.pageIndicator = nil
        issBanner.activityIndicator = DefaultActivityIndicator()
        issBanner.delegate = self
        issBanner.setImageInputs(localSource)
        
        lblBannerIndex.text = setSideSpace("1/\(localSource.count)")
        lblBannerIndex.layer.cornerRadius = 5.0
        lblBannerIndex.layer.borderWidth = 1
        lblBannerIndex.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lblBannerIndex.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    func setSideSpace(_ str: String) -> String {
        let resultStr = "   " + str + "   "
        return resultStr
    }
    
    func setData(_ responseData: JSON){
        let arrayData = responseData.arrayValue
        for data in arrayData {
            let tempView = makePostUv(data)
            svPostList.addArrangedSubview(tempView)
        }
        svPostList.translatesAutoresizingMaskIntoConstraints = false
        
        //일단 비워놓을 UIView 나중에 뭐로 채울지 생각해볼것
        let uvTemp = UIView()
        uvTemp.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //        uvTemp.heightAnchor.constraint(equalTo: btnCreatePost.heightAnchor, multiplier: 1).isActive = true
        uvTemp.backgroundColor = .clear
        svPostList.addArrangedSubview(uvTemp)
        
        let uvBottom = UIView()
        uvBottom.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        uvBottom.backgroundColor = .clear
        svPostList.addArrangedSubview(uvBottom)
        
        indicLoading.stopAnimating()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    
    @objc func panAction(_ sender : UIPanGestureRecognizer){
        btnScrollUp.isHidden = (scrollPostList.contentOffset.y <= 0)
    }
    
    func makePostUv(_ postData: JSON) -> UIView {
        let viewPost = UIView()
        viewPost.backgroundColor = .white
        viewPost.layer.cornerRadius = 15
        viewPost.layer.shadowColor = UIColor.lightGray.cgColor
        viewPost.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewPost.layer.shadowRadius = 2.0
        viewPost.layer.shadowOpacity = 0.9
        
        let imgProfile = UIImageView(image: UIImage(named: "tempProfile"))
        let iconSize:CGFloat = 35
        imgProfile.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        imgProfile.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        
        let lblNickName = UILabel()
        lblNickName.textColor = .darkText
        lblNickName.text = postData["userDTO"]["userName"].string
        lblNickName.fontSize = 15
        //        btnMenu.widthAnchor.constraint(equalToConstant: 25).isActive = true
        //        btnMenu.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        let imgViewCount = UIImageView(image: UIImage(named: "viewIcon"))
        imgViewCount.widthAnchor.constraint(equalTo: imgViewCount.heightAnchor, multiplier: 1).isActive = true
        let lblPostInfo = UILabel()
        let strView:String = String(postData["viewCount"].intValue)
        let strDate:String = String(postData["registerDt"].string!.split(separator: " ")[0])
        lblPostInfo.text = strView + "  " + strDate
        lblPostInfo.fontSize = 11
        lblPostInfo.textColor = .lightGray
        
        let svCountDate = UIStackView(arrangedSubviews: [imgViewCount,lblPostInfo])
        svCountDate.axis = .horizontal
        svCountDate.spacing = 5
        
        let svPostInfo = UIStackView(arrangedSubviews: [lblNickName,svCountDate])
        svPostInfo.axis = .vertical
        svPostInfo.spacing = 5
        let svStar = UIStackView()
        let cgSize:CGFloat = 25
        if segueTitle == 6 {
            svStar.isHidden = false
            let score : Int = postData["reviewScore"].intValue
            for i in 1...5 {
                let imgStar = UIImageView()
                imgStar.contentMode = .scaleAspectFill
                imgStar.widthAnchor.constraint(equalToConstant: cgSize).isActive = true
                if i <= score {
                    imgStar.image = UIImage(named: "GPAIcon")
                }
                else {
                    imgStar.image = UIImage(named: "GPAIconOff")
                }
                svStar.addArrangedSubview(imgStar)
            }
        }
        else {
            svStar.isHidden = true
        }
        svStar.spacing = 2
        svStar.alignment = .center
        svStar.distribution = .fillEqually
        
        let svTopPost = UIStackView(arrangedSubviews: [imgProfile,svPostInfo,svStar])
        svTopPost.axis = .horizontal
        svTopPost.spacing = 5
        
        let btnLocationName = UIButton(type: .custom)
        if postData["category"] == 7 {
            btnLocationName.isHidden = false
            btnLocationName.setTitle(postData["storeDTO"]["storeNm"].string, for: .normal)
            btnLocationName.fontSize = 15
            btnLocationName.setTitleColor(#colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1), for: .normal)
            btnLocationName.setTitleColor(btnhighlightedColor, for: .highlighted)
            btnLocationName.accessibilityIdentifier = postData["storeDTO"]["storeSn"].string
            btnLocationName.contentHorizontalAlignment = .left
            btnLocationName.addTarget(self, action: #selector(gotoLocationInfo(_:)), for: .touchUpInside)
        }
        let lbltemp = UILabel()
        lbltemp.text = "                                      "
        let svLocationLink = UIStackView(arrangedSubviews: [btnLocationName,lbltemp])
        svLocationLink.axis = .horizontal
        svLocationLink.distribution = .fillProportionally
        
        let lblTitle = UILabel()
        lblTitle.textColor = .darkText
        lblTitle.text = postData["title"].string
        lblTitle.font = UIFont.boldSystemFont(ofSize: 17)
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
            svTag.isHidden = true
        } else {
            for hashTag in listHashTag! {
                let btn = UIButton(type: .system)
                btn.setTitle(setHashTagString(String(hashTag)), for: .normal)
                btn.layer.cornerRadius = 15
                btn.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
                btn.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
                btn.addTarget(self, action: #selector(searchByTag(_:)), for: .touchUpInside)
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
        let svImg = UIStackView(arrangedSubviews: [UIImageView(image: UIImage(named: "tempProfile")),UIImageView(image: UIImage(named: "tempProfile")),UIImageView(image: UIImage(named: "tempProfile")),UIImageView(image: UIImage(named: "tempProfile")),UIImageView(image: UIImage(named: "tempProfile"))])
        svImg.translatesAutoresizingMaskIntoConstraints = false
        svImg.spacing = 5
        scvImg.addSubview(svImg)
        for img in svImg.arrangedSubviews {
            img.widthAnchor.constraint(equalToConstant: 100).isActive = true
            img.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        scvImg.addConstraint(NSLayoutConstraint(item: svImg, attribute: .centerY, relatedBy: .equal, toItem: scvImg, attribute: .centerY, multiplier: 1, constant: 0))
        svImg.heightAnchor.constraint(equalTo: scvImg.heightAnchor, multiplier: 1).isActive = true
        svImg.topAnchor.constraint(equalTo: scvImg.topAnchor, constant: 0).isActive = true
        svImg.bottomAnchor.constraint(equalTo: scvImg.bottomAnchor, constant: 0).isActive = true
        svImg.leadingAnchor.constraint(equalTo: scvImg.leadingAnchor, constant: 0).isActive = true
        svImg.trailingAnchor.constraint(equalTo: scvImg.trailingAnchor, constant: 0).isActive = true
        
        
        let svContent = UIStackView()
        svContent.addArrangedSubview(svTopPost)
        if postData["category"] == 7 {
            svContent.addArrangedSubview(svLocationLink)
        }
        svContent.addArrangedSubview(lblTitle)
        svContent.addArrangedSubview(lblContent)
        svContent.addArrangedSubview(scvTag)
        svContent.addArrangedSubview(scvImg)
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
        uvLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let uvLineBottom = UIView()
        uvLineBottom.backgroundColor = .none
        uvLineBottom.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        
        let btnLike = FlatButton(title: String(postData["favorCount"].int!))
        let checkLikePost = (postData["selectedFavor"].int != 0)
        btnLike.setImage(UIImage(named: checkLikePost ? "LikeOnBtn" : "LikeOffBtn"), for: .normal)
        btnLike.titleColor = checkLikePost ? themeColor : .lightGray
        btnLike.layer.cornerRadius = 5
        btnLike.titleLabel?.fontSize = 12
        //        btnLike.contentEdgeInsets.left = btnMargin
        //        btnLike.contentEdgeInsets.right = btnMargin
        btnLike.accessibilityValue = String(postData["selectedFavor"].intValue)
        btnLike.accessibilityIdentifier = postData["boardSn"].string
        
        btnLike.addTarget(self, action: #selector(likePost(_:)), for: .touchUpInside)
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
        btnMenu.addTarget(self, action: #selector(menuPost(_:)), for: .touchUpInside)
        btnMenu.accessibilityIdentifier = postData["boardSn"].string
        btnMenu.accessibilityValue = postData["userDTO"]["userSn"].string
        btnMenu.imageView?.contentMode = .scaleAspectFit
        
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
    @objc func searchByTag(_ sender: UIButton){
        let strTag = sender.titleLabel!.text!.trimmingCharacters(in: ["#"," "])
        selectedTag = strTag
        self.tabBarController?.selectedViewController = self.tabBarController?.children[1]        
    }
    
    @objc func likePost(_ sender: FlatButton) {
        boardSn = sender.accessibilityIdentifier!
        (sender.accessibilityValue == "0") ? likePostOn(boardSn,sender) : likePostOff(boardSn,sender)
    }
    func likePostOn(_ boardSn:String,_ btn:FlatButton){
        let url = OperationIP + "/board/insertBoardFavorInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                print(response.value!)
                btn.setImage(UIImage(named: "LikeOnBtn"), for: .normal)
                btn.titleColor = self.themeColor
                btn.title = String(Int(btn.title!)! + 1)
                btn.accessibilityValue = "1"
            }
        }
    }
    func likePostOff(_ boardSn:String,_ btn:FlatButton){
        let url = OperationIP + "/board/deleteBoardFavorInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                print(response.value!)
                btn.setImage(UIImage(named: "LikeOffBtn"), for: .normal)
                btn.titleColor = .lightGray
                btn.title = String(Int(btn.title!)! - 1)
                btn.accessibilityValue = "0"
            }
        }
    }
    
    @objc func menuPost(_ sender: IconButton) {
        let alertController = UIAlertController(title: "글 메뉴", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let MyPostEditAction = UIAlertAction(title: "수정", style: .default, handler: { _ in
            self.updatePost(sender.accessibilityIdentifier!)
        })
        let MyPostDeleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.deletePostAlert(sender.accessibilityIdentifier!)
        })
        
        let reportAction = UIAlertAction(title: "신고", style: .default, handler: { _ in
            self.reportPost(sender.accessibilityIdentifier!)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        if getString(userData["userSn"]) == sender.accessibilityValue! {
            alertController.addAction(MyPostEditAction)
            alertController.addAction(MyPostDeleteAction)
        } else {
            alertController.addAction(reportAction)
        }
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    func updatePost(_ boardSn: String){
        let url = OperationIP + "/board/selectBoardInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        //        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.postJSON = JSON(response.value!)
                self.isUpdate = true
                let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "writePostView")
                self.navigationController?.pushViewController(goToVC!, animated: true)
            }
        }
    }
    func deletePostAlert(_ boardSn: String){
        let alertController = UIAlertController(title: "글을 삭제하시겠습니까?", message: "삭제된 게시글은 되돌릴 수 없습니다.", preferredStyle: UIAlertController.Style.actionSheet)
        
        let MyPostDeleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.deletePost(boardSn)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(MyPostDeleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func deletePost(_ boardSn: String){
        let url = OperationIP + "/board/deleteBoardInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")//.replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                print(response.value!)
                self.alertControllerDefault(title: "삭제 완료", message: "게시글이 삭제되었습니다.")
            }
        }
    }
    func reportPost(_ boardSn:String){
        let alertController = UIAlertController(title: "신고 사유 선택", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let reportAction001 = UIAlertAction(title: "게시판에 부적절한 게시글", style: .default, handler:  { _ in
            self.requestReportPost(boardSn,"001")
        })
        let reportAction002 = UIAlertAction(title: "음란성 게시글", style: .default, handler: { _ in
            self.requestReportPost(boardSn,"002")
        })
        let reportAction003 = UIAlertAction(title: "욕설", style: .default, handler: { _ in
            self.requestReportPost(boardSn,"003")
        })
        let reportAction004 = UIAlertAction(title: "도배", style: .default, handler: { _ in
            self.requestReportPost(boardSn,"004")
        })
        let reportAction005 = UIAlertAction(title: "광고/사기", style: .default, handler: { _ in
            self.requestReportPost(boardSn,"005")
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(reportAction001)
        alertController.addAction(reportAction002)
        alertController.addAction(reportAction003)
        alertController.addAction(reportAction004)
        alertController.addAction(reportAction005)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func requestReportPost(_ boardSn: String,_ reportReason:String){
        let url = OperationIP + "/board/insertBoardReportInfo.do"
        let parameter = JSON([
            "boardSn": boardSn,
            "reportReason": reportReason
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")//.replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                print(response.value!)
            }
        }
    }
    
    
    @objc func gotoPost(_ sender : UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        guard let rvc = storyboard.instantiateViewController(withIdentifier: "showPostView") as? ShowPostViewController else {
            //아니면 종료
            return
        }
        rvc.boardSn = sender.view!.accessibilityIdentifier!
        rvc.category = sender.view!.accessibilityValue!
        //        rvc.storeNm = sender.view!.accessibilityLabel!
        self.navigationController?.pushViewController(rvc, animated: true)
        //        print(sender.view!.accessibilityIdentifier!)
        //        boardSn = sender.view!.accessibilityIdentifier!
        //        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "showPostView")
        //        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    
    @IBAction func searchPost(_ sender: UIBarButtonItem) {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItems?.remove(at: 1)
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "ex) 동 검색: 화양동, 키워드 검색: 치킨.."
        searchBar.delegate = self
        
        let uvSearch = UIView()
        uvSearch.layer.cornerRadius = 15
        uvSearch.backgroundColor = .lightGray
        
        let imgSearch = UIImageView(image: Icon.cm.search)
        let tfSearch = UITextField()
        
        let svSearch = UIStackView(arrangedSubviews: [imgSearch,tfSearch])
        svSearch.axis = .horizontal
        svSearch.spacing = 5
        
        self.navigationItem.titleView = searchBar
    }
    
    @IBAction func upToTop(_ sender: Any) {
        scrollPostList.scrollToTop()
        btnScrollUp.isHidden = true
    }
    
    @IBAction func gotoCreatePost(_ sender: UIButton) {
        
    }
    
    // 수정 필요
    @IBAction func showFilter(_ sender: UIBarButtonItem) {
        self.navigationItem.hidesBackButton = false
        //        self.navigationItem.rightBarButtonItems?.remove(at: 1)
        
        self.navigationItem.titleView?.isHidden = true
        //        let goToVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "postFilterView")
        //        self.present(goToVC, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func requestPost(_ isUpdate: Bool){
        let url = OperationIP + "/board/selectBoardListInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        let parameter = JSON([
            "category": String(segueTitle+1),
            "filterInfo": "all",
            "sortInfo": "registerDt",
            "offset": 0,
            "limit": 20
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.responseJSON = JSON(response.value!)
                print("##")
                print(self.responseJSON)
                print("##")
                if !isUpdate {
                    self.setUI()
                }
            }
        }
    }
    
    //######################
    //      리뷰
    //######################
    func requestReview(){
        let url = OperationIP + "/review/selectReviewListInfo.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        let parameter = JSON([
            "category": 7,
            "filterInfo": "all",
            "sortInfo": "registerDt",
            "offset": 0,
            "limit": 100
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.responseJSON = JSON(response.value!)
                print("##")
                print(self.responseJSON)
                print("##")
                self.setUI()
            }
        }
    }
    //######################
    //      장소상세 링크
    //######################
    @objc func gotoLocationInfo(_ sender: UIButton){
        let locationSn = sender.accessibilityIdentifier
        getLocationInfo(locationSn!)
    }
    func getLocationInfo(_ locationSn : String){
        print("\n\n\n\n\n\n\n\n\n\n //////////////get storeInfo !!////////////// \n\n\n\n\n\n\n\n\n\n")
        let url = OperationIP + "/store/selectStoreInfo.do"
        let parameter = JSON([
            "storeSn": locationSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                locationData = JSON(response.value!)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let goToVC = storyboard.instantiateViewController(withIdentifier: "locationInfoView") as? LocationViewController else {
                    //아니면 종료
                    return
                }
                self.navigationController?.pushViewController(goToVC, animated: true)
            }
        }
    }
}

extension PostListViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        lblBannerIndex.text = setSideSpace("\(page+1)/\(localSource.count)")
        //        print("current page:", page)
    }
}


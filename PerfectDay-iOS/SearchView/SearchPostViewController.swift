//
//  SearchPostViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/12.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
import MaterialDesignWidgets
import Material

// UIPickerViewDelegate, UIPickerViewDataSource,
class SearchPostViewController: UIViewController,UIGestureRecognizerDelegate, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let strHashTag = ["건대", "홍대", "강남", "이색", "고궁", "tv방영", "가성비", "고급진", "국밥", "방탈출", "야식", "비오는날", "100일데이트코스", "커플100%되는곳", "킬링타임코스", "호불호없는"]
    let btnMargin:CGFloat = -10
    var scrollPostList = UIScrollView()
    var svPostList = UIStackView()
    var btnScrollUp = UIButton(type: .custom)
    let lblCountPost = UILabel()
    let segmentControl = MaterialSegmentedControl()
    let userData = getUserData()
    var boardSn: String = ""
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    var searchData = JSON()
    var postJSON = JSON()
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        setFilterUI()
        //        setScroll(UIScrollView())
        setPostUI()
        setScrollUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        view.endEditing(true)
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
    
    func setFilterUI(){
        // UI 구조
        // 세로 스택뷰[ 가로 스택 뷰1{선택한 위치 라벨, 위치 설정 버튼} , 가로 스택 뷰2{결과 장소 수 라벨, 필터 버튼, 정렬조건 버튼} ]
        let svHorizontal = UIStackView()
        let svLabel = UIStackView()
        let lblCountPostGuide = UILabel()
        
        let lblCountPostEnd = UILabel()
        let btnFilter = UIButton(type: .custom)
        
        //Label Setting
        let intFontSize:CGFloat = 13
        lblCountPostGuide.fontSize = intFontSize
        lblCountPostGuide.textColor = .darkText
        lblCountPostGuide.text = "조건에 해당하는 게시물: "
        lblCountPostGuide.textAlignment = .right
        lblCountPost.fontSize = intFontSize
        lblCountPost.textColor = #colorLiteral(red: 0.9882352941, green: 0.368627451, blue: 0.5725490196, alpha: 1)
        lblCountPost.text = "000"
        lblCountPost.textAlignment = .center
        lblCountPostEnd.fontSize = intFontSize
        lblCountPostEnd.textColor = .darkText
        lblCountPostEnd.text = " 개"
        lblCountPostEnd.textAlignment = .left
        
        //segmentControl
        //        let segmentControl = MaterialSegmentedControl()
        segmentControl.selectorStyle = .fill
        segmentControl.foregroundColor = .white
        segmentControl.selectedForegroundColor = .white
        segmentControl.selectorColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.568627451, alpha: 1)
        segmentControl.backgroundColor = .lightGray
        setSampleSegments(segmentControl, intFontSize)
        segmentControl.setCornerBorder(cornerRadius: intFontSize)
        
        //Button Setting
        btnFilter.setTitle("", for: .normal)
        btnFilter.setImage(UIImage(named: "FilterBtn"), for: .normal)
        btnFilter.addTarget(self, action: #selector(filterPost), for: .touchUpInside)
        
        //Stack Setting
        svLabel.addArrangedSubview(lblCountPostGuide)
        svLabel.addArrangedSubview(lblCountPost)
        svLabel.addArrangedSubview(lblCountPostEnd)
        svHorizontal.addArrangedSubview(svLabel)
        svHorizontal.addArrangedSubview(segmentControl)
        svHorizontal.addArrangedSubview(btnFilter)
        
        btnFilter.widthAnchor.constraint(equalTo: svHorizontal.heightAnchor, multiplier: 1).isActive = true
        
        svHorizontal.translatesAutoresizingMaskIntoConstraints = false
        svHorizontal.distribution = .fill
        svHorizontal.spacing = 3
        view.addSubview(svHorizontal)
        view.addConstraint(NSLayoutConstraint(item: svHorizontal, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        svHorizontal.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        svHorizontal.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        // Add actions
    }
    
    @objc func filterPost(sender: UIButton){
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let rvc = storyboard.instantiateViewController(withIdentifier: "postFilterView") as? FilterPostViewController else {
            //아니면 종료
            return
        }
        
        let searchView = self.parent?.parent as! SearchViewController
        rvc.selectedPeriod = rvc.listFilterPeriod.firstIndex(of: searchView.periodValue)!
        rvc.selectedSorting = rvc.listFilterSorting.firstIndex(of: searchView.sortingValue)!
        self.present(rvc, animated: true, completion: nil)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    
    func setPostUI(){
        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        panGestureRecongnizer.delegate = self
        scrollPostList.addGestureRecognizer(panGestureRecongnizer)
    }
    
    @objc func panAction(_ sender : UIPanGestureRecognizer){
        btnScrollUp.isHidden = (scrollPostList.contentOffset.y <= 0)
    }
    
    func setPostList(){
        svPostList.removeSubviews()
        lblCountPost.text = String(searchData.arrayValue.count)
        for post in searchData.arrayValue {
            let postView = makeTempUv(post)
            svPostList.addArrangedSubview(postView)
        }
        svPostList.translatesAutoresizingMaskIntoConstraints = false
        let endLbl = UILabel()
        endLbl.text = " "
        endLbl.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        endLbl.backgroundColor = .white
        svPostList.addArrangedSubview(endLbl)
        let searchView = self.parent?.parent as! SearchViewController
        searchView.indicLoading.stopAnimating()
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
        
        let svTopPost = UIStackView(arrangedSubviews: [imgProfile,svPostInfo])
        svTopPost.axis = .horizontal
        svTopPost.spacing = 5
        
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
            debugPrint(response)
            if response.value != nil {
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
            debugPrint(response)
            if response.value != nil {
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
            self.reportPostOrComment()
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
    func reportPostOrComment(){
        let alertController = UIAlertController(title: "신고 사유 선택", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let reportAction0 = UIAlertAction(title: "게시판에 부적절한 게시글", style: .default, handler: nil)
        let reportAction1 = UIAlertAction(title: "음란성 게시글", style: .default, handler: nil)
        let reportAction2 = UIAlertAction(title: "욕설", style: .default, handler: nil)
        let reportAction3 = UIAlertAction(title: "도배", style: .default, handler: nil)
        let reportAction4 = UIAlertAction(title: "광고/사기", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(reportAction0)
        alertController.addAction(reportAction1)
        alertController.addAction(reportAction2)
        alertController.addAction(reportAction3)
        alertController.addAction(reportAction4)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func gotoPost(_ sender: UITapGestureRecognizer){
        
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        guard let rvc = storyboard.instantiateViewController(withIdentifier: "showPostView") as? ShowPostViewController else {
            //아니면 종료
            return
        }
        rvc.boardSn = sender.view!.accessibilityIdentifier!
        rvc.category = sender.view!.accessibilityValue!
        //        rvc.storeNm = sender.view!.accessibilityLabel!
        self.navigationController?.pushViewController(rvc, animated: true)
        //        let goToVC = UIStoryboard.init(name: "Board", bundle: Bundle.main).instantiateViewController(withIdentifier: "showPostView")
        //        self.present(goToVC, animated: true, completion: nil)
    }
    
    func setScrollUI(){
        scrollPostList.translatesAutoresizingMaskIntoConstraints = false
        svPostList.translatesAutoresizingMaskIntoConstraints = false
        svPostList.distribution = .fill
        svPostList.axis = .vertical
        svPostList.spacing = 15
        
        view.addSubview(scrollPostList)
        view.addConstraint(NSLayoutConstraint(item: scrollPostList, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.widthAnchor.constraint(equalTo: scrollPostList.widthAnchor, multiplier: 1).isActive = true
        scrollPostList.topAnchor.constraint(equalTo: view.subviews[0].bottomAnchor, constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: scrollPostList.bottomAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollPostList.trailingAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: scrollPostList.leadingAnchor, constant: 0).isActive = true
        
        scrollPostList.addSubview(svPostList)
        scrollPostList.addConstraint(NSLayoutConstraint(item: svPostList, attribute: .centerX, relatedBy: .equal, toItem: scrollPostList, attribute: .centerX, multiplier: 1, constant: 0))
        svPostList.widthAnchor.constraint(equalTo: scrollPostList.widthAnchor, multiplier: 1).isActive = true
        svPostList.topAnchor.constraint(equalTo: scrollPostList.topAnchor, constant: 0).isActive = true
        svPostList.bottomAnchor.constraint(equalTo: scrollPostList.bottomAnchor, constant: 0).isActive = true
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

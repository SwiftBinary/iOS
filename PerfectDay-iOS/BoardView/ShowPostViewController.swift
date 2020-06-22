//
//  ShowPostViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/24.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Material

class ShowPostViewController: UIViewController {
    
    let darkGray = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.368627451, blue: 0.5725490196, alpha: 1)
    let btnhighlightedColor = #colorLiteral(red: 1, green: 0.737254902, blue: 0.9294117647, alpha: 1)
    
    let btnLike = FlatButton()
    let btnComment = FlatButton()
    
    @IBOutlet var uvPost: UIView!
    @IBOutlet var uvComment: UIView!
    
    @IBOutlet var uvFunc: UIView!
    @IBOutlet var svHashTag: UIStackView!
    @IBOutlet var scvHashTag: UIScrollView!
    @IBOutlet var svimage: UIStackView!
    @IBOutlet var scvImage: UIScrollView!
    @IBOutlet var svScore: UIStackView!
    
    @IBOutlet var svComment: UIStackView!
    @IBOutlet var lblTemp: UILabel!
    
    var checkLikePost = false
    var isMyPost = false
    var isCommentUpdate = false
    
    let userData = getUserData()
    
    let commentProfileSize: CGFloat = 30
    let commentFontSize: CGFloat = 15
    let commentInfoFontSize: CGFloat = 10
    
    @IBOutlet var lblUserNickName: UILabel!
    @IBOutlet var btnLocationName: UIButton!
    @IBOutlet var lblPostInfo: UILabel!
    @IBOutlet var lblContentTitle: UILabel!
    @IBOutlet var lblContent: UILabel!
    
    @IBOutlet var tfComment: UITextField!
    @IBOutlet var btnSendComment: UIButton!
    
    var reponseJSON: JSON = []
    var boardSn = ""
    var replySn = ""
    var category:String = ""
    var isLocaitonLink = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setField(tfComment, "댓글을 입력해주세요.")
//        getBoardSn()
        //        requestPostFirst()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uvFunc.removeSubviews()
        svScore.removeSubviews()
        svHashTag.removeSubviews()
        if category == "7" {
            requestReviewFirst()
        }
        else {
            requestPostFirst()
        }
    }
    
    //###########################
    //          게시글
    //###########################
    func getBoardSn(){
        let navigationVCList = self.navigationController!.viewControllers
        boardSn = (navigationVCList[1] as! PostListViewController).boardSn
        print(self.boardSn)
    }
    func requestPostFirst(){
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
                self.reponseJSON = JSON(response.value!)
                print("##")
                print(self.reponseJSON)
                print("##")
                self.setUI()
            }
        }
    }
    func requestReviewFirst(){
        let url = OperationIP + "/review/selectReviewInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        //        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.reponseJSON = JSON(response.value!)
                print("##")
                print(self.reponseJSON)
                print("##")
                self.setUI()
            }
        }
    }
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        let navigationVCList = self.navigationController!.viewControllers
        let navigationTitle = navigationVCList[1].navigationItem.title
        self.navigationItem.title = navigationTitle
        let postData = reponseJSON
        
        lblUserNickName.text = postData["userDTO"]["userName"].string
        let strView:String = String(postData["viewCount"].intValue)
        let strDate:String = String(postData["registerDt"].string!.split(separator: " ")[0])
        lblPostInfo.text = strView + "  " + strDate
        
        if category == "7" {
            svScore.isHidden = false
            let score : Int = postData["reviewScore"].intValue
            for i in 1...5 {
                let imgStar = UIImageView()
                //                imgStar.contentMode = .scaleAspectFill
                if i <= score {
                    imgStar.image = UIImage(named: "GPAIcon")
                }
                else {
                    imgStar.image = UIImage(named: "GPAIcon-1")
                }
                svScore.addArrangedSubview(imgStar)
            }
        }
        else {
            svScore.isHidden = true
        }
        if category == "7" {
            btnLocationName.isHidden = false
            btnLocationName.setTitle(postData["storeDTO"]["storeNm"].string, for: .normal)
            btnLocationName.fontSize = 15
            btnLocationName.setTitleColor(#colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1), for: .normal)
            btnLocationName.setTitleColor(btnhighlightedColor, for: .highlighted)
            btnLocationName.accessibilityIdentifier = postData["storeDTO"]["storeSn"].string
            btnLocationName.contentHorizontalAlignment = .left
            btnLocationName.addTarget(self, action: #selector(gotoLocationInfo(_:)), for: .touchUpInside)
        }
        else {
            btnLocationName.isHidden = true
        }
        
        lblContentTitle.text = postData["title"].string
        lblContent.isHidden = (postData["content"].string == nil)
        lblContent.text = postData["content"].string
        lblContent.numberOfLines = countLabelLines(label: lblContent)
        lblContent.lineBreakMode = .byCharWrapping
        
        uvPost.backgroundColor = .white
        uvPost.clipsToBounds = true
        uvPost.layer.cornerRadius = 30.0
        uvPost.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        uvPost.translatesAutoresizingMaskIntoConstraints = false
        
        uvComment.backgroundColor = .white
        uvComment.clipsToBounds = true
        uvComment.layer.cornerRadius = 30.0
        uvComment.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        let listHashTag = postData["hashTag"].string?.split(separator: " ")
        if listHashTag == nil {
            scvHashTag.isHidden = true
        } else {
            for hashTag in listHashTag! {
                let btn = UIButton(type: .system)
                btn.setTitle(setHashTagString(String(hashTag)), for: .normal)
                btn.layer.cornerRadius = 15
                btn.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
                btn.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
                svHashTag.addArrangedSubview(btn)
            }
        }
        
        if postData["photoList"].arrayValue.isEmpty {
            scvImage.isHidden = true
        }
        
        btnLike.title = String(postData["favorCount"].int!)
        btnLike.setImage(UIImage(named: "LikeOffBtn"), for: .normal)
        btnLike.layer.cornerRadius = 5
        btnLike.titleLabel?.fontSize = 12
        btnLike.titleColor = .darkGray
        btnLike.addTarget(self, action: #selector(likePost(_:)), for: .touchUpInside)
        
        btnComment.title = String(postData["replyCount"].int!)
        btnComment.isUserInteractionEnabled = false
        btnComment.setImage(UIImage(named: "CommentIcon"), for: .normal)
        btnComment.titleLabel?.fontSize = 12
        btnComment.titleColor = .darkGray
        
        let lblTemp = UILabel()
        lblTemp.text = "                          "
        lblTemp.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
        let btnMenu = IconButton()
        btnMenu.image = Icon.cm.moreHorizontal
        btnMenu.tintColor = .darkGray
        btnMenu.addTarget(self, action: #selector(menuPost(_:)), for: .touchUpInside)
        let svFunc = UIStackView(arrangedSubviews: [btnLike,btnComment,lblTemp,btnMenu])
        svFunc.axis = .horizontal
        svFunc.distribution = .fillProportionally
        svFunc.spacing = 5
        
        svFunc.translatesAutoresizingMaskIntoConstraints = false
        uvFunc.addSubview(svFunc)
        uvFunc.addConstraint(NSLayoutConstraint(item: svFunc, attribute: .centerX, relatedBy: .equal, toItem: uvFunc, attribute: .centerX, multiplier: 1, constant: 0))
        uvFunc.addConstraint(NSLayoutConstraint(item: svFunc, attribute: .centerY, relatedBy: .equal, toItem: uvFunc, attribute: .centerY, multiplier: 1, constant: 0))
        svFunc.widthAnchor.constraint(equalTo: uvFunc.widthAnchor, multiplier: 0.9).isActive = true
        svFunc.heightAnchor.constraint(equalTo: uvFunc.heightAnchor, multiplier: 1).isActive = true
        
        updatePostUI()
        setComment(postData["replyList"])
    }
    
    @objc func likePost(_ sender: FlatButton) {
        let postData = reponseJSON
        checkLikePost = (postData["selectedFavor"] == 0)
        checkLikePost ? likePostOn() : likePostOff()
    }
    func likePostOn(){
        let url = OperationIP + "/board/insertBoardFavorInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        //        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.requestPost(true)
            }
        }
    }
    func likePostOff(){
        let url = OperationIP + "/board/deleteBoardFavorInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                //                print(response.value!)
                self.requestPost(true)
            }
        }
    }
    @objc func menuPost(_ sender: IconButton) {
        let alertController = UIAlertController(title: "글 메뉴", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let MyPostEditAction = UIAlertAction(title: "수정", style: .default, handler: { _ in
            self.updatePost()
        })
        let MyPostDeleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.deletePostAlert()
        })
        
        let reportAction = UIAlertAction(title: "신고", style: .default, handler: { _ in
            self.reportPostOrComment()
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        if getString(userData["userSn"]) == reponseJSON["userSn"].stringValue {
            alertController.addAction(MyPostEditAction)
            alertController.addAction(MyPostDeleteAction)
        } else {
            alertController.addAction(reportAction)
        }
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    func updatePost(){
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "writePostView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    func deletePostAlert(){
        let alertController = UIAlertController(title: "글을 삭제하시겠습니까?", message: "삭제된 게시글은 되돌릴 수 없습니다.", preferredStyle: UIAlertController.Style.actionSheet)
        
        let MyPostDeleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.deletePost()
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(MyPostDeleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func deletePost(){
        let url = OperationIP + "/board/deleteBoardInfo.do"
        let parameter = JSON([
            "boardSn": reponseJSON["boardSn"].stringValue
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")//.replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                print(response.value!)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //###########################
    //           댓글
    //###########################
    func setComment(_ comments: JSON) {
        let listComment = comments.arrayValue.reversed()
        for comment in listComment{
            let isEnable = comment["isEnable"].stringValue
            let commentItem = UIView()
            if isEnable == "001" {
                makeCommentView(comment,commentItem)
            } else {
                makeDeleteCommentView(comment,commentItem)
            }
            svComment.addArrangedSubview(commentItem)
        }
        lblTemp.isHidden = true
        //        uvPost.heightAnchor.constraint(equalToConstant: uvPost.frame.height + svComment.frame.height).isActive = true
    }
    func makeCommentView(_ comment: JSON,_ backComment: UIView){
        let lblUserNickName = UILabel()
        lblUserNickName.textColor = .darkText
        lblUserNickName.text = String(comment["userDTO"]["userName"].string!)
        lblUserNickName.font = UIFont.systemFont(ofSize: commentFontSize)
        
        let lblUserComment = UILabel()
        lblUserComment.textColor = .darkText
        lblUserComment.text = String(comment["content"].string!)
        lblUserComment.font = UIFont.systemFont(ofSize: commentFontSize-1)
        //        userComment.numberOfLines = 0
        
        let lblTime = UILabel()
        lblTime.text =  "시간"
        lblTime.textColor = .lightGray
        lblTime.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        let btnLikeComment = UIButton(type: .custom)
        btnLikeComment.setTitle(String(comment["selectedFavor"].intValue)+"공감" + String(comment["favorCount"].int!), for: .normal)
        btnLikeComment.setImage(UIImage(named: (comment["selectedFavor"].intValue == 0) ? "LikeOffBtn":"LikeOnBtn"), for: .normal)
        btnLikeComment.addTarget(self, action: #selector(likeComment(_:)), for: .touchUpInside)
        btnLikeComment.titleLabel!.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        btnLikeComment.setTitleColor((comment["selectedFavor"].intValue == 0) ? .lightGray: themeColor, for: .normal)
        btnLikeComment.accessibilityIdentifier = comment["replySn"].stringValue
        btnLikeComment.accessibilityValue = String(comment["selectedFavor"].intValue)
        
        let btnAddComment = UIButton(type: .system)
        btnAddComment.setTitle("댓글달기", for: .normal)
        btnAddComment.setTitleColor(.lightGray, for: .normal)
        btnAddComment.titleLabel!.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        
        let btnReportComment = UIButton(type: .system)
        btnReportComment.addTarget(self, action: #selector(reportPostOrComment), for: .touchUpInside)
        btnReportComment.setTitle("신고", for: .normal)
        btnReportComment.setTitleColor(.lightGray, for: .normal)
        btnReportComment.titleLabel!.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        btnReportComment.accessibilityIdentifier = comment["replySn"].stringValue
        
        let btnUpdateComment = UIButton(type: .system)
        btnUpdateComment.addTarget(self, action: #selector(updateComment(_:)), for: .touchUpInside)
        btnUpdateComment.setTitle("수정", for: .normal)
        btnUpdateComment.setTitleColor(.lightGray, for: .normal)
        btnUpdateComment.titleLabel!.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        btnUpdateComment.accessibilityIdentifier = comment["replySn"].stringValue
        
        let btnDeleteComment = UIButton(type: .system)
        btnDeleteComment.addTarget(self, action: #selector(deleteComment(_:)), for: .touchUpInside)
        btnDeleteComment.setTitle("삭제", for: .normal)
        btnDeleteComment.setTitleColor(.lightGray, for: .normal)
        btnDeleteComment.titleLabel!.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        btnDeleteComment.accessibilityIdentifier = comment["replySn"].stringValue
        
        let lblSpace = UILabel()
        lblSpace.text = ""
        lblSpace.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
        
        let listCommentInfo = (comment["userSn"].stringValue == getString(userData["userSn"])) ? [lblTime,btnLikeComment,btnAddComment,btnUpdateComment,btnDeleteComment,lblSpace] : [lblTime,btnLikeComment,btnAddComment,btnReportComment,lblSpace]
        let svCommentInfo = UIStackView(arrangedSubviews: listCommentInfo)
        svCommentInfo.spacing = 5
        svCommentInfo.axis = .horizontal
        svCommentInfo.distribution = .fill
        
        let imgProfile = UIImageView(image: UIImage(named: "tempProfile"))
        imgProfile.contentMode = .scaleAspectFit
        imgProfile.widthAnchor.constraint(equalToConstant: commentProfileSize).isActive = true
        imgProfile.heightAnchor.constraint(equalToConstant: commentProfileSize).isActive = true
        let svVertical = UIStackView(arrangedSubviews: [lblUserNickName,lblUserComment,svCommentInfo])
        svVertical.axis = .vertical
        svVertical.distribution = .fill
        svVertical.spacing = 2
        
        let svHorizontal = UIStackView(arrangedSubviews: [imgProfile,svVertical])
        svHorizontal.alignment = .top
        svHorizontal.axis = .horizontal
        svHorizontal.distribution = .fill
        svHorizontal.spacing = 10
        
        svHorizontal.translatesAutoresizingMaskIntoConstraints = false
        backComment.addSubview(svHorizontal)
        backComment.addConstraint(NSLayoutConstraint(item: svHorizontal, attribute: .centerX, relatedBy: .equal, toItem: backComment, attribute: .centerX, multiplier: 1, constant: 0))
        
        svHorizontal.leadingAnchor.constraint(equalTo: backComment.leadingAnchor, constant: 0).isActive = true
        svHorizontal.trailingAnchor.constraint(equalTo: backComment.trailingAnchor, constant: 0).isActive = true
        svHorizontal.widthAnchor.constraint(equalTo: backComment.widthAnchor, multiplier: 1).isActive = true
        svHorizontal.heightAnchor.constraint(equalTo: backComment.heightAnchor, multiplier: 1).isActive = true
        
        //        return backComment
    }
    func makeDeleteCommentView(_ comment: JSON,_ backComment: UIView){
        let lblDeleteGuide = UILabel()
        lblDeleteGuide.textColor = .darkText
        lblDeleteGuide.text = "삭제된 댓글입니다."
        lblDeleteGuide.font = UIFont.systemFont(ofSize: commentFontSize)
        
        let lblDeleteGuide2 = UILabel()
        lblDeleteGuide2.textColor = .darkText
        lblDeleteGuide2.text = "삭제된 댓글입니다."
        lblDeleteGuide2.font = UIFont.systemFont(ofSize: commentFontSize-2)
        //        userComment.numberOfLines = 0
        
        let imgProfile = UIImageView(image: UIImage(named: "tempProfile"))
        imgProfile.contentMode = .scaleAspectFit
        imgProfile.widthAnchor.constraint(equalToConstant: commentProfileSize).isActive = true
        imgProfile.heightAnchor.constraint(equalToConstant: commentProfileSize).isActive = true
        
        let svVertical = UIStackView(arrangedSubviews: [lblDeleteGuide,lblDeleteGuide2])
        svVertical.axis = .vertical
        svVertical.distribution = .fill
        svVertical.spacing = 2
        
        let svHorizontal = UIStackView(arrangedSubviews: [imgProfile,svVertical])
        svHorizontal.alignment = .top
        svHorizontal.axis = .horizontal
        svHorizontal.distribution = .fill
        svHorizontal.spacing = 10
        
        svHorizontal.translatesAutoresizingMaskIntoConstraints = false
        backComment.addSubview(svHorizontal)
        backComment.addConstraint(NSLayoutConstraint(item: svHorizontal, attribute: .centerX, relatedBy: .equal, toItem: backComment, attribute: .centerX, multiplier: 1, constant: 0))
        
        svHorizontal.leadingAnchor.constraint(equalTo: backComment.leadingAnchor, constant: 0).isActive = true
        svHorizontal.trailingAnchor.constraint(equalTo: backComment.trailingAnchor, constant: 0).isActive = true
        svHorizontal.widthAnchor.constraint(equalTo: backComment.widthAnchor, multiplier: 1).isActive = true
        svHorizontal.heightAnchor.constraint(equalTo: backComment.heightAnchor, multiplier: 1).isActive = true
    }
    
    @objc func reportPostOrComment(){
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
    
    @objc func likeComment(_ sender: UIButton){
        let isFavor = sender.accessibilityValue!
        replySn = sender.accessibilityIdentifier!
        print("~~~~~")
        print(isFavor)
        print(replySn)
        print("~~~~~")
        (isFavor == "0") ? likeCommentOn(replySn,sender) : likeCommentOff(replySn,sender)
    }
    func likeCommentOn(_ replySn: String, _ btn: UIButton){
        print("ON")
        let url = OperationIP + "/board/insertReplyFavorInfo.do"
        let parameter = JSON([
            "replySn": replySn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        //        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                self.requestPost(false,btn)
            }
        }
    }
    func likeCommentOff(_ replySn: String, _ btn: UIButton){
        print("OFF")
        let url = OperationIP + "/board/deleteReplyFavorInfo.do"
        let parameter = JSON([
            "replySn": replySn
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        //        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                self.requestPost(false,btn)
            }
        }
    }
    @objc func deleteComment(_ sender :UIButton) {
        let alertController = UIAlertController(title: "댓글 삭제", message: "댓글을 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.actionSheet)
        let deleteCommentAction = UIAlertAction(title: "확인", style: .destructive, handler: { _ in
            self.requestDeleteComment(sender)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(deleteCommentAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    func requestDeleteComment(_ btn: UIButton){
        replySn = btn.accessibilityIdentifier!
        let url = OperationIP + "/board/deleteReplyInfo.do"
        let parameter = JSON([
            "replySn": replySn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                //                self.requestPost(false,btn)
            }
        }
    }
    @objc func updateComment(_ sender :UIButton) {
        let alertController = UIAlertController(title: "댓글 수정", message: "댓글을 수정하시겠습니까?", preferredStyle: UIAlertController.Style.actionSheet)
        let deleteCommentAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.isCommentUpdate = true
            self.btnSendComment.setTitle("수정", for: .normal)
            self.replySn = sender.accessibilityIdentifier!
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(deleteCommentAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    func requestUpdateComment(){
        let url = OperationIP + "/board/updateReplyInfo.do"
        let parameter = JSON([
            "replySn" : replySn,
            "boardSn" : boardSn,
            "content" : tfComment.text!
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")//.replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.btnSendComment.setTitle("등록", for: .normal)
            }
        }
    }
    
    @IBAction func sendComment(_ sender: UIButton) {
        if tfComment.text!.isEmpty {
            alertControllerDefault(title: "댓글을 입력해주세요.", message: "")
        } else {
            isCommentUpdate ? requestUpdateComment() : requestComment(tfComment.text!)
            
            tfComment.text = ""
        }
    }
    func requestComment(_ comment: String){
        let url = OperationIP + "/board/insertReplyInfo.do"
        let parameter = JSON([
            "boardSn": boardSn,
            "content": comment
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")//.replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                //                print("#####")
                //                print(JSON(response.value!))
                //                print("##")
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
    
    //######################
    //      업데이트용
    //######################
    func requestPost(_ isPost : Bool, _ btn: UIButton? = nil){
        let url = OperationIP + "/board/selectBoardInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.reponseJSON = JSON(response.value!)
                isPost ? self.updatePostUI() : self.updateCommentUI(btn!)
            }
        }
    }
    func requestReview(_ isPost : Bool, _ btn: UIButton? = nil){
        let url = OperationIP + "/review/selectReviewInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            //            debugPrint(response)
            if response.value != nil {
                self.reponseJSON = JSON(response.value!)
                isPost ? self.updatePostUI() : self.updateCommentUI(btn!)
            }
        }
    }
    func updatePostUI(){
        let postData = reponseJSON
        checkLikePost = (postData["selectedFavor"].int != 0)
        btnLike.setImage(UIImage(named: checkLikePost ? "LikeOnBtn" : "LikeOffBtn"), for: .normal)
        btnLike.titleColor = checkLikePost ? themeColor : .darkGray
        btnLike.title = String(postData["favorCount"].int!)
        btnComment.title = String(postData["replyCount"].int!)
    }
    func updateCommentUI(_ btn : UIButton){
        let postData = reponseJSON
        for comment in postData["replyList"].arrayValue {
            if btn.accessibilityIdentifier! == comment["replySn"].stringValue{
                print(comment)
                let isSelectedFavor = comment["selectedFavor"].intValue
                btn.setTitle(String(isSelectedFavor) + "공감" + String(comment["favorCount"].int!), for: .normal)
                btn.setImage(UIImage(named: (isSelectedFavor == 0) ?  "LikeOffBtn":"LikeOnBtn"), for: .normal)
                btn.setTitleColor((isSelectedFavor == 0) ? .lightGray: themeColor, for: .normal)
                btn.accessibilityValue = String(isSelectedFavor)
                print(btn.accessibilityIdentifier)
                print(btn.accessibilityValue)
            }
        }
    }
    //######################
    //      장소상세 링크
    //######################
    @objc func gotoLocationInfo(_ sender: UIButton){
        let locationSn = sender.self.accessibilityIdentifier
        getLocationInfo(locationSn!)
    }
    func getLocationInfo(_ locationSn : String){
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

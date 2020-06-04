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
    
    let btnLike = FlatButton()
    let btnComment = FlatButton()
    
    @IBOutlet var uvPost: UIView!
    @IBOutlet var uvComment: UIView!
    
    @IBOutlet var svHashTag: UIStackView!
    @IBOutlet var uvFunc: UIView!
    @IBOutlet var svimage: UIStackView!
    @IBOutlet var svComment: UIStackView!
    
    @IBOutlet var lblTemp: UILabel!
    
    var checkLikePost = false
    var isMyPost = false
    
    let userData = getUserData()
    
    let commentProfileSize: CGFloat = 30
    let commentFontSize: CGFloat = 15
    let commentInfoFontSize: CGFloat = 10
    
    @IBOutlet var lblUserNickName: UILabel!
    @IBOutlet var lblPostInfo: UILabel!
    @IBOutlet var lblContentTitle: UILabel!
    @IBOutlet var lblContent: UILabel!
    
    @IBOutlet var tfComment: UITextField!
    
    var reponseJSON: JSON = []
    var boardSn = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBoardSn()
        requestPostFirst()
    }
    
    //###########################
    //          게시글
    //###########################
    func getBoardSn(){
        let navigationVCList = self.navigationController!.viewControllers
        boardSn = (navigationVCList[1] as! PostListViewController).boardSn
    }
    func requestPostFirst(){
        let url = developIP + "/board/selectBoardInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
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
        //        let navigationVCList = self.navigationController!.viewControllers
        //        let navigationTitle = navigationVCList[1].navigationItem.title
        //        self.navigationItem.title = navigationTitle
        let postData = reponseJSON
        
        lblUserNickName.text = postData["userDTO"]["userName"].string
        let strView:String = String(postData["viewCount"].intValue)
        let strDate:String = String(postData["updateDt"].string!.split(separator: " ")[0])
        lblPostInfo.text = strView + "  " + strDate
        
        lblContentTitle.text = postData["title"].string
        lblContent.isHidden = postData["content"].string == nil
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
        
        if listHashTag!.isEmpty {
            svHashTag.isHidden = true
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
            svimage.isHidden = true
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
        btnMenu.addTarget(self, action: #selector(menuComment(_:)), for: .touchUpInside)
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
        
        updatePost()
        setComment(postData["replyList"])
    }
    
    @objc func likePost(_ sender: FlatButton) {
        let postData = reponseJSON
        checkLikePost = (postData["selectedFavor"] == 0)
        checkLikePost ? likePostOn() : likePostOff()
    }
    func likePostOn(){
        let url = developIP + "/board/insertBoardFavorInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                self.requestPost()
            }
        }
    }
    func likePostOff(){
        let url = developIP + "/board/deleteBoardFavorInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                print(response.value!)
                self.requestPost()
            }
        }
    }
    
    //###########################
    //           댓글
    //###########################
    func setComment(_ comments: JSON) {
        let listComment = comments.arrayValue
        for comment in listComment{
            let commentItem = makeCommentView(comment)
            svComment.addArrangedSubview(commentItem)
        }
        lblTemp.isHidden = true
        //        uvPost.heightAnchor.constraint(equalToConstant: uvPost.frame.height + svComment.frame.height).isActive = true
    }
    
    func makeCommentView(_ comment: JSON) -> UIView {
        print(comment)
        
        let backComment = UIView()
        //        backComment.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let lblUserNickName = UILabel()
        lblUserNickName.text = String(comment["userDTO"]["userName"].string!)
        lblUserNickName.font = UIFont.systemFont(ofSize: commentFontSize)
        
        let lblUserComment = UILabel()
        lblUserComment.text = String(comment["content"].string!)
        lblUserComment.font = UIFont.systemFont(ofSize: commentFontSize-1)
        //        userComment.numberOfLines = 0
        
        let lblTime = UILabel()
        lblTime.text =  "시간"
        lblTime.textColor = .lightGray
        lblTime.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        let btnLikeComment = UIButton(type: .system)
        btnLikeComment.tag = 0
        btnLikeComment.setTitle("공감" + String(comment["selectedFavor"].int!), for: .normal)
        btnLikeComment.setImage(UIImage(named: "LikeOffBtn"), for: .normal)
        btnLikeComment.addTarget(self, action: #selector(likeComment), for: .touchUpInside)
        btnLikeComment.titleLabel!.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        btnLikeComment.setTitleColor(.lightGray, for: .normal)
        
        let btnAddComment = UIButton(type: .system)
        btnAddComment.setTitle("댓글달기", for: .normal)
        btnAddComment.setTitleColor(.lightGray, for: .normal)
        btnAddComment.titleLabel!.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        
        let btnReportComment = UIButton(type: .system)
        btnReportComment.addTarget(self, action: #selector(reportPostOrComment), for: .touchUpInside)
        btnReportComment.setTitle("신고", for: .normal)
        btnReportComment.setTitleColor(.lightGray, for: .normal)
        btnReportComment.titleLabel!.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        let lblSpace = UILabel()
        lblSpace.text = ""
        lblSpace.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
        
        let svCommentInfo = UIStackView(arrangedSubviews: [lblTime,btnLikeComment,btnAddComment,btnReportComment,lblSpace])
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
        
        return backComment
    }
    @objc func menuComment(_ sender: IconButton) {
        let alertController = UIAlertController(title: "글 메뉴", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let MyPostEditAction = UIAlertAction(title: "수정", style: .default, handler: { _ in
            
        })
        let MyPostDeleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            
        })
        
        let PostAction = UIAlertAction(title: "신고", style: .default, handler: { _ in
            self.reportPostOrComment()
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        if isMyPost {
            alertController.addAction(MyPostEditAction)
            alertController.addAction(MyPostDeleteAction)
        } else {
            alertController.addAction(PostAction)
        }
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
        if sender.tag == 0{
            sender.setImage(UIImage(named: "LikeOnBtn"), for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "LikeOffBtn"), for: .normal)
            sender.tag = 0
        }
        
    }
    @IBAction func sendComment(_ sender: UIButton) {
        if tfComment.text!.isEmpty {
            alertControllerDefault(title: "댓글을 입력해주세요.", message: "")
        } else {
            requestComment(tfComment.text!)
        }
    }
    func requestComment(_ comment: String){
        let url = developIP + "/board/insertReplyInfo.do"
        let parameter = JSON([
            "boardSn": boardSn,
            "content": comment
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                print("#####")
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
    func requestPost(){
        let url = developIP + "/board/selectBoardInfo.do"
        let parameter = JSON([
            "boardSn": boardSn
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                self.reponseJSON = JSON(response.value!)
                self.updatePost()
            }
        }
    }
    func updatePost(){
        let postData = reponseJSON
        checkLikePost = (postData["selectedFavor"].int != 0)
        btnLike.setImage(UIImage(named: checkLikePost ? "LikeOnBtn" : "LikeOffBtn"), for: .normal)
        btnLike.titleColor = checkLikePost ? themeColor : .darkGray
        btnLike.title = String(postData["favorCount"].int!)
        btnComment.title = String(postData["replyCount"].int!)
    }
}

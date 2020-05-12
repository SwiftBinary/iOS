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
    
    @IBOutlet var uvPost: UIView!
    @IBOutlet var uvComment: UIView!
    
    @IBOutlet var svHashTag: UIStackView!
    @IBOutlet var svFuncStack: UIStackView!
    @IBOutlet var svComment: UIStackView!
    
    @IBOutlet var lblTemp: UILabel!
    @IBOutlet var btnLike: FlatButton!
    @IBOutlet var btnComment: UIButton!
    @IBOutlet var btnMenu: IconButton!
    
    var checkLikePost = false
    var isMyPost = false
    
    let commentProfileSize: CGFloat = 25
    let commentNum = 10
    let commentFontSize: CGFloat = 15
    let commentInfoFontSize: CGFloat = 10
    
    @IBOutlet var lblContentTitle: UILabel!
    @IBOutlet var lblContent: UILabel!
    
    var reponseJSON: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setComment()
        requestPost()
    }
    
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        let navigationVCList = self.navigationController!.viewControllers
        let navigationTitle = navigationVCList[1].navigationItem.title
        self.navigationItem.title = navigationTitle
        
        lblContent.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
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
        
        for btn in svHashTag.arrangedSubviews {
            btn.layer.cornerRadius = 15
            btn.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            btn.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
        }
        
//        btnLike.titleLabel = "999+"
        btnLike.setImage(UIImage(named: "LikeOffBtn"), for: .normal)
        btnLike.layer.cornerRadius = 15
        
        btnComment.setTitle(String(commentNum))
        btnComment.setImage(UIImage(named: "CommentIcon"), for: .normal)
        btnComment.tintColor = .darkGray
        
        btnMenu.image = Icon.cm.moreHorizontal
        btnMenu.tintColor = .darkGray
    }
    
    func setComment() {
        for i in 1...commentNum{
            let commentItem = makeCommentView(i)
            svComment.addArrangedSubview(commentItem)
        }
        lblTemp.isHidden = true
//        uvPost.heightAnchor.constraint(equalToConstant: uvPost.frame.height + svComment.frame.height).isActive = true
    }
    
    func makeCommentView(_ index: Int) -> UIView {
        let backComment = UIView()
        //        backComment.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let lblUserNickName = UILabel()
        lblUserNickName.text = "닉네임"
        lblUserNickName.font = UIFont.systemFont(ofSize: commentFontSize)
        
        let lblUserComment = UILabel()
        lblUserComment.text = "와 제 남자친구랑 한 번 가보고 싶어요!와 제 남자친구랑 한 번 가보고 싶어요!와 제 남자친구랑 한 번 가보고 싶어요!와 제 남자친구랑 한 번 가보고 싶어요!와 제 남자친구랑 한 번 가보고 싶어요!"
        lblUserComment.font = UIFont.systemFont(ofSize: commentFontSize-1)
        //        userComment.numberOfLines = 0
        
        let lblTime = UILabel()
        lblTime.text = String(index) + "시간"
        lblTime.textColor = .lightGray
        lblTime.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        let btnLikeComment = UIButton(type: .custom)
        btnLikeComment.tag = 0
        btnLikeComment.setTitle("공감 13", for: .normal)
        btnLikeComment.setImage(UIImage(named: "LikeOffBtn"), for: .normal)
        btnLikeComment.addTarget(self, action: #selector(likeComment), for: .touchUpInside)
        btnLikeComment.titleLabel!.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        btnLikeComment.setTitleColor(.lightGray, for: .normal)
        
        let btnAddComment = UIButton(type: .custom)
        btnAddComment.setTitle("댓글달기", for: .normal)
        btnAddComment.setTitleColor(.lightGray, for: .normal)
        btnAddComment.titleLabel!.font = UIFont.systemFont(ofSize: commentInfoFontSize)
        
        let btnReportComment = UIButton(type: .custom)
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
    
    @IBAction func likePost(_ sender: FlatButton) {
        checkLikePost = !checkLikePost
        sender.setImage(UIImage(named: checkLikePost ? "LikeOnBtn" : "LikeOffBtn"), for: .normal)
        sender.titleColor = checkLikePost ? themeColor : .darkGray
    }
    
    @IBAction func menuComment(_ sender: IconButton) {
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
    
    func requestPost(){
        let url = developIP + "/board/selectBoardListInfo.do"
        let jsonHeader = JSON(["userSn":"U200207_1581067560549"])
        let parameter = JSON([
                "category": 4,
                "filterInfo": "1m",
                "sortInfo": "viewCnt",
                "offset": 0,
                "limit": 20
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":"U200207_1581067560549"]
        
        print(convertedHeaderString)
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                self.reponseJSON = JSON(response.value!)
                print("##")
                print(self.reponseJSON)
                print("##")
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

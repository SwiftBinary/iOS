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
    
    @IBOutlet var svHashTag: UIStackView!
    @IBOutlet var uvPost: UIView!
    @IBOutlet var uvComment: UIView!
    
    @IBOutlet var svFuncStack: UIStackView!
    @IBOutlet var btnLike: FlatButton!
    @IBOutlet var btnComment: UIButton!
    @IBOutlet var btnMenu: IconButton!
    
    var checkLikePost = false
    var isMyPost = false
    var commentNum = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
        requestPost()
    }
    
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        let navigationVCList = self.navigationController!.viewControllers
        let navigationTitle = navigationVCList[1].navigationItem.title
        self.navigationItem.title = navigationTitle
        
        uvPost.backgroundColor = .white
        uvPost.clipsToBounds = true
        uvPost.layer.cornerRadius = 30.0
        uvPost.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
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
        let httpHeaders: HTTPHeaders = ["json":convertedHeaderString]
        
        print(convertedHeaderString)
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                let reponseJSON = JSON(response.value!)
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

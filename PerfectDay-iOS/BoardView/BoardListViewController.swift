//
//  BoardListViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class BoardListViewController: UIViewController {

    // sv = StackView
    @IBOutlet var svList: UIStackView!
    
    @IBOutlet var tempImage: UIImageView!
    
    @IBOutlet var btnNotice: UIButton!
    @IBOutlet var btnCourseShare: UIButton!
    @IBOutlet var btnHot: UIButton!
    @IBOutlet var btnFree: UIButton!
    @IBOutlet var btnSomething: UIButton!
    @IBOutlet var btnAdvice: UIButton!
    @IBOutlet var btnReview: UIButton!
    
    var btnList: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageAction()
        setButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setImageAction() {
        tempImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedMe)))
        tempImage.isUserInteractionEnabled = true
    }
    @objc func tappedMe()
    {
        print("Tapped on Image")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let plViewController = segue.destination as! PostListViewController
        // segue.indentifier -> 스토리보드 화살표(노드) segue Indentifier 명
        if segue.identifier == "notice" {
            plViewController.naviTitle = "공지사항"
        } else if segue.identifier == "courseshare" {
            plViewController.naviTitle = "코스를 공유해요"
        } else if segue.identifier == "hot" {
            plViewController.naviTitle = "인기 게시판"
        } else if segue.identifier == "free" {
            plViewController.naviTitle = "자유 게시판"
        } else if segue.identifier == "something" {
            plViewController.naviTitle = "썸타는 게시판"
        } else if segue.identifier == "advice" {
            plViewController.naviTitle = "조언을 해줘요"
        } else if segue.identifier == "review" {
            plViewController.naviTitle = "실시간 장소리뷰"
        }
//        plViewController.textMessage = messageTx.text! // 메인화면 문구를 수정화면으로 전달
//        plViewController.isOn = isOn
//        plViewController.delegate = self
        
    }
    
    func setButton(){
        btnList = [btnNotice,btnCourseShare,btnHot,btnFree, btnSomething,btnAdvice,btnReview]
        for btn in btnList {
            btn.imageView?.contentMode = .scaleAspectFit
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

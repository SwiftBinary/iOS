//
//  PostListViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {

    var naviTitle: String = ""
    @IBOutlet var btnCreatePost: UIButton!
    @IBOutlet var btnFilter: UIButton!
    
    @IBOutlet var svPostList: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = naviTitle
        if naviTitle == "실시간 장소리뷰" || naviTitle == "공지사항" {
            btnCreatePost.isHidden = true
        } else {
            tempFunc(n: 20)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUI() {
        
    }
    
    func tempFunc(n: Int){
        for _ in 0...n {
            let tempSv = makeTempSv()
            svPostList.addArrangedSubview(tempSv)
        }
        svPostList.spacing = 0.5
        svPostList.translatesAutoresizingMaskIntoConstraints = false
//        svPostList.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        let endLbl = UILabel()
        endLbl.text = " "
        endLbl.backgroundColor = .white
        svPostList.addArrangedSubview(endLbl)
    }
    
    func makeTempSv() -> UIStackView {
        let lblNickName = UILabel()
        let lblTitle = UILabel()
        let lblContent = UILabel()
        let lblDate = UILabel()
        lblNickName.text = "닉네임"
        lblTitle.text = "게시글 제목"
        lblContent.text = "내용을 입력해주세요."
        lblDate.text = "2020-02-24"
        
        lblNickName.backgroundColor = .white
        lblTitle.backgroundColor = .white
        lblContent.backgroundColor = .white
        lblDate.backgroundColor = .white
        
        let tempSv = UIStackView(arrangedSubviews: [lblNickName,lblTitle,lblContent,lblDate])
        
        tempSv.axis = .vertical
        tempSv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoPost)))
        
        return tempSv
    }
    
    @objc func gotoPost(){
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "showPostView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    
    @IBAction func gotoCreatePost(_ sender: UIButton) {
        
    }
    
    @IBAction func showFilter(_ sender: UIButton) {
        let goToVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "postFilterView")
        self.present(goToVC, animated: true, completion: nil)
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

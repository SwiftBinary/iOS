//
//  WriteReviewViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/11.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

class WriteReviewViewController: UIViewController {

    @IBOutlet var tvContentView: UIView!
    @IBOutlet var tfHashTag: UITextField!
    @IBOutlet var tfHashTag2: UITextField!
    
    @IBOutlet var svRating: UIStackView!
    @IBOutlet var lblRate: UILabel!
    
    
    let strReivew = ["별로예요.",
    "아쉬워요.",
    "무난하네요.",
    "좋아요! 마음에 듭니다.",
    "마음에 쏙 들어요! 적극추천~"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        self.navigationItem.title = "리뷰 작성하기"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        setStarRating()
        setTextView()
    }
    
    func setStarRating(){
        for (index,btn) in svRating.arrangedSubviews.enumerated() {
            (btn as! UIButton).addTarget(self, action: #selector(selectRate(_:)), for: .touchUpInside)
            print(index)
        }
    }
    
    func setTextView(){
        let content = RSKPlaceholderTextView(frame: CGRect(x: 0, y: 0, width: tvContentView.frame.width, height: tvContentView.frame.height))
        content.placeholder = "자유롭게 좋았던 점과 불만스러웠던 점을 남겨주세요."
        tvContentView.addSubview(content)
        tvContentView.addConstraint(NSLayoutConstraint(item: content, attribute: .centerX, relatedBy: .equal, toItem: tvContentView, attribute: .centerX, multiplier: 1, constant: 0))
        tvContentView.addConstraint(NSLayoutConstraint(item: content, attribute: .centerY, relatedBy: .equal, toItem: tvContentView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    @objc func selectRate(_ sender: UIButton){
        let index = svRating.arrangedSubviews.firstIndex(of: sender)
        lblRate.text = strReivew[index!]
    }
    
    @IBAction func checkEdit(_ sender: UITextField) {
        if tfHashTag.text == "" {
            tfHashTag2.isHidden = false
        } else {
            tfHashTag2.isHidden = true
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

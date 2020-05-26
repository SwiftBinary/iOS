//
//  SearchViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/11.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var svHashTag: UIStackView!
    let strHashTag = ["건대", "홍대", "강남", "이색", "고궁", "tv방영", "가성비", "고급진", "국밥", "방탈출", "야식", "비오는날", "100일데이트코스", "커플100%되는곳", "킬링타임코스", "호불호없는"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    func setUI() {
        for hashTag in strHashTag {
            let btnHashTag = UIButton(type: .system)
            btnHashTag.setTitle(setHashTagString(hashTag))
            btnHashTag.layer.cornerRadius = 15
            btnHashTag.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            btnHashTag.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
            svHashTag.addArrangedSubview(btnHashTag)
        }
        svHashTag.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        // 실제 적용 시에
        // - 서버에서 올릴 해시태그 받아서
        // - 버튼 변수 만들고 속성 부여 후
        // - svHashTag에 addArrangedSubview로 버튼 추가
        for btn in svHashTag.arrangedSubviews {
            btn.layer.cornerRadius = 15
            btn.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            btn.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
        }
        svHashTag.translatesAutoresizingMaskIntoConstraints = false
    }

    /* _ */

}

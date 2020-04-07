//
//  DibsCourseViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/12.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DibsCourseViewController: UIViewController, IndicatorInfoProvider {

    var itemInfo: IndicatorInfo = "View"

    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScroll(scrollView)
        //setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let VC = self.parent?.parent
        VC?.navigationItem.leftBarButtonItem = nil
    }
    func setScroll(_ scrollMain: UIScrollView){

        scrollMain.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollMain)
        view.addConstraint(NSLayoutConstraint(item: scrollMain, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        scrollMain.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        scrollMain.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollMain.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        scrollMain.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        scrollMain.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        let svMain = UIStackView()
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.distribution = .fillEqually
        svMain.backgroundColor = .darkGray
        svMain.axis = .vertical
        svMain.spacing = 15

        scrollMain.addSubview(svMain)
        scrollMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: scrollMain, attribute: .centerX, multiplier: 1, constant: 0))
        svMain.widthAnchor.constraint(equalTo: scrollMain.widthAnchor, multiplier: 0.9).isActive = true
        svMain.topAnchor.constraint(equalTo: scrollMain.topAnchor, constant: 15).isActive = true

        for _ in 0...100 {
            let tempBtn = UIButton(type: .system)
            tempBtn.setTitle("Button", for: .normal)
            tempBtn.backgroundColor = .white
            setSNSButton(tempBtn,"")
            svMain.addArrangedSubview(tempBtn)
        }
    }
    
    
    func setUI(){
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "찜한 코스"

        view.addSubview(label)
        view.backgroundColor = .white

        view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -50))
    }
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

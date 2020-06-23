//
//  DibsViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DibsViewController: ButtonBarPagerTabStripViewController {

        let colorPink = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
        
        override func viewDidLoad() {
            setUI()
            super.viewDidLoad()
        }

        func setUI(){
            // change selected bar color
            settings.style.buttonBarBackgroundColor = .white
            settings.style.buttonBarItemBackgroundColor = .white
            settings.style.selectedBarBackgroundColor = colorPink
            settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
            settings.style.selectedBarHeight = 2.0
            settings.style.buttonBarMinimumLineSpacing = 0
            settings.style.buttonBarItemTitleColor = .black
            settings.style.buttonBarItemsShouldFillAvailableWidth = true
            settings.style.buttonBarLeftContentInset = 0
            settings.style.buttonBarRightContentInset = 0

            changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
                guard changeCurrentIndex == true else { return }
                oldCell?.label.textColor = .black
                newCell?.label.textColor = self?.colorPink
            }
        }
        
        // MARK: - PagerTabStripDataSource
        override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
            let child_1 = DibsLocationViewController(itemInfo: "장소")
            let child_2 = DibsCourseViewController(itemInfo: "코스")
            return [child_1, child_2]
        }
    }

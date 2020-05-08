//
//  SetLikeViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/24.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class SetLikeViewController: UIViewController {

    
    @IBOutlet var svCategory: UIStackView!
    
    @IBOutlet var uvEat: UIView!
    @IBOutlet var uvDrink: UIView!
    @IBOutlet var uvPlay: UIView!
    @IBOutlet var uvWatch: UIView!
    @IBOutlet var uvWalk: UIView!
    
    
    var openList = [true,false,false,false,false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setUIView()
    }
    
    func setUI(){
            self.tabBarController?.tabBar.isHidden = true
    }
    func setUIView(){
        let uvList: Array<UIView> = [uvEat,uvDrink,uvPlay,uvWatch,uvWalk]
        for (index, uv) in uvList.enumerated() {
            uv.backgroundColor = .white
            uv.layer.cornerRadius = 15.0
            uv.layer.shadowColor = UIColor.lightGray.cgColor
            uv.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            uv.layer.shadowRadius = 2.0
            uv.layer.shadowOpacity = 0.9
            uv.tag = index
            uv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCategory(_:))))
        }
    }
    
    @objc func openCategory(_ sender: UITapGestureRecognizer){
        let viewTag = sender.view!.tag
        let openedViewTag = openList.contains(true) ? openList.firstIndex(of: true) : -1
        
        clipView(viewIndex: viewTag)
        if (openedViewTag != -1) && (viewTag != openedViewTag) {
            clipView(viewIndex: openedViewTag!)
        }
    }
    func clipView(viewIndex: Int) {
        for subIndex in 1..<svCategory.arrangedSubviews[viewIndex].subviews.first!.subviews.endIndex {
            svCategory.arrangedSubviews[viewIndex].subviews.first!.subviews[subIndex].isHidden = openList[viewIndex]
        }
        openList[viewIndex] = !openList[viewIndex]
        (svCategory.arrangedSubviews[viewIndex].subviews.first!.subviews.first!.subviews.last as! UIImageView).image = openList[viewIndex] ? UIImage(named: "upArrow") : UIImage(named: "downArrow")
    }
    
    @IBAction func gotoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

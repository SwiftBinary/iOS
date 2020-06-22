//
//  SearchPostViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/12.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MaterialDesignWidgets
import Material

// UIPickerViewDelegate, UIPickerViewDataSource,
class SearchPostViewController: UIViewController,UIGestureRecognizerDelegate, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let strHashTag = ["건대", "홍대", "강남", "이색", "고궁", "tv방영", "가성비", "고급진", "국밥", "방탈출", "야식", "비오는날", "100일데이트코스", "커플100%되는곳", "킬링타임코스", "호불호없는"]
    let btnMargin:CGFloat = -10
    var scrollPostList = UIScrollView()
    var svPostList = UIStackView()
    var btnScrollUp = UIButton(type: .custom)
    let segmentControl = MaterialSegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        setFilterUI()
        //        setScroll(UIScrollView())
        setPostUI()
        setScrollUI()
    }
    func setSampleSegments(_ segmentedControl: MaterialSegmentedControl, _ cornerRadius: CGFloat) {
        let strList = ["게시글","생생 리뷰"]
        for str in strList {
            // Button background needs to be clear, it will be set to clear in segmented control anyway.
            let button = MaterialButton(text: str, textColor: .white, bgColor: #colorLiteral(red: 1, green: 0.3921568627, blue: 0.568627451, alpha: 1), cornerRadius: cornerRadius)
            button.titleLabel?.fontSize = 13
            button.rippleLayerColor = .white
            button.rippleLayerAlpha = 0.15
            segmentedControl.segments.append(button)
        }
    }
    
    func setFilterUI(){
        // UI 구조
        // 세로 스택뷰[ 가로 스택 뷰1{선택한 위치 라벨, 위치 설정 버튼} , 가로 스택 뷰2{결과 장소 수 라벨, 필터 버튼, 정렬조건 버튼} ]
        let svHorizontal = UIStackView()
        let svLabel = UIStackView()
        let lblCountPostGuide = UILabel()
        let lblCountPost = UILabel()
        let lblCountPostEnd = UILabel()
        let btnFilter = UIButton(type: .custom)
        
        //Label Setting
        let intFontSize:CGFloat = 13
        lblCountPostGuide.fontSize = intFontSize
        lblCountPostGuide.textColor = .darkText
        lblCountPostGuide.text = "조건에 해당하는 게시물: "
        lblCountPostGuide.textAlignment = .right
        lblCountPost.fontSize = intFontSize
        lblCountPost.textColor = #colorLiteral(red: 0.9882352941, green: 0.368627451, blue: 0.5725490196, alpha: 1)
        lblCountPost.text = "000"
        lblCountPost.textAlignment = .center
        lblCountPostEnd.fontSize = intFontSize
        lblCountPostEnd.textColor = .darkText
        lblCountPostEnd.text = " 개"
        lblCountPostEnd.textAlignment = .left
        
        //segmentControl
//        let segmentControl = MaterialSegmentedControl()
        segmentControl.selectorStyle = .fill
        segmentControl.foregroundColor = .white
        segmentControl.selectedForegroundColor = .white
        segmentControl.selectorColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.568627451, alpha: 1)
        segmentControl.backgroundColor = .lightGray
        setSampleSegments(segmentControl, intFontSize)
        segmentControl.setCornerBorder(cornerRadius: intFontSize)
        
        //Button Setting
        btnFilter.setTitle("", for: .normal)
        btnFilter.setImage(UIImage(named: "FilterBtn"), for: .normal)
        btnFilter.addTarget(self, action: #selector(filterPost), for: .touchUpInside)
        
        //Stack Setting
        svLabel.addArrangedSubview(lblCountPostGuide)
        svLabel.addArrangedSubview(lblCountPost)
        svLabel.addArrangedSubview(lblCountPostEnd)
        svHorizontal.addArrangedSubview(svLabel)
        svHorizontal.addArrangedSubview(segmentControl)
        svHorizontal.addArrangedSubview(btnFilter)
        
        btnFilter.widthAnchor.constraint(equalTo: svHorizontal.heightAnchor, multiplier: 1).isActive = true
        
        svHorizontal.translatesAutoresizingMaskIntoConstraints = false
        svHorizontal.distribution = .fill
        svHorizontal.spacing = 3
        view.addSubview(svHorizontal)
        view.addConstraint(NSLayoutConstraint(item: svHorizontal, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        svHorizontal.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        svHorizontal.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        // Add actions
    }
    
    @objc func filterPost(sender: UIButton){
        let goToVC = UIStoryboard.init(name: "Search", bundle: Bundle.main).instantiateViewController(withIdentifier: "postFilterView")
        self.present(goToVC, animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    
    func setPostUI(){
        tempFunc()
        
        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        panGestureRecongnizer.delegate = self
        scrollPostList.addGestureRecognizer(panGestureRecongnizer)
    }
    
    @objc func panAction(_ sender : UIPanGestureRecognizer){
        btnScrollUp.isHidden = (scrollPostList.contentOffset.y <= 0)
    }
    
    func tempFunc(){
        for index in 1..<5 {
            let tempView = makeTempUv(index)
            svPostList.addArrangedSubview(tempView)
        }
        svPostList.translatesAutoresizingMaskIntoConstraints = false
        let endLbl = UILabel()
        endLbl.text = " "
        endLbl.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        endLbl.backgroundColor = .white
        svPostList.addArrangedSubview(endLbl)
    }
    
    func makeTempUv(_ i: Int) -> UIView {
        let viewPost = UIView()
        viewPost.backgroundColor = .white
        viewPost.layer.cornerRadius = 15
        viewPost.layer.shadowColor = UIColor.lightGray.cgColor
        viewPost.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewPost.layer.shadowRadius = 2.0
        viewPost.layer.shadowOpacity = 0.9
        
        let lblTitle = UILabel()
        lblTitle.textColor = .darkText
        lblTitle.text = "게시글 " + String(i)
        let lblContent = UILabel()
        lblContent.textColor = .darkText
        //            lblContent.isHidden = postData["content"].string == nil
        lblContent.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        lblContent.numberOfLines = 4 //countLabelLines(label: lblContent)
        lblContent.lineBreakMode = .byCharWrapping
        
        let scvTag = UIScrollView()
        scvTag.translatesAutoresizingMaskIntoConstraints = false
        let svTag = UIStackView()
        for hashTag in strHashTag {
            let btnHashTag = UIButton(type: .system)
            btnHashTag.setTitle(setHashTagString(hashTag))
            btnHashTag.layer.cornerRadius = 15
            btnHashTag.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            btnHashTag.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
            svTag.addArrangedSubview(btnHashTag)
        }
        svTag.translatesAutoresizingMaskIntoConstraints = false
        svTag.spacing = 5
        scvTag.addSubview(svTag)
        scvTag.addConstraint(NSLayoutConstraint(item: svTag, attribute: .centerY, relatedBy: .equal, toItem: scvTag, attribute: .centerY, multiplier: 1, constant: 0))
        scvTag.showsHorizontalScrollIndicator = false
//        svTag.heightAnchor.constraint(equalTo: scvTag.heightAnchor, multiplier: 1).isActive = true
        svTag.topAnchor.constraint(equalTo: scvTag.topAnchor, constant: 0).isActive = true
        svTag.bottomAnchor.constraint(equalTo: scvTag.bottomAnchor, constant: 0).isActive = true
        svTag.leadingAnchor.constraint(equalTo: scvTag.leadingAnchor, constant: 0).isActive = true
        svTag.trailingAnchor.constraint(equalTo: scvTag.trailingAnchor, constant: 0).isActive = true
        
        let scvImg = UIScrollView()
        scvImg.translatesAutoresizingMaskIntoConstraints = false
        let svImg = UIStackView(arrangedSubviews: [UIImageView(image: UIImage(named: "tempProfile")),UIImageView(image: UIImage(named: "tempProfile")),UIImageView(image: UIImage(named: "tempProfile")),UIImageView(image: UIImage(named: "tempProfile")),UIImageView(image: UIImage(named: "tempProfile"))])
        svImg.translatesAutoresizingMaskIntoConstraints = false
        svImg.spacing = 5
        scvImg.addSubview(svImg)
        for img in svImg.arrangedSubviews {
            img.widthAnchor.constraint(equalToConstant: 100).isActive = true
            img.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        scvImg.addConstraint(NSLayoutConstraint(item: svImg, attribute: .centerY, relatedBy: .equal, toItem: scvImg, attribute: .centerY, multiplier: 1, constant: 0))
        svImg.heightAnchor.constraint(equalTo: scvImg.heightAnchor, multiplier: 1).isActive = true
        svImg.topAnchor.constraint(equalTo: scvImg.topAnchor, constant: 0).isActive = true
        svImg.bottomAnchor.constraint(equalTo: scvImg.bottomAnchor, constant: 0).isActive = true
        svImg.leadingAnchor.constraint(equalTo: scvImg.leadingAnchor, constant: 0).isActive = true
        svImg.trailingAnchor.constraint(equalTo: scvImg.trailingAnchor, constant: 0).isActive = true
        
        let svContent = UIStackView(arrangedSubviews: [lblTitle,lblContent,scvTag,scvImg])
        svContent.axis = .vertical
        svContent.spacing = 5
        svContent.distribution = .fill
        let uvContent = UIView()
        svContent.translatesAutoresizingMaskIntoConstraints = false
        uvContent.addSubview(svContent)
        uvContent.addConstraint(NSLayoutConstraint(item: svContent, attribute: .centerX, relatedBy: .equal, toItem: uvContent, attribute: .centerX, multiplier: 1, constant: 0))
        uvContent.addConstraint(NSLayoutConstraint(item: svContent, attribute: .centerY, relatedBy: .equal, toItem: uvContent, attribute: .centerY, multiplier: 1, constant: 0))
        svContent.widthAnchor.constraint(equalTo: uvContent.widthAnchor, multiplier: 0.9).isActive = true
        svContent.heightAnchor.constraint(equalTo: uvContent.heightAnchor, multiplier: 1).isActive = true
        
        let uvLineTop = UIView()
        uvLineTop.backgroundColor = .none
        uvLineTop.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        
        let uvLine = UIView()
        uvLine.backgroundColor = .lightGray
        uvLine.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
        
        let uvLineBottom = UIView()
        uvLineBottom.backgroundColor = .none
        uvLineBottom.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        
        //            let btnLike = FlatButton(title: "String(postData["favorCount"].int!)")
        let btnLike = FlatButton(title: "999")
        btnLike.setImage(UIImage(named: "LikeOffBtn"), for: .normal)
        btnLike.layer.cornerRadius = 5
        //        btnLike.contentEdgeInsets.left = btnMargin
        //        btnLike.contentEdgeInsets.right = btnMargin
        btnLike.titleColor = .lightGray
        let btnComment = FlatButton(title: "999")
        btnComment.isEnabled = false
        btnComment.setImage(UIImage(named: "CommentIcon"), for: .normal)
        btnComment.titleColor = .lightGray
//        btnComment.contentEdgeInsets.left = btnMargin
//        btnComment.contentEdgeInsets.right = btnMargin
        let lblTemp = UILabel()
        lblTemp.text = "                          "
        lblTemp.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
        let btnMenu = IconButton()
        btnMenu.image = Icon.cm.moreHorizontal
        btnMenu.tintColor = .darkGray
        let svFunc = UIStackView(arrangedSubviews: [btnLike,btnComment,lblTemp,btnMenu])
        svFunc.axis = .horizontal
        svFunc.distribution = .fillProportionally
        svFunc.spacing = 5
        let uvFunc = UIView()
        svFunc.translatesAutoresizingMaskIntoConstraints = false
        uvFunc.addSubview(svFunc)
        uvFunc.addConstraint(NSLayoutConstraint(item: svFunc, attribute: .centerX, relatedBy: .equal, toItem: uvFunc, attribute: .centerX, multiplier: 1, constant: 0))
        uvFunc.addConstraint(NSLayoutConstraint(item: svFunc, attribute: .centerY, relatedBy: .equal, toItem: uvFunc, attribute: .centerY, multiplier: 1, constant: 0))
        svFunc.widthAnchor.constraint(equalTo: uvFunc.widthAnchor, multiplier: 0.9).isActive = true
        svFunc.heightAnchor.constraint(equalTo: uvFunc.heightAnchor, multiplier: 1).isActive = true
        
        
        let svMain = UIStackView(arrangedSubviews: [uvLineTop,uvContent,uvLine,uvFunc,uvLineBottom])
        svMain.axis = .vertical
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.spacing = 5
        viewPost.addSubview(svMain)
        viewPost.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: viewPost, attribute: .centerX, multiplier: 1, constant: 0))
        viewPost.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: viewPost, attribute: .centerY, multiplier: 1, constant: 0))
        svMain.widthAnchor.constraint(equalTo: viewPost.widthAnchor, multiplier: 1).isActive = true
        svMain.heightAnchor.constraint(equalTo: viewPost.heightAnchor, multiplier: 1).isActive = true
        
//        viewPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoPost)))
        
        return viewPost
    }
    
    @objc func gotoPost(){
        let goToVC = UIStoryboard.init(name: "Board", bundle: Bundle.main).instantiateViewController(withIdentifier: "showPostView")
        self.present(goToVC, animated: true, completion: nil)
    }
    
    func setScrollUI(){
        scrollPostList.translatesAutoresizingMaskIntoConstraints = false
        svPostList.translatesAutoresizingMaskIntoConstraints = false
        svPostList.distribution = .fill
        svPostList.axis = .vertical
        svPostList.spacing = 15
        
        view.addSubview(scrollPostList)
        view.addConstraint(NSLayoutConstraint(item: scrollPostList, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.widthAnchor.constraint(equalTo: scrollPostList.widthAnchor, multiplier: 1).isActive = true
        scrollPostList.topAnchor.constraint(equalTo: view.subviews[0].bottomAnchor, constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: scrollPostList.bottomAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollPostList.trailingAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: scrollPostList.leadingAnchor, constant: 0).isActive = true
        
        scrollPostList.addSubview(svPostList)
        scrollPostList.addConstraint(NSLayoutConstraint(item: svPostList, attribute: .centerX, relatedBy: .equal, toItem: scrollPostList, attribute: .centerX, multiplier: 1, constant: 0))
        svPostList.widthAnchor.constraint(equalTo: scrollPostList.widthAnchor, multiplier: 1).isActive = true
        svPostList.topAnchor.constraint(equalTo: scrollPostList.topAnchor, constant: 0).isActive = true
        svPostList.bottomAnchor.constraint(equalTo: scrollPostList.bottomAnchor, constant: 0).isActive = true
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

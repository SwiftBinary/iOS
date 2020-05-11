//
//  PostListViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import ImageSlideshow
import Material

class PostListViewController: UIViewController,UIGestureRecognizerDelegate,UISearchBarDelegate {
    let darkGray = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    let themeColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
    var segueTitle: Int = 0
    let arrayTitle = ["공지사항","코스를 공유해요","인기 게시판","자유 게시판","썸타는 게시판","조언을 구해요","실시간 장소리뷰"]
    let arrayHiddenCreate = [0,2,6]
    
    let testNum = 20
    
    @IBOutlet var btnScrollUp: UIButton!
    @IBOutlet var btnCreatePost: UIButton!
    
    @IBOutlet var issBanner: ImageSlideshow!
    let localSource = [BundleImageSource(imageString: "testBanner0"), BundleImageSource(imageString: "testBanner1"), BundleImageSource(imageString: "testBanner2"), BundleImageSource(imageString: "testBanner3")]
    @IBOutlet var lblBannerIndex: UILabel!
    
    @IBOutlet var scrollPostList: UIScrollView!
    @IBOutlet var svPostList: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBanner()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUI() {
        let navigationVCList = self.navigationController!.viewControllers
        segueTitle = (navigationVCList[0] as! BoardListViewController).segueTag
        
        self.navigationItem.title = arrayTitle[segueTitle]
        if arrayHiddenCreate.contains(segueTitle) { // 실시간 장소리뷰, 공지사항
            btnCreatePost.isHidden = true
        } else {
            tempFunc(n: testNum)
        }
        
        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        panGestureRecongnizer.delegate = self
        scrollPostList.addGestureRecognizer(panGestureRecongnizer)
    }
    func setBanner(){
        issBanner.slideshowInterval = 5.0
        issBanner.contentScaleMode = UIViewContentMode.scaleAspectFill
        issBanner.pageIndicator = nil
        issBanner.activityIndicator = DefaultActivityIndicator()
        issBanner.delegate = self
        issBanner.setImageInputs(localSource)
        
        lblBannerIndex.text = setSideSpace("1/\(localSource.count)")
        lblBannerIndex.layer.cornerRadius = 5.0
        lblBannerIndex.layer.borderWidth = 1
        lblBannerIndex.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lblBannerIndex.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    func setSideSpace(_ str: String) -> String {
        let resultStr = "   " + str + "   "
        return resultStr
    }
    
    func tempFunc(n: Int){
        for _ in 0...testNum {
            let tempView = makeTempUv()
            svPostList.addArrangedSubview(tempView)
        }
        svPostList.translatesAutoresizingMaskIntoConstraints = false
        let endLbl = UILabel()
        endLbl.text = " "
        endLbl.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
        endLbl.backgroundColor = .white
        svPostList.addArrangedSubview(endLbl)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    
    @objc func panAction (_ sender : UIPanGestureRecognizer){
        btnScrollUp.isHidden = (scrollPostList.contentOffset.y <= 0)
    }
    
    func makeTempUv() -> UIView {
        let myView = UIView()
        myView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        myView.backgroundColor = .white
        myView.layer.cornerRadius = 30.0
        myView.layer.shadowColor = UIColor.lightGray.cgColor
        myView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        myView.layer.shadowRadius = 2.0
        myView.layer.shadowOpacity = 0.9
//        let lblNickName = UILabel()
//        let lblTitle = UILabel()
//        let lblContent = UILabel()
//        let lblDate = UILabel()
//        lblNickName.text = "닉네임"
//        lblTitle.text = "게시글 제목"
//        lblContent.text = "내용을 입력해주세요."
//        lblDate.text = "2020-02-24"
//
//        lblNickName.backgroundColor = .white
//        lblTitle.backgroundColor = .white
//        lblContent.backgroundColor = .white
//        lblDate.backgroundColor = .white
//
//        let tempSv = UIStackView(arrangedSubviews: [lblNickName,lblTitle,lblContent,lblDate])
//
//        tempSv.axis = .vertical
//        tempSv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoPost)))
        myView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoPost)))
        
        return myView
    }
    
    @objc func gotoPost(){
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "showPostView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    
    @IBAction func searchPost(_ sender: UIBarButtonItem) {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItems?.remove(at: 1)
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "ex) 동 검색: 화양동, 키워드 검색: 치킨.."
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.heightAnchor.constraint(equalToConstant: (self.navigationController?.navigationBar.frame.height)!).isActive = true
        self.navigationItem.titleView = searchBar
    }
    
    @IBAction func upToTop(_ sender: Any) {
        scrollPostList.scrollToTop()
        btnScrollUp.isHidden = true
    }
    
    @IBAction func gotoCreatePost(_ sender: UIButton) {
        
    }
    
    
    // 수정 필요
    @IBAction func showFilter(_ sender: UIBarButtonItem) {
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

extension PostListViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        lblBannerIndex.text = setSideSpace("\(page+1)/\(localSource.count)")
//        print("current page:", page)
    }
}


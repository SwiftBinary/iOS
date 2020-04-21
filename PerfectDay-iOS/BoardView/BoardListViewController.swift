//
//  BoardListViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import ImageSlideshow

class BoardListViewController: UIViewController {

    // sv = StackView
    
    @IBOutlet var issBanner: ImageSlideshow!
    let localSource = [BundleImageSource(imageString: "testBanner0"), BundleImageSource(imageString: "testBanner1"), BundleImageSource(imageString: "testBanner2"), BundleImageSource(imageString: "testBanner3")]
    @IBOutlet var lblBannerIndex: UILabel!    

    @IBOutlet var svTemp: UIStackView!
    
    @IBOutlet var uvNotice: UIView!
    @IBOutlet var uvShareCourse: UIView!
    @IBOutlet var uvHot: UIView!
    @IBOutlet var uvFree: UIView!
    @IBOutlet var uvSomething: UIView!
    @IBOutlet var uvAdvice: UIView!
    @IBOutlet var uvReview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBanner()
        setGotoPostList()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
        
        //UIView 추가해서 배경만들기
    }
    func setSideSpace(_ str: String) -> String {
        let resultStr = "   " + str + "   "
        return resultStr
    }
    
    func setGotoPostList() {
        let uvList = [uvNotice,uvShareCourse,uvHot,uvFree,uvSomething,uvAdvice,uvReview]
        for view in uvList{
            view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToPostList)))
        }
    }
    @objc func goToPostList() {
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "postListView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let plViewController = segue.destination as! PostListViewController
        print("##########")
        print(sender)
        print("##########")
        // segue.indentifier -> 스토리보드 화살표(노드) segue Indentifier 명
//        if segue.identifier == "notice" {
//            plViewController.naviTitle = "공지사항"
//        } else if segue.identifier == "courseshare" {
//            plViewController.naviTitle = "코스를 공유해요"
//        } else if segue.identifier == "hot" {
//            plViewController.naviTitle = "인기 게시판"
//        } else if segue.identifier == "free" {
//            plViewController.naviTitle = "자유 게시판"
//        } else if segue.identifier == "something" {
//            plViewController.naviTitle = "썸타는 게시판"
//        } else if segue.identifier == "advice" {
//            plViewController.naviTitle = "조언을 해줘요"
//        } else if segue.identifier == "review" {
//            plViewController.naviTitle = "실시간 장소리뷰"
//        }
//        plViewController.textMessage = messageTx.text!
//        plViewController.isOn = isOn
//        plViewController.delegate = self
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

extension BoardListViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        lblBannerIndex.text = setSideSpace("\(page+1)/\(localSource.count)")
//        print("current page:", page)
    }
}

//    func setBanner(){
//        issBanner.slideshowInterval = 5.0
//        issBanner.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
//        issBanner.pageIndicatorPosition = .init(horizontal: .right(padding: 10), vertical: .under)
//        issBanner.contentScaleMode = UIViewContentMode.scaleAspectFill
//        let pageControl = UIPageControl()
//        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
//        pageControl.pageIndicatorTintColor = UIColor.black
//        pageControl.backgroundColor = .blue
//        issBanner.pageIndicator = pageControl
//        issBanner.pageIndicator = nil
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
//        issBanner.activityIndicator = DefaultActivityIndicator()
//        issBanner.delegate = self
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
//        issBanner.setImageInputs(localSource)
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
//        issBanner.addGestureRecognizer(recognizer)
//        lblBannerIndex.text = "1/\(localSource.count)"
//        lblBannerIndex.backgroundColor = .white
        //UIView 추가해서 배경만들기
//    }

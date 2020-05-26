//
//  PostListViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import ImageSlideshow
import Material

class PostListViewController: UIViewController,UIGestureRecognizerDelegate,UISearchBarDelegate {
    let darkGray = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    let themeColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
    var segueTitle: Int = 0
    let arrayTitle = ["공지사항","코스를 공유해요","인기 게시판","자유 게시판","썸타는 게시판","조언을 구해요","실시간 장소리뷰"]
    let strHashTag = ["건대", "홍대", "강남", "이색", "고궁", "tv방영", "가성비", "고급진", "국밥", "방탈출", "야식", "비오는날", "100일데이트코스", "커플100%되는곳", "킬링타임코스", "호불호없는"]
    let arrayHiddenCreate = [0,2,6]
    
    let btnMargin:CGFloat = -10
    var reponseJSON:JSON = []
    
    
    @IBOutlet var btnScrollUp: UIButton!
    @IBOutlet var btnCreatePost: UIButton!
    
    @IBOutlet var issBanner: ImageSlideshow!
    let localSource = [BundleImageSource(imageString: "testBanner0"), BundleImageSource(imageString: "testBanner1"), BundleImageSource(imageString: "testBanner2"), BundleImageSource(imageString: "testBanner3")]
    @IBOutlet var lblBannerIndex: UILabel!
    
    @IBOutlet var scrollPostList: UIScrollView!
    @IBOutlet var svPostList: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCatagoryInfo()
        requestPost()
        
        setBanner()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getCatagoryInfo(){
        let navigationVCList = self.navigationController!.viewControllers
        segueTitle = (navigationVCList[0] as! BoardListViewController).segueTag
        self.navigationItem.title = arrayTitle[segueTitle]
    }
    
    func setUI() {
        if arrayHiddenCreate.contains(segueTitle) { // 실시간 장소리뷰, 공지사항
            btnCreatePost.isHidden = true
        }
        tempFunc(reponseJSON)
        
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
    
    func tempFunc(_ reponseData: JSON){
        let arrayData = reponseData.arrayValue
        for data in arrayData {
            let tempView = makeTempUv(data)
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
    
    @objc func panAction(_ sender : UIPanGestureRecognizer){
        btnScrollUp.isHidden = (scrollPostList.contentOffset.y <= 0)
    }
    
    func makeTempUv(_ postData: JSON) -> UIView {
        let viewPost = UIView()
        viewPost.backgroundColor = .white
        viewPost.layer.cornerRadius = 15
        viewPost.layer.shadowColor = UIColor.lightGray.cgColor
        viewPost.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewPost.layer.shadowRadius = 2.0
        viewPost.layer.shadowOpacity = 0.9
        
        let lblTitle = UILabel()
        lblTitle.text = postData["title"].string
        let lblContent = UILabel()
        lblContent.isHidden = postData["content"].string == nil
        lblContent.text = postData["content"].string
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
        scvTag.addSubview(svTag)
        scvTag.addConstraint(NSLayoutConstraint(item: svTag, attribute: .centerY, relatedBy: .equal, toItem: scvTag, attribute: .centerY, multiplier: 1, constant: 0))
        svTag.heightAnchor.constraint(equalTo: scvTag.heightAnchor, multiplier: 0.9).isActive = true
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
        
        let btnLike = FlatButton(title: String(postData["favorCount"].int!))
//        let btnLike = FlatButton(title: "999")
        btnLike.setImage(UIImage(named: "LikeOffBtn"), for: .normal)
        btnLike.layer.cornerRadius = 5
//        btnLike.contentEdgeInsets.left = btnMargin
//        btnLike.contentEdgeInsets.right = btnMargin
        btnLike.titleColor = .lightGray
        let btnComment = UIButton(type: .custom)
        btnComment.isEnabled = false
        btnComment.setTitle(String(postData["replyCount"].int!), for: .normal)
        btnComment.setImage(UIImage(named: "CommentIcon"), for: .normal)
        btnComment.tintColor = .darkGray
        btnComment.contentEdgeInsets.left = btnMargin
        btnComment.contentEdgeInsets.right = btnMargin
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
        
        viewPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoPost)))
        
        return viewPost
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
        
        let uvSearch = UIView()
        uvSearch.layer.cornerRadius = 15
        uvSearch.backgroundColor = .lightGray
        
        let imgSearch = UIImageView(image: Icon.cm.search)
        let tfSearch = UITextField()
        
        let svSearch = UIStackView(arrangedSubviews: [imgSearch,tfSearch])
        svSearch.axis = .horizontal
        svSearch.spacing = 5
        
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
        self.navigationItem.hidesBackButton = false
//        self.navigationItem.rightBarButtonItems?.remove(at: 1)
        
        self.navigationItem.titleView?.isHidden = true
//        let goToVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "postFilterView")
//        self.present(goToVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func requestPost(){
        let url = developIP + "/board/selectBoardListInfo.do"
        let jsonHeader = JSON(["userSn":"U200207_1581067560549"])
        let parameter = JSON([
            "category": String(segueTitle+1),
                "filterInfo": "1m",
                "sortInfo": "viewCnt",
                "offset": 0,
                "limit": 20
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["userSn":"U200207_1581067560549"]
        
        print(convertedHeaderString)
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                self.reponseJSON = JSON(response.value!)
                print("##")
                print(self.reponseJSON)
                print("##")
                self.setUI()
            }
        }
    }
}

extension PostListViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        lblBannerIndex.text = setSideSpace("\(page+1)/\(localSource.count)")
//        print("current page:", page)
    }
}


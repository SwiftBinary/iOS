//
//  SearchViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/11.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import XLPagerTabStrip
import MaterialDesignWidgets

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var uiSearchBar: UISearchBar!
    @IBOutlet var svHashTag: UIStackView!
    @IBOutlet var uvTapView: UIView!
    
    @IBOutlet var indicLoading: UIActivityIndicatorView!
    
    var resultSearchView: SearchResultViewController?
    
    // Post Filter Value
    var periodValue = "all"
    var sortingValue = "registerDt"
    
    // Location Filter Value
    var selectedValue = "DISTANCE_ASC"
    var priceValue: Int = 70000
    var timeValue: Int = 180
    var distanceValue: Float = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        hideKeyboard()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        uiSearchBar.text = selectedTag
        print(selectedTag)
        selectedTag = ""
        if
            uiSearchBar.text != "" {
            searchBarSearchButtonClicked(uiSearchBar)
        }
    }
    
    func setUI() {
        indicLoading.center = view.center
        getHashTag(svHashTag)
        svHashTag.translatesAutoresizingMaskIntoConstraints = false
        uiSearchBar.delegate = self
    }
    func getHashTag(_ svTag: UIStackView){
        let url = OperationIP + "/tag/selectHashTagList.do"
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn
            ,"deviceOS":"IOS"]
        AF.request(url,method: .post,headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                self.setHashTag(svTag,JSON(response.value!).arrayValue)
            }
        }
    }
    func setHashTag(_ svTag:UIStackView, _ listTag: [JSON]){
        for hashTag in listTag {
            let btnHashTag = UIButton(type: .system)
            btnHashTag.setTitle(setHashTagString(hashTag["tag"].stringValue))
            btnHashTag.layer.cornerRadius = 15
            btnHashTag.layer.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            btnHashTag.tintColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
            btnHashTag.addTarget(self, action: #selector(searchByTag(_:)), for: .touchUpInside)
            svTag.addArrangedSubview(btnHashTag)
        }
    }
    @objc func searchByTag(_ sender: UIButton){
        let strTag = sender.titleLabel!.text!.trimmingCharacters(in: ["#"," "])
        uiSearchBar.text = strTag
        searchBarSearchButtonClicked(uiSearchBar)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //        print((((uvTapView.subviews.first!.subviews.last! as! XLPagerTabStrip.ButtonBarView).dataSource as! SearchResultViewController).viewControllers))
//        print(resultSearchView?.viewControllers)
//        print(resultSearchView!.currentIndex)
        view.endEditing(true)
        resultSearchView!.currentIndex == 0 ? searchStoreInfo(searchBar) : searchPostInfo(searchBar)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSearchView" {
            let connectContainerViewController = segue.destination as! SearchResultViewController
            resultSearchView = connectContainerViewController
        }
    }
    
    func searchStoreInfo(_ searchBar: UISearchBar) {
        let searchLocationView = (self.resultSearchView?.viewControllers[0] as! SearchLocationViewController)
        indicLoading.startAnimating()
        searchLocationView.lblGuide.isHidden = true
        searchLocationView.uvStoreList.isHidden = true
        searchLocationView.searchStoreInfo(searchKeyWord: searchBar.text!, distanceLimit: distanceValue, priceLimit: priceValue, tmCostLimit: timeValue, sortedBy: selectedValue, offset:0)
    }
    func searchPostInfo(_ searchBar: UISearchBar) {
        indicLoading.startAnimating()
        
        let selectedBoard = (resultSearchView?.viewControllers.last as! SearchPostViewController).segmentControl.selectedSegmentIndex
        let requeatURL = (selectedBoard == 0) ? "/board/selectBoardSearchListInfo.do" : "/review/selectReviewSearchListInfo.do"
        
//        print(selectedBoard)
//        print(requeatURL)
        
        let url = OperationIP + requeatURL
        let httpHeaders: HTTPHeaders = ["userSn":userDTO.userSn]
        let parameter = JSON([
            "category":7,
            "searchKeyword":searchBar.text!,
            "filterInfo":periodValue,
            "sortInfo":sortingValue,
            "offset":0,
            "limit":20
        ])
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            if response.value != nil {
                let responseJSON = JSON(response.value!)
//                print(responseJSON)
                print("########################################")
                (self.resultSearchView?.viewControllers.last as! SearchPostViewController).searchData = responseJSON
                (self.resultSearchView?.viewControllers.last as! SearchPostViewController).setPostList()
//                (self.resultSearchView?.viewControllers.last as! SearchPostViewController)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    
}

//[<UIScrollView: 0x7f9908093200;
//    frame = (0 44; 414 629);
//    clipsToBounds = YES;
//    autoresize = W+H;
//    gestureRecognizers = <NSArray: 0x6000022d6610>;
//    layer = <CALayer: 0x600002cad980>;
//    contentOffset: {0, 0};
//    contentSize: {828, 0};
//    adjustedContentInset: {0, 0, 0, 0}>,
//
//    <XLPagerTabStrip.ButtonBarView: 0x7f9908113200; baseClass = UICollectionView;
//    frame = (0 0; 414 44);
//    clipsToBounds = YES;
//    autoresize = W;
//    gestureRecognizers = <NSArray: 0x6000022e41b0>;
//    layer = <CALayer: 0x600002cc3ac0>;
//    contentOffset: {0, 0};
//    contentSize: {414, 44};
//    adjustedContentInset: {0, 0, 0, 0};
//    layout: <UICollectionViewFlowLayout: 0x7f9907c72560>;
//    dataSource: <PerfectDay_iOS.SearchResultViewController: 0x7f9908027200>>]

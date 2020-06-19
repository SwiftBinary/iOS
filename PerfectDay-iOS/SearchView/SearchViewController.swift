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

class SearchViewController: UIViewController{//}, UISearchBarDelegate {
    
    @IBOutlet var uiSearchBar: UISearchBar!
    @IBOutlet var svHashTag: UIStackView!
    @IBOutlet var uvTapView: UIView!
    
    let userData = getUserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setUI()
    }
    func setUI() {
        getHashTag(svHashTag)
        svHashTag.translatesAutoresizingMaskIntoConstraints = false
//        uiSearchBar.delegate = self
    }
    func getHashTag(_ svTag: UIStackView){
        let url = OperationIP + "/tag/selectHashTagList.do"
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
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
            svTag.addArrangedSubview(btnHashTag)
        }
    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
////        print(uvTapView.subviews.first!.subviews.last!.subviews)
//
//        let url = OperationIP + "/store/selectSearchStoreInfoList.do"
//        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
//        let parameter = JSON([
//            "distanceLimit": 3,
//            "latitude": 37.68915657,
//            "longitude": 127.04546691,
//            "limit": 20,
//            "offset": 0,
//            "priceLimit": 70000,
//            "searchKeyWord": searchBar.text!,
//            "sortedBy": "DISTANCE_ASC",
//            "tmCostLimit": 180
//        ])
//        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
//        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
//            if response.value != nil {
//                let responseJSON = JSON(response.value!)
////                print(responseJSON)
//            }
//        }
//    }
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

//
//  ShowPostViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/24.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ShowPostViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
        requestPost()
    }
    
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        let navigationVCList = self.navigationController!.viewControllers
        let navigationTitle = navigationVCList[1].navigationItem.title
        self.navigationItem.title = navigationTitle
    }
    func requestPost(){
        let url = developIP + "/board/selectBoardListInfo.do"
        let jsonHeader = JSON(["userSn":"U200207_1581067560549"])
        let parameter = JSON([
                "category": 4,
                "filterInfo": "1m",
                "sortInfo": "viewCnt",
                "offset": 0,
                "limit": 20
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let convertedHeaderString = jsonHeader.rawString()!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let httpHeaders: HTTPHeaders = ["json":convertedHeaderString]
        
        print(convertedHeaderString)
        print(convertedParameterString)
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                let reponseJSON = JSON(response.value!)
            }
        }
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

//
//  AcceptContentViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/26.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class AcceptContentViewController: UIViewController {

    @IBOutlet var tvContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tvContent.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tvContent.layer.borderWidth = 0.5
        tvContent.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tvContent.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let data = ContentData.sharedData.LocationContent
        tvContent.text = data
    }
    
    @IBAction func gotoBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

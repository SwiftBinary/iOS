//
//  LocationResultViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/07.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class LocationResultViewController: UIViewController {

    @IBOutlet var scrollResultList: UIScrollView!
    @IBOutlet var tfKeyword: UITextField!
    @IBOutlet var svResultList: UIStackView!
    @IBOutlet var lblGuide: UILabel!
    
    let count = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        if count != 0 {
            tempFunc(n: count)
        }
        setUI()
    }
    
    func tempFunc(n: Int){
        lblGuide.isHidden = true
        for i in 0...n {
            let tempBtn = UIButton(type: .system)
            tempBtn.setTitle("Button"+String(i), for: .normal)
            tempBtn.tintColor = .darkGray
            setSNSButton(tempBtn, "")
            tempBtn.addTarget(self, action: #selector(tempUpEvent), for: .touchUpInside)
            tempBtn.addTarget(self, action: #selector(tempDownEvent), for: .touchDown)
            svResultList.addArrangedSubview(tempBtn)
        }
        //print(svResultList.arrangedSubviews)
        svResultList.spacing = 8
        svResultList.translatesAutoresizingMaskIntoConstraints = false
    }

    func setUI() {
        self.navigationItem.backBarButtonItem?.titleTextAttributes(for: .disabled)
        setField(tfKeyword, "ex) 건대입구 또는 홍대입구")
    }
    
    @objc func tempUpEvent(sender: UIButton) {
        print(sender.titleLabel!.text!)
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "setLocationView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    @objc func tempDownEvent(sender: UIButton) {
        //sender.setTitleColor(.lightGray, for: .normal)
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

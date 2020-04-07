//
//  FilterPostViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit

class FilterPostViewController: UIViewController {
       //Button
    @IBOutlet var btnAll: UIButton!
    @IBOutlet var btnOneWeek: UIButton!
    @IBOutlet var btnOneMonth: UIButton!
    @IBOutlet var btnThreeMonths: UIButton!
    @IBOutlet var btnSixMonths: UIButton!

    var listBtn: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBtn()
    }

    func setBtn(){
        listBtn = [btnAll,btnOneWeek,btnOneMonth,btnThreeMonths,btnSixMonths]
        for btn in listBtn {
            btn.layer.cornerRadius = 5
            btn.layer.borderColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
            btn.layer.borderWidth = 0.5
        }
    }
    
    @IBAction func gotoBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setOption(_ sender: UIButton) {
    }
    @IBAction func allClear(_ sender: UIBarButtonItem) {
        
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

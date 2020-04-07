//
//  FilterLocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/17.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MultiSlider

class FilterLocationViewController: UIViewController {

    // Slider
    @IBOutlet var slPrice: MultiSlider!
    @IBOutlet var slTime: MultiSlider!
    @IBOutlet var slDistance: MultiSlider!
    
    //Button
    @IBOutlet var btnDistance: UIButton!
    @IBOutlet var btnGPA: UIButton!
    @IBOutlet var btnTimeLong: UIButton!
    @IBOutlet var btnTimeShort: UIButton!
    @IBOutlet var btnPriceHigh: UIButton!
    @IBOutlet var btnPriceLow: UIButton!

    var listBtn: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBtn()
    }
    
    func setUI(){
        slPrice.valueLabelPosition = .top
        slTime.valueLabelPosition = .top
        slDistance.valueLabelPosition = .top
    }
    func setBtn(){
        listBtn = [btnDistance,btnGPA,btnTimeLong,btnTimeShort,btnPriceHigh,btnPriceLow]
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

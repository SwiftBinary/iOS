//
//  FilterLocationViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/17.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class FilterLocationViewController: UIViewController {
    
    //Button
    @IBOutlet var btnDistance: MaterialButton!
    @IBOutlet var btnGPA: MaterialButton!
    @IBOutlet var btnTimeLong: MaterialButton!
    @IBOutlet var btnTimeShort: MaterialButton!
    @IBOutlet var btnPriceHigh: MaterialButton!
    @IBOutlet var btnPriceLow: MaterialButton!
    var selectBtn = 0
    
    var listBtn: [MaterialButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBtn()
    }
    
    func setUI(){
        
    }
    func setBtn(){
        listBtn = [btnDistance,btnGPA,btnTimeLong,btnTimeShort,btnPriceHigh,btnPriceLow]
        for btn in listBtn {
            btn.setTextStyles(textColor: .black, font: .systemFont(ofSize: 17))
            btn.cornerRadius = 5
            btn.backgroundColor = .white
            btn.layer.borderColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
            btn.layer.borderWidth = 0.5
            btn.rippleEnabled = false
            btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        }
        listBtn[0].setTextStyles(textColor: .white, font: .none)
        listBtn[0].backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
    }
    
    @objc func btnAction(_ sender: MaterialButton) {
        let index = listBtn.firstIndex(of: sender)!
        if selectBtn != index {
            print(index)
            listBtn[selectBtn].setTextStyles(textColor: .black, font: .none)
            listBtn[selectBtn].backgroundColor = .white
        }
        selectBtn = index
        sender.setTextStyles(textColor: .white, font: .none)
        sender.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
    }
    
    
    @IBAction func gotoBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setOption(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allClear(_ sender: UIBarButtonItem) {
        listBtn[selectBtn].setTextStyles(textColor: .black, font: .none)
        listBtn[selectBtn].backgroundColor = .white
        listBtn[0].setTextStyles(textColor: .white, font: .none)
        listBtn[0].backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        selectBtn = 0
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

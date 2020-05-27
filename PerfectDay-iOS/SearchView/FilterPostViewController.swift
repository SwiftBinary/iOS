//
//  FilterPostViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/10.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class FilterPostViewController: UIViewController {
    //Button Period
    @IBOutlet var btnAll: MaterialButton!
    @IBOutlet var btnOneWeek: MaterialButton!
    @IBOutlet var btnOneMonth: MaterialButton!
    @IBOutlet var btnThreeMonths: MaterialButton!
    @IBOutlet var btnSixMonths: MaterialButton!
    
    //Button Sorting
    @IBOutlet var btnLatest: MaterialButton!
    @IBOutlet var btnView: MaterialButton!
    @IBOutlet var btnComment: MaterialButton!
    @IBOutlet var btnLike: MaterialButton!
    
    var listBtnPeriod: [MaterialButton] = []
    var listBtnSorting: [MaterialButton] = []
    var selectedPeriod = 0
    var selectedSorting = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        listBtnPeriod = [btnAll,btnOneWeek,btnOneMonth,btnThreeMonths,btnSixMonths]
        listBtnSorting = [btnLatest,btnView,btnComment,btnLike]
        setBtn(listBtnPeriod)
        setBtn(listBtnSorting)
    }
    
    func setBtn(_ listBtn : [MaterialButton]){
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
        let isPeriod = listBtnPeriod.contains(sender)
        let index = isPeriod ? listBtnPeriod.firstIndex(of: sender)! : listBtnSorting.firstIndex(of: sender)!
        if (isPeriod ? selectedPeriod : selectedSorting) != index {
            (isPeriod ? listBtnPeriod : listBtnSorting)[(isPeriod ? selectedPeriod : selectedSorting)].setTextStyles(textColor: .black, font: .none)
            (isPeriod ? listBtnPeriod : listBtnSorting)[(isPeriod ? selectedPeriod : selectedSorting)].backgroundColor = .white
        }
        if isPeriod { selectedPeriod = index
        } else { selectedSorting = index }
        sender.setTextStyles(textColor: .white, font: .none)
        sender.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
//        print(selectedPeriod, selectedSorting)
    }
    
    @IBAction func gotoBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setOption(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func allClear(_ sender: UIBarButtonItem) {
        listBtnPeriod[selectedPeriod].setTextStyles(textColor: .black, font: .none)
        listBtnPeriod[selectedPeriod].backgroundColor = .white
        listBtnSorting[selectedSorting].setTextStyles(textColor: .black, font: .none)
        listBtnSorting[selectedSorting].backgroundColor = .white
        
        listBtnPeriod[0].setTextStyles(textColor: .white, font: .none)
        listBtnPeriod[0].backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        listBtnSorting[0].setTextStyles(textColor: .white, font: .none)
        listBtnSorting[0].backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        selectedPeriod = 0
        selectedSorting = 0
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

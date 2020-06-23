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
    
    @IBOutlet var nvbFilter: UINavigationBar!
    @IBOutlet var bbtnResetFilter: UIBarButtonItem!
    
    //Label
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblDistance: UILabel!
    
    //Slider
    @IBOutlet var slPrice: UISlider!
    @IBOutlet var slTime: UISlider!
    @IBOutlet var slDistance: UISlider!
    
    
    //Button
    @IBOutlet var btnDistance: MaterialButton!
    @IBOutlet var btnGPA: MaterialButton!
    @IBOutlet var btnTimeLong: MaterialButton!
    @IBOutlet var btnTimeShort: MaterialButton!
    @IBOutlet var btnPriceHigh: MaterialButton!
    @IBOutlet var btnPriceLow: MaterialButton!
    
    let listFilterValue = ["DISTANCE_ASC","SCORE_DESC","TIME_DESC","TIME_ASC","PRICE_DESC","PRICE_ASC"]
    
    var selectedIndex = 0
//    var selectedValue = "DISTANCE_ASC"
    var priceValue: Int = 0
    var timeValue: Int = 0
    var distanceValue: Float = 0.0
    
    var listBtn: [MaterialButton] = []
    let step: Float = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBtn()
    }
    
    func setUI(){
        slPrice.value = Float(priceValue) / 1000
        slTime.value = Float(timeValue) / 10
        slDistance.value = distanceValue * 10
        
        lblPrice.text = getText(slPrice,"Price")
        lblTime.text = getText(slTime,"Time")
        lblDistance.text = getText(slDistance,"Distance")
        
        nvbFilter.barStyle = .default
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
        listBtn[selectedIndex].setTextStyles(textColor: .white, font: .none)
        listBtn[selectedIndex].backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
    }
    
    @objc func btnAction(_ sender: MaterialButton) {
        let index = listBtn.firstIndex(of: sender)!
        if selectedIndex != index {
//            selectedValue = listFilterValue[index]
//            print(selectedValue)
            listBtn[selectedIndex].setTextStyles(textColor: .black, font: .none)
            listBtn[selectedIndex].backgroundColor = .white
        }
        selectedIndex = index
        sender.setTextStyles(textColor: .white, font: .none)
        sender.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
    }
    
    
    @IBAction func gotoBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setOption(_ sender: UIButton) {
                print(priceValue)
                print(timeValue)
                print(distanceValue)
                print(listFilterValue[selectedIndex])
        let searchView = (self.presentingViewController?.children[1] as! UINavigationController).viewControllers.first as! SearchViewController
        searchView.priceValue = priceValue
        searchView.timeValue = timeValue
        searchView.distanceValue = distanceValue
        searchView.selectedValue = listFilterValue[selectedIndex]
        
        //        print(self.presentedViewController)
        //        print(self.view.parent)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allClear(_ sender: UIBarButtonItem) {
        priceValue = 70
        timeValue = 180
        distanceValue = 30
        
        slPrice.value = Float(priceValue)
        slTime.value = Float(timeValue)
        slDistance.value = distanceValue
        
        lblPrice.text = getText(slPrice,"Price")
        lblTime.text = getText(slTime,"Time")
        lblDistance.text = getText(slDistance,"Distance")
        
        listBtn[selectedIndex].setTextStyles(textColor: .black, font: .none)
        listBtn[selectedIndex].backgroundColor = .white
        listBtn.first!.setTextStyles(textColor: .white, font: .none)
        listBtn.first!.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        selectedIndex = 0
    }
    
    @IBAction func setSliderPrice(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        lblPrice.text = getText(sender,"Price")
        priceValue = Int(sender.value) * 1000
    }
    @IBAction func setSliderTime(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        lblTime.text = getText(sender,"Time")
        timeValue = Int(sender.value) * 10
    }
    @IBAction func setSliderDistance(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        lblDistance.text = getText(sender,"Distance")
        distanceValue = sender.value/10
    }
    
    func getText(_ slider:UISlider,_ value: String) -> String {
        var lblValue = ""
        var lblUnit = ""
        switch value {
        case "Price":
            switch slider.value {
            case 0:
                lblValue = "0"
                lblUnit = "원"
            case 1..<10:
                lblValue = String(Int(slider.value))
                lblUnit = "천원"
            default:
                lblValue = (Int(slider.value) % 10 == 0 ? String(Int(slider.value/10)) : String(slider.value/10))
                lblUnit = (slider.value == slider.maximumValue ? "만원+" : "만원")
            }
        case "Time":
            lblValue = slider.value == 0 ? "0시간" : RegexTime(Int(slider.value * 10))
            lblUnit = (slider.value == slider.maximumValue ? "+" : "")
        case "Distance":
            lblValue = (Int(slider.value) % 10 == 0 ? String(Int(slider.value/10)) : String(slider.value/10))
            lblUnit = (slider.value == slider.maximumValue ? "km+" : "km")
        default:
            break
        }
        
        return lblValue + lblUnit
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

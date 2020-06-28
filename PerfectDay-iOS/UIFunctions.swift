//
//  UIFunctions.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/04/03.
//  Copyright © 2020 문종식. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public func makeUILabel(_ text: String) -> UILabel {
    let uiLabel = UILabel()
    uiLabel.textColor = .darkText
    uiLabel.text = text
    return uiLabel
}

public func makeUITextField(_ placeholder: String) -> UITextField {
    let uiTextField = UITextField()
    uiTextField.placeholder = placeholder
    uiTextField.textColor = .black
    
    uiTextField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    uiTextField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    uiTextField.layer.borderWidth = 1.0
    uiTextField.layer.cornerRadius = 5
    uiTextField.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
    return uiTextField
}

public func countLabelLines(label: UILabel!) -> Int {
    // Call self.layoutIfNeeded() if your view uses auto layout
    let myText = label.text! as NSString
    
    let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
    let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)
    
    return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
}

public func setHashTagString(_ str: String) -> String{
    let setStr = "  #" + str + "  "
    return setStr
}

public func DecimalWon(_ value: Int) -> String{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let result = numberFormatter.string(from: NSNumber(value: value))! + "원"
    return result
}

public func RegexTime(_ value: Int) -> String{
    var result = ""
    let Hour = String(value / 60)
    let Minute = String(value % 60)
    
    if Hour != "0" {
        result += (Hour + "시간")
    }
    if Minute != "0" {
        result += (Minute + "분")
    }
    return result
}

public func setShadowCard(_ item: UIView, bgColor: UIColor, crRadius:CGFloat, shColor: UIColor, shOffsetW: CGFloat ,shOffsetH: CGFloat, shRadius: CGFloat, sdOpacity: Float){
    item.backgroundColor = bgColor
    item.layer.cornerRadius = crRadius
    item.layer.shadowColor = shColor.cgColor
    item.layer.shadowOffset = CGSize(width: shOffsetW, height: shOffsetH)
    item.layer.shadowRadius = shRadius
    item.layer.shadowOpacity = sdOpacity
}

public func getUserData() -> Dictionary<String,Any> {
    let data = UserDefaults.standard.dictionary(forKey: userDataKey)
    if data == nil {
        return ["":""]
    } else {
        return data!
    }
}

//public func getLocationData() -> JSON {
//    let data = UserDefaults.standard.dictionary(forKey: locationDataKey)
//    var dataJSON = JSON()
//    if data == nil {
//        return dataJSON
//    } else {
//        dataJSON = JSON(data!)
//        return dataJSON
//    }
//}

public func getString(_ data: Any?) -> String {
    return data as! String
}

public func getImageURL(_ locationSn:String,_ imageSn: String, tag: String) -> String{
    var URL = locationSn + "/" + imageSn
    
    switch tag {
    case "landmark":
        URL = LandmarkImageURL + URL
    case "store":
        URL = StoreImageURL + URL
    default:
        print("")
    }
    return URL
}

public func setPref(_ label : UILabel,_ PrefSn : String,_ prefData : String){
    switch PrefSn {
    case "10000000":
        setprefData(eat,label,prefData)
        break
    case "01000000":
        setprefData(drink,label,prefData)
        break
    case "00100000":
        setprefData(play,label,prefData)
        break
    case "00010000":
        setprefData(see,label,prefData)
        break
    case "00001000":
        setprefData(walk,label,prefData)
        break
    default :
        setprefData(ect,label,prefData)
        break
    }
}
public func setprefData(_ data : Array<String>,_ label : UILabel,_ prefInt : String){
    var text : String = ""
    var num = 1000000000
    var dataNum = Int(prefInt)
    for i in 0...9{
        if dataNum! / num > 0 {
            switch dataNum! / num {
            case 1, 2:
                if text == "" { text = data[i] }
                else { text = text + " " + data[i] }
                break
            default:
                if text == "" { text = "기타"}
                break
            }
            dataNum = dataNum! % num
        }
        num /= 10
    }
    label.text = text
}

public func setSequenceColor(_ PrefSn : String,_ btnColor : UIButton){
    switch PrefSn {
    case "10000000":
        btnColor.layer.backgroundColor = #colorLiteral(red: 1, green: 0.2955724597, blue: 0.5731969476, alpha: 1)
        break
    case "01000000":
        btnColor.layer.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        break
    case "00100000":
        btnColor.layer.backgroundColor = #colorLiteral(red: 1, green: 0.6745098039, blue: 0.02352941176, alpha: 1)
        break
    case "00010000":
        btnColor.layer.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.3215686275, blue: 0.7803921569, alpha: 1)
        break
    case "00001000":
        btnColor.layer.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.7803921569, blue: 0.6901960784, alpha: 1)
        break
    default :
        btnColor.layer.backgroundColor = #colorLiteral(red: 1, green: 0.2955724597, blue: 0.5731969476, alpha: 1)
        break
    }
}


extension UITextView
{
    
}


// UIViewController 확장
extension UIViewController
{

    //화면터치로 키보드 내리는 함수
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        view.removeGestureRecognizer(view.gestureRecognizers!.last!)
    }

    
    // 로그인 화면 SNS 로그인 버튼 속성 지정
    // 버튼에 넣을 이미지명과 문구를 받음
    func setSNSButton(_ btn: UIButton, _ str: String){
        btn.layer.borderWidth = 1 // 테두리 두께
        btn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) // 테두리 색상
        btn.layer.cornerRadius = 5 // 모서리 곡률
        btn.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // 배경색
        btn.setTitleColor(.darkGray, for: .normal) // 텍스트 색
        let miniLogo = UIImage(named: str)
        btn.setImage(miniLogo, for: .normal)
        //btn.imageView?.image?.withRenderingMode(.alwaysOriginal)
    }
    
    func setField(_ field: UITextField, _ str: String){
        field.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = 5
        field.backgroundColor = .white
        field.attributedPlaceholder = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
    }
    
    func setViewBorder(_ view:UIView){
        view.layer.borderWidth = 0.5
        view.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.cornerRadius = 5
    }
    
    public func alertControllerDefault(title: String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acceptAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default , handler: nil)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion:{})
    }
}

extension UIScrollView {
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            let bottomOffset = scrollBottomOffset()
            if (childStartPoint.y > bottomOffset.y) {
                setContentOffset(bottomOffset, animated: true)
            } else {
                setContentOffset(CGPoint(x: 0, y: childStartPoint.y), animated: true)
            }
        }
    }
    // Bonus: Scroll to top
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: true)
    }
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = scrollBottomOffset()
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    private func scrollBottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}

extension UIImageView {
    func getPixelColorAt(point:CGPoint) -> UIColor{
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        layer.render(in: context!)
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0)
//        pixel.deallocate(capacity: 4)
        pixel.deallocate()
        return color
    }
}

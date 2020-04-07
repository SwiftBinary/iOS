//
//  UIFunctions.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/04/03.
//  Copyright © 2020 문종식. All rights reserved.
//

import Foundation
import UIKit

public func makeUILabel(_ text: String) -> UILabel {
    let uiLabel = UILabel()
    uiLabel.text = text
    return uiLabel
}

public func makeUITextField(_ placeholder: String) -> UITextField {
    let uiTextField = UITextField()
    uiTextField.placeholder = " " + placeholder
    uiTextField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    uiTextField.layer.borderWidth = 1.0
    uiTextField.layer.cornerRadius = 5
    uiTextField.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
    return uiTextField
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
        field.attributedPlaceholder = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
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

//
//  WritePostViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/22.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

class WritePostViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tvContentView: UIView!
    
    @IBOutlet var tfHashTag: UITextField! //
    
    var naviTitle: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "게시글 작성하기"
        self.tabBarController?.tabBar.isHidden = true
        setUI()
    }
    
    func setUI(){
        tfTitle.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        tfTitle.delegate = self
        
        let content = RSKPlaceholderTextView(frame: CGRect(x: (self.view.frame.width*0.04), y: 0, width: self.view.frame.width*0.96, height: tvContentView.frame.height*0.9))
        content.placeholder = "내용을 입력하세요. (최대 1000자 까지 입력 가능)"
        tvContentView.addSubview(content)
    }
    
    @IBAction func gotoBack(_ sender: UIBarButtonItem) {
        let alertMessage = "정말 게시글 작성을 취소하시겠습니까?\n해당 페이지를 벗어나면\n게시글 작성 상황은 저장되지 않습니다."
        let alertController = UIAlertController(title: "작성 취소", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let selectAction = UIAlertAction(title: "예", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func tfFocusing(_ sender: UITextField) {
        tfHashTag.becomeFirstResponder()
    }
    
    @IBAction func checkEdit(_ sender: UITextField) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
            return false
        }
        let substringToReplace = textView.text[rangeOfTextToReplace]
        let count = textView.text.count - substringToReplace.count + text.count
        return count <= 20
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

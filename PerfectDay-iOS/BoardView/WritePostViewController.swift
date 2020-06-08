//
//  WritePostViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/02/22.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MobileCoreServices
import RSKPlaceholderTextView
import Material

class WritePostViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {
    
    
    let developIP = "http://203.252.161.96:8080"
    let OperationIP = "http://203.252.161.219:8080"
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    let userData = getUserData()
    
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tvContentView: UIView!
    
    @IBOutlet var tfHashTag: UITextField! //
    
    var naviTitle: String = ""
    @IBOutlet var imgView: UIImageView!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    @IBOutlet var svUploadImage: UIStackView!
    @IBOutlet var svUploadImage2: UIStackView!
    
    @IBOutlet var bbtnBack: UIBarButtonItem!
    
    var isUpdatePost = false
    var categorySn: Int = 0
    var uploadPost = false
    var reponseJSON: JSON = []
    @IBOutlet var btnUploadPost: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategorySn()
        setUI()
    }
    
    func getCategorySn(){
        var navigationVCList = self.navigationController!.viewControllers
        navigationVCList = navigationVCList.reversed()
        if type(of: navigationVCList[1]) == PostListViewController.self {
            categorySn = (navigationVCList[1] as! PostListViewController).segueTitle + 1
        } else {
            self.reponseJSON = (navigationVCList[1] as! ShowPostViewController).reponseJSON
            categorySn = reponseJSON["category"].intValue
            isUpdatePost = true
        }
    }
    
    func setUI(){
        self.navigationItem.title = "게시글 작성하기"
        self.navigationItem.titleLabel.textColor = .black
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
        
        bbtnBack.image = Icon.close
        
        tfTitle.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        tfTitle.delegate = self
        
        let content = RSKPlaceholderTextView(frame: CGRect(x: (self.view.frame.width*0.04), y: 0, width: self.view.frame.width*0.96, height: tvContentView.frame.height*0.9))
        content.placeholder = "내용을 입력하세요. (최대 1000자 까지 입력 가능)"
        content.delegate = self
        tvContentView.addSubview(content)
        
        print(isUpdatePost)
        if isUpdatePost {
            btnUploadPost.setTitle("게시글 수정하기", for: .normal)
            tfTitle.text = reponseJSON["title"].stringValue
            content.text = reponseJSON["content"].stringValue
            tfHashTag.text = reponseJSON["hashTag"].stringValue
        }
        
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
        checkEditText()
    }
    func textViewDidChange(_ textView: UITextView) {
        checkEditText()
    }
    func checkEditText() {
        if !(tfTitle.text!.isEmpty || (tvContentView.subviews[0] as! RSKPlaceholderTextView).isEmpty) {
            btnUploadPost.isEnabled = true
            btnUploadPost.backgroundColor = themeColor
        } else {
            btnUploadPost.isEnabled = false
            btnUploadPost.backgroundColor = .lightGray
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            //            UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            imgView.image = captureImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func loadImage(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            alertControllerDefault(title: "업로드 실패", message: "앨범에 접근할 수 없습니다.\n권한을 확인해주세요.")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
            return false
        }
        let substringToReplace = textView.text[rangeOfTextToReplace]
        let count = textView.text.count - substringToReplace.count + text.count
        return count <= 20
    }
    
    @IBAction func uploadPost(_ sender: UIButton) {
        let alertController = UIAlertController(title: isUpdatePost ? "게시글 수정":"게시글 업로드", message: isUpdatePost ? "게시글을 수정하시겠습니까?":"게시글을 업로드 하시겠습니까?", preferredStyle: UIAlertController.Style.actionSheet)
        
        if isUpdatePost{
            let uploadPostAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.requestUpdatePost()
            })
            alertController.addAction(uploadPostAction)
        } else {
            let uploadPostAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.requestUploadPost()
            })
            alertController.addAction(uploadPostAction)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func requestUpdatePost(){
        let postTitle = tfTitle.text!
        let postContent = (tvContentView.subviews[0] as! RSKPlaceholderTextView).text!
        let postHashTag = (tfHashTag.text!.isEmpty) ? " " : tfHashTag.text!
        let url = OperationIP + "/board/updateBoardInfo.do"
        let parameter = JSON([
            "boardSn": reponseJSON["boardSn"].stringValue,
            "category": categorySn,
            "title": postTitle,
            "content": postContent,
            "hashTag": postHashTag,
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")//.replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
//                let reponseJSON = JSON(response.value!)
//                print(reponseJSON)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func requestUploadPost(){
        let postTitle = tfTitle.text!
        let postContent = (tvContentView.subviews[0] as! RSKPlaceholderTextView).text!
        let postHashTag = (tfHashTag.text!.isEmpty) ? " " : tfHashTag.text!
        let url = OperationIP + "/board/insertBoardInfo.do"
        let parameter = JSON([
            //                "boardSn": "1",
            "category": categorySn,
            "title": postTitle,
            "content": postContent,
            "hashTag": postHashTag,
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")//.replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"])]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
//                let reponseJSON = JSON(response.value!)
//                print(reponseJSON)
            }
            self.navigationController?.popViewController(animated: true)
        }
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

//
//  WriteReviewViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/11.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MobileCoreServices
import RSKPlaceholderTextView
import Material

class WriteReviewViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var uvBack: UIView!
    @IBOutlet var tfShortReview: UITextField!
    @IBOutlet var tvContentView: UIView!
    
    @IBOutlet var sliderScore: UISlider!
    
    @IBOutlet var tfHashTag: UITextField! //
    
    var naviTitle: String = ""
    @IBOutlet var imgView: UIImageView!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    @IBOutlet var svUploadImage: UIStackView!
    @IBOutlet var svUploadImage2: UIStackView!
    
    var isUpdatePost = false
    var uploadPost = false
    var responseJSON: JSON = []
    var storeSn = ""
    @IBOutlet var btnUploadPost: UIButton!

    
    @IBOutlet var lblGPAReview: UILabel!
    let startImageView = [UIImageView]()
    
    let strReivew = ["별로예요.",
                     "아쉬워요.",
                     "무난하네요.",
                     "좋아요! 마음에 듭니다.",
                     "마음에 쏙 들어요! 적극추천~"]
    
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    let userData = getUserData()
    
    var Score : Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getCategorySn()
        hideKeyboard()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        self.navigationItem.title = "후기 작성하기"
        self.navigationItem.titleLabel.textColor = .black

        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.action = #selector(gotoBack(_:))
        self.navigationItem.backBarButtonItem = backItem
        
        scrollView.bounces = false
        uvBack.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uvBack.layer.shadowColor = UIColor.lightGray.cgColor
        uvBack.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        uvBack.layer.shadowRadius = 2.0
        uvBack.layer.shadowOpacity = 0.5
        
        tfShortReview.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        tfShortReview.delegate = self
        
        let value = responseJSON["reviewScore"].intValue
        for index in 1 ... 5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if index <= value {
                    starImage.image = UIImage(named: "GPAIcon")
                }else{
                    starImage.image = UIImage(named: "GPAIconOff")
                }
            }
        }
        
        let content = RSKPlaceholderTextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: tvContentView.frame.height*0.9))
        content.placeholder = "내용을 입력하세요. (최대 1000자 까지 입력 가능)"
        content.delegate = self
        tvContentView.addSubview(content)
        
        print(isUpdatePost)
        if isUpdatePost {
            btnUploadPost.setTitle("게시글 수정하기", for: .normal)
            tfShortReview.text = responseJSON["title"].stringValue
            sliderScore.value = Float(responseJSON["reviewScore"].intValue)
            content.text = responseJSON["content"].stringValue
            tfHashTag.text = responseJSON["hashTag"].stringValue
        }
    }
    @objc func gotoBack(_ sender: UIBarButtonItem) {
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
    func setTextView(){
        let content = RSKPlaceholderTextView(frame: CGRect(x: 0, y: 0, width: tvContentView.frame.width, height: tvContentView.frame.height))
        content.placeholder = "자유롭게 좋았던 점과 불만스러웠던 점을 남겨주세요."
        tvContentView.addSubview(content)
        tvContentView.addConstraint(NSLayoutConstraint(item: content, attribute: .centerX, relatedBy: .equal, toItem: tvContentView, attribute: .centerX, multiplier: 1, constant: 0))
        tvContentView.addConstraint(NSLayoutConstraint(item: content, attribute: .centerY, relatedBy: .equal, toItem: tvContentView, attribute: .centerY, multiplier: 1, constant: 0))
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
        if !(tfShortReview.text!.isEmpty || (tvContentView.subviews[0] as! RSKPlaceholderTextView).isEmpty) {
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
        return count <= 1000
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
        let postTitle = tfShortReview.text!
        let postContent = (tvContentView.subviews[0] as! RSKPlaceholderTextView).text!
        let postHashTag = (tfHashTag.text!.isEmpty) ? " " : tfHashTag.text!
//        let postScore = Int(lblGPAReview.accessibilityValue!)
        let url = OperationIP + "/review/updateReviewInfo.do"
        let parameter = JSON([
            "boardSn": responseJSON["boardSn"].stringValue,
            "storeSn": storeSn,
            "category": 7,
            "title": postTitle,
            "content": postContent,
            "hashTag": postHashTag,
            "reviewScore" : Score
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")//.replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                //                let responseJSON = JSON(response.value!)
                //                print(responseJSON)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    func requestUploadPost(){
        let postTitle = tfShortReview.text!
        let postContent = (tvContentView.subviews[0] as! RSKPlaceholderTextView).text!
        let postHashTag = (tfHashTag.text!.isEmpty) ? " " : tfHashTag.text!
//        let postScore = Int(lblGPAReview.accessibilityValue!)
        let url = OperationIP + "/review/insertReviewInfo.do"
        let parameter = JSON([
            "storeSn": storeSn,
            "category": 7,
            "title": postTitle,
            "content": postContent,
            "hashTag": postHashTag,
            "reviewScore" : Score
        ])
        
        let convertedParameterString = parameter.rawString()!.replacingOccurrences(of: "\n", with: "")//.replacingOccurrences(of: " ", with: "")
        
        let httpHeaders: HTTPHeaders = ["userSn":getString(userData["userSn"]),"deviceOS":"IOS"]
        
        AF.request(url,method: .post, parameters: ["json":convertedParameterString], headers: httpHeaders).responseJSON { response in
            debugPrint(response)
            if response.value != nil {
                //                let responseJSON = JSON(response.value!)
                //                print(responseJSON)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    @IBAction func starPointChanged(_ sender: UISlider) {
        let roundValue = round(sender.value)
        for index in 1 ... 5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if index <= Int(roundValue) {
                    starImage.image = UIImage(named: "GPAIcon")
                }else{
                    starImage.image = UIImage(named: "GPAIconOff")
                }
            }
        }
        Score = Int(roundValue)
//        lblGPAReview.accessibilityValue = String(roundValue)
        lblGPAReview.text = strReivew[Int(roundValue) - 1]
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

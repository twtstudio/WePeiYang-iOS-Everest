//
//  FBNewQuestionController.swift
//  WePeiYang
//
//  Created by Zrzz on 2020/11/18.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import Alamofire

class FBNewQuestionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 标题
    var titleLabel: UILabel!
    var titleField: UITextField!
    // 校区
    var campusLabel: UILabel!
    var campusSelectionView: SelectionView!
    // 标签
    var tagLabel: UILabel!
    var tagSelectionView: SelectionView!
    var tagDesLabel: UILabel!
    // 问题描述
    var contentCountLabel: UILabel!
    var contentLabel: UILabel!
    var contentField: UITextView!
    // 插入图片
    var photoLabel: UILabel!
    var photoCollectionView: FBPhotoCollectionView!
    // 提交按钮
    var confirmButton: UIButton!
    
    // CONSTS
    let LABEL_FONT_SIZE: CGFloat = 16
    let LEFT_PADDING: CGFloat = SCREEN.width / 12
    
    // Data
    var availableTags: [FBTagModel] = [
        FBTagModel(id: 0, name: "后保部", children: nil),
        FBTagModel(id: 0, name: "后保部", children: nil),
        FBTagModel(id: 0, name: "后保部", children: nil),
        FBTagModel(id: 0, name: "后保部", children: nil),
    ]
    let campus: [String] = ["卫津路", "北洋园"]
    
    var selectedTag: Int = -1 // default no tag is selected
    var selectedCampus: Int = 0 // default 0 which means both campus
    
    var imageViews = [UIImageView]()
    var images = [UIImage]() {
        didSet {
            photoCollectionView.reload(images)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        addCallBack()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        confirmButton.addShadow(UIColor.feedBackBlue, sRadius: 2, sOpacity: 0.2, offset: (3, 3))
    }
}

//MARK: - UI
extension FBNewQuestionViewController {
    
    fileprivate func addSymmetryLine(x: CGFloat = SCREEN.width / 12, y: CGFloat, isDotted: Bool = false) {
        if isDotted {
            view.addDashLine(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), points: CGPoint(x: x, y: y), CGPoint(x: SCREEN.width - x, y: y))
        } else {
            view.addLine(color: #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1), points: CGPoint(x: x, y: y), CGPoint(x: SCREEN.width - x, y: y))
        }
    }
    
    fileprivate func setUp() {
        view.backgroundColor = .white
        
        addSymmetryLine(y: 15)
        
        titleField = UITextField()
        titleField.placeholder = "20字以内"
        titleField.delegate = self
        titleField.returnKeyType = .done
        titleField.font = .systemFont(ofSize: LABEL_FONT_SIZE)
        // adding padding
        titleField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 30))
        titleField.leftViewMode = .always
        
        view.addSubview(titleField)
        titleField.snp.makeConstraints{ (make) in
            make.right.equalTo(-SCREEN.width / 15)
            make.height.equalTo(30)
            make.width.equalTo(SCREEN.width * 0.7)
            make.top.equalTo(view).offset(20)
        }
        
        titleLabel = UILabel()
        titleLabel.text = "标题: "
        titleLabel.font = .systemFont(ofSize: LABEL_FONT_SIZE)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleField)
            make.left.equalTo(LEFT_PADDING)
        }
        
        addSymmetryLine(y: 55)
        addSymmetryLine(y: 80, isDotted: true)
        
        campusLabel = UILabel()
        view.addSubview(campusLabel)
        campusLabel.text = "选择校区(可选): "
        campusLabel.font = .systemFont(ofSize: LABEL_FONT_SIZE)
        campusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.left.equalTo(LEFT_PADDING)
        }
        
        let layout = UICollectionViewFlowLayout()
        
        layout.estimatedItemSize = CGSize(width: 200, height: 25)
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        campusSelectionView = SelectionView(data: campus, collectionViewLayout: layout)
        campusSelectionView.allowsCancelSelection = true
        view.addSubview(campusSelectionView)
        campusSelectionView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(SCREEN.width * 0.8)
            make.top.equalTo(campusLabel.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        
        tagLabel = UILabel()
        view.addSubview(tagLabel)
        tagLabel.text = "选择部门:"
        tagLabel.font = .systemFont(ofSize: LABEL_FONT_SIZE)
        tagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(campusSelectionView.snp.bottom).offset(5)
            make.left.equalTo(LEFT_PADDING)
        }
        
        tagSelectionView = SelectionView(data: availableTags.map { $0.name! }, collectionViewLayout: layout)
        view.addSubview(tagSelectionView)
        tagSelectionView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(SCREEN.width * 0.8)
            make.top.equalTo(tagLabel.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        
        tagDesLabel = UILabel()
        tagDesLabel.text = "我是一个部门介绍"
        tagDesLabel.font = .systemFont(ofSize: 12)
        tagDesLabel.lineBreakMode = .byWordWrapping
        tagDesLabel.textColor = .gray
        view.addSubview(tagDesLabel)
        tagDesLabel.snp.makeConstraints { (make) in
            make.left.equalTo(LEFT_PADDING)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(tagSelectionView.snp.bottom).offset(5)
        }
        
        addSymmetryLine(y: 235, isDotted: true)
        
        contentLabel = UILabel()
        contentLabel.text = "问题描述:"
        contentLabel.textColor = UIColor.black
        contentLabel.font = .systemFont(ofSize: LABEL_FONT_SIZE)
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagDesLabel.snp.bottom).offset(20)
            make.left.equalTo(LEFT_PADDING)
        }
        
        contentCountLabel = UILabel()
        contentCountLabel.text = "0/200"
        contentCountLabel.textColor = .gray
        contentCountLabel.font = .systemFont(ofSize: LABEL_FONT_SIZE - 2)
        view.addSubview(contentCountLabel)
        contentCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentLabel)
            make.right.equalTo(view.snp.right).offset(-LEFT_PADDING)
        }
        
        contentField = UITextView()
        contentField.layer.borderWidth = 1
        contentField.layer.cornerRadius = 5
        contentField.layer.masksToBounds = true
        contentField.delegate = self
        contentField.text = "不超过200字"
        contentField.textColor = UIColor(hex6: 0xd3d3d3)
        contentField.layer.borderColor = UIColor(hex6: 0xf4f4f4).cgColor
        contentField.textContainerInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 5)
        contentField.font = .systemFont(ofSize: 14)
        view.addSubview(contentField)
        contentField.snp.makeConstraints{ (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.height.equalTo(100)
            make.left.equalTo(LEFT_PADDING)
            make.right.equalTo(-LEFT_PADDING)
        }
        
        addSymmetryLine(y: 390, isDotted: true)
        
        photoLabel = UILabel()
        photoLabel.text = "添加图片: "
        photoLabel.textColor = UIColor.black
        photoLabel.font = .systemFont(ofSize: LABEL_FONT_SIZE)
        view.addSubview(photoLabel)
        photoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentField.snp.bottom).offset(25)
            make.left.equalTo(LEFT_PADDING)
        }
        
        let photoW = SCREEN.width * 5 / 6 / 3
        photoCollectionView = FBPhotoCollectionView(size: CGSize(width: photoW, height: photoW))
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN.width * 5 / 6)
            make.top.equalTo(photoLabel.snp.bottom).offset(5)
            make.height.equalTo(photoW)
            make.centerX.equalTo(view)
        }
        
        confirmButton = UIButton()
        confirmButton.backgroundColor = UIColor.feedBackBlue
        confirmButton.addTarget(self, action: #selector(postQues), for: .touchUpInside)
        confirmButton.setTitle("确认提交", for: .normal)
        confirmButton.layer.cornerRadius = 15
        confirmButton.layer.masksToBounds = true
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.bounds.width/2)
            make.top.equalTo(photoCollectionView.snp.bottom).offset(50)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
    }
    
    fileprivate func addCallBack() {
        campusSelectionView.addCallBack { (idx) in
            self.selectedCampus = self.selectedCampus == (idx + 1) ? 0 : (idx + 1)
        }
        
        tagSelectionView.addCallBack { (idx) in
            self.selectedTag = idx
            self.tagDesLabel.text = idx == -1 ? "我是一个部门介绍" : self.availableTags[idx].description ?? "这个部门还没有介绍哦"
        }
    }
}

//MARK: - Data
extension FBNewQuestionViewController {
    
    @objc func postQues() {
        if let title = titleField.text, let content = contentField.text {
            guard title != "" && content != "不超过200字" && content != "" else {
                let alert = UIAlertController(title: "提示", message: "请填写完整信息", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                alert.addAction(action1)
                // for iPad
                if let popover = alert.popoverPresentationController {
                    popover.sourceView = confirmButton
                    popover.sourceRect = confirmButton.frame
                    popover.permittedArrowDirections = .any
                }
                self.present(alert, animated: true)
                return
            }
            guard selectedTag != -1 else {
                let alert = UIAlertController(title: "提示", message: "请至少选择一个标签", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                alert.addAction(action1)
                // for iPad
                if let popover = alert.popoverPresentationController {
                    popover.sourceView = confirmButton
                    popover.sourceRect = confirmButton.frame
                    popover.permittedArrowDirections = .any
                }
                self.present(alert, animated: true)
                return
            }
            
            SwiftMessages.showLoading()
            
            FBQuestionHelper.postQuestion(title: title, content: content, tagList: [availableTags[selectedTag].id ?? 0], campus: selectedCampus) { (result) in
                switch result {
                case .success(let questionId):
                    if let imgs = self.photoCollectionView.images {
                        guard imgs.count != 1 else {
                            NotificationCenter.default.post(Notification(name: Notification.Name(FB_NOTIFICATIONFLAG_NEED_RELOAD)))
                            NotificationCenter.default.post(Notification(name: Notification.Name(FB_SHOULD_RELOAD_NEWQUESTIONVC)))
                            SwiftMessages.hideLoading()
                            SwiftMessages.showSuccessMessage(body: "发布成功")
                            self.dismiss(animated: true)
                            return
                        }
                        let cnt = imgs.count
                        
                        let group = DispatchGroup()
                        
                        for i in 0..<cnt - 1 {
                            group.enter()
                            FBQuestionHelper.postImg(img: imgs[i], question_id: questionId) { (result) in
                                switch result {
                                case .success(let str):
                                    print(str)
                                    group.leave()
                                case .failure(let err):
                                    print(err)
                                    group.leave()
                                }
                            }
                        }
                        group.notify(queue: .main) {
                            NotificationCenter.default.post(Notification(name: Notification.Name(FB_NOTIFICATIONFLAG_NEED_RELOAD)))
                            NotificationCenter.default.post(Notification(name: Notification.Name(FB_SHOULD_RELOAD_NEWQUESTIONVC)))
                            SwiftMessages.hideLoading()
                            SwiftMessages.showSuccessMessage(body: "发布成功")
                            self.dismiss(animated: true)
                        }
                    }
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}

//MARK: - Delegate
extension FBNewQuestionViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 200
        let currentString: NSString = textView.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        contentCountLabel.text = "\(newString.length)/200"
        return newString.length <= maxLength
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "不超过200字" {
            textView.text = ""
            textView.textColor = .black
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            textView.text = "不超过200字"
            textView.textColor = UIColor(hex6: 0xdbdbdb)
        }
        return true
    }
}

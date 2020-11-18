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
     
     var titleField: UITextField!
     var confirmButton: UIButton!
     var contentField: UITextView!
     
     var titleLabel: UILabel!
     var classLabel: UILabel!
     var classDesLabel: UILabel!
     var contentsLabel: UILabel!
     var photoLabel: UILabel!
     
     var images = [UIImage]() {
          didSet {
               photoCollectionView.reload(images)
          }
     }
     var imageViews = [UIImageView]()
     
     var photoCollectionView: FBPhotoCollectionView!
     var tagCollectionView: UICollectionView?
     let collectionViewCellId = "feedBackCollectionViewCellID"
     
     let LABEL_FONT_SIZE: CGFloat = 16
     let LEFT_PADDING: CGFloat = SCREEN.width / 12
     
     // MARK: - Data
     var availableTags: [TagModel] = [
          TagModel(id: 0, name: "后保部", children: nil),
          TagModel(id: 0, name: "后保部", children: nil),
          TagModel(id: 0, name: "后保部", children: nil),
          TagModel(id: 0, name: "后保部", children: nil),
     ] {
          didSet {
               tagCollectionView?.reloadData()
          }
     }
     var selectedTag: Int = -1 // default no tag is selected
     
     override func viewDidLoad() {
          super.viewDidLoad()
          setUp()
     }
     
     override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          confirmButton.addShadow(UIColor(hex6: 0x00a1e9), sRadius: 2, sOpacity: 0.2, offset: (3, 3))
     }
}

//MARK: - UI
extension FBNewQuestionViewController {
     func setUp() {
          view.backgroundColor = .white
          
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
          
          classLabel = UILabel()
          view.addSubview(classLabel)
          classLabel.text = "选择标签: "
          classLabel.font = .systemFont(ofSize: LABEL_FONT_SIZE)
          classLabel.snp.makeConstraints { (make) in
               make.top.equalTo(titleLabel.snp.bottom).offset(20)
               make.left.equalTo(LEFT_PADDING)
          }
          
          let layout = UICollectionViewFlowLayout()
          
          layout.estimatedItemSize = CGSize(width: 200, height: 25)
          layout.minimumInteritemSpacing = 10
          layout.scrollDirection = .horizontal
          tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
          tagCollectionView?.backgroundColor = .white
          tagCollectionView?.delegate = self
          tagCollectionView?.dataSource = self
          tagCollectionView?.register(FBTagCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellId)
          view.addSubview(tagCollectionView!)
          tagCollectionView!.snp.makeConstraints { (make) in
               make.centerX.equalTo(view)
               make.width.equalTo(SCREEN.width * 0.8)
               make.top.equalTo(classLabel.snp.bottom).offset(5)
               make.height.equalTo(30)
          }
          
          classDesLabel = UILabel()
          classDesLabel.text = "我是一个部门介绍"
          classDesLabel.font = .systemFont(ofSize: LABEL_FONT_SIZE)
          classDesLabel.textColor = .gray
          view.addSubview(classDesLabel)
          classDesLabel.snp.makeConstraints { (make) in
               make.left.equalTo(LEFT_PADDING)
               make.top.equalTo(tagCollectionView!.snp.bottom).offset(5)
          }
          
          contentsLabel = UILabel()
          contentsLabel.text = "问题描述: "
          contentsLabel.textColor = UIColor.black
          contentsLabel.font = .systemFont(ofSize: LABEL_FONT_SIZE)
          view.addSubview(contentsLabel)
          contentsLabel.snp.makeConstraints { (make) in
               make.top.equalTo(classDesLabel.snp.bottom).offset(20)
               make.left.equalTo(LEFT_PADDING)
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
               make.top.equalTo(contentsLabel.snp.bottom).offset(5)
               make.height.equalTo(100)
               make.left.equalTo(LEFT_PADDING)
               make.right.equalTo(-LEFT_PADDING)
          }
          
          photoLabel = UILabel()
          photoLabel.text = "添加图片: "
          photoLabel.textColor = UIColor.black
          photoLabel.font = .systemFont(ofSize: LABEL_FONT_SIZE)
          view.addSubview(photoLabel)
          photoLabel.snp.makeConstraints { (make) in
               make.top.equalTo(contentField.snp.bottom).offset(20)
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
          confirmButton.backgroundColor = UIColor(hex6: 0x00a1e9)
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
}

//MARK: - Data
extension FBNewQuestionViewController {
     
     @objc func postQues() {
          if let title = titleField.text, let content = contentField.text {
               guard title != "" && content != "" else {
                    let alert = UIAlertController(title: "提示", message: "请填写完整信息", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                    alert.addAction(action1)
                    self.present(alert, animated: true)
                    return
               }
               guard selectedTag != -1 else {
                    let alert = UIAlertController(title: "提示", message: "请至少选择一个标签", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                    alert.addAction(action1)
                    self.present(alert, animated: true)
                    return
               }
               
               SwiftMessages.showLoading()
               
               QuestionHelper.postQuestion(title: title, content: content, tagList: availableTags.map{ $0.id ?? 0 }.filter{ $0 != 0 }) { (result) in
                    switch result {
                    case .success(let questionId):
                         if let imgs = self.photoCollectionView.images {
                              guard imgs.count != 1 else {
                                   self.dismiss(animated: true)
                                   return
                              }
                              let cnt = imgs.count
                              
                              let group = DispatchGroup()
                              
                              for i in 0..<cnt - 1 {
                                   group.enter()
                                   QuestionHelper.postImg(img: imgs[i], question_id: questionId) { (result) in
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
                                   //                                   animationView.stop()
                                   SwiftMessages.hideLoading()
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


extension FBNewQuestionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return availableTags.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as! FBTagCollectionViewCell
          cell.update(by: availableTags[indexPath.row], selected: indexPath.row == selectedTag)
          return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          if selectedTag == -1 {
               selectedTag = indexPath.row
               (collectionView.cellForItem(at: indexPath) as! FBTagCollectionViewCell).toggle()
          } else if selectedTag == indexPath.row {
               return
          } else {
               (collectionView.cellForItem(at: IndexPath(row: selectedTag, section: indexPath.section)) as! FBTagCollectionViewCell).toggle()
               (collectionView.cellForItem(at: indexPath) as! FBTagCollectionViewCell).toggle()
               selectedTag = indexPath.row
          }
     }
}

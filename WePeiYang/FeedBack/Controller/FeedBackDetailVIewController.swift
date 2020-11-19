//
//  FeedBackDetailVIewController.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/15.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire


class FeedBackDetailViewController: UIViewController {
     // MARK: - UI
     
     var tableView: UITableView!
     var tabBarView: FBDetailTabBarView!
     var commentView: UIView!
     var textView: UITextView!
     
     //MARK: - Data
     var comments = [CommentModel]()
     var questionOfthisPage: QuestionModel?
     var tags = [TagModel]()
     var isLiked: Bool? {
          didSet {
               tabBarView.likeBtn.setImage(UIImage(named: isLiked ?? false ? "feedback_thumb_up_fill" : "feedback_thumb_up"), for: .normal)
          }
     }
     let commentCellID = "feedBackDVCCell"
     
     override func viewDidLoad() {
          super .viewDidLoad()
          setUp()
          
     }
     override func viewWillAppear(_ animated: Bool) {
          super .viewWillAppear(animated)
          
          loadData()
          
     }
}

// MARK: - UI
extension FeedBackDetailViewController {
     private func setUp() {
          navigationItem.title = "问题详情"
          view.backgroundColor = UIColor(hex6: 0xf6f6f6)
          
          let naviHeight = navigationController?.navigationBar.frame.maxY ?? 0
          tableView = UITableView(frame: CGRect(x: 0, y: naviHeight - 12, width: SCREEN.width, height: SCREEN.height - naviHeight - 70 + 12))
          tableView.backgroundColor = UIColor(hex6: 0xf6f6f6)
          tableView.dataSource = self
          tableView.delegate = self
          tableView.register(FBCommentTableViewCell.self, forCellReuseIdentifier: commentCellID)
          tableView.tableHeaderView = FBDetailHeaderView(question: questionOfthisPage ?? QuestionModel())
          tableView.keyboardDismissMode = .onDrag
          tableView.separatorStyle = .none
          view.addSubview(tableView)
          
          tabBarView = FBDetailTabBarView(frame: CGRect(x: 0, y: SCREEN.height - 70, width: SCREEN.width, height: 70))
          view.addSubview(tabBarView)
          tabBarView.likeBtn.addTarget(self, action: #selector(likeOrDislike), for: .touchUpInside)
          self.isLiked = questionOfthisPage?.isLiked
          tabBarView.commentBtn.add(for: .touchUpInside) {
               self.commentView.isHidden = false
               self.commentView.addShadow(.black, sRadius: 5, sOpacity: 0.3, offset: (0, -4))
               self.textView.becomeFirstResponder()
          }
          
          commentView = UIView()
          commentView.backgroundColor = .white
          self.view.addSubview(self.commentView)
          commentView.snp.updateConstraints { (make) in
               make.width.equalTo(SCREEN.width)
               make.height.equalTo(60)
               make.bottom.equalTo(view)
               make.centerX.equalTo(view)
          }
          
          textView = UITextView()
          commentView.addSubview(textView)
//          textView.layer.borderColor = UIColor.black.cgColor
//          textView.layer.borderWidth = 1
//          textView.layer.cornerRadius = 20
//          textView.layer.masksToBounds = true
          textView.text = "发表你的看法"
          textView.textColor = UIColor(hex6: 0xdbdbdb)
          textView.returnKeyType = .send
          // 防止圆角遮挡
          textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
          textView.font = .systemFont(ofSize: 18)
          textView.delegate = self
          self.textView.snp.updateConstraints { (make) in
               make.left.equalTo(self.commentView.snp.left).offset(10)
               make.centerY.equalTo(self.commentView.snp.centerY)
               make.width.equalTo(self.commentView.snp.width).offset(-30)
               make.height.equalTo(40)
          }
          commentView.isHidden = true
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
          
     }
     
     @objc func likeOrDislike() {
          if self.isLiked ?? false {
               QuestionHelper.dislikeQuestion(id: questionOfthisPage?.id ?? 0) { (result) in
                    switch result {
                    case .success(let str):
                         SwiftMessages.showSuccessMessage(body: str)
                         self.isLiked = false
                    case .failure(let err):
                         print(err)
                    }
               }
          } else {
               QuestionHelper.likeQuestion(id: questionOfthisPage?.id ?? 0) { (result) in
                    switch result {
                    case .success(let str):
                         SwiftMessages.showSuccessMessage(body: str)
                         self.isLiked = true
                    case .failure(let err):
                         print(err)
                    }
               }
          }
     }
     
     @objc func keyboardShow(note: Notification)  {
          guard let userInfo = note.userInfo else {return}
          guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{return}
          UIView.animate(withDuration: 1) {
               self.commentView.transform = CGAffineTransform.init(translationX: 0, y: -keyboardRect.height)
          }
     }
     @objc func keyboardDisappear(note: Notification)  {
          textView.endEditing(true)
          if textView.text == "" {
               textView.text = "发表你的看法"
               textView.textColor = UIColor(hex6: 0xdbdbdb)
          }
          self.commentView.isHidden = true
          UIView.animate(withDuration: 1) {
               self.commentView.transform = CGAffineTransform.identity
          }
     }
}

// MARK: - Data
extension FeedBackDetailViewController {
     private func loadData() {
          if questionOfthisPage?.solved == 1 {
               CommentHelper.commentGet(type: .answer, id: questionOfthisPage?.id ?? 0) { (result) in
                    switch result {
                    case .success(let answers):
                         self.comments = answers
                         CommentHelper.commentGet(id: self.questionOfthisPage?.id ?? 0) { (result) in
                              switch result {
                              case .success(let comments):
                                   self.comments += comments
                                   self.tableView.reloadData()
                              case .failure(let err):
                                   print(err)
                              }
                         }
                    case .failure(let err):
                         print(err)
                    }
               }
          } else {
               CommentHelper.commentGet(id: questionOfthisPage?.id ?? 0) { (result) in
                    switch result {
                    case .success(let comments):
                         self.comments = comments
                         self.tableView.reloadData()
                    case .failure(let err):
                         print(err)
                    }
               }
          }
     }
}

// MARK: - Delegate

extension FeedBackDetailViewController: UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return comments.count
     }
     
     //MARK:- The content of the comment
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: commentCellID) as! FBCommentTableViewCell
          cell.update(comment: comments[indexPath.row])
          return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          let comment = comments[indexPath.row]
          var str = comment.contain ?? ""
          var aStr: NSAttributedString?
          if comment.adminID != nil {
               if comment.contain?.findFirst("src") != -1 {
                    str = "点击查看详情"
               } else {
                    aStr = comment.contain?.htmlToAttributedString
                    return 60 + aStr!.getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 0)
               }
          }
          return 80 + str.getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 0)
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let comment = comments[indexPath.row]
          if comment.adminID != nil && comment.contain?.findFirst("src") != -1 {
               let detailVC = FBReplyDetailView(html: comment.contain ?? "")
               UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                    self.view.addSubview(detailVC)
               }, completion: nil)
          }
     }
     
     func textViewDidChange(_ textView: UITextView) {
          if let lineHeight = textView.font?.lineHeight {
               let nowSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: lineHeight))
               let lines = floorf(Float(nowSize.height / lineHeight))
               if lines <= 5 {
                    let addedHeight = lineHeight * CGFloat(lines - 1)
                    commentView.snp.updateConstraints { (make) in
                         make.height.equalTo(60 + addedHeight)
                    }
                    textView.snp.updateConstraints { (make) in
                         make.height.equalTo(40 + addedHeight)
                    }
               }
          }
     }
     
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
          if textView.text == "发表你的看法" {
               textView.text = ""
               textView.textColor = .black
          }
          if (text ==  "\n") {
               textView.resignFirstResponder()
               guard textView.text! != "" else {
                    return true
               }
               textView.endEditing(true)
               CommentHelper.addComment(questionId: (questionOfthisPage?.id)!, contain: textView.text) { (string) in
                    SwiftMessages.showSuccessMessage(body: "评论发布成功!")
                    self.loadData()
                    textView.text = "发表你的看法"
                    textView.textColor = UIColor(hex6: 0xdbdbdb)
               }
          }
          return true
     }
}


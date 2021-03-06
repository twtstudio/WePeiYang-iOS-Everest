//
//  FBCommentTableViewCell.swift
//  WePeiYang
//
//  Created by phoenix Dai on 2020/9/22.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import WebKit

class FBCommentTableViewCell: UITableViewCell {
     
     var bgView: UIView!
     var userImgView: UIImageView! // user头像
     var userNameLabel: UILabel! // user名称
     var contentLabel: UILabel! // 内容
     var timeLabel: UILabel! // 时间
     var likesBtn: UIButton! // 点赞图标
     
     var likes: Int! {
          didSet {
               likesLabel.text = likes.description
          }
     }
     var likesLabel: UILabel! // 点赞Label
     var isLiked: Bool! {
          didSet {
               likesBtn.setImage(UIImage(named: isLiked ? "feedback_thumb_up_fill" : "feedback_thumb_up"), for: .normal)
          }
     }
     var commentID: Int!

     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          
          backgroundColor = UIColor(hex6: 0xf6f6f6)
          selectionStyle = .none
          
          bgView = UIView()
          contentView.addSubview(bgView)
          bgView.backgroundColor = .white
          bgView.addCornerRadius(15)
          bgView.snp.makeConstraints { (make) in
               make.top.equalTo(contentView).offset(5)
               make.bottom.equalTo(contentView).offset(-5)
               make.left.equalTo(contentView).offset(10)
               make.right.equalTo(contentView).offset(-10)
          }
          
          userImgView = UIImageView()
          userImgView.image = UIImage(named: "feedback_user")
          userImgView.backgroundColor = .white
          bgView.addSubview(userImgView)
          userImgView.snp.makeConstraints { (make) in
               make.left.top.equalTo(bgView).offset(10)
               make.width.height.equalTo(20)
          }
          
          userNameLabel = UILabel()
          userNameLabel.font = .boldSystemFont(ofSize: 14)
          userNameLabel.backgroundColor = .white
          bgView.addSubview(userNameLabel)
          userNameLabel.snp.makeConstraints { (make) in
               make.left.equalTo(userImgView.snp.right).offset(5)
               make.centerY.equalTo(userImgView)
               make.height.equalTo(20)
          }

          contentLabel = UILabel()
          contentLabel.font = .systemFont(ofSize: 14)
          contentLabel.backgroundColor = .white
          bgView.addSubview(contentLabel)
          contentLabel.numberOfLines = 0
          contentLabel.snp.makeConstraints { (make) in
               make.left.equalTo(userNameLabel.snp.left)
               make.top.equalTo(userNameLabel.snp.bottom).offset(5)
               make.width.equalTo(SCREEN.width * 0.8)
          }
          
          timeLabel = UILabel()
          timeLabel.font = .systemFont(ofSize: 12)
          timeLabel.backgroundColor = .white
          timeLabel.textColor = .gray
          bgView.addSubview(timeLabel)
          timeLabel.snp.makeConstraints { (make) in
               make.left.equalTo(contentLabel.snp.left)
               make.bottom.equalTo(self).offset(-10)
          }
          
          likesBtn = UIButton()
          likesBtn.tag = 0
          bgView.addSubview(likesBtn)
          likesBtn.snp.makeConstraints { (make) in
               make.centerY.equalTo(timeLabel)
               make.left.equalTo(timeLabel.snp.right).offset(5)
               make.width.height.equalTo(15)
          }
          
          likesLabel = UILabel()
          likesLabel.font = .systemFont(ofSize: 12)
          likesLabel.backgroundColor = .white
          bgView.addSubview(likesLabel)
          likesLabel.snp.makeConstraints { (make) in
               make.centerY.equalTo(timeLabel)
               make.left.equalTo(likesBtn.snp.right).offset(5)
          }
     }
     
     override func layoutIfNeeded() {
          super.layoutIfNeeded()
          bgView.addShadow(.black, sRadius: 3, sOpacity: 0.2, offset: (1, 1))
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
     func update(comment: FBCommentModel) {
          
          userNameLabel.text = comment.username
          userNameLabel.sizeToFit()
         
          contentLabel.text = comment.contain
          contentLabel.textColor = .black
          
          timeLabel.text = (comment.createdAt?[0..<10] ?? "") + " " + (comment.createdAt?[11..<16] ?? "")
          timeLabel.sizeToFit()
          commentID = comment.id ?? 0
          likesBtn.removeTarget(nil, action: nil, for: .allEvents)
          likesBtn.addTarget(self, action: #selector(likeOrDislike), for: .touchUpInside)
          isLiked = comment.isLiked
          likes = comment.likes ?? 0
          likesLabel.sizeToFit()
     }
     
     @objc func likeOrDislike() {
          if isLiked == false {
               likesBtn.setImage(UIImage(named: "feedback_thumb_up_fill"), for: .normal)
               FBCommentHelper.likeComment(type: .comment, commentId: commentID) { (result) in
                    switch result {
                    case .success(let str):
                         SwiftMessages.showSuccessMessage(body: str)
                    case .failure(let error):
                         print(error)
                    }
               }
               isLiked = true
               likes += 1
               
          } else {
               likesBtn.setImage(UIImage(named: "feedback_thumb_up"), for: .normal)
               FBCommentHelper.dislikeComment(type: .comment, commentId: commentID) { (result) in
                    switch result {
                    case .success(let str):
                         SwiftMessages.showSuccessMessage(body: str)
                    case .failure(let error):
                         print(error)
                    }
               }
               isLiked = false
               likes -= 1
          }
     }
     
     
     
}

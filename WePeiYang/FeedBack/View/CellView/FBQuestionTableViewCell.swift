//
//  FBQuestionTableViewCell.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBQuestionTableViewCell: UITableViewCell {
     
     var bgView: UIView!
     var titleLabel: UILabel! // 标题
     var userImgView: UIImageView! // user的图标
     var usernameLabel: UILabel! // user名字
     var timeLabel: UILabel! // 时间
     var contentLabel: UILabel! // 内容
     var msgImgView: UIImageView! // msg图标
     var msgCntLabel: UILabel! // 评论个数
     var likesImgView: UIImageView! // 点赞图标
     var likesLabel: UILabel! // 点赞数
     var stLabel: UILabel! // 状态 校方未回复 校方已解决
     var imgView: UIImageView! // 图片
     
     
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
          
          titleLabel = UILabel()
          titleLabel.font = .boldSystemFont(ofSize: 16)
          bgView.addSubview(titleLabel)
          titleLabel.snp.makeConstraints { (make) in
               make.top.equalTo(bgView).offset(5)
               make.left.equalTo(bgView).offset(SCREEN.width / 20)
               make.width.equalTo(SCREEN.width * 0.9)
               make.height.equalTo(30)
          }
          
          userImgView = UIImageView()
          userImgView.image = UIImage(named: "feedback_user")
          bgView.addSubview(userImgView)
          userImgView.snp.makeConstraints { (make) in
               make.left.equalTo(titleLabel)
               make.width.height.equalTo(15)
               make.top.equalTo(titleLabel.snp.bottom).offset(5)
          }
          
          usernameLabel = UILabel()
          bgView.addSubview(usernameLabel)
          usernameLabel.font = .systemFont(ofSize: 12)
          usernameLabel.snp.makeConstraints { (make) in
               make.left.equalTo(userImgView.snp.right).offset(2)
               make.centerY.equalTo(userImgView)
          }
          
          timeLabel = UILabel()
          bgView.addSubview(timeLabel)
          timeLabel.font = .systemFont(ofSize: 12)
          timeLabel.snp.makeConstraints { (make) in
               make.left.equalTo(usernameLabel.snp.right).offset(5)
               make.centerY.equalTo(usernameLabel)
          }
          
          contentLabel = UILabel()
          contentLabel.numberOfLines = 2
          bgView.addSubview(contentLabel)
          contentLabel.font = .systemFont(ofSize: 14)
          contentLabel.snp.makeConstraints { (make) in
               make.left.equalTo(titleLabel)
               make.width.equalTo(SCREEN.width * 0.9)
               make.top.equalTo(userImgView.snp.bottom).offset(10)
               
          }
          
          msgImgView = UIImageView()
          msgImgView.image = UIImage(named: "feedback_message")
          bgView.addSubview(msgImgView)
          msgImgView.snp.makeConstraints { (make) in
               make.left.equalTo(titleLabel)
               make.width.height.equalTo(20)
               //               make.bottom.equalTo(bgView.snp.bottom).offset(-5)
               make.top.equalTo(contentLabel.snp.bottom).offset(5)
          }
          
          msgCntLabel = UILabel()
          bgView.addSubview(msgCntLabel)
          msgCntLabel.font = .systemFont(ofSize: 12)
          msgCntLabel.snp.makeConstraints { (make) in
               make.left.equalTo(msgImgView.snp.right).offset(5)
               make.centerY.equalTo(msgImgView)
          }
          
          likesImgView = UIImageView()
          likesImgView.image = UIImage(named: "feedback_thumb_up")
          bgView.addSubview(likesImgView)
          likesImgView.snp.makeConstraints { (make) in
               make.left.equalTo(msgCntLabel.snp.right).offset(5)
               make.width.height.equalTo(20)
               make.centerY.equalTo(msgImgView)
          }
          
          likesLabel = UILabel()
          bgView.addSubview(likesLabel)
          likesLabel.font = .systemFont(ofSize: 12)
          likesLabel.snp.makeConstraints { (make) in
               make.left.equalTo(likesImgView.snp.right).offset(5)
               make.centerY.equalTo(msgImgView)
          }
          
          stLabel = UILabel()
          bgView.addSubview(stLabel)
          stLabel.font = .systemFont(ofSize: 12)
          stLabel.snp.makeConstraints { (make) in
               make.left.equalTo(likesLabel.snp.right).offset(5)
               make.centerY.equalTo(msgImgView)
          }
          
          imgView = UIImageView()
          bgView.addSubview(imgView)
          imgView.contentMode = .scaleToFill
          imgView.image = UIImage(named: "aaaaaa")
          imgView.layer.cornerRadius = 5
          imgView.layer.masksToBounds = true
          imgView.snp.makeConstraints { (make) in
               //               make.centerY.equalTo(contentLabel)
               make.right.equalTo(-SCREEN.width / 20)
               make.width.equalTo(0)
               //               make.top.equalTo(titleLabel.snp.bottom).offset(5)
               make.centerY.equalTo(self).priority(50)
               make.height.equalTo(80)
          }
          
          
          
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
     
     func update(by question: QuestionModel) {
          
          titleLabel.text = question.name
          titleLabel.sizeToFit()
          usernameLabel.text = question.username
          usernameLabel.sizeToFit()
          timeLabel.text = question.createdAt?.components(separatedBy: "T")[0]
          timeLabel.sizeToFit()
          contentLabel.text = question.datumDescription
          msgCntLabel.text = question.msgCount?.description
          msgCntLabel.sizeToFit()
          stLabel.text = (question.solved ?? 0) == 1 ? "已解决" : "未解决"
          stLabel.textColor = (question.solved ?? 0) == 1 ? UIColor(hex6: 0x387a47) : .black
          likesLabel.text = question.likes?.description ?? ""
          likesLabel.sizeToFit()
          
          if question.name!.count >= 14 {
               imgView.snp.makeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).priority(100)
               }
          }
          
          if question.urlList?.count == 0 {
               contentLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(SCREEN.width * 0.9)
               }
               imgView.snp.updateConstraints { (make) in
                    make.width.equalTo(0)
               }
          } else {
               contentLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(SCREEN.width * 0.6)
               }
               imgView.snp.updateConstraints { (make) in
                    make.width.equalTo(SCREEN.width * 0.25)
               }
               imgView.sd_setImage(with: URL(string: question.thumbImg ?? ""), completed: nil)
          }
     }
     
}

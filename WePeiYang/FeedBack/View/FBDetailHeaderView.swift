//
//  FeedBackDetailHeaderView.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/24.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBDetailHeaderView: UIView {

     var titleLabel: UILabel!
     var contentLabel: UILabel!
     var photoCollectionView: FBPhotoCollectionView!
     var userImgView: UIImageView!
     var usernameLabel: UILabel!
     var timeLabel: UILabel!
     var stLabel: UILabel!

     convenience init(question: QuestionModel) {
          self.init()
//          self.init()
          titleLabel = UILabel()
          titleLabel.font = .boldSystemFont(ofSize: 20)
          titleLabel.numberOfLines = 0
          addSubview(titleLabel)
          titleLabel.snp.makeConstraints { (make) in
               make.centerX.equalTo(self)
               make.width.equalTo(SCREEN.width * 0.8)
               make.top.equalTo(self).offset(5)
          }
          
          contentLabel = UILabel()
          contentLabel.numberOfLines = 0
          contentLabel.font = .systemFont(ofSize: 14)
          addSubview(contentLabel)
          contentLabel.snp.makeConstraints { (make) in
               make.centerX.equalTo(self)
               make.top.equalTo(titleLabel.snp.bottom).offset(5)
               make.width.equalTo(SCREEN.width * 0.8)
          }
          
          let images = question.urlList ?? []
          let photoCVHeight = CGFloat(ceilf(Float(images.count) / 3) * 100)
          photoCollectionView = FBPhotoCollectionView(thumbUrls: question.thumbUrlList ?? [], urls: images)
          addSubview(photoCollectionView)
          photoCollectionView.snp.makeConstraints { (make) in
               make.top.equalTo(contentLabel.snp.bottom).offset(5)
               make.width.equalTo(300)
               make.height.equalTo(photoCVHeight)
               make.centerX.equalTo(self)
          }
          
          timeLabel = UILabel()
          timeLabel.font = .systemFont(ofSize: 12)
          addSubview(timeLabel)
          timeLabel.snp.makeConstraints { (make) in
               make.right.equalTo(self).offset(-10)
               make.top.equalTo(photoCollectionView.snp.bottom).offset(10)
          }
          
          usernameLabel = UILabel()
          usernameLabel.font = .systemFont(ofSize: 12)
          addSubview(usernameLabel)
          usernameLabel.snp.makeConstraints { (make) in
               make.right.equalTo(timeLabel.snp.left).offset(-5)
               make.centerY.equalTo(timeLabel)
          }
          
          userImgView = UIImageView()
          addSubview(userImgView)
          userImgView.image = UIImage(named: "feedback_user")
          userImgView.snp.makeConstraints { (make) in
               make.width.height.equalTo(20)
               make.right.equalTo(usernameLabel.snp.left).offset(-5)
               make.centerY.equalTo(timeLabel)
          }
          
          stLabel = UILabel()
          stLabel.font = .boldSystemFont(ofSize: 14)
          addSubview(stLabel)
          stLabel.snp.makeConstraints { (make) in
               make.right.equalTo(self).offset(-10)
               make.top.equalTo(timeLabel.snp.bottom).offset(5)
          }
          
          
          titleLabel.text = question.name
          contentLabel.text = question.datumDescription
          usernameLabel.text = question.username
          timeLabel.text = question.createdAt?.components(separatedBy: "T")[0]
          stLabel.text = question.solved ?? 0 == 1 ? "校方已回复" : "校方未回复"
          stLabel.textColor = question.solved ?? 0 == 1 ? UIColor(hex6: 0x387a47) : .red
          
          frame = CGRect(x: 0, y: 0, width: SCREEN.width, height: 150 +    photoCVHeight + (question.datumDescription ?? "").getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.9, numbersOfLines: 0))
     }
}

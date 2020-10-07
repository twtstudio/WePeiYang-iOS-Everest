//
//  FeedBackDetailHeaderView.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/24.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBDetailHeaderView: UIView {

     var bgView: UIView!
     var titleLabel: UILabel! // 标题
     var tagView: FBTagCollectionView! // 标签
     var contentLabel: UILabel! // 内容
     var photoCollectionView: FBPhotoCollectionView! // 照片墙
     var userImgView: UIImageView! // 头像
     var usernameLabel: UILabel! // 昵称
     var timeLabel: UILabel! // 时间
     var msgImgView: UIImageView! // msg图标
     var msgCntLabel: UILabel! // 评论个数
     var likesImgView: UIImageView! // 点赞图标
     var likesLabel: UILabel! // 点赞数
     var stLabel: UILabel! // 回复状态
     
     let collectionViewCellId = "feedBackCollectionViewCellID"
     var tags = [TagModel]()

     convenience init(question: QuestionModel) {
          self.init()
          
          bgView = UIView()
          self.addSubview(bgView)
          bgView.backgroundColor = .white
          bgView.addCornerRadius(15)
          bgView.snp.makeConstraints { (make) in
               make.top.equalTo(self).offset(5)
               make.bottom.equalTo(self).offset(-5)
               make.left.equalTo(self).offset(10)
               make.right.equalTo(self).offset(-10)
          }
          
          titleLabel = UILabel()
          titleLabel.font = .boldSystemFont(ofSize: 20)
          titleLabel.backgroundColor = .white
          titleLabel.numberOfLines = 0
          bgView.addSubview(titleLabel)
          titleLabel.snp.makeConstraints { (make) in
               make.centerX.equalTo(bgView)
               make.width.equalTo(SCREEN.width * 0.9)
               make.top.equalTo(bgView).offset(5)
          }
          
          tagView = FBTagCollectionView(frame: .zero, itemSize: CGSize(width: 200, height: 25), isSelectedOnly: true)
          tagView.backgroundColor = .white
          tagView.cvDelegate = self
          tagView.cvDataSource = self
          bgView.addSubview(tagView)
          tagView.snp.makeConstraints { (make) in
               make.left.equalTo(titleLabel)
               make.top.equalTo(titleLabel.snp.bottom).offset(5)
               make.height.equalTo(25)
               make.width.equalTo(SCREEN.width * 0.9)
          }
          
          contentLabel = UILabel()
          contentLabel.numberOfLines = 0
          contentLabel.font = .systemFont(ofSize: 14)
          contentLabel.backgroundColor = .white
          bgView.addSubview(contentLabel)
          contentLabel.snp.makeConstraints { (make) in
               make.centerX.equalTo(bgView)
               make.top.equalTo(tagView.snp.bottom).offset(5)
               make.width.equalTo(SCREEN.width * 0.9)
          }
          
          let images = question.urlList ?? []
          let photoCVHeight = CGFloat(ceilf(Float(images.count) / 3) * 100)
          photoCollectionView = FBPhotoCollectionView(thumbUrls: question.thumbUrlList ?? [], urls: images)
          photoCollectionView.backgroundColor = .white
          bgView.addSubview(photoCollectionView)
          photoCollectionView.snp.makeConstraints { (make) in
               make.top.equalTo(contentLabel.snp.bottom).offset(5)
               make.width.equalTo(300)
               make.height.equalTo(photoCVHeight)
               make.centerX.equalTo(bgView)
          }
          
          timeLabel = UILabel()
          timeLabel.font = .systemFont(ofSize: 12)
          timeLabel.backgroundColor = .white
          bgView.addSubview(timeLabel)
          timeLabel.snp.makeConstraints { (make) in
               make.right.equalTo(bgView).offset(-10)
               make.top.equalTo(photoCollectionView.snp.bottom).offset(30)
          }
          
          usernameLabel = UILabel()
          usernameLabel.font = .systemFont(ofSize: 12)
          usernameLabel.backgroundColor = .white
          bgView.addSubview(usernameLabel)
          usernameLabel.snp.makeConstraints { (make) in
               make.right.equalTo(timeLabel.snp.left).offset(-5)
               make.centerY.equalTo(timeLabel)
          }
          
          userImgView = UIImageView()
          userImgView.backgroundColor = .white
          bgView.addSubview(userImgView)
          userImgView.image = UIImage(named: "feedback_user")
          userImgView.snp.makeConstraints { (make) in
               make.width.height.equalTo(20)
               make.right.equalTo(usernameLabel.snp.left).offset(-5)
               make.centerY.equalTo(timeLabel)
          }
          
          likesLabel = UILabel()
          likesLabel.backgroundColor = .white
          bgView.addSubview(likesLabel)
          likesLabel.font = .systemFont(ofSize: 12)
          likesLabel.snp.makeConstraints { (make) in
               make.top.equalTo(timeLabel.snp.bottom).offset(5)
               make.right.equalTo(titleLabel.snp.right)
          }
          
          likesImgView = UIImageView()
          likesImgView.backgroundColor = .white
          likesImgView.image = UIImage(named: "feedback_thumb_up")
          bgView.addSubview(likesImgView)
          likesImgView.snp.makeConstraints { (make) in
               make.right.equalTo(likesLabel.snp.left).offset(-5)
               make.width.height.equalTo(20)
               make.centerY.equalTo(likesLabel)
          }
          
          msgCntLabel = UILabel()
          msgCntLabel.backgroundColor = .white
          bgView.addSubview(msgCntLabel)
          msgCntLabel.font = .systemFont(ofSize: 12)
          msgCntLabel.snp.makeConstraints { (make) in
               make.right.equalTo(likesImgView.snp.left).offset(-5)
               make.centerY.equalTo(likesLabel)
          }
          
          msgImgView = UIImageView()
          msgImgView.backgroundColor = .white
          msgImgView.image = UIImage(named: "feedback_message")
          bgView.addSubview(msgImgView)
          msgImgView.snp.makeConstraints { (make) in
               make.width.height.equalTo(15)
               make.right.equalTo(msgCntLabel.snp.left).offset(-5)
               make.centerY.equalTo(likesLabel)
          }
          
          stLabel = UILabel()
          stLabel.font = .boldSystemFont(ofSize: 14)
          stLabel.backgroundColor = .white
          bgView.addSubview(stLabel)
          stLabel.snp.makeConstraints { (make) in
               make.left.equalTo(bgView).offset(10)
               make.centerY.equalTo(likesLabel)
          }
          
          
          titleLabel.text = question.name
          self.tags = (question.tags ?? []).sorted(by: { $0.id! < $1.id! })
          tagView.addDelegate(delegate: self, dataSource: self, isSelectedOnly: true)
          tagView.sizeToFit()
          contentLabel.text = question.datumDescription
          usernameLabel.text = question.username
          timeLabel.text = (question.createdAt?[0..<10] ?? "") + " " + (question.createdAt?[11..<16] ?? "")
          msgCntLabel.text = question.msgCount?.description
          msgCntLabel.sizeToFit()
          likesLabel.text = question.likes?.description ?? ""
          likesLabel.sizeToFit()
          stLabel.text = question.solved ?? 0 == 1 ? "校方已回复" : "校方未回复"
          stLabel.textColor = question.solved ?? 0 == 1 ? UIColor(hex6: 0x387a47) : .red
          
          frame = CGRect(x: 0, y: 0, width: SCREEN.width, height: 125 +
                            (question.name ?? "").getSuitableHeight(font: .boldSystemFont(ofSize: 20), setWidth: SCREEN.width * 0.9, numbersOfLines: 0)
                            + photoCVHeight +
                            (question.datumDescription ?? "").getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.9, numbersOfLines: 0))
     }
     
     override func layoutSubviews() {
          super.layoutSubviews()
          bgView.addShadow(.black, sRadius: 2, sOpacity: 0.2, offset: (1, 1))
     }
}

//MARK: - Delegate
extension FBDetailHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return tags.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as! FBTagCollectionViewCell
          cell.update(by: tags[indexPath.row], selected: true)
          return cell
     }
}


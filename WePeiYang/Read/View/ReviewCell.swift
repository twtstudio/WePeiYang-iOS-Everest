
//
//  Review.swift
//  CellAutolayout
//
//  Created by Halcao on 2016/10/24.
//  Copyright © 2016年 Halcao. All rights reserved.
//

import UIKit
import SnapKit

class ReviewCell: UITableViewCell {
    var avatar: UIImageView = UIImageView()
    var content: UILabel = UILabel()
    var username: UILabel = UILabel()
    var rateView: StarView! = nil
    var timestamp: UILabel = UILabel()
    var heartView: UIImageView = UIImageView()
    var like: UILabel = UILabel()
    let separator = UIView()
    let fooView = UIView()

    
    private let bigiPhoneWidth: CGFloat = 414.0
    private let kAVATAR_HEIGHT = 45
    
    convenience init(model: Review) {
        self.init()
        self.content.attributedText = attributedString(model.bookName, content: model.content)
        self.avatar.setImageWithURL(NSURL(string: model.avatarURL)!, placeholderImage: UIImage(named: "readerAvatar1"))
        //self.like.text = model.like
        self.timestamp.text = model.updateTime

        self.rateView = StarView(rating: model.rating, height: 15, tappable: false)

        self.username.text = model.userName
        
        // 用like的tag存储点赞个数
        like.tag = model.like
        self.like.text = String(format: "%02d", self.like.tag)
        contentView.tag = model.reviewID
        // 如果点过赞 记录之
        heartView.tag = model.liked ? 1 : 0
        
        // imgView tag
        imageView?.tag = 0
        
        
        fooView.addSubview(heartView)
        fooView.addSubview(like)
        
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(content)
        self.contentView.addSubview(username)
        self.contentView.addSubview(rateView)
        self.contentView.addSubview(timestamp)
        //        self.contentView.addSubview(heartView)
        //        self.contentView.addSubview(like)
        self.contentView.addSubview(separator)
        self.contentView.addSubview(fooView)
        
        
        self.contentView.backgroundColor = UIColor(red:0.99, green:0.99, blue:1.00, alpha:1.00)
        // let frame = avatar.frame
        // avatar.frame = CGRectMake(frame.origin.x, frame.origin.y, 45, 45)
        avatar.snp_makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(15)
            make.height.equalTo(kAVATAR_HEIGHT)
            make.width.equalTo(kAVATAR_HEIGHT)
        }
        
        avatar.layer.cornerRadius = CGFloat(kAVATAR_HEIGHT/2)
        avatar.layer.masksToBounds = true
        
        username.font = UIFont.systemFontOfSize(14)
        username.textColor = UIColor.init(red: 151/255, green: 152/255, blue: 153/255, alpha: 1)
        username.sizeToFit()
        username.snp_makeConstraints { make in
            make.left.equalTo(avatar.snp_right).offset(10)
            make.top.equalTo(contentView).offset(15)
        }
        
        rateView.snp_makeConstraints { make in
            make.top.equalTo(username.snp_bottom).offset(3)
            make.left.equalTo(avatar.snp_right).offset(10)
        }
        
        let width = UIScreen.mainScreen().bounds.size.width
        
        if width >= bigiPhoneWidth {
            content.font = UIFont.systemFontOfSize(16)
        } else {
            content.font = UIFont.systemFontOfSize(14)
        }
        
        content.preferredMaxLayoutWidth = width - 40;
        content.lineBreakMode = NSLineBreakMode.ByWordWrapping
        // content.font = UIFont.systemFontOfSize(16)
        content.numberOfLines = 0
        //content.textColor = UIColor(red:0, green:0, blue:0, alpha:0.8)
        content.sizeToFit()
        content.snp_makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(avatar.snp_bottom).offset(10)
            make.right.equalTo(contentView).offset(-20)
            //make.bottom.equalTo(contentView).offset(-40)
        }
        
        timestamp.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        if #available(iOS 8.2, *) {
            timestamp.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        } else {
            // Fallback on earlier versions
        }
        timestamp.sizeToFit()
        timestamp.snp_makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(content.snp_bottom).offset(10)
            make.bottom.equalTo(contentView).offset(-20)
        }
        
        if #available(iOS 8.2, *) {
            like.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        } else {
            // Fallback on earlier versions
        }
        
        
        fooView.snp_makeConstraints { make in
            make.centerY.equalTo(timestamp.snp_centerY)
            make.right.equalTo(contentView).offset(-12)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
       // fooView.userInteractionEnabled = model.liked ? false : true
        fooView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.likeTapped)))
        like.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        like.snp_makeConstraints { make in
            make.top.equalTo(fooView).offset(8)
            make.left.equalTo(fooView).offset(12)
            
        }
        
        heartView.image = UIImage(named: model.liked ? "red_heart" : "grey_heart")
        heartView.snp_makeConstraints { make in
            make.right.equalTo(like.snp_left).offset(-3)
            // make.top.equalTo(contentView).offset(16)
            make.centerY.equalTo(like.snp_centerY)
            //make.height.equalTo(14)
            //make.width.equalTo(15)
            make.height.equalTo(12)
            make.width.equalTo(13)
        }
        
        
        separator.backgroundColor = UIColor.init(red: 227/255, green: 227/255, blue: 229/255, alpha: 1)
        separator.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.bottom.equalTo(contentView).offset(0)
        }
        
        
    }
    
    func likeTapped() {
        
        
        if self.heartView.tag == 0 {

            User.sharedInstance.like(.Like, reviewID: "\(contentView.tag)") {
                self.like.tag += 1
                let frame = self.heartView.frame
                let width = frame.size.width
                let height = frame.size.height
                self.heartView.frame = CGRect(x: self.heartView.frame.origin.x - width/2 , y: self.heartView.frame.origin.y - height/2, width: self.heartView.frame.size.width*2, height: self.heartView.frame.size.height*2)
                UIView.animateWithDuration(0.25, animations: {
                self.heartView.image = UIImage(named: "red_heart")
                self.like.text = String(format: "%02d", self.like.tag)
                self.heartView.frame = frame
                self.heartView.tag = 1
                // self.fooView.userInteractionEnabled = false
                })
            }
        } else if self.heartView.tag == 1 {
            User.sharedInstance.like(.CancelLike, reviewID: "\(contentView.tag)") {
                self.like.tag -= 1
                self.like.text = String(format: "%02d", self.like.tag)
                self.heartView.image = UIImage(named: "grey_heart")
                self.heartView.tag = 0
            }
        }
        
    }
    
    func attributedString(title: String, content: String) -> NSMutableAttributedString {
        let fooString = "《\(title)》\(content)"
        let mutableAttributedString = NSMutableAttributedString(string: fooString)
        let bookTitleColor = UIColor(red:0.87, green:0.31, blue:0.22, alpha:1.00)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: bookTitleColor,range: NSRange(location:0, length: title.characters.count+2))
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSRange(location:title.characters.count+2, length: content.characters.count))
        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 14.0)!, range: NSRange(location: 0, length: fooString.characters.count))
        
        return mutableAttributedString
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


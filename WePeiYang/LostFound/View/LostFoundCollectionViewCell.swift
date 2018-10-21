//
//  LostFoundCollectionViewCell.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SDWebImage

class LostFoundCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var markLabel: UILabel!
    var timeLabel: UILabel!
    var placeLabel: UILabel!
    var pictureImageView: UIImageView!
    var markImageView: UIImageView!
    var timeImageView: UIImageView!
    var placeImageView: UIImageView!
    var markArray = ["身份证", "饭卡", "手机", "钥匙", "书包", "手表&饰品", "U盘&硬盘", "水杯", "钱包", "银行卡", "书", "伞", "其他"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        markLabel = UILabel()
        timeLabel = UILabel()
        placeLabel = UILabel()
        pictureImageView = UIImageView()
        markImageView = UIImageView()
        timeImageView = UIImageView()
        placeImageView = UIImageView()
        self.backgroundColor = UIColor.white
        pictureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 170))
        pictureImageView.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(markLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(placeLabel)
        contentView.addSubview(pictureImageView)
        contentView.addSubview(markImageView)
        contentView.addSubview(timeImageView)
        contentView.addSubview(placeImageView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .darkGray
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        
        //        pictureImageView.snp.makeConstraints { make in
        //            make.top.equalToSuperview().offset(10)
        //            make.centerX.equalToSuperview()
        //            make.width.height.equalTo(contentView.bounds.width)
        //        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(175)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            //            make.bottom.equalTo(markImageView.snp.top).offset(-5)
        }
        
        markImageView.image = #imageLiteral(resourceName: "物品")
        markImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            //            make.bottom.equalTo(timeImageView.snp.top)//.offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/12))
        }
        
        markLabel.numberOfLines = 0
        markLabel.font = UIFont.systemFont(ofSize: 13)
        markLabel.textColor = UIColor(hex6: 0x999999)
        markLabel.snp.makeConstraints { make in
            make.top.equalTo(markImageView.snp.top)//.offset(5)
            make.left.equalTo(markImageView.snp.right).offset(10)
            //            make.bottom.equalTo(timeLabel.snp.top).offset(-5)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(contentView.bounds.width*(1/12))
        }
        
        timeImageView.snp.makeConstraints { make in
            make.top.equalTo(markImageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            //            make.bottom.equalTo(placeImageView.snp.top).offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/12))
        }
        timeImageView.image = #imageLiteral(resourceName: "时间")
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = UIColor(hex6: 0x999999)
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeImageView.snp.top)//.offset(5)
            make.left.equalTo(timeImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(contentView.bounds.width*(1/12))
            //            make.height.equalTo(20)
        }
        
        placeImageView.image = #imageLiteral(resourceName: "地点")
        placeImageView.snp.makeConstraints { make in
            make.top.equalTo(timeImageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/12))
        }
        
        placeLabel.numberOfLines = 1
        placeLabel.textColor = UIColor(hex6: 0x999999)
        placeLabel.font = UIFont.systemFont(ofSize: 13)
        //        placeLabel.sizeToFit()
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(placeImageView.snp.top)//.offset(5)
            make.left.equalTo(placeImageView.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(contentView.bounds.width*(1/12))
        }
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(pic: String, title: String, mark: Int, time: String, place: String) {
        if pic != "", let picURL = URL(string: TWT_URL + pic) {
            pictureImageView.sd_setImage(with: picURL)
        } else {
            let picURL = "暂无图片"
            pictureImageView.image = UIImage(named: picURL)
        }
        pictureImageView.contentMode = .scaleAspectFill
        
        titleLabel.text = title
        //        titleLabel.sizeToFit()
        
        markLabel.text = markArray[mark - 1]
        //        markLabel.sizeToFit()
        
        timeLabel.text = time
        //        timeLabel.sizeToFit()
        
        placeLabel.text = place
        //        placeLabel.sizeToFit()
    }
    
}

//
//  LostFound.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/17.
//  Copyright © 2017年 twtstudio. All rights reserved.
//



import UIKit
import SnapKit
import SDWebImage

class LostFoundCollectionViewCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    var nameLabel = UILabel()
    var timeLabel = UILabel()
    var placeLabel = UILabel()
    var pictureImage = UIImageView()
    var markImage = UIImageView()
    var timeImage = UIImageView()
    var placeImage = UIImageView()
    
    
    
    
    
    override init(frame: CGRect){
        
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(titleLabel)
        self.addSubview(nameLabel)
        self.addSubview(timeLabel)
        self.addSubview(placeLabel)
        self.addSubview(pictureImage)
        self.addSubview(markImage)
        self.addSubview(timeImage)
        self.addSubview(placeImage)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(pic: URL, title: String, mark: Int, time: String, place: String){
        
        
        pictureImage.sd_setImage(with: pic)
        pictureImage.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(0.1)
            make.left.equalToSuperview()//.offset(10)
            make.right.equalToSuperview()//.offset(-5)
            make.height.equalTo(170)
            
            
        }
        
        titleLabel.text = title
        titleLabel.numberOfLines = 0
//                titleLable.preferredMaxLayoutWidth = contentView.bounds.width
//                titleLable.font = UIFont.italicSystemFont(ofSize: 10)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(175)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalTo(markImage.snp.top).offset(-5)
            
        }
        
        nameLabel.text = "\(mark)"
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.textColor = UIColor(hex6: 0x999999)
        nameLabel.snp.makeConstraints{
            
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(markImage.snp.right).offset(10)
            make.bottom.equalTo(timeLabel.snp.top).offset(-5)
            
        }
        markImage.image = #imageLiteral(resourceName: "物品")
        markImage.snp.makeConstraints{
            
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalTo(timeImage.snp.top).offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/12))
        }
        
        timeImage.image = #imageLiteral(resourceName: "时间")
        timeImage.snp.makeConstraints{
            
            make in
            make.top.equalTo(markImage.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalTo(placeImage.snp.top).offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/12))
        }
        
        timeLabel.text = time
        timeLabel.numberOfLines = 0
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = UIColor(hex6: 0x999999)
        timeLabel.snp.makeConstraints{
            
            make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(timeImage.snp.right).offset(10)
        }
        
        placeImage.image = #imageLiteral(resourceName: "地点")
        placeImage.snp.makeConstraints{
            
            make in
            make.top.equalTo(timeImage.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/12))
        }
        
        placeLabel.text = place
        placeLabel.numberOfLines = 0
        placeLabel.textColor = UIColor(hex6: 0x999999)
        placeLabel.font = UIFont.systemFont(ofSize: 13)
        placeLabel.snp.makeConstraints{
            
            make in
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.left.equalTo(placeImage.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-5)
        
        }
        
        
    }
    
    
}







//
//  LostFoundCollectionViewCell.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/2.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class LostFoundCollectionViewCell: UICollectionViewCell {
    
    var titleLable = UILabel()
    var nameLabel = UILabel()
    var timeLabel = UILabel()
    var placeLabel = UILabel()
    var pictureImage = UIImageView()
    var markImage = UIImageView()
    var timeImage = UIImageView()
    var placeImage = UIImageView()
//    let screenWidth = UIScreen.main.bounds.width
    
    

    
   override init(frame: CGRect){
   
        super.init(frame: frame)
        
//        title = UILabel(frame: CGRect(x:30, y: 0, width: UIScreen.main.bounds.width, height: 50))
//    
//        title.textColor = UIColor.black
        self.backgroundColor = UIColor.white
    
        self.addSubview(titleLable)
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

    func initUI(pic: String, title: String, mark: String, time: String, place: String){
        
        
        
//      pictureImage.sd_setImage(with: pic)
        
        
        let image = UIImage(named: pic)
        pictureImage.image = image
        
        let imageHeight = image?.size.height ?? 200
        let imageWidth = image?.size.width ?? 200
        let width: CGFloat = UIScreen.main.bounds.size.width/2-10
        let ratio = imageWidth/width
        let height = imageHeight/ratio
        pictureImage.contentMode = .scaleAspectFit

        pictureImage.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(0.1)
            make.left.equalToSuperview()//.offset(10)
            make.right.equalToSuperview()//.offset(-5)
            make.height.equalTo(height)
//            make.wi
//            make.bottom.equalTo(titleLable.snp.top).offset(-50)
//            make.width.height.equalTo(contentView.bounds.width*(3/5))

        }
        
        titleLable.text = title
        titleLable.numberOfLines = 0
//        titleLable.preferredMaxLayoutWidth = contentView.bounds.width
//        titleLable.font = UIFont.italicSystemFont(ofSize: 10)
        titleLable.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(height+10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalTo(markImage.snp.top).offset(-5)
            
        }
        
        nameLabel.text = mark
        nameLabel.numberOfLines = 0
        nameLabel.snp.makeConstraints{
            
            make in
            make.top.equalTo(titleLable.snp.bottom).offset(5)
            make.left.equalTo(markImage.snp.right).offset(10)
            make.bottom.equalTo(timeLabel.snp.top).offset(-5)
        
        }
        markImage.image = #imageLiteral(resourceName: "物品")
        markImage.snp.makeConstraints{
            
            make in
            make.top.equalTo(titleLable.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalTo(timeImage.snp.top).offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/8))
        }
        
        timeImage.image = #imageLiteral(resourceName: "时间")
        timeImage.snp.makeConstraints{
            
            make in
            make.top.equalTo(markImage.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalTo(placeImage.snp.top).offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/8))
        }
        
        timeLabel.text = time
        timeLabel.numberOfLines = 0
        timeLabel.snp.makeConstraints{
            
            make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(timeImage.snp.right).offset(10)
        }
        
        placeImage.image = #imageLiteral(resourceName: "地点")
        placeImage.snp.makeConstraints{
            
            make in
            make.top.equalTo(timeImage.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/8))
        }
        
        placeLabel.text = place
        placeLabel.numberOfLines = 0
        placeLabel.snp.makeConstraints{
            
            make in
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.left.equalTo(placeImage.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-5)
        
        }
        
    
    }
    

    
    

    
    
}

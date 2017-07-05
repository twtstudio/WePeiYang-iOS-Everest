//
//  MyLostFoundTableViewCell.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/4.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class MyLostFoundTableViewCell: UITableViewCell {
    
    var pictureImage = UIImageView()
    var titleLabel = UILabel()
    var isBackLabel = UILabel()
    var timeLabel = UILabel()
    var placeLabel = UILabel()
    var markLabel = UILabel()
    var markImage = UIImageView()
    var timeImage = UIImageView()
    var placeImage = UIImageView()
    
    override var frame: CGRect{
        
        didSet{
            
            var newFrame = frame;
            
            newFrame.origin.x += 10/2;
            newFrame.size.width -= 10;
            newFrame.origin.y += 10;
            newFrame.size.height -= 10;
            super.frame = newFrame;
            
        }
        
        
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(pictureImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(isBackLabel)
        contentView.addSubview(timeImage)
        contentView.addSubview(placeImage)
        contentView.addSubview(markImage)
        contentView.addSubview(markLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(placeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initMyUI(pic: String, title: String, isBack: String, mark: String, time: String, place: String){
        
        let image = UIImage(named: pic)
        pictureImage.image = image
        pictureImage.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(contentView.bounds.width*(100/400)+50)
            make.bottom.equalToSuperview().offset(-10)
        
        }
        
        isBackLabel.text = isBack
        isBackLabel.numberOfLines = 1
        isBackLabel.font = UIFont.italicSystemFont(ofSize: 20)
        isBackLabel.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(pictureImage.snp.right).offset(10)
        
        }
        
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints{
            make in
            make.top.equalTo(isBackLabel.snp.bottom).offset(5)
            make.left.equalTo(pictureImage.snp.right).offset(10)
            
        }
        
        markImage.image = #imageLiteral(resourceName: "物品")
        markImage.snp.makeConstraints{
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(pictureImage.snp.right).offset(10)
            make.width.height.equalTo(contentView.bounds.width*(100/2024))
        }
        
        markLabel.text = mark
        markLabel.font = UIFont.italicSystemFont(ofSize: 14)
        markLabel.textColor = UIColor(hex6: 0x999999)
        markLabel.numberOfLines = 1
        markLabel.snp.makeConstraints{
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(markImage.snp.right).offset(3)
    
        
        }
        
        timeImage.image = #imageLiteral(resourceName: "时间")
        timeImage.snp.makeConstraints{
            make in
            make.top.equalTo(markImage.snp.bottom).offset(5)
            make.left.equalTo(pictureImage.snp.right).offset(10)
            make.width.height.equalTo(contentView.bounds.width*(100/2024))
        }
        
        timeLabel.text = time
        timeLabel.font = UIFont.italicSystemFont(ofSize: 14)
        timeLabel.textColor = UIColor(hex6: 0x999999)
        timeLabel.numberOfLines = 1
        timeLabel.snp.makeConstraints{
            make in
            make.top.equalTo(markImage.snp.bottom).offset(5)
            make.left.equalTo(timeImage.snp.right).offset(3)
        
        }
        
        placeImage.image = #imageLiteral(resourceName: "地点")
        placeImage.snp.makeConstraints{
            make in
            make.top.equalTo(timeImage.snp.bottom).offset(5)
            make.left.equalTo(pictureImage.snp.right).offset(10)
            make.width.height.equalTo(contentView.bounds.width*(100/2024))
            make.bottom.equalToSuperview().offset(-15)
        }
        
        placeLabel.text = place
        placeLabel.font = UIFont.italicSystemFont(ofSize: 14)
        placeLabel.textColor = UIColor(hex6: 0x999999)
        placeLabel.numberOfLines = 1
        placeLabel.snp.makeConstraints{
            make in
            make.top.equalTo(timeImage.snp.bottom).offset(5)
            make.left.equalTo(placeImage.snp.right).offset(3)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

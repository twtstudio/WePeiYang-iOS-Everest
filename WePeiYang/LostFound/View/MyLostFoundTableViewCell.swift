//
//  MyLostFoundTableViewCell.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/4.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class MyLostFoundTableViewCell: UITableViewCell {
    
    var pictureImageView = UIImageView()
    var titleLabel = UILabel()
    var isBackLabel = UILabel()
    var timeLabel = UILabel()
    var placeLabel = UILabel()
    var markLabel = UILabel()
    var markImageView = UIImageView()
    var timeImageView = UIImageView()
    var placeImageView = UIImageView()
    var editButton = UIButton()
    var reversalButton = UIButton()
    var reversal = ""

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
        
        contentView.addSubview(pictureImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(isBackLabel)
        contentView.addSubview(timeImageView)
        contentView.addSubview(placeImageView)
        contentView.addSubview(markImageView)
        contentView.addSubview(markLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(placeLabel)
        contentView.addSubview(editButton)
        contentView.addSubview(reversalButton)



    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initMyUI(pic: URL, title: String, isBack: Int, mark: Int, time: String, place: String) {
        
//        let image = UIImage(named: pic)
//        pictureImage.image = image
        pictureImageView.sd_setImage(with: pic)
        pictureImageView.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(contentView.bounds.width*(100/400)+50)
            make.bottom.equalToSuperview().offset(-10)
        
        }
        if isBack == 0{
            isBackLabel.text = "未找到!"
        } else {
            isBackLabel.text = "已找到!"
        }
        isBackLabel.numberOfLines = 1
        isBackLabel.font = UIFont.italicSystemFont(ofSize: 20)
        isBackLabel.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(pictureImageView.snp.right).offset(10)
        
        }
        
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints{
            make in
            make.top.equalTo(isBackLabel.snp.bottom).offset(5)
            make.left.equalTo(pictureImageView.snp.right).offset(10)
            
        }
        
        markImageView.image = #imageLiteral(resourceName: "物品")
        markImageView.snp.makeConstraints{
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(pictureImageView.snp.right).offset(10)
            make.width.height.equalTo(contentView.bounds.width*(100/2024))
        }

        switch mark {
        case 1:
            markLabel.text = "身份证"
        case 2:
            markLabel.text = "饭卡"
        case 3:
            markLabel.text = "手机"
        case 4:
            markLabel.text = "钥匙"
        case 5:
            markLabel.text = "书包"
        case 6:
            markLabel.text = "手表&饰品"
        case 7:
            markLabel.text = "水杯"
        case 8:
            markLabel.text = "U盘&硬盘"
        case 9:
            markLabel.text = "钱包"
        case 10:
            markLabel.text = "银行卡"
        case 11:
            markLabel.text = "书"
        case 12:
            markLabel.text = "伞"
        case 13:
            markLabel.text = "其他"
        default:
            markLabel.text = ""
        }
//        markLabel.text = mark
        markLabel.font = UIFont.italicSystemFont(ofSize: 14)
        markLabel.textColor = UIColor(hex6: 0x999999)
        markLabel.numberOfLines = 1
        markLabel.snp.makeConstraints{
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(markImageView.snp.right).offset(3)
    
        
        }
        
        timeImageView.image = #imageLiteral(resourceName: "时间")
        timeImageView.snp.makeConstraints{
            make in
            make.top.equalTo(markImageView.snp.bottom).offset(5)
            make.left.equalTo(pictureImageView.snp.right).offset(10)
            make.width.height.equalTo(contentView.bounds.width*(100/2024))
        }
        
        timeLabel.text = time
        timeLabel.font = UIFont.italicSystemFont(ofSize: 14)
        timeLabel.textColor = UIColor(hex6: 0x999999)
        timeLabel.numberOfLines = 1
        timeLabel.snp.makeConstraints{
            make in
            make.top.equalTo(markImageView.snp.bottom).offset(5)
            make.left.equalTo(timeImageView.snp.right).offset(3)
        
        }
        
        placeImageView.image = #imageLiteral(resourceName: "地点")
        placeImageView.snp.makeConstraints{
            make in
            make.top.equalTo(timeImageView.snp.bottom).offset(5)
            make.left.equalTo(pictureImageView.snp.right).offset(10)
            make.width.height.equalTo(contentView.bounds.width*(100/2024))
            make.bottom.equalToSuperview().offset(-15)
        }
        
        placeLabel.text = place
        placeLabel.font = UIFont.italicSystemFont(ofSize: 14)
        placeLabel.textColor = UIColor(hex6: 0x999999)
        placeLabel.numberOfLines = 1
        placeLabel.snp.makeConstraints{
            make in
            make.top.equalTo(timeImageView.snp.bottom).offset(5)
            make.left.equalTo(placeImageView.snp.right).offset(3)
            make.bottom.equalToSuperview().offset(-15)
        }

//        editButton.setBackgroundImage(UIImage(named: "笔"), for: .normal)
        editButton.setImage(UIImage(named: "笔"), for: .normal)

        editButton.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
//            make.width.height.equalTo(contentView.bounds.width*(100/1560))
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        editButton.imageView?.snp.makeConstraints {
            make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        
        }
        
        
        if isBack == 0 {
            reversal = "灰勾"
        }
        else {
            reversal = "蓝勾"
        }
        reversalButton.setBackgroundImage(UIImage(named: reversal), for: .normal)
        reversalButton.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(isBackLabel.snp.right).offset(10)
            make.bottom.equalTo(titleLabel.snp.top).offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(100/2024))
            
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

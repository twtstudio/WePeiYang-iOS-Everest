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
    
    var titleLabel: UILabel!
    var markLabel: UILabel!
    var timeLabel: UILabel!
    var placeLabel: UILabel!
    var pictureImageView: UIImageView!
    var markImageView: UIImageView!
    var timeImageView: UIImageView!
    var placeImageView: UIImageView!
    var markArray = ["身份证","饭卡","手机","钥匙","书包","手表&饰品","U盘&硬盘","水杯","钱包","银行卡","书","伞","其他"]
    
    
    
    
    override init(frame: CGRect){
        
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
        pictureImageView
            .clipsToBounds = true

        
        self.addSubview(titleLabel)
        self.addSubview(markLabel)
        self.addSubview(timeLabel)
        self.addSubview(placeLabel)
        self.addSubview(pictureImageView)
        self.addSubview(markImageView)
        self.addSubview(timeImageView)
        self.addSubview(placeImageView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func initUI(pic: String, title: String, mark: Int, time: String, place: String){
        

        if pic != "", let picURL = URL(string: TWT_URL + pic) {
            pictureImageView.sd_setImage(with: picURL)
        } else {
            let picURL = "暂无图片"
            pictureImageView.image = UIImage(named: picURL)
        }
        pictureImageView.contentMode = .scaleAspectFill

        
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
            make.bottom.equalTo(markImageView.snp.top).offset(-5)
            
        }

        print(mark)
        markLabel.text = markArray[mark - 1]
        markLabel.numberOfLines = 0
        markLabel.font = UIFont.systemFont(ofSize: 13)
        markLabel.textColor = UIColor(hex6: 0x999999)
        markLabel.snp.makeConstraints{
            
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(markImageView.snp.right).offset(10)
            make.bottom.equalTo(timeLabel.snp.top).offset(-5)
            make.right.equalToSuperview().offset(0.1)
            
        }
        
        markImageView.image = #imageLiteral(resourceName: "物品")
        markImageView.snp.makeConstraints{
            
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalTo(timeImageView.snp.top).offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/12))
            
        }
        
        timeImageView.image = #imageLiteral(resourceName: "时间")
        timeImageView.snp.makeConstraints{
            
            make in
            make.top.equalTo(markImageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalTo(placeImageView.snp.top).offset(-5)
            make.width.height.equalTo(contentView.bounds.width*(1/12))
        }
        
        timeLabel.text = time
        timeLabel.numberOfLines = 0
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = UIColor(hex6: 0x999999)
        timeLabel.snp.makeConstraints{
            
            make in
            make.top.equalTo(markLabel.snp.bottom).offset(5)
            make.left.equalTo(timeImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(0.1)
        }
        
        placeImageView.image = #imageLiteral(resourceName: "地点")
        placeImageView.snp.makeConstraints{
            
            make in
            make.top.equalTo(timeImageView.snp.bottom).offset(5)
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
            make.left.equalTo(placeImageView.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(0.1)
        
        }
        
        
    }
    
    
}







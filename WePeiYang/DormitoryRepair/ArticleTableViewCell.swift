//
//  ArticleTableViewCell.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2017/9/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    var itemDetailInformationLabel: UILabel!
    var itemImageView: UIImageView!
    var locationImageView: UIImageView!
    var itemLabel: UILabel!
    var locationLabel: UILabel!
    var dateLabel: UILabel!
    var progressLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        itemDetailInformationLabel = UILabel()
        itemImageView = UIImageView(image: ImageData.itemImage)
        locationImageView = UIImageView(image: ImageData.locationImage)
        itemLabel = UILabel()
        locationLabel = UILabel()
        dateLabel = UILabel()
        progressLabel = UILabel()
        
        contentView.addSubview(itemDetailInformationLabel)
        contentView.addSubview(itemImageView)
        contentView.addSubview(locationImageView)
        contentView.addSubview(itemLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(progressLabel)
        
        
        progressLabel.snp.makeConstraints { make in
            make.right.equalTo(-2)
            make.bottom.equalTo(-2)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        progressLabel.text = "已接受"
        progressLabel.font = UIFont.systemFont(ofSize: 12)
        progressLabel.textColor = UIColor(red: 0.55, green: 0.78, blue: 0.59, alpha: 1.00)
        progressLabel.backgroundColor = UIColor.white
        
        itemLabel.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.top.equalTo(32)
        }
        itemLabel.text = "卫生间踩踏板"
        itemLabel.font = UIFont.systemFont(ofSize: 12)
        itemLabel.textColor = UIColor.black
        itemLabel.backgroundColor = UIColor.white
        itemLabel.alpha = 0.5
        
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.height.equalTo(20)
            make.width.equalTo(250)
            make.top.equalTo(57)
        }
        locationLabel.text = "诚园7斋B栋3楼"
        locationLabel.font = UIFont.systemFont(ofSize: 12)
        locationLabel.textColor = UIColor.black
        locationLabel.backgroundColor = UIColor.white
        locationLabel.alpha = 0.5
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-2)
            make.left.equalTo(5)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        dateLabel.text = "2017-05-12"
        dateLabel.textColor = UIColor.black
        dateLabel.backgroundColor = UIColor.white
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.alpha = 0.5
        
        
        
        itemDetailInformationLabel.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.top.equalTo(5)
            make.height.equalTo(20)
            make.right.equalTo(-5)
        }
        itemDetailInformationLabel.text = "三楼楼道靠近楼梯口的路由器坏了时断时续时断时续"
        itemDetailInformationLabel.textColor = UIColor.black
        itemDetailInformationLabel.backgroundColor = UIColor.white
        itemDetailInformationLabel.font = UIFont.systemFont(ofSize: 13)
        itemDetailInformationLabel.alpha = 0.8
        
        itemImageView.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.height.equalTo(13)
            make.width.equalTo(13)
            make.top.equalTo(35)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.height.equalTo(13)
            make.width.equalTo(13)
            make.top.equalTo(60)
        }
        
        
        self.selectionStyle = .none
        
    }
    
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.origin.x += 6
            newFrame.size.width -= 12
            newFrame.origin.y -= 30
            newFrame.size.height -= 6
            self.layer.masksToBounds = true;
            self.layer.cornerRadius = 5;
            super.frame = newFrame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

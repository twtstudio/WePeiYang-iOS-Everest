//
//  SearchResultTableViewCell.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/21.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class SearchResultTableViewCell: UITableViewCell {
    
    var foodImageView: UIImageView!
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        label.textAlignment = .left
        label.text = "水煮鱼"
        label.textColor = .black
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.textAlignment = .left
        label.text = "竹园餐厅（学四）二层1窗口"
        label.textColor = .black
        return label
    }()
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.textAlignment = .left
        label.text = "综合评分："
        label.textColor = .black
        return label
    }()
    
    let openingHoursLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.textAlignment = .left
        label.text = "营业时间："
        label.textColor = .black
        return label
    }()
    
    let buttonImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .orange
        return imgView
    }()
    
    let commentImageView: UIImageView = {
        let img = UIImage(named: "btn_4快速点评_n")
        let imgView = UIImageView()
        imgView.image = img?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imgView.tintColor = .white
        imgView.backgroundColor = .clear
        return imgView
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.text = "点评"
        label.textColor = .white
        return label

    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        foodImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 110, height: 110))
        foodImageView.backgroundColor = .red
        contentView.addSubview(foodImageView)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(openingHoursLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(foodImageView.snp.right).offset(10)
            make.top.equalToSuperview().inset(15)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(foodImageView.snp.right).offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(10)
            make.width.equalTo(200)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.left.equalTo(foodImageView.snp.right).offset(10)
            make.top.equalTo(locationLabel.snp.bottom).offset(15)
            make.height.equalTo(10)
            make.width.equalTo(75)
        }
        
        openingHoursLabel.snp.makeConstraints { make in
            make.left.equalTo(foodImageView.snp.right).offset(10)
            make.top.equalTo(rateLabel.snp.bottom).offset(15)
            make.height.equalTo(10)
            make.width.equalTo(75)
        }
        
        contentView.addSubview(buttonImageView)
        contentView.addSubview(commentImageView)
        contentView.addSubview(commentLabel)
        buttonImageView.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(65)
        }
        commentImageView.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.right.equalToSuperview().inset(20)
            make.height.width.equalTo(25)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(commentImageView.snp.bottom).offset(10)
            make.centerX.equalTo(commentImageView.snp.centerX)
            make.width.equalTo(30)
            make.height.equalTo(10)
        }
        
    }
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            newFrame.size.height -= 10
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 2
            super.frame = newFrame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

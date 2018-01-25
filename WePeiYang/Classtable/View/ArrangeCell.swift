//
//  ArrangeCell.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/24.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class ArrangeCell: UITableViewCell {
    var arrangeNo = 1
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let locationLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        contentView.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.98, alpha:1.00)
        contentView.layer.cornerRadius = 4
        contentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
            make.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.00)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19.5)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.textColor = UIColor(red:0.37, green:0.37, blue:0.37, alpha:1.00)
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.height.equalTo(19.5)
        }

        contentView.addSubview(locationLabel)
        locationLabel.textColor = UIColor(red:0.37, green:0.37, blue:0.37, alpha:1.00)
        locationLabel.font = UIFont.systemFont(ofSize: 15)
        locationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.height.equalTo(19.5)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func load(model: ClassModel, no: Int) {
        titleLabel.text = "上课时间 " + no.description
        let weekRange = model.weekStart + "-" + model.weekEnd + "周"
        var time = ""
        if let arrange = model.arrange.first {
            let week = arrange.week == "单双周" ? "每周" : model.arrange.first!.week
            time = week
            var mandarinWeek = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
            if arrange.day >= 1 && arrange.day <= 7 {
                let day = mandarinWeek[arrange.day]
                time += day
            }
            let timeRange = arrange.start.description + "-" + arrange.end.description + "节"
            time += timeRange
            locationLabel.text = arrange.room
        }
        dateLabel.text =  weekRange + "，" + time
        
        titleLabel.sizeToFit()
        dateLabel.sizeToFit()
        locationLabel.sizeToFit()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

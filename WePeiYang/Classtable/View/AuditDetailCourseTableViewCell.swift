//
//  AuditDetailCourseTableViewCell.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/20.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class AuditDetailCourseTableViewCell: UITableViewCell {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = ""
        return label
    }()
    
    var teacherLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = ""
        return label
    }()
    
    var collegeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = ""
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = ""
        return label
    }()
    
    var weekTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = ""
        return label
    }()
    
    var dayTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = ""
        return label
    }()
    
    var flagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "[课程冲突：择业指导]"
        label.textColor = .red
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(teacherLabel)
        contentView.addSubview(collegeLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(weekTimeLabel)
        contentView.addSubview(dayTimeLabel)
        contentView.addSubview(flagLabel)
        
        teacherLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dayTimeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        weekTimeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        teacherLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
            //make.width.equalTo(160)
        }
        collegeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(teacherLabel.snp.top)
            make.height.equalTo(20)
            make.left.equalTo(teacherLabel.snp.right).offset(10)
        }
        locationLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(weekTimeLabel.snp.top)
            make.height.equalTo(20)
            make.left.equalTo(weekTimeLabel.snp.right).offset(10)
        }
        weekTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(teacherLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
            //make.width.equalTo(160)
        }
        dayTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(weekTimeLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
            //make.width.equalTo(160)
        }
        flagLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(dayTimeLabel.snp.top)
            make.height.equalTo(20)
            make.left.equalTo(dayTimeLabel.snp.right).offset(10)
        }
        
        teacherLabel.sizeToFit()
        weekTimeLabel.sizeToFit()
        dayTimeLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

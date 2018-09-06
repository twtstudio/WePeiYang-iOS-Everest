//
//  AuditClassCell.swift
//  WePeiYang
//
//  Created by Tigris on 4/26/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class AuditClassCell: UITableViewCell {
    var courseName = UILabel()
    var teacherName = UILabel()
    var weekInfo = UILabel()
    var timeInfo = UILabel()
    var collegeInfo = UILabel()
    var classroomInfo = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(courseName)
        self.contentView.addSubview(teacherName)
        self.contentView.addSubview(weekInfo)
        self.contentView.addSubview(timeInfo)
        self.contentView.addSubview(collegeInfo)
        self.contentView.addSubview(classroomInfo)

        courseName.textColor = UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)
        courseName.numberOfLines = 1
        courseName.textAlignment = .left
        courseName.font = UIFont.boldSystemFont(ofSize: 22)

        teacherName.textColor = UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)
        teacherName.numberOfLines = 1
        teacherName.textAlignment = .left

        weekInfo.textColor = .black
        weekInfo.numberOfLines = 1
        weekInfo.textAlignment = .left

        timeInfo.textColor = .black
        timeInfo.numberOfLines = 1
        timeInfo.textAlignment = .right

        collegeInfo.textColor = UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)
        collegeInfo.numberOfLines = 1
        collegeInfo.textAlignment = .right

        classroomInfo.textColor = .black
        classroomInfo.numberOfLines = 1
        classroomInfo.textAlignment = .right

        courseName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(5)
        }

        teacherName.snp.makeConstraints { make in
            make.top.equalTo(courseName).offset(5)
            make.left.equalToSuperview().offset(5)
        }

        weekInfo.snp.makeConstraints { make in
            make.top.equalTo(teacherName).offset(5)
            make.left.equalToSuperview().offset(5)
        }

        timeInfo.snp.makeConstraints { make in
            make.top.equalTo(weekInfo).offset(5)
            make.left.equalToSuperview().offset(5)
        }

        collegeInfo.snp.makeConstraints { make in
            make.top.equalTo(courseName).offset(5)
            make.right.equalToSuperview().offset(-5)
        }

        classroomInfo.snp.makeConstraints { make in
            make.top.equalTo(collegeInfo).offset(5)
            make.right.equalToSuperview().offset(-5)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

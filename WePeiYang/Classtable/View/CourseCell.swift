//
//  CourseCell.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/24.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
    var titleLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel)
        if isiPad {
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        } else {
            if UIScreen.main.bounds.width <= CGFloat.iPhoneSEWidth {
                titleLabel.font = UIFont.systemFont(ofSize: 9.5, weight: UIFont.Weight.medium)
            } else {
                titleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
            }
        }

        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
//        titleLabel.adjustsFontSizeToFitWidth = true

        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.left.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
            make.bottom.equalToSuperview().offset(-3)
        }

        contentView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(1)
            make.bottom.right.equalToSuperview().offset(-1)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setIdle() {
        contentView.backgroundColor = UIColor(red: 0.91, green: 0.93, blue: 0.96, alpha: 1.00)
        titleLabel.textColor = .lightGray
        titleLabel.text = "无"
    }

    func dismissIdle() {
        // 还原
        titleLabel.textColor = .white
    }

    func load(course: ClassModel) {
        if course.courseID == "" {
            self.alpha = 0
        } else {
            self.alpha = 1
            let colors = Metadata.Color.fluentColors

            // 确保安全
            let index = course.colorIndex % colors.count
            
//            if course.courseID.hasPrefix("-") {
//                index = 3
//            }

            contentView.backgroundColor = colors[index]
            if course.isDisplay == false {
                contentView.backgroundColor = .gray
                contentView.alpha = 0.3
            } else {
                contentView.alpha = 0.7
            }

            var name = course.courseName
            let maxLength = 4*course.arrange.first!.length

            if course.courseName.count > maxLength {
                name = (name as NSString).substring(to: maxLength) + "..."
            }

            if course.arrange[0].room != "" {
                name += "\n@" + course.arrange[0].room
            }

            titleLabel.text = name

        }
    }
}

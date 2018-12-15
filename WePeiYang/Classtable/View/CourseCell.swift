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
    var flagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)
        label.text = "多节"
        label.textColor = .black
        label.backgroundColor = UIColor(hex6: 0xBDBDBD)
        label.textAlignment = .center
        return label
    }()

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


        //titleLabel.layer.masksToBounds = true

        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(2)
//            make.bottom.top.equalToSuperview().inset(20)
            make.bottom.top.equalToSuperview().inset(1)
        }

        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(2)
            make.bottom.top.equalToSuperview().inset(3)
        }

        let fitSize = flagLabel.systemLayoutSizeFitting(CGSize(width: 100, height: 10), withHorizontalFittingPriority: UILayoutPriority.fittingSizeLevel, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)

        let centerXY: CGFloat = (fitSize.width + fitSize.height) / (2 * sqrt(2))
        flagLabel.frame = CGRect(x: 0, y: fitSize.width / 1.41, width: fitSize.width + 40, height: fitSize.height)
        flagLabel.center = CGPoint(x: centerXY, y: centerXY)
        self.contentView.addSubview(flagLabel)
//        let oldFrame = flagLabel.frame
//        flagLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
//        flagLabel.layer.frame = oldFrame
        flagLabel.transform = CGAffineTransform(rotationAngle: -CGFloat(Float.pi / 4))
        flagLabel.isHidden = true

    }

    override func draw(_ rect: CGRect) {

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
        if course.classID == "" && course.courseID == "" {
            self.alpha = 0
            self.flagLabel.isHidden = true
        } else {
            self.alpha = 1
            let colors = Metadata.Color.fluentColors

            if course.displayCourses.count + course.undispalyCourses.count < 2 {
                self.flagLabel.isHidden = true
//                if course.displayCourses.count == 0 {
//                    self.flagLabel.alpha = 0.7
//                } else {
//                    self.flagLabel.alpha = 1
//                }
            } else {
                self.flagLabel.isHidden = false
            }

            // 确保安全
            let index = course.colorIndex % colors.count
            contentView.backgroundColor = colors[index]
            if course.isDisplay == false {
                titleLabel.textColor = .lightGray
                contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
                flagLabel.textColor = .gray
                flagLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            } else {
                titleLabel.textColor = .white
                contentView.backgroundColor = colors[index].withAlphaComponent(0.8)
                flagLabel.textColor = UIColor.black.withAlphaComponent(0.2)
                flagLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
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

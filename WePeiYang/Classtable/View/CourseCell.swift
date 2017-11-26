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
    var roomLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(roomLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        roomLabel.font = UIFont.systemFont(ofSize: 12)
        roomLabel.numberOfLines = 0
        roomLabel.textColor = .white
        roomLabel.sizeToFit()

        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.left.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
        }
        
        roomLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom)
//            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
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

    func load(course: ClassModel) {
        if course.classID == "" {
            self.alpha = 0
        } else {
            let colors = Metadata.Color.fluentColors
            let index = Int(arc4random()) % colors.count
            contentView.backgroundColor = colors[index]
            contentView.alpha = 0.7
            roomLabel.text = "@" + course.arrange[0].room
            roomLabel.sizeToFit()
            titleLabel.text = course.courseName //+ "\n@" + course.arrange[0].room
            titleLabel.sizeToFit()
        }
    }
}

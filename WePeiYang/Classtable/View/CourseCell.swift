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
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        
        layer.cornerRadius = 6
        layer.masksToBounds = true

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
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
            self.contentView.backgroundColor = colors[index]
            self.contentView.alpha = 0.7
            self.titleLabel.text = course.courseName + "\n@" + course.arrange[0].room
            titleLabel.sizeToFit()
        }
    }
}

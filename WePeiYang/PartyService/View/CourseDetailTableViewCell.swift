//
//  CourseDetailTableViewCell.swift
//  WePeiYang
//
//  Created by Allen X on 8/16/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class CourseDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CourseDetailTableViewCell {
    convenience init(detail: Courses.Study20.Detail) {

        let articleNameLabel = UILabel(text: detail.articleName ?? "文章", fontSize: 14)
        let tapToReadLabel = UILabel(text: "开始阅读", fontSize: 14)

        self.init()

        contentView.addSubview(tapToReadLabel)
        tapToReadLabel.snp.makeConstraints {
            make in
            make.right.equalTo(contentView).offset(-14)
            make.centerY.equalTo(contentView)
        }

        contentView.addSubview(articleNameLabel)
        articleNameLabel.snp.makeConstraints {
            make in
            make.left.equalTo(contentView).offset(14)
            make.centerY.equalTo(contentView)
            make.right.lessThanOrEqualTo(tapToReadLabel.snp.left).offset(-20)

        }
    }
}

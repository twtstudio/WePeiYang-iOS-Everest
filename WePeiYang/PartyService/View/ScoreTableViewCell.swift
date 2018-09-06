//
//  ScoreTableViewCell.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/15.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import UIKit
//import SnapKit

class ScoreTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    convenience init(title: String, score: String, completeTime: String) {
        self.init()

        let titleLabel = UILabel(text: title)
        let timeLabel = UILabel(text: completeTime)
        let scoreLabel = UILabel(text: score)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        titleLabel.textColor = UIColor.lightGray
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        scoreLabel.textColor = UIColor.red
        timeLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
        timeLabel.textColor = UIColor.lightGray

        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(scoreLabel)

        timeLabel.snp.makeConstraints {
            make in
            make.right.equalTo(contentView).offset(-8)
            make.centerY.equalTo(contentView)
        }

        scoreLabel.snp.makeConstraints {
            make in
            make.right.equalTo(timeLabel.snp.left).offset(-8)
            make.centerY.equalTo(contentView)
        }

        titleLabel.snp.makeConstraints {
            make in
            make.left.equalTo(contentView).offset(8)
            make.centerY.equalTo(contentView)
            make.right.lessThanOrEqualTo(scoreLabel.snp.left).offset(-8)

        }

    }

}

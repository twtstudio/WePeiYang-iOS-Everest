//
//  CourseCollectionViewCell.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/12/1.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.text = "jjjjjjjjj"
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.text = "weiuhgvwenvwrjv"
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 15
        self.contentView.tag = 10086

        self.nameLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        self.nameLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.vertical)

        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(locationLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(10)
        }
        locationLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualToSuperview().inset(15)
        }
        nameLabel.sizeToFit()
        locationLabel.sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

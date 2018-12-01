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
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.text = "weiuhgvwenvwrjv"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 15
        self.contentView.tag = 10086

        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(locationLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(40)
        }
        locationLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(35)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}

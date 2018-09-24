//
//  QuizCell.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit


class QuizCollectionCell: UICollectionViewCell {
    
    var label:UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label

    }()

    var imageView = UIImageView()

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)

        imageView.snp.makeConstraints {
            make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.height.equalTo(64)
            make.width.equalTo(64)
        }

        label.snp.makeConstraints {
            make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

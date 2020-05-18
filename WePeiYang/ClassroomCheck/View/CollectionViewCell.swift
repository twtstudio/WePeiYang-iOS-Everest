//
//  CollectionViewCell.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class TestCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
//        view.backgroundColor = .black
        return view
    }()
    let label: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "47教"
        l.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return l
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)

        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
//            make.left.equalTo(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(imageView.snp.width)
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


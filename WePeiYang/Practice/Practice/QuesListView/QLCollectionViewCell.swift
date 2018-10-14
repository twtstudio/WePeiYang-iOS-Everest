//
//  QLCollectionViewCell.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/10/12.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class QLCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(22)
            make.height.equalTo(12)
            make.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

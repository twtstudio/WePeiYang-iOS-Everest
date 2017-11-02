//
//  ModuleCollectionViewCell.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/29.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ModuleCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var titleLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        titleLabel = UILabel()
        
        let imageWidth: CGFloat = 62
        imageView.frame = CGRect(x: (self.width-imageWidth)/2, y: 0, width: imageWidth, height: imageWidth)
        titleLabel.frame = CGRect(x: 0, y: imageWidth + 8, width: frame.width, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        self.addSubview(imageView)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

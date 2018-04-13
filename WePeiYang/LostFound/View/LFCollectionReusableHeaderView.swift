//
//  CollectionReusableHeaderView.swift
//  WePeiYang
//
//  Created by Hado on 2017/12/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

let headerIdentifer = "CollectionReusableViewHeader"
class LFCollectionReusableHeaderView: UICollectionReusableView {
    
    
    var image: UIImageView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = UIImageView(frame: CGRect(x: 0, y: 100, width:150, height: 150))
        image.center = CGPoint(x: self.frame.width/2, y: 170)
        image.image = UIImage(named: "飞")
        self.addSubview(image)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 100, width:150, height: 50))
        titleLabel.center = CGPoint(x: self.frame.width/2, y: 280)
        titleLabel.text = "暂时没有该类物品!"
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
        
}

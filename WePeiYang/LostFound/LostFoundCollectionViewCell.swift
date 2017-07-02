//
//  LostFoundCollectionViewCell.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/2.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LostFoundCollectionViewCell: UICollectionViewCell {
    
    var title: UILabel!
    
    override init(frame: CGRect){
    
        super.init(frame: frame)
        
        title = UILabel(frame: CGRect(x:30, y: 0, width: UIScreen.main.bounds.width, height: 50))
        title.textColor = UIColor.black
        self.addSubview(title!)
        
        self.backgroundColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

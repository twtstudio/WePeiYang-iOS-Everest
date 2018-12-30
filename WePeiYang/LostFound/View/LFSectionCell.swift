//
//  LFSectionCell.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class SectionCell: UITableViewHeaderFooterView {
    
    let label = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex6: 0xeeeeee)
        addSubview(label)
        
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(hex6: 0x00a1e9)
        
        label.frame = CGRect(x: 10, y: 5, width: 100, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

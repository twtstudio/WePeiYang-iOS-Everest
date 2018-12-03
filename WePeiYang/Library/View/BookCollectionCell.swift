//
//  BookCollectionCell.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/10/30.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class BookCollectionCell: UICollectionViewCell {
    let bookCard = BookCard()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bookCard)
        bookCard.sizeToFit()
        bookCard.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(frame.width * 0.05)
            make.left.equalTo(contentView).offset(frame.width * 0.05)
            make.right.equalTo(contentView).offset(-frame.width * 0.05)
            make.bottom.equalTo(contentView).offset(-frame.width * 0.05)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

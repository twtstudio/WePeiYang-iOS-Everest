//
//  BookDetailTableHeaderView.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/11/8.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class BookDetailTableHeaderView: UITableViewHeaderFooterView {
    
    private var labels: [UILabel] = []
    //    private let text = ["索书号", "馆藏地点"]
    private let padding: CGFloat = 5
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.backgroundColor = UIColor.white
        for i in 0..<2 {
            let label = UILabel()
            label.textColor = LibraryMainViewController.fontGrayColor
            label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
            label.text = BookCostant.detailTableHeaderText[i]
            label.textAlignment = .center
            labels.append(label)
            addSubview(label)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for i in 0..<2 {
            labels[i].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(contentView)
                make.bottom.equalTo(contentView)
            }
        }
        labels[0].snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(contentView.width * 0.1)
            make.width.equalTo(contentView).multipliedBy(0.35)
        }
        labels[1].snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView).multipliedBy(0.5)
            make.right.equalTo(contentView)
        }
    }
}

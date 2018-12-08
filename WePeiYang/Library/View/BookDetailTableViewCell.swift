//
//  BookDetailTableViewCell.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/11/8.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class BookDetailTableViewCell: UITableViewCell {
    var holding: Holding? {
        didSet {
            if let hold = holding {
                storeImage.image = hold.state == "借出" ? #imageLiteral(resourceName: "借出") : #imageLiteral(resourceName: "在馆")
                labels[0].text = hold.callno
                labels[1].text = hold.local
            }
        }
    }
    
    private var labels: [UILabel] = []
    //    private var texts: [String] = ["I247.5/J9-1(20)v.1", "卫津路人文社科阅览区"]
    private let stateLabel = UILabel()
    private let storeImage = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(storeImage)
        storeImage.image = #imageLiteral(resourceName: "在馆")
        storeImage.contentMode = .scaleAspectFit
        for i in 0..<2 {
            labels.append(UILabel(text: "", color: LibraryMainViewController.fontGrayColor, fontSize: 14))
            labels[i].numberOfLines = 0
            labels[i].textAlignment = .center
            addSubview(labels[i])
        }
        remakeConstraints()
    }
    
    private func remakeConstraints() {
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        storeImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.1)
            make.bottom.equalTo(contentView)
        }
        
        labels[0].snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.left.equalTo(storeImage.snp.right).offset(5)
            make.width.equalTo(contentView).multipliedBy(0.35)
            make.bottom.equalTo(contentView)
        }
        labels[1].snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.right.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.5)
            make.bottom.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

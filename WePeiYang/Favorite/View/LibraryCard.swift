
//
//  LibraryCard.swift
//  WePeiYang
//
//  Created by Halcao on 2017/12/12.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LibraryCard: CardView {
    let titleLabel = UILabel()
    let tableView = UITableView()
    
    override func initialize() {
        super.initialize()
        
        self.backgroundColor = .white
        let padding: CGFloat = 20
        
        titleLabel.text = "图书馆"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightSemibold)
        titleLabel.textColor = .black
        self.addSubview(titleLabel)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.top.equalToSuperview().offset(padding)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        let provider = LibraryCardDataProvider()
        tableView.delegate = provider
        tableView.dataSource = provider
        (tableView as UIScrollView).isScrollEnabled = false
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-padding)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(132)
        }
        
//        let button
    }
}

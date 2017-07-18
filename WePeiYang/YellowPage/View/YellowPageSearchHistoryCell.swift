//
//  YellowPageSearchHistoryCell.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/23.
//  Modified by Halcao on 2017/7/18.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class YellowPageSearchHistoryCell: UITableViewCell {
    
    let deleteView = ExtendedButton()
    let label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    convenience init(name: String) {
        self.init(style: .default, reuseIdentifier: "YellowPageSearchHistoryCell")
        let imgView = UIImageView()
        imgView.image = UIImage(named: "history")
        self.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
        }
        
        label.text = name
//        label.font = UIFont.flexibleFont(with: 15)
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(22)
            make.centerY.equalTo(self)
        }
        
        //deleteView.image = UIImage(named: "delete")
        deleteView.setImage(UIImage(named: "delete"), for: .normal)

        self.addSubview(deleteView)
        deleteView.snp.makeConstraints { make in
            make.width.equalTo(13)
            make.height.equalTo(13)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
        }
    }
}

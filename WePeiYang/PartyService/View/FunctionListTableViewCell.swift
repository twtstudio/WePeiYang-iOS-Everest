//
//  FunctionListTableViewCell.swift
//  WePeiYang
//
//  Created by Allen X on 8/12/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit
//import SnapKit

class FunctionListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    convenience init(iconName: String, desc: String) {
        self.init()
        
        let iconView = UIImageView(imageName: iconName, desiredSize: CGSize(width: 30, height: 30))
    
        guard let foo = iconView else {
            return
        }
        
        
        contentView.addSubview(foo)
        
        iconView?.snp.makeConstraints {
            make in
            make.left.equalTo(contentView).offset(4)
            make.centerY.equalTo(contentView)
        }
        
        let descLabel = UILabel(text: desc)
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            make in
            make.left.equalTo((iconView?.snp.right)!).offset(5)
            make.centerY.equalTo(contentView)
        }
        
    }

}

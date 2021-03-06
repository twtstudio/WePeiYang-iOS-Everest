//
//  ClassWidgetCell.swift
//  WePeiYangWidget
//
//  Created by Halcao on 2018/2/21.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class ClassWidgetCell: UITableViewCell {
    let coursenameLabel = UILabel()
    let infoLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        coursenameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        if DeviceStatus.deviceOSVersion.starts(with: "9") {
            coursenameLabel.textColor = .lightText
            infoLabel.textColor = .lightGray
        } else {
            coursenameLabel.textColor = .darkGray
            infoLabel.textColor = .gray
        }
        coursenameLabel.frame = CGRect(x: 20, y: 5, width: 200, height: 20)
        contentView.addSubview(coursenameLabel)

        infoLabel.font = UIFont.systemFont(ofSize: 13)
        infoLabel.frame = CGRect(x: 20, y: 25, width: 200, height: 20)
        contentView.addSubview(infoLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

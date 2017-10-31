//
//  TextTableViewCell.swift
//  WePeiYang
//
//  Created by Allen X on 8/17/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TextTableViewCell {
    convenience init(text: Courses.StudyText) {
        self.init()
        
        let nameLabel = UILabel(text: text.fileTitle!)
        let tapToSeeDetailLabel = UILabel(text: "查看详情")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        tapToSeeDetailLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        //TODO: nameLabel self-sizing
        
        
        contentView.addSubview(tapToSeeDetailLabel)
        tapToSeeDetailLabel.snp.makeConstraints {
            make in
            make.right.equalTo(contentView).offset(-14)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            make in
            make.left.equalTo(contentView).offset(14)
            make.centerY.equalTo(contentView)
            make.right.lessThanOrEqualTo(tapToSeeDetailLabel.snp.left).offset(-20)
        }
    }
}

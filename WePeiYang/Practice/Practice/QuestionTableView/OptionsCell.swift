//
//  OptionsCell.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/21.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit

extension QuestionViewParameters {
    static let optionLabelW = 0.7 * deviceWidth
    static let optionsOffsetY = 0.007 * deviceHeight
    static let aFont = UIFont.systemFont(ofSize: 17)
}

class OptionsCell: UITableViewCell {
    let btnWidth = QuestionViewParameters.cellH
    let offset = 0.01 * deviceWidth
    
    let btnImages: [UIImage] = [#imageLiteral(resourceName: "A"), #imageLiteral(resourceName: "B"), #imageLiteral(resourceName: "C"), #imageLiteral(resourceName: "D"), #imageLiteral(resourceName: "E")]
    
    let optionIcon: UIImageView = {
        let btn = UIImageView(frame: .zero)
        return btn
    }()
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .clear
        
        self.addSubview(optionIcon)
        self.addSubview(optionLabel)

    }
    
    func initUI(order: Int, optionsContent: String?) {
//        optionBtn.setImage(btnImages[order], for: .normal)
        optionIcon.image = btnImages[order]
        optionIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(btnWidth)
            make.left.top.equalTo(self)
        }
        
        if let content = optionsContent {
            optionLabel.text = content
            optionLabel.font = QuestionViewParameters.aFont
            optionLabel.snp.makeConstraints { (make) in
                make.width.equalTo(QuestionViewParameters.optionLabelW)
                make.height.equalTo(content.calculateHeightWithConstrained(width: CGFloat(QuestionViewParameters.optionLabelW), font: QuestionViewParameters.aFont))
                make.left.equalTo(optionIcon).offset(btnWidth + offset)
                make.top.equalTo(self).offset(QuestionViewParameters.optionsOffsetY)
            }
        } else {
            // 数据为空时怎么办（待填坑）
            
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

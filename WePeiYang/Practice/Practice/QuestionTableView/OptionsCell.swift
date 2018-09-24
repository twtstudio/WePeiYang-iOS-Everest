//
//  OptionsCell.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/21.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit

class OptionsCell: UITableViewCell {
    let questionViewParameters = QuestionViewParameters()
    
    let btnImages: [UIImage] = [#imageLiteral(resourceName: "A"), #imageLiteral(resourceName: "B"), #imageLiteral(resourceName: "C"), #imageLiteral(resourceName: "D"), #imageLiteral(resourceName: "E")]

    let selectedbtnImgs: [UIImage] = [#imageLiteral(resourceName: "selectedA"), #imageLiteral(resourceName: "selectedB"), #imageLiteral(resourceName: "selectedC"), #imageLiteral(resourceName: "selectedD"), #imageLiteral(resourceName: "selectedE")]
    let errorImg: UIImage = UIImage()//#imageLiteral(resourceName: "errorIcon.png")

    
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
    
    var optionContent: String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .clear
        self.addSubview(optionIcon)
        self.addSubview(optionLabel)
    }
    
    func setupUI() {
        let btnWidth = questionViewParameters.cellH
        let offset = 0.01 * deviceWidth

        optionIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(btnWidth)
            make.top.equalTo(self)
            make.left.equalTo(self).offset(5)
        }
        
        if let content = optionContent {
            optionLabel.text = content
            optionLabel.font = questionViewParameters.aFont
            optionLabel.snp.makeConstraints { (make) in
                make.width.equalTo(questionViewParameters.optionLabelW)
                make.height.equalTo(content.calculateHeightWithConstrained(width: CGFloat(questionViewParameters.optionLabelW + 3), font: questionViewParameters.aFont))
                make.left.equalTo(optionIcon).offset(btnWidth + offset)
                make.top.equalTo(self).offset(questionViewParameters.optionsOffsetY)
            }
        } else {
            // 数据为空时怎么办（待填坑）
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

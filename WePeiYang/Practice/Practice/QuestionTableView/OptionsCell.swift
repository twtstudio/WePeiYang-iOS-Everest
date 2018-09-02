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
//    let errorImg: UIImage =
    
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
    
    func initUI(order: Int, optionsContent: String?, isSelected: Bool, rightAns: String) {
        let btnWidth = questionViewParameters.cellH
        let offset = 0.01 * deviceWidth
        let practiceModel = PracticeModel()

        if isSelected == false {
            optionIcon.image = btnImages[order]
        }else {
            if practiceModel.optionDics[order + 2] == rightAns {
                optionIcon.image = errorImg
            }else {
                optionIcon.image = selectedbtnImgs[order]
                
            }
        }
        
        optionIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(btnWidth)
            make.left.top.equalTo(self)
        }
        
        if let content = optionsContent {
            optionLabel.text = content
            optionLabel.font = questionViewParameters.aFont
            optionLabel.snp.makeConstraints { (make) in
                make.width.equalTo(questionViewParameters.optionLabelW)
                make.height.equalTo(content.calculateHeightWithConstrained(width: CGFloat(questionViewParameters.optionLabelW), font: questionViewParameters.aFont))
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

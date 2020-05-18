//
//  cell.swift
//  WePeiYang
//
//  Created by 安宇 on 21/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//
import SnapKit
import UIKit

class ActivityCell: UITableViewCell {
    
    var activityImage = ActivityView()

//    override var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set {
//            var frame = newValue
//            frame.origin.x += 10
//            frame.size.width -= 2 * 10
//            super.frame = frame
//        }
//    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    convenience init() {
        self.init(style: .default, reuseIdentifier: "ActivitiesTableViewCell")
//        self.in
        contentView.addSubview(activityImage)
        //        添加阴影效果
        
        activityImage.layer.shadowOpacity = 0.3
        activityImage.layer.shadowColor = UIColor.gray.cgColor
        activityImage.layer.shadowRadius = 3
        activityImage.layer.shadowOffset = CGSize(width: 0,height: 0.5)
        activityImage.layer.masksToBounds = false
        
        //      添加圆角效果
        activityImage.layer.cornerRadius = 15
        activityImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            //            make.height.equalTo(cellHeight)
            if isiPad {
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.6)
            } else {
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            }
        }

        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    MARK:这个Model等后台给了就改
//    convenience init(byModel Activity: ConsumeDetail, withIndex index: Int) {
//        self.init(style: .default, reuseIdentifier: "ActivityTableViewCell")
//
//        contentView.addSubview(activityImage)
//        activityImage.layer.shadowOpacity = 0.3
//        activityImage.layer.shadowColor = UIColor.gray.cgColor
//        activityImage.layer.shadowRadius = 3
//        activityImage.layer.shadowOffset = CGSize(width: 0,height: 0.5)
//        activityImage.layer.masksToBounds = false
//
//        //      添加圆角效果
//        activityImage.layer.cornerRadius = 15
//        activityImage.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(10)
//            make.bottom.equalToSuperview().offset(-10)
//            //            make.height.equalTo(cellHeight)
//            if isiPad {
//                make.centerX.equalToSuperview()
//                make.width.equalToSuperview().multipliedBy(0.6)
//            } else {
//                make.left.equalToSuperview().offset(15)
//                make.right.equalToSuperview().offset(-15)
//            }
//        }
//
//
        
//    }
    
    
    
}

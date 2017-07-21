//
//  StatusInfoCell.swift
//  TableView
//
//  Created by Kyrie Wei on 10/26/16.
//  Copyright © 2016 Kyrie Wei. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class StatusInfoCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    convenience init(status: String, callno: String, location: String, duetime: String) {
        self.init()
        
        let callnoLabel:UILabel = {
            let callnoLabel = UILabel()
            callnoLabel.text = callno
            callnoLabel.textColor = UIColor.darkGrayColor()
            callnoLabel.textAlignment = .Center
            callnoLabel.font = UIFont.systemFontOfSize(13)
            callnoLabel.sizeToFit()
            return callnoLabel
        }()
        
        let locationLabel:UILabel = {
            let locationLabel = UILabel()
            locationLabel.text = location
            locationLabel.textColor = UIColor.darkGrayColor()
            locationLabel.textAlignment = .Center
            locationLabel.font = UIFont.systemFontOfSize(13)
            locationLabel.sizeToFit()
            return locationLabel
        }()
        
        let statusLabel:UILabel = {
            let statusLabel = UILabel()
            
            if status == "在馆" {
                statusLabel.text = "在馆"
                statusLabel.textColor = UIColor.redColor()
            } else {
                statusLabel.text = "借出"
                statusLabel.textColor = UIColor.lightGrayColor()
            }
            statusLabel.sizeToFit()
            statusLabel.textAlignment = .Center
            statusLabel.font = UIFont.systemFontOfSize(13)
            return statusLabel
        }()
        
        contentView.addSubview(callnoLabel)
        callnoLabel.snp_makeConstraints {
            make in
            make.left.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
        contentView.addSubview(statusLabel)
        statusLabel.snp_makeConstraints{
            make in
            make.right.equalTo(contentView.snp_right).offset(-16)
            make.centerY.equalTo(callnoLabel.snp_centerY)
        }
        
        contentView.addSubview(locationLabel)
        locationLabel.snp_makeConstraints {
            make in
            make.left.greaterThanOrEqualTo(callnoLabel.snp_left).offset(10)
            make.right.lessThanOrEqualTo(statusLabel.snp_right).offset(-10)
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(callnoLabel.snp_centerY)
        }
        
        if status == "借出" {
           // let dueTimeForMatter = NSDateFormatter()
           // dueTimeForMatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dueTimeLabel:UILabel = {
                let dueTimeLabel = UILabel()
                // dueTimeLabel.text = "应还时间：\(dueTimeForMatter.stringFromDate(duetime))"
                dueTimeLabel.text = "应还时间：\(duetime)"
                dueTimeLabel.textColor = UIColor.grayColor()
                dueTimeLabel.textAlignment = .Center
                dueTimeLabel.font = UIFont.systemFontOfSize(10)
                return dueTimeLabel
            }()
            
            contentView.addSubview(dueTimeLabel)
            dueTimeLabel.snp_makeConstraints{
                make in
                make.bottom.equalTo(contentView).offset(-2)
                make.right.equalTo(contentView).offset(-16)
            }
        }
        
    }
    
    
}
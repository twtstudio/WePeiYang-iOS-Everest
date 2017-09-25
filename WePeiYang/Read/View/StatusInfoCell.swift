//
//  StatusInfoCell.swift
//  TableView
//
//  Created by Kyrie Wei on 10/26/16.
//  Copyright © 2016 Kyrie Wei. All rights reserved.
//

import UIKit

class StatusInfoCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    convenience init(status: String, callno: String, location: String, duetime: String) {
        self.init()
        
        let callnoLabel:UILabel = {
            let callnoLabel = UILabel()
            callnoLabel.text = callno
            callnoLabel.textColor = .darkGray
            callnoLabel.textAlignment = .center
            callnoLabel.font = UIFont.systemFont(ofSize: 13)
            callnoLabel.sizeToFit()
            return callnoLabel
        }()
        
        let locationLabel:UILabel = {
            let locationLabel = UILabel()
            locationLabel.text = location
            locationLabel.textColor = .darkGray
            locationLabel.textAlignment = .center
            locationLabel.font = UIFont.systemFont(ofSize: 13)
            locationLabel.sizeToFit()
            return locationLabel
        }()
        
        let statusLabel:UILabel = {
            let statusLabel = UILabel()
            
            if status == "在馆" {
                statusLabel.text = "在馆"
                statusLabel.textColor = .red
            } else {
                statusLabel.text = "借出"
                statusLabel.textColor = .lightGray
            }
            statusLabel.sizeToFit()
            statusLabel.textAlignment = .center
            statusLabel.font = UIFont.systemFont(ofSize: 13)
            return statusLabel
        }()
        
        contentView.addSubview(callnoLabel)
        callnoLabel.snp.makeConstraints {
            make in
            make.left.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints{
            make in
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.centerY.equalTo(callnoLabel.snp.centerY)
        }
        
        contentView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints {
            make in
            make.left.greaterThanOrEqualTo(callnoLabel.snp.left).offset(10)
            make.right.lessThanOrEqualTo(statusLabel.snp.right).offset(-10)
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(callnoLabel.snp.centerY)
        }
        
        if status == "借出" {
           // let dueTimeForMatter = NSDateFormatter()
           // dueTimeForMatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dueTimeLabel:UILabel = {
                let dueTimeLabel = UILabel()
                // dueTimeLabel.text = "应还时间：\(dueTimeForMatter.stringFromDate(duetime))"
                dueTimeLabel.text = "应还时间：\(duetime)"
                dueTimeLabel.textColor = .gray
                dueTimeLabel.textAlignment = .center
                dueTimeLabel.font = UIFont.systemFont(ofSize: 10)
                return dueTimeLabel
            }()
            
            contentView.addSubview(dueTimeLabel)
            dueTimeLabel.snp.makeConstraints{
                make in
                make.bottom.equalTo(contentView).offset(-2)
                make.right.equalTo(contentView).offset(-16)
            }
        }
        
    }
    
    
}

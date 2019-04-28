//
//  JobFairTableViewCell.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/15.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
class JobFairTableViewCell: UITableViewCell {
    
    var titleLable = UILabel()
    var lineLable = UILabel()
    var timeImageView = UIImageView()
    var timeLable = UILabel()
    var locationImageView = UIImageView()
    var locationLable = UILabel()
    var visitsImageView = UIImageView()
    var visitsLable = UILabel()
    var currentDataLable = UILabel()
    var importantNum: Int = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(recruitmentInfo: RecruitInfo, index: Int, isSearch: Bool) {
        self.init(style: .default, reuseIdentifier: "JobFairTableViewCell")
        let padding: CGFloat = 20
        self.importantNum = recruitmentInfo.imporant.count
        
        titleLable.frame = CGRect(x: padding, y: padding, width: Device.width-(padding*2), height: 50)
        titleLable.textAlignment = .left
        titleLable.lineBreakMode = .byWordWrapping
        titleLable.font = UIFont.systemFont(ofSize: 20)
        titleLable.numberOfLines = 2
        contentView.addSubview(titleLable)
        
        timeImageView.frame = CGRect(x: padding*3/2, y: padding+titleLable.height, width: 40, height: 40)
        timeImageView.image = UIImage(named: "时间")
        contentView.addSubview(timeImageView)
        
        timeLable.frame = CGRect(x: padding*7/2, y: timeImageView.y+5, width: Device.width/2 , height: 30)
        timeLable.font = UIFont.systemFont(ofSize: 15)
        timeLable.textAlignment = .left
        contentView.addSubview(timeLable)
        
        locationImageView.frame = CGRect(x: padding*3/2, y: timeImageView.y+timeImageView.height, width: 40, height: 40)
        locationImageView.image = UIImage(named: "地点")
        contentView.addSubview(locationImageView)
        
        locationLable.frame = CGRect(x: padding*7/2, y: locationImageView.y+5, width: Device.width/2 + padding, height: 30)
        locationLable.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(locationLable)
        
        visitsImageView.frame = CGRect(x: padding*3/2, y: locationImageView.y+locationImageView.height, width: 40, height: 40)
        visitsImageView.image = UIImage(named: "浏览量")
        contentView.addSubview(visitsImageView)
        
        visitsLable.frame = CGRect(x: padding*7/2, y: visitsImageView.y+5, width: Device.width/9, height: 30)
        visitsLable.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(visitsLable)
        
        currentDataLable.frame = CGRect(x: Device.width-padding-(Device.width-padding*2)/4-10, y: visitsImageView.y+30, width: (Device.width-padding*2)/4 + 10, height: 30)
        currentDataLable.textColor = UIColor.gray
        contentView.addSubview(currentDataLable)
        
        lineLable.frame = CGRect(x: padding, y: 208, width: Device.width-padding*2, height: 2)
        lineLable.textColor = .black
        lineLable.text = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
       // lineLable.backgroundColor = .red
        lineLable.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(lineLable)
        
        if isSearch == false {
            if index < importantNum {
                titleLable.text = recruitmentInfo.imporant[index].title
                timeLable.text = "\(recruitmentInfo.imporant[index].heldDate) \(recruitmentInfo.imporant[index].heldTime)"
                locationLable.text = recruitmentInfo.imporant[index].place
                print(recruitmentInfo.imporant[index].place)
                visitsLable.text = recruitmentInfo.imporant[index].click
                currentDataLable.text = recruitmentInfo.imporant[index].date.changeTimeType()
            }else {
                titleLable.text = recruitmentInfo.commons[index-importantNum].title
                timeLable.text = "\(recruitmentInfo.commons[index-importantNum].heldDate) \(recruitmentInfo.commons[index-importantNum].heldTime)"
                locationLable.text = recruitmentInfo.commons[index-importantNum].place
                visitsLable.text = recruitmentInfo.commons[index-importantNum].click
                currentDataLable.text = recruitmentInfo.commons[index-importantNum].date.changeTimeType()
            }
        }else {
            titleLable.text = recruitmentInfo.commons[index-7].title
            timeLable.text = "\(recruitmentInfo.commons[index-7].heldDate) \(recruitmentInfo.commons[index-7].heldTime)"
            locationLable.text = recruitmentInfo.commons[index-7].place
            visitsLable.text = recruitmentInfo.commons[index-7].click
            currentDataLable.text = recruitmentInfo.commons[index-7].date.changeTimeType()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

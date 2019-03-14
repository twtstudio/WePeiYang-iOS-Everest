//
//  AnnouncementTableViewCell.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/15.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
class AnnouncementTableViewCell: UITableViewCell {

    var timeLable = UILabel()
    var zhiDingImageView = UIImageView()
    var visitsImageView = UIImageView()
    var visitsLable = UILabel()
    var mainLable = UILabel()
    var lineLable = UILabel()
    var importantNum: Int!
    var topImageView = UIImageView()
    var topLable = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    convenience init(recruitmentInfo: RecruitInfo, index: Int) {
        self.init(style: .default, reuseIdentifier: "AnnouncementTableViewCell")

        let padding: CGFloat = 20
        self.importantNum = recruitmentInfo.imporant.count

        timeLable.frame = CGRect(x: padding, y: padding, width: Device.width/4, height: 20)
        timeLable.textColor = .gray
        contentView.addSubview(timeLable)

        visitsImageView.frame = CGRect(x: Device.width-padding-Device.width/9-30, y: padding-5, width: 30, height: 30)
        visitsImageView.image = UIImage(named: "浏览量")
        contentView.addSubview(visitsImageView)

        visitsLable.frame = CGRect(x: Device.width-padding-Device.width/9, y: padding, width: Device.width/9, height: 20)
        contentView.addSubview(visitsLable)

        mainLable.frame = CGRect(x: padding, y: padding*2+15, width: Device.width-(padding*2), height: 50)
        mainLable.textAlignment = .left
        mainLable.lineBreakMode = .byWordWrapping
        mainLable.font = UIFont.systemFont(ofSize: 20)
        mainLable.textColor = .black
        mainLable.numberOfLines = 2
        contentView.addSubview(mainLable)

        lineLable.frame = CGRect(x: padding, y: 128, width: Device.width-padding*2, height: 2)
        lineLable.textColor = .black
        lineLable.text = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        lineLable.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(lineLable)

        if index < importantNum {
            timeLable.text = recruitmentInfo.imporant[index].date.changeTimeType()
            visitsLable.text = recruitmentInfo.imporant[index].click
            mainLable.text = recruitmentInfo.imporant[index].title

            topImageView.image = UIImage(named: "置顶")
            topImageView.frame = CGRect(x: Device.width-padding-Device.width/9-30-60, y: padding-10, width: 40, height: 40)
            contentView.addSubview(topImageView)

            topLable.frame = CGRect(x: topImageView.frame.maxX-10, y: padding, width: Device.width/10, height: 20)
            topLable.text = "置顶"
            topLable.font = UIFont.systemFont(ofSize: 13)
            topLable.textColor = UIColor.black
            contentView.addSubview(topLable)
        }else {
            timeLable.text = recruitmentInfo.common[index-importantNum].date.changeTimeType()
            visitsLable.text = recruitmentInfo.common[index-importantNum].click
            mainLable.text = recruitmentInfo.common[index-importantNum].title
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  TrendsTableViewCell.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/15.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
class TrendsTableViewCell: UITableViewCell {
    var timeLable = UILabel()
    var zhiDingImageView = UIImageView()
    var visitsImageView = UIImageView()
    var visitsLable = UILabel()
    var mainLable = UILabel()
    var lineLable = UILabel()
    var importantNum: Int = 5
    var rotationNum: Int = 3
    var commenNum: Int = 10
    var topImageView = UIImageView()
    var topLable = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    convenience init(recruitmentInfo: RecruitInfo, index: Int) {
        self.init(style: .default, reuseIdentifier: "TrendsTableViewCell")

        let padding: CGFloat = 20
        importantNum = recruitmentInfo.imporant.count
        commenNum = recruitmentInfo.common.count
        rotationNum = recruitmentInfo.rotation.count

        timeLable.frame = CGRect(x: padding, y: padding, width: Device.width/4, height: 20)
        timeLable.text = "2018/10/27"
        timeLable.textColor = .gray
        contentView.addSubview(timeLable)

        visitsImageView.frame = CGRect(x: Device.width-padding-Device.width/9-30, y: padding-5, width: 30, height: 30)
        visitsImageView.image = UIImage(named: "浏览量")
        contentView.addSubview(visitsImageView)

        visitsLable.frame = CGRect(x: Device.width-padding-Device.width/9, y: padding, width: Device.width/9, height: 20)
        visitsLable.text = "3088"
        contentView.addSubview(visitsLable)

        mainLable.frame = CGRect(x: padding, y: padding*2+15, width: Device.width-(padding*2), height: 50)
        mainLable.textAlignment = .left
        mainLable.lineBreakMode = .byWordWrapping
        mainLable.font = UIFont.systemFont(ofSize: 20)
        mainLable.textColor = .black
        mainLable.text = "天津市2019年定向天津大学选调优秀高校毕业生公告"
        mainLable.numberOfLines = 2
        contentView.addSubview(mainLable)

        lineLable.frame = CGRect(x: padding, y: 129, width: Device.width-padding*2, height: 1)
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

        }else if index >= importantNum && index < (importantNum + rotationNum) {
            timeLable.text = recruitmentInfo.rotation[index-importantNum].date.changeTimeType()
            visitsLable.text = recruitmentInfo.rotation[index-importantNum].click
            mainLable.text = recruitmentInfo.rotation[index-importantNum].title
        }else {
            timeLable.text = recruitmentInfo.common[index-(importantNum + rotationNum)].date.changeTimeType()
            visitsLable.text = recruitmentInfo.common[index-(importantNum + rotationNum)].click
            mainLable.text = recruitmentInfo.common[index-(importantNum + rotationNum)].title
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

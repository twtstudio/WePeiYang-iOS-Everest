//
//  ClassTableCard.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/27.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

class ClassTableCard: CardView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    var cells: [CourseCell] = []
    
    override func initialize() {
        super.initialize()
        let padding: CGFloat = 20
        
        titleLabel.frame = CGRect(x: padding, y: padding-5, width: 200, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold)
        titleLabel.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.00)
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)

        subtitleLabel.frame = CGRect(x: padding, y: padding + 20 - 5, width: 200, height: 30)
        // TODO: 明天的课程
        subtitleLabel.text = "今天的课程"
        subtitleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightSemibold)
        subtitleLabel.textColor = .black
        subtitleLabel.sizeToFit()
        self.addSubview(subtitleLabel)
        
        self.backgroundColor = .white
        
        layout(rect: self.frame)
    }
    
    override func layout(rect: CGRect) {
        let padding: CGFloat = 20
        let offset: CGFloat = 2
        let cellWidth = (rect.width - 2*padding - 4*offset) / 5 as CGFloat
        let cellHeight = 110 as CGFloat

        blankView.frame = CGRect(x: padding, y: 95, width: (cellWidth+offset)*5, height: cellHeight)
        if cells.count == 0 {
            // 初始化
            for i in 0..<5 {
                let cell = CourseCell(style: .default, reuseIdentifier: "CourseCell\(i.description)")
                cell.frame = CGRect(x: padding+(cellWidth+offset)*CGFloat(i), y: 95, width: cellWidth, height: cellHeight)
                cell.tag = i
                cells.append(cell)
                self.addSubview(cell)
            }
        } else {
            // 调整位置
            for i in 0..<5 {
                let cell = cells[i]
                cell.frame = CGRect(x: padding+(cellWidth+offset)*CGFloat(i), y: 95, width: cellWidth, height: cellHeight)
            }
        }
        super.layout(rect: rect)
    }
}

extension ClassTableCard {
    override func refresh() {
        super.refresh()
        self.setState(.loading("加载中...", .darkGray))

        CacheManager.retreive("classtable/classtable.json", from: .group, as: String.self, success: { string in
            guard let table = Mapper<ClassTableModel>().map(JSONString: string) else {
                return
            }
            let termStart = Date(timeIntervalSince1970: Double(table.termStart))
            let week = Int(Date().timeIntervalSince(termStart)/(7.0*24*60*60) + 1)
            let weekday = DateTool.getChineseWeekDay()
            //                let weekString = DateTool.getChineseNumber(number: week)
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.numberStyle = .spellOut
            let weekString = formatter.string(from: NSNumber(value: week)) ?? DateTool.getChineseNumber(number: week)
            self.titleLabel.text = "第" + weekString + "周" + " " + weekday
            self.titleLabel.sizeToFit()

            var courses = ClassTableHelper.getTodayCourse(table: table).filter { course in
                return course.courseName != ""
            }

            // 这个时间点有课就代表着时候有课
            let keys = [1, 3, 5, 7, 9]
            for (idx, time) in keys.enumerated() {
                // 返回第一个包含时间点的课程 // 可能是 nil
                let course = courses.first { course in
                    let range = course.arrange.first!.start...course.arrange.first!.end
                    return range.contains(time)
                }
                if let course = course {
                    let index = courses.index { m in
                        return m.classID == course.classID &&
                            m.arrange.first?.start ==  course.arrange.first?.start &&
                            m.arrange.first?.end ==  course.arrange.first?.end
                    }
                    courses.remove(at: index!)
                    self.cells[idx].load(course: course)
                } else {
                    self.cells[idx].setIdle()
                }
            }
            if courses.count == 0 {
                self.setState(.empty("今天没有课，做点有趣的事情吧！", .darkGray))
            } else {
                self.setState(.data)
            }
        })
    }
}

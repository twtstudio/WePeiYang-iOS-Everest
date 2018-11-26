//
//  CourseListView.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/22.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

private struct C {
    static var cellWidth: CGFloat {
        return (UIScreen.main.bounds.width - classNumberViewWidth) / 7
    }// = 47
//    static let cellHeight: CGFloat = 55
    static let cellHeight: CGFloat = (UIScreen.main.bounds.height*0.9) / 12
    static let dayCount = 7
    static let courseCount = 12

    static let classNumberViewWidth: CGFloat = 32 //35
    static let dayNumberViewHeight: CGFloat = 45
}

protocol CourseListViewDelegate: class {
    /// 选中课程
    ///
    /// - Parameters:
    ///   - listView: 所在的 listView
    ///   - course: 被选中的课程
    func listView(_ listView: CourseListView, didSelectCourse course: ClassModel)
}

//Hiererachy
//"CourseListView" UIView
//    +--- "containerView" UIView
//        +-- "scrollView" UIScrollView
//            +-- "contentView" UIView
//                +-- Subview 1 UIView
//                    +-- Subview 2 UIView
//                        +-- Subview 3 UIView
class CourseListView: UIView {
    // C stands for Constant

    var classNumberView: UIView!
    var dayNumberView: UIView!
    var updownContentView: UIScrollView!
    var tableViews: [UITableView] = []

    weak var delegate: CourseListViewDelegate?
    // 周一到周日
    var coursesForDay: [[ClassModel]] = [[], [], [], [], [], [], []]

    var monthLabel: UILabel!
    var dayNumberLabels: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        let dayInMonth = DateTool.getCurrentWeekDay()

        classNumberView = UIView(frame: .zero)
        dayNumberView = UIView(frame: .zero)
        updownContentView = UIScrollView(frame: .zero)
        updownContentView.showsVerticalScrollIndicator = false
        updownContentView.bounces = false

        self.addSubview(dayNumberView)

        dayNumberView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
        dayNumberView.layer.borderWidth = 1
        // 周几 label 的底板
        dayNumberView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(C.dayNumberViewHeight)
        }

        monthLabel = UILabel(frame: .zero)
//        monthLabel.font = UIFont.systemFont(ofSize: 12)
        monthLabel.font = UIFont.boldSystemFont(ofSize: 11)
//        monthLabel.textColor = .lightGray
        monthLabel.textColor = UIColor(red: 0.25, green: 0.36, blue: 0.47, alpha: 1.00)
        monthLabel.textAlignment = .center
        monthLabel.numberOfLines = 2
        monthLabel.backgroundColor = UIColor(red: 0.96, green: 0.98, blue: 0.98, alpha: 1.00)
        dayNumberView.addSubview(monthLabel)
        monthLabel.text = dayInMonth[0]
        monthLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(C.classNumberViewWidth)
        }

        // 进行周几标签的布局
        var dayTitles = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        for i in 0..<C.dayCount {
            let label = UILabel(frame: .zero)
            label.backgroundColor = UIColor(red: 0.96, green: 0.98, blue: 0.98, alpha: 1.00)
            label.text = dayTitles[i] + "\n" + dayInMonth[i+1]
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 11)
//            label.font = UIFont.systemFont(ofSize: 12)
//            label.textColor = .lightGray
            label.textColor = UIColor(red: 0.25, green: 0.36, blue: 0.47, alpha: 1.00)
            label.numberOfLines = 2
            dayNumberView.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(C.cellWidth)
                if i == 0 {
                    make.left.equalToSuperview().offset(C.classNumberViewWidth)
                } else {
                    make.left.equalTo(dayNumberLabels[i-1].snp.right)
                }
                if i == C.dayCount - 1 {
                    label.snp.makeConstraints { make in
                        make.right.equalToSuperview()
                    }
                }
            }
            dayNumberLabels.append(label)
        }

        // 上下滑动的view
        self.addSubview(updownContentView)
        updownContentView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(dayNumberView.snp.bottom)
        }

        let contentView = UIView()
        updownContentView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.addSubview(classNumberView)
        classNumberView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(C.classNumberViewWidth)
            make.height.equalTo(CGFloat(C.courseCount) * C.cellHeight)
            make.bottom.equalToSuperview()
        }
        // 课程编号的label
        var courseCountLabels: [UILabel] = []
        for i in 0..<C.courseCount {
            let label = UILabel(frame: .zero)
            label.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 0.97, alpha: 1.00)
            label.text = "\(i+1)"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor(red: 0.46, green: 0.55, blue: 0.62, alpha: 1.00)
            classNumberView.addSubview(label)
            label.snp.makeConstraints { make in
                make.height.equalTo(C.cellHeight)
                make.width.equalTo(C.classNumberViewWidth)
                make.left.equalToSuperview()
                if i == 0 {
                    // 第一个
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(courseCountLabels[i-1].snp.bottom)
                }
            }
            courseCountLabels.append(label)
        }
        // 最后一个
        courseCountLabels.last!.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }

        for i in 0..<7 {
            // 每天的 tableView
            let tableView = UITableView()
            tableViews.append(tableView)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            // 为了对应每天
            tableView.tag = i
            tableView.contentInset.bottom = 64
            tableView.allowsSelection = false
            contentView.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.top.equalTo(courseCountLabels[0].snp.top)
                make.bottom.equalToSuperview()
                if i == 0 {
                    make.left.equalTo(courseCountLabels[0].snp.right)
                } else {
                    make.left.equalTo(tableViews[i-1].snp.right)
                }
                if i == 7 - 1 {
                    tableView.snp.makeConstraints { make in
                        make.right.equalToSuperview()
                    }
                }
                make.height.equalTo(CGFloat(C.courseCount) * C.cellHeight)
                make.width.equalTo(C.cellWidth)
            }
            tableView.isScrollEnabled = false
        }

        // 因为 tableView 在 scrollView 上，所以手势被屏蔽了 需要手动添加
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTouch(sender:)))
        updownContentView.addGestureRecognizer(recognizer)
    }

    @objc func tableViewTouch(sender: UITapGestureRecognizer) {
        // 算出相对第一个 tableView 的点击位置
        let location = sender.location(in: tableViews[0])
        let index = Int(location.x / C.cellWidth)
        // 算出相对被点击的 tabelView 的 indexPath
        let realLocation = sender.location(in: tableViews[index])
        let indexPath = tableViews[index].indexPathForRow(at: realLocation)
        if let indexPath = indexPath {
            // 代理事件
            let model = coursesForDay[index][indexPath.row]
            self.delegate?.listView(self, didSelectCourse: model)
        }
    }

    func load(courses: [[ClassModel]], weeks: Int) {
        let dayInMonth = DateTool.getWeekDayAfter(weeks: weeks)
        var dayTitles = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        for i in 0..<C.dayCount {
            dayNumberLabels[i].text = dayTitles[i] + "\n" + dayInMonth[i+1]
        }
        monthLabel.text = dayInMonth[0]
        coursesForDay = courses
        self.tableViews.forEach({ $0.reloadData() })
    }

    deinit {
        self.delegate = nil
    }

}

extension CourseListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesForDay[tableView.tag].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 构造 cell
        var model = coursesForDay[tableView.tag][indexPath.row]
        let cell = CourseCell(style: .default, reuseIdentifier: "reuse[\(tableView.tag)]\(indexPath)")
        if model.courseID.count > 0, model.courseID.hasPrefix("-") {
            model.colorIndex = 8
        }
        cell.load(course: model)
        return cell
    }
}

extension CourseListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = coursesForDay[tableView.tag][indexPath.row]
        return CGFloat(model.arrange[0].length) * C.cellHeight
    }
}

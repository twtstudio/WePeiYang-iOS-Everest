//
//  CourseListView.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/22.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

fileprivate struct C {
    static var cellWidth: CGFloat {
        return (UIScreen.main.bounds.width - classNumberViewWidth) / 7
    }// = 47
    static let cellHeight: CGFloat = 55
    static let dayCount = 7
    static let courseCount = 12
    
    static let classNumberViewWidth: CGFloat = 30
    static let dayNumberViewHeight: CGFloat = 30
}

protocol CourseListViewDelegate {
    /// 选中课程
    ///
    /// - Parameters:
    ///   - listView: 所在的 listView
    ///   - course: 被选中的课程
    func listView(_ listView: CourseListView, didSelectCourse course: ClassModel)
}

protocol CourseListViewDataSource {
//    var
    func courses(in day: Int) -> [ClassModel]
    func dayTitles() -> [String]
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
    
    var delegate: CourseListViewDelegate?
    var dataSource: CourseListViewDataSource? {
        didSet {
//            self.reloadData()
        }
    }
    // 周一到周日
    private var days: [Int] = [1, 2, 3, 4, 5, 6, 7]
    var coursesForDay: [[ClassModel]] = [[], [], [], [], [], [], []]
    
    var week: [[ClassModel]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        classNumberView = UIView(frame: .zero)
        dayNumberView = UIView(frame: .zero)
        updownContentView = UIScrollView(frame: .zero)
        updownContentView.showsVerticalScrollIndicator = false
        
        self.addSubview(dayNumberView)
        
        // 周几 label 的底板
        dayNumberView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(C.dayNumberViewHeight)
        }
        
        // 进行周几标签的布局
        var dayTitles = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        var dayNumberLabels: [UILabel] = []
        for i in 0..<C.dayCount {
            let label = UILabel(frame: .zero)
            label.text = dayTitles[i]
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = .lightGray
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
            label.text = "\(i+1)"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .lightGray
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
    
    func tableViewTouch(sender: UITapGestureRecognizer) {
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
            print(model)
        }
    }

    func load(courses: [[ClassModel]]) {
        coursesForDay = courses
        self.tableViews.forEach({ $0.reloadData() })
    }
    
    func load(table: ClassTableModel, week: Int) {
        coursesForDay = [[], [], [], [], [], [], []]
        var classes = [] as [ClassModel]
//        var coursesForDay: [[ClassModel]] = []
        for course in table.classes {
            // 对 week 进行判定
            // 起止周
            if week < Int(course.weekStart)! || week > Int(course.weekEnd)! {
                // TODO: turn gray
                continue
            }

            // 每个 arrange 变成一个
            for arrange in course.arrange {
                let day = arrange.day-1
                // 如果是实习什么的课
                if day < 0 || day > 6 {
                    continue
                }
                // 对 week 进行判定
                // 单双周
                if (week % 2 == 0 && arrange.week == "单周")
                || (week % 2 == 1 && arrange.week == "双周") {
                    // TODO: turn gray
                    continue
                }

                var newCourse = course
                newCourse.arrange = [arrange]
                classes.append(newCourse)
                coursesForDay[day].append(newCourse)
            }
        }
        
        for day in 0..<7 {
            var array = coursesForDay[day]
            // 按课程开始时间排序
            array.sort(by: { a, b in
                return a.arrange[0].start < b.arrange[0].start
            })
            
            var lastEnd = 0
            for course in array {
                // 如果两节课之前有空格，加入长度为一的占位符
                if (course.arrange[0].start-1) - (lastEnd+1) >= 0 {
                    // 从上节课的结束到下节课的开始填满
                    for i in (lastEnd+1)...(course.arrange[0].start-1) {
                        // 构造一个假的 model
                        let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(course.arrange[0].day)\", \"start\":\"\(i)\", \"end\":\"\(i)\"}]}")!
                        // placeholders[i].append(placeholder)
                        array.append(placeholder)
                    }
//                    for i in (lastEnd+1)..<(course.arrange[0].start-1) {
//                        // 构造一个假的 model
//                        let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(course.arrange[0].day)\", \"start\":\"\(i)\", \"end\":\"\(i+1)\"}]}")!
//                        // placeholders[i].append(placeholder)
//                        array.append(placeholder)
//                    }
                }
                lastEnd = course.arrange[0].end
            }
            // 按开始时间进行排序
            array.sort(by: { $0.0.arrange[0].start < $0.1.arrange[0].start })
            coursesForDay[day] = array
        }
        // 所有 tableView reloadData
        self.tableViews.forEach({ $0.reloadData() })
    }
}

extension CourseListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return C.courseCount
        return coursesForDay[tableView.tag].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 构造 cell
        let model = coursesForDay[tableView.tag][indexPath.row]
        let cell = CourseCell(style: .default, reuseIdentifier: "reuse[\(tableView.tag)]\(indexPath)")
        cell.load(course: model)
        return cell
    }
}

extension CourseListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = coursesForDay[tableView.tag][indexPath.row]
        return CGFloat(model.arrange[0].length) * C.cellHeight
    }
    
    // 下面方法没用
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let model = coursesForDay[tableView.tag]?[indexPath.row] {
//            self.delegate?.listView(self, didSelectCourse: model)
//            print(model.courseName)
//        }
//    }
}

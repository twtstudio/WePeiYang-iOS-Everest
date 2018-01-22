//
//  ClassTableViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

let ClassTableKey = "ClassTableKey"
class ClassTableViewController: UIViewController {
    
    var listView: CourseListView!
    var weekSelectView: WeekSelectView!
    var table: ClassTableModel?
    var currentWeek: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        initNavBar()
        
        // 选择周
        weekSelectView = WeekSelectView()
        self.view.addSubview(weekSelectView)
        weekSelectView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-60)
            make.height.equalTo(60)
            make.left.right.equalToSuperview()
        }
        weekSelectView.subviews.forEach { v in
            if v is WeekItemCell {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(setCurrentWeek))
                v.addGestureRecognizer(gesture)
            }
        }
        
        // 课表主视图
        listView = CourseListView()
        self.view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(weekSelectView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    
        loadCache()
        load()
    }
    
    func initNavBar() {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        backView.addSubview(button)
        button.setTitle("第\(currentWeek)周", for: .normal)
        button.setTitleColor(.black, for: .normal)
        self.navigationItem.titleView = backView
        button.addTarget(self, action: #selector(toggleWeekSelect), for: .touchUpInside)
    }
    
    func setCurrentWeek(sender: UITapGestureRecognizer) {
        guard let cell = sender.view,
        let table = table else {
            return
        }
        currentWeek = cell.tag
        let courses = self.getCourse(table: table, week: currentWeek)
        listView.load(courses: courses)
    }
    
    func toggleWeekSelect(sender: UIButton) {
        if sender.tag == 0 {
            self.weekSelectView.snp.updateConstraints { make in
                make.top.equalToSuperview()
            }
            sender.tag = 1
        } else {
            self.weekSelectView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(-60)
            }
            sender.tag = 0
        }
        
        // 告诉self.view约束需要更新
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
        })
    }
    
    func loadCache() {
        if let dic = CacheManager.loadGroupCache(withKey: ClassTableKey) as? [String: Any], let table = Mapper<ClassTableModel>().map(JSON: dic) {
            self.table = table
            let courses = self.getCourse(table: table, week: currentWeek)
            listView.load(courses: courses)
            self.updateWeekItem()
//            self.listView.load(table: table, week: currentWeek)
        }
    }
    
    func load() {
        ClasstableDataManager.getClassTable(success: { table in
            let dic = table.toJSON()
            CacheManager.saveGroupCache(with: dic, key: ClassTableKey)
            self.table = table
            self.updateWeekItem()

            let courses = self.getCourse(table: table, week: self.currentWeek)
            self.listView.load(courses: courses)
        }, failure: { errorMessage in
            print(errorMessage)
        })
    }
}

extension ClassTableViewController {
    func getCourse(table: ClassTableModel, week: Int) -> [[ClassModel]] {
        var coursesForDay: [[ClassModel]] = [[], [], [], [], [], [], []]
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
            // 补下剩余的空白
            if lastEnd < 12 {
                for i in (lastEnd+1)...12 {
                    // 构造一个假的 model
                    let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(day)\", \"start\":\"\(i)\", \"end\":\"\(i)\"}]}")!
                    // placeholders[i].append(placeholder)
                    array.append(placeholder)
                }
            }
            // 按开始时间进行排序
            array.sort(by: { $0.0.arrange[0].start < $0.1.arrange[0].start })
            coursesForDay[day] = array
        }
        return coursesForDay
    }
    
    func updateWeekItem() {
        guard let table = table,
            var cells = weekSelectView.subviews.filter({ $0 is WeekItemCell }) as? [WeekItemCell],
        cells.count == 22 else {
            return
        }
        cells.sort(by: { a, b in
            a.tag < b.tag
        })
        
        for i in 1...22 {
            let courses = getCourse(table: table, week: i)
            var matrix: [[Bool]] = [[], [], [], [], []]
            for i in 0..<5 {
                matrix[i] = [false, false, false, false, false]
            }
            
            let items = [1, 3, 5, 7, 9]
            let classes = courses.flatMap { $0 }
            
            // day, index
            var coordinates: [(Int, Int, Bool)] = []
            for course in classes {
                if course.arrange.first!.day > 5 || course.arrange.first!.day <= 0 {
                    continue
                }
                for i in course.arrange.first!.start...course.arrange.first!.end {
                    if i > 9 {
                        continue
                    }
                    if !items.contains(i) {
                        continue
                    }
                    let isReal = course.courseName != "" ? true : false
                    coordinates.append((course.arrange.first!.day-1, i, isReal))
                    let orig = matrix[i/2][course.arrange.first!.day-1]
                    matrix[i/2][course.arrange.first!.day-1] = isReal || orig
                }
            }
            
            /*
            // 抽取每行中的双数下标的元素
            let sub1 = courses.map { items in
                return items.enumerated().filter { index, item in
                    return index % 2 == 0
                    }.map { $0.1 }
            }
            // 抽取每行中的单数下标的元素
            let sub2 = courses.map { items in
                return items.enumerated().filter { index, item in
                    return index % 2 == 1
                    }.map { $0.1 }
            }
            let matrix = zip(sub1, sub2).map { (arg) -> [Bool] in
                let (arr1, arr2) = arg
                return zip(arr1, arr2).map {
                    return $0.courseName != "" || $1.courseName != ""
                }
            }
             */
            let cell = cells[i-1]
            cell.load(courses: matrix, week: i)
        }
    }
}

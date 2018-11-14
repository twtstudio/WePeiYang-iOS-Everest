//
//  ClassTableViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import PopupDialog

class ClassTableViewController: UIViewController {

    var listView: CourseListView!
    var weekSelectView: WeekSelectView!
    var table: ClassTableModel? {
        didSet {
            updateWeekItem()
        }
    }
    var weekCourseDict: [Int: [[ClassModel]]] = [:]

    var backButton: UIButton!
    // 当前的周
    var currentWeek: Int = 1
    // 当前显示的周
    var currentDisplayWeek: Int = 1 {
        willSet {
            if let cells = weekSelectView.subviews.filter({ $0 is WeekItemCell }) as? [WeekItemCell] {
                cells.forEach { cell in
                    cell.dismissSelected()
                }

                if newValue - 1 < cells.count {
                    cells[newValue-1].setSelected()
                }
            }

            backButton.setTitle("第\(newValue)周", for: .normal)
            backButton.sizeToFit()
            backButton.frame.origin.x = (90 - (backButton.width + 15))/2
            if currentWeek != newValue {
                backButton.setTitleColor(UIColor(red: 0.98, green: 0.26, blue: 0.27, alpha: 1.00), for: .normal)
            } else {
                backButton.setTitleColor(UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00), for: .normal)
            }
            // 刷新标题栏
            self.navigationItem.titleView?.subviews.forEach { v in
                // 显示 label
                if v.tag == 1 {
                    if currentWeek != newValue {
                        v.isHidden = false
                    } else {
                        v.isHidden = true
                    }
                } else if v.tag == 2 {
                    v.frame.origin.x = backButton.frame.origin.x + backButton.width
                }
            }
        }
    }
    var isSelecting = false {
        didSet {
            for v in self.navigationItem.titleView?.subviews ?? [] where v.tag == 2 {
                if isSelecting {
                    // 旋转 pi
                    v.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                } else {
                    // 复位
                    v.transform = CGAffineTransform.identity
                }
            }
        }
    }

    private var refreshButton: UIView? {
        let button = navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
        button?.layer.anchorPoint = CGPoint(x: 0.54, y: 0.54)
        return button
    }

    private var isRefreshing: Bool = false

    private func startRotating() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi
        rotationAnimation.duration = 0.5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = 1000
        refreshButton?.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    private func stopRotating() {
        refreshButton?.layer.removeAllAnimations()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        hidesBottomBarWhenPushed = true
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

        // 加上点击事件
        let gesture = UITapGestureRecognizer(target: self, action: #selector(weekCellTapped))
        gesture.cancelsTouchesInView = false
        weekSelectView.addGestureRecognizer(gesture)

        // 课表主视图
        listView = CourseListView()
        listView.delegate = self
        self.view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(weekSelectView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        if isModal {
            let image = UIImage(named: "ic_back")!
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        }

        loadCache()
        if TwTUser.shared.tjuBindingState {
            perform(#selector(load), with: nil, afterDelay: 1)
        }
    }

    private func checkBindingState() {
        // not bind
        if !TwTUser.shared.tjuBindingState {
            let popup = PopupDialog(title: "未绑定办公网", message: "微北洋的服务依赖于选课网，若要使用课程表查询功能，请先绑定办公网。", buttonAlignment: .horizontal)
            let cancelButton = CancelButton(title: "取消", action: {
                if let table = self.table {
                    let message = "未绑定办公网，已加载缓存\n缓存时间: " + table.updatedAt
                    SwiftMessages.showWarningMessage(body: message)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            let bindButton = DefaultButton(title: "绑定", action: {
                let vc = TJUBindingViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.completion = { success in
                    if success {
                        self.load()
                    }
                }
                self.present(vc, animated: true)
            })
            popup.addButtons([cancelButton, bindButton])
            self.present(popup, animated: true, completion: nil)
        }
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

    func initNavBar() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        let downArrow = UIImageView(image: #imageLiteral(resourceName: "ic_arrow_down").with(color: UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)))
        downArrow.frame = CGRect(x: 70, y: 8, width: 15, height: 15)
        downArrow.tag = 2

        titleView.addSubview(downArrow)
        backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 30))
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.setTitle("第\(currentDisplayWeek)周", for: .normal)
        backButton.setTitleColor(UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00), for: .normal)
        backButton.sizeToFit()
        backButton.frame.origin.x = (90 - (backButton.width + 15))/2
        downArrow.frame.origin.x = backButton.frame.origin.x + backButton.width
        backButton.tag = -1
        titleView.addSubview(backButton)

        let backLabel = UILabel(frame: CGRect(x: 0, y: 25, width: 75, height: 10))
        backLabel.backgroundColor = .clear
        backLabel.textColor = UIColor(red: 0.98, green: 0.26, blue: 0.27, alpha: 1.00)
        backLabel.textAlignment = .center
        backLabel.font = UIFont.systemFont(ofSize: 8)
        backLabel.text = "返回本周"
        backLabel.isHidden = true
        backLabel.tag = 1
        titleView.addSubview(backLabel)

        self.navigationItem.titleView = titleView
        backButton.addTarget(self, action: #selector(toggleWeekSelect), for: .touchUpInside)

        // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(load))
        let refreshBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(load))
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItems = [refreshBarButton, addBarButton]
    }

    @objc func weekCellTapped(sender: UITapGestureRecognizer) {
//        guard let cell = sender.view,
////        cell.tag - 1 < cells.count,
//        cell.tag > 0,
        guard let table = table else {
                return
        }
        let point = sender.location(in: weekSelectView)
        let week = Int(point.x / 50) + 1

//        let week = cell.tag
        let courses = self.getCourse(table: table, week: week)
        listView.load(courses: courses, weeks: week - currentWeek)
        currentDisplayWeek = week
    }

    @objc func toggleWeekSelect(sender: UIButton) {
        guard let table = table else {
            return
        }

        if !isSelecting {
            // 收起状态 -> 展开状态
            self.weekSelectView.snp.updateConstraints { make in
                make.top.equalToSuperview()
            }
            isSelecting = true
            // 点开居中
            // TODO: 确定多少比较合适
            if currentDisplayWeek <= 22 && currentDisplayWeek >= 4 {
                weekSelectView.contentOffset = CGPoint(x: (CGFloat(currentDisplayWeek)-3.5)*50-25, y: 0)
            }
        } else {
            // 展开状态 -> 收起状态
            if currentDisplayWeek != currentWeek {
                currentDisplayWeek = currentWeek
                let courses = self.getCourse(table: table, week: currentWeek)
                // 跳回当前周
                listView.load(courses: courses, weeks: 0)
            }
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()

            self.weekSelectView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(-60)
            }
            isSelecting = false
        }

        // 告诉self.view约束需要更新
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
        })
    }

    func loadCache() {
        CacheManager.retreive("classtable/classtable.json", from: .group, as: String.self, success: { string in
            if let table = Mapper<ClassTableModel>().map(JSONString: string) {
                self.table = table
                self.weekCourseDict = [:]
                let now = Date()
                let termStart = Date(timeIntervalSince1970: Double(table.termStart))
                var week = now.timeIntervalSince(termStart)/(7.0*24*60*60) + 1
                if week < 1 {
                    week = 1
                }
                self.currentWeek = Int(week)
                self.currentDisplayWeek = Int(week)
                let courses = self.getCourse(table: table, week: self.currentWeek)
                self.listView.load(courses: courses, weeks: 0)
            }
        }, failure: {
            SwiftMessages.showLoading()
        })
    }

    @objc func load() {
        guard isRefreshing == false else {
            return
        }
        isRefreshing = true
        startRotating()
        ClasstableDataManager.getClassTable(success: { table in
            self.isRefreshing = false
            self.stopRotating()
            SwiftMessages.hideLoading()
            if let oldTable = self.table,
                oldTable.updatedAt > table.updatedAt,
                table.updatedAt.contains("2017-04-01") {
                // 如果新的还不如旧的
                // 那就不刷新
                SwiftMessages.showWarningMessage(body: "服务器故障\n缓存时间: \(oldTable.updatedAt)", context: SwiftMessages.PresentationContext.view(self.view))
                return
            }

            if UserDefaults.standard.bool(forKey: ClassTableNotificationEnabled) {
                ClassTableNotificationHelper.addNotification(table: table)
            }
            let string = table.toJSONString() ?? ""
            CacheManager.store(object: string, in: .group, as: "classtable/classtable.json")
            self.table = table
            let now = Date()
            let termStart = Date(timeIntervalSince1970: Double(table.termStart))
            CacheManager.saveGroupCache(with: termStart, key: "TermStart")

            var week = now.timeIntervalSince(termStart)/(7.0*24*60*60) + 1
            if week < 1 {
                week = 1
            }
            self.currentWeek = Int(week)
            self.currentDisplayWeek = Int(week)
            self.weekCourseDict = [:]
            let courses = self.getCourse(table: table, week: self.currentWeek)
            // 和本周的差距
            SwiftMessages.showSuccessMessage(body: "刷新成功\n更新时间: \(table.updatedAt)", context: SwiftMessages.PresentationContext.view(self.view))

            self.listView.load(courses: courses, weeks: 0)
        }, failure: { errorMessage in
            self.isRefreshing = false
            self.stopRotating()
            SwiftMessages.hideLoading()
            SwiftMessages.showErrorMessage(body: errorMessage)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.isTranslucent = false

        checkBindingState()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
}

extension ClassTableViewController {
    func getCourse(table: ClassTableModel, week: Int) -> [[ClassModel]] {
        if let dict = weekCourseDict[week] {
            return dict
        }
        // TODO: optimize

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
                // TODO: 这个是啥来着?
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
            array.sort(by: { $0.arrange[0].start < $1.arrange[0].start })
            coursesForDay[day] = array
        }
        weekCourseDict[week] = coursesForDay
        return coursesForDay
    }

    // 刷新缩略图
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
            for index in 0..<5 {
                matrix[index] = [false, false, false, false, false]
            }

            let classes = courses.flatMap { $0 }

            // day, index
            for course in classes {
                if course.courseName == "" || course.arrange.first!.day > 5 || course.arrange.first!.day <= 0 {
                    continue
                }

                for num in course.arrange.first!.start...course.arrange.first!.end {
                    if num > 9 || num < 0 {
                        break
                    }

                    let start = (num - 1) / 2
                    matrix[start][course.arrange.first!.day-1] = true
                }
            }

            let cell = cells[i-1]
            cell.load(courses: matrix, week: i)
        }
    }
}

extension ClassTableViewController: CourseListViewDelegate {
    func listView(_ listView: CourseListView, didSelectCourse course: ClassModel) {
        guard let table = table else {
            return
        }
        if course.courseName == "" {
            // TODO: 手动添加课程
            return
        }

        // 相似课程
//        let similiarCourses = table.classes.filter { $0.courseID == course.courseID }
        let similiarCourses = table.classes.filter { $0.courseName == course.courseName }
        var singleArrangeCourses = [ClassModel]()
        // 每个 arrange 作为一个 class
        for course in similiarCourses {
            for arrange in course.arrange {
                var newCourse = course
                newCourse.arrange = [arrange]
                singleArrangeCourses.append(newCourse)
            }
        }
        let detailVC = ClassDetailViewController(courses: singleArrangeCourses)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

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

    private var listView: CourseListView!
    private var weekSelectView: WeekSelectView!
    private var weekCourseDict: [Int: [[ClassModel]]] = [:] {
        didSet {
            self.updateWeekItem()
        }
    }

    private var backButton: UIButton!
    // 当前的周
    private var currentWeek: Int = 1
    // 当前显示的周
    private var currentDisplayWeek: Int = 1 {
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
    private var isSelecting = false {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshClassTable(_:)), name: NotificationName.NotificationClassTableWillRefresh.name, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshClassTable(_ notification: Notification) {
        if TwTUser.shared.tjuBindingState {
            self.load()
        }
    }

    private func checkBindingState() {
        // not bind
        if !TwTUser.shared.tjuBindingState {
            let popup = PopupDialog(title: "未绑定办公网", message: "微北洋的服务依赖于选课网，若要使用课程表查询功能，请先绑定办公网。", buttonAlignment: .horizontal)
            let cancelButton = CancelButton(title: "取消", action: {
                if let table = AuditUser.shared.mergedTable {
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
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(audit))
        navigationItem.rightBarButtonItems = [refreshBarButton, addBarButton]
    }

    @objc func weekCellTapped(sender: UITapGestureRecognizer) {
        let point = sender.location(in: weekSelectView)
        let week = Int(point.x / 50) + 1

        if let courses = self.weekCourseDict[week] {
            listView.load(courses: courses, weeks: week - self.currentWeek)
        }
        self.currentDisplayWeek = week
    }

    @objc func toggleWeekSelect(sender: UIButton) {
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
                // 跳回当前周
                if let course = self.weekCourseDict[currentWeek] {
                    self.listView.load(courses: course, weeks: 0)
                }
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
                let now = Date()
                let termStart = Date(timeIntervalSince1970: Double(table.termStart))
                var week = now.timeIntervalSince(termStart)/(7.0*24*60*60) + 1
                if week < 1 {
                    week = 1
                }
                self.currentWeek = Int(week)
                self.currentDisplayWeek = Int(week)

                AuditUser.shared.updateCourses(originTable: table, isStore: false)
                var weekDic = [Int: [[ClassModel]]]()
                for week in 1...22 {
                    weekDic[week] = AuditUser.shared.getCourseListModel(week: week)
                }
                self.weekCourseDict = weekDic

                if let courses = self.weekCourseDict[self.currentWeek] {
                    self.listView.load(courses: courses, weeks: self.currentWeek)
                }
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
        
        var originTable: ClassTableModel?
        var auditItems: [AuditDetailCourseItem]?
        
        let group = DispatchGroup()
        group.enter()
        ClasstableDataManager.getClassTable(success: { table in
            if let oldTable = AuditUser.shared.mergedTable,
                oldTable.updatedAt > table.updatedAt,
                table.updatedAt.contains("2017-04-01") {
                // 如果新的还不如旧的
                // 那就不刷新
                SwiftMessages.showWarningMessage(body: "服务器故障\n缓存时间: \(oldTable.updatedAt)", context: SwiftMessages.PresentationContext.view(self.view))
                group.leave()
                return
            }
            originTable = table
            group.leave()
        }, failure: { error in
            let msg = error.localizedDescription
            guard let error = error as? WPYCustomError else {
                SwiftMessages.showErrorMessage(body: msg)
                return
            }

            switch error {
            case .custom(let msg):
                SwiftMessages.showErrorMessage(body: msg)
            case .errorCode(let code, _):
                if code == 40010 {
                    SwiftMessages.showErrorMessage(body: "办公网密码错误，请重新绑定办公网")
                    AccountManager.unbind(url: BindingAPIs.unbindTJUAccount, success: {
                        TWTKeychain.erase(.tju)
                        TwTUser.shared.tjuBindingState = false

                        let bindVC = TJUBindingViewController()
                        bindVC.hidesBottomBarWhenPushed = true
                        bindVC.completion = { success in
                            if success {
                                self.load()
                            }
                        }
                        UIViewController.top?.present(bindVC, animated: true, completion: nil)
                    }, failure: { err in
                        SwiftMessages.showErrorMessage(body: err.localizedDescription)
                    })
                }
            }
            group.leave()
        })
        
        group.enter()
        ClasstableDataManager.getPersonalAuditList(success: { model in
            auditItems = []
            model.data.forEach { list in
                let college = list.college
                list.infos.forEach { item in
                    var item = item
                    item.courseCollege = college
                    auditItems!.append(item)
                }
            }
            AuditCacheManager.load(model: model)
            group.leave()
        }, failure: { errStr in
            SwiftMessages.showErrorMessage(body: errStr)
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) {
            self.isRefreshing = false
            self.stopRotating()
            
            guard let table = originTable, let auditItems = auditItems else {
                return
            }
            
            AuditUser.shared.updateCourses(originTable: table, auditCourses: auditItems, isStore: true)
            
            let now = Date()
            let termStart = Date(timeIntervalSince1970: Double(table.termStart))
            var week = now.timeIntervalSince(termStart)/(7.0*24*60*60) + 1
            if week < 1 {
                week = 1
            }
            self.currentWeek = Int(week)
            self.currentDisplayWeek = Int(week)

            var weekDic = [Int: [[ClassModel]]]()
            for week in 1...22 {
                weekDic[week] = AuditUser.shared.getCourseListModel(week: week)
            }
            self.weekCourseDict = weekDic

            if let courses = self.weekCourseDict[self.currentWeek] {
                self.listView.load(courses: courses, weeks: self.currentWeek)
            }
            // 和本周的差距
            SwiftMessages.showSuccessMessage(body: "刷新成功\n更新时间: \(table.updatedAt)", context: SwiftMessages.PresentationContext.view(self.view))
        }
        
    }
    
    @objc func audit() {
        navigationController?.pushViewController(AuditHomeViewController(), animated: true)
    }
    
//    @objc func audit() {
//        navigationController?.pushViewController(AuditHomeViewController(), animated: true)
//    }

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

        self.listView.cancelEmptyView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
}

extension ClassTableViewController {
    // 刷新缩略图
    func updateWeekItem() {
        guard var cells = weekSelectView.subviews.filter({ $0 is WeekItemCell }) as? [WeekItemCell], cells.count == 22 else {
            return
        }
        cells.sort(by: { a, b in
            a.tag < b.tag
        })

        for i in 1...22 {
            guard let courses = self.weekCourseDict[i] else {
                return
            }
            var matrix: [[Bool]] = [[], [], [], [], []]
            for index in 0..<5 {
                matrix[index] = [false, false, false, false, false]
            }

            let classes = courses.flatMap { $0 }

            // day, index
            for course in classes {
                if course.courseName == "" || course.arrange.first!.day > 5 || course.arrange.first!.day <= 0 || i < Int(course.weekStart)! || i > Int(course.weekEnd)! || course.courseName.hasPrefix("[非本周]") {
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
        guard let table = AuditUser.shared.mergedTable else {
            return
        }

        let similiarCourses = table.classes.filter { $0.courseID == course.courseID }
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

    func collectionView(_ listView: CourseCollectionView, didSelectCourse course: ClassModel) {
        guard let table = AuditUser.shared.mergedTable else {
            return
        }

        let similiarCourses = table.classes.filter { $0.courseID == course.courseID }
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

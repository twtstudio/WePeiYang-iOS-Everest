//
//  LessonListViewController.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/10/15.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
import PopupDialog

class PLessonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var searchController = UISearchController()
    
    var searchArray:[QuesBasicInfo] = [QuesBasicInfo]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var resultArray: [QuesBasicInfo] = [QuesBasicInfo]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: 需要参数
    var courseName: String = {
        return PracticeFigure.className
    }()
    
    var classId: Int = {
        return Int(PracticeFigure.classID)!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        getListWith(classId: classId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor.practiceBlue
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = courseName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return searchArray.count
        } else {
            return resultArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var text: String = ""
        let cellId = "lessonCell"
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        
        cell.accessoryType = .disclosureIndicator
        if self.searchController.isActive {
            text = searchArray[indexPath.item].courseName
        } else {
            text = resultArray[indexPath.item].courseName
        }
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 弹出做题模式选择框
        let cell = self.tableView(self.tableView, cellForRowAt: indexPath)
        if self.searchController.isActive {
            PracticeFigure.courseID = String(searchArray[indexPath.item].id)
        } else {
            PracticeFigure.courseID = String(resultArray[indexPath.item].id)
        }
        guard let title = cell.textLabel?.text else { return }
        presentWarningCard(with: title, of: PracticeFigure.classID)
    }

}

extension PLessonListViewController: UISearchResultsUpdating
{
    // 实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        self.searchArray = self.resultArray.filter { (quesInfo) -> Bool in
            return quesInfo.courseName.contains(searchController.searchBar.text!)
        }
    }
}

// 各个控件初始化设置部分
extension PLessonListViewController: UISearchBarDelegate {
    private func setupSearchController() {
        self.searchController = ({
//            let vc = PLessonListViewController()
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self   //两个样例使用不同的代理
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.definesPresentationContext = false
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
//
        // 搜索框
        let bar = searchController.searchBar
        // 样式
        bar.barStyle = .default
        // 设置光标及取消按钮的颜色
        bar.tintColor = UIColor.practiceBlue
        // 设置代理
        bar.delegate = self
        // 提示
        bar.placeholder = "课程躲起来了？"

    }
    
    private func setupNavBar(){
        self.navigationController?.navigationBar.backgroundColor = .blue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19)]
        navigationItem.title = "课程列表"
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: deviceWidth, height: deviceHeight - 64), style: .grouped)
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
    }
    
    private func presentWarningCard(with title: String, of classId: String) {
        let warningCard = PopupDialog(title: title, message: "请选择练习模式", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
        let leftButton = PracticePopupDialogButton(title: "顺序练习", dismissOnTap: true) {
            PracticeFigure.currentCourseIndex = "0"
            // TODO: 点击卡片，进入练习
            let warningCard = PopupDialog(title: title, message: "请选择题目类型", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
            let leftButton = PracticePopupDialogButton(title: "单选", dismissOnTap: true) {
                PracticeFigure.questionType = "0"
                self.navigationController?.pushViewController(ExerciseCollectionViewController(), animated: true)
            }
            let centerButton = PracticePopupDialogButton(title: "多选", dismissOnTap: true) {
                PracticeFigure.questionType = "1"
                self.navigationController?.pushViewController(ExerciseCollectionViewController(), animated: true)
            }
            let rightButton = PracticePopupDialogButton(title: "判断", dismissOnTap: true) {
                PracticeFigure.questionType = "2"
                self.navigationController?.pushViewController(ExerciseCollectionViewController(), animated: true)
            }
            warningCard.addButtons([leftButton, centerButton, rightButton])
            self.present(warningCard, animated: true, completion: nil)
        }
        let rightButton = PracticePopupDialogButton(title: "模拟考试", dismissOnTap: true) {
            // TODO: 进入模拟考试
            self.navigationController?.pushViewController(QuizCollectionViewController(), animated: true)
        }
        warningCard.addButtons([leftButton, rightButton])
        self.present(warningCard, animated: true, completion: nil)
    }
}

extension PLessonListViewController {
    // 获取课程列表数组
    private func getListWith(classId: Int) {
        getCourseList(classId: classId, success: { (courseArray) in
            self.resultArray = courseArray
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }) { (err) in
            debugLog(err)
        }
    }
    
    private func getCourseList(classId: Int, success: @escaping ([QuesBasicInfo]) -> (), failure: (Error) -> ()) {
        SolaSessionManager.solaSession(baseURL: "https://exam.twtstudio.com", url: "/api/class/\(classId)", success: { (dic) in
            var array: [QuesBasicInfo] = []
            if let data = dic["data"] as? [[String: Any]] {
                for i in 0..<data.count {
                    let id = data[i]["id"] as? Int ?? 0
                    let courseName = data[i]["course_name"] as? String ?? ""
                    let quesInfo = QuesBasicInfo(id: id, courseName: courseName)
                    array.append(quesInfo)
                    debugLog(quesInfo)
                }
            }
            success(array)
        }) { (err) in
            debugLog(err)
        }
    }
}

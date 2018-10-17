//
//  LessonListViewController.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/10/15.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class PLessonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    var resultArray: [QuesBasicInfo] = []
    let searchBarH: CGFloat = 30
    
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
        getListWith(classId: classId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor.practiceBlue
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = courseName
    }
    
    private func setupNavBar(){
        self.navigationController?.navigationBar.backgroundColor = .blue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19)]
        navigationItem.title = "课程列表"
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar(frame:CGRect(x: 0, y: 120, width: 0.7 * view.bounds.width, height:50))
        searchBar.placeholder = "搜索"
        searchBar.backgroundColor = .white
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = searchBarH / 2
        searchBar.layer.borderColor = UIColor.practiceBlue.cgColor
        searchBar.layer.backgroundColor = UIColor.white.cgColor
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchBarH * 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchView = UIView()
        searchView.frame = CGRect(x: 0, y: 0, width: 0.9 * deviceWidth, height: searchBarH)
        searchView.backgroundColor = .white
        
        setupSearchBar()
        searchView.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.center.equalTo(searchView)
            make.height.equalTo(searchBarH)
            make.width.equalTo(0.9 * deviceWidth)
        }
        return searchView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "lessonCell"
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = resultArray[indexPath.item].courseName
        debugLog(resultArray[indexPath.item].courseName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 跳转到课程界面
    }
}

extension PLessonListViewController {
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

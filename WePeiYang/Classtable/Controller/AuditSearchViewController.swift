//
//  AuditSearchViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/21.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class AuditSearchViewController: UIViewController {
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsScopeBar = true
        searchBar.barTintColor = .white
        searchBar.placeholder = "搜索"
        searchBar.scopeButtonTitles = ["课程", "学院"]
        return searchBar
    }()
    private var tableView: UITableView!
    
    private struct CourseInfo {
        let name: String
        let college: String
        let courseID: Int
    }
    private var courseList: [CourseInfo] = []
    private var collegeList: [AuditCollegeItem] = []
    
    private enum SearchType: Int {
        case course = 0
        case college
    }
    private var searchType: SearchType = .course
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "搜索"
        
        searchBar.delegate = self
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
            searchField.becomeFirstResponder()
        }
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.rowHeight = 70
        
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        AuditUser.shared.load()
        
    }
    
}

extension AuditSearchViewController {
    func search(with keyword: String) {
        guard !keyword.isEmpty else {
            return
        }
        
        switch self.searchType {
        case .college:
            ClasstableDataManager.getAllColleges(success: { model in
                self.collegeList = model.data.filter {
                    return $0.collegeName.contains(keyword)
                }
                self.tableView.reloadData()
            }, failure: { errStr in
                log(errStr)
            })
        case .course:
            ClasstableDataManager.searchCourse(courseName: keyword, success: { model in
                self.courseList = model.data.map { item in
                    let collegeName = AuditUser.shared.getCollegeName(ID: item.collegeID)
                    return CourseInfo(name: item.name, college: collegeName, courseID: item.id)
                }
                self.tableView.reloadData()
            }, failure: { errStr in
                log(errStr)
            })
        }
    }
}

extension AuditSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBarTextDidEndEditing(searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        self.search(with: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if let type = SearchType(rawValue: selectedScope), let searchText = searchBar.text {
            self.searchType = type
            self.tableView.reloadData()
            self.search(with: searchText)
        }
    }
}

extension AuditSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch self.searchType {
        case .course:
            let detailVC = AuditDetailViewController(courseID: String(self.courseList[indexPath.row].courseID))
            self.navigationController?.pushViewController(detailVC, animated: true)
        case .college:
            let collegeCourseVC = AuditCollegeCourseViewController(collegeName: self.collegeList[indexPath.row].collegeName, collegeID: String(self.collegeList[indexPath.row].collegeID))
            self.navigationController?.pushViewController(collegeCourseVC, animated: true)
        }
    }
}

extension AuditSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchType == .course ? self.courseList.count : self.collegeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.searchType {
        case .course:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
            cell.textLabel?.text = self.courseList[indexPath.row].name
            cell.detailTextLabel?.text = self.courseList[indexPath.row].college
            
            return cell
        case .college:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
            cell.textLabel?.text = self.collegeList[indexPath.row].collegeName
            return cell
        }
    }
}

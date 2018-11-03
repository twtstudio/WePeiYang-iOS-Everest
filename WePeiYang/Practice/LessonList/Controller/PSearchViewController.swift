//
//  CourseListViewController.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

struct QuesBasicInfo {
    var id: Int
    var courseName: String
}

class PSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    var resultArray: [QuesBasicInfo] = []
    let searchBarH: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor.practiceBlue
        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: <#T##CGFloat#>)]
        navigationItem.title = "课程搜索"
    }
    
    private func setupNavBar(){
        self.navigationController?.navigationBar.backgroundColor = .blue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19)]
        navigationItem.title = "课程列表"
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
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
        getResult(keyword: searchText)
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
        
        return cell
    }
}

extension PSearchViewController {
    private func getResult(keyword: String) {
        getSearchResult(courseName: keyword, success: { (array) in
            self.resultArray = array
        }) { (err) in
            log(err)
        }
    }
    
    private func getSearchResult(courseName: String, success: @escaping ([QuesBasicInfo]) -> (), failure: (Error) -> ()) {
        SolaSessionManager.solaSession(baseURL: "https://exam.twtstudio.com", url: "/api/search/\(courseName)", success: { (dic) in
            var array: [QuesBasicInfo] = []
            if let keyValue = dic["data"] as? [[String: Any]] {
                for i in 0..<keyValue.count {
                    let id = keyValue[i]["id"] as? Int ?? 0
                    let courseName = keyValue[i]["course_name"] as? String ?? ""
                    let ques = QuesBasicInfo(id: id, courseName: courseName)
                    array.append(ques)
                }
            }
            success(array)
        }) { (err) in
            log(err)
        }
    }
}

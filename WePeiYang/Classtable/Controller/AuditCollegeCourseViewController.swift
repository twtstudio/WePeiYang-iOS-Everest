//
//  AuditCollegeCourseViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/21.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class AuditCollegeCourseViewController: UIViewController {
    private var tableView: UITableView!
    private var collegeName: String = ""
    private var collegeID: String = ""
    private var courseList: [(Int, String)] = []
    
    convenience init(collegeName: String, collegeID: String) {
        self.init()
        self.collegeName = collegeName
        self.collegeID = collegeID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.collegeName
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        ClasstableDataManager.searchCourse(collegeID: self.collegeID, success: { model in
            self.courseList = model.data.map { ($0.id, $0.name) }
            self.tableView.reloadData()
        }, failure: { errStr in
            log(errStr)
        })
    }
    
}

extension AuditCollegeCourseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailCourseVC = AuditDetailViewController(courseID: String(self.courseList[indexPath.row].0))
        self.navigationController?.pushViewController(detailCourseVC, animated: true)
    }
}

extension AuditCollegeCourseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = self.courseList[indexPath.row].1
        return cell
    }
}

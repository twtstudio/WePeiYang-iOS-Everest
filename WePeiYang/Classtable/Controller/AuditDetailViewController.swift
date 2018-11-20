//
//  AuditDetailViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/21.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class AuditDetailViewController: UIViewController {
    private var tableView: UITableView!
    private var detailCourseList: [AuditDetailCourseItem] = []
    private var dayTitles = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    private var courseID: String = ""
    
    convenience init(courseID: String) {
        self.init()
        self.courseID = courseID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        view.backgroundColor = .white
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        tableView.register(AuditDetailCourseTableViewCell.self, forCellReuseIdentifier: "AuditDetailCourseTableViewCell")
        
        self.view.addSubview(tableView)
        
        ClasstableDataManager.getAuditDetailCourse(courseID: self.courseID, success: { model in
            model.data.info.forEach { item in
                var newItem = item
                newItem.courseCollege = model.data.college
                self.detailCourseList.append(newItem)
            }
            self.tableView.reloadData()
        }, failure: { errStr in
            
        })
        
    }
    
    
}

extension AuditDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
}

extension AuditDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailCourseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuditDetailCourseTableViewCell") as! AuditDetailCourseTableViewCell
        
        let item = self.detailCourseList[indexPath.row]
        
        cell.nameLabel.text = item.courseName
        
        cell.teacherLabel.text = item.teacher + " " + item.teacherType
        
        let startWeek = item.startWeek
        let endWeek = item.endWeek
        cell.weekTimeLabel.text = "第 " + String(startWeek) + "-" + String(endWeek) + " 周"

        let dayTime = self.dayTitles[item.weekDay - 1]
        let startTime = item.startTime
        let endTime = item.startTime + item.courseLength - 1
        cell.dayTimeLabel.text = dayTime + " " + String(startTime) + "-" + String(endTime) + " 节"
        
        cell.locationLabel.text = item.building + "楼" + item.room
        
        cell.collegeLabel.text = item.courseCollege
        
        return cell
    }
}

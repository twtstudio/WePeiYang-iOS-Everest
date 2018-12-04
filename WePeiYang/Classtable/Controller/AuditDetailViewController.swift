//
//  AuditDetailViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/21.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import PopupDialog

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
            log(errStr)
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
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! AuditDetailCourseTableViewCell
        if cell.isConflict == true {
            //let courseName = self.detailCourseList[indexPath.row].courseName
            let popupVC = PopupDialog(title: "亲～课程冲突啦", message: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn)
            let cancelButton = DestructiveButton(title: "知道啦", action: nil)
            popupVC.addButton(cancelButton)
            self.present(popupVC, animated: true)
        } else {
            if cell.flagLabel.text == "[已蹭课]" {
                let popupVC = PopupDialog(title: "亲～课程已经蹭上啦", message: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn)
                let cancelButton = DefaultButton(title: "知道啦", action: nil)
                popupVC.addButton(cancelButton)
                self.present(popupVC, animated: true)
                return
            }
            let courseName = self.detailCourseList[indexPath.row].courseName
            let popupVC = PopupDialog(title: "大佬要蹭课吗？", message: "\(courseName)", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
            let cancelButton = CancelButton(title: "取消", action: nil)
            let auditButton = DefaultButton(title: "蹭课") {
                let item = self.detailCourseList[indexPath.row]
                AuditUser.shared.auditCourse(item: item, success: { _ in
                    SwiftMessages.showSuccessMessage(body: "蹭课成功")
                    
                    self.tableView.reloadData()
                    NotificationCenter.default.post(name: NotificationName.NotificationAuditListWillRefresh.name, object: nil)
                    NotificationCenter.default.post(name: NotificationName.NotificationClassTableWillRefresh.name, object: nil)
                }, failure: { errStr in
                    log(errStr)
                })
            }
            popupVC.addButtons([cancelButton, auditButton])
            self.present(popupVC, animated: true)
        }
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
        
//        if let conflictCourse = AuditUser.shared.checkConflict(item: item) {
//            if conflictCourse == "[已蹭课]" {
//                cell.flagLabel.text = conflictCourse
//                cell.isConflict = false
//            } else {
//                cell.flagLabel.text = "冲突课程：" + conflictCourse
//                cell.isConflict = true
//            }
//        } else {
//            cell.flagLabel.text = "没有冲突"
//            cell.isConflict = false
//        }

        if AuditUser.shared.auditCourseSet.contains(item.id) {
            cell.flagLabel.text = "已蹭课"
            cell.isConflict = false
        } else {
            if AuditUser.shared.checkConflictAgain(item: item) {
                cell.flagLabel.text = "有冲突"
                cell.isConflict = true
            } else {
                cell.flagLabel.text = "没有冲突"
                cell.isConflict = false
            }
        }
        
        cell.nameLabel.text = item.courseName
        cell.teacherLabel.text = item.teacher + " " + item.teacherType
        let startWeek = item.startWeek
        let endWeek = item.endWeek
        var weekType = ""
        
        if item.weekType == 1 {
            weekType = "单周"
        } else if item.weekType == 2 {
            weekType = "双周"
        } else if item.weekType == 3 {
            weekType = "单双周"
        }
        
        cell.weekTimeLabel.text = "第 " + String(startWeek) + "-" + String(endWeek) + " 周  " + weekType
        let dayTime = self.dayTitles[item.weekDay - 1]
        let startTime = item.startTime
        let endTime = item.startTime + item.courseLength - 1
        cell.dayTimeLabel.text = dayTime + " " + String(startTime) + "-" + String(endTime) + " 节"
        cell.locationLabel.text = item.building + "楼" + item.room
        cell.collegeLabel.text = item.courseCollege
        
        return cell
    }
}

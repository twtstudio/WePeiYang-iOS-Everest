//
//  CourseInfoView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/10/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class PCourseInfoTableView: UITableView {
    private var title: String?
//    private var subtitle: String?
//    private var contentArray: [(label: String, btnText: String)] = []
    private var courseInfo: [PCourseInfo] = []
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.bounces = false
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTableView(courseName: String?, courseInfo: [PCourseInfo]) {
        self.title = courseName
        self.courseInfo = courseInfo

        self.reloadData()
    }
    
}

extension PCourseInfoTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = self.courseInfo.count + 2
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            cell.textLabel?.text = title
            return cell
        case 1:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.systemFont(ofSize: 10)
            cell.textLabel?.text = "顺序练习 - 题型选择"
            return cell
        default:
            let cell = PCourseInfoCell()
            let info = courseInfo[indexPath.item - 2]
            let index = Int(info.quesIndex) ?? 3
            var qtype: String = ""
            switch info.quesType {
            case 0:
                qtype = "单选题"
            case 1:
                qtype = "多选题"
            case 2:
                qtype = "判断题"
            default:
                break
            }
            cell.setupUI(typeInt: info.quesType, quesType: qtype, numOfQues: info.quesNum, doneQues: info.doneNum, index: index)
            return cell

        }
    }
}

extension PCourseInfoTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 1 {
            return 20
        } else {
            return 44
        }
    }
}

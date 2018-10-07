//
//  ClassDetailViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/24.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class ClassDetailViewController: UIViewController {
    var tableView: UITableView!
    var courses: [ClassModel] = []
    var headerView: UIView!
    // TODO: 删除
//    var footerView: UIView!

    convenience init(courses: [ClassModel]) {
        self.init()
        self.courses = courses
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "课程详情"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.19, green: 0.69, blue: 0.92, alpha: 1.00)
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(ArrangeCell.self, forCellReuseIdentifier: "ArrangeCell")
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 30
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
        initAccessoryView()
    }

    func initAccessoryView() {
        headerView = UIView()
        headerView.backgroundColor = .white
//        footerView = UIView()

        guard let course = courses.first else {
            SwiftMessages.showErrorMessage(body: "数据解析错误😟，请稍后再试")
            return
        }
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        headerView.addSubview(titleLabel)
        titleLabel.text = course.courseName
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }

        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0

        let teachers = Set<String>(courses.map { $0.teacher })
        var teacherString = ""
        for (idx, teacher) in teachers.enumerated() {
            if idx == 0 {
                teacherString = teacher
            } else {
                teacherString += "，" + teacher
            }
        }

        var detailString = "逻辑班号: " + course.classID
        detailString += "\n课程编号: " + course.courseID
        detailString += "\n课程类型: " + course.courseType
        detailString += "\n课程性质: " + course.courseNature
        detailString += "\n学分: " + course.credit
        detailString += "\n授课教师: " + teacherString
        detailString += "\n开课学院: " + course.college
        detailString += "\n校区: " + course.campus
        if course.ext != "" {
            detailString += "\n备注: " + course.ext
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attributedString = NSAttributedString(string: detailString, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])

        detailLabel.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
        detailLabel.font = UIFont.systemFont(ofSize: 15)
//        detailLabel.text = detailString
        detailLabel.attributedText = attributedString
        headerView.addSubview(detailLabel)
        detailLabel.sizeToFit()
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-20)
        }

//        footerView.snp.makeConstraints { make in
//
//        }
    }
}

extension ClassDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = courses[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArrangeCell") as? ArrangeCell {
            cell.load(model: model, no: indexPath.row+1)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        headerView.setNeedsLayout()
//        headerView.layoutIfNeeded()
        return headerView.systemLayoutSizeFitting(.init(width: CGFloat.infinity, height: CGFloat.infinity)).height
    }
}

extension ClassDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
}

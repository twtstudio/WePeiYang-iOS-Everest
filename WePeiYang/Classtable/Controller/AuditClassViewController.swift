//
//  AuditClassViewController.swift
//  WePeiYang
//
//  Created by Tigris on 4/24/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class AuditClassViewController: UIViewController {
    var tableView: UITableView!
    var auditClassList = [PopularClassModel]()
    var myClassList = [PopularClassModel]()

    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.navigationItem.title = "添加课程"
        let titleTextAttribute = [NSAttributedStringKey.foregroundColor: UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute
        let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchToggle))
        self.navigationItem.rightBarButtonItem = rightButton

        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        load()
        self.view.addSubview(tableView)
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @objc func searchToggle() {
        let collegeSphereVC = CollegeSphereViewController()
        self.navigationController?.pushViewController(collegeSphereVC, animated: true)
    }

    func load() {
        ClasstableDataManager.getPopularClass(success: { list in
            self.auditClassList = list
            self.tableView.reloadData()
        }, failure: { errMsg in
            SwiftMessages.showErrorMessage(body: errMsg)
        })
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
}

extension AuditClassViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
//            if auditClassList.count > 4 {
//                return 4
//            } else {
//                return auditClassList.count
//            }
            // More elegant way to write it
            return min(auditClassList.count + 1, 5)
        case 1:
            return min(myClassList.count + 1, 4 + 1)
        case 2:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: "CourseCell\(indexPath.section)") {
            cell = reusableCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CourseCell\(indexPath.section)")
        }
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case 0:
            if auditClassList.count <= 4 {
                if indexPath.row == auditClassList.count {
                    cell.textLabel?.text = "更多"
                    cell.textLabel?.textColor = UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)
                    cell.accessoryType = .none
                } else {
                    let model = auditClassList[indexPath.row]
                    cell.textLabel?.text = model.course.name
                }
            } else {
                if indexPath.row == 4 {
                    cell.textLabel?.text = "更多"
                    cell.textLabel?.textColor = UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)
                    cell.accessoryType = .none
                } else {
                    let model = auditClassList[indexPath.row]
                    cell.textLabel?.text = model.course.name
                }
            }
        case 1:
            if myClassList.isEmpty {
                cell.textLabel?.text = "暂无"
                cell.textLabel?.textColor = UIColor.gray
                cell.accessoryType = .none
            } else if myClassList.count <= 4 {
                if indexPath.row == myClassList.count {
                    cell.textLabel?.text = "更多"
                    cell.textLabel?.textColor = UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)
                    cell.accessoryType = .none
                } else {
                    cell.textLabel?.text = myClassList[indexPath.row].course.name
                }
            } else {
                if indexPath.row == 4 {
                    cell.textLabel?.text = "更多"
                    cell.textLabel?.textColor = UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)
                    cell.accessoryType = .none
                } else {
                    cell.textLabel?.text = myClassList[indexPath.row].course.name
                }
            }
        case 2:
            cell.textLabel?.text = "添加自定义课程"
//            cell.textLabel?.textColor = UIColor(red:0.14, green:0.69, blue:0.93, alpha:1.00)
            // FIXME: make it blue when we can add custom class to the table
            cell.textLabel?.textColor = UIColor.gray
            cell.accessoryType = .none
        default:
            fatalError()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 4 {
                let allPopularClassesViewController = AllPopularClassesViewController()
                self.navigationController?.pushViewController(allPopularClassesViewController, animated: true)
            }
        default:
            return
        }
    }
}

extension AuditClassViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "热门课程"
        case 1:
            return "我的课程"
        case 2:
            return "其他"
        default:
            return ""
        }
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.navigationItem.title = "添加课程"
        let titleTextAttribute = [NSAttributedStringKey.foregroundColor : UIColor(red:0.14, green:0.69, blue:0.93, alpha:1.00)]
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
            return min(auditClassList.count, 4)
        case 1:
            return min(myClassList.count, 4)
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
            let model = auditClassList[indexPath.row]
            cell.textLabel?.text = model.course.name
        case 1:
            let model = myClassList[indexPath.row]
            cell.textLabel?.text = model.course.name
        case 2:
            cell.textLabel?.text = "添加自定义课程"
//            cell.textLabel?.textColor = UIColor(red:0.14, green:0.69, blue:0.93, alpha:1.00)
            // FIXME: make it blue when we can add custom class to the table
            cell.textLabel?.textColor = UIColor.gray
            cell.accessoryType = .none
        default:
            fatalError()
        }
//        ClasstableDataManager.getPopularClass(success: { dict in
//            cell.accessoryType = .disclosureIndicator
//            for i in 0...4 {
//                cell.textLabel?.text = dict[i].course.name
//            }
//            print(dict)
//
//        }, failure: { errMsg in
//            SwiftMessages.showErrorMessage(body: errMsg)
//        })
        return cell
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

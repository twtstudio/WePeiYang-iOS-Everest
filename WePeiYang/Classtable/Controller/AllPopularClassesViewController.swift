//
//  AllPopularClassesViewController.swift
//  WePeiYang
//
//  Created by Tigris on 5/6/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class AllPopularClassesViewController: UIViewController {
    var tableView: UITableView!
    var auditClassList = [PopularClassModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.title = "热门课程"
        let titleTextAttribute = [NSAttributedStringKey.foregroundColor: UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute

        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.bottom = 64
        self.view.addSubview(tableView)
        load()
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

extension AllPopularClassesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let course = auditClassList[indexPath.row]
        SwiftMessages.showLoading()
        ClasstableDataManager.getCourseInfo(id: course.courseID, success: { model in
            SwiftMessages.hideLoading()
            ClasstableDataManager.addAduitCoursesLocal(courses: model.toClassModel())
        }, failure: { errMsg in
            SwiftMessages.hideLoading()
            SwiftMessages.showErrorMessage(body: errMsg)
        })
    }
}

extension AllPopularClassesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auditClassList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCourseCell") ?? UITableViewCell(style: .default, reuseIdentifier: "AllCourseCell")
        cell.textLabel?.text = auditClassList[indexPath.row].course.name
        return cell
    }
}

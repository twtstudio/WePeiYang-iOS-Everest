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

class LessonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lessonsName = ["党史党章1", "党史党章1", "党史党章1"]
    
    let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: deviceWidth, height: deviceHeight - 64), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavBar()
    }
    
    private func setupNavBar(){
        self.navigationController?.navigationBar.backgroundColor = .blue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19)]
        navigationItem.title = "课程列表"
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "lessonCell"
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = lessonsName[indexPath.item]
        
        return cell
    }
}

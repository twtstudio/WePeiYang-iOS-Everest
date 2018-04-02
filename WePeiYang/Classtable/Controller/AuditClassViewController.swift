//
//  AuditClassViewController.swift
//  WePeiYang
//
//  Created by Tigris on 4/24/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class AuditClassViewController: UIViewController {
    
    var auditClassList = [PopularClassModel]()
    var myClassList = [PopularClassModel]()
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.navigationItem.title = "添加课程"
        
        let titleTextAttribute = [NSAttributedStringKey.foregroundColor : UIColor(red:0.14, green:0.69, blue:0.93, alpha:1.00)]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute
        let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchToggle))
        self.navigationItem.rightBarButtonItem = rightButton
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
        load()
        
        self.view.addSubview(tableView)
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
            return auditClassList.count
        case 1:
            return myClassList.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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

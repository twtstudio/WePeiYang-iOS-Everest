//
//  ClassTableViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

let ClassTableKey = "ClassTableKey"
class ClassTableViewController: UIViewController {
    
    var listView: CourseListView!
    var table: ClassTableModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        initNavBar()
        listView = CourseListView()
//        listView.dataSource = self
        self.view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        loadCache()
        load()
    }
    
    func initNavBar() {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        backView.addSubview(button)
        button.setTitle("第5周", for: .normal)
        button.setTitleColor(.black, for: .normal)
        self.navigationItem.titleView = backView
    }
    
    func loadCache() {
        if let dic = CacheManager.loadGroupCache(withKey: ClassTableKey) as? [String: Any], let table = Mapper<ClassTableModel>().map(JSON: dic) {
//            self.dataProvider.table = table
//            self.title = "第 \(self.dataProvider.weekNumber()) 周"
//            self.listView.reloadData()
            self.listView.load(table: table, week: 5)
        }
    }
    
    func load() {
        ClasstableDataManager.getClassTable(success: { table in
            let dic = table.toJSON()
            CacheManager.saveGroupCache(with: dic, key: ClassTableKey)
            self.table = table
//            self.title = "第 \(self.weekNumber()) 周"
//            self.listView.reloadData()
            self.listView.load(table: table, week: 4)
        }, failure: { errorMessage in
            print(errorMessage)
        })
    }
}

//extension ClassTableViewController: CourseListViewDataSource {
//    func courses(in day: Int) -> [ClassModel] {
//
//    }
//
//    func weekNumber() {
//
//    }
//
//}


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
    var dataProvider = ClassDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        
        listView = CourseListView()
        listView.dataSource = dataProvider
        self.view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        loadCache()
        load()
    }
    
    func loadCache() {
        if let dic = CacheManager.loadGroupCache(withKey: ClassTableKey) as? [String: Any], let table = Mapper<ClassTableModel>().map(JSON: dic) {
            self.dataProvider.table = table
            self.title = "第 \(self.dataProvider.weekNumber()) 周"
            self.listView.reloadData()
        }
    }
    
    func load() {
        ClasstableDataManager.getClassTable(success: { table in
            let dic = table.toJSON()
            CacheManager.saveGroupCache(with: dic, key: ClassTableKey)
            self.dataProvider.table = table
            self.title = "第 \(self.dataProvider.weekNumber()) 周"
            self.listView.reloadData()
//            self.listView.load(table: table)
        }, failure: { errorMessage in
            print(errorMessage)
        })
    }
    
}



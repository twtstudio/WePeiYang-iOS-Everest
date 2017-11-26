//
//  ClassTableViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit


class ClassTableViewController: UIViewController {
    var listView: CourseListView!
    var dataProvider = ClassDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        
        listView = CourseListView(frame: self.view.bounds)
        listView.dataSource = dataProvider
        self.view.addSubview(listView)
        self.load()
    }
    
    func load() {
        ClasstableDataManager.getClassTable(success: { table in
            print(table)
            self.dataProvider.table = table
            self.title = "第 \(self.dataProvider.weekNumber()) 周"
            self.listView.reloadData()
//            self.listView.load(table: table)
        }, failure: { errorMessage in
            print(errorMessage)
        })
    }
    
}



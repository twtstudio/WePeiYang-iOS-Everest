//
//  PublishLostViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class PublishLostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!;
    
    var virtualArray = [
        0: ["添加图片"],
        1: ["标题","时间","地点"],
        2: ["卡号","姓名"],
        3: ["姓名","联系电话"],
        4: ["物品描述"],
        5: ["刊登时长"]
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "捡到物品"
        self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = UIColor(hex6: 0xeeeeee);
        self.tableView.register(PublishCustomCell.self, forCellReuseIdentifier: "PublishLostCell");
        self.tableView.estimatedRowHeight = 500;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.view.addSubview(tableView);

        
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let data = self.virtualArray[section];
        return data!.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublishLostCell", for: indexPath) as!PublishCustomCell;
        cell.textField.placeholder = "请输入" 
        

        cell.textLabel?.text = virtualArray[indexPath.section]?[indexPath.row];
        return cell;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

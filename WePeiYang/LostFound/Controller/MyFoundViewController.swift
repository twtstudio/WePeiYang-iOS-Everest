//
//  FountMIneViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class MyFoundViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var myFound: [MyLostFoundModel] = []
    
//    var myLost1 = MyLoatFoundModel(isBack: "未交还", title: "大大捡到了", mark:"钱包" , time: "2017/5/1", place: "图书馆", picture: "pic2")
//    var myLost2 = MyLoatFoundModel(isBack: "未交还", title: "大大又捡到了", mark:"钱包" , time: "2017/5/1", place: "图书馆", picture: "pic3")
//    var myLost3 = MyLoatFoundModel(isBack: "已交还", title: "大大又捡到了", mark:"钱包" , time: "2017/5/1",place: "图书馆", picture: "pic1")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        myFound = [myLost1, myLost2, myLost3]
        
        self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.view.addSubview(tableView!)
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return myFound.count
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? MyLostFoundTableViewCell{
            
            cell.initMyUI(pic: URL(string: "")!, title: myFound[indexPath.row].title, isBack: myFound[indexPath.row].isBack, mark: myFound[indexPath.row].detail_type, time: myFound[indexPath.row].time, place: myFound[indexPath.row].place)
            return cell
            
            
            
        }
        
        let cell = MyLostFoundTableViewCell()
        cell.initMyUI(pic: URL(string: "")!, title: myFound[indexPath.row].title, isBack: myFound[indexPath.row].isBack, mark: myFound[indexPath.row].detail_type, time: myFound[indexPath.row].time, place: myFound[indexPath.row].place)
        
        
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

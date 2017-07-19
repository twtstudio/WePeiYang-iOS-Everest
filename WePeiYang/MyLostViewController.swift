//
//  LostFountMineViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class MyLostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var tableView: UITableView!
    var myLost: [MyLostFoundModel] = []
    
//    var myLost1 = MyLoatFoundModel(isBack: "未找到", title: "求大大", mark:"钱包" , time: "2017/5/1", place: "图书馆", picture: "pic2")
//    var myLost2 = MyLoatFoundModel(isBack: "未找到", title: "求大大", mark:"钱包" , time: "2017/5/1", place: "图书馆", picture: "pic3")
//    var myLost3 = MyLoatFoundModel(isBack: "已找到", title: "求大大", mark:"钱包" , time: "2017/5/1",place: "图书馆", picture: "pic1")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        myLost.append(myLost1)
//        myLost.append(myLost2)
//        myLost.append(myLost3)
        
        self.title = "我的"
        
        self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(hex6: 0xeeeeee)
        self.tableView.register(MyLostFoundTableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        self.tableView.estimatedRowHeight = 500
        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(tableView!)
        refresh()
        
    }
    
    func refresh() {
    
        GetMyLostAPI.getMyLostAPI(success: { (myLosts) in
            self.myLost = myLosts
            self.tableView.reloadData()
        
        
        }, failure: {error in
            print(error)
        
        })
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailView = DetailViewController()
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return myLost.count
//    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 100
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headView = UIView()
//        headView.backgroundColor = UIColor(hex6: 0xeeeeee)
//        return headView
//        
//    }
//    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return myLost.count
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? MyLostFoundTableViewCell{
            
            cell.initMyUI(pic: myLost[indexPath.row].picture, title: myLost[indexPath.row].title, isBack: myLost[indexPath.row].isBack, mark: myLost[indexPath.row].detail_type, time: myLost[indexPath.row].time, place: myLost[indexPath.row].place)
            return cell
            
            
            
        }

        let cell = MyLostFoundTableViewCell()
        cell.initMyUI(pic: myLost[indexPath.row].picture, title: myLost[indexPath.row].title, isBack: myLost[indexPath.row].isBack, mark: myLost[indexPath.row].detail_type, time: myLost[indexPath.row].time, place: myLost[indexPath.row].place)

        
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

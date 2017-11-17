//
//  FountMIneViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh



class MyFoundViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var myFound: [MyLostFoundModel] = []
    let footer = MJRefreshAutoNormalFooter()
    let header = MJRefreshNormalHeader()
    var curPage: Int = 0
    var id = ""
    
    //    var myLost1 = MyLoatFoundModel(isBack: "未交还", title: "大大捡到了", mark:"钱包" , time: "2017/5/1", place: "图书馆", picture: "pic2")
    //    var myLost2 = MyLoatFoundModel(isBack: "未交还", title: "大大又捡到了", mark:"钱包" , time: "2017/5/1", place: "图书馆", picture: "pic3")
    //    var myLost3 = MyLoatFoundModel(isBack: "已交还", title: "大大又捡到了", mark:"钱包" , time: "2017/5/1",place: "图书馆", picture: "pic1")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        myFound = [myLost1, myLost2, myLost3]
        
        self.tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-110), style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(hex6: 0xeeeeee)

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.view.addSubview(tableView!)
        refresh()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoad))
        self.tableView.mj_footer.isAutomaticallyHidden = true
    }
    
    func refresh() {
        
        
        GetMyFoundAPI.getMyFound(page: curPage, success: { (myFounds) in
            self.myFound = myFounds
            self.tableView.reloadData()
            
            
        }, failure: {error in
            print(error)
            
        })
        
    }
    //底部上拉加载
    func footerLoad() {
        print("上拉加载")
        self.curPage += 1
        GetMyFoundAPI.getMyFound(page: curPage, success: { (myFounds) in
            self.myFound += myFounds
            
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
            
        }, failure: { error in
            print(error)
            
            
        })
        self.tableView.reloadData()
    }
    
    //顶部下拉刷新
    func headerRefresh(){
        print("下拉刷新.")
        
        self.curPage = 1
        GetMyFoundAPI.getMyFound(page: 1, success: { (myFounds) in
            self.myFound = myFounds
            print(self.myFound)
            
            //结束刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            
            
            
        }, failure: { error in
            print(error)
            
        })
        
        
    }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        id = myFound[indexPath.row].id
        
        tableView.deselectRow(at: indexPath, animated: true)
        let detailView = DetailViewController()
        detailView.id = id
        
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }

    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return myFound.count
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? MyLostFoundTableViewCell {
            
            cell.editButton.addTarget(self, action: #selector(editButtonTapped(sender: )), for: .touchUpInside)
            cell.inverseButton.addTarget(self, action: #selector(inverseButtonTapped(sender: )), for: .touchUpInside)
            
            let pic = myFound[indexPath.row].picture
            
            cell.initMyUI(pic: pic, title: myFound[indexPath.row].title, isBack: myFound[indexPath.row].isBack, mark: myFound[indexPath.row].detail_type, time: myFound[indexPath.row].time, place: myFound[indexPath.row].place)
            return cell
            
            
            
        }
        
        let cell = MyLostFoundTableViewCell()
        cell.editButton.addTarget(self, action: #selector(editButtonTapped(sender: )), for: .touchUpInside)
        cell.inverseButton.addTarget(self, action: #selector(inverseButtonTapped(sender: )), for: .touchUpInside)
        let pic = myFound[indexPath.row].picture
        cell.initMyUI(pic: pic, title: myFound[indexPath.row].title, isBack: myFound[indexPath.row].isBack, mark: myFound[indexPath.row].detail_type, time: myFound[indexPath.row].time, place: myFound[indexPath.row].place)
        
        
        
        return cell
    }
    func editButtonTapped(sender: UIButton) {
        
        let cell = sender.superView(of: UITableViewCell.self)!
        let indexPath = tableView.indexPath(for: cell)
        id = myFound[(indexPath?[1])!].id
        print(id)
        
        print("indexPath：\(indexPath!)")
        let vc = PublishLostViewController()
        let index = 1
        vc.index = index
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    func inverseButtonTapped(sender: UIButton) {
        //        let cell = superUITableViewCell(of: inverseButton)!
        
        let cell = sender.superView(of: UITableViewCell.self)!
        let indexPath = tableView.indexPath(for: cell)
        id = myFound[(indexPath?[1])!].id
        print(id)
        
        print("indexPath：\(indexPath!)")
        
        GetInverseAPI.getInverse(id: id, success: { (code) in
            
            print(code)
            self.refresh()
            
        }, failure: { error in
            print(error)
        })
        
    }
    
}



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
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configUI()
        //refresh()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoad))
        self.tableView.mj_header.beginRefreshing()
    }
    
    func configUI() {
        self.tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-110), style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(hex6: 0xeeeeee)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView!)
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
    @objc func footerLoad() {
        print("上拉加载")
        self.curPage += 1
        GetMyFoundAPI.getMyFound(page: curPage, success: { (myFounds) in
            self.myFound += myFounds
            if myFounds.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.curPage -= 1
            } else {
                self.tableView.mj_footer.endRefreshing()
            }
            self.tableView.reloadData()
            
        }, failure: { error in
            print(error)
            self.curPage -= 1
        })
        self.tableView.reloadData()
    }
    
    //顶部下拉刷新
    @objc func headerRefresh(){
        print("下拉刷新.")
        
        GetMyFoundAPI.getMyFound(page: 1, success: { (myFounds) in
            self.myFound = myFounds
            print(self.myFound)
            self.curPage = 1
            //结束刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.resetNoMoreData()
            self.tableView.reloadData()
        }, failure: { error in
            print(error)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id = myFound[indexPath.row].id
        
        tableView.deselectRow(at: indexPath, animated: true)
        let detailView = LFDetailViewController()
        detailView.id = id
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(hex6: 0xeeeeee)
        return view
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
    @objc func editButtonTapped(sender: UIButton) {
        
        let cell = sender.superView(of: UITableViewCell.self)!
        let indexPath = tableView.indexPath(for: cell)
        id = myFound[(indexPath?[1])!].id
        
        let vc = PublishLostViewController()
        let index = 1
        vc.index = index
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func inverseButtonTapped(sender: UIButton) {
        let cell = sender.superView(of: UITableViewCell.self)!
        let indexPath = tableView.indexPath(for: cell)
        id = myFound[(indexPath?[1])!].id
        GetInverseAPI.getInverse(id: "\(id)", success: { (code) in
            self.refresh()
        }, failure: { error in
            print(error)
        })
        
    }
    
}

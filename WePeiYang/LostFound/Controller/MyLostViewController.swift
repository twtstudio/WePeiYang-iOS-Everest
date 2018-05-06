//
//  LostFountMineViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh
enum MyURLState: String {
    case lostURL = "lost"
    case foundURL = "found"
}

let TWT_URL = "http://open.twtstudio.com/"

class MyLostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var id = 0
    var tableView: UITableView!
    var myLost: [MyLostFoundModel] = []
    let footer = MJRefreshAutoNormalFooter()
    let header = MJRefreshNormalHeader()
    var curPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        //refresh()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoad))
        self.tableView.mj_header.beginRefreshing()
    }
    
    func configUI() {
        self.title = "我的"
        self.tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-110), style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(hex6: 0xeeeeee)
        self.tableView.register(MyLostFoundTableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(tableView!)
    }
    
    func refresh() {
        GetMyLostAPI.getMyLost(page: 1, success: { (myLosts) in
            self.myLost = myLosts
            self.tableView.reloadData()
            self.curPage = 1
        }, failure: {error in
            print(error)
        })
    }

    //底部上拉加载
    @objc func footerLoad() {
        self.curPage += 1
        GetMyLostAPI.getMyLost(page: curPage, success: { (MyLosts) in
            self.myLost += MyLosts
            if MyLosts.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.curPage -= 1
            } else {
                self.tableView.mj_footer.endRefreshing()
            }
            self.tableView.reloadData()
        }, failure: { error in
            print(error)
        })
        self.tableView.reloadData()
    }
    
    //顶部下拉刷新
    @objc func headerRefresh(){
        GetMyLostAPI.getMyLost(page: 1, success: { (MyLosts) in
            self.myLost = MyLosts
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
        id = myLost[indexPath.row].id
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return myLost.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? MyLostFoundTableViewCell {
            
            cell.editButton.addTarget(self, action: #selector(editButtonTapped(editButton: )), for: .touchUpInside)
            cell.inverseButton.addTarget(self, action: #selector(inverseButtonTapped(inverseButton: )), for: .touchUpInside)
            let pic = myLost[indexPath.row].picture
            print(pic)
            cell.initMyUI(pic: pic, title: myLost[indexPath.row].title, isBack: myLost[indexPath.row].isBack, mark: myLost[indexPath.row].detail_type, time: myLost[indexPath.row].time, place: myLost[indexPath.row].place)
            
            return cell
        } else {
            let cell = MyLostFoundTableViewCell()
            cell.editButton.addTarget(self, action: #selector(editButtonTapped(editButton: )), for: .touchUpInside)
            cell.inverseButton.addTarget(self, action: #selector(inverseButtonTapped(inverseButton: )), for: .touchUpInside)

            let pic = TWT_URL + myLost[indexPath.row].picture

            cell.initMyUI(pic: pic, title: myLost[indexPath.row].title, isBack: myLost[indexPath.row].isBack, mark: myLost[indexPath.row].detail_type, time: myLost[indexPath.row].time, place: myLost[indexPath.row].place)

            return cell
        }
    }

    // 修改按钮的回调
    @objc func editButtonTapped(editButton: UIButton) {

        let cell = editButton.superView(of: UITableViewCell.self)!
        let indexPath = tableView.indexPath(for: cell)
        id = myLost[(indexPath?[1])!].id
        
        print("indexPath：\(indexPath!)")
        let vc = PublishLostViewController()
        let index = 1
        vc.index = index
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    // 翻转的按钮的回调
    @objc func inverseButtonTapped(inverseButton: UIButton) {
        //        let cell = superUITableViewCell(of: inverseButton)!
        
        let cell = inverseButton.superView(of: UITableViewCell.self)!
        let indexPath = tableView.indexPath(for: cell)
        id = myLost[(indexPath?[1])!].id

        GetInverseAPI.getInverse(id: "\(id)", success: { (code) in
            self.refresh()
        }, failure: { error in
            print(error)
        })
        
    }
    
}

// 返回父视图
// 返回点击（修改or翻转按钮）返回当前点击cell
extension UIView {
    //返回该view所在的父view
    func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
}

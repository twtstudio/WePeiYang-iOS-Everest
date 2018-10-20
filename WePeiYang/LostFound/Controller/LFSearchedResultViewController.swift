//
//  LFSearchedResultViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh

class LFSearchedResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var searchedView: UICollectionView!
    var promptView: UIScrollView!
    let layout = UICollectionViewFlowLayout()
    var searchedList: [LostFoundModel] = []
    let footer = MJRefreshAutoNormalFooter()
    let header = MJRefreshNormalHeader()
    var curPage : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        promptUI()
        
        //refresh()
        self.title = "搜索结果"
        self.navigationController?.navigationBar.isTranslucent = false
        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(LFSearchedResultViewController.backToMain))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        self.searchedView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.searchedView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoad))
        self.searchedView.mj_header.beginRefreshing()
    }
    
    func configUI() {
        
        searchedView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        searchedView.register(LostFoundCollectionViewCell.self, forCellWithReuseIdentifier: "searchedCell")
        
        searchedView.delegate = self
        searchedView.dataSource = self
        
        searchedView.backgroundColor = UIColor(hex6: 0xeeeeee)
        self.automaticallyAdjustsScrollViewInsets = false
        layout.itemSize = CGSize(width: self.view.frame.size.width/2-10, height:  270)
        layout.sectionInset = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        self.view.addSubview(searchedView)
    }
    
    // 为空显示的View,允许刷新
    func promptUI() {
        self.promptView = UIScrollView(frame: UIScreen.main.bounds)
        self.promptView.backgroundColor = UIColor(hex6: 0xeeeeee)
        let image = UIImageView(frame: CGRect(x: 0, y: 100, width:150, height: 150))
        image.center = CGPoint(x: self.view.frame.width/2, y: 170)
        image.image = UIImage(named: "飞")
        self.promptView.addSubview(image)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 100, width:240, height: 50))
        titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 280)
        titleLabel.text = "暂时没有该类物品,去发布吧!"
        titleLabel.textAlignment = .center
        self.promptView.addSubview(titleLabel)
        self.promptView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        
        self.view.addSubview(promptView)
        promptView.isHidden = true
        
        //        self.searchedView.mj_footer.isAutomaticallyHidden = true
    }
    
    func refresh() {
        print(inputText)
        GetSearchAPI.getSearch(inputText: inputText, page: 1, success: { (searchs) in
            
            self.searchedList = searchs
            self.selectView()
            self.searchedView.reloadData()
            self.curPage = 1
        }, failure: { error in
            print(error)
        })
    }
    
    func selectView() {
        if searchedList.count == 0 {
            self.promptView.isHidden = false
            //            self.view.addSubview(self.promptView)
        } else {
            self.promptView.isHidden = true
            //            print(searchedList.count)
            //            self.view.addSubview(self.searchedView)
            //            self.searchedView.reloadData()
        }
    }
    
    //底部上拉加载
    @objc func footerLoad() {
        print("上拉加载")
        self.curPage += 1
        GetSearchAPI.getSearch(inputText: inputText, page: curPage, success: { (searchs) in
            self.searchedList += searchs
            if searchs.count == 0 {
                self.searchedView.mj_footer.endRefreshingWithNoMoreData()
                self.curPage -= 1
            } else {
                self.searchedView.mj_footer.endRefreshing()
            }
            self.searchedView.reloadData()
        }, failure: { error in
            print(error)
            self.curPage -= 1
        })
        self.searchedView.reloadData()
    }
    
    //顶部下拉刷新
    @objc func headerRefresh(){
        print("下拉刷新.")
        print(inputText)
        
        GetSearchAPI.getSearch(inputText: inputText, page: 1, success: { (searchs) in
            self.searchedList = searchs
            print(self.searchedList)
            self.selectView()
            //结束刷新
            self.searchedView.mj_header.endRefreshing()
            self.promptView.mj_header.endRefreshing()
            self.curPage = 1
            self.searchedView.mj_footer.resetNoMoreData()
            self.searchedView.reloadData()
            
        }, failure: { error in
            print(error)
        })
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //某个Cell被选择的事件处理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let id = searchedList[indexPath.row].id
        let detailVC = LFDetailViewController()
        detailVC.id = id
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchedCell", for: indexPath) as? LostFoundCollectionViewCell{
            //        cell.title.text = "这里是内容：\(indexPath.row)"
            
            let picURL = searchedList[indexPath.row].picture
            cell.initUI(pic: picURL, title: searchedList[indexPath.row].title, mark: Int(searchedList[indexPath.row].detail_type)!, time: searchedList[indexPath.row].time, place: searchedList[indexPath.row].place)
            
            return cell
            
        }
        
        let cell = LostFoundCollectionViewCell()
        
        let picURL = searchedList[indexPath.row].picture
        cell.initUI(pic: picURL, title: searchedList[indexPath.row].title, mark: Int(searchedList[indexPath.row].detail_type)!, time: searchedList[indexPath.row].time, place: searchedList[indexPath.row].place)
        
        return cell
    }
    
    
    @objc func backToMain() {
        let mainVC = self.navigationController?.viewControllers[1]
        self.navigationController?.popToViewController(mainVC!, animated: true)
    }
}

//
//  LFSearchedResultViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh

class LFSearchedResultViewController: UIViewController {
    
    var searchedView: UICollectionView!
    var promptView: UIScrollView!
    let layout = UICollectionViewFlowLayout()
    var searchedList: [LostData] = []
    let footer = MJRefreshAutoNormalFooter()
    let header = MJRefreshNormalHeader()
    var curPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        promptUI()
        
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
        layout.itemSize = CGSize(width: self.view.frame.size.width / 2 - 10, height: 270)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.view.addSubview(searchedView)
    }
    
    // 为空显示的View,允许刷新
    func promptUI() {
        self.promptView = UIScrollView(frame: UIScreen.main.bounds)
        self.promptView.backgroundColor = UIColor(hex6: 0xeeeeee)
        let image = UIImageView(frame: CGRect(x: 0, y: 100, width: 150, height: 150))
        image.center = CGPoint(x: self.view.frame.width/2, y: 170)
        image.image = UIImage(named: "LFFly")
        self.promptView.addSubview(image)

        self.promptView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        
        self.view.addSubview(promptView)
        promptView.isHidden = true
        
    }
    
    func refresh() {
//        GetSearchAPI.getSearch(inputText: inputText, page: 1, success: { searchs in
//            if searchs.isEmpty {
//                SwiftMessages.showWarningMessage(body: "暂时没有该类物品")
//                return
//            }
//            self.searchedList = searchs
//            self.selectView()
//            self.searchedView.reloadData()
//            self.curPage = 1
//        }) { _ in
//        }
        LostFoundHelper.getSearch(keyword: inputText, success: { search in
            if search.data.isEmpty {
                SwiftMessages.showWarningMessage(body: "暂时没有该类物品")
                return
            }
            self.searchedList = search.data
            self.selectView()
            self.searchedView.reloadData()
            self.curPage = 1
        }, failure: { _ in
        })
    }
    
    func selectView() {
        self.promptView.isHidden = !searchedList.isEmpty
    }
    
    // 底部上拉加载
    @objc func footerLoad() {
        self.curPage += 1
//        GetSearchAPI.getSearch(inputText: inputText, page: curPage, success: { searchs in
//            self.searchedList += searchs
//            if searchs.isEmpty {
//                self.searchedView.mj_footer.endRefreshingWithNoMoreData()
//                self.curPage -= 1
//            } else {
//                self.searchedView.mj_footer.endRefreshing()
//            }
//            self.searchedView.reloadData()
//        }, failure: { _ in
//            self.curPage -= 1
//        })
        LostFoundHelper.getSearch(keyword: inputText, page: curPage, success: { search in
            self.searchedList += search.data
            if search.data.isEmpty {
                self.searchedView.mj_footer.endRefreshingWithNoMoreData()
                self.curPage -= 1
            } else {
                self.searchedView.mj_footer.endRefreshing()
            }
            self.searchedView.reloadData()
        }, failure: { _ in
            self.curPage -= 1
        })
        self.searchedView.reloadData()
    }
    
    // 顶部下拉刷新
    @objc func headerRefresh() {
//        GetSearchAPI.getSearch(inputText: inputText, page: 1, success: { searchs in
//            self.searchedList = searchs
//            self.selectView()
//            // 结束刷新
//            self.searchedView.mj_header.endRefreshing()
//            self.promptView.mj_header.endRefreshing()
//            self.curPage = 1
//            self.searchedView.mj_footer.resetNoMoreData()
//            self.searchedView.reloadData()
//        }) { _ in
//        }
        LostFoundHelper.getSearch(keyword: inputText, page: 1, success: { search in
            self.searchedList = search.data
            self.selectView()
            // 结束刷新
            self.searchedView.mj_header.endRefreshing()
            self.promptView.mj_header.endRefreshing()
            self.curPage = 1
            self.searchedView.mj_footer.resetNoMoreData()
            self.searchedView.reloadData()
        }, failure: { _ in
        })
    }
    
    @objc func backToMain() {
        let mainVC = self.navigationController?.viewControllers[1]
        self.navigationController?.popToViewController(mainVC!, animated: true)
    }
    
}

extension LFSearchedResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchedCell", for: indexPath) as? LostFoundCollectionViewCell {
            let picURL = searchedList[indexPath.row].picture
            cell.initUI(pic: picURL?[0] ?? "", title: searchedList[indexPath.row].title, mark: searchedList[indexPath.row].detailType, time: searchedList[indexPath.row].time, place: searchedList[indexPath.row].place)
            return cell
            
        }
        
        let cell = LostFoundCollectionViewCell()
        
        let picURL = searchedList[indexPath.row].picture
        cell.initUI(pic: picURL?[0] ?? "", title: searchedList[indexPath.row].title, mark: searchedList[indexPath.row].detailType, time: searchedList[indexPath.row].time, place: searchedList[indexPath.row].place)
        
        return cell
    }
    
}

extension LFSearchedResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = searchedList[indexPath.row].id
        let detailVC = LFDetailViewController()
        detailVC.id = id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

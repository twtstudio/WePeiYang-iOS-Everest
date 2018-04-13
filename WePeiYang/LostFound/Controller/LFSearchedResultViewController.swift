//
//  searchededResultViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/9/11.
//  Copyright © 2017年 twtstudio. All rights reserved.
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
        refresh()

        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(LFSearchedResultViewController.backToMain))
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }

    func configUI() {
        //        layout.estimatedItemSize = CGSize(width: self.view.frame.size.width/2-10, height: 270)
        //        layout.itemSize =
        layout.itemSize = CGSize(width: self.view.frame.size.width/2-10, height:  270)
        //        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        searchedView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        
        searchedView.register(LostFoundCollectionViewCell.self, forCellWithReuseIdentifier: "searchedCell")
        
        searchedView.delegate = self
        searchedView.dataSource = self
        
        searchedView.backgroundColor = UIColor(hex6: 0xeeeeee)
        
        self.view.addSubview(searchedView)

    }
    
    // 为空显示的View,允许刷新
    func promptUI() {
        self.promptView = UIScrollView(frame: UIScreen.main.bounds)
        self.promptView.backgroundColor = UIColor(hex6: 0xeeeeee)
        let image = UIImageView(frame: CGRect(x: 0, y: 150, width:150, height: 150))
        image.center = CGPoint(x: self.view.frame.width/2, y: 280)
        image.image = UIImage(named: "箱子")
        self.promptView.addSubview(image)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 150, width:200, height: 50))
        titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 400)
        titleLabel.text = "暂时没有找到该类物品!"
        titleLabel.textAlignment = .center
        self.promptView.addSubview(titleLabel)
        self.promptView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.searchedView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.searchedView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoad))
//        self.searchedView.mj_footer.isAutomaticallyHidden = true
    }
    
    func refresh() {
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
            self.view.addSubview(self.promptView)
        } else {
            print(searchedList.count)
            self.view.addSubview(self.searchedView)
            self.searchedView.reloadData()
        }
    }

    //底部上拉加载
    @objc func footerLoad() {
        print("上拉加载")
        self.curPage += 1
        GetSearchAPI.getSearch(inputText: inputText, page: curPage, success: { (searchs) in
            self.searchedList += searchs
            self.searchedView.mj_footer.endRefreshing()
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
        
        GetSearchAPI.getSearch(inputText: inputText, page: 1, success: { (searchs) in
            self.searchedList = searchs
            print(self.searchedList)
            self.selectView()
            self.curPage = 1
            //结束刷新
            self.searchedView.mj_header.endRefreshing()
            self.promptView.mj_header.endRefreshing()
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

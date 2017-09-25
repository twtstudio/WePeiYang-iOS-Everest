//
//  searchededResultViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/9/11.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh

class SearchedResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var searchedView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    var searchedList: [LostFoundModel] = []
    let footer = MJRefreshAutoNormalFooter()
    let header = MJRefreshNormalHeader()
    var curPage : Int = 1
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        refresh()
        self.searchedView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.searchedView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoad))
        self.searchedView.mj_footer.isAutomaticallyHidden = true
        
        
        
    }
    
    func refresh() {
        GetSearchAPI.getSearch(inputText: inputText ,page: curPage, success: { (searchs) in
            self.searchedList = searchs
            self.searchedView.reloadData()
            
        }, failure: { error in
            print(error)
            
        })
    }
    
    //底部上拉加载
    func footerLoad() {
        print("上拉加载")
        self.curPage += 1
        GetSearchAPI.getSearch(inputText: inputText, page: curPage, success: { (searchs) in
            self.searchedList += searchs
            
            self.searchedView.mj_footer.endRefreshing()
            self.searchedView.reloadData()
            
        }, failure: { error in
            print(error)
            
            
        })
        self.searchedView.reloadData()
    }
    
    //顶部下拉刷新
    func headerRefresh(){
        print("下拉刷新.")
        
        self.curPage = 1
        GetSearchAPI.getSearch(inputText: inputText, page: 1, success: { (searchs) in
            self.searchedList = searchs
            print(self.searchedList)
            
            //结束刷新
            self.searchedView.mj_header.endRefreshing()
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
        let detailVC = DetailViewController()
        detailVC.id = id
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return searchedList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchedCell", for: indexPath) as? LostFoundCollectionViewCell{
            //        cell.title.text = "这里是内容：\(indexPath.row)"
            
            if searchedList[indexPath.row].picture != ""{
                let picURL = searchedList[indexPath.row].picture
                cell.initUI(pic: URL(string: TWT_URL + picURL)!, title: searchedList[indexPath.row].title, mark: searchedList[indexPath.row].detail_type, time: searchedList[indexPath.row].time, place: searchedList[indexPath.row].place)
            } else {
                let picURL = "http://open.twtstudio.com/uploads/17-07-12/945139dcd91e9ed3d5967ef7f81e18f6.jpg"
                cell.initUI(pic: URL(string: picURL)!, title: searchedList[indexPath.row].title, mark: searchedList[indexPath.row].detail_type, time: searchedList[indexPath.row].time, place: searchedList[indexPath.row].place)
                
            }
            return cell
            
        }
        let cell = LostFoundCollectionViewCell()
        if searchedList[indexPath.row].picture != ""{
            let picURL = searchedList[indexPath.row].picture
            cell.initUI(pic: URL(string: TWT_URL + picURL)!, title: searchedList[indexPath.row].title, mark: searchedList[indexPath.row].detail_type, time: searchedList[indexPath.row].time, place: searchedList[indexPath.row].place)
        } else {
            let picURL = "http://open.twtstudio.com/uploads/17-07-12/945139dcd91e9ed3d5967ef7f81e18f6.jpg"
            cell.initUI(pic: URL(string: picURL)!, title: searchedList[indexPath.row].title, mark: searchedList[indexPath.row].detail_type, time: searchedList[indexPath.row].time, place: searchedList[indexPath.row].place)
            
        }
        
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}

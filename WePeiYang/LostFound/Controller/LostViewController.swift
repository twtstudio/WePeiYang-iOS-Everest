//
//  LostViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/2.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

var lostList: [LostFoundModel] = []
class LostViewController: UIViewController, UIPageViewControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var lostView: UICollectionView!
    var promptView: UIScrollView!
    let layout = UICollectionViewFlowLayout()
    let footer = MJRefreshAutoNormalFooter()
    let header = MJRefreshNormalHeader()
    var curPage: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        promptUI()
        //refresh()

        self.lostView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.lostView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoad))

        self.lostView.mj_header.beginRefreshing()
    }
    
    func configUI() {
        lostView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height-110), collectionViewLayout: layout)
        lostView.register(LostFoundCollectionViewCell.self, forCellWithReuseIdentifier: "lostCell")
        lostView.delegate = self
        lostView.dataSource = self
        lostView.backgroundColor = UIColor(hex6: 0xeeeeee)
        self.automaticallyAdjustsScrollViewInsets = false
        layout.itemSize = CGSize(width: self.view.frame.size.width/2-10, height:  270)
        layout.sectionInset = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        self.view.addSubview(lostView)
    }
    
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
    }
    // 网络的异步请求
    func refresh() {
        GetLostAPI.getLost(page: 1, success: { (losts) in
            lostList = losts
            self.selectView()
            self.lostView.backgroundColor = UIColor(hex6: 0xeeeeee)
            self.curPage = 1
            self.lostView.mj_footer.resetNoMoreData()
            //            self.lostView.reloadData()
        }, failure: { error in
            print(error)
        })
    }

    func selectView() {
        if lostList.count == 0 {
            self.promptView.isHidden = false
//            self.view.addSubview(self.promptView)
        } else {
            self.promptView.isHidden = true
//            self.view.addSubview(self.lostView)
//            self.lostView.reloadData()
        }
    }
    
    func tapped(){
        let vc = PublishLostViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //底部上拉加载
    @objc func footerLoad() {
        self.curPage += 1
        GetLostAPI.getLost(page: curPage, success: { (losts) in
            lostList += losts
            if losts.count == 0 {
                self.lostView.mj_footer.endRefreshingWithNoMoreData()
                self.curPage -= 1
            } else {
                self.lostView.mj_footer.endRefreshing()
            }
            self.lostView.reloadData()
        }, failure: { error in
            print(error)
            self.curPage -= 1
        })
    }
    
    //顶部下拉刷新
    @objc func headerRefresh(){
        GetLostAPI.getLost(page: 1, success: { (losts) in
            lostList = losts

            self.selectView()
            //结束刷新
            self.lostView.mj_header.endRefreshing()
            self.promptView.mj_header.endRefreshing()
            self.curPage = 1
            self.lostView.mj_footer.resetNoMoreData()
            self.lostView.reloadData()
        }, failure: { error in
            print(error)
        })
    }

    //某个Cell被选择的事件处理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = lostList[indexPath.row].id
        let detailVC = LFDetailViewController()
        detailVC.id = id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return lostList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lostCell", for: indexPath) as? LostFoundCollectionViewCell{
            let picURL = lostList[indexPath.row].picture
            cell.initUI(pic: picURL, title: lostList[indexPath.row].title ,mark: Int(lostList[indexPath.row].detail_type)!, time: lostList[indexPath.row].time, place: lostList[indexPath.row].place)

            return cell
        }
        let cell = LostFoundCollectionViewCell(frame: .zero)

        let picURL = lostList[indexPath.row].picture
        cell.initUI(pic: picURL, title: lostList[indexPath.row].title ,mark: Int(lostList[indexPath.row].detail_type)!, time: lostList[indexPath.row].time, place: lostList[indexPath.row].place)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

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
import SnapKit

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
        refresh()

//        header.setRefreshingTarget(self, refreshingAction: #selector(LostViewController.headerRefresh))
//        
//        footer.setRefreshingTarget(self, refreshingAction: #selector(LostViewController.footerLoad))
//        footer.isAutomaticallyHidden = true
        self.lostView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.lostView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoad))
        self.lostView.mj_footer.isAutomaticallyHidden = true
        
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
    }
    // 网络的异步请求
    func refresh() {

        GetLostAPI.getLost(page: curPage, success: { (losts) in
            lostList = losts
            self.selectView()
            self.lostView.backgroundColor = UIColor(hex6: 0xeeeeee)
//            self.lostView.reloadData()
        }
            
            
            , failure: { error in
                print(error)
            } )
    }
    func selectView() {
        if lostList.count == 0 {
        self.view.addSubview(self.promptView)
        } else {
            print(lostList.count)
            self.view.addSubview(self.lostView)
            self.lostView.reloadData()
        }
        
    }
    
    func tapped(){
        let vc = PublishLostViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //底部上拉加载
    func footerLoad() {
        print("上拉加载")
        self.curPage += 1
        GetLostAPI.getLost(page: curPage, success: { (losts) in
            lostList += losts

            self.lostView.mj_footer.endRefreshing()
            self.lostView.reloadData()
        
        }, failure: { error in
            print(error)
        
        
        })
            self.lostView.reloadData()
    }
    
    //顶部下拉刷新
    func headerRefresh(){
        print("下拉刷新.")
        
        self.curPage = 1
        GetLostAPI.getLost(page: 1, success: { (losts) in
            lostList = losts
            self.selectView()
            //结束刷新
            self.lostView.mj_header.endRefreshing()
            self.promptView.mj_header.endRefreshing()
            self.lostView.reloadData()
            
            
        
        }, failure: { error in
            print(error)
        
        })



    }
    
    
    
    
    //某个Cell被选择的事件处理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(lostList[indexPath.row].id)
        let id = lostList[indexPath.row].id
        let detailVC = LFDetailViewController()
//        detailVC.id = 197
        detailVC.id = id
        print(id)
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return lostList.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let image = UIImage(named: lostList[indexPath.row].picture)
//        let imageHeight = image?.size.height
//        let imageWidth = image?.size.width
//        let width: CGFloat = self.view.frame.size.width/2 - 10
//        let ratio = imageWidth!/width
//        let height = imageHeight!/ratio
//        return CGSize(width: width, height: height + 4*30)
//        
//    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        
        
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lostCell", for: indexPath) as? LostFoundCollectionViewCell{
        
//        var a: String? = "a"
//        if let a = a {
//        
//        }
        let picURL = lostList[indexPath.row].picture
        

            cell.initUI(pic: picURL, title: lostList[indexPath.row].title ,mark: Int(lostList[indexPath.row].detail_type)!, time: lostList[indexPath.row].time, place: lostList[indexPath.row].place)
        
            return cell

        }
//        cell.title.text = "这里是内容：\(indexPath.row)"
        let cell = LostFoundCollectionViewCell()

            
            let picURL = lostList[indexPath.row].picture
            cell.initUI(pic: picURL, title: lostList[indexPath.row].title ,mark: Int(lostList[indexPath.row].detail_type)!, time: lostList[indexPath.row].time, place: lostList[indexPath.row].place)
       

        
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

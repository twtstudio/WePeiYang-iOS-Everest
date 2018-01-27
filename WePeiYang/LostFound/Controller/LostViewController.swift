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

class LostViewController: UIViewController, UIPageViewControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    var lostView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    var lostList: [LostFoundModel] = []
    let footer = MJRefreshAutoNormalFooter()
    let header = MJRefreshNormalHeader()
    var curPage: Int = 1

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lostView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height-110), collectionViewLayout: layout)
        
        lostView.register(LostFoundCollectionViewCell.self, forCellWithReuseIdentifier: "lostCell")
        
        lostView.delegate = self
        lostView.dataSource = self
        
        lostView.backgroundColor = UIColor(hex6: 0xeeeeee)
        self.automaticallyAdjustsScrollViewInsets = false
        
        layout.itemSize = CGSize(width: self.view.frame.size.width/2-10, height:  270)
        

        layout.sectionInset = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        self.view.addSubview(lostView)
        
//        let fab = FAB(subActions: [
//            (name: "fuck", function: {
//                
//                let vc = PublishLostViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
//            }),
//            (name: "fs", function: {
//                
//                let vc = PublishLostViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
//                
//            })
//        ])
//        
//        fab.frame = CGRect(x: 300, y: 400, width: 56, height: 56)
        
        
        let button = UIButton(type: .contactAdd)
        button.frame = CGRect(x: 250, y: 400, width: 100, height: 50)

        self.view.addSubview(button)
        
        button.setTitle("丢失信息", for: UIControlState.normal)
        button.setTitle("触摸状态", for: UIControlState.highlighted)
//        button.setTitle("禁用状态", for: .disabled)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        refresh()
//        header.setRefreshingTarget(self, refreshingAction: #selector(LostViewController.headerRefresh))
//        
//        footer.setRefreshingTarget(self, refreshingAction: #selector(LostViewController.footerLoad))
//        footer.isAutomaticallyHidden = true
        self.lostView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.lostView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoad))
//        self.lostView.mj_footer.isAutomaticallyHidden = true

        }
    
    
    func refresh() {

        GetLostAPI.getLost(page: curPage, success: { (losts) in
            self.lostList = losts
            self.lostView.reloadData()
        }
            
            
            , failure: { error in
                print(error)
            } )
    }
    

    func tapped(){
        let vc = PublishLostViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    
    }
    
    //底部上拉加载
    func footerLoad() {
        print("上拉加载")
        self.curPage += 1
        GetLostAPI.getLost(page: curPage, success: { (losts) in
            self.lostList += losts

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
            self.lostList = losts
            print(self.lostList)

            //结束刷新
            self.lostView.mj_header.endRefreshing()
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
        let detailVC = DetailViewController()
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

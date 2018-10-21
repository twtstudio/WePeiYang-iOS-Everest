//
//  FoundViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh

var foundList: [LostFoundModel] = []

class FoundViewController: UIViewController {
    
    var foundView: UICollectionView!
    var promptView: UIScrollView!
    let layout = UICollectionViewFlowLayout()
    var curPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        promptUI()
        
        foundView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        foundView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoad))
        foundView.mj_header.beginRefreshing()
    }
    
    func configUI() {
        layout.itemSize = CGSize(width: self.view.frame.size.width / 2 - 10, height: 270)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        foundView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.bounds.height - 110), collectionViewLayout: layout)
        foundView.register(LostFoundCollectionViewCell.self, forCellWithReuseIdentifier: "foundCell")
        foundView.delegate = self
        foundView.dataSource = self
        foundView.backgroundColor = UIColor(hex6: 0xeeeeee)
        view.addSubview(foundView)
    }
    
    func promptUI() {
        promptView = UIScrollView(frame: UIScreen.main.bounds)
        promptView.backgroundColor = UIColor(hex6: 0xeeeeee)
        
        let image = UIImageView(frame: CGRect(x: 0, y: 100, width: 150, height: 150))
        image.center = CGPoint(x: self.view.frame.width/2, y: 170)
        image.image = #imageLiteral(resourceName: "LFFly")
        promptView.addSubview(image)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 240, height: 50))
        titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 280)
        titleLabel.text = "暂时没有该类物品,去发布吧!"
        titleLabel.textAlignment = .center
        promptView.addSubview(titleLabel)
        
        promptView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        view.addSubview(promptView)
        promptView.isHidden = true
    }
    
    func refresh() {
        GetFoundAPI.getFound(page: curPage, success: { founds in
            foundList = founds
            self.selectView()
            self.foundView.reloadData()
        }) { _ in
        }
    }
    
    // 底部上拉加载
    @objc func footerLoad() {
        self.curPage += 1
        GetFoundAPI.getFound(page: curPage, success: { losts in
            foundList += losts
            self.foundView.reloadData()
            if losts.isEmpty {
                self.curPage -= 1
                self.foundView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.foundView.mj_footer.endRefreshing()
            }
        }) { _ in
        }
        self.foundView.reloadData()
    }
    
    // 顶部下拉刷新
    @objc func headerRefresh() {
        GetFoundAPI.getFound(page: 1, success: { losts in
            foundList = losts
            self.selectView()
            self.foundView.mj_footer.resetNoMoreData()
            // 结束刷新
            self.foundView.mj_header.endRefreshing()
            self.promptView.mj_header.endRefreshing()
            self.foundView.reloadData()
            self.curPage = 1
        }) { _ in
        }
    }
    
    func selectView() {
        self.promptView.isHidden = !foundList.isEmpty
    }
    
}

extension FoundViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foundList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foundCell", for: indexPath) as? LostFoundCollectionViewCell {
            let picURL = foundList[indexPath.row].picture
            cell.initUI(pic: picURL, title: foundList[indexPath.row].title, mark: Int(foundList[indexPath.row].detail_type)!, time: foundList[indexPath.row].time, place: foundList[indexPath.row].place)
            return cell
            
        }
        let cell = LostFoundCollectionViewCell(frame: .zero)
        let picURL = foundList[indexPath.row].picture
        cell.initUI(pic: picURL, title: foundList[indexPath.row].title, mark: Int(foundList[indexPath.row].detail_type)!, time: foundList[indexPath.row].time, place: foundList[indexPath.row].place)
        return cell
    }
    
}

extension FoundViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = foundList[indexPath.row].id
        let detailVC = LFDetailViewController()
        detailVC.id = id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

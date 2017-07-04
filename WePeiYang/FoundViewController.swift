//
//  FoundViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/2.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit


class FoundViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var foundView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    var foundList: [LostFoundModel] = []
    
    var found1 = LostFoundModel(title: "我捡东西了", mark: "水杯", time: "2017/5/1", picture: "pic1", place:"图书馆二楼")
    var found2 = LostFoundModel(title: "我又捡到东西了", mark: "lala", time:"2017/5/1" , picture: "pic2", place:"图书馆一楼")
    var found3 = LostFoundModel(title: "我又又捡到东西了", mark: "天使", time:"2017/5/1" , picture: "pic2", place:"图书馆一楼")
    var found4 = LostFoundModel(title: "我又又又丢东西了", mark: "恶魔", time:"2017/5/1" , picture: "pic3", place:"图书馆三楼")
    var found5 = LostFoundModel(title: "我又又又又捡到丢东西了", mark: "恶魔", time:"2017/5/1" , picture: "pic3", place:"图书馆三楼")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foundList.append(found2)
        foundList.append(found4)
        foundList.append(found3)
        foundList.append(found1)
        foundList.append(found5)
        
        
        foundView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        
        foundView.register(LostFoundCollectionViewCell.self, forCellWithReuseIdentifier: "foundCell")
        
        foundView.delegate = self
        foundView.dataSource = self
        
        foundView.backgroundColor = UIColor(hex6: 0xeeeeee)
        
//        layout.estimatedItemSize = CGSize(width: self.view.frame.size.width/2-20, height: 150)
//        layout.itemSize =
//        layout.itemSize = CGSize(width: self.view.frame.size.width/2-30, height: 150)
        //        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        self.view.addSubview(foundView)
        
        
        
    }
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return 2
    //    }
//    func numberOfItemsInSection(section: Int) -> Int{
//        
//        return 2
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let image = UIImage(named: foundList[indexPath.row].picture)
        let imageHeight = image?.size.height
        let imageWidth = image?.size.width
        let width = self.view.frame.size.width/2 - 10
        let ratio = imageWidth!/width
        let height = imageHeight!/ratio
        return CGSize(width: width, height: height + 4*30)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return foundList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foundCell", for: indexPath) as? LostFoundCollectionViewCell{
//        cell.title.text = "这里是内容：\(indexPath.row)"
            cell.initUI(pic: foundList[indexPath.row].picture, title: foundList[indexPath.row].title, mark: foundList[indexPath.row].mark, time: foundList[indexPath.row].time, place: foundList[indexPath.row].place)
            return cell
        
        }
        let cell = LostFoundCollectionViewCell()
        cell.initUI(pic: foundList[indexPath.row].picture, title: foundList[indexPath.row].title, mark: foundList[indexPath.row].mark, time: foundList[indexPath.row].time, place: foundList[indexPath.row].place)
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

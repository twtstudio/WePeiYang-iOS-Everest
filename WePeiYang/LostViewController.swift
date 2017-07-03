//
//  LostViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/2.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LostViewController: UIViewController, UIPageViewControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {


    var foundView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    var lostList: [LostFoundModel] = []
    
    var lost1 = LostFoundModel(title: "我丢东西了", name: "水杯", time: "2017/5/1", picture: "pic1", place:"图书馆二楼")
    var lost2 = LostFoundModel(title: "我又丢东西了", name: "lala", time:"2017/5/1" , picture: "pic2", place:"图书馆一楼")
    var lost3 = LostFoundModel(title: "我又又丢东西了", name: "天使", time:"2017/5/1" , picture: "pic2", place:"图书馆一楼")
    var lost4 = LostFoundModel(title: "我又又又丢东西了", name: "恶魔", time:"2017/5/1" , picture: "pic3", place:"图书馆三楼")
    var lost5 = LostFoundModel(title: "我又又又又丢东西了", name: "恶魔", time:"2017/5/1" , picture: "pic3", place:"图书馆三楼")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lostList.append(lost1)
        lostList.append(lost2)
        lostList.append(lost3)
        lostList.append(lost4)
        lostList.append(lost5)
        


        foundView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        
        foundView.register(LostFoundCollectionViewCell.self, forCellWithReuseIdentifier: "lostCell")
        
        foundView.delegate = self
        foundView.dataSource = self
        
        foundView.backgroundColor = UIColor(hex6: 0xeeeeee)
        
//        layout.itemSize = CGSize(width: self.view.frame.size.width/2-10, height:  )
        

        //        layout.minimumInteritemSpacing = 20
//        layout.headerReferenceSize = CGSize(width: 100, height: 50)         //页眉尺寸
        layout.sectionInset = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        self.view.addSubview(foundView)
        
        
        
    }
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return 2
    //    }
    func numberOfItemsInSection(section: Int) -> Int{
        
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return lostList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = UIImage(named: lostList[indexPath.row].picture)
        let imageHeight = image?.size.height
        let imageWidth = image?.size.width
        let width: CGFloat = self.view.frame.size.width/2 - 10
        let ratio = imageWidth!/width
        let height = imageHeight!/ratio
        return CGSize(width: width, height: height + 3*30)
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lostCell", for: indexPath) as? LostFoundCollectionViewCell{
        
        cell.initUI(pic: lostList[indexPath.row].picture, title: lostList[indexPath.row].title ,name: lostList[indexPath.row].name, time: lostList[indexPath.row].time, place: lostList[indexPath.row].place)
            return cell
        }
//        cell.title.text = "这里是内容：\(indexPath.row)"
        let cell = LostFoundCollectionViewCell()
        cell.initUI(pic: lostList[indexPath.row].picture, title: lostList[indexPath.row].title ,name: lostList[indexPath.row].name, time: lostList[indexPath.row].time, place: lostList[indexPath.row].place)
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

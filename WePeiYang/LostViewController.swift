//
//  LostViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/2.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LostViewController: UIViewController, UIPageViewControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    var lostView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    var lostList: [LostFoundModel] = []
    

    
    var lost1 = LostFoundModel(title: "我丢东西了", detail_type: 3, time: "2017/5/1", picture: "pic1", place:"图书馆二楼")
    var lost2 = LostFoundModel(title: "我又丢东西了", detail_type: 2, time:"2017/5/1" , picture: "pic2", place:"图书馆一楼")
    var lost3 = LostFoundModel(title: "我又又丢东西了", detail_type: 1, time:"2017/5/1" , picture: "pic2", place:"图书馆一楼")
    var lost4 = LostFoundModel(title: "我又又又丢东西了", detail_type: 3, time:"2017/5/1" , picture: "pic3", place:"图书馆三楼")
    var lost5 = LostFoundModel(title: "我又又又又丢东西了", detail_type: 4, time:"2017/5/1" , picture: "pic3", place:"图书馆三楼")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lostList = [lost1, lost2, lost3, lost4, lost5]        



        
        lostView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        
        lostView.register(LostFoundCollectionViewCell.self, forCellWithReuseIdentifier: "lostCell")
        
        lostView.delegate = self
        lostView.dataSource = self
        
        lostView.backgroundColor = UIColor(hex6: 0xeeeeee)
        self.automaticallyAdjustsScrollViewInsets = false
        
        layout.itemSize = CGSize(width: self.view.frame.size.width/2-10, height:  250)
        

//        layout.minimumInteritemSpacing = 20
//        layout.headerReferenceSize = CGSize(width: 100, height: 50)         //页眉尺寸
        layout.sectionInset = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        self.view.addSubview(lostView)
        
        let button = UIButton(type: .contactAdd)
        button.frame = CGRect(x: 250, y: 400, width: 100, height: 50)

        self.view.addSubview(button)
        
        button.setTitle("丢失信息", for: UIControlState.normal)
        button.setTitle("触摸状态", for: UIControlState.highlighted)
//        button.setTitle("禁用状态", for: .disabled)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
//        let lostAPI = LostAPI()
//        lostAPI.request(success: {
//            self.lostList = lostAPI.lostList
//            self.lostView.reloadData()
//        })
        
        
        
        
    }
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return 2
    //    }
//    func numberOfItemsInSection(section: Int) -> Int{
//        
//        return 2
//    }
    func tapped(){
        let vc = PublishLostViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    
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
        

        
        
        
        let picURL = lostList[indexPath.row].picture
        
        cell.initUI(pic: URL(string: picURL)!, title: lostList[indexPath.row].title ,mark: lostList[indexPath.row].detail_type, time: lostList[indexPath.row].time, place: lostList[indexPath.row].place)
            return cell
        }
//        cell.title.text = "这里是内容：\(indexPath.row)"
        let cell = LostFoundCollectionViewCell()
        let picURL = lostList[indexPath.row].picture
        cell.initUI(pic: URL(string: picURL)!, title: lostList[indexPath.row].title ,mark: lostList[indexPath.row].detail_type, time: lostList[indexPath.row].time, place: lostList[indexPath.row].place)
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

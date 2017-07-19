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
    let TWT_URL = "http://open.twtstudio.com/"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        layout.estimatedItemSize = CGSize(width: self.view.frame.size.width/2-10, height: 270)
        //        layout.itemSize =
        layout.itemSize = CGSize(width: self.view.frame.size.width/2-10, height:  270)
        //        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)

        foundView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        
        foundView.register(LostFoundCollectionViewCell.self, forCellWithReuseIdentifier: "foundCell")
        
        foundView.delegate = self
        foundView.dataSource = self
        
        foundView.backgroundColor = UIColor(hex6: 0xeeeeee)
        
        self.view.addSubview(foundView)
        refresh()
        
        
        
    }
    
    func refresh() {
        GetFoundAPI.getFound(success: { (founds) in
            self.foundList = founds
            self.foundView.reloadData()
        
        }, failure: { error in
            print(error)
        
        })
    }
    

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let image = UIImage(named: foundList[indexPath.row].picture)
//        let imageHeight = image?.size.height
//        let imageWidth = image?.size.width
//        let width = self.view.frame.size.width/2 - 10
//        let ratio = imageWidth!/width
//        let height = imageHeight!/ratio
//        return CGSize(width: width, height: height + 4*30)
//        
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return foundList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foundCell", for: indexPath) as? LostFoundCollectionViewCell{
//        cell.title.text = "这里是内容：\(indexPath.row)"
            
            if foundList[indexPath.row].picture != ""{
            let picURL = foundList[indexPath.row].picture
            cell.initUI(pic: URL(string: TWT_URL + picURL)!, title: foundList[indexPath.row].title, mark: foundList[indexPath.row].detail_type, time: foundList[indexPath.row].time, place: foundList[indexPath.row].place)
            } else {
                let picURL = "http://open.twtstudio.com/uploads/17-07-12/945139dcd91e9ed3d5967ef7f81e18f6.jpg"
                cell.initUI(pic: URL(string: picURL)!, title: foundList[indexPath.row].title, mark: foundList[indexPath.row].detail_type, time: foundList[indexPath.row].time, place: foundList[indexPath.row].place)
            
            }
            return cell
        
        }
        let cell = LostFoundCollectionViewCell()
        if foundList[indexPath.row].picture != ""{
            let picURL = foundList[indexPath.row].picture
            cell.initUI(pic: URL(string: TWT_URL + picURL)!, title: foundList[indexPath.row].title, mark: foundList[indexPath.row].detail_type, time: foundList[indexPath.row].time, place: foundList[indexPath.row].place)
        } else {
            let picURL = "http://open.twtstudio.com/uploads/17-07-12/945139dcd91e9ed3d5967ef7f81e18f6.jpg"
            cell.initUI(pic: URL(string: picURL)!, title: foundList[indexPath.row].title, mark: foundList[indexPath.row].detail_type, time: foundList[indexPath.row].time, place: foundList[indexPath.row].place)
            
        }
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

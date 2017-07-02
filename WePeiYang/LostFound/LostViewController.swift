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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark --导航栏（Navigationbar）的配置
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00a1e9)
//            UIColor()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        
        foundView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        
        foundView.register(LostFoundCollectionViewCell.self, forCellWithReuseIdentifier: "lostFoundCell")
        
        foundView.delegate = self
        foundView.dataSource = self
        
        foundView.backgroundColor = UIColor.white
        
        layout.itemSize = CGSize(width: self.view.frame.size.width/2-30, height: 150)
        //        layout.minimumInteritemSpacing = 20
        layout.headerReferenceSize = CGSize(width: 100, height: 50)         //页眉尺寸
        layout.sectionInset = UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20)
        self.view.addSubview(foundView)
        
        
        
    }
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return 2
    //    }
    func numberOfItemsInSection(section: Int) -> Int{
        
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 10
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lostFoundCell", for: indexPath) as! LostFoundCollectionViewCell
        cell.title.text = "这里是内容：\(indexPath.row)"
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

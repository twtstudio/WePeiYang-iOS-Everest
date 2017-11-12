//
//  AllModulesViewController.swift
//  WePeiYang
//
//  Created by Allen X on 5/11/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

class AllModulesViewController: UIViewController {
    typealias ModuleData = (title: String, image: UIImage, class: AnyClass)
    fileprivate let modules: [ModuleData] = [
        (title: "GPA", image: UIImage(named: "gpaBtn")!, class: GPAViewController.self),
        (title: "课程表", image: UIImage(named: "classtableBtn")!, class: GPAViewController.self),
        (title: "失物招领", image: UIImage(named: "lfBtn")!, class: LostFoundPageViewController.self),
        (title: "自行车", image: UIImage(named: "bicycleBtn")!, class: BicycleServiceViewController.self),
        (title: "党建", image: UIImage(named: "partyBtn")!, class: PartyMainViewController.self),
        (title: "探索", image: UIImage(named: "msBtn")!, class: GPAViewController.self),
        (title: "阅读", image: UIImage(named: "readBtn")!, class: ReadViewController.self),
        (title: "黄页", image: UIImage(named: "yellowPageBtn")!, class: YellowPageMainViewController.self),
        (title: "上网", image: UIImage(named: "bicycleBtn")!, class: WLANLoginViewController.self)]
    
    var collectionView: UICollectionView!
    // The below override will not be called if current viewcontroller is controlled by a UINavigationController
    // We should do self.navigationController.navigationBar.barStyle = UIBarStyleBlack
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 3D Touch
//        if #available(iOS 9.0, *) {
//            if traitCollection.forceTouchCapability == .available {
//                registerForPreviewingWithDelegate(self as! UIViewControllerPreviewingDelegate, sourceView: self.collectionView!)
//            }
//        }
        // TODO: barColor
        self.view.backgroundColor = Metadata.Color.GlobalViewBackgroundColor

        // set layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.bounds.width/4, height: 104)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: self.view.width, height: 100)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        
        // register collection cell
        collectionView.register(ModuleCollectionViewCell.self, forCellWithReuseIdentifier: "ModuleCollectionViewCell")
        
        // register header view
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionElementKindSectionHeader")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
}

// Mark: UICollectionViewDataSource
extension AllModulesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModuleCollectionViewCell", for: indexPath) as? ModuleCollectionViewCell {
            let data = modules[indexPath.row]
            cell.titleLabel.text = data.title
            cell.imageView.image = data.image
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionElementKindSectionHeader", for: indexPath)
            let label = UILabel(text: "更多功能")
            label.font = UIFont.systemFont(ofSize: 35, weight: UIFontWeightHeavy)
            label.x = 15
            label.y = 25
            label.sizeToFit()
            header.addSubview(label)
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // instantiate a view controller by its class
        if let vc = (modules[indexPath.row].class as? UIViewController.Type)?.init() {
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


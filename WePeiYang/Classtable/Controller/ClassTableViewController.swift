//
//  ClassTableViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit


class ClassTableViewController: UIViewController {

    struct Constant {
        static let dayCount: CGFloat = 7
        static let bounds = UIScreen.main.bounds
        static let numberViewWidth: CGFloat = 30
        static var weekViewWidth: CGFloat {
            return bounds.width - numberViewWidth
        }
        static var weekViewHeight: CGFloat {
            return 30
        }
        static var cellWidth: CGFloat {
            return weekViewWidth / dayCount
        }
        static var cellHeight: CGFloat {
            return 60
        }
        static var dayViewHeight: CGFloat {
            return cellHeight * 12
        }
//        static var
    }
    
//    var classTableView: UIScrollView!
    var classTableView: UICollectionView!
    fileprivate var classNumberView: UIScrollView!
    private var weekdayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        weekdayView = UIView(frame: CGRect(x: Constant.numberViewWidth, y: 0, width: Constant.weekViewWidth, height: Constant.weekViewHeight))
        classNumberView = UIScrollView(frame: CGRect(x: 0, y: Constant.weekViewHeight, width: Constant.numberViewWidth, height: view.height))
        classNumberView.contentSize = CGSize(width: Constant.numberViewWidth, height: Constant.dayViewHeight)
        for i in 0..<12 {
            let label = UILabel(frame: CGRect(x: 0, y: CGFloat(i)*Constant.cellHeight, width: Constant.numberViewWidth, height: Constant.cellHeight))
            label.text = "\(i+1)"
            classNumberView.addSubview(label)
        }
//        classNumberView.delegate = self
        
        for i in 0..<7 {
            let label = UILabel(frame: CGRect(x: CGFloat(i)*Constant.cellWidth, y: 0, width: Constant.cellWidth, height: Constant.weekViewHeight))
            label.text = "周 \(i+1) "
            label.textAlignment = .center
            weekdayView.addSubview(label)
        }

        // TODO: Fix height
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        classTableView = UIScrollView(frame: CGRect(x: Constant.numberViewWidth, y: Constant.weekViewWidth, width: Constant.numberViewWidth, height: view.height))
        layout.itemSize = CGSize(width: Constant.cellWidth, height: Constant.cellHeight*2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
//        layout.footerReferenceSize = CGSize(width: self.view.width, height: 80)
        
        classTableView = UICollectionView(frame: CGRect(x: Constant.numberViewWidth, y: Constant.weekViewHeight, width: Constant.weekViewWidth, height: view.height), collectionViewLayout: layout)
        classTableView.contentSize = CGSize(width: Constant.weekViewWidth, height: Constant.dayViewHeight)
//        classTableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
        classTableView.backgroundColor = .white
        classTableView.register(ClassTableCell.self, forCellWithReuseIdentifier: "ClassTableCell")
//        classTableView.delegate = self
        classTableView.dataSource = self
        // 否则会显示不全
        classTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        (classTableView as UIScrollView).delegate = self

        
        self.view.addSubview(weekdayView)
        self.view.addSubview(classNumberView)
        self.view.addSubview(classTableView)
        
        self.load()
    }
    
    func load() {
        ClasstableDataManager.getClassTable(success: { table in
            print(table)
        }, failure: { errorMessage in
            print(errorMessage)
        })
    }
    
}

extension ClassTableViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassTableCell", for: indexPath) as! ClassTableCell
        cell.classLabel.text = "\(indexPath)"
        cell.backgroundColor = .red
        if arc4random() % 3 == 0 {
//            cell.backgroundColor = .white
            cell.alpha = 0.0
        }
        return cell
    }
}

extension ClassTableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === classTableView {
            classNumberView.contentOffset = classTableView.contentOffset
        }
    }
}

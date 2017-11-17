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
            return weekViewWidth/dayCount
        }
        static var cellHeight: CGFloat {
            return 30
        }
//        static var
    }
    
//    var classTableView: UIScrollView!
    var classTableView: UIScrollView!
    private var classNumberView: UIView!
    private var weekdayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        weekdayView = UIView(frame: CGRect(x: Constant.numberViewWidth, y: 0, width: Constant.weekViewWidth, height: Constant.weekViewHeight))
        classNumberView = UIView(frame: CGRect(x: 0, y: Constant.weekViewHeight, width: Constant.cellWidth, height: view.height))
        for i in 0..<12 {
            let label = UILabel(frame: CGRect(x: 0, y: CGFloat(i)*Constant.weekViewHeight, width: Constant.numberViewWidth, height: Constant.weekViewHeight))
            label.text = "\(i+1)"
            classNumberView.addSubview(label)
        }
        for i in 0..<7 {
            let label = UILabel(frame: CGRect(x: CGFloat(i)*Constant.cellWidth, y: 0, width: Constant.cellWidth, height: Constant.weekViewHeight))
            label.text = "\(i+1)"
            weekdayView.addSubview(label)
        }

        // TODO: Fix height
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
        classTableView = UIScrollView(frame: CGRect(x: Constant.numberViewWidth, y: Constant.weekViewWidth, width: Constant.numberViewWidth, height: view.height))
//        classTableView = UICollectionView(frame: CGRect(x: Constant.numberViewWidth, y: Constant.weekViewWidth, width: Constant.numberViewWidth, height: view.height), collectionViewLayout: layout)
        
        self.view.addSubview(weekdayView)
        self.view.addSubview(classNumberView)
        self.view.addSubview(classTableView)
    }
}

//
//  ReviewListViewController.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/23.
//  Copyright © 2016年 Halcao. All rights reserved.
//

import UIKit

class ReviewListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reviewArr: [Review] = []
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) , style: .grouped)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let titleLabel = UILabel(text: "我的评论", fontSize: 17)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        self.navigationItem.titleView = titleLabel;
        
        //NavigationBar 的背景，使用了View
        self.navigationController?.navigationBar.alpha = 0
//        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))
        
        bgView.backgroundColor = UIColor(colorLiteralRed: 234.0/255.0, green: 74.0/255.0, blue: 70/255.0, alpha: 1.0)
        self.view.addSubview(bgView)
        
        //        //改变 statusBar 颜色
        self.navigationController?.navigationBar.barStyle = .black
//        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        if self.reviewArr.count == 0 {
            let label = UILabel(text: "你还没有点评哦，去评论吧！")
            label.sizeToFit()
            self.view.addSubview(label)
            label.snp.makeConstraints { make in
                make.center.equalTo(self.view.snp.center)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add TableView
        view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none

    }
    
    // Mark: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ReviewCell(model: self.reviewArr[indexPath.row])
        if indexPath.row == reviewArr.count - 1 {
            cell.separator.removeFromSuperview()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookDetailViewController(bookID: "\(reviewArr[indexPath.row].bookID)")
        self.navigationController?.pushViewController(vc, animated: true)
        print("Push Detail View Controller, bookID: \(reviewArr[indexPath.row].bookID)")
        self.tableView.deselectRow(at: indexPath, animated: true)
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

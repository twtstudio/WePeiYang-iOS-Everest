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
    let tableView = UITableView(frame: CGRect.zero , style: .grouped)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.reviewArr.count == 0 {
            let label = UILabel(text: "你还没有点评哦，去评论吧！")
            label.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
            label.font = UIFont.boldSystemFont(ofSize: 19)
            label.sizeToFit()
            self.view.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-40)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add TableView
        self.title = "我的评论"
        view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
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
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = BookDetailViewController(bookID: "\(reviewArr[indexPath.row].bookID)")
        self.navigationController?.pushViewController(vc, animated: true)
        print("Push Detail View Controller, bookID: \(reviewArr[indexPath.row].bookID)")
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        self.navigationController?.navigationBar.shadowImage = nil
    }
    
}

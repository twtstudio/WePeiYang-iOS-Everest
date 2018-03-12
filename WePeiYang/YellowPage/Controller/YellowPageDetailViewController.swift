//
//  YellowPageDetailViewController.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/23.
//  Modified by Halcao on 2017/7/18.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit
import AddressBook

class YellowPageDetailViewController: UIViewController {
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
    
    var models = [ClientItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel(text: self.navigationItem.title!)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        
        self.navigationController!.navigationBar.tintColor = UIColor.white
        // FIXME: 改变 statusBar 颜色
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }

//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        super.viewWillAppear(animated)
//    }

//    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        super.viewDidDisappear(animated)
//    }
}

extension YellowPageDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // FIXME: reuse
        let cell = YellowPageCell(with: .detailed, model: models[indexPath.row])
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:)))
        cell.phoneLabel.addGestureRecognizer(tapRecognizer)
        return cell
    }
}

extension YellowPageDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}

extension YellowPageDetailViewController {
    @objc func cellTapped(sender: UILabel) {
        let alertVC = UIAlertController(title: "详情", message: "想要做什么？", preferredStyle: .actionSheet)
        let copyAction = UIAlertAction(title: "复制到剪切板", style: .default) { action in
            if let superview = sender.superview as? YellowPageCell {
                superview.longPressed()
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
        }
        alertVC.addAction(copyAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

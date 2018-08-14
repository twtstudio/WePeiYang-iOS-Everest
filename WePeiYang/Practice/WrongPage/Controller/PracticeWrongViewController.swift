//
//  PracticeWrongViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/8/2.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class PracticeWrongViewController: UIViewController {
    
    let practiceWrongTableView = UITableView(frame: CGRect(), style: .grouped)
    
    let practiceWrongNumber = 5 // 从 exam.twtstudio.com/api/student 的 error_number 获取
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        practiceWrongTableView.frame = self.view.bounds
        practiceWrongTableView.delegate = self
        practiceWrongTableView.dataSource = self
        self.view.addSubview(practiceWrongTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /* 导航栏 */
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .practiceBlue), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        /* 标题 */
        let titleLabel = UILabel(text: "我的错题")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
}

/* 表单视图数据 */
extension PracticeWrongViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return practiceWrongNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

/* 表单视图代理 */
extension PracticeWrongViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
}
